// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SnacksTable extends Snacks with TableInfo<$SnacksTable, Snack> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnacksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiryImagePathMeta = const VerificationMeta(
    'expiryImagePath',
  );
  @override
  late final GeneratedColumn<String> expiryImagePath = GeneratedColumn<String>(
    'expiry_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiryDateMeta = const VerificationMeta(
    'expiryDate',
  );
  @override
  late final GeneratedColumn<String> expiryDate = GeneratedColumn<String>(
    'expiry_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<String> quantity = GeneratedColumn<String>(
    'quantity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trashedAtMeta = const VerificationMeta(
    'trashedAt',
  );
  @override
  late final GeneratedColumn<int> trashedAt = GeneratedColumn<int>(
    'trashed_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eatenAtMeta = const VerificationMeta(
    'eatenAt',
  );
  @override
  late final GeneratedColumn<int> eatenAt = GeneratedColumn<int>(
    'eaten_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    imagePath,
    expiryImagePath,
    expiryDate,
    name,
    quantity,
    trashedAt,
    eatenAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'snacks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Snack> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    if (data.containsKey('expiry_image_path')) {
      context.handle(
        _expiryImagePathMeta,
        expiryImagePath.isAcceptableOrUnknown(
          data['expiry_image_path']!,
          _expiryImagePathMeta,
        ),
      );
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
        _expiryDateMeta,
        expiryDate.isAcceptableOrUnknown(data['expiry_date']!, _expiryDateMeta),
      );
    } else if (isInserting) {
      context.missing(_expiryDateMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('trashed_at')) {
      context.handle(
        _trashedAtMeta,
        trashedAt.isAcceptableOrUnknown(data['trashed_at']!, _trashedAtMeta),
      );
    }
    if (data.containsKey('eaten_at')) {
      context.handle(
        _eatenAtMeta,
        eatenAt.isAcceptableOrUnknown(data['eaten_at']!, _eatenAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Snack map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Snack(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      )!,
      expiryImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expiry_image_path'],
      ),
      expiryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expiry_date'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quantity'],
      ),
      trashedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trashed_at'],
      ),
      eatenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}eaten_at'],
      ),
    );
  }

  @override
  $SnacksTable createAlias(String alias) {
    return $SnacksTable(attachedDatabase, alias);
  }
}

class Snack extends DataClass implements Insertable<Snack> {
  final int id;
  final String imagePath;
  final String? expiryImagePath;
  final String expiryDate;
  final String? name;
  final String? quantity;
  final int? trashedAt;
  final int? eatenAt;
  const Snack({
    required this.id,
    required this.imagePath,
    this.expiryImagePath,
    required this.expiryDate,
    this.name,
    this.quantity,
    this.trashedAt,
    this.eatenAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['image_path'] = Variable<String>(imagePath);
    if (!nullToAbsent || expiryImagePath != null) {
      map['expiry_image_path'] = Variable<String>(expiryImagePath);
    }
    map['expiry_date'] = Variable<String>(expiryDate);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<String>(quantity);
    }
    if (!nullToAbsent || trashedAt != null) {
      map['trashed_at'] = Variable<int>(trashedAt);
    }
    if (!nullToAbsent || eatenAt != null) {
      map['eaten_at'] = Variable<int>(eatenAt);
    }
    return map;
  }

  SnacksCompanion toCompanion(bool nullToAbsent) {
    return SnacksCompanion(
      id: Value(id),
      imagePath: Value(imagePath),
      expiryImagePath: expiryImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryImagePath),
      expiryDate: Value(expiryDate),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      trashedAt: trashedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(trashedAt),
      eatenAt: eatenAt == null && nullToAbsent
          ? const Value.absent()
          : Value(eatenAt),
    );
  }

  factory Snack.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Snack(
      id: serializer.fromJson<int>(json['id']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      expiryImagePath: serializer.fromJson<String?>(json['expiryImagePath']),
      expiryDate: serializer.fromJson<String>(json['expiryDate']),
      name: serializer.fromJson<String?>(json['name']),
      quantity: serializer.fromJson<String?>(json['quantity']),
      trashedAt: serializer.fromJson<int?>(json['trashedAt']),
      eatenAt: serializer.fromJson<int?>(json['eatenAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'imagePath': serializer.toJson<String>(imagePath),
      'expiryImagePath': serializer.toJson<String?>(expiryImagePath),
      'expiryDate': serializer.toJson<String>(expiryDate),
      'name': serializer.toJson<String?>(name),
      'quantity': serializer.toJson<String?>(quantity),
      'trashedAt': serializer.toJson<int?>(trashedAt),
      'eatenAt': serializer.toJson<int?>(eatenAt),
    };
  }

  Snack copyWith({
    int? id,
    String? imagePath,
    Value<String?> expiryImagePath = const Value.absent(),
    String? expiryDate,
    Value<String?> name = const Value.absent(),
    Value<String?> quantity = const Value.absent(),
    Value<int?> trashedAt = const Value.absent(),
    Value<int?> eatenAt = const Value.absent(),
  }) => Snack(
    id: id ?? this.id,
    imagePath: imagePath ?? this.imagePath,
    expiryImagePath: expiryImagePath.present
        ? expiryImagePath.value
        : this.expiryImagePath,
    expiryDate: expiryDate ?? this.expiryDate,
    name: name.present ? name.value : this.name,
    quantity: quantity.present ? quantity.value : this.quantity,
    trashedAt: trashedAt.present ? trashedAt.value : this.trashedAt,
    eatenAt: eatenAt.present ? eatenAt.value : this.eatenAt,
  );
  Snack copyWithCompanion(SnacksCompanion data) {
    return Snack(
      id: data.id.present ? data.id.value : this.id,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      expiryImagePath: data.expiryImagePath.present
          ? data.expiryImagePath.value
          : this.expiryImagePath,
      expiryDate: data.expiryDate.present
          ? data.expiryDate.value
          : this.expiryDate,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      trashedAt: data.trashedAt.present ? data.trashedAt.value : this.trashedAt,
      eatenAt: data.eatenAt.present ? data.eatenAt.value : this.eatenAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Snack(')
          ..write('id: $id, ')
          ..write('imagePath: $imagePath, ')
          ..write('expiryImagePath: $expiryImagePath, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('trashedAt: $trashedAt, ')
          ..write('eatenAt: $eatenAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    imagePath,
    expiryImagePath,
    expiryDate,
    name,
    quantity,
    trashedAt,
    eatenAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Snack &&
          other.id == this.id &&
          other.imagePath == this.imagePath &&
          other.expiryImagePath == this.expiryImagePath &&
          other.expiryDate == this.expiryDate &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.trashedAt == this.trashedAt &&
          other.eatenAt == this.eatenAt);
}

class SnacksCompanion extends UpdateCompanion<Snack> {
  final Value<int> id;
  final Value<String> imagePath;
  final Value<String?> expiryImagePath;
  final Value<String> expiryDate;
  final Value<String?> name;
  final Value<String?> quantity;
  final Value<int?> trashedAt;
  final Value<int?> eatenAt;
  const SnacksCompanion({
    this.id = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.expiryImagePath = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.trashedAt = const Value.absent(),
    this.eatenAt = const Value.absent(),
  });
  SnacksCompanion.insert({
    this.id = const Value.absent(),
    required String imagePath,
    this.expiryImagePath = const Value.absent(),
    required String expiryDate,
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.trashedAt = const Value.absent(),
    this.eatenAt = const Value.absent(),
  }) : imagePath = Value(imagePath),
       expiryDate = Value(expiryDate);
  static Insertable<Snack> custom({
    Expression<int>? id,
    Expression<String>? imagePath,
    Expression<String>? expiryImagePath,
    Expression<String>? expiryDate,
    Expression<String>? name,
    Expression<String>? quantity,
    Expression<int>? trashedAt,
    Expression<int>? eatenAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (imagePath != null) 'image_path': imagePath,
      if (expiryImagePath != null) 'expiry_image_path': expiryImagePath,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (trashedAt != null) 'trashed_at': trashedAt,
      if (eatenAt != null) 'eaten_at': eatenAt,
    });
  }

  SnacksCompanion copyWith({
    Value<int>? id,
    Value<String>? imagePath,
    Value<String?>? expiryImagePath,
    Value<String>? expiryDate,
    Value<String?>? name,
    Value<String?>? quantity,
    Value<int?>? trashedAt,
    Value<int?>? eatenAt,
  }) {
    return SnacksCompanion(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      expiryImagePath: expiryImagePath ?? this.expiryImagePath,
      expiryDate: expiryDate ?? this.expiryDate,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      trashedAt: trashedAt ?? this.trashedAt,
      eatenAt: eatenAt ?? this.eatenAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (expiryImagePath.present) {
      map['expiry_image_path'] = Variable<String>(expiryImagePath.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<String>(expiryDate.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<String>(quantity.value);
    }
    if (trashedAt.present) {
      map['trashed_at'] = Variable<int>(trashedAt.value);
    }
    if (eatenAt.present) {
      map['eaten_at'] = Variable<int>(eatenAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnacksCompanion(')
          ..write('id: $id, ')
          ..write('imagePath: $imagePath, ')
          ..write('expiryImagePath: $expiryImagePath, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('trashedAt: $trashedAt, ')
          ..write('eatenAt: $eatenAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SnacksTable snacks = $SnacksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [snacks];
}

typedef $$SnacksTableCreateCompanionBuilder =
    SnacksCompanion Function({
      Value<int> id,
      required String imagePath,
      Value<String?> expiryImagePath,
      required String expiryDate,
      Value<String?> name,
      Value<String?> quantity,
      Value<int?> trashedAt,
      Value<int?> eatenAt,
    });
typedef $$SnacksTableUpdateCompanionBuilder =
    SnacksCompanion Function({
      Value<int> id,
      Value<String> imagePath,
      Value<String?> expiryImagePath,
      Value<String> expiryDate,
      Value<String?> name,
      Value<String?> quantity,
      Value<int?> trashedAt,
      Value<int?> eatenAt,
    });

class $$SnacksTableFilterComposer
    extends Composer<_$AppDatabase, $SnacksTable> {
  $$SnacksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expiryImagePath => $composableBuilder(
    column: $table.expiryImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trashedAt => $composableBuilder(
    column: $table.trashedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get eatenAt => $composableBuilder(
    column: $table.eatenAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SnacksTableOrderingComposer
    extends Composer<_$AppDatabase, $SnacksTable> {
  $$SnacksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expiryImagePath => $composableBuilder(
    column: $table.expiryImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trashedAt => $composableBuilder(
    column: $table.trashedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get eatenAt => $composableBuilder(
    column: $table.eatenAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SnacksTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnacksTable> {
  $$SnacksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get expiryImagePath => $composableBuilder(
    column: $table.expiryImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get trashedAt =>
      $composableBuilder(column: $table.trashedAt, builder: (column) => column);

  GeneratedColumn<int> get eatenAt =>
      $composableBuilder(column: $table.eatenAt, builder: (column) => column);
}

class $$SnacksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SnacksTable,
          Snack,
          $$SnacksTableFilterComposer,
          $$SnacksTableOrderingComposer,
          $$SnacksTableAnnotationComposer,
          $$SnacksTableCreateCompanionBuilder,
          $$SnacksTableUpdateCompanionBuilder,
          (Snack, BaseReferences<_$AppDatabase, $SnacksTable, Snack>),
          Snack,
          PrefetchHooks Function()
        > {
  $$SnacksTableTableManager(_$AppDatabase db, $SnacksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnacksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnacksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnacksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
                Value<String?> expiryImagePath = const Value.absent(),
                Value<String> expiryDate = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> quantity = const Value.absent(),
                Value<int?> trashedAt = const Value.absent(),
                Value<int?> eatenAt = const Value.absent(),
              }) => SnacksCompanion(
                id: id,
                imagePath: imagePath,
                expiryImagePath: expiryImagePath,
                expiryDate: expiryDate,
                name: name,
                quantity: quantity,
                trashedAt: trashedAt,
                eatenAt: eatenAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String imagePath,
                Value<String?> expiryImagePath = const Value.absent(),
                required String expiryDate,
                Value<String?> name = const Value.absent(),
                Value<String?> quantity = const Value.absent(),
                Value<int?> trashedAt = const Value.absent(),
                Value<int?> eatenAt = const Value.absent(),
              }) => SnacksCompanion.insert(
                id: id,
                imagePath: imagePath,
                expiryImagePath: expiryImagePath,
                expiryDate: expiryDate,
                name: name,
                quantity: quantity,
                trashedAt: trashedAt,
                eatenAt: eatenAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SnacksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SnacksTable,
      Snack,
      $$SnacksTableFilterComposer,
      $$SnacksTableOrderingComposer,
      $$SnacksTableAnnotationComposer,
      $$SnacksTableCreateCompanionBuilder,
      $$SnacksTableUpdateCompanionBuilder,
      (Snack, BaseReferences<_$AppDatabase, $SnacksTable, Snack>),
      Snack,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SnacksTableTableManager get snacks =>
      $$SnacksTableTableManager(_db, _db.snacks);
}
