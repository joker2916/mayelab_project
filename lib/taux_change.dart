import 'package:drift/drift.dart';

class TauxChange extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get deviseSource => text().withLength(min: 1, max: 10)();
  TextColumn get deviseCible => text().withLength(min: 1, max: 10)();
  RealColumn get tauxAchat => real()();
  RealColumn get tauxVente => real()();
  DateTimeColumn get dateDebut => dateTime()();
  DateTimeColumn get dateFin => dateTime().nullable()();
  DateTimeColumn get dateModification =>
      dateTime().clientDefault(() => DateTime.now())();
}
