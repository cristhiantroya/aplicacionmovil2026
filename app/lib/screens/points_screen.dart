import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/point_service.dart';
import '../models/point_model.dart';

class PointsScreen extends StatefulWidget {
  final bool isSelecting;

  const PointsScreen({super.key, this.isSelecting = false});

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
      _points = await pointService.getSafePoints();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
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
          ? const Center(child: Text('No hay puntos seguros disponibles'))
          : RefreshIndicator(
              onRefresh: _loadPoints,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _points.length,
                itemBuilder: (context, index) {
                  final point = _points[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(
                        point.nombre,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text(point.direccion), Text(point.ciudad)],
                      ),
                      trailing: const Icon(Icons.location_on),
                      onTap: widget.isSelecting
                          ? () => Navigator.of(context).pop(point)
                          : null,
                    ),
                  );
                },
              ),
            ),
    );
  }
}
