import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Snacks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get imagePath => text()();
  TextColumn get expiryImagePath => text().nullable()();
  TextColumn get expiryDate => text()();
  TextColumn get name => text().nullable()();
  TextColumn get quantity => text().nullable()();
  IntColumn get trashedAt => integer().nullable()();
  IntColumn get eatenAt => integer().nullable()();
}

@DriftDatabase(tables: [Snacks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.addColumn(snacks, snacks.expiryImagePath);
            await migrator.addColumn(snacks, snacks.name);
            await migrator.addColumn(snacks, snacks.quantity);
          }
          if (from < 3) {
            await migrator.addColumn(snacks, snacks.trashedAt);
            await migrator.addColumn(snacks, snacks.eatenAt);
          }
        },
      );

  Future<int> addSnack({
    required String imagePath,
    required String expiryDate,
    required String expiryImagePath,
    String? name,
    String? quantity,
  }) {
    return into(snacks).insert(
      SnacksCompanion.insert(
        imagePath: imagePath,
        expiryImagePath: Value(expiryImagePath),
        expiryDate: expiryDate,
        name: Value(name),
        quantity: Value(quantity),
      ),
    );
  }

  Stream<List<Snack>> watchActiveSnacks() {
    return (select(snacks)
          ..where((t) => t.trashedAt.isNull() & t.eatenAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(expression: t.expiryDate),
          ]))
        .watch();
  }

  Stream<List<Snack>> watchTrashSnacks() {
    return (select(snacks)
          ..where((t) => t.trashedAt.isNotNull())
          ..orderBy([
            (t) => OrderingTerm(expression: t.trashedAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Stream<List<Snack>> watchEatenSnacks() {
    return (select(snacks)
          ..where((t) => t.eatenAt.isNotNull())
          ..orderBy([
            (t) => OrderingTerm(expression: t.eatenAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Future<void> trashSnack(int id) {
    return (update(snacks)..where((t) => t.id.equals(id))).write(
      SnacksCompanion(
        trashedAt: Value(DateTime.now().millisecondsSinceEpoch),
        eatenAt: const Value(null),
      ),
    );
  }

  Future<void> restoreSnack(int id) {
    return (update(snacks)..where((t) => t.id.equals(id))).write(
      const SnacksCompanion(
        trashedAt: Value(null),
      ),
    );
  }

  Future<void> restoreEaten(int id) {
    return (update(snacks)..where((t) => t.id.equals(id))).write(
      const SnacksCompanion(
        eatenAt: Value(null),
      ),
    );
  }

  Future<void> markEaten(int id) {
    return (update(snacks)..where((t) => t.id.equals(id))).write(
      SnacksCompanion(
        eatenAt: Value(DateTime.now().millisecondsSinceEpoch),
        trashedAt: const Value(null),
      ),
    );
  }

  Future<void> deleteSnackPermanently(Snack snack) async {
    await _deleteFileIfExists(snack.imagePath);
    if (snack.expiryImagePath != null) {
      await _deleteFileIfExists(snack.expiryImagePath!);
    }
    await (delete(snacks)..where((t) => t.id.equals(snack.id))).go();
  }

  Future<int> purgeOldTrash(Duration duration) async {
    final cutoff =
        DateTime.now().subtract(duration).millisecondsSinceEpoch;
    final oldItems = await (select(snacks)
          ..where((t) => t.trashedAt.isSmallerOrEqualValue(cutoff)))
        .get();
    for (final item in oldItems) {
      await _deleteFileIfExists(item.imagePath);
      if (item.expiryImagePath != null) {
        await _deleteFileIfExists(item.expiryImagePath!);
      }
    }
    return (delete(snacks)
          ..where((t) => t.trashedAt.isSmallerOrEqualValue(cutoff)))
        .go();
  }

  Future<int> clearTrash() async {
    final items = await (select(snacks)
          ..where((t) => t.trashedAt.isNotNull()))
        .get();
    for (final item in items) {
      await _deleteFileIfExists(item.imagePath);
      if (item.expiryImagePath != null) {
        await _deleteFileIfExists(item.expiryImagePath!);
      }
    }
    return (delete(snacks)..where((t) => t.trashedAt.isNotNull())).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'snack_keeper.sqlite'));
    return NativeDatabase(file);
  });
}

Future<void> _deleteFileIfExists(String path) async {
  final file = File(path);
  if (await file.exists()) {
    await file.delete();
  }
}
