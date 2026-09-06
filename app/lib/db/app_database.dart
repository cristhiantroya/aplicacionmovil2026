import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// Esquema LOCAL, no clon del servidor: solo los campos que la UI
// muestra + 3 campos de control cliente (actualizadoEn, pendienteEnvio,
// clienteId para idempotencia).
class ProductosLocal extends Table {
  
  IntColumn get idProducto => integer().nullable()(); // null si aún no confirma el server
  TextColumn get clienteId => text()(); // UUID generado en cliente (idempotencia)
  TextColumn get nombre => text()();
  RealColumn get precio => real()();
  TextColumn get estadoUso => text()();
  TextColumn get categoria => text().nullable()();
  TextColumn get ubicacion => text().nullable()();
  DateTimeColumn get actualizadoEn => dateTime()(); // marca del SERVIDOR
  BoolColumn get pendienteEnvio => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {clienteId};
}

class OperacionesPendientes extends Table {
  TextColumn get clienteId => text()(); // mismo id de idempotencia
  TextColumn get tipo => text()(); // 'crear_producto'
  TextColumn get payloadJson => text()();
  IntColumn get intentos => integer().withDefault(const Constant(0))();
  DateTimeColumn get creadoEn => dateTime()();

  @override
  Set<Column> get primaryKey => {clienteId};
}

@DriftDatabase(tables: [ProductosLocal, OperacionesPendientes])
class AppDatabase extends _$AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();
  AppDatabase._internal() : super(_openConnection());
  factory AppDatabase() => instance;

  @override
  int get schemaVersion => 1;

  // Elimina TODO el almacén local (cierre de sesión / datos personales)
  Future<void> wipeAll() async {
    await delete(productosLocal).go();
    await delete(operacionesPendientes).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'comprasegura.sqlite'));
    return NativeDatabase(file);
  });
}