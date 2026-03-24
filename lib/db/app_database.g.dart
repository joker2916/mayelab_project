// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CompaniesTable extends Companies
    with TableInfo<$CompaniesTable, Company> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompaniesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid.v4());
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _taxNumberMeta =
      const VerificationMeta('taxNumber');
  @override
  late final GeneratedColumn<String> taxNumber = GeneratedColumn<String>(
      'tax_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _currencyDefaultMeta =
      const VerificationMeta('currencyDefault');
  @override
  late final GeneratedColumn<String> currencyDefault = GeneratedColumn<String>(
      'currency_default', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NULLABLE REFERENCES currencies(id)');
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
      'active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, taxNumber, currencyDefault, active, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'companies';
  @override
  VerificationContext validateIntegrity(Insertable<Company> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('tax_number')) {
      context.handle(_taxNumberMeta,
          taxNumber.isAcceptableOrUnknown(data['tax_number']!, _taxNumberMeta));
    }
    if (data.containsKey('currency_default')) {
      context.handle(
          _currencyDefaultMeta,
          currencyDefault.isAcceptableOrUnknown(
              data['currency_default']!, _currencyDefaultMeta));
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta,
          active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Company map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Company(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      taxNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tax_number']),
      currencyDefault: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}currency_default']),
      active: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $CompaniesTable createAlias(String alias) {
    return $CompaniesTable(attachedDatabase, alias);
  }
}

class Company extends DataClass implements Insertable<Company> {
  final String id;
  final String name;
  final String? taxNumber;
  final String? currencyDefault;
  final bool active;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const Company(
      {required this.id,
      required this.name,
      this.taxNumber,
      this.currencyDefault,
      required this.active,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || taxNumber != null) {
      map['tax_number'] = Variable<String>(taxNumber);
    }
    if (!nullToAbsent || currencyDefault != null) {
      map['currency_default'] = Variable<String>(currencyDefault);
    }
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  CompaniesCompanion toCompanion(bool nullToAbsent) {
    return CompaniesCompanion(
      id: Value(id),
      name: Value(name),
      taxNumber: taxNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(taxNumber),
      currencyDefault: currencyDefault == null && nullToAbsent
          ? const Value.absent()
          : Value(currencyDefault),
      active: Value(active),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Company.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Company(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      taxNumber: serializer.fromJson<String?>(json['taxNumber']),
      currencyDefault: serializer.fromJson<String?>(json['currencyDefault']),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'taxNumber': serializer.toJson<String?>(taxNumber),
      'currencyDefault': serializer.toJson<String?>(currencyDefault),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Company copyWith(
          {String? id,
          String? name,
          Value<String?> taxNumber = const Value.absent(),
          Value<String?> currencyDefault = const Value.absent(),
          bool? active,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      Company(
        id: id ?? this.id,
        name: name ?? this.name,
        taxNumber: taxNumber.present ? taxNumber.value : this.taxNumber,
        currencyDefault: currencyDefault.present
            ? currencyDefault.value
            : this.currencyDefault,
        active: active ?? this.active,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  Company copyWithCompanion(CompaniesCompanion data) {
    return Company(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      taxNumber: data.taxNumber.present ? data.taxNumber.value : this.taxNumber,
      currencyDefault: data.currencyDefault.present
          ? data.currencyDefault.value
          : this.currencyDefault,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Company(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('taxNumber: $taxNumber, ')
          ..write('currencyDefault: $currencyDefault, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, taxNumber, currencyDefault, active, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Company &&
          other.id == this.id &&
          other.name == this.name &&
          other.taxNumber == this.taxNumber &&
          other.currencyDefault == this.currencyDefault &&
          other.active == this.active &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CompaniesCompanion extends UpdateCompanion<Company> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> taxNumber;
  final Value<String?> currencyDefault;
  final Value<bool> active;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const CompaniesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.taxNumber = const Value.absent(),
    this.currencyDefault = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CompaniesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.taxNumber = const Value.absent(),
    this.currencyDefault = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Company> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? taxNumber,
    Expression<String>? currencyDefault,
    Expression<bool>? active,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (taxNumber != null) 'tax_number': taxNumber,
      if (currencyDefault != null) 'currency_default': currencyDefault,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CompaniesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? taxNumber,
      Value<String?>? currencyDefault,
      Value<bool>? active,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return CompaniesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      taxNumber: taxNumber ?? this.taxNumber,
      currencyDefault: currencyDefault ?? this.currencyDefault,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (taxNumber.present) {
      map['tax_number'] = Variable<String>(taxNumber.value);
    }
    if (currencyDefault.present) {
      map['currency_default'] = Variable<String>(currencyDefault.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompaniesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('taxNumber: $taxNumber, ')
          ..write('currencyDefault: $currencyDefault, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CurrenciesTable extends Currencies
    with TableInfo<$CurrenciesTable, Currency> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrenciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid.v4());
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, code, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'currencies';
  @override
  VerificationContext validateIntegrity(Insertable<Currency> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Currency map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Currency(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
    );
  }

  @override
  $CurrenciesTable createAlias(String alias) {
    return $CurrenciesTable(attachedDatabase, alias);
  }
}

class Currency extends DataClass implements Insertable<Currency> {
  final String id;
  final String code;
  final String? name;
  const Currency({required this.id, required this.code, this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    return map;
  }

  CurrenciesCompanion toCompanion(bool nullToAbsent) {
    return CurrenciesCompanion(
      id: Value(id),
      code: Value(code),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  factory Currency.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Currency(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String?>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String?>(name),
    };
  }

  Currency copyWith(
          {String? id,
          String? code,
          Value<String?> name = const Value.absent()}) =>
      Currency(
        id: id ?? this.id,
        code: code ?? this.code,
        name: name.present ? name.value : this.name,
      );
  Currency copyWithCompanion(CurrenciesCompanion data) {
    return Currency(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Currency(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Currency &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name);
}

class CurrenciesCompanion extends UpdateCompanion<Currency> {
  final Value<String> id;
  final Value<String> code;
  final Value<String?> name;
  final Value<int> rowid;
  const CurrenciesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CurrenciesCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : code = Value(code);
  static Insertable<Currency> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CurrenciesCompanion copyWith(
      {Value<String>? id,
      Value<String>? code,
      Value<String?>? name,
      Value<int>? rowid}) {
    return CurrenciesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrenciesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExchangeRatesTable extends ExchangeRates
    with TableInfo<$ExchangeRatesTable, ExchangeRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExchangeRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid.v4());
  static const VerificationMeta _fromCurrencyMeta =
      const VerificationMeta('fromCurrency');
  @override
  late final GeneratedColumn<String> fromCurrency = GeneratedColumn<String>(
      'from_currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES currencies(id)');
  static const VerificationMeta _toCurrencyMeta =
      const VerificationMeta('toCurrency');
  @override
  late final GeneratedColumn<String> toCurrency = GeneratedColumn<String>(
      'to_currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES currencies(id)');
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<int> rate = GeneratedColumn<int>(
      'rate', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns =>
      [id, fromCurrency, toCurrency, rate, date, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exchange_rates';
  @override
  VerificationContext validateIntegrity(Insertable<ExchangeRate> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('from_currency')) {
      context.handle(
          _fromCurrencyMeta,
          fromCurrency.isAcceptableOrUnknown(
              data['from_currency']!, _fromCurrencyMeta));
    } else if (isInserting) {
      context.missing(_fromCurrencyMeta);
    }
    if (data.containsKey('to_currency')) {
      context.handle(
          _toCurrencyMeta,
          toCurrency.isAcceptableOrUnknown(
              data['to_currency']!, _toCurrencyMeta));
    } else if (isInserting) {
      context.missing(_toCurrencyMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
          _rateMeta, rate.isAcceptableOrUnknown(data['rate']!, _rateMeta));
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExchangeRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExchangeRate(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      fromCurrency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from_currency'])!,
      toCurrency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to_currency'])!,
      rate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rate'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ExchangeRatesTable createAlias(String alias) {
    return $ExchangeRatesTable(attachedDatabase, alias);
  }
}

class ExchangeRate extends DataClass implements Insertable<ExchangeRate> {
  final String id;
  final String fromCurrency;
  final String toCurrency;
  final int rate;
  final DateTime date;
  final DateTime createdAt;
  const ExchangeRate(
      {required this.id,
      required this.fromCurrency,
      required this.toCurrency,
      required this.rate,
      required this.date,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['from_currency'] = Variable<String>(fromCurrency);
    map['to_currency'] = Variable<String>(toCurrency);
    map['rate'] = Variable<int>(rate);
    map['date'] = Variable<DateTime>(date);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExchangeRatesCompanion toCompanion(bool nullToAbsent) {
    return ExchangeRatesCompanion(
      id: Value(id),
      fromCurrency: Value(fromCurrency),
      toCurrency: Value(toCurrency),
      rate: Value(rate),
      date: Value(date),
      createdAt: Value(createdAt),
    );
  }

  factory ExchangeRate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExchangeRate(
      id: serializer.fromJson<String>(json['id']),
      fromCurrency: serializer.fromJson<String>(json['fromCurrency']),
      toCurrency: serializer.fromJson<String>(json['toCurrency']),
      rate: serializer.fromJson<int>(json['rate']),
      date: serializer.fromJson<DateTime>(json['date']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fromCurrency': serializer.toJson<String>(fromCurrency),
      'toCurrency': serializer.toJson<String>(toCurrency),
      'rate': serializer.toJson<int>(rate),
      'date': serializer.toJson<DateTime>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExchangeRate copyWith(
          {String? id,
          String? fromCurrency,
          String? toCurrency,
          int? rate,
          DateTime? date,
          DateTime? createdAt}) =>
      ExchangeRate(
        id: id ?? this.id,
        fromCurrency: fromCurrency ?? this.fromCurrency,
        toCurrency: toCurrency ?? this.toCurrency,
        rate: rate ?? this.rate,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
      );
  ExchangeRate copyWithCompanion(ExchangeRatesCompanion data) {
    return ExchangeRate(
      id: data.id.present ? data.id.value : this.id,
      fromCurrency: data.fromCurrency.present
          ? data.fromCurrency.value
          : this.fromCurrency,
      toCurrency:
          data.toCurrency.present ? data.toCurrency.value : this.toCurrency,
      rate: data.rate.present ? data.rate.value : this.rate,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRate(')
          ..write('id: $id, ')
          ..write('fromCurrency: $fromCurrency, ')
          ..write('toCurrency: $toCurrency, ')
          ..write('rate: $rate, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, fromCurrency, toCurrency, rate, date, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExchangeRate &&
          other.id == this.id &&
          other.fromCurrency == this.fromCurrency &&
          other.toCurrency == this.toCurrency &&
          other.rate == this.rate &&
          other.date == this.date &&
          other.createdAt == this.createdAt);
}

class ExchangeRatesCompanion extends UpdateCompanion<ExchangeRate> {
  final Value<String> id;
  final Value<String> fromCurrency;
  final Value<String> toCurrency;
  final Value<int> rate;
  final Value<DateTime> date;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ExchangeRatesCompanion({
    this.id = const Value.absent(),
    this.fromCurrency = const Value.absent(),
    this.toCurrency = const Value.absent(),
    this.rate = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExchangeRatesCompanion.insert({
    this.id = const Value.absent(),
    required String fromCurrency,
    required String toCurrency,
    required int rate,
    required DateTime date,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : fromCurrency = Value(fromCurrency),
        toCurrency = Value(toCurrency),
        rate = Value(rate),
        date = Value(date);
  static Insertable<ExchangeRate> custom({
    Expression<String>? id,
    Expression<String>? fromCurrency,
    Expression<String>? toCurrency,
    Expression<int>? rate,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromCurrency != null) 'from_currency': fromCurrency,
      if (toCurrency != null) 'to_currency': toCurrency,
      if (rate != null) 'rate': rate,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExchangeRatesCompanion copyWith(
      {Value<String>? id,
      Value<String>? fromCurrency,
      Value<String>? toCurrency,
      Value<int>? rate,
      Value<DateTime>? date,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ExchangeRatesCompanion(
      id: id ?? this.id,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      rate: rate ?? this.rate,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fromCurrency.present) {
      map['from_currency'] = Variable<String>(fromCurrency.value);
    }
    if (toCurrency.present) {
      map['to_currency'] = Variable<String>(toCurrency.value);
    }
    if (rate.present) {
      map['rate'] = Variable<int>(rate.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRatesCompanion(')
          ..write('id: $id, ')
          ..write('fromCurrency: $fromCurrency, ')
          ..write('toCurrency: $toCurrency, ')
          ..write('rate: $rate, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SequencesTable extends Sequences
    with TableInfo<$SequencesTable, Sequence> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SequencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid.v4());
  static const VerificationMeta _companyIdMeta =
      const VerificationMeta('companyId');
  @override
  late final GeneratedColumn<String> companyId = GeneratedColumn<String>(
      'company_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _journalIdMeta =
      const VerificationMeta('journalId');
  @override
  late final GeneratedColumn<String> journalId = GeneratedColumn<String>(
      'journal_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastNumberMeta =
      const VerificationMeta('lastNumber');
  @override
  late final GeneratedColumn<int> lastNumber = GeneratedColumn<int>(
      'last_number', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _paddingMeta =
      const VerificationMeta('padding');
  @override
  late final GeneratedColumn<int> padding = GeneratedColumn<int>(
      'padding', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4));
  static const VerificationMeta _prefixMeta = const VerificationMeta('prefix');
  @override
  late final GeneratedColumn<String> prefix = GeneratedColumn<String>(
      'prefix', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, companyId, journalId, lastNumber, padding, prefix];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sequences';
  @override
  VerificationContext validateIntegrity(Insertable<Sequence> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('company_id')) {
      context.handle(_companyIdMeta,
          companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta));
    } else if (isInserting) {
      context.missing(_companyIdMeta);
    }
    if (data.containsKey('journal_id')) {
      context.handle(_journalIdMeta,
          journalId.isAcceptableOrUnknown(data['journal_id']!, _journalIdMeta));
    }
    if (data.containsKey('last_number')) {
      context.handle(
          _lastNumberMeta,
          lastNumber.isAcceptableOrUnknown(
              data['last_number']!, _lastNumberMeta));
    }
    if (data.containsKey('padding')) {
      context.handle(_paddingMeta,
          padding.isAcceptableOrUnknown(data['padding']!, _paddingMeta));
    }
    if (data.containsKey('prefix')) {
      context.handle(_prefixMeta,
          prefix.isAcceptableOrUnknown(data['prefix']!, _prefixMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sequence map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sequence(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      companyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}company_id'])!,
      journalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}journal_id']),
      lastNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_number'])!,
      padding: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}padding'])!,
      prefix: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}prefix']),
    );
  }

  @override
  $SequencesTable createAlias(String alias) {
    return $SequencesTable(attachedDatabase, alias);
  }
}

class Sequence extends DataClass implements Insertable<Sequence> {
  final String id;
  final String companyId;
  final String? journalId;
  final int lastNumber;
  final int padding;
  final String? prefix;
  const Sequence(
      {required this.id,
      required this.companyId,
      this.journalId,
      required this.lastNumber,
      required this.padding,
      this.prefix});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['company_id'] = Variable<String>(companyId);
    if (!nullToAbsent || journalId != null) {
      map['journal_id'] = Variable<String>(journalId);
    }
    map['last_number'] = Variable<int>(lastNumber);
    map['padding'] = Variable<int>(padding);
    if (!nullToAbsent || prefix != null) {
      map['prefix'] = Variable<String>(prefix);
    }
    return map;
  }

  SequencesCompanion toCompanion(bool nullToAbsent) {
    return SequencesCompanion(
      id: Value(id),
      companyId: Value(companyId),
      journalId: journalId == null && nullToAbsent
          ? const Value.absent()
          : Value(journalId),
      lastNumber: Value(lastNumber),
      padding: Value(padding),
      prefix:
          prefix == null && nullToAbsent ? const Value.absent() : Value(prefix),
    );
  }

  factory Sequence.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sequence(
      id: serializer.fromJson<String>(json['id']),
      companyId: serializer.fromJson<String>(json['companyId']),
      journalId: serializer.fromJson<String?>(json['journalId']),
      lastNumber: serializer.fromJson<int>(json['lastNumber']),
      padding: serializer.fromJson<int>(json['padding']),
      prefix: serializer.fromJson<String?>(json['prefix']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'companyId': serializer.toJson<String>(companyId),
      'journalId': serializer.toJson<String?>(journalId),
      'lastNumber': serializer.toJson<int>(lastNumber),
      'padding': serializer.toJson<int>(padding),
      'prefix': serializer.toJson<String?>(prefix),
    };
  }

  Sequence copyWith(
          {String? id,
          String? companyId,
          Value<String?> journalId = const Value.absent(),
          int? lastNumber,
          int? padding,
          Value<String?> prefix = const Value.absent()}) =>
      Sequence(
        id: id ?? this.id,
        companyId: companyId ?? this.companyId,
        journalId: journalId.present ? journalId.value : this.journalId,
        lastNumber: lastNumber ?? this.lastNumber,
        padding: padding ?? this.padding,
        prefix: prefix.present ? prefix.value : this.prefix,
      );
  Sequence copyWithCompanion(SequencesCompanion data) {
    return Sequence(
      id: data.id.present ? data.id.value : this.id,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      journalId: data.journalId.present ? data.journalId.value : this.journalId,
      lastNumber:
          data.lastNumber.present ? data.lastNumber.value : this.lastNumber,
      padding: data.padding.present ? data.padding.value : this.padding,
      prefix: data.prefix.present ? data.prefix.value : this.prefix,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sequence(')
          ..write('id: $id, ')
          ..write('companyId: $companyId, ')
          ..write('journalId: $journalId, ')
          ..write('lastNumber: $lastNumber, ')
          ..write('padding: $padding, ')
          ..write('prefix: $prefix')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, companyId, journalId, lastNumber, padding, prefix);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sequence &&
          other.id == this.id &&
          other.companyId == this.companyId &&
          other.journalId == this.journalId &&
          other.lastNumber == this.lastNumber &&
          other.padding == this.padding &&
          other.prefix == this.prefix);
}

class SequencesCompanion extends UpdateCompanion<Sequence> {
  final Value<String> id;
  final Value<String> companyId;
  final Value<String?> journalId;
  final Value<int> lastNumber;
  final Value<int> padding;
  final Value<String?> prefix;
  final Value<int> rowid;
  const SequencesCompanion({
    this.id = const Value.absent(),
    this.companyId = const Value.absent(),
    this.journalId = const Value.absent(),
    this.lastNumber = const Value.absent(),
    this.padding = const Value.absent(),
    this.prefix = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SequencesCompanion.insert({
    this.id = const Value.absent(),
    required String companyId,
    this.journalId = const Value.absent(),
    this.lastNumber = const Value.absent(),
    this.padding = const Value.absent(),
    this.prefix = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : companyId = Value(companyId);
  static Insertable<Sequence> custom({
    Expression<String>? id,
    Expression<String>? companyId,
    Expression<String>? journalId,
    Expression<int>? lastNumber,
    Expression<int>? padding,
    Expression<String>? prefix,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (companyId != null) 'company_id': companyId,
      if (journalId != null) 'journal_id': journalId,
      if (lastNumber != null) 'last_number': lastNumber,
      if (padding != null) 'padding': padding,
      if (prefix != null) 'prefix': prefix,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SequencesCompanion copyWith(
      {Value<String>? id,
      Value<String>? companyId,
      Value<String?>? journalId,
      Value<int>? lastNumber,
      Value<int>? padding,
      Value<String?>? prefix,
      Value<int>? rowid}) {
    return SequencesCompanion(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      journalId: journalId ?? this.journalId,
      lastNumber: lastNumber ?? this.lastNumber,
      padding: padding ?? this.padding,
      prefix: prefix ?? this.prefix,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<String>(companyId.value);
    }
    if (journalId.present) {
      map['journal_id'] = Variable<String>(journalId.value);
    }
    if (lastNumber.present) {
      map['last_number'] = Variable<int>(lastNumber.value);
    }
    if (padding.present) {
      map['padding'] = Variable<int>(padding.value);
    }
    if (prefix.present) {
      map['prefix'] = Variable<String>(prefix.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SequencesCompanion(')
          ..write('id: $id, ')
          ..write('companyId: $companyId, ')
          ..write('journalId: $journalId, ')
          ..write('lastNumber: $lastNumber, ')
          ..write('padding: $padding, ')
          ..write('prefix: $prefix, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ComptesTable extends Comptes with TableInfo<$ComptesTable, Compte> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComptesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
      'nom', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _lftMeta = const VerificationMeta('lft');
  @override
  late final GeneratedColumn<int> lft = GeneratedColumn<int>(
      'lft', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _rgtMeta = const VerificationMeta('rgt');
  @override
  late final GeneratedColumn<int> rgt = GeneratedColumn<int>(
      'rgt', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, code, nom, lft, rgt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'comptes';
  @override
  VerificationContext validateIntegrity(Insertable<Compte> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('nom')) {
      context.handle(
          _nomMeta, nom.isAcceptableOrUnknown(data['nom']!, _nomMeta));
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('lft')) {
      context.handle(
          _lftMeta, lft.isAcceptableOrUnknown(data['lft']!, _lftMeta));
    } else if (isInserting) {
      context.missing(_lftMeta);
    }
    if (data.containsKey('rgt')) {
      context.handle(
          _rgtMeta, rgt.isAcceptableOrUnknown(data['rgt']!, _rgtMeta));
    } else if (isInserting) {
      context.missing(_rgtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Compte map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Compte(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      nom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom'])!,
      lft: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lft'])!,
      rgt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rgt'])!,
    );
  }

  @override
  $ComptesTable createAlias(String alias) {
    return $ComptesTable(attachedDatabase, alias);
  }
}

class Compte extends DataClass implements Insertable<Compte> {
  final int id;
  final String code;
  final String nom;
  final int lft;
  final int rgt;
  const Compte(
      {required this.id,
      required this.code,
      required this.nom,
      required this.lft,
      required this.rgt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['nom'] = Variable<String>(nom);
    map['lft'] = Variable<int>(lft);
    map['rgt'] = Variable<int>(rgt);
    return map;
  }

  ComptesCompanion toCompanion(bool nullToAbsent) {
    return ComptesCompanion(
      id: Value(id),
      code: Value(code),
      nom: Value(nom),
      lft: Value(lft),
      rgt: Value(rgt),
    );
  }

  factory Compte.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Compte(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      nom: serializer.fromJson<String>(json['nom']),
      lft: serializer.fromJson<int>(json['lft']),
      rgt: serializer.fromJson<int>(json['rgt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'nom': serializer.toJson<String>(nom),
      'lft': serializer.toJson<int>(lft),
      'rgt': serializer.toJson<int>(rgt),
    };
  }

  Compte copyWith({int? id, String? code, String? nom, int? lft, int? rgt}) =>
      Compte(
        id: id ?? this.id,
        code: code ?? this.code,
        nom: nom ?? this.nom,
        lft: lft ?? this.lft,
        rgt: rgt ?? this.rgt,
      );
  Compte copyWithCompanion(ComptesCompanion data) {
    return Compte(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      nom: data.nom.present ? data.nom.value : this.nom,
      lft: data.lft.present ? data.lft.value : this.lft,
      rgt: data.rgt.present ? data.rgt.value : this.rgt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Compte(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nom: $nom, ')
          ..write('lft: $lft, ')
          ..write('rgt: $rgt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, nom, lft, rgt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Compte &&
          other.id == this.id &&
          other.code == this.code &&
          other.nom == this.nom &&
          other.lft == this.lft &&
          other.rgt == this.rgt);
}

class ComptesCompanion extends UpdateCompanion<Compte> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> nom;
  final Value<int> lft;
  final Value<int> rgt;
  const ComptesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.nom = const Value.absent(),
    this.lft = const Value.absent(),
    this.rgt = const Value.absent(),
  });
  ComptesCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String nom,
    required int lft,
    required int rgt,
  })  : code = Value(code),
        nom = Value(nom),
        lft = Value(lft),
        rgt = Value(rgt);
  static Insertable<Compte> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? nom,
    Expression<int>? lft,
    Expression<int>? rgt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (nom != null) 'nom': nom,
      if (lft != null) 'lft': lft,
      if (rgt != null) 'rgt': rgt,
    });
  }

  ComptesCompanion copyWith(
      {Value<int>? id,
      Value<String>? code,
      Value<String>? nom,
      Value<int>? lft,
      Value<int>? rgt}) {
    return ComptesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      nom: nom ?? this.nom,
      lft: lft ?? this.lft,
      rgt: rgt ?? this.rgt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (lft.present) {
      map['lft'] = Variable<int>(lft.value);
    }
    if (rgt.present) {
      map['rgt'] = Variable<int>(rgt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComptesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nom: $nom, ')
          ..write('lft: $lft, ')
          ..write('rgt: $rgt')
          ..write(')'))
        .toString();
  }
}

class $EcrituresTable extends Ecritures
    with TableInfo<$EcrituresTable, Ecriture> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EcrituresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid.v4());
  static const VerificationMeta _companyIdMeta =
      const VerificationMeta('companyId');
  @override
  late final GeneratedColumn<String> companyId = GeneratedColumn<String>(
      'company_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES companies(id)');
  static const VerificationMeta _currencyIdMeta =
      const VerificationMeta('currencyId');
  @override
  late final GeneratedColumn<String> currencyId = GeneratedColumn<String>(
      'currency_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NULLABLE REFERENCES currencies(id)');
  static const VerificationMeta _libelleMeta =
      const VerificationMeta('libelle');
  @override
  late final GeneratedColumn<String> libelle = GeneratedColumn<String>(
      'libelle', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 500),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _statutMeta = const VerificationMeta('statut');
  @override
  late final GeneratedColumn<String> statut = GeneratedColumn<String>(
      'statut', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('BROUILLON'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        companyId,
        currencyId,
        libelle,
        reference,
        date,
        isDeleted,
        statut,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ecritures';
  @override
  VerificationContext validateIntegrity(Insertable<Ecriture> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('company_id')) {
      context.handle(_companyIdMeta,
          companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta));
    } else if (isInserting) {
      context.missing(_companyIdMeta);
    }
    if (data.containsKey('currency_id')) {
      context.handle(
          _currencyIdMeta,
          currencyId.isAcceptableOrUnknown(
              data['currency_id']!, _currencyIdMeta));
    }
    if (data.containsKey('libelle')) {
      context.handle(_libelleMeta,
          libelle.isAcceptableOrUnknown(data['libelle']!, _libelleMeta));
    } else if (isInserting) {
      context.missing(_libelleMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('statut')) {
      context.handle(_statutMeta,
          statut.isAcceptableOrUnknown(data['statut']!, _statutMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ecriture map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ecriture(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      companyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}company_id'])!,
      currencyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_id']),
      libelle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}libelle'])!,
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      statut: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}statut'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $EcrituresTable createAlias(String alias) {
    return $EcrituresTable(attachedDatabase, alias);
  }
}

class Ecriture extends DataClass implements Insertable<Ecriture> {
  final String id;
  final String companyId;
  final String? currencyId;
  final String libelle;
  final String? reference;
  final DateTime? date;
  final bool isDeleted;
  final String statut;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const Ecriture(
      {required this.id,
      required this.companyId,
      this.currencyId,
      required this.libelle,
      this.reference,
      this.date,
      required this.isDeleted,
      required this.statut,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['company_id'] = Variable<String>(companyId);
    if (!nullToAbsent || currencyId != null) {
      map['currency_id'] = Variable<String>(currencyId);
    }
    map['libelle'] = Variable<String>(libelle);
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['statut'] = Variable<String>(statut);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  EcrituresCompanion toCompanion(bool nullToAbsent) {
    return EcrituresCompanion(
      id: Value(id),
      companyId: Value(companyId),
      currencyId: currencyId == null && nullToAbsent
          ? const Value.absent()
          : Value(currencyId),
      libelle: Value(libelle),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      isDeleted: Value(isDeleted),
      statut: Value(statut),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Ecriture.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ecriture(
      id: serializer.fromJson<String>(json['id']),
      companyId: serializer.fromJson<String>(json['companyId']),
      currencyId: serializer.fromJson<String?>(json['currencyId']),
      libelle: serializer.fromJson<String>(json['libelle']),
      reference: serializer.fromJson<String?>(json['reference']),
      date: serializer.fromJson<DateTime?>(json['date']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      statut: serializer.fromJson<String>(json['statut']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'companyId': serializer.toJson<String>(companyId),
      'currencyId': serializer.toJson<String?>(currencyId),
      'libelle': serializer.toJson<String>(libelle),
      'reference': serializer.toJson<String?>(reference),
      'date': serializer.toJson<DateTime?>(date),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'statut': serializer.toJson<String>(statut),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Ecriture copyWith(
          {String? id,
          String? companyId,
          Value<String?> currencyId = const Value.absent(),
          String? libelle,
          Value<String?> reference = const Value.absent(),
          Value<DateTime?> date = const Value.absent(),
          bool? isDeleted,
          String? statut,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      Ecriture(
        id: id ?? this.id,
        companyId: companyId ?? this.companyId,
        currencyId: currencyId.present ? currencyId.value : this.currencyId,
        libelle: libelle ?? this.libelle,
        reference: reference.present ? reference.value : this.reference,
        date: date.present ? date.value : this.date,
        isDeleted: isDeleted ?? this.isDeleted,
        statut: statut ?? this.statut,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  Ecriture copyWithCompanion(EcrituresCompanion data) {
    return Ecriture(
      id: data.id.present ? data.id.value : this.id,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      currencyId:
          data.currencyId.present ? data.currencyId.value : this.currencyId,
      libelle: data.libelle.present ? data.libelle.value : this.libelle,
      reference: data.reference.present ? data.reference.value : this.reference,
      date: data.date.present ? data.date.value : this.date,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      statut: data.statut.present ? data.statut.value : this.statut,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ecriture(')
          ..write('id: $id, ')
          ..write('companyId: $companyId, ')
          ..write('currencyId: $currencyId, ')
          ..write('libelle: $libelle, ')
          ..write('reference: $reference, ')
          ..write('date: $date, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('statut: $statut, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, companyId, currencyId, libelle, reference,
      date, isDeleted, statut, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ecriture &&
          other.id == this.id &&
          other.companyId == this.companyId &&
          other.currencyId == this.currencyId &&
          other.libelle == this.libelle &&
          other.reference == this.reference &&
          other.date == this.date &&
          other.isDeleted == this.isDeleted &&
          other.statut == this.statut &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EcrituresCompanion extends UpdateCompanion<Ecriture> {
  final Value<String> id;
  final Value<String> companyId;
  final Value<String?> currencyId;
  final Value<String> libelle;
  final Value<String?> reference;
  final Value<DateTime?> date;
  final Value<bool> isDeleted;
  final Value<String> statut;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const EcrituresCompanion({
    this.id = const Value.absent(),
    this.companyId = const Value.absent(),
    this.currencyId = const Value.absent(),
    this.libelle = const Value.absent(),
    this.reference = const Value.absent(),
    this.date = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.statut = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EcrituresCompanion.insert({
    this.id = const Value.absent(),
    required String companyId,
    this.currencyId = const Value.absent(),
    required String libelle,
    this.reference = const Value.absent(),
    this.date = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.statut = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : companyId = Value(companyId),
        libelle = Value(libelle);
  static Insertable<Ecriture> custom({
    Expression<String>? id,
    Expression<String>? companyId,
    Expression<String>? currencyId,
    Expression<String>? libelle,
    Expression<String>? reference,
    Expression<DateTime>? date,
    Expression<bool>? isDeleted,
    Expression<String>? statut,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (companyId != null) 'company_id': companyId,
      if (currencyId != null) 'currency_id': currencyId,
      if (libelle != null) 'libelle': libelle,
      if (reference != null) 'reference': reference,
      if (date != null) 'date': date,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (statut != null) 'statut': statut,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EcrituresCompanion copyWith(
      {Value<String>? id,
      Value<String>? companyId,
      Value<String?>? currencyId,
      Value<String>? libelle,
      Value<String?>? reference,
      Value<DateTime?>? date,
      Value<bool>? isDeleted,
      Value<String>? statut,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return EcrituresCompanion(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      currencyId: currencyId ?? this.currencyId,
      libelle: libelle ?? this.libelle,
      reference: reference ?? this.reference,
      date: date ?? this.date,
      isDeleted: isDeleted ?? this.isDeleted,
      statut: statut ?? this.statut,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<String>(companyId.value);
    }
    if (currencyId.present) {
      map['currency_id'] = Variable<String>(currencyId.value);
    }
    if (libelle.present) {
      map['libelle'] = Variable<String>(libelle.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (statut.present) {
      map['statut'] = Variable<String>(statut.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EcrituresCompanion(')
          ..write('id: $id, ')
          ..write('companyId: $companyId, ')
          ..write('currencyId: $currencyId, ')
          ..write('libelle: $libelle, ')
          ..write('reference: $reference, ')
          ..write('date: $date, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('statut: $statut, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LigneEcrituresTable extends LigneEcritures
    with TableInfo<$LigneEcrituresTable, LigneEcriture> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LigneEcrituresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid.v4());
  static const VerificationMeta _ecritureIdMeta =
      const VerificationMeta('ecritureId');
  @override
  late final GeneratedColumn<String> ecritureId = GeneratedColumn<String>(
      'ecriture_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES ecritures(id)');
  static const VerificationMeta _compteIdMeta =
      const VerificationMeta('compteId');
  @override
  late final GeneratedColumn<int> compteId = GeneratedColumn<int>(
      'compte_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES comptes(id)');
  static const VerificationMeta _debitMeta = const VerificationMeta('debit');
  @override
  late final GeneratedColumn<int> debit = GeneratedColumn<int>(
      'debit', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _creditMeta = const VerificationMeta('credit');
  @override
  late final GeneratedColumn<int> credit = GeneratedColumn<int>(
      'credit', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, ecritureId, compteId, debit, credit, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ligne_ecritures';
  @override
  VerificationContext validateIntegrity(Insertable<LigneEcriture> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ecriture_id')) {
      context.handle(
          _ecritureIdMeta,
          ecritureId.isAcceptableOrUnknown(
              data['ecriture_id']!, _ecritureIdMeta));
    } else if (isInserting) {
      context.missing(_ecritureIdMeta);
    }
    if (data.containsKey('compte_id')) {
      context.handle(_compteIdMeta,
          compteId.isAcceptableOrUnknown(data['compte_id']!, _compteIdMeta));
    } else if (isInserting) {
      context.missing(_compteIdMeta);
    }
    if (data.containsKey('debit')) {
      context.handle(
          _debitMeta, debit.isAcceptableOrUnknown(data['debit']!, _debitMeta));
    }
    if (data.containsKey('credit')) {
      context.handle(_creditMeta,
          credit.isAcceptableOrUnknown(data['credit']!, _creditMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LigneEcriture map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LigneEcriture(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ecritureId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ecriture_id'])!,
      compteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}compte_id'])!,
      debit: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}debit'])!,
      credit: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}credit'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
    );
  }

  @override
  $LigneEcrituresTable createAlias(String alias) {
    return $LigneEcrituresTable(attachedDatabase, alias);
  }
}

class LigneEcriture extends DataClass implements Insertable<LigneEcriture> {
  final String id;
  final String ecritureId;
  final int compteId;
  final int debit;
  final int credit;
  final String? description;
  const LigneEcriture(
      {required this.id,
      required this.ecritureId,
      required this.compteId,
      required this.debit,
      required this.credit,
      this.description});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['ecriture_id'] = Variable<String>(ecritureId);
    map['compte_id'] = Variable<int>(compteId);
    map['debit'] = Variable<int>(debit);
    map['credit'] = Variable<int>(credit);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  LigneEcrituresCompanion toCompanion(bool nullToAbsent) {
    return LigneEcrituresCompanion(
      id: Value(id),
      ecritureId: Value(ecritureId),
      compteId: Value(compteId),
      debit: Value(debit),
      credit: Value(credit),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory LigneEcriture.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LigneEcriture(
      id: serializer.fromJson<String>(json['id']),
      ecritureId: serializer.fromJson<String>(json['ecritureId']),
      compteId: serializer.fromJson<int>(json['compteId']),
      debit: serializer.fromJson<int>(json['debit']),
      credit: serializer.fromJson<int>(json['credit']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ecritureId': serializer.toJson<String>(ecritureId),
      'compteId': serializer.toJson<int>(compteId),
      'debit': serializer.toJson<int>(debit),
      'credit': serializer.toJson<int>(credit),
      'description': serializer.toJson<String?>(description),
    };
  }

  LigneEcriture copyWith(
          {String? id,
          String? ecritureId,
          int? compteId,
          int? debit,
          int? credit,
          Value<String?> description = const Value.absent()}) =>
      LigneEcriture(
        id: id ?? this.id,
        ecritureId: ecritureId ?? this.ecritureId,
        compteId: compteId ?? this.compteId,
        debit: debit ?? this.debit,
        credit: credit ?? this.credit,
        description: description.present ? description.value : this.description,
      );
  LigneEcriture copyWithCompanion(LigneEcrituresCompanion data) {
    return LigneEcriture(
      id: data.id.present ? data.id.value : this.id,
      ecritureId:
          data.ecritureId.present ? data.ecritureId.value : this.ecritureId,
      compteId: data.compteId.present ? data.compteId.value : this.compteId,
      debit: data.debit.present ? data.debit.value : this.debit,
      credit: data.credit.present ? data.credit.value : this.credit,
      description:
          data.description.present ? data.description.value : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LigneEcriture(')
          ..write('id: $id, ')
          ..write('ecritureId: $ecritureId, ')
          ..write('compteId: $compteId, ')
          ..write('debit: $debit, ')
          ..write('credit: $credit, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ecritureId, compteId, debit, credit, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LigneEcriture &&
          other.id == this.id &&
          other.ecritureId == this.ecritureId &&
          other.compteId == this.compteId &&
          other.debit == this.debit &&
          other.credit == this.credit &&
          other.description == this.description);
}

class LigneEcrituresCompanion extends UpdateCompanion<LigneEcriture> {
  final Value<String> id;
  final Value<String> ecritureId;
  final Value<int> compteId;
  final Value<int> debit;
  final Value<int> credit;
  final Value<String?> description;
  final Value<int> rowid;
  const LigneEcrituresCompanion({
    this.id = const Value.absent(),
    this.ecritureId = const Value.absent(),
    this.compteId = const Value.absent(),
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LigneEcrituresCompanion.insert({
    this.id = const Value.absent(),
    required String ecritureId,
    required int compteId,
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : ecritureId = Value(ecritureId),
        compteId = Value(compteId);
  static Insertable<LigneEcriture> custom({
    Expression<String>? id,
    Expression<String>? ecritureId,
    Expression<int>? compteId,
    Expression<int>? debit,
    Expression<int>? credit,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ecritureId != null) 'ecriture_id': ecritureId,
      if (compteId != null) 'compte_id': compteId,
      if (debit != null) 'debit': debit,
      if (credit != null) 'credit': credit,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LigneEcrituresCompanion copyWith(
      {Value<String>? id,
      Value<String>? ecritureId,
      Value<int>? compteId,
      Value<int>? debit,
      Value<int>? credit,
      Value<String?>? description,
      Value<int>? rowid}) {
    return LigneEcrituresCompanion(
      id: id ?? this.id,
      ecritureId: ecritureId ?? this.ecritureId,
      compteId: compteId ?? this.compteId,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ecritureId.present) {
      map['ecriture_id'] = Variable<String>(ecritureId.value);
    }
    if (compteId.present) {
      map['compte_id'] = Variable<int>(compteId.value);
    }
    if (debit.present) {
      map['debit'] = Variable<int>(debit.value);
    }
    if (credit.present) {
      map['credit'] = Variable<int>(credit.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LigneEcrituresCompanion(')
          ..write('id: $id, ')
          ..write('ecritureId: $ecritureId, ')
          ..write('compteId: $compteId, ')
          ..write('debit: $debit, ')
          ..write('credit: $credit, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttachmentsTable extends Attachments
    with TableInfo<$AttachmentsTable, Attachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid.v4());
  static const VerificationMeta _ecritureIdMeta =
      const VerificationMeta('ecritureId');
  @override
  late final GeneratedColumn<String> ecritureId = GeneratedColumn<String>(
      'ecriture_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES ecritures(id)');
  static const VerificationMeta _filenameMeta =
      const VerificationMeta('filename');
  @override
  late final GeneratedColumn<String> filename = GeneratedColumn<String>(
      'filename', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mimeMeta = const VerificationMeta('mime');
  @override
  late final GeneratedColumn<String> mime = GeneratedColumn<String>(
      'mime', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
      'size', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns =>
      [id, ecritureId, filename, path, mime, size, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attachments';
  @override
  VerificationContext validateIntegrity(Insertable<Attachment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ecriture_id')) {
      context.handle(
          _ecritureIdMeta,
          ecritureId.isAcceptableOrUnknown(
              data['ecriture_id']!, _ecritureIdMeta));
    } else if (isInserting) {
      context.missing(_ecritureIdMeta);
    }
    if (data.containsKey('filename')) {
      context.handle(_filenameMeta,
          filename.isAcceptableOrUnknown(data['filename']!, _filenameMeta));
    } else if (isInserting) {
      context.missing(_filenameMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('mime')) {
      context.handle(
          _mimeMeta, mime.isAcceptableOrUnknown(data['mime']!, _mimeMeta));
    }
    if (data.containsKey('size')) {
      context.handle(
          _sizeMeta, size.isAcceptableOrUnknown(data['size']!, _sizeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attachment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      ecritureId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ecriture_id'])!,
      filename: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}filename'])!,
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      mime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mime']),
      size: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}size']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AttachmentsTable createAlias(String alias) {
    return $AttachmentsTable(attachedDatabase, alias);
  }
}

class Attachment extends DataClass implements Insertable<Attachment> {
  final String id;
  final String ecritureId;
  final String filename;
  final String path;
  final String? mime;
  final int? size;
  final DateTime createdAt;
  const Attachment(
      {required this.id,
      required this.ecritureId,
      required this.filename,
      required this.path,
      this.mime,
      this.size,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['ecriture_id'] = Variable<String>(ecritureId);
    map['filename'] = Variable<String>(filename);
    map['path'] = Variable<String>(path);
    if (!nullToAbsent || mime != null) {
      map['mime'] = Variable<String>(mime);
    }
    if (!nullToAbsent || size != null) {
      map['size'] = Variable<int>(size);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AttachmentsCompanion toCompanion(bool nullToAbsent) {
    return AttachmentsCompanion(
      id: Value(id),
      ecritureId: Value(ecritureId),
      filename: Value(filename),
      path: Value(path),
      mime: mime == null && nullToAbsent ? const Value.absent() : Value(mime),
      size: size == null && nullToAbsent ? const Value.absent() : Value(size),
      createdAt: Value(createdAt),
    );
  }

  factory Attachment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attachment(
      id: serializer.fromJson<String>(json['id']),
      ecritureId: serializer.fromJson<String>(json['ecritureId']),
      filename: serializer.fromJson<String>(json['filename']),
      path: serializer.fromJson<String>(json['path']),
      mime: serializer.fromJson<String?>(json['mime']),
      size: serializer.fromJson<int?>(json['size']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ecritureId': serializer.toJson<String>(ecritureId),
      'filename': serializer.toJson<String>(filename),
      'path': serializer.toJson<String>(path),
      'mime': serializer.toJson<String?>(mime),
      'size': serializer.toJson<int?>(size),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Attachment copyWith(
          {String? id,
          String? ecritureId,
          String? filename,
          String? path,
          Value<String?> mime = const Value.absent(),
          Value<int?> size = const Value.absent(),
          DateTime? createdAt}) =>
      Attachment(
        id: id ?? this.id,
        ecritureId: ecritureId ?? this.ecritureId,
        filename: filename ?? this.filename,
        path: path ?? this.path,
        mime: mime.present ? mime.value : this.mime,
        size: size.present ? size.value : this.size,
        createdAt: createdAt ?? this.createdAt,
      );
  Attachment copyWithCompanion(AttachmentsCompanion data) {
    return Attachment(
      id: data.id.present ? data.id.value : this.id,
      ecritureId:
          data.ecritureId.present ? data.ecritureId.value : this.ecritureId,
      filename: data.filename.present ? data.filename.value : this.filename,
      path: data.path.present ? data.path.value : this.path,
      mime: data.mime.present ? data.mime.value : this.mime,
      size: data.size.present ? data.size.value : this.size,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attachment(')
          ..write('id: $id, ')
          ..write('ecritureId: $ecritureId, ')
          ..write('filename: $filename, ')
          ..write('path: $path, ')
          ..write('mime: $mime, ')
          ..write('size: $size, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ecritureId, filename, path, mime, size, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attachment &&
          other.id == this.id &&
          other.ecritureId == this.ecritureId &&
          other.filename == this.filename &&
          other.path == this.path &&
          other.mime == this.mime &&
          other.size == this.size &&
          other.createdAt == this.createdAt);
}

class AttachmentsCompanion extends UpdateCompanion<Attachment> {
  final Value<String> id;
  final Value<String> ecritureId;
  final Value<String> filename;
  final Value<String> path;
  final Value<String?> mime;
  final Value<int?> size;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AttachmentsCompanion({
    this.id = const Value.absent(),
    this.ecritureId = const Value.absent(),
    this.filename = const Value.absent(),
    this.path = const Value.absent(),
    this.mime = const Value.absent(),
    this.size = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttachmentsCompanion.insert({
    this.id = const Value.absent(),
    required String ecritureId,
    required String filename,
    required String path,
    this.mime = const Value.absent(),
    this.size = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : ecritureId = Value(ecritureId),
        filename = Value(filename),
        path = Value(path);
  static Insertable<Attachment> custom({
    Expression<String>? id,
    Expression<String>? ecritureId,
    Expression<String>? filename,
    Expression<String>? path,
    Expression<String>? mime,
    Expression<int>? size,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ecritureId != null) 'ecriture_id': ecritureId,
      if (filename != null) 'filename': filename,
      if (path != null) 'path': path,
      if (mime != null) 'mime': mime,
      if (size != null) 'size': size,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttachmentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? ecritureId,
      Value<String>? filename,
      Value<String>? path,
      Value<String?>? mime,
      Value<int?>? size,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return AttachmentsCompanion(
      id: id ?? this.id,
      ecritureId: ecritureId ?? this.ecritureId,
      filename: filename ?? this.filename,
      path: path ?? this.path,
      mime: mime ?? this.mime,
      size: size ?? this.size,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ecritureId.present) {
      map['ecriture_id'] = Variable<String>(ecritureId.value);
    }
    if (filename.present) {
      map['filename'] = Variable<String>(filename.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (mime.present) {
      map['mime'] = Variable<String>(mime.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('ecritureId: $ecritureId, ')
          ..write('filename: $filename, ')
          ..write('path: $path, ')
          ..write('mime: $mime, ')
          ..write('size: $size, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogsTable extends AuditLogs
    with TableInfo<$AuditLogsTable, AuditLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
      'entity', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _detailsMeta =
      const VerificationMeta('details');
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
      'details', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns =>
      [id, entity, entityId, action, details, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_logs';
  @override
  VerificationContext validateIntegrity(Insertable<AuditLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity')) {
      context.handle(_entityMeta,
          entity.isAcceptableOrUnknown(data['entity']!, _entityMeta));
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('details')) {
      context.handle(_detailsMeta,
          details.isAcceptableOrUnknown(data['details']!, _detailsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      entity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id']),
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      details: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}details']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AuditLogsTable createAlias(String alias) {
    return $AuditLogsTable(attachedDatabase, alias);
  }
}

class AuditLog extends DataClass implements Insertable<AuditLog> {
  final int id;
  final String entity;
  final String? entityId;
  final String action;
  final String? details;
  final DateTime createdAt;
  const AuditLog(
      {required this.id,
      required this.entity,
      this.entityId,
      required this.action,
      this.details,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity'] = Variable<String>(entity);
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<String>(entityId);
    }
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AuditLogsCompanion toCompanion(bool nullToAbsent) {
    return AuditLogsCompanion(
      id: Value(id),
      entity: Value(entity),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      action: Value(action),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
      createdAt: Value(createdAt),
    );
  }

  factory AuditLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLog(
      id: serializer.fromJson<int>(json['id']),
      entity: serializer.fromJson<String>(json['entity']),
      entityId: serializer.fromJson<String?>(json['entityId']),
      action: serializer.fromJson<String>(json['action']),
      details: serializer.fromJson<String?>(json['details']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entity': serializer.toJson<String>(entity),
      'entityId': serializer.toJson<String?>(entityId),
      'action': serializer.toJson<String>(action),
      'details': serializer.toJson<String?>(details),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AuditLog copyWith(
          {int? id,
          String? entity,
          Value<String?> entityId = const Value.absent(),
          String? action,
          Value<String?> details = const Value.absent(),
          DateTime? createdAt}) =>
      AuditLog(
        id: id ?? this.id,
        entity: entity ?? this.entity,
        entityId: entityId.present ? entityId.value : this.entityId,
        action: action ?? this.action,
        details: details.present ? details.value : this.details,
        createdAt: createdAt ?? this.createdAt,
      );
  AuditLog copyWithCompanion(AuditLogsCompanion data) {
    return AuditLog(
      id: data.id.present ? data.id.value : this.id,
      entity: data.entity.present ? data.entity.value : this.entity,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      action: data.action.present ? data.action.value : this.action,
      details: data.details.present ? data.details.value : this.details,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLog(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('details: $details, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, entity, entityId, action, details, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLog &&
          other.id == this.id &&
          other.entity == this.entity &&
          other.entityId == this.entityId &&
          other.action == this.action &&
          other.details == this.details &&
          other.createdAt == this.createdAt);
}

class AuditLogsCompanion extends UpdateCompanion<AuditLog> {
  final Value<int> id;
  final Value<String> entity;
  final Value<String?> entityId;
  final Value<String> action;
  final Value<String?> details;
  final Value<DateTime> createdAt;
  const AuditLogsCompanion({
    this.id = const Value.absent(),
    this.entity = const Value.absent(),
    this.entityId = const Value.absent(),
    this.action = const Value.absent(),
    this.details = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AuditLogsCompanion.insert({
    this.id = const Value.absent(),
    required String entity,
    this.entityId = const Value.absent(),
    required String action,
    this.details = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : entity = Value(entity),
        action = Value(action);
  static Insertable<AuditLog> custom({
    Expression<int>? id,
    Expression<String>? entity,
    Expression<String>? entityId,
    Expression<String>? action,
    Expression<String>? details,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entity != null) 'entity': entity,
      if (entityId != null) 'entity_id': entityId,
      if (action != null) 'action': action,
      if (details != null) 'details': details,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AuditLogsCompanion copyWith(
      {Value<int>? id,
      Value<String>? entity,
      Value<String?>? entityId,
      Value<String>? action,
      Value<String?>? details,
      Value<DateTime>? createdAt}) {
    return AuditLogsCompanion(
      id: id ?? this.id,
      entity: entity ?? this.entity,
      entityId: entityId ?? this.entityId,
      action: action ?? this.action,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogsCompanion(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('details: $details, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TauxChangeTable extends TauxChange
    with TableInfo<$TauxChangeTable, TauxChangeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TauxChangeTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _deviseSourceMeta =
      const VerificationMeta('deviseSource');
  @override
  late final GeneratedColumn<String> deviseSource = GeneratedColumn<String>(
      'devise_source', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES currencies(code)');
  static const VerificationMeta _deviseCibleMeta =
      const VerificationMeta('deviseCible');
  @override
  late final GeneratedColumn<String> deviseCible = GeneratedColumn<String>(
      'devise_cible', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES currencies(code)');
  static const VerificationMeta _tauxAchatMeta =
      const VerificationMeta('tauxAchat');
  @override
  late final GeneratedColumn<double> tauxAchat = GeneratedColumn<double>(
      'taux_achat', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _tauxVenteMeta =
      const VerificationMeta('tauxVente');
  @override
  late final GeneratedColumn<double> tauxVente = GeneratedColumn<double>(
      'taux_vente', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateDebutMeta =
      const VerificationMeta('dateDebut');
  @override
  late final GeneratedColumn<DateTime> dateDebut = GeneratedColumn<DateTime>(
      'date_debut', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dateFinMeta =
      const VerificationMeta('dateFin');
  @override
  late final GeneratedColumn<DateTime> dateFin = GeneratedColumn<DateTime>(
      'date_fin', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _dateModificationMeta =
      const VerificationMeta('dateModification');
  @override
  late final GeneratedColumn<DateTime> dateModification =
      GeneratedColumn<DateTime>('date_modification', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        deviseSource,
        deviseCible,
        tauxAchat,
        tauxVente,
        dateDebut,
        dateFin,
        dateModification
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'taux_change';
  @override
  VerificationContext validateIntegrity(Insertable<TauxChangeData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('devise_source')) {
      context.handle(
          _deviseSourceMeta,
          deviseSource.isAcceptableOrUnknown(
              data['devise_source']!, _deviseSourceMeta));
    } else if (isInserting) {
      context.missing(_deviseSourceMeta);
    }
    if (data.containsKey('devise_cible')) {
      context.handle(
          _deviseCibleMeta,
          deviseCible.isAcceptableOrUnknown(
              data['devise_cible']!, _deviseCibleMeta));
    } else if (isInserting) {
      context.missing(_deviseCibleMeta);
    }
    if (data.containsKey('taux_achat')) {
      context.handle(_tauxAchatMeta,
          tauxAchat.isAcceptableOrUnknown(data['taux_achat']!, _tauxAchatMeta));
    } else if (isInserting) {
      context.missing(_tauxAchatMeta);
    }
    if (data.containsKey('taux_vente')) {
      context.handle(_tauxVenteMeta,
          tauxVente.isAcceptableOrUnknown(data['taux_vente']!, _tauxVenteMeta));
    } else if (isInserting) {
      context.missing(_tauxVenteMeta);
    }
    if (data.containsKey('date_debut')) {
      context.handle(_dateDebutMeta,
          dateDebut.isAcceptableOrUnknown(data['date_debut']!, _dateDebutMeta));
    } else if (isInserting) {
      context.missing(_dateDebutMeta);
    }
    if (data.containsKey('date_fin')) {
      context.handle(_dateFinMeta,
          dateFin.isAcceptableOrUnknown(data['date_fin']!, _dateFinMeta));
    }
    if (data.containsKey('date_modification')) {
      context.handle(
          _dateModificationMeta,
          dateModification.isAcceptableOrUnknown(
              data['date_modification']!, _dateModificationMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TauxChangeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TauxChangeData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      deviseSource: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}devise_source'])!,
      deviseCible: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}devise_cible'])!,
      tauxAchat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}taux_achat'])!,
      tauxVente: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}taux_vente'])!,
      dateDebut: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_debut'])!,
      dateFin: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_fin']),
      dateModification: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_modification'])!,
    );
  }

  @override
  $TauxChangeTable createAlias(String alias) {
    return $TauxChangeTable(attachedDatabase, alias);
  }
}

class TauxChangeData extends DataClass implements Insertable<TauxChangeData> {
  final int id;
  final String deviseSource;
  final String deviseCible;
  final double tauxAchat;
  final double tauxVente;
  final DateTime dateDebut;
  final DateTime? dateFin;
  final DateTime dateModification;
  const TauxChangeData(
      {required this.id,
      required this.deviseSource,
      required this.deviseCible,
      required this.tauxAchat,
      required this.tauxVente,
      required this.dateDebut,
      this.dateFin,
      required this.dateModification});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['devise_source'] = Variable<String>(deviseSource);
    map['devise_cible'] = Variable<String>(deviseCible);
    map['taux_achat'] = Variable<double>(tauxAchat);
    map['taux_vente'] = Variable<double>(tauxVente);
    map['date_debut'] = Variable<DateTime>(dateDebut);
    if (!nullToAbsent || dateFin != null) {
      map['date_fin'] = Variable<DateTime>(dateFin);
    }
    map['date_modification'] = Variable<DateTime>(dateModification);
    return map;
  }

  TauxChangeCompanion toCompanion(bool nullToAbsent) {
    return TauxChangeCompanion(
      id: Value(id),
      deviseSource: Value(deviseSource),
      deviseCible: Value(deviseCible),
      tauxAchat: Value(tauxAchat),
      tauxVente: Value(tauxVente),
      dateDebut: Value(dateDebut),
      dateFin: dateFin == null && nullToAbsent
          ? const Value.absent()
          : Value(dateFin),
      dateModification: Value(dateModification),
    );
  }

  factory TauxChangeData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TauxChangeData(
      id: serializer.fromJson<int>(json['id']),
      deviseSource: serializer.fromJson<String>(json['deviseSource']),
      deviseCible: serializer.fromJson<String>(json['deviseCible']),
      tauxAchat: serializer.fromJson<double>(json['tauxAchat']),
      tauxVente: serializer.fromJson<double>(json['tauxVente']),
      dateDebut: serializer.fromJson<DateTime>(json['dateDebut']),
      dateFin: serializer.fromJson<DateTime?>(json['dateFin']),
      dateModification: serializer.fromJson<DateTime>(json['dateModification']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deviseSource': serializer.toJson<String>(deviseSource),
      'deviseCible': serializer.toJson<String>(deviseCible),
      'tauxAchat': serializer.toJson<double>(tauxAchat),
      'tauxVente': serializer.toJson<double>(tauxVente),
      'dateDebut': serializer.toJson<DateTime>(dateDebut),
      'dateFin': serializer.toJson<DateTime?>(dateFin),
      'dateModification': serializer.toJson<DateTime>(dateModification),
    };
  }

  TauxChangeData copyWith(
          {int? id,
          String? deviseSource,
          String? deviseCible,
          double? tauxAchat,
          double? tauxVente,
          DateTime? dateDebut,
          Value<DateTime?> dateFin = const Value.absent(),
          DateTime? dateModification}) =>
      TauxChangeData(
        id: id ?? this.id,
        deviseSource: deviseSource ?? this.deviseSource,
        deviseCible: deviseCible ?? this.deviseCible,
        tauxAchat: tauxAchat ?? this.tauxAchat,
        tauxVente: tauxVente ?? this.tauxVente,
        dateDebut: dateDebut ?? this.dateDebut,
        dateFin: dateFin.present ? dateFin.value : this.dateFin,
        dateModification: dateModification ?? this.dateModification,
      );
  TauxChangeData copyWithCompanion(TauxChangeCompanion data) {
    return TauxChangeData(
      id: data.id.present ? data.id.value : this.id,
      deviseSource: data.deviseSource.present
          ? data.deviseSource.value
          : this.deviseSource,
      deviseCible:
          data.deviseCible.present ? data.deviseCible.value : this.deviseCible,
      tauxAchat: data.tauxAchat.present ? data.tauxAchat.value : this.tauxAchat,
      tauxVente: data.tauxVente.present ? data.tauxVente.value : this.tauxVente,
      dateDebut: data.dateDebut.present ? data.dateDebut.value : this.dateDebut,
      dateFin: data.dateFin.present ? data.dateFin.value : this.dateFin,
      dateModification: data.dateModification.present
          ? data.dateModification.value
          : this.dateModification,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TauxChangeData(')
          ..write('id: $id, ')
          ..write('deviseSource: $deviseSource, ')
          ..write('deviseCible: $deviseCible, ')
          ..write('tauxAchat: $tauxAchat, ')
          ..write('tauxVente: $tauxVente, ')
          ..write('dateDebut: $dateDebut, ')
          ..write('dateFin: $dateFin, ')
          ..write('dateModification: $dateModification')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, deviseSource, deviseCible, tauxAchat,
      tauxVente, dateDebut, dateFin, dateModification);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TauxChangeData &&
          other.id == this.id &&
          other.deviseSource == this.deviseSource &&
          other.deviseCible == this.deviseCible &&
          other.tauxAchat == this.tauxAchat &&
          other.tauxVente == this.tauxVente &&
          other.dateDebut == this.dateDebut &&
          other.dateFin == this.dateFin &&
          other.dateModification == this.dateModification);
}

class TauxChangeCompanion extends UpdateCompanion<TauxChangeData> {
  final Value<int> id;
  final Value<String> deviseSource;
  final Value<String> deviseCible;
  final Value<double> tauxAchat;
  final Value<double> tauxVente;
  final Value<DateTime> dateDebut;
  final Value<DateTime?> dateFin;
  final Value<DateTime> dateModification;
  const TauxChangeCompanion({
    this.id = const Value.absent(),
    this.deviseSource = const Value.absent(),
    this.deviseCible = const Value.absent(),
    this.tauxAchat = const Value.absent(),
    this.tauxVente = const Value.absent(),
    this.dateDebut = const Value.absent(),
    this.dateFin = const Value.absent(),
    this.dateModification = const Value.absent(),
  });
  TauxChangeCompanion.insert({
    this.id = const Value.absent(),
    required String deviseSource,
    required String deviseCible,
    required double tauxAchat,
    required double tauxVente,
    required DateTime dateDebut,
    this.dateFin = const Value.absent(),
    this.dateModification = const Value.absent(),
  })  : deviseSource = Value(deviseSource),
        deviseCible = Value(deviseCible),
        tauxAchat = Value(tauxAchat),
        tauxVente = Value(tauxVente),
        dateDebut = Value(dateDebut);
  static Insertable<TauxChangeData> custom({
    Expression<int>? id,
    Expression<String>? deviseSource,
    Expression<String>? deviseCible,
    Expression<double>? tauxAchat,
    Expression<double>? tauxVente,
    Expression<DateTime>? dateDebut,
    Expression<DateTime>? dateFin,
    Expression<DateTime>? dateModification,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviseSource != null) 'devise_source': deviseSource,
      if (deviseCible != null) 'devise_cible': deviseCible,
      if (tauxAchat != null) 'taux_achat': tauxAchat,
      if (tauxVente != null) 'taux_vente': tauxVente,
      if (dateDebut != null) 'date_debut': dateDebut,
      if (dateFin != null) 'date_fin': dateFin,
      if (dateModification != null) 'date_modification': dateModification,
    });
  }

  TauxChangeCompanion copyWith(
      {Value<int>? id,
      Value<String>? deviseSource,
      Value<String>? deviseCible,
      Value<double>? tauxAchat,
      Value<double>? tauxVente,
      Value<DateTime>? dateDebut,
      Value<DateTime?>? dateFin,
      Value<DateTime>? dateModification}) {
    return TauxChangeCompanion(
      id: id ?? this.id,
      deviseSource: deviseSource ?? this.deviseSource,
      deviseCible: deviseCible ?? this.deviseCible,
      tauxAchat: tauxAchat ?? this.tauxAchat,
      tauxVente: tauxVente ?? this.tauxVente,
      dateDebut: dateDebut ?? this.dateDebut,
      dateFin: dateFin ?? this.dateFin,
      dateModification: dateModification ?? this.dateModification,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deviseSource.present) {
      map['devise_source'] = Variable<String>(deviseSource.value);
    }
    if (deviseCible.present) {
      map['devise_cible'] = Variable<String>(deviseCible.value);
    }
    if (tauxAchat.present) {
      map['taux_achat'] = Variable<double>(tauxAchat.value);
    }
    if (tauxVente.present) {
      map['taux_vente'] = Variable<double>(tauxVente.value);
    }
    if (dateDebut.present) {
      map['date_debut'] = Variable<DateTime>(dateDebut.value);
    }
    if (dateFin.present) {
      map['date_fin'] = Variable<DateTime>(dateFin.value);
    }
    if (dateModification.present) {
      map['date_modification'] = Variable<DateTime>(dateModification.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TauxChangeCompanion(')
          ..write('id: $id, ')
          ..write('deviseSource: $deviseSource, ')
          ..write('deviseCible: $deviseCible, ')
          ..write('tauxAchat: $tauxAchat, ')
          ..write('tauxVente: $tauxVente, ')
          ..write('dateDebut: $dateDebut, ')
          ..write('dateFin: $dateFin, ')
          ..write('dateModification: $dateModification')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CompaniesTable companies = $CompaniesTable(this);
  late final $CurrenciesTable currencies = $CurrenciesTable(this);
  late final $ExchangeRatesTable exchangeRates = $ExchangeRatesTable(this);
  late final $SequencesTable sequences = $SequencesTable(this);
  late final $ComptesTable comptes = $ComptesTable(this);
  late final $EcrituresTable ecritures = $EcrituresTable(this);
  late final $LigneEcrituresTable ligneEcritures = $LigneEcrituresTable(this);
  late final $AttachmentsTable attachments = $AttachmentsTable(this);
  late final $AuditLogsTable auditLogs = $AuditLogsTable(this);
  late final $TauxChangeTable tauxChange = $TauxChangeTable(this);
  late final TauxChangeDao tauxChangeDao = TauxChangeDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        companies,
        currencies,
        exchangeRates,
        sequences,
        comptes,
        ecritures,
        ligneEcritures,
        attachments,
        auditLogs,
        tauxChange
      ];
}

typedef $$CompaniesTableCreateCompanionBuilder = CompaniesCompanion Function({
  Value<String> id,
  required String name,
  Value<String?> taxNumber,
  Value<String?> currencyDefault,
  Value<bool> active,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$CompaniesTableUpdateCompanionBuilder = CompaniesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> taxNumber,
  Value<String?> currencyDefault,
  Value<bool> active,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

final class $$CompaniesTableReferences
    extends BaseReferences<_$AppDatabase, $CompaniesTable, Company> {
  $$CompaniesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EcrituresTable, List<Ecriture>>
      _ecrituresRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.ecritures,
          aliasName:
              $_aliasNameGenerator(db.companies.id, db.ecritures.companyId));

  $$EcrituresTableProcessedTableManager get ecrituresRefs {
    final manager = $$EcrituresTableTableManager($_db, $_db.ecritures)
        .filter((f) => f.companyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ecrituresRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CompaniesTableFilterComposer
    extends Composer<_$AppDatabase, $CompaniesTable> {
  $$CompaniesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taxNumber => $composableBuilder(
      column: $table.taxNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currencyDefault => $composableBuilder(
      column: $table.currencyDefault,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> ecrituresRefs(
      Expression<bool> Function($$EcrituresTableFilterComposer f) f) {
    final $$EcrituresTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ecritures,
        getReferencedColumn: (t) => t.companyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EcrituresTableFilterComposer(
              $db: $db,
              $table: $db.ecritures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CompaniesTableOrderingComposer
    extends Composer<_$AppDatabase, $CompaniesTable> {
  $$CompaniesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taxNumber => $composableBuilder(
      column: $table.taxNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currencyDefault => $composableBuilder(
      column: $table.currencyDefault,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CompaniesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompaniesTable> {
  $$CompaniesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get taxNumber =>
      $composableBuilder(column: $table.taxNumber, builder: (column) => column);

  GeneratedColumn<String> get currencyDefault => $composableBuilder(
      column: $table.currencyDefault, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> ecrituresRefs<T extends Object>(
      Expression<T> Function($$EcrituresTableAnnotationComposer a) f) {
    final $$EcrituresTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ecritures,
        getReferencedColumn: (t) => t.companyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EcrituresTableAnnotationComposer(
              $db: $db,
              $table: $db.ecritures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CompaniesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CompaniesTable,
    Company,
    $$CompaniesTableFilterComposer,
    $$CompaniesTableOrderingComposer,
    $$CompaniesTableAnnotationComposer,
    $$CompaniesTableCreateCompanionBuilder,
    $$CompaniesTableUpdateCompanionBuilder,
    (Company, $$CompaniesTableReferences),
    Company,
    PrefetchHooks Function({bool ecrituresRefs})> {
  $$CompaniesTableTableManager(_$AppDatabase db, $CompaniesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompaniesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompaniesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompaniesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> taxNumber = const Value.absent(),
            Value<String?> currencyDefault = const Value.absent(),
            Value<bool> active = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CompaniesCompanion(
            id: id,
            name: name,
            taxNumber: taxNumber,
            currencyDefault: currencyDefault,
            active: active,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            Value<String?> taxNumber = const Value.absent(),
            Value<String?> currencyDefault = const Value.absent(),
            Value<bool> active = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CompaniesCompanion.insert(
            id: id,
            name: name,
            taxNumber: taxNumber,
            currencyDefault: currencyDefault,
            active: active,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CompaniesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({ecrituresRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ecrituresRefs) db.ecritures],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ecrituresRefs)
                    await $_getPrefetchedData<Company, $CompaniesTable,
                            Ecriture>(
                        currentTable: table,
                        referencedTable:
                            $$CompaniesTableReferences._ecrituresRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CompaniesTableReferences(db, table, p0)
                                .ecrituresRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.companyId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CompaniesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CompaniesTable,
    Company,
    $$CompaniesTableFilterComposer,
    $$CompaniesTableOrderingComposer,
    $$CompaniesTableAnnotationComposer,
    $$CompaniesTableCreateCompanionBuilder,
    $$CompaniesTableUpdateCompanionBuilder,
    (Company, $$CompaniesTableReferences),
    Company,
    PrefetchHooks Function({bool ecrituresRefs})>;
typedef $$CurrenciesTableCreateCompanionBuilder = CurrenciesCompanion Function({
  Value<String> id,
  required String code,
  Value<String?> name,
  Value<int> rowid,
});
typedef $$CurrenciesTableUpdateCompanionBuilder = CurrenciesCompanion Function({
  Value<String> id,
  Value<String> code,
  Value<String?> name,
  Value<int> rowid,
});

class $$CurrenciesTableFilterComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));
}

class $$CurrenciesTableOrderingComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$CurrenciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$CurrenciesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CurrenciesTable,
    Currency,
    $$CurrenciesTableFilterComposer,
    $$CurrenciesTableOrderingComposer,
    $$CurrenciesTableAnnotationComposer,
    $$CurrenciesTableCreateCompanionBuilder,
    $$CurrenciesTableUpdateCompanionBuilder,
    (Currency, BaseReferences<_$AppDatabase, $CurrenciesTable, Currency>),
    Currency,
    PrefetchHooks Function()> {
  $$CurrenciesTableTableManager(_$AppDatabase db, $CurrenciesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurrenciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurrenciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurrenciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CurrenciesCompanion(
            id: id,
            code: code,
            name: name,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String code,
            Value<String?> name = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CurrenciesCompanion.insert(
            id: id,
            code: code,
            name: name,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CurrenciesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CurrenciesTable,
    Currency,
    $$CurrenciesTableFilterComposer,
    $$CurrenciesTableOrderingComposer,
    $$CurrenciesTableAnnotationComposer,
    $$CurrenciesTableCreateCompanionBuilder,
    $$CurrenciesTableUpdateCompanionBuilder,
    (Currency, BaseReferences<_$AppDatabase, $CurrenciesTable, Currency>),
    Currency,
    PrefetchHooks Function()>;
typedef $$ExchangeRatesTableCreateCompanionBuilder = ExchangeRatesCompanion
    Function({
  Value<String> id,
  required String fromCurrency,
  required String toCurrency,
  required int rate,
  required DateTime date,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$ExchangeRatesTableUpdateCompanionBuilder = ExchangeRatesCompanion
    Function({
  Value<String> id,
  Value<String> fromCurrency,
  Value<String> toCurrency,
  Value<int> rate,
  Value<DateTime> date,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$ExchangeRatesTableReferences
    extends BaseReferences<_$AppDatabase, $ExchangeRatesTable, ExchangeRate> {
  $$ExchangeRatesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CurrenciesTable _fromCurrencyTable(_$AppDatabase db) =>
      db.currencies.createAlias($_aliasNameGenerator(
          db.exchangeRates.fromCurrency, db.currencies.id));

  $$CurrenciesTableProcessedTableManager get fromCurrency {
    final $_column = $_itemColumn<String>('from_currency')!;

    final manager = $$CurrenciesTableTableManager($_db, $_db.currencies)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fromCurrencyTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CurrenciesTable _toCurrencyTable(_$AppDatabase db) =>
      db.currencies.createAlias(
          $_aliasNameGenerator(db.exchangeRates.toCurrency, db.currencies.id));

  $$CurrenciesTableProcessedTableManager get toCurrency {
    final $_column = $_itemColumn<String>('to_currency')!;

    final manager = $$CurrenciesTableTableManager($_db, $_db.currencies)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toCurrencyTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ExchangeRatesTableFilterComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rate => $composableBuilder(
      column: $table.rate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CurrenciesTableFilterComposer get fromCurrency {
    final $$CurrenciesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fromCurrency,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableFilterComposer get toCurrency {
    final $$CurrenciesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toCurrency,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExchangeRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rate => $composableBuilder(
      column: $table.rate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CurrenciesTableOrderingComposer get fromCurrency {
    final $$CurrenciesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fromCurrency,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableOrderingComposer get toCurrency {
    final $$CurrenciesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toCurrency,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExchangeRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CurrenciesTableAnnotationComposer get fromCurrency {
    final $$CurrenciesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.fromCurrency,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableAnnotationComposer get toCurrency {
    final $$CurrenciesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toCurrency,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExchangeRatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExchangeRatesTable,
    ExchangeRate,
    $$ExchangeRatesTableFilterComposer,
    $$ExchangeRatesTableOrderingComposer,
    $$ExchangeRatesTableAnnotationComposer,
    $$ExchangeRatesTableCreateCompanionBuilder,
    $$ExchangeRatesTableUpdateCompanionBuilder,
    (ExchangeRate, $$ExchangeRatesTableReferences),
    ExchangeRate,
    PrefetchHooks Function({bool fromCurrency, bool toCurrency})> {
  $$ExchangeRatesTableTableManager(_$AppDatabase db, $ExchangeRatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExchangeRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExchangeRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExchangeRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> fromCurrency = const Value.absent(),
            Value<String> toCurrency = const Value.absent(),
            Value<int> rate = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExchangeRatesCompanion(
            id: id,
            fromCurrency: fromCurrency,
            toCurrency: toCurrency,
            rate: rate,
            date: date,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String fromCurrency,
            required String toCurrency,
            required int rate,
            required DateTime date,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExchangeRatesCompanion.insert(
            id: id,
            fromCurrency: fromCurrency,
            toCurrency: toCurrency,
            rate: rate,
            date: date,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExchangeRatesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({fromCurrency = false, toCurrency = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (fromCurrency) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.fromCurrency,
                    referencedTable:
                        $$ExchangeRatesTableReferences._fromCurrencyTable(db),
                    referencedColumn: $$ExchangeRatesTableReferences
                        ._fromCurrencyTable(db)
                        .id,
                  ) as T;
                }
                if (toCurrency) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.toCurrency,
                    referencedTable:
                        $$ExchangeRatesTableReferences._toCurrencyTable(db),
                    referencedColumn:
                        $$ExchangeRatesTableReferences._toCurrencyTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ExchangeRatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExchangeRatesTable,
    ExchangeRate,
    $$ExchangeRatesTableFilterComposer,
    $$ExchangeRatesTableOrderingComposer,
    $$ExchangeRatesTableAnnotationComposer,
    $$ExchangeRatesTableCreateCompanionBuilder,
    $$ExchangeRatesTableUpdateCompanionBuilder,
    (ExchangeRate, $$ExchangeRatesTableReferences),
    ExchangeRate,
    PrefetchHooks Function({bool fromCurrency, bool toCurrency})>;
typedef $$SequencesTableCreateCompanionBuilder = SequencesCompanion Function({
  Value<String> id,
  required String companyId,
  Value<String?> journalId,
  Value<int> lastNumber,
  Value<int> padding,
  Value<String?> prefix,
  Value<int> rowid,
});
typedef $$SequencesTableUpdateCompanionBuilder = SequencesCompanion Function({
  Value<String> id,
  Value<String> companyId,
  Value<String?> journalId,
  Value<int> lastNumber,
  Value<int> padding,
  Value<String?> prefix,
  Value<int> rowid,
});

class $$SequencesTableFilterComposer
    extends Composer<_$AppDatabase, $SequencesTable> {
  $$SequencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get companyId => $composableBuilder(
      column: $table.companyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get journalId => $composableBuilder(
      column: $table.journalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastNumber => $composableBuilder(
      column: $table.lastNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get padding => $composableBuilder(
      column: $table.padding, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get prefix => $composableBuilder(
      column: $table.prefix, builder: (column) => ColumnFilters(column));
}

class $$SequencesTableOrderingComposer
    extends Composer<_$AppDatabase, $SequencesTable> {
  $$SequencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get companyId => $composableBuilder(
      column: $table.companyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get journalId => $composableBuilder(
      column: $table.journalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastNumber => $composableBuilder(
      column: $table.lastNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get padding => $composableBuilder(
      column: $table.padding, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get prefix => $composableBuilder(
      column: $table.prefix, builder: (column) => ColumnOrderings(column));
}

class $$SequencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SequencesTable> {
  $$SequencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get companyId =>
      $composableBuilder(column: $table.companyId, builder: (column) => column);

  GeneratedColumn<String> get journalId =>
      $composableBuilder(column: $table.journalId, builder: (column) => column);

  GeneratedColumn<int> get lastNumber => $composableBuilder(
      column: $table.lastNumber, builder: (column) => column);

  GeneratedColumn<int> get padding =>
      $composableBuilder(column: $table.padding, builder: (column) => column);

  GeneratedColumn<String> get prefix =>
      $composableBuilder(column: $table.prefix, builder: (column) => column);
}

class $$SequencesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SequencesTable,
    Sequence,
    $$SequencesTableFilterComposer,
    $$SequencesTableOrderingComposer,
    $$SequencesTableAnnotationComposer,
    $$SequencesTableCreateCompanionBuilder,
    $$SequencesTableUpdateCompanionBuilder,
    (Sequence, BaseReferences<_$AppDatabase, $SequencesTable, Sequence>),
    Sequence,
    PrefetchHooks Function()> {
  $$SequencesTableTableManager(_$AppDatabase db, $SequencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SequencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SequencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SequencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> companyId = const Value.absent(),
            Value<String?> journalId = const Value.absent(),
            Value<int> lastNumber = const Value.absent(),
            Value<int> padding = const Value.absent(),
            Value<String?> prefix = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SequencesCompanion(
            id: id,
            companyId: companyId,
            journalId: journalId,
            lastNumber: lastNumber,
            padding: padding,
            prefix: prefix,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String companyId,
            Value<String?> journalId = const Value.absent(),
            Value<int> lastNumber = const Value.absent(),
            Value<int> padding = const Value.absent(),
            Value<String?> prefix = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SequencesCompanion.insert(
            id: id,
            companyId: companyId,
            journalId: journalId,
            lastNumber: lastNumber,
            padding: padding,
            prefix: prefix,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SequencesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SequencesTable,
    Sequence,
    $$SequencesTableFilterComposer,
    $$SequencesTableOrderingComposer,
    $$SequencesTableAnnotationComposer,
    $$SequencesTableCreateCompanionBuilder,
    $$SequencesTableUpdateCompanionBuilder,
    (Sequence, BaseReferences<_$AppDatabase, $SequencesTable, Sequence>),
    Sequence,
    PrefetchHooks Function()>;
typedef $$ComptesTableCreateCompanionBuilder = ComptesCompanion Function({
  Value<int> id,
  required String code,
  required String nom,
  required int lft,
  required int rgt,
});
typedef $$ComptesTableUpdateCompanionBuilder = ComptesCompanion Function({
  Value<int> id,
  Value<String> code,
  Value<String> nom,
  Value<int> lft,
  Value<int> rgt,
});

final class $$ComptesTableReferences
    extends BaseReferences<_$AppDatabase, $ComptesTable, Compte> {
  $$ComptesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LigneEcrituresTable, List<LigneEcriture>>
      _ligneEcrituresRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.ligneEcritures,
              aliasName: $_aliasNameGenerator(
                  db.comptes.id, db.ligneEcritures.compteId));

  $$LigneEcrituresTableProcessedTableManager get ligneEcrituresRefs {
    final manager = $$LigneEcrituresTableTableManager($_db, $_db.ligneEcritures)
        .filter((f) => f.compteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ligneEcrituresRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ComptesTableFilterComposer
    extends Composer<_$AppDatabase, $ComptesTable> {
  $$ComptesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lft => $composableBuilder(
      column: $table.lft, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rgt => $composableBuilder(
      column: $table.rgt, builder: (column) => ColumnFilters(column));

  Expression<bool> ligneEcrituresRefs(
      Expression<bool> Function($$LigneEcrituresTableFilterComposer f) f) {
    final $$LigneEcrituresTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ligneEcritures,
        getReferencedColumn: (t) => t.compteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LigneEcrituresTableFilterComposer(
              $db: $db,
              $table: $db.ligneEcritures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ComptesTableOrderingComposer
    extends Composer<_$AppDatabase, $ComptesTable> {
  $$ComptesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nom => $composableBuilder(
      column: $table.nom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lft => $composableBuilder(
      column: $table.lft, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rgt => $composableBuilder(
      column: $table.rgt, builder: (column) => ColumnOrderings(column));
}

class $$ComptesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComptesTable> {
  $$ComptesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<int> get lft =>
      $composableBuilder(column: $table.lft, builder: (column) => column);

  GeneratedColumn<int> get rgt =>
      $composableBuilder(column: $table.rgt, builder: (column) => column);

  Expression<T> ligneEcrituresRefs<T extends Object>(
      Expression<T> Function($$LigneEcrituresTableAnnotationComposer a) f) {
    final $$LigneEcrituresTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ligneEcritures,
        getReferencedColumn: (t) => t.compteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LigneEcrituresTableAnnotationComposer(
              $db: $db,
              $table: $db.ligneEcritures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ComptesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ComptesTable,
    Compte,
    $$ComptesTableFilterComposer,
    $$ComptesTableOrderingComposer,
    $$ComptesTableAnnotationComposer,
    $$ComptesTableCreateCompanionBuilder,
    $$ComptesTableUpdateCompanionBuilder,
    (Compte, $$ComptesTableReferences),
    Compte,
    PrefetchHooks Function({bool ligneEcrituresRefs})> {
  $$ComptesTableTableManager(_$AppDatabase db, $ComptesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComptesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComptesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComptesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String> nom = const Value.absent(),
            Value<int> lft = const Value.absent(),
            Value<int> rgt = const Value.absent(),
          }) =>
              ComptesCompanion(
            id: id,
            code: code,
            nom: nom,
            lft: lft,
            rgt: rgt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String code,
            required String nom,
            required int lft,
            required int rgt,
          }) =>
              ComptesCompanion.insert(
            id: id,
            code: code,
            nom: nom,
            lft: lft,
            rgt: rgt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ComptesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({ligneEcrituresRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (ligneEcrituresRefs) db.ligneEcritures
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ligneEcrituresRefs)
                    await $_getPrefetchedData<Compte, $ComptesTable,
                            LigneEcriture>(
                        currentTable: table,
                        referencedTable: $$ComptesTableReferences
                            ._ligneEcrituresRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ComptesTableReferences(db, table, p0)
                                .ligneEcrituresRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.compteId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ComptesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ComptesTable,
    Compte,
    $$ComptesTableFilterComposer,
    $$ComptesTableOrderingComposer,
    $$ComptesTableAnnotationComposer,
    $$ComptesTableCreateCompanionBuilder,
    $$ComptesTableUpdateCompanionBuilder,
    (Compte, $$ComptesTableReferences),
    Compte,
    PrefetchHooks Function({bool ligneEcrituresRefs})>;
typedef $$EcrituresTableCreateCompanionBuilder = EcrituresCompanion Function({
  Value<String> id,
  required String companyId,
  Value<String?> currencyId,
  required String libelle,
  Value<String?> reference,
  Value<DateTime?> date,
  Value<bool> isDeleted,
  Value<String> statut,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$EcrituresTableUpdateCompanionBuilder = EcrituresCompanion Function({
  Value<String> id,
  Value<String> companyId,
  Value<String?> currencyId,
  Value<String> libelle,
  Value<String?> reference,
  Value<DateTime?> date,
  Value<bool> isDeleted,
  Value<String> statut,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

final class $$EcrituresTableReferences
    extends BaseReferences<_$AppDatabase, $EcrituresTable, Ecriture> {
  $$EcrituresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CompaniesTable _companyIdTable(_$AppDatabase db) =>
      db.companies.createAlias(
          $_aliasNameGenerator(db.ecritures.companyId, db.companies.id));

  $$CompaniesTableProcessedTableManager get companyId {
    final $_column = $_itemColumn<String>('company_id')!;

    final manager = $$CompaniesTableTableManager($_db, $_db.companies)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_companyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$LigneEcrituresTable, List<LigneEcriture>>
      _ligneEcrituresRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.ligneEcritures,
              aliasName: $_aliasNameGenerator(
                  db.ecritures.id, db.ligneEcritures.ecritureId));

  $$LigneEcrituresTableProcessedTableManager get ligneEcrituresRefs {
    final manager = $$LigneEcrituresTableTableManager($_db, $_db.ligneEcritures)
        .filter((f) => f.ecritureId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ligneEcrituresRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$EcrituresTableFilterComposer
    extends Composer<_$AppDatabase, $EcrituresTable> {
  $$EcrituresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currencyId => $composableBuilder(
      column: $table.currencyId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get libelle => $composableBuilder(
      column: $table.libelle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$CompaniesTableFilterComposer get companyId {
    final $$CompaniesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.companyId,
        referencedTable: $db.companies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CompaniesTableFilterComposer(
              $db: $db,
              $table: $db.companies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> ligneEcrituresRefs(
      Expression<bool> Function($$LigneEcrituresTableFilterComposer f) f) {
    final $$LigneEcrituresTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ligneEcritures,
        getReferencedColumn: (t) => t.ecritureId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LigneEcrituresTableFilterComposer(
              $db: $db,
              $table: $db.ligneEcritures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EcrituresTableOrderingComposer
    extends Composer<_$AppDatabase, $EcrituresTable> {
  $$EcrituresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currencyId => $composableBuilder(
      column: $table.currencyId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get libelle => $composableBuilder(
      column: $table.libelle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$CompaniesTableOrderingComposer get companyId {
    final $$CompaniesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.companyId,
        referencedTable: $db.companies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CompaniesTableOrderingComposer(
              $db: $db,
              $table: $db.companies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EcrituresTableAnnotationComposer
    extends Composer<_$AppDatabase, $EcrituresTable> {
  $$EcrituresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get currencyId => $composableBuilder(
      column: $table.currencyId, builder: (column) => column);

  GeneratedColumn<String> get libelle =>
      $composableBuilder(column: $table.libelle, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get statut =>
      $composableBuilder(column: $table.statut, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CompaniesTableAnnotationComposer get companyId {
    final $$CompaniesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.companyId,
        referencedTable: $db.companies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CompaniesTableAnnotationComposer(
              $db: $db,
              $table: $db.companies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> ligneEcrituresRefs<T extends Object>(
      Expression<T> Function($$LigneEcrituresTableAnnotationComposer a) f) {
    final $$LigneEcrituresTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ligneEcritures,
        getReferencedColumn: (t) => t.ecritureId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LigneEcrituresTableAnnotationComposer(
              $db: $db,
              $table: $db.ligneEcritures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EcrituresTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EcrituresTable,
    Ecriture,
    $$EcrituresTableFilterComposer,
    $$EcrituresTableOrderingComposer,
    $$EcrituresTableAnnotationComposer,
    $$EcrituresTableCreateCompanionBuilder,
    $$EcrituresTableUpdateCompanionBuilder,
    (Ecriture, $$EcrituresTableReferences),
    Ecriture,
    PrefetchHooks Function({bool companyId, bool ligneEcrituresRefs})> {
  $$EcrituresTableTableManager(_$AppDatabase db, $EcrituresTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EcrituresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EcrituresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EcrituresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> companyId = const Value.absent(),
            Value<String?> currencyId = const Value.absent(),
            Value<String> libelle = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<DateTime?> date = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> statut = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EcrituresCompanion(
            id: id,
            companyId: companyId,
            currencyId: currencyId,
            libelle: libelle,
            reference: reference,
            date: date,
            isDeleted: isDeleted,
            statut: statut,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String companyId,
            Value<String?> currencyId = const Value.absent(),
            required String libelle,
            Value<String?> reference = const Value.absent(),
            Value<DateTime?> date = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<String> statut = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EcrituresCompanion.insert(
            id: id,
            companyId: companyId,
            currencyId: currencyId,
            libelle: libelle,
            reference: reference,
            date: date,
            isDeleted: isDeleted,
            statut: statut,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EcrituresTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {companyId = false, ligneEcrituresRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (ligneEcrituresRefs) db.ligneEcritures
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (companyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.companyId,
                    referencedTable:
                        $$EcrituresTableReferences._companyIdTable(db),
                    referencedColumn:
                        $$EcrituresTableReferences._companyIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ligneEcrituresRefs)
                    await $_getPrefetchedData<Ecriture, $EcrituresTable,
                            LigneEcriture>(
                        currentTable: table,
                        referencedTable: $$EcrituresTableReferences
                            ._ligneEcrituresRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EcrituresTableReferences(db, table, p0)
                                .ligneEcrituresRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.ecritureId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$EcrituresTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EcrituresTable,
    Ecriture,
    $$EcrituresTableFilterComposer,
    $$EcrituresTableOrderingComposer,
    $$EcrituresTableAnnotationComposer,
    $$EcrituresTableCreateCompanionBuilder,
    $$EcrituresTableUpdateCompanionBuilder,
    (Ecriture, $$EcrituresTableReferences),
    Ecriture,
    PrefetchHooks Function({bool companyId, bool ligneEcrituresRefs})>;
typedef $$LigneEcrituresTableCreateCompanionBuilder = LigneEcrituresCompanion
    Function({
  Value<String> id,
  required String ecritureId,
  required int compteId,
  Value<int> debit,
  Value<int> credit,
  Value<String?> description,
  Value<int> rowid,
});
typedef $$LigneEcrituresTableUpdateCompanionBuilder = LigneEcrituresCompanion
    Function({
  Value<String> id,
  Value<String> ecritureId,
  Value<int> compteId,
  Value<int> debit,
  Value<int> credit,
  Value<String?> description,
  Value<int> rowid,
});

final class $$LigneEcrituresTableReferences
    extends BaseReferences<_$AppDatabase, $LigneEcrituresTable, LigneEcriture> {
  $$LigneEcrituresTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $EcrituresTable _ecritureIdTable(_$AppDatabase db) =>
      db.ecritures.createAlias(
          $_aliasNameGenerator(db.ligneEcritures.ecritureId, db.ecritures.id));

  $$EcrituresTableProcessedTableManager get ecritureId {
    final $_column = $_itemColumn<String>('ecriture_id')!;

    final manager = $$EcrituresTableTableManager($_db, $_db.ecritures)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ecritureIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ComptesTable _compteIdTable(_$AppDatabase db) =>
      db.comptes.createAlias(
          $_aliasNameGenerator(db.ligneEcritures.compteId, db.comptes.id));

  $$ComptesTableProcessedTableManager get compteId {
    final $_column = $_itemColumn<int>('compte_id')!;

    final manager = $$ComptesTableTableManager($_db, $_db.comptes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_compteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LigneEcrituresTableFilterComposer
    extends Composer<_$AppDatabase, $LigneEcrituresTable> {
  $$LigneEcrituresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get debit => $composableBuilder(
      column: $table.debit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get credit => $composableBuilder(
      column: $table.credit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  $$EcrituresTableFilterComposer get ecritureId {
    final $$EcrituresTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ecritureId,
        referencedTable: $db.ecritures,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EcrituresTableFilterComposer(
              $db: $db,
              $table: $db.ecritures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ComptesTableFilterComposer get compteId {
    final $$ComptesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.compteId,
        referencedTable: $db.comptes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ComptesTableFilterComposer(
              $db: $db,
              $table: $db.comptes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LigneEcrituresTableOrderingComposer
    extends Composer<_$AppDatabase, $LigneEcrituresTable> {
  $$LigneEcrituresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get debit => $composableBuilder(
      column: $table.debit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get credit => $composableBuilder(
      column: $table.credit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  $$EcrituresTableOrderingComposer get ecritureId {
    final $$EcrituresTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ecritureId,
        referencedTable: $db.ecritures,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EcrituresTableOrderingComposer(
              $db: $db,
              $table: $db.ecritures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ComptesTableOrderingComposer get compteId {
    final $$ComptesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.compteId,
        referencedTable: $db.comptes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ComptesTableOrderingComposer(
              $db: $db,
              $table: $db.comptes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LigneEcrituresTableAnnotationComposer
    extends Composer<_$AppDatabase, $LigneEcrituresTable> {
  $$LigneEcrituresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get debit =>
      $composableBuilder(column: $table.debit, builder: (column) => column);

  GeneratedColumn<int> get credit =>
      $composableBuilder(column: $table.credit, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  $$EcrituresTableAnnotationComposer get ecritureId {
    final $$EcrituresTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ecritureId,
        referencedTable: $db.ecritures,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EcrituresTableAnnotationComposer(
              $db: $db,
              $table: $db.ecritures,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ComptesTableAnnotationComposer get compteId {
    final $$ComptesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.compteId,
        referencedTable: $db.comptes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ComptesTableAnnotationComposer(
              $db: $db,
              $table: $db.comptes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LigneEcrituresTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LigneEcrituresTable,
    LigneEcriture,
    $$LigneEcrituresTableFilterComposer,
    $$LigneEcrituresTableOrderingComposer,
    $$LigneEcrituresTableAnnotationComposer,
    $$LigneEcrituresTableCreateCompanionBuilder,
    $$LigneEcrituresTableUpdateCompanionBuilder,
    (LigneEcriture, $$LigneEcrituresTableReferences),
    LigneEcriture,
    PrefetchHooks Function({bool ecritureId, bool compteId})> {
  $$LigneEcrituresTableTableManager(
      _$AppDatabase db, $LigneEcrituresTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LigneEcrituresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LigneEcrituresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LigneEcrituresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ecritureId = const Value.absent(),
            Value<int> compteId = const Value.absent(),
            Value<int> debit = const Value.absent(),
            Value<int> credit = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LigneEcrituresCompanion(
            id: id,
            ecritureId: ecritureId,
            compteId: compteId,
            debit: debit,
            credit: credit,
            description: description,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String ecritureId,
            required int compteId,
            Value<int> debit = const Value.absent(),
            Value<int> credit = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LigneEcrituresCompanion.insert(
            id: id,
            ecritureId: ecritureId,
            compteId: compteId,
            debit: debit,
            credit: credit,
            description: description,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LigneEcrituresTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({ecritureId = false, compteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (ecritureId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.ecritureId,
                    referencedTable:
                        $$LigneEcrituresTableReferences._ecritureIdTable(db),
                    referencedColumn:
                        $$LigneEcrituresTableReferences._ecritureIdTable(db).id,
                  ) as T;
                }
                if (compteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.compteId,
                    referencedTable:
                        $$LigneEcrituresTableReferences._compteIdTable(db),
                    referencedColumn:
                        $$LigneEcrituresTableReferences._compteIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$LigneEcrituresTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LigneEcrituresTable,
    LigneEcriture,
    $$LigneEcrituresTableFilterComposer,
    $$LigneEcrituresTableOrderingComposer,
    $$LigneEcrituresTableAnnotationComposer,
    $$LigneEcrituresTableCreateCompanionBuilder,
    $$LigneEcrituresTableUpdateCompanionBuilder,
    (LigneEcriture, $$LigneEcrituresTableReferences),
    LigneEcriture,
    PrefetchHooks Function({bool ecritureId, bool compteId})>;
typedef $$AttachmentsTableCreateCompanionBuilder = AttachmentsCompanion
    Function({
  Value<String> id,
  required String ecritureId,
  required String filename,
  required String path,
  Value<String?> mime,
  Value<int?> size,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$AttachmentsTableUpdateCompanionBuilder = AttachmentsCompanion
    Function({
  Value<String> id,
  Value<String> ecritureId,
  Value<String> filename,
  Value<String> path,
  Value<String?> mime,
  Value<int?> size,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$AttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ecritureId => $composableBuilder(
      column: $table.ecritureId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filename => $composableBuilder(
      column: $table.filename, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mime => $composableBuilder(
      column: $table.mime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get size => $composableBuilder(
      column: $table.size, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$AttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ecritureId => $composableBuilder(
      column: $table.ecritureId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filename => $composableBuilder(
      column: $table.filename, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get path => $composableBuilder(
      column: $table.path, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mime => $composableBuilder(
      column: $table.mime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get size => $composableBuilder(
      column: $table.size, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$AttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ecritureId => $composableBuilder(
      column: $table.ecritureId, builder: (column) => column);

  GeneratedColumn<String> get filename =>
      $composableBuilder(column: $table.filename, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get mime =>
      $composableBuilder(column: $table.mime, builder: (column) => column);

  GeneratedColumn<int> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AttachmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AttachmentsTable,
    Attachment,
    $$AttachmentsTableFilterComposer,
    $$AttachmentsTableOrderingComposer,
    $$AttachmentsTableAnnotationComposer,
    $$AttachmentsTableCreateCompanionBuilder,
    $$AttachmentsTableUpdateCompanionBuilder,
    (Attachment, BaseReferences<_$AppDatabase, $AttachmentsTable, Attachment>),
    Attachment,
    PrefetchHooks Function()> {
  $$AttachmentsTableTableManager(_$AppDatabase db, $AttachmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> ecritureId = const Value.absent(),
            Value<String> filename = const Value.absent(),
            Value<String> path = const Value.absent(),
            Value<String?> mime = const Value.absent(),
            Value<int?> size = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AttachmentsCompanion(
            id: id,
            ecritureId: ecritureId,
            filename: filename,
            path: path,
            mime: mime,
            size: size,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String ecritureId,
            required String filename,
            required String path,
            Value<String?> mime = const Value.absent(),
            Value<int?> size = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AttachmentsCompanion.insert(
            id: id,
            ecritureId: ecritureId,
            filename: filename,
            path: path,
            mime: mime,
            size: size,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AttachmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AttachmentsTable,
    Attachment,
    $$AttachmentsTableFilterComposer,
    $$AttachmentsTableOrderingComposer,
    $$AttachmentsTableAnnotationComposer,
    $$AttachmentsTableCreateCompanionBuilder,
    $$AttachmentsTableUpdateCompanionBuilder,
    (Attachment, BaseReferences<_$AppDatabase, $AttachmentsTable, Attachment>),
    Attachment,
    PrefetchHooks Function()>;
typedef $$AuditLogsTableCreateCompanionBuilder = AuditLogsCompanion Function({
  Value<int> id,
  required String entity,
  Value<String?> entityId,
  required String action,
  Value<String?> details,
  Value<DateTime> createdAt,
});
typedef $$AuditLogsTableUpdateCompanionBuilder = AuditLogsCompanion Function({
  Value<int> id,
  Value<String> entity,
  Value<String?> entityId,
  Value<String> action,
  Value<String?> details,
  Value<DateTime> createdAt,
});

class $$AuditLogsTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entity => $composableBuilder(
      column: $table.entity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$AuditLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entity => $composableBuilder(
      column: $table.entity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$AuditLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AuditLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuditLogsTable,
    AuditLog,
    $$AuditLogsTableFilterComposer,
    $$AuditLogsTableOrderingComposer,
    $$AuditLogsTableAnnotationComposer,
    $$AuditLogsTableCreateCompanionBuilder,
    $$AuditLogsTableUpdateCompanionBuilder,
    (AuditLog, BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLog>),
    AuditLog,
    PrefetchHooks Function()> {
  $$AuditLogsTableTableManager(_$AppDatabase db, $AuditLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> entity = const Value.absent(),
            Value<String?> entityId = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String?> details = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AuditLogsCompanion(
            id: id,
            entity: entity,
            entityId: entityId,
            action: action,
            details: details,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String entity,
            Value<String?> entityId = const Value.absent(),
            required String action,
            Value<String?> details = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              AuditLogsCompanion.insert(
            id: id,
            entity: entity,
            entityId: entityId,
            action: action,
            details: details,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AuditLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AuditLogsTable,
    AuditLog,
    $$AuditLogsTableFilterComposer,
    $$AuditLogsTableOrderingComposer,
    $$AuditLogsTableAnnotationComposer,
    $$AuditLogsTableCreateCompanionBuilder,
    $$AuditLogsTableUpdateCompanionBuilder,
    (AuditLog, BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLog>),
    AuditLog,
    PrefetchHooks Function()>;
typedef $$TauxChangeTableCreateCompanionBuilder = TauxChangeCompanion Function({
  Value<int> id,
  required String deviseSource,
  required String deviseCible,
  required double tauxAchat,
  required double tauxVente,
  required DateTime dateDebut,
  Value<DateTime?> dateFin,
  Value<DateTime> dateModification,
});
typedef $$TauxChangeTableUpdateCompanionBuilder = TauxChangeCompanion Function({
  Value<int> id,
  Value<String> deviseSource,
  Value<String> deviseCible,
  Value<double> tauxAchat,
  Value<double> tauxVente,
  Value<DateTime> dateDebut,
  Value<DateTime?> dateFin,
  Value<DateTime> dateModification,
});

final class $$TauxChangeTableReferences
    extends BaseReferences<_$AppDatabase, $TauxChangeTable, TauxChangeData> {
  $$TauxChangeTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CurrenciesTable _deviseSourceTable(_$AppDatabase db) =>
      db.currencies.createAlias(
          $_aliasNameGenerator(db.tauxChange.deviseSource, db.currencies.code));

  $$CurrenciesTableProcessedTableManager get deviseSource {
    final $_column = $_itemColumn<String>('devise_source')!;

    final manager = $$CurrenciesTableTableManager($_db, $_db.currencies)
        .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deviseSourceTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CurrenciesTable _deviseCibleTable(_$AppDatabase db) =>
      db.currencies.createAlias(
          $_aliasNameGenerator(db.tauxChange.deviseCible, db.currencies.code));

  $$CurrenciesTableProcessedTableManager get deviseCible {
    final $_column = $_itemColumn<String>('devise_cible')!;

    final manager = $$CurrenciesTableTableManager($_db, $_db.currencies)
        .filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deviseCibleTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TauxChangeTableFilterComposer
    extends Composer<_$AppDatabase, $TauxChangeTable> {
  $$TauxChangeTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tauxAchat => $composableBuilder(
      column: $table.tauxAchat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tauxVente => $composableBuilder(
      column: $table.tauxVente, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateDebut => $composableBuilder(
      column: $table.dateDebut, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateFin => $composableBuilder(
      column: $table.dateFin, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateModification => $composableBuilder(
      column: $table.dateModification,
      builder: (column) => ColumnFilters(column));

  $$CurrenciesTableFilterComposer get deviseSource {
    final $$CurrenciesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deviseSource,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableFilterComposer get deviseCible {
    final $$CurrenciesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deviseCible,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TauxChangeTableOrderingComposer
    extends Composer<_$AppDatabase, $TauxChangeTable> {
  $$TauxChangeTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tauxAchat => $composableBuilder(
      column: $table.tauxAchat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tauxVente => $composableBuilder(
      column: $table.tauxVente, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateDebut => $composableBuilder(
      column: $table.dateDebut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateFin => $composableBuilder(
      column: $table.dateFin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateModification => $composableBuilder(
      column: $table.dateModification,
      builder: (column) => ColumnOrderings(column));

  $$CurrenciesTableOrderingComposer get deviseSource {
    final $$CurrenciesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deviseSource,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableOrderingComposer get deviseCible {
    final $$CurrenciesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deviseCible,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TauxChangeTableAnnotationComposer
    extends Composer<_$AppDatabase, $TauxChangeTable> {
  $$TauxChangeTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get tauxAchat =>
      $composableBuilder(column: $table.tauxAchat, builder: (column) => column);

  GeneratedColumn<double> get tauxVente =>
      $composableBuilder(column: $table.tauxVente, builder: (column) => column);

  GeneratedColumn<DateTime> get dateDebut =>
      $composableBuilder(column: $table.dateDebut, builder: (column) => column);

  GeneratedColumn<DateTime> get dateFin =>
      $composableBuilder(column: $table.dateFin, builder: (column) => column);

  GeneratedColumn<DateTime> get dateModification => $composableBuilder(
      column: $table.dateModification, builder: (column) => column);

  $$CurrenciesTableAnnotationComposer get deviseSource {
    final $$CurrenciesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deviseSource,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableAnnotationComposer get deviseCible {
    final $$CurrenciesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deviseCible,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.code,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TauxChangeTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TauxChangeTable,
    TauxChangeData,
    $$TauxChangeTableFilterComposer,
    $$TauxChangeTableOrderingComposer,
    $$TauxChangeTableAnnotationComposer,
    $$TauxChangeTableCreateCompanionBuilder,
    $$TauxChangeTableUpdateCompanionBuilder,
    (TauxChangeData, $$TauxChangeTableReferences),
    TauxChangeData,
    PrefetchHooks Function({bool deviseSource, bool deviseCible})> {
  $$TauxChangeTableTableManager(_$AppDatabase db, $TauxChangeTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TauxChangeTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TauxChangeTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TauxChangeTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> deviseSource = const Value.absent(),
            Value<String> deviseCible = const Value.absent(),
            Value<double> tauxAchat = const Value.absent(),
            Value<double> tauxVente = const Value.absent(),
            Value<DateTime> dateDebut = const Value.absent(),
            Value<DateTime?> dateFin = const Value.absent(),
            Value<DateTime> dateModification = const Value.absent(),
          }) =>
              TauxChangeCompanion(
            id: id,
            deviseSource: deviseSource,
            deviseCible: deviseCible,
            tauxAchat: tauxAchat,
            tauxVente: tauxVente,
            dateDebut: dateDebut,
            dateFin: dateFin,
            dateModification: dateModification,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String deviseSource,
            required String deviseCible,
            required double tauxAchat,
            required double tauxVente,
            required DateTime dateDebut,
            Value<DateTime?> dateFin = const Value.absent(),
            Value<DateTime> dateModification = const Value.absent(),
          }) =>
              TauxChangeCompanion.insert(
            id: id,
            deviseSource: deviseSource,
            deviseCible: deviseCible,
            tauxAchat: tauxAchat,
            tauxVente: tauxVente,
            dateDebut: dateDebut,
            dateFin: dateFin,
            dateModification: dateModification,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TauxChangeTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({deviseSource = false, deviseCible = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (deviseSource) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.deviseSource,
                    referencedTable:
                        $$TauxChangeTableReferences._deviseSourceTable(db),
                    referencedColumn:
                        $$TauxChangeTableReferences._deviseSourceTable(db).code,
                  ) as T;
                }
                if (deviseCible) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.deviseCible,
                    referencedTable:
                        $$TauxChangeTableReferences._deviseCibleTable(db),
                    referencedColumn:
                        $$TauxChangeTableReferences._deviseCibleTable(db).code,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TauxChangeTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TauxChangeTable,
    TauxChangeData,
    $$TauxChangeTableFilterComposer,
    $$TauxChangeTableOrderingComposer,
    $$TauxChangeTableAnnotationComposer,
    $$TauxChangeTableCreateCompanionBuilder,
    $$TauxChangeTableUpdateCompanionBuilder,
    (TauxChangeData, $$TauxChangeTableReferences),
    TauxChangeData,
    PrefetchHooks Function({bool deviseSource, bool deviseCible})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CompaniesTableTableManager get companies =>
      $$CompaniesTableTableManager(_db, _db.companies);
  $$CurrenciesTableTableManager get currencies =>
      $$CurrenciesTableTableManager(_db, _db.currencies);
  $$ExchangeRatesTableTableManager get exchangeRates =>
      $$ExchangeRatesTableTableManager(_db, _db.exchangeRates);
  $$SequencesTableTableManager get sequences =>
      $$SequencesTableTableManager(_db, _db.sequences);
  $$ComptesTableTableManager get comptes =>
      $$ComptesTableTableManager(_db, _db.comptes);
  $$EcrituresTableTableManager get ecritures =>
      $$EcrituresTableTableManager(_db, _db.ecritures);
  $$LigneEcrituresTableTableManager get ligneEcritures =>
      $$LigneEcrituresTableTableManager(_db, _db.ligneEcritures);
  $$AttachmentsTableTableManager get attachments =>
      $$AttachmentsTableTableManager(_db, _db.attachments);
  $$AuditLogsTableTableManager get auditLogs =>
      $$AuditLogsTableTableManager(_db, _db.auditLogs);
  $$TauxChangeTableTableManager get tauxChange =>
      $$TauxChangeTableTableManager(_db, _db.tauxChange);
}
