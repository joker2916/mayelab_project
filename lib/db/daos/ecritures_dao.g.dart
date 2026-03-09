// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ecritures_dao.dart';

// ignore_for_file: type=lint
mixin _$EcrituresDaoMixin on DatabaseAccessor<AppDatabase> {
  $EcrituresTable get ecritures => attachedDatabase.ecritures;
  $ComptesTable get comptes => attachedDatabase.comptes;
  $LigneEcrituresTable get ligneEcritures => attachedDatabase.ligneEcritures;
  EcrituresDaoManager get managers => EcrituresDaoManager(this);
}

class EcrituresDaoManager {
  final _$EcrituresDaoMixin _db;
  EcrituresDaoManager(this._db);
  $$EcrituresTableTableManager get ecritures =>
      $$EcrituresTableTableManager(_db.attachedDatabase, _db.ecritures);
  $$ComptesTableTableManager get comptes =>
      $$ComptesTableTableManager(_db.attachedDatabase, _db.comptes);
  $$LigneEcrituresTableTableManager get ligneEcritures =>
      $$LigneEcrituresTableTableManager(
          _db.attachedDatabase, _db.ligneEcritures);
}
