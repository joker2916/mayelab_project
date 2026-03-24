// lib/data/database/tables/attachements_table.dart
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

class Attachments extends Table {
  TextColumn get id => text().clientDefault(() => _uuid.v4())();
  TextColumn get ecritureId =>
      text().customConstraint('NOT NULL REFERENCES ecritures(id)')();
  TextColumn get filename => text()();
  TextColumn get path => text()();
  TextColumn get mime => text().nullable()();
  IntColumn get size => integer().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}
