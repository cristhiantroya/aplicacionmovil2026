import 'package:drift/drift.dart';

import '../../db/app_database.dart';
import '../../errors/app_exception.dart';
import '../../models/product_model.dart';
import '../../models/product_dto.dart';
import '../local/product_local_source.dart';
import '../remote/product_remote_source.dart';

class ProductRepository {
  final ProductRemoteSource _remoteSource;
  final ProductLocalSource _localSource;

  ProductRepository(this._remoteSource, this._localSource);

  Future<List<Product>> getProducts() async {
    try {
      final remoteProducts = await _remoteSource.getProducts();

      await _localSource.clearSyncedProducts();

      final localProducts = remoteProducts.map(_dtoToLocal).toList();

      await _localSource.saveProducts(localProducts);

      return remoteProducts.map(_dtoToDomain).toList();
    } on NetworkException {
      final cached = await _localSource.getProducts();

      return cached.map(_localToDomain).toList();
    }
  }

  ProductosLocalCompanion _dtoToLocal(ProductDto dto) {
    return ProductosLocalCompanion.insert(
      clienteId: 'srv-${dto.idProducto}',
      idProducto: Value(dto.idProducto),
      nombre: dto.nombre,
      precio: dto.precio is String
          ? double.parse(dto.precio)
          : (dto.precio as num).toDouble(),
      estadoUso: dto.estadoUso,
      categoria: Value(dto.categoria),
      ubicacion: Value(dto.ubicacion),
      actualizadoEn: DateTime.now(),
    );
  }

  Product _dtoToDomain(ProductDto dto) {
    return Product(
      idProducto: dto.idProducto,
      idUsuario: dto.idUsuario,
      nombre: dto.nombre,
      descripcion: dto.descripcion,
      precio: dto.precio is String
          ? double.parse(dto.precio)
          : (dto.precio as num).toDouble(),
      estadoUso: dto.estadoUso,
      estadoDisponibilidad: dto.estadoDisponibilidad,
      categoria: dto.categoria,
      ubicacion: dto.ubicacion,
      creadoEn: dto.creadoEn,
      imagenes: dto.imagenes
          .map(
            (i) => ProductImage(
              idImagen: i.idImagen,
              idProducto: i.idProducto,
              url: i.url,
              estado: i.estado,
              creadoEn: i.creadoEn,
            ),
          )
          .toList(),
    );
  }

  Product _localToDomain(ProductosLocalData p) {
    return Product(
      idProducto: p.idProducto ?? 0,
      idUsuario: 0,
      nombre: p.nombre,
      descripcion: 'Producto almacenado localmente',
      precio: p.precio,
      estadoUso: p.estadoUso,
      estadoDisponibilidad: p.pendienteEnvio ? 'pendiente' : 'disponible',
      categoria: p.categoria,
      ubicacion: p.ubicacion,
      creadoEn: p.actualizadoEn,
      imagenes: const [],
    );
  }
}
