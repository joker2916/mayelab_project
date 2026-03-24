// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ecritures_dao.dart';

// ignore_for_file: type=lint
mixin _$EcrituresDaoMixin on DatabaseAccessor<AppDatabase> {
  $CompaniesTable get companies => attachedDatabase.companies;
  $EcrituresTable get ecritures => attachedDatabase.ecritures;
  $ComptesTable get comptes => attachedDatabase.comptes;
  $LigneEcrituresTable get ligneEcritures => attachedDatabase.ligneEcritures;
  EcrituresDaoManager get managers => EcrituresDaoManager(this);
}

class EcrituresDaoManager {
  final _$EcrituresDaoMixin _db;
  EcrituresDaoManager(this._db);
  $$CompaniesTableTableManager get companies =>
      $$CompaniesTableTableManager(_db.attachedDatabase, _db.companies);
  $$EcrituresTableTableManager get ecritures =>
      $$EcrituresTableTableManager(_db.attachedDatabase, _db.ecritures);
  $$ComptesTableTableManager get comptes =>
      $$ComptesTableTableManager(_db.attachedDatabase, _db.comptes);
  $$LigneEcrituresTableTableManager get ligneEcritures =>
      $$LigneEcrituresTableTableManager(
          _db.attachedDatabase, _db.ligneEcritures);
}
