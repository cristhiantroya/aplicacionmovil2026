import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/api_service.dart';
import '../services/point_service.dart';
import '../models/point_model.dart';
import 'package:go_router/go_router.dart';

class PointsScreen extends StatefulWidget {
  final bool isSelecting;
  final String? ciudad;

  const PointsScreen({super.key, this.isSelecting = false, this.ciudad});

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  List<SafePoint> _points = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  Future<void> _loadPoints() async {
    try {
      final apiService = ApiService();
      final pointService = PointService(apiService);

      // Si se especificó una ciudad, filtrar por ella
      if (widget.ciudad != null && widget.ciudad!.isNotEmpty) {
        _points = await pointService.getSafePoints(ciudad: widget.ciudad);
      } else {
        _points = await pointService.getSafePoints();
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Calcula el centro del mapa como el promedio de todas las coordenadas
  LatLng _calculateCenter() {
    if (_points.isEmpty) {
      return const LatLng(-0.22985, -78.52495); // Quito default
    }

    double latSum = 0;
    double lngSum = 0;
    for (final p in _points) {
      latSum += p.latitud;
      lngSum += p.longitud;
    }
    return LatLng(latSum / _points.length, lngSum / _points.length);
  }

  void _showPointDetail(SafePoint point) async {
    if (!widget.isSelecting) return;

    final selected = await showModalBottomSheet<SafePoint>(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              point.nombre,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(child: Text(point.direccion)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_city, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(point.ciudad),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(ctx).pop(point),
                icon: const Icon(Icons.check_circle),
                label: const Text('Seleccionar este punto'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (selected != null && mounted) {
  context.pop(selected);
}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isSelecting ? 'Seleccionar Punto Seguro' : 'Puntos Seguros',
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadPoints,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : _points.isEmpty
          ?
            // Mensaje bloqueante cuando no hay puntos en la ciudad
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_off,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.ciudad != null
                          ? 'No hay puntos seguros disponibles en ${widget.ciudad}.'
                          : 'No hay puntos seguros disponibles.',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No es posible iniciar esta transacción por el momento.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    if (!widget.isSelecting) ...[
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loadPoints,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ],
                ),
              ),
            )
          :
            // Mapa con puntos seguros
            FlutterMap(
              options: MapOptions(
                initialCenter: _calculateCenter(),
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.comprasegura.app',
                ),
                MarkerLayer(
                  markers: _points.map((point) {
                    return Marker(
                      point: LatLng(point.latitud, point.longitud),
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () => _showPointDetail(point),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 36,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
    );
  }
}
