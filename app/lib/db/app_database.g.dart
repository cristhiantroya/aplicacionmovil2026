// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductosLocalTable extends ProductosLocal
    with TableInfo<$ProductosLocalTable, ProductosLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductosLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idProductoMeta = const VerificationMeta(
    'idProducto',
  );
  @override
  late final GeneratedColumn<int> idProducto = GeneratedColumn<int>(
    'id_producto',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<String> clienteId = GeneratedColumn<String>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioMeta = const VerificationMeta('precio');
  @override
  late final GeneratedColumn<double> precio = GeneratedColumn<double>(
    'precio',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estadoUsoMeta = const VerificationMeta(
    'estadoUso',
  );
  @override
  late final GeneratedColumn<String> estadoUso = GeneratedColumn<String>(
    'estado_uso',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
    'categoria',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ubicacionMeta = const VerificationMeta(
    'ubicacion',
  );
  @override
  late final GeneratedColumn<String> ubicacion = GeneratedColumn<String>(
    'ubicacion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> actualizadoEn =
      GeneratedColumn<DateTime>(
        'actualizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _pendienteEnvioMeta = const VerificationMeta(
    'pendienteEnvio',
  );
  @override
  late final GeneratedColumn<bool> pendienteEnvio = GeneratedColumn<bool>(
    'pendiente_envio',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pendiente_envio" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    idProducto,
    clienteId,
    nombre,
    precio,
    estadoUso,
    categoria,
    ubicacion,
    actualizadoEn,
    pendienteEnvio,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'productos_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductosLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_producto')) {
      context.handle(
        _idProductoMeta,
        idProducto.isAcceptableOrUnknown(data['id_producto']!, _idProductoMeta),
      );
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('precio')) {
      context.handle(
        _precioMeta,
        precio.isAcceptableOrUnknown(data['precio']!, _precioMeta),
      );
    } else if (isInserting) {
      context.missing(_precioMeta);
    }
    if (data.containsKey('estado_uso')) {
      context.handle(
        _estadoUsoMeta,
        estadoUso.isAcceptableOrUnknown(data['estado_uso']!, _estadoUsoMeta),
      );
    } else if (isInserting) {
      context.missing(_estadoUsoMeta);
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    }
    if (data.containsKey('ubicacion')) {
      context.handle(
        _ubicacionMeta,
        ubicacion.isAcceptableOrUnknown(data['ubicacion']!, _ubicacionMeta),
      );
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actualizadoEnMeta);
    }
    if (data.containsKey('pendiente_envio')) {
      context.handle(
        _pendienteEnvioMeta,
        pendienteEnvio.isAcceptableOrUnknown(
          data['pendiente_envio']!,
          _pendienteEnvioMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clienteId};
  @override
  ProductosLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductosLocalData(
      idProducto: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id_producto'],
      ),
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      precio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio'],
      )!,
      estadoUso: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado_uso'],
      )!,
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria'],
      ),
      ubicacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ubicacion'],
      ),
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actualizado_en'],
      )!,
      pendienteEnvio: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pendiente_envio'],
      )!,
    );
  }

  @override
  $ProductosLocalTable createAlias(String alias) {
    return $ProductosLocalTable(attachedDatabase, alias);
  }
}

class ProductosLocalData extends DataClass
    implements Insertable<ProductosLocalData> {
  final int? idProducto;
  final String clienteId;
  final String nombre;
  final double precio;
  final String estadoUso;
  final String? categoria;
  final String? ubicacion;
  final DateTime actualizadoEn;
  final bool pendienteEnvio;
  const ProductosLocalData({
    this.idProducto,
    required this.clienteId,
    required this.nombre,
    required this.precio,
    required this.estadoUso,
    this.categoria,
    this.ubicacion,
    required this.actualizadoEn,
    required this.pendienteEnvio,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || idProducto != null) {
      map['id_producto'] = Variable<int>(idProducto);
    }
    map['cliente_id'] = Variable<String>(clienteId);
    map['nombre'] = Variable<String>(nombre);
    map['precio'] = Variable<double>(precio);
    map['estado_uso'] = Variable<String>(estadoUso);
    if (!nullToAbsent || categoria != null) {
      map['categoria'] = Variable<String>(categoria);
    }
    if (!nullToAbsent || ubicacion != null) {
      map['ubicacion'] = Variable<String>(ubicacion);
    }
    map['actualizado_en'] = Variable<DateTime>(actualizadoEn);
    map['pendiente_envio'] = Variable<bool>(pendienteEnvio);
    return map;
  }

  ProductosLocalCompanion toCompanion(bool nullToAbsent) {
    return ProductosLocalCompanion(
      idProducto: idProducto == null && nullToAbsent
          ? const Value.absent()
          : Value(idProducto),
      clienteId: Value(clienteId),
      nombre: Value(nombre),
      precio: Value(precio),
      estadoUso: Value(estadoUso),
      categoria: categoria == null && nullToAbsent
          ? const Value.absent()
          : Value(categoria),
      ubicacion: ubicacion == null && nullToAbsent
          ? const Value.absent()
          : Value(ubicacion),
      actualizadoEn: Value(actualizadoEn),
      pendienteEnvio: Value(pendienteEnvio),
    );
  }

  factory ProductosLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductosLocalData(
      idProducto: serializer.fromJson<int?>(json['idProducto']),
      clienteId: serializer.fromJson<String>(json['clienteId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      precio: serializer.fromJson<double>(json['precio']),
      estadoUso: serializer.fromJson<String>(json['estadoUso']),
      categoria: serializer.fromJson<String?>(json['categoria']),
      ubicacion: serializer.fromJson<String?>(json['ubicacion']),
      actualizadoEn: serializer.fromJson<DateTime>(json['actualizadoEn']),
      pendienteEnvio: serializer.fromJson<bool>(json['pendienteEnvio']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idProducto': serializer.toJson<int?>(idProducto),
      'clienteId': serializer.toJson<String>(clienteId),
      'nombre': serializer.toJson<String>(nombre),
      'precio': serializer.toJson<double>(precio),
      'estadoUso': serializer.toJson<String>(estadoUso),
      'categoria': serializer.toJson<String?>(categoria),
      'ubicacion': serializer.toJson<String?>(ubicacion),
      'actualizadoEn': serializer.toJson<DateTime>(actualizadoEn),
      'pendienteEnvio': serializer.toJson<bool>(pendienteEnvio),
    };
  }

  ProductosLocalData copyWith({
    Value<int?> idProducto = const Value.absent(),
    String? clienteId,
    String? nombre,
    double? precio,
    String? estadoUso,
    Value<String?> categoria = const Value.absent(),
    Value<String?> ubicacion = const Value.absent(),
    DateTime? actualizadoEn,
    bool? pendienteEnvio,
  }) => ProductosLocalData(
    idProducto: idProducto.present ? idProducto.value : this.idProducto,
    clienteId: clienteId ?? this.clienteId,
    nombre: nombre ?? this.nombre,
    precio: precio ?? this.precio,
    estadoUso: estadoUso ?? this.estadoUso,
    categoria: categoria.present ? categoria.value : this.categoria,
    ubicacion: ubicacion.present ? ubicacion.value : this.ubicacion,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    pendienteEnvio: pendienteEnvio ?? this.pendienteEnvio,
  );
  ProductosLocalData copyWithCompanion(ProductosLocalCompanion data) {
    return ProductosLocalData(
      idProducto: data.idProducto.present
          ? data.idProducto.value
          : this.idProducto,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      precio: data.precio.present ? data.precio.value : this.precio,
      estadoUso: data.estadoUso.present ? data.estadoUso.value : this.estadoUso,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      ubicacion: data.ubicacion.present ? data.ubicacion.value : this.ubicacion,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
      pendienteEnvio: data.pendienteEnvio.present
          ? data.pendienteEnvio.value
          : this.pendienteEnvio,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductosLocalData(')
          ..write('idProducto: $idProducto, ')
          ..write('clienteId: $clienteId, ')
          ..write('nombre: $nombre, ')
          ..write('precio: $precio, ')
          ..write('estadoUso: $estadoUso, ')
          ..write('categoria: $categoria, ')
          ..write('ubicacion: $ubicacion, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('pendienteEnvio: $pendienteEnvio')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    idProducto,
    clienteId,
    nombre,
    precio,
    estadoUso,
    categoria,
    ubicacion,
    actualizadoEn,
    pendienteEnvio,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductosLocalData &&
          other.idProducto == this.idProducto &&
          other.clienteId == this.clienteId &&
          other.nombre == this.nombre &&
          other.precio == this.precio &&
          other.estadoUso == this.estadoUso &&
          other.categoria == this.categoria &&
          other.ubicacion == this.ubicacion &&
          other.actualizadoEn == this.actualizadoEn &&
          other.pendienteEnvio == this.pendienteEnvio);
}

class ProductosLocalCompanion extends UpdateCompanion<ProductosLocalData> {
  final Value<int?> idProducto;
  final Value<String> clienteId;
  final Value<String> nombre;
  final Value<double> precio;
  final Value<String> estadoUso;
  final Value<String?> categoria;
  final Value<String?> ubicacion;
  final Value<DateTime> actualizadoEn;
  final Value<bool> pendienteEnvio;
  final Value<int> rowid;
  const ProductosLocalCompanion({
    this.idProducto = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.precio = const Value.absent(),
    this.estadoUso = const Value.absent(),
    this.categoria = const Value.absent(),
    this.ubicacion = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
    this.pendienteEnvio = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductosLocalCompanion.insert({
    this.idProducto = const Value.absent(),
    required String clienteId,
    required String nombre,
    required double precio,
    required String estadoUso,
    this.categoria = const Value.absent(),
    this.ubicacion = const Value.absent(),
    required DateTime actualizadoEn,
    this.pendienteEnvio = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : clienteId = Value(clienteId),
       nombre = Value(nombre),
       precio = Value(precio),
       estadoUso = Value(estadoUso),
       actualizadoEn = Value(actualizadoEn);
  static Insertable<ProductosLocalData> custom({
    Expression<int>? idProducto,
    Expression<String>? clienteId,
    Expression<String>? nombre,
    Expression<double>? precio,
    Expression<String>? estadoUso,
    Expression<String>? categoria,
    Expression<String>? ubicacion,
    Expression<DateTime>? actualizadoEn,
    Expression<bool>? pendienteEnvio,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (idProducto != null) 'id_producto': idProducto,
      if (clienteId != null) 'cliente_id': clienteId,
      if (nombre != null) 'nombre': nombre,
      if (precio != null) 'precio': precio,
      if (estadoUso != null) 'estado_uso': estadoUso,
      if (categoria != null) 'categoria': categoria,
      if (ubicacion != null) 'ubicacion': ubicacion,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
      if (pendienteEnvio != null) 'pendiente_envio': pendienteEnvio,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductosLocalCompanion copyWith({
    Value<int?>? idProducto,
    Value<String>? clienteId,
    Value<String>? nombre,
    Value<double>? precio,
    Value<String>? estadoUso,
    Value<String?>? categoria,
    Value<String?>? ubicacion,
    Value<DateTime>? actualizadoEn,
    Value<bool>? pendienteEnvio,
    Value<int>? rowid,
  }) {
    return ProductosLocalCompanion(
      idProducto: idProducto ?? this.idProducto,
      clienteId: clienteId ?? this.clienteId,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      estadoUso: estadoUso ?? this.estadoUso,
      categoria: categoria ?? this.categoria,
      ubicacion: ubicacion ?? this.ubicacion,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
      pendienteEnvio: pendienteEnvio ?? this.pendienteEnvio,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idProducto.present) {
      map['id_producto'] = Variable<int>(idProducto.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<String>(clienteId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (precio.present) {
      map['precio'] = Variable<double>(precio.value);
    }
    if (estadoUso.present) {
      map['estado_uso'] = Variable<String>(estadoUso.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (ubicacion.present) {
      map['ubicacion'] = Variable<String>(ubicacion.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<DateTime>(actualizadoEn.value);
    }
    if (pendienteEnvio.present) {
      map['pendiente_envio'] = Variable<bool>(pendienteEnvio.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductosLocalCompanion(')
          ..write('idProducto: $idProducto, ')
          ..write('clienteId: $clienteId, ')
          ..write('nombre: $nombre, ')
          ..write('precio: $precio, ')
          ..write('estadoUso: $estadoUso, ')
          ..write('categoria: $categoria, ')
          ..write('ubicacion: $ubicacion, ')
          ..write('actualizadoEn: $actualizadoEn, ')
          ..write('pendienteEnvio: $pendienteEnvio, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OperacionesPendientesTable extends OperacionesPendientes
    with TableInfo<$OperacionesPendientesTable, OperacionesPendiente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OperacionesPendientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<String> clienteId = GeneratedColumn<String>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intentosMeta = const VerificationMeta(
    'intentos',
  );
  @override
  late final GeneratedColumn<int> intentos = GeneratedColumn<int>(
    'intentos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    clienteId,
    tipo,
    payloadJson,
    intentos,
    creadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'operaciones_pendientes';
  @override
  VerificationContext validateIntegrity(
    Insertable<OperacionesPendiente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('intentos')) {
      context.handle(
        _intentosMeta,
        intentos.isAcceptableOrUnknown(data['intentos']!, _intentosMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    } else if (isInserting) {
      context.missing(_creadoEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clienteId};
  @override
  OperacionesPendiente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OperacionesPendiente(
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente_id'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      intentos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intentos'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
    );
  }

  @override
  $OperacionesPendientesTable createAlias(String alias) {
    return $OperacionesPendientesTable(attachedDatabase, alias);
  }
}

class OperacionesPendiente extends DataClass
    implements Insertable<OperacionesPendiente> {
  final String clienteId;
  final String tipo;
  final String payloadJson;
  final int intentos;
  final DateTime creadoEn;
  const OperacionesPendiente({
    required this.clienteId,
    required this.tipo,
    required this.payloadJson,
    required this.intentos,
    required this.creadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cliente_id'] = Variable<String>(clienteId);
    map['tipo'] = Variable<String>(tipo);
    map['payload_json'] = Variable<String>(payloadJson);
    map['intentos'] = Variable<int>(intentos);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    return map;
  }

  OperacionesPendientesCompanion toCompanion(bool nullToAbsent) {
    return OperacionesPendientesCompanion(
      clienteId: Value(clienteId),
      tipo: Value(tipo),
      payloadJson: Value(payloadJson),
      intentos: Value(intentos),
      creadoEn: Value(creadoEn),
    );
  }

  factory OperacionesPendiente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OperacionesPendiente(
      clienteId: serializer.fromJson<String>(json['clienteId']),
      tipo: serializer.fromJson<String>(json['tipo']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      intentos: serializer.fromJson<int>(json['intentos']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clienteId': serializer.toJson<String>(clienteId),
      'tipo': serializer.toJson<String>(tipo),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'intentos': serializer.toJson<int>(intentos),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
    };
  }

  OperacionesPendiente copyWith({
    String? clienteId,
    String? tipo,
    String? payloadJson,
    int? intentos,
    DateTime? creadoEn,
  }) => OperacionesPendiente(
    clienteId: clienteId ?? this.clienteId,
    tipo: tipo ?? this.tipo,
    payloadJson: payloadJson ?? this.payloadJson,
    intentos: intentos ?? this.intentos,
    creadoEn: creadoEn ?? this.creadoEn,
  );
  OperacionesPendiente copyWithCompanion(OperacionesPendientesCompanion data) {
    return OperacionesPendiente(
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      intentos: data.intentos.present ? data.intentos.value : this.intentos,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OperacionesPendiente(')
          ..write('clienteId: $clienteId, ')
          ..write('tipo: $tipo, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('intentos: $intentos, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(clienteId, tipo, payloadJson, intentos, creadoEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OperacionesPendiente &&
          other.clienteId == this.clienteId &&
          other.tipo == this.tipo &&
          other.payloadJson == this.payloadJson &&
          other.intentos == this.intentos &&
          other.creadoEn == this.creadoEn);
}

class OperacionesPendientesCompanion
    extends UpdateCompanion<OperacionesPendiente> {
  final Value<String> clienteId;
  final Value<String> tipo;
  final Value<String> payloadJson;
  final Value<int> intentos;
  final Value<DateTime> creadoEn;
  final Value<int> rowid;
  const OperacionesPendientesCompanion({
    this.clienteId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.intentos = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OperacionesPendientesCompanion.insert({
    required String clienteId,
    required String tipo,
    required String payloadJson,
    this.intentos = const Value.absent(),
    required DateTime creadoEn,
    this.rowid = const Value.absent(),
  }) : clienteId = Value(clienteId),
       tipo = Value(tipo),
       payloadJson = Value(payloadJson),
       creadoEn = Value(creadoEn);
  static Insertable<OperacionesPendiente> custom({
    Expression<String>? clienteId,
    Expression<String>? tipo,
    Expression<String>? payloadJson,
    Expression<int>? intentos,
    Expression<DateTime>? creadoEn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clienteId != null) 'cliente_id': clienteId,
      if (tipo != null) 'tipo': tipo,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (intentos != null) 'intentos': intentos,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OperacionesPendientesCompanion copyWith({
    Value<String>? clienteId,
    Value<String>? tipo,
    Value<String>? payloadJson,
    Value<int>? intentos,
    Value<DateTime>? creadoEn,
    Value<int>? rowid,
  }) {
    return OperacionesPendientesCompanion(
      clienteId: clienteId ?? this.clienteId,
      tipo: tipo ?? this.tipo,
      payloadJson: payloadJson ?? this.payloadJson,
      intentos: intentos ?? this.intentos,
      creadoEn: creadoEn ?? this.creadoEn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clienteId.present) {
      map['cliente_id'] = Variable<String>(clienteId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (intentos.present) {
      map['intentos'] = Variable<int>(intentos.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OperacionesPendientesCompanion(')
          ..write('clienteId: $clienteId, ')
          ..write('tipo: $tipo, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('intentos: $intentos, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductosLocalTable productosLocal = $ProductosLocalTable(this);
  late final $OperacionesPendientesTable operacionesPendientes =
      $OperacionesPendientesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    productosLocal,
    operacionesPendientes,
  ];
}

typedef $$ProductosLocalTableCreateCompanionBuilder =
    ProductosLocalCompanion Function({
      Value<int?> idProducto,
      required String clienteId,
      required String nombre,
      required double precio,
      required String estadoUso,
      Value<String?> categoria,
      Value<String?> ubicacion,
      required DateTime actualizadoEn,
      Value<bool> pendienteEnvio,
      Value<int> rowid,
    });
typedef $$ProductosLocalTableUpdateCompanionBuilder =
    ProductosLocalCompanion Function({
      Value<int?> idProducto,
      Value<String> clienteId,
      Value<String> nombre,
      Value<double> precio,
      Value<String> estadoUso,
      Value<String?> categoria,
      Value<String?> ubicacion,
      Value<DateTime> actualizadoEn,
      Value<bool> pendienteEnvio,
      Value<int> rowid,
    });

class $$ProductosLocalTableFilterComposer
    extends Composer<_$AppDatabase, $ProductosLocalTable> {
  $$ProductosLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idProducto => $composableBuilder(
    column: $table.idProducto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clienteId => $composableBuilder(
    column: $table.clienteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precio => $composableBuilder(
    column: $table.precio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estadoUso => $composableBuilder(
    column: $table.estadoUso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ubicacion => $composableBuilder(
    column: $table.ubicacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendienteEnvio => $composableBuilder(
    column: $table.pendienteEnvio,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductosLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductosLocalTable> {
  $$ProductosLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idProducto => $composableBuilder(
    column: $table.idProducto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clienteId => $composableBuilder(
    column: $table.clienteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precio => $composableBuilder(
    column: $table.precio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estadoUso => $composableBuilder(
    column: $table.estadoUso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ubicacion => $composableBuilder(
    column: $table.ubicacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendienteEnvio => $composableBuilder(
    column: $table.pendienteEnvio,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductosLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductosLocalTable> {
  $$ProductosLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idProducto => $composableBuilder(
    column: $table.idProducto,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clienteId =>
      $composableBuilder(column: $table.clienteId, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<double> get precio =>
      $composableBuilder(column: $table.precio, builder: (column) => column);

  GeneratedColumn<String> get estadoUso =>
      $composableBuilder(column: $table.estadoUso, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<String> get ubicacion =>
      $composableBuilder(column: $table.ubicacion, builder: (column) => column);

  GeneratedColumn<DateTime> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pendienteEnvio => $composableBuilder(
    column: $table.pendienteEnvio,
    builder: (column) => column,
  );
}

class $$ProductosLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductosLocalTable,
          ProductosLocalData,
          $$ProductosLocalTableFilterComposer,
          $$ProductosLocalTableOrderingComposer,
          $$ProductosLocalTableAnnotationComposer,
          $$ProductosLocalTableCreateCompanionBuilder,
          $$ProductosLocalTableUpdateCompanionBuilder,
          (
            ProductosLocalData,
            BaseReferences<
              _$AppDatabase,
              $ProductosLocalTable,
              ProductosLocalData
            >,
          ),
          ProductosLocalData,
          PrefetchHooks Function()
        > {
  $$ProductosLocalTableTableManager(
    _$AppDatabase db,
    $ProductosLocalTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductosLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductosLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductosLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int?> idProducto = const Value.absent(),
                Value<String> clienteId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<double> precio = const Value.absent(),
                Value<String> estadoUso = const Value.absent(),
                Value<String?> categoria = const Value.absent(),
                Value<String?> ubicacion = const Value.absent(),
                Value<DateTime> actualizadoEn = const Value.absent(),
                Value<bool> pendienteEnvio = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductosLocalCompanion(
                idProducto: idProducto,
                clienteId: clienteId,
                nombre: nombre,
                precio: precio,
                estadoUso: estadoUso,
                categoria: categoria,
                ubicacion: ubicacion,
                actualizadoEn: actualizadoEn,
                pendienteEnvio: pendienteEnvio,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int?> idProducto = const Value.absent(),
                required String clienteId,
                required String nombre,
                required double precio,
                required String estadoUso,
                Value<String?> categoria = const Value.absent(),
                Value<String?> ubicacion = const Value.absent(),
                required DateTime actualizadoEn,
                Value<bool> pendienteEnvio = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductosLocalCompanion.insert(
                idProducto: idProducto,
                clienteId: clienteId,
                nombre: nombre,
                precio: precio,
                estadoUso: estadoUso,
                categoria: categoria,
                ubicacion: ubicacion,
                actualizadoEn: actualizadoEn,
                pendienteEnvio: pendienteEnvio,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductosLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductosLocalTable,
      ProductosLocalData,
      $$ProductosLocalTableFilterComposer,
      $$ProductosLocalTableOrderingComposer,
      $$ProductosLocalTableAnnotationComposer,
      $$ProductosLocalTableCreateCompanionBuilder,
      $$ProductosLocalTableUpdateCompanionBuilder,
      (
        ProductosLocalData,
        BaseReferences<_$AppDatabase, $ProductosLocalTable, ProductosLocalData>,
      ),
      ProductosLocalData,
      PrefetchHooks Function()
    >;
typedef $$OperacionesPendientesTableCreateCompanionBuilder =
    OperacionesPendientesCompanion Function({
      required String clienteId,
      required String tipo,
      required String payloadJson,
      Value<int> intentos,
      required DateTime creadoEn,
      Value<int> rowid,
    });
typedef $$OperacionesPendientesTableUpdateCompanionBuilder =
    OperacionesPendientesCompanion Function({
      Value<String> clienteId,
      Value<String> tipo,
      Value<String> payloadJson,
      Value<int> intentos,
      Value<DateTime> creadoEn,
      Value<int> rowid,
    });

class $$OperacionesPendientesTableFilterComposer
    extends Composer<_$AppDatabase, $OperacionesPendientesTable> {
  $$OperacionesPendientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clienteId => $composableBuilder(
    column: $table.clienteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intentos => $composableBuilder(
    column: $table.intentos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OperacionesPendientesTableOrderingComposer
    extends Composer<_$AppDatabase, $OperacionesPendientesTable> {
  $$OperacionesPendientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clienteId => $composableBuilder(
    column: $table.clienteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intentos => $composableBuilder(
    column: $table.intentos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OperacionesPendientesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OperacionesPendientesTable> {
  $$OperacionesPendientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clienteId =>
      $composableBuilder(column: $table.clienteId, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intentos =>
      $composableBuilder(column: $table.intentos, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);
}

class $$OperacionesPendientesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OperacionesPendientesTable,
          OperacionesPendiente,
          $$OperacionesPendientesTableFilterComposer,
          $$OperacionesPendientesTableOrderingComposer,
          $$OperacionesPendientesTableAnnotationComposer,
          $$OperacionesPendientesTableCreateCompanionBuilder,
          $$OperacionesPendientesTableUpdateCompanionBuilder,
          (
            OperacionesPendiente,
            BaseReferences<
              _$AppDatabase,
              $OperacionesPendientesTable,
              OperacionesPendiente
            >,
          ),
          OperacionesPendiente,
          PrefetchHooks Function()
        > {
  $$OperacionesPendientesTableTableManager(
    _$AppDatabase db,
    $OperacionesPendientesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OperacionesPendientesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$OperacionesPendientesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OperacionesPendientesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> clienteId = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> intentos = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OperacionesPendientesCompanion(
                clienteId: clienteId,
                tipo: tipo,
                payloadJson: payloadJson,
                intentos: intentos,
                creadoEn: creadoEn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clienteId,
                required String tipo,
                required String payloadJson,
                Value<int> intentos = const Value.absent(),
                required DateTime creadoEn,
                Value<int> rowid = const Value.absent(),
              }) => OperacionesPendientesCompanion.insert(
                clienteId: clienteId,
                tipo: tipo,
                payloadJson: payloadJson,
                intentos: intentos,
                creadoEn: creadoEn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OperacionesPendientesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OperacionesPendientesTable,
      OperacionesPendiente,
      $$OperacionesPendientesTableFilterComposer,
      $$OperacionesPendientesTableOrderingComposer,
      $$OperacionesPendientesTableAnnotationComposer,
      $$OperacionesPendientesTableCreateCompanionBuilder,
      $$OperacionesPendientesTableUpdateCompanionBuilder,
      (
        OperacionesPendiente,
        BaseReferences<
          _$AppDatabase,
          $OperacionesPendientesTable,
          OperacionesPendiente
        >,
      ),
      OperacionesPendiente,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductosLocalTableTableManager get productosLocal =>
      $$ProductosLocalTableTableManager(_db, _db.productosLocal);
  $$OperacionesPendientesTableTableManager get operacionesPendientes =>
      $$OperacionesPendientesTableTableManager(_db, _db.operacionesPendientes);
}
