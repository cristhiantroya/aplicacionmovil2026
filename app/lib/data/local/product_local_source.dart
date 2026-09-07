import '../../db/app_database.dart';

class ProductLocalSource {
  final AppDatabase _db;

  ProductLocalSource(this._db);

  Future<List<ProductosLocalData>> getProducts() async {
    return _db.select(_db.productosLocal).get();
  }

  Future<void> clearSyncedProducts() async {
    await (_db.delete(
      _db.productosLocal,
    )..where(
        (t) => t.pendienteEnvio.equals(false),
      ))
        .go();
  }

  Future<void> saveProduct(
    ProductosLocalCompanion product,
  ) async {
    await _db
        .into(_db.productosLocal)
        .insertOnConflictUpdate(product);
  }

  Future<void> saveProducts(
    List<ProductosLocalCompanion> products,
  ) async {
    for (final product in products) {
      await saveProduct(product);
    }
  }
}