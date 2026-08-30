// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BusinessSettingsTableTable extends BusinessSettingsTable
    with TableInfo<$BusinessSettingsTableTable, BusinessSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _businessNameMeta =
      const VerificationMeta('businessName');
  @override
  late final GeneratedColumn<String> businessName = GeneratedColumn<String>(
      'business_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('My Restaurant'));
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _gstIdMeta = const VerificationMeta('gstId');
  @override
  late final GeneratedColumn<String> gstId = GeneratedColumn<String>(
      'gst_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _logoPathMeta =
      const VerificationMeta('logoPath');
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
      'logo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, businessName, phone, address, gstId, logoPath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'business_settings';
  @override
  VerificationContext validateIntegrity(
      Insertable<BusinessSettingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('business_name')) {
      context.handle(
          _businessNameMeta,
          businessName.isAcceptableOrUnknown(
              data['business_name']!, _businessNameMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('gst_id')) {
      context.handle(
          _gstIdMeta, gstId.isAcceptableOrUnknown(data['gst_id']!, _gstIdMeta));
    }
    if (data.containsKey('logo_path')) {
      context.handle(_logoPathMeta,
          logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BusinessSettingsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusinessSettingsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      businessName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      gstId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gst_id'])!,
      logoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_path']),
    );
  }

  @override
  $BusinessSettingsTableTable createAlias(String alias) {
    return $BusinessSettingsTableTable(attachedDatabase, alias);
  }
}

class BusinessSettingsTableData extends DataClass
    implements Insertable<BusinessSettingsTableData> {
  final int id;
  final String businessName;
  final String phone;
  final String address;
  final String gstId;
  final String? logoPath;
  const BusinessSettingsTableData(
      {required this.id,
      required this.businessName,
      required this.phone,
      required this.address,
      required this.gstId,
      this.logoPath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['business_name'] = Variable<String>(businessName);
    map['phone'] = Variable<String>(phone);
    map['address'] = Variable<String>(address);
    map['gst_id'] = Variable<String>(gstId);
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    return map;
  }

  BusinessSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return BusinessSettingsTableCompanion(
      id: Value(id),
      businessName: Value(businessName),
      phone: Value(phone),
      address: Value(address),
      gstId: Value(gstId),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
    );
  }

  factory BusinessSettingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusinessSettingsTableData(
      id: serializer.fromJson<int>(json['id']),
      businessName: serializer.fromJson<String>(json['businessName']),
      phone: serializer.fromJson<String>(json['phone']),
      address: serializer.fromJson<String>(json['address']),
      gstId: serializer.fromJson<String>(json['gstId']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'businessName': serializer.toJson<String>(businessName),
      'phone': serializer.toJson<String>(phone),
      'address': serializer.toJson<String>(address),
      'gstId': serializer.toJson<String>(gstId),
      'logoPath': serializer.toJson<String?>(logoPath),
    };
  }

  BusinessSettingsTableData copyWith(
          {int? id,
          String? businessName,
          String? phone,
          String? address,
          String? gstId,
          Value<String?> logoPath = const Value.absent()}) =>
      BusinessSettingsTableData(
        id: id ?? this.id,
        businessName: businessName ?? this.businessName,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        gstId: gstId ?? this.gstId,
        logoPath: logoPath.present ? logoPath.value : this.logoPath,
      );
  BusinessSettingsTableData copyWithCompanion(
      BusinessSettingsTableCompanion data) {
    return BusinessSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      businessName: data.businessName.present
          ? data.businessName.value
          : this.businessName,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      gstId: data.gstId.present ? data.gstId.value : this.gstId,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BusinessSettingsTableData(')
          ..write('id: $id, ')
          ..write('businessName: $businessName, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('gstId: $gstId, ')
          ..write('logoPath: $logoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, businessName, phone, address, gstId, logoPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessSettingsTableData &&
          other.id == this.id &&
          other.businessName == this.businessName &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.gstId == this.gstId &&
          other.logoPath == this.logoPath);
}

class BusinessSettingsTableCompanion
    extends UpdateCompanion<BusinessSettingsTableData> {
  final Value<int> id;
  final Value<String> businessName;
  final Value<String> phone;
  final Value<String> address;
  final Value<String> gstId;
  final Value<String?> logoPath;
  const BusinessSettingsTableCompanion({
    this.id = const Value.absent(),
    this.businessName = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.gstId = const Value.absent(),
    this.logoPath = const Value.absent(),
  });
  BusinessSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.businessName = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.gstId = const Value.absent(),
    this.logoPath = const Value.absent(),
  });
  static Insertable<BusinessSettingsTableData> custom({
    Expression<int>? id,
    Expression<String>? businessName,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? gstId,
    Expression<String>? logoPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessName != null) 'business_name': businessName,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (gstId != null) 'gst_id': gstId,
      if (logoPath != null) 'logo_path': logoPath,
    });
  }

  BusinessSettingsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? businessName,
      Value<String>? phone,
      Value<String>? address,
      Value<String>? gstId,
      Value<String?>? logoPath}) {
    return BusinessSettingsTableCompanion(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      gstId: gstId ?? this.gstId,
      logoPath: logoPath ?? this.logoPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (businessName.present) {
      map['business_name'] = Variable<String>(businessName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (gstId.present) {
      map['gst_id'] = Variable<String>(gstId.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('businessName: $businessName, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('gstId: $gstId, ')
          ..write('logoPath: $logoPath')
          ..write(')'))
        .toString();
  }
}

class $TaxSettingsTableTable extends TaxSettingsTable
    with TableInfo<$TaxSettingsTableTable, TaxSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaxSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sgstPctMeta =
      const VerificationMeta('sgstPct');
  @override
  late final GeneratedColumn<double> sgstPct = GeneratedColumn<double>(
      'sgst_pct', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(9.0));
  static const VerificationMeta _cgstPctMeta =
      const VerificationMeta('cgstPct');
  @override
  late final GeneratedColumn<double> cgstPct = GeneratedColumn<double>(
      'cgst_pct', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(9.0));
  static const VerificationMeta _igstPctMeta =
      const VerificationMeta('igstPct');
  @override
  late final GeneratedColumn<double> igstPct = GeneratedColumn<double>(
      'igst_pct', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(18.0));
  static const VerificationMeta _taxModeMeta =
      const VerificationMeta('taxMode');
  @override
  late final GeneratedColumn<String> taxMode = GeneratedColumn<String>(
      'tax_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('SGST+CGST'));
  static const VerificationMeta _taxEnabledMeta =
      const VerificationMeta('taxEnabled');
  @override
  late final GeneratedColumn<bool> taxEnabled = GeneratedColumn<bool>(
      'tax_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("tax_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, sgstPct, cgstPct, igstPct, taxMode, taxEnabled];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tax_settings';
  @override
  VerificationContext validateIntegrity(
      Insertable<TaxSettingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sgst_pct')) {
      context.handle(_sgstPctMeta,
          sgstPct.isAcceptableOrUnknown(data['sgst_pct']!, _sgstPctMeta));
    }
    if (data.containsKey('cgst_pct')) {
      context.handle(_cgstPctMeta,
          cgstPct.isAcceptableOrUnknown(data['cgst_pct']!, _cgstPctMeta));
    }
    if (data.containsKey('igst_pct')) {
      context.handle(_igstPctMeta,
          igstPct.isAcceptableOrUnknown(data['igst_pct']!, _igstPctMeta));
    }
    if (data.containsKey('tax_mode')) {
      context.handle(_taxModeMeta,
          taxMode.isAcceptableOrUnknown(data['tax_mode']!, _taxModeMeta));
    }
    if (data.containsKey('tax_enabled')) {
      context.handle(
          _taxEnabledMeta,
          taxEnabled.isAcceptableOrUnknown(
              data['tax_enabled']!, _taxEnabledMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaxSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaxSettingsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sgstPct: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sgst_pct'])!,
      cgstPct: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cgst_pct'])!,
      igstPct: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}igst_pct'])!,
      taxMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tax_mode'])!,
      taxEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}tax_enabled'])!,
    );
  }

  @override
  $TaxSettingsTableTable createAlias(String alias) {
    return $TaxSettingsTableTable(attachedDatabase, alias);
  }
}

class TaxSettingsTableData extends DataClass
    implements Insertable<TaxSettingsTableData> {
  final int id;
  final double sgstPct;
  final double cgstPct;
  final double igstPct;
  final String taxMode;
  final bool taxEnabled;
  const TaxSettingsTableData(
      {required this.id,
      required this.sgstPct,
      required this.cgstPct,
      required this.igstPct,
      required this.taxMode,
      required this.taxEnabled});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sgst_pct'] = Variable<double>(sgstPct);
    map['cgst_pct'] = Variable<double>(cgstPct);
    map['igst_pct'] = Variable<double>(igstPct);
    map['tax_mode'] = Variable<String>(taxMode);
    map['tax_enabled'] = Variable<bool>(taxEnabled);
    return map;
  }

  TaxSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return TaxSettingsTableCompanion(
      id: Value(id),
      sgstPct: Value(sgstPct),
      cgstPct: Value(cgstPct),
      igstPct: Value(igstPct),
      taxMode: Value(taxMode),
      taxEnabled: Value(taxEnabled),
    );
  }

  factory TaxSettingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaxSettingsTableData(
      id: serializer.fromJson<int>(json['id']),
      sgstPct: serializer.fromJson<double>(json['sgstPct']),
      cgstPct: serializer.fromJson<double>(json['cgstPct']),
      igstPct: serializer.fromJson<double>(json['igstPct']),
      taxMode: serializer.fromJson<String>(json['taxMode']),
      taxEnabled: serializer.fromJson<bool>(json['taxEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sgstPct': serializer.toJson<double>(sgstPct),
      'cgstPct': serializer.toJson<double>(cgstPct),
      'igstPct': serializer.toJson<double>(igstPct),
      'taxMode': serializer.toJson<String>(taxMode),
      'taxEnabled': serializer.toJson<bool>(taxEnabled),
    };
  }

  TaxSettingsTableData copyWith(
          {int? id,
          double? sgstPct,
          double? cgstPct,
          double? igstPct,
          String? taxMode,
          bool? taxEnabled}) =>
      TaxSettingsTableData(
        id: id ?? this.id,
        sgstPct: sgstPct ?? this.sgstPct,
        cgstPct: cgstPct ?? this.cgstPct,
        igstPct: igstPct ?? this.igstPct,
        taxMode: taxMode ?? this.taxMode,
        taxEnabled: taxEnabled ?? this.taxEnabled,
      );
  TaxSettingsTableData copyWithCompanion(TaxSettingsTableCompanion data) {
    return TaxSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      sgstPct: data.sgstPct.present ? data.sgstPct.value : this.sgstPct,
      cgstPct: data.cgstPct.present ? data.cgstPct.value : this.cgstPct,
      igstPct: data.igstPct.present ? data.igstPct.value : this.igstPct,
      taxMode: data.taxMode.present ? data.taxMode.value : this.taxMode,
      taxEnabled:
          data.taxEnabled.present ? data.taxEnabled.value : this.taxEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaxSettingsTableData(')
          ..write('id: $id, ')
          ..write('sgstPct: $sgstPct, ')
          ..write('cgstPct: $cgstPct, ')
          ..write('igstPct: $igstPct, ')
          ..write('taxMode: $taxMode, ')
          ..write('taxEnabled: $taxEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sgstPct, cgstPct, igstPct, taxMode, taxEnabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaxSettingsTableData &&
          other.id == this.id &&
          other.sgstPct == this.sgstPct &&
          other.cgstPct == this.cgstPct &&
          other.igstPct == this.igstPct &&
          other.taxMode == this.taxMode &&
          other.taxEnabled == this.taxEnabled);
}

class TaxSettingsTableCompanion extends UpdateCompanion<TaxSettingsTableData> {
  final Value<int> id;
  final Value<double> sgstPct;
  final Value<double> cgstPct;
  final Value<double> igstPct;
  final Value<String> taxMode;
  final Value<bool> taxEnabled;
  const TaxSettingsTableCompanion({
    this.id = const Value.absent(),
    this.sgstPct = const Value.absent(),
    this.cgstPct = const Value.absent(),
    this.igstPct = const Value.absent(),
    this.taxMode = const Value.absent(),
    this.taxEnabled = const Value.absent(),
  });
  TaxSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.sgstPct = const Value.absent(),
    this.cgstPct = const Value.absent(),
    this.igstPct = const Value.absent(),
    this.taxMode = const Value.absent(),
    this.taxEnabled = const Value.absent(),
  });
  static Insertable<TaxSettingsTableData> custom({
    Expression<int>? id,
    Expression<double>? sgstPct,
    Expression<double>? cgstPct,
    Expression<double>? igstPct,
    Expression<String>? taxMode,
    Expression<bool>? taxEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sgstPct != null) 'sgst_pct': sgstPct,
      if (cgstPct != null) 'cgst_pct': cgstPct,
      if (igstPct != null) 'igst_pct': igstPct,
      if (taxMode != null) 'tax_mode': taxMode,
      if (taxEnabled != null) 'tax_enabled': taxEnabled,
    });
  }

  TaxSettingsTableCompanion copyWith(
      {Value<int>? id,
      Value<double>? sgstPct,
      Value<double>? cgstPct,
      Value<double>? igstPct,
      Value<String>? taxMode,
      Value<bool>? taxEnabled}) {
    return TaxSettingsTableCompanion(
      id: id ?? this.id,
      sgstPct: sgstPct ?? this.sgstPct,
      cgstPct: cgstPct ?? this.cgstPct,
      igstPct: igstPct ?? this.igstPct,
      taxMode: taxMode ?? this.taxMode,
      taxEnabled: taxEnabled ?? this.taxEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sgstPct.present) {
      map['sgst_pct'] = Variable<double>(sgstPct.value);
    }
    if (cgstPct.present) {
      map['cgst_pct'] = Variable<double>(cgstPct.value);
    }
    if (igstPct.present) {
      map['igst_pct'] = Variable<double>(igstPct.value);
    }
    if (taxMode.present) {
      map['tax_mode'] = Variable<String>(taxMode.value);
    }
    if (taxEnabled.present) {
      map['tax_enabled'] = Variable<bool>(taxEnabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaxSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('sgstPct: $sgstPct, ')
          ..write('cgstPct: $cgstPct, ')
          ..write('igstPct: $igstPct, ')
          ..write('taxMode: $taxMode, ')
          ..write('taxEnabled: $taxEnabled')
          ..write(')'))
        .toString();
  }
}

class $DeliveryAppSettingsTableTable extends DeliveryAppSettingsTable
    with
        TableInfo<$DeliveryAppSettingsTableTable,
            DeliveryAppSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeliveryAppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _appNameMeta =
      const VerificationMeta('appName');
  @override
  late final GeneratedColumn<String> appName = GeneratedColumn<String>(
      'app_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _commissionPctMeta =
      const VerificationMeta('commissionPct');
  @override
  late final GeneratedColumn<double> commissionPct = GeneratedColumn<double>(
      'commission_pct', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(18.0));
  static const VerificationMeta _fixedFeeMeta =
      const VerificationMeta('fixedFee');
  @override
  late final GeneratedColumn<double> fixedFee = GeneratedColumn<double>(
      'fixed_fee', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, appName, commissionPct, fixedFee, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'delivery_app_settings';
  @override
  VerificationContext validateIntegrity(
      Insertable<DeliveryAppSettingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('app_name')) {
      context.handle(_appNameMeta,
          appName.isAcceptableOrUnknown(data['app_name']!, _appNameMeta));
    } else if (isInserting) {
      context.missing(_appNameMeta);
    }
    if (data.containsKey('commission_pct')) {
      context.handle(
          _commissionPctMeta,
          commissionPct.isAcceptableOrUnknown(
              data['commission_pct']!, _commissionPctMeta));
    }
    if (data.containsKey('fixed_fee')) {
      context.handle(_fixedFeeMeta,
          fixedFee.isAcceptableOrUnknown(data['fixed_fee']!, _fixedFeeMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeliveryAppSettingsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeliveryAppSettingsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      appName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}app_name'])!,
      commissionPct: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}commission_pct'])!,
      fixedFee: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fixed_fee'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $DeliveryAppSettingsTableTable createAlias(String alias) {
    return $DeliveryAppSettingsTableTable(attachedDatabase, alias);
  }
}

class DeliveryAppSettingsTableData extends DataClass
    implements Insertable<DeliveryAppSettingsTableData> {
  final int id;
  final String appName;
  final double commissionPct;
  final double fixedFee;
  final bool isActive;
  const DeliveryAppSettingsTableData(
      {required this.id,
      required this.appName,
      required this.commissionPct,
      required this.fixedFee,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['app_name'] = Variable<String>(appName);
    map['commission_pct'] = Variable<double>(commissionPct);
    map['fixed_fee'] = Variable<double>(fixedFee);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  DeliveryAppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return DeliveryAppSettingsTableCompanion(
      id: Value(id),
      appName: Value(appName),
      commissionPct: Value(commissionPct),
      fixedFee: Value(fixedFee),
      isActive: Value(isActive),
    );
  }

  factory DeliveryAppSettingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeliveryAppSettingsTableData(
      id: serializer.fromJson<int>(json['id']),
      appName: serializer.fromJson<String>(json['appName']),
      commissionPct: serializer.fromJson<double>(json['commissionPct']),
      fixedFee: serializer.fromJson<double>(json['fixedFee']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'appName': serializer.toJson<String>(appName),
      'commissionPct': serializer.toJson<double>(commissionPct),
      'fixedFee': serializer.toJson<double>(fixedFee),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  DeliveryAppSettingsTableData copyWith(
          {int? id,
          String? appName,
          double? commissionPct,
          double? fixedFee,
          bool? isActive}) =>
      DeliveryAppSettingsTableData(
        id: id ?? this.id,
        appName: appName ?? this.appName,
        commissionPct: commissionPct ?? this.commissionPct,
        fixedFee: fixedFee ?? this.fixedFee,
        isActive: isActive ?? this.isActive,
      );
  DeliveryAppSettingsTableData copyWithCompanion(
      DeliveryAppSettingsTableCompanion data) {
    return DeliveryAppSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      appName: data.appName.present ? data.appName.value : this.appName,
      commissionPct: data.commissionPct.present
          ? data.commissionPct.value
          : this.commissionPct,
      fixedFee: data.fixedFee.present ? data.fixedFee.value : this.fixedFee,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeliveryAppSettingsTableData(')
          ..write('id: $id, ')
          ..write('appName: $appName, ')
          ..write('commissionPct: $commissionPct, ')
          ..write('fixedFee: $fixedFee, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, appName, commissionPct, fixedFee, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeliveryAppSettingsTableData &&
          other.id == this.id &&
          other.appName == this.appName &&
          other.commissionPct == this.commissionPct &&
          other.fixedFee == this.fixedFee &&
          other.isActive == this.isActive);
}

class DeliveryAppSettingsTableCompanion
    extends UpdateCompanion<DeliveryAppSettingsTableData> {
  final Value<int> id;
  final Value<String> appName;
  final Value<double> commissionPct;
  final Value<double> fixedFee;
  final Value<bool> isActive;
  const DeliveryAppSettingsTableCompanion({
    this.id = const Value.absent(),
    this.appName = const Value.absent(),
    this.commissionPct = const Value.absent(),
    this.fixedFee = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  DeliveryAppSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    required String appName,
    this.commissionPct = const Value.absent(),
    this.fixedFee = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : appName = Value(appName);
  static Insertable<DeliveryAppSettingsTableData> custom({
    Expression<int>? id,
    Expression<String>? appName,
    Expression<double>? commissionPct,
    Expression<double>? fixedFee,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (appName != null) 'app_name': appName,
      if (commissionPct != null) 'commission_pct': commissionPct,
      if (fixedFee != null) 'fixed_fee': fixedFee,
      if (isActive != null) 'is_active': isActive,
    });
  }

  DeliveryAppSettingsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? appName,
      Value<double>? commissionPct,
      Value<double>? fixedFee,
      Value<bool>? isActive}) {
    return DeliveryAppSettingsTableCompanion(
      id: id ?? this.id,
      appName: appName ?? this.appName,
      commissionPct: commissionPct ?? this.commissionPct,
      fixedFee: fixedFee ?? this.fixedFee,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (appName.present) {
      map['app_name'] = Variable<String>(appName.value);
    }
    if (commissionPct.present) {
      map['commission_pct'] = Variable<double>(commissionPct.value);
    }
    if (fixedFee.present) {
      map['fixed_fee'] = Variable<double>(fixedFee.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeliveryAppSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('appName: $appName, ')
          ..write('commissionPct: $commissionPct, ')
          ..write('fixedFee: $fixedFee, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _colorHexMeta =
      const VerificationMeta('colorHex');
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
      'color_hex', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('#4F46E5'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, sortOrder, isActive, colorHex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
      Insertable<CategoriesTableData> instance,
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
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('color_hex')) {
      context.handle(_colorHexMeta,
          colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      colorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_hex'])!,
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoriesTableData extends DataClass
    implements Insertable<CategoriesTableData> {
  final int id;
  final String name;
  final int sortOrder;
  final bool isActive;
  final String colorHex;
  const CategoriesTableData(
      {required this.id,
      required this.name,
      required this.sortOrder,
      required this.isActive,
      required this.colorHex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    map['color_hex'] = Variable<String>(colorHex);
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      id: Value(id),
      name: Value(name),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
      colorHex: Value(colorHex),
    );
  }

  factory CategoriesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriesTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
      'colorHex': serializer.toJson<String>(colorHex),
    };
  }

  CategoriesTableData copyWith(
          {int? id,
          String? name,
          int? sortOrder,
          bool? isActive,
          String? colorHex}) =>
      CategoriesTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        sortOrder: sortOrder ?? this.sortOrder,
        isActive: isActive ?? this.isActive,
        colorHex: colorHex ?? this.colorHex,
      );
  CategoriesTableData copyWithCompanion(CategoriesTableCompanion data) {
    return CategoriesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('colorHex: $colorHex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, sortOrder, isActive, colorHex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive &&
          other.colorHex == this.colorHex);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoriesTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<String> colorHex;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.colorHex = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.colorHex = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CategoriesTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
    Expression<String>? colorHex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
      if (colorHex != null) 'color_hex': colorHex,
    });
  }

  CategoriesTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? sortOrder,
      Value<bool>? isActive,
      Value<String>? colorHex}) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      colorHex: colorHex ?? this.colorHex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('colorHex: $colorHex')
          ..write(')'))
        .toString();
  }
}

class $ItemsTableTable extends ItemsTable
    with TableInfo<$ItemsTableTable, ItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _sellingPriceMeta =
      const VerificationMeta('sellingPrice');
  @override
  late final GeneratedColumn<double> sellingPrice = GeneratedColumn<double>(
      'selling_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _costPriceMeta =
      const VerificationMeta('costPrice');
  @override
  late final GeneratedColumn<double> costPrice = GeneratedColumn<double>(
      'cost_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lowStockThresholdMeta =
      const VerificationMeta('lowStockThreshold');
  @override
  late final GeneratedColumn<int> lowStockThreshold = GeneratedColumn<int>(
      'low_stock_threshold', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  static const VerificationMeta _defaultPrepQtyMeta =
      const VerificationMeta('defaultPrepQty');
  @override
  late final GeneratedColumn<int> defaultPrepQty = GeneratedColumn<int>(
      'default_prep_qty', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isAvailableMeta =
      const VerificationMeta('isAvailable');
  @override
  late final GeneratedColumn<bool> isAvailable = GeneratedColumn<bool>(
      'is_available', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_available" IN (0, 1))'),
      defaultValue: const Constant(true));
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
  static const VerificationMeta _isBestSellerMeta =
      const VerificationMeta('isBestSeller');
  @override
  late final GeneratedColumn<bool> isBestSeller = GeneratedColumn<bool>(
      'is_best_seller', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_best_seller" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        categoryId,
        name,
        description,
        sellingPrice,
        costPrice,
        imageUrl,
        lowStockThreshold,
        defaultPrepQty,
        isAvailable,
        isDeleted,
        isBestSeller
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(Insertable<ItemsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('selling_price')) {
      context.handle(
          _sellingPriceMeta,
          sellingPrice.isAcceptableOrUnknown(
              data['selling_price']!, _sellingPriceMeta));
    } else if (isInserting) {
      context.missing(_sellingPriceMeta);
    }
    if (data.containsKey('cost_price')) {
      context.handle(_costPriceMeta,
          costPrice.isAcceptableOrUnknown(data['cost_price']!, _costPriceMeta));
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('low_stock_threshold')) {
      context.handle(
          _lowStockThresholdMeta,
          lowStockThreshold.isAcceptableOrUnknown(
              data['low_stock_threshold']!, _lowStockThresholdMeta));
    }
    if (data.containsKey('default_prep_qty')) {
      context.handle(
          _defaultPrepQtyMeta,
          defaultPrepQty.isAcceptableOrUnknown(
              data['default_prep_qty']!, _defaultPrepQtyMeta));
    }
    if (data.containsKey('is_available')) {
      context.handle(
          _isAvailableMeta,
          isAvailable.isAcceptableOrUnknown(
              data['is_available']!, _isAvailableMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('is_best_seller')) {
      context.handle(
          _isBestSellerMeta,
          isBestSeller.isAcceptableOrUnknown(
              data['is_best_seller']!, _isBestSellerMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      sellingPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}selling_price'])!,
      costPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost_price'])!,
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      lowStockThreshold: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}low_stock_threshold'])!,
      defaultPrepQty: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}default_prep_qty'])!,
      isAvailable: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_available'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      isBestSeller: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_best_seller'])!,
    );
  }

  @override
  $ItemsTableTable createAlias(String alias) {
    return $ItemsTableTable(attachedDatabase, alias);
  }
}

class ItemsTableData extends DataClass implements Insertable<ItemsTableData> {
  final int id;
  final int categoryId;
  final String name;
  final String description;
  final double sellingPrice;
  final double costPrice;
  final String? imageUrl;
  final int lowStockThreshold;
  final int defaultPrepQty;
  final bool isAvailable;
  final bool isDeleted;
  final bool isBestSeller;
  const ItemsTableData(
      {required this.id,
      required this.categoryId,
      required this.name,
      required this.description,
      required this.sellingPrice,
      required this.costPrice,
      this.imageUrl,
      required this.lowStockThreshold,
      required this.defaultPrepQty,
      required this.isAvailable,
      required this.isDeleted,
      required this.isBestSeller});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['selling_price'] = Variable<double>(sellingPrice);
    map['cost_price'] = Variable<double>(costPrice);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['low_stock_threshold'] = Variable<int>(lowStockThreshold);
    map['default_prep_qty'] = Variable<int>(defaultPrepQty);
    map['is_available'] = Variable<bool>(isAvailable);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['is_best_seller'] = Variable<bool>(isBestSeller);
    return map;
  }

  ItemsTableCompanion toCompanion(bool nullToAbsent) {
    return ItemsTableCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      name: Value(name),
      description: Value(description),
      sellingPrice: Value(sellingPrice),
      costPrice: Value(costPrice),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      lowStockThreshold: Value(lowStockThreshold),
      defaultPrepQty: Value(defaultPrepQty),
      isAvailable: Value(isAvailable),
      isDeleted: Value(isDeleted),
      isBestSeller: Value(isBestSeller),
    );
  }

  factory ItemsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemsTableData(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      sellingPrice: serializer.fromJson<double>(json['sellingPrice']),
      costPrice: serializer.fromJson<double>(json['costPrice']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      lowStockThreshold: serializer.fromJson<int>(json['lowStockThreshold']),
      defaultPrepQty: serializer.fromJson<int>(json['defaultPrepQty']),
      isAvailable: serializer.fromJson<bool>(json['isAvailable']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      isBestSeller: serializer.fromJson<bool>(json['isBestSeller']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'sellingPrice': serializer.toJson<double>(sellingPrice),
      'costPrice': serializer.toJson<double>(costPrice),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'lowStockThreshold': serializer.toJson<int>(lowStockThreshold),
      'defaultPrepQty': serializer.toJson<int>(defaultPrepQty),
      'isAvailable': serializer.toJson<bool>(isAvailable),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'isBestSeller': serializer.toJson<bool>(isBestSeller),
    };
  }

  ItemsTableData copyWith(
          {int? id,
          int? categoryId,
          String? name,
          String? description,
          double? sellingPrice,
          double? costPrice,
          Value<String?> imageUrl = const Value.absent(),
          int? lowStockThreshold,
          int? defaultPrepQty,
          bool? isAvailable,
          bool? isDeleted,
          bool? isBestSeller}) =>
      ItemsTableData(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        name: name ?? this.name,
        description: description ?? this.description,
        sellingPrice: sellingPrice ?? this.sellingPrice,
        costPrice: costPrice ?? this.costPrice,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
        lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
        defaultPrepQty: defaultPrepQty ?? this.defaultPrepQty,
        isAvailable: isAvailable ?? this.isAvailable,
        isDeleted: isDeleted ?? this.isDeleted,
        isBestSeller: isBestSeller ?? this.isBestSeller,
      );
  ItemsTableData copyWithCompanion(ItemsTableCompanion data) {
    return ItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      sellingPrice: data.sellingPrice.present
          ? data.sellingPrice.value
          : this.sellingPrice,
      costPrice: data.costPrice.present ? data.costPrice.value : this.costPrice,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      lowStockThreshold: data.lowStockThreshold.present
          ? data.lowStockThreshold.value
          : this.lowStockThreshold,
      defaultPrepQty: data.defaultPrepQty.present
          ? data.defaultPrepQty.value
          : this.defaultPrepQty,
      isAvailable:
          data.isAvailable.present ? data.isAvailable.value : this.isAvailable,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      isBestSeller: data.isBestSeller.present
          ? data.isBestSeller.value
          : this.isBestSeller,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemsTableData(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('costPrice: $costPrice, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('defaultPrepQty: $defaultPrepQty, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('isBestSeller: $isBestSeller')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      categoryId,
      name,
      description,
      sellingPrice,
      costPrice,
      imageUrl,
      lowStockThreshold,
      defaultPrepQty,
      isAvailable,
      isDeleted,
      isBestSeller);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemsTableData &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.name == this.name &&
          other.description == this.description &&
          other.sellingPrice == this.sellingPrice &&
          other.costPrice == this.costPrice &&
          other.imageUrl == this.imageUrl &&
          other.lowStockThreshold == this.lowStockThreshold &&
          other.defaultPrepQty == this.defaultPrepQty &&
          other.isAvailable == this.isAvailable &&
          other.isDeleted == this.isDeleted &&
          other.isBestSeller == this.isBestSeller);
}

class ItemsTableCompanion extends UpdateCompanion<ItemsTableData> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<String> name;
  final Value<String> description;
  final Value<double> sellingPrice;
  final Value<double> costPrice;
  final Value<String?> imageUrl;
  final Value<int> lowStockThreshold;
  final Value<int> defaultPrepQty;
  final Value<bool> isAvailable;
  final Value<bool> isDeleted;
  final Value<bool> isBestSeller;
  const ItemsTableCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.sellingPrice = const Value.absent(),
    this.costPrice = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.lowStockThreshold = const Value.absent(),
    this.defaultPrepQty = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.isBestSeller = const Value.absent(),
  });
  ItemsTableCompanion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    required String name,
    this.description = const Value.absent(),
    required double sellingPrice,
    this.costPrice = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.lowStockThreshold = const Value.absent(),
    this.defaultPrepQty = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.isBestSeller = const Value.absent(),
  })  : categoryId = Value(categoryId),
        name = Value(name),
        sellingPrice = Value(sellingPrice);
  static Insertable<ItemsTableData> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<double>? sellingPrice,
    Expression<double>? costPrice,
    Expression<String>? imageUrl,
    Expression<int>? lowStockThreshold,
    Expression<int>? defaultPrepQty,
    Expression<bool>? isAvailable,
    Expression<bool>? isDeleted,
    Expression<bool>? isBestSeller,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (sellingPrice != null) 'selling_price': sellingPrice,
      if (costPrice != null) 'cost_price': costPrice,
      if (imageUrl != null) 'image_url': imageUrl,
      if (lowStockThreshold != null) 'low_stock_threshold': lowStockThreshold,
      if (defaultPrepQty != null) 'default_prep_qty': defaultPrepQty,
      if (isAvailable != null) 'is_available': isAvailable,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (isBestSeller != null) 'is_best_seller': isBestSeller,
    });
  }

  ItemsTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? categoryId,
      Value<String>? name,
      Value<String>? description,
      Value<double>? sellingPrice,
      Value<double>? costPrice,
      Value<String?>? imageUrl,
      Value<int>? lowStockThreshold,
      Value<int>? defaultPrepQty,
      Value<bool>? isAvailable,
      Value<bool>? isDeleted,
      Value<bool>? isBestSeller}) {
    return ItemsTableCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      costPrice: costPrice ?? this.costPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      defaultPrepQty: defaultPrepQty ?? this.defaultPrepQty,
      isAvailable: isAvailable ?? this.isAvailable,
      isDeleted: isDeleted ?? this.isDeleted,
      isBestSeller: isBestSeller ?? this.isBestSeller,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sellingPrice.present) {
      map['selling_price'] = Variable<double>(sellingPrice.value);
    }
    if (costPrice.present) {
      map['cost_price'] = Variable<double>(costPrice.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (lowStockThreshold.present) {
      map['low_stock_threshold'] = Variable<int>(lowStockThreshold.value);
    }
    if (defaultPrepQty.present) {
      map['default_prep_qty'] = Variable<int>(defaultPrepQty.value);
    }
    if (isAvailable.present) {
      map['is_available'] = Variable<bool>(isAvailable.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (isBestSeller.present) {
      map['is_best_seller'] = Variable<bool>(isBestSeller.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('costPrice: $costPrice, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('defaultPrepQty: $defaultPrepQty, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('isBestSeller: $isBestSeller')
          ..write(')'))
        .toString();
  }
}

class $OrdersTableTable extends OrdersTable
    with TableInfo<$OrdersTableTable, OrdersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orderNumberMeta =
      const VerificationMeta('orderNumber');
  @override
  late final GeneratedColumn<String> orderNumber = GeneratedColumn<String>(
      'order_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderSourceMeta =
      const VerificationMeta('orderSource');
  @override
  late final GeneratedColumn<String> orderSource = GeneratedColumn<String>(
      'order_source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deliveryAppNameMeta =
      const VerificationMeta('deliveryAppName');
  @override
  late final GeneratedColumn<String> deliveryAppName = GeneratedColumn<String>(
      'delivery_app_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deliveryAppOrderIdMeta =
      const VerificationMeta('deliveryAppOrderId');
  @override
  late final GeneratedColumn<String> deliveryAppOrderId =
      GeneratedColumn<String>('delivery_app_order_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customerPhoneMeta =
      const VerificationMeta('customerPhone');
  @override
  late final GeneratedColumn<String> customerPhone = GeneratedColumn<String>(
      'customer_phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deliveryAddressMeta =
      const VerificationMeta('deliveryAddress');
  @override
  late final GeneratedColumn<String> deliveryAddress = GeneratedColumn<String>(
      'delivery_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _subtotalMeta =
      const VerificationMeta('subtotal');
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
      'subtotal', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _taxAmountMeta =
      const VerificationMeta('taxAmount');
  @override
  late final GeneratedColumn<double> taxAmount = GeneratedColumn<double>(
      'tax_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _sgstAmountMeta =
      const VerificationMeta('sgstAmount');
  @override
  late final GeneratedColumn<double> sgstAmount = GeneratedColumn<double>(
      'sgst_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _cgstAmountMeta =
      const VerificationMeta('cgstAmount');
  @override
  late final GeneratedColumn<double> cgstAmount = GeneratedColumn<double>(
      'cgst_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _discountAmountMeta =
      const VerificationMeta('discountAmount');
  @override
  late final GeneratedColumn<double> discountAmount = GeneratedColumn<double>(
      'discount_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _deliveryFeeMeta =
      const VerificationMeta('deliveryFee');
  @override
  late final GeneratedColumn<double> deliveryFee = GeneratedColumn<double>(
      'delivery_fee', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _platformFeeMeta =
      const VerificationMeta('platformFee');
  @override
  late final GeneratedColumn<double> platformFee = GeneratedColumn<double>(
      'platform_fee', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _grossAmountMeta =
      const VerificationMeta('grossAmount');
  @override
  late final GeneratedColumn<double> grossAmount = GeneratedColumn<double>(
      'gross_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _netEarningsMeta =
      const VerificationMeta('netEarnings');
  @override
  late final GeneratedColumn<double> netEarnings = GeneratedColumn<double>(
      'net_earnings', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _finalTotalMeta =
      const VerificationMeta('finalTotal');
  @override
  late final GeneratedColumn<double> finalTotal = GeneratedColumn<double>(
      'final_total', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Cash'));
  static const VerificationMeta _paymentStatusMeta =
      const VerificationMeta('paymentStatus');
  @override
  late final GeneratedColumn<String> paymentStatus = GeneratedColumn<String>(
      'payment_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Pending'));
  static const VerificationMeta _orderStatusMeta =
      const VerificationMeta('orderStatus');
  @override
  late final GeneratedColumn<String> orderStatus = GeneratedColumn<String>(
      'order_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Pending'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _invoicePathMeta =
      const VerificationMeta('invoicePath');
  @override
  late final GeneratedColumn<String> invoicePath = GeneratedColumn<String>(
      'invoice_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderNumber,
        orderSource,
        deliveryAppName,
        deliveryAppOrderId,
        customerPhone,
        deliveryAddress,
        subtotal,
        taxAmount,
        sgstAmount,
        cgstAmount,
        discountAmount,
        deliveryFee,
        platformFee,
        grossAmount,
        netEarnings,
        finalTotal,
        paymentMethod,
        paymentStatus,
        orderStatus,
        notes,
        invoicePath,
        createdAt,
        completedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(Insertable<OrdersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_number')) {
      context.handle(
          _orderNumberMeta,
          orderNumber.isAcceptableOrUnknown(
              data['order_number']!, _orderNumberMeta));
    } else if (isInserting) {
      context.missing(_orderNumberMeta);
    }
    if (data.containsKey('order_source')) {
      context.handle(
          _orderSourceMeta,
          orderSource.isAcceptableOrUnknown(
              data['order_source']!, _orderSourceMeta));
    } else if (isInserting) {
      context.missing(_orderSourceMeta);
    }
    if (data.containsKey('delivery_app_name')) {
      context.handle(
          _deliveryAppNameMeta,
          deliveryAppName.isAcceptableOrUnknown(
              data['delivery_app_name']!, _deliveryAppNameMeta));
    }
    if (data.containsKey('delivery_app_order_id')) {
      context.handle(
          _deliveryAppOrderIdMeta,
          deliveryAppOrderId.isAcceptableOrUnknown(
              data['delivery_app_order_id']!, _deliveryAppOrderIdMeta));
    }
    if (data.containsKey('customer_phone')) {
      context.handle(
          _customerPhoneMeta,
          customerPhone.isAcceptableOrUnknown(
              data['customer_phone']!, _customerPhoneMeta));
    }
    if (data.containsKey('delivery_address')) {
      context.handle(
          _deliveryAddressMeta,
          deliveryAddress.isAcceptableOrUnknown(
              data['delivery_address']!, _deliveryAddressMeta));
    }
    if (data.containsKey('subtotal')) {
      context.handle(_subtotalMeta,
          subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta));
    }
    if (data.containsKey('tax_amount')) {
      context.handle(_taxAmountMeta,
          taxAmount.isAcceptableOrUnknown(data['tax_amount']!, _taxAmountMeta));
    }
    if (data.containsKey('sgst_amount')) {
      context.handle(
          _sgstAmountMeta,
          sgstAmount.isAcceptableOrUnknown(
              data['sgst_amount']!, _sgstAmountMeta));
    }
    if (data.containsKey('cgst_amount')) {
      context.handle(
          _cgstAmountMeta,
          cgstAmount.isAcceptableOrUnknown(
              data['cgst_amount']!, _cgstAmountMeta));
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
          _discountAmountMeta,
          discountAmount.isAcceptableOrUnknown(
              data['discount_amount']!, _discountAmountMeta));
    }
    if (data.containsKey('delivery_fee')) {
      context.handle(
          _deliveryFeeMeta,
          deliveryFee.isAcceptableOrUnknown(
              data['delivery_fee']!, _deliveryFeeMeta));
    }
    if (data.containsKey('platform_fee')) {
      context.handle(
          _platformFeeMeta,
          platformFee.isAcceptableOrUnknown(
              data['platform_fee']!, _platformFeeMeta));
    }
    if (data.containsKey('gross_amount')) {
      context.handle(
          _grossAmountMeta,
          grossAmount.isAcceptableOrUnknown(
              data['gross_amount']!, _grossAmountMeta));
    }
    if (data.containsKey('net_earnings')) {
      context.handle(
          _netEarningsMeta,
          netEarnings.isAcceptableOrUnknown(
              data['net_earnings']!, _netEarningsMeta));
    }
    if (data.containsKey('final_total')) {
      context.handle(
          _finalTotalMeta,
          finalTotal.isAcceptableOrUnknown(
              data['final_total']!, _finalTotalMeta));
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('payment_status')) {
      context.handle(
          _paymentStatusMeta,
          paymentStatus.isAcceptableOrUnknown(
              data['payment_status']!, _paymentStatusMeta));
    }
    if (data.containsKey('order_status')) {
      context.handle(
          _orderStatusMeta,
          orderStatus.isAcceptableOrUnknown(
              data['order_status']!, _orderStatusMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('invoice_path')) {
      context.handle(
          _invoicePathMeta,
          invoicePath.isAcceptableOrUnknown(
              data['invoice_path']!, _invoicePathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrdersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrdersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_number'])!,
      orderSource: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_source'])!,
      deliveryAppName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}delivery_app_name']),
      deliveryAppOrderId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}delivery_app_order_id']),
      customerPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_phone']),
      deliveryAddress: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}delivery_address']),
      subtotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}subtotal'])!,
      taxAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tax_amount'])!,
      sgstAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sgst_amount'])!,
      cgstAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cgst_amount'])!,
      discountAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}discount_amount'])!,
      deliveryFee: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}delivery_fee'])!,
      platformFee: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}platform_fee'])!,
      grossAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}gross_amount'])!,
      netEarnings: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}net_earnings'])!,
      finalTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}final_total'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      paymentStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_status'])!,
      orderStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      invoicePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
    );
  }

  @override
  $OrdersTableTable createAlias(String alias) {
    return $OrdersTableTable(attachedDatabase, alias);
  }
}

class OrdersTableData extends DataClass implements Insertable<OrdersTableData> {
  final int id;
  final String orderNumber;
  final String orderSource;
  final String? deliveryAppName;
  final String? deliveryAppOrderId;
  final String? customerPhone;
  final String? deliveryAddress;
  final double subtotal;
  final double taxAmount;
  final double sgstAmount;
  final double cgstAmount;
  final double discountAmount;
  final double deliveryFee;
  final double platformFee;
  final double grossAmount;
  final double netEarnings;
  final double finalTotal;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final String notes;
  final String? invoicePath;
  final DateTime createdAt;
  final DateTime? completedAt;
  const OrdersTableData(
      {required this.id,
      required this.orderNumber,
      required this.orderSource,
      this.deliveryAppName,
      this.deliveryAppOrderId,
      this.customerPhone,
      this.deliveryAddress,
      required this.subtotal,
      required this.taxAmount,
      required this.sgstAmount,
      required this.cgstAmount,
      required this.discountAmount,
      required this.deliveryFee,
      required this.platformFee,
      required this.grossAmount,
      required this.netEarnings,
      required this.finalTotal,
      required this.paymentMethod,
      required this.paymentStatus,
      required this.orderStatus,
      required this.notes,
      this.invoicePath,
      required this.createdAt,
      this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_number'] = Variable<String>(orderNumber);
    map['order_source'] = Variable<String>(orderSource);
    if (!nullToAbsent || deliveryAppName != null) {
      map['delivery_app_name'] = Variable<String>(deliveryAppName);
    }
    if (!nullToAbsent || deliveryAppOrderId != null) {
      map['delivery_app_order_id'] = Variable<String>(deliveryAppOrderId);
    }
    if (!nullToAbsent || customerPhone != null) {
      map['customer_phone'] = Variable<String>(customerPhone);
    }
    if (!nullToAbsent || deliveryAddress != null) {
      map['delivery_address'] = Variable<String>(deliveryAddress);
    }
    map['subtotal'] = Variable<double>(subtotal);
    map['tax_amount'] = Variable<double>(taxAmount);
    map['sgst_amount'] = Variable<double>(sgstAmount);
    map['cgst_amount'] = Variable<double>(cgstAmount);
    map['discount_amount'] = Variable<double>(discountAmount);
    map['delivery_fee'] = Variable<double>(deliveryFee);
    map['platform_fee'] = Variable<double>(platformFee);
    map['gross_amount'] = Variable<double>(grossAmount);
    map['net_earnings'] = Variable<double>(netEarnings);
    map['final_total'] = Variable<double>(finalTotal);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['payment_status'] = Variable<String>(paymentStatus);
    map['order_status'] = Variable<String>(orderStatus);
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || invoicePath != null) {
      map['invoice_path'] = Variable<String>(invoicePath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  OrdersTableCompanion toCompanion(bool nullToAbsent) {
    return OrdersTableCompanion(
      id: Value(id),
      orderNumber: Value(orderNumber),
      orderSource: Value(orderSource),
      deliveryAppName: deliveryAppName == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveryAppName),
      deliveryAppOrderId: deliveryAppOrderId == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveryAppOrderId),
      customerPhone: customerPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(customerPhone),
      deliveryAddress: deliveryAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveryAddress),
      subtotal: Value(subtotal),
      taxAmount: Value(taxAmount),
      sgstAmount: Value(sgstAmount),
      cgstAmount: Value(cgstAmount),
      discountAmount: Value(discountAmount),
      deliveryFee: Value(deliveryFee),
      platformFee: Value(platformFee),
      grossAmount: Value(grossAmount),
      netEarnings: Value(netEarnings),
      finalTotal: Value(finalTotal),
      paymentMethod: Value(paymentMethod),
      paymentStatus: Value(paymentStatus),
      orderStatus: Value(orderStatus),
      notes: Value(notes),
      invoicePath: invoicePath == null && nullToAbsent
          ? const Value.absent()
          : Value(invoicePath),
      createdAt: Value(createdAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory OrdersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrdersTableData(
      id: serializer.fromJson<int>(json['id']),
      orderNumber: serializer.fromJson<String>(json['orderNumber']),
      orderSource: serializer.fromJson<String>(json['orderSource']),
      deliveryAppName: serializer.fromJson<String?>(json['deliveryAppName']),
      deliveryAppOrderId:
          serializer.fromJson<String?>(json['deliveryAppOrderId']),
      customerPhone: serializer.fromJson<String?>(json['customerPhone']),
      deliveryAddress: serializer.fromJson<String?>(json['deliveryAddress']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      taxAmount: serializer.fromJson<double>(json['taxAmount']),
      sgstAmount: serializer.fromJson<double>(json['sgstAmount']),
      cgstAmount: serializer.fromJson<double>(json['cgstAmount']),
      discountAmount: serializer.fromJson<double>(json['discountAmount']),
      deliveryFee: serializer.fromJson<double>(json['deliveryFee']),
      platformFee: serializer.fromJson<double>(json['platformFee']),
      grossAmount: serializer.fromJson<double>(json['grossAmount']),
      netEarnings: serializer.fromJson<double>(json['netEarnings']),
      finalTotal: serializer.fromJson<double>(json['finalTotal']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      paymentStatus: serializer.fromJson<String>(json['paymentStatus']),
      orderStatus: serializer.fromJson<String>(json['orderStatus']),
      notes: serializer.fromJson<String>(json['notes']),
      invoicePath: serializer.fromJson<String?>(json['invoicePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderNumber': serializer.toJson<String>(orderNumber),
      'orderSource': serializer.toJson<String>(orderSource),
      'deliveryAppName': serializer.toJson<String?>(deliveryAppName),
      'deliveryAppOrderId': serializer.toJson<String?>(deliveryAppOrderId),
      'customerPhone': serializer.toJson<String?>(customerPhone),
      'deliveryAddress': serializer.toJson<String?>(deliveryAddress),
      'subtotal': serializer.toJson<double>(subtotal),
      'taxAmount': serializer.toJson<double>(taxAmount),
      'sgstAmount': serializer.toJson<double>(sgstAmount),
      'cgstAmount': serializer.toJson<double>(cgstAmount),
      'discountAmount': serializer.toJson<double>(discountAmount),
      'deliveryFee': serializer.toJson<double>(deliveryFee),
      'platformFee': serializer.toJson<double>(platformFee),
      'grossAmount': serializer.toJson<double>(grossAmount),
      'netEarnings': serializer.toJson<double>(netEarnings),
      'finalTotal': serializer.toJson<double>(finalTotal),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'paymentStatus': serializer.toJson<String>(paymentStatus),
      'orderStatus': serializer.toJson<String>(orderStatus),
      'notes': serializer.toJson<String>(notes),
      'invoicePath': serializer.toJson<String?>(invoicePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  OrdersTableData copyWith(
          {int? id,
          String? orderNumber,
          String? orderSource,
          Value<String?> deliveryAppName = const Value.absent(),
          Value<String?> deliveryAppOrderId = const Value.absent(),
          Value<String?> customerPhone = const Value.absent(),
          Value<String?> deliveryAddress = const Value.absent(),
          double? subtotal,
          double? taxAmount,
          double? sgstAmount,
          double? cgstAmount,
          double? discountAmount,
          double? deliveryFee,
          double? platformFee,
          double? grossAmount,
          double? netEarnings,
          double? finalTotal,
          String? paymentMethod,
          String? paymentStatus,
          String? orderStatus,
          String? notes,
          Value<String?> invoicePath = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> completedAt = const Value.absent()}) =>
      OrdersTableData(
        id: id ?? this.id,
        orderNumber: orderNumber ?? this.orderNumber,
        orderSource: orderSource ?? this.orderSource,
        deliveryAppName: deliveryAppName.present
            ? deliveryAppName.value
            : this.deliveryAppName,
        deliveryAppOrderId: deliveryAppOrderId.present
            ? deliveryAppOrderId.value
            : this.deliveryAppOrderId,
        customerPhone:
            customerPhone.present ? customerPhone.value : this.customerPhone,
        deliveryAddress: deliveryAddress.present
            ? deliveryAddress.value
            : this.deliveryAddress,
        subtotal: subtotal ?? this.subtotal,
        taxAmount: taxAmount ?? this.taxAmount,
        sgstAmount: sgstAmount ?? this.sgstAmount,
        cgstAmount: cgstAmount ?? this.cgstAmount,
        discountAmount: discountAmount ?? this.discountAmount,
        deliveryFee: deliveryFee ?? this.deliveryFee,
        platformFee: platformFee ?? this.platformFee,
        grossAmount: grossAmount ?? this.grossAmount,
        netEarnings: netEarnings ?? this.netEarnings,
        finalTotal: finalTotal ?? this.finalTotal,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        orderStatus: orderStatus ?? this.orderStatus,
        notes: notes ?? this.notes,
        invoicePath: invoicePath.present ? invoicePath.value : this.invoicePath,
        createdAt: createdAt ?? this.createdAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
      );
  OrdersTableData copyWithCompanion(OrdersTableCompanion data) {
    return OrdersTableData(
      id: data.id.present ? data.id.value : this.id,
      orderNumber:
          data.orderNumber.present ? data.orderNumber.value : this.orderNumber,
      orderSource:
          data.orderSource.present ? data.orderSource.value : this.orderSource,
      deliveryAppName: data.deliveryAppName.present
          ? data.deliveryAppName.value
          : this.deliveryAppName,
      deliveryAppOrderId: data.deliveryAppOrderId.present
          ? data.deliveryAppOrderId.value
          : this.deliveryAppOrderId,
      customerPhone: data.customerPhone.present
          ? data.customerPhone.value
          : this.customerPhone,
      deliveryAddress: data.deliveryAddress.present
          ? data.deliveryAddress.value
          : this.deliveryAddress,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      taxAmount: data.taxAmount.present ? data.taxAmount.value : this.taxAmount,
      sgstAmount:
          data.sgstAmount.present ? data.sgstAmount.value : this.sgstAmount,
      cgstAmount:
          data.cgstAmount.present ? data.cgstAmount.value : this.cgstAmount,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      deliveryFee:
          data.deliveryFee.present ? data.deliveryFee.value : this.deliveryFee,
      platformFee:
          data.platformFee.present ? data.platformFee.value : this.platformFee,
      grossAmount:
          data.grossAmount.present ? data.grossAmount.value : this.grossAmount,
      netEarnings:
          data.netEarnings.present ? data.netEarnings.value : this.netEarnings,
      finalTotal:
          data.finalTotal.present ? data.finalTotal.value : this.finalTotal,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      paymentStatus: data.paymentStatus.present
          ? data.paymentStatus.value
          : this.paymentStatus,
      orderStatus:
          data.orderStatus.present ? data.orderStatus.value : this.orderStatus,
      notes: data.notes.present ? data.notes.value : this.notes,
      invoicePath:
          data.invoicePath.present ? data.invoicePath.value : this.invoicePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrdersTableData(')
          ..write('id: $id, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('orderSource: $orderSource, ')
          ..write('deliveryAppName: $deliveryAppName, ')
          ..write('deliveryAppOrderId: $deliveryAppOrderId, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('deliveryAddress: $deliveryAddress, ')
          ..write('subtotal: $subtotal, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('sgstAmount: $sgstAmount, ')
          ..write('cgstAmount: $cgstAmount, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('deliveryFee: $deliveryFee, ')
          ..write('platformFee: $platformFee, ')
          ..write('grossAmount: $grossAmount, ')
          ..write('netEarnings: $netEarnings, ')
          ..write('finalTotal: $finalTotal, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('orderStatus: $orderStatus, ')
          ..write('notes: $notes, ')
          ..write('invoicePath: $invoicePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        orderNumber,
        orderSource,
        deliveryAppName,
        deliveryAppOrderId,
        customerPhone,
        deliveryAddress,
        subtotal,
        taxAmount,
        sgstAmount,
        cgstAmount,
        discountAmount,
        deliveryFee,
        platformFee,
        grossAmount,
        netEarnings,
        finalTotal,
        paymentMethod,
        paymentStatus,
        orderStatus,
        notes,
        invoicePath,
        createdAt,
        completedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrdersTableData &&
          other.id == this.id &&
          other.orderNumber == this.orderNumber &&
          other.orderSource == this.orderSource &&
          other.deliveryAppName == this.deliveryAppName &&
          other.deliveryAppOrderId == this.deliveryAppOrderId &&
          other.customerPhone == this.customerPhone &&
          other.deliveryAddress == this.deliveryAddress &&
          other.subtotal == this.subtotal &&
          other.taxAmount == this.taxAmount &&
          other.sgstAmount == this.sgstAmount &&
          other.cgstAmount == this.cgstAmount &&
          other.discountAmount == this.discountAmount &&
          other.deliveryFee == this.deliveryFee &&
          other.platformFee == this.platformFee &&
          other.grossAmount == this.grossAmount &&
          other.netEarnings == this.netEarnings &&
          other.finalTotal == this.finalTotal &&
          other.paymentMethod == this.paymentMethod &&
          other.paymentStatus == this.paymentStatus &&
          other.orderStatus == this.orderStatus &&
          other.notes == this.notes &&
          other.invoicePath == this.invoicePath &&
          other.createdAt == this.createdAt &&
          other.completedAt == this.completedAt);
}

class OrdersTableCompanion extends UpdateCompanion<OrdersTableData> {
  final Value<int> id;
  final Value<String> orderNumber;
  final Value<String> orderSource;
  final Value<String?> deliveryAppName;
  final Value<String?> deliveryAppOrderId;
  final Value<String?> customerPhone;
  final Value<String?> deliveryAddress;
  final Value<double> subtotal;
  final Value<double> taxAmount;
  final Value<double> sgstAmount;
  final Value<double> cgstAmount;
  final Value<double> discountAmount;
  final Value<double> deliveryFee;
  final Value<double> platformFee;
  final Value<double> grossAmount;
  final Value<double> netEarnings;
  final Value<double> finalTotal;
  final Value<String> paymentMethod;
  final Value<String> paymentStatus;
  final Value<String> orderStatus;
  final Value<String> notes;
  final Value<String?> invoicePath;
  final Value<DateTime> createdAt;
  final Value<DateTime?> completedAt;
  const OrdersTableCompanion({
    this.id = const Value.absent(),
    this.orderNumber = const Value.absent(),
    this.orderSource = const Value.absent(),
    this.deliveryAppName = const Value.absent(),
    this.deliveryAppOrderId = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.deliveryAddress = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.sgstAmount = const Value.absent(),
    this.cgstAmount = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.deliveryFee = const Value.absent(),
    this.platformFee = const Value.absent(),
    this.grossAmount = const Value.absent(),
    this.netEarnings = const Value.absent(),
    this.finalTotal = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.orderStatus = const Value.absent(),
    this.notes = const Value.absent(),
    this.invoicePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  OrdersTableCompanion.insert({
    this.id = const Value.absent(),
    required String orderNumber,
    required String orderSource,
    this.deliveryAppName = const Value.absent(),
    this.deliveryAppOrderId = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.deliveryAddress = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.sgstAmount = const Value.absent(),
    this.cgstAmount = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.deliveryFee = const Value.absent(),
    this.platformFee = const Value.absent(),
    this.grossAmount = const Value.absent(),
    this.netEarnings = const Value.absent(),
    this.finalTotal = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.orderStatus = const Value.absent(),
    this.notes = const Value.absent(),
    this.invoicePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  })  : orderNumber = Value(orderNumber),
        orderSource = Value(orderSource);
  static Insertable<OrdersTableData> custom({
    Expression<int>? id,
    Expression<String>? orderNumber,
    Expression<String>? orderSource,
    Expression<String>? deliveryAppName,
    Expression<String>? deliveryAppOrderId,
    Expression<String>? customerPhone,
    Expression<String>? deliveryAddress,
    Expression<double>? subtotal,
    Expression<double>? taxAmount,
    Expression<double>? sgstAmount,
    Expression<double>? cgstAmount,
    Expression<double>? discountAmount,
    Expression<double>? deliveryFee,
    Expression<double>? platformFee,
    Expression<double>? grossAmount,
    Expression<double>? netEarnings,
    Expression<double>? finalTotal,
    Expression<String>? paymentMethod,
    Expression<String>? paymentStatus,
    Expression<String>? orderStatus,
    Expression<String>? notes,
    Expression<String>? invoicePath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderNumber != null) 'order_number': orderNumber,
      if (orderSource != null) 'order_source': orderSource,
      if (deliveryAppName != null) 'delivery_app_name': deliveryAppName,
      if (deliveryAppOrderId != null)
        'delivery_app_order_id': deliveryAppOrderId,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (deliveryAddress != null) 'delivery_address': deliveryAddress,
      if (subtotal != null) 'subtotal': subtotal,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (sgstAmount != null) 'sgst_amount': sgstAmount,
      if (cgstAmount != null) 'cgst_amount': cgstAmount,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (deliveryFee != null) 'delivery_fee': deliveryFee,
      if (platformFee != null) 'platform_fee': platformFee,
      if (grossAmount != null) 'gross_amount': grossAmount,
      if (netEarnings != null) 'net_earnings': netEarnings,
      if (finalTotal != null) 'final_total': finalTotal,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (orderStatus != null) 'order_status': orderStatus,
      if (notes != null) 'notes': notes,
      if (invoicePath != null) 'invoice_path': invoicePath,
      if (createdAt != null) 'created_at': createdAt,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  OrdersTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? orderNumber,
      Value<String>? orderSource,
      Value<String?>? deliveryAppName,
      Value<String?>? deliveryAppOrderId,
      Value<String?>? customerPhone,
      Value<String?>? deliveryAddress,
      Value<double>? subtotal,
      Value<double>? taxAmount,
      Value<double>? sgstAmount,
      Value<double>? cgstAmount,
      Value<double>? discountAmount,
      Value<double>? deliveryFee,
      Value<double>? platformFee,
      Value<double>? grossAmount,
      Value<double>? netEarnings,
      Value<double>? finalTotal,
      Value<String>? paymentMethod,
      Value<String>? paymentStatus,
      Value<String>? orderStatus,
      Value<String>? notes,
      Value<String?>? invoicePath,
      Value<DateTime>? createdAt,
      Value<DateTime?>? completedAt}) {
    return OrdersTableCompanion(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      orderSource: orderSource ?? this.orderSource,
      deliveryAppName: deliveryAppName ?? this.deliveryAppName,
      deliveryAppOrderId: deliveryAppOrderId ?? this.deliveryAppOrderId,
      customerPhone: customerPhone ?? this.customerPhone,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      sgstAmount: sgstAmount ?? this.sgstAmount,
      cgstAmount: cgstAmount ?? this.cgstAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      platformFee: platformFee ?? this.platformFee,
      grossAmount: grossAmount ?? this.grossAmount,
      netEarnings: netEarnings ?? this.netEarnings,
      finalTotal: finalTotal ?? this.finalTotal,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderStatus: orderStatus ?? this.orderStatus,
      notes: notes ?? this.notes,
      invoicePath: invoicePath ?? this.invoicePath,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderNumber.present) {
      map['order_number'] = Variable<String>(orderNumber.value);
    }
    if (orderSource.present) {
      map['order_source'] = Variable<String>(orderSource.value);
    }
    if (deliveryAppName.present) {
      map['delivery_app_name'] = Variable<String>(deliveryAppName.value);
    }
    if (deliveryAppOrderId.present) {
      map['delivery_app_order_id'] = Variable<String>(deliveryAppOrderId.value);
    }
    if (customerPhone.present) {
      map['customer_phone'] = Variable<String>(customerPhone.value);
    }
    if (deliveryAddress.present) {
      map['delivery_address'] = Variable<String>(deliveryAddress.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (taxAmount.present) {
      map['tax_amount'] = Variable<double>(taxAmount.value);
    }
    if (sgstAmount.present) {
      map['sgst_amount'] = Variable<double>(sgstAmount.value);
    }
    if (cgstAmount.present) {
      map['cgst_amount'] = Variable<double>(cgstAmount.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<double>(discountAmount.value);
    }
    if (deliveryFee.present) {
      map['delivery_fee'] = Variable<double>(deliveryFee.value);
    }
    if (platformFee.present) {
      map['platform_fee'] = Variable<double>(platformFee.value);
    }
    if (grossAmount.present) {
      map['gross_amount'] = Variable<double>(grossAmount.value);
    }
    if (netEarnings.present) {
      map['net_earnings'] = Variable<double>(netEarnings.value);
    }
    if (finalTotal.present) {
      map['final_total'] = Variable<double>(finalTotal.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<String>(paymentStatus.value);
    }
    if (orderStatus.present) {
      map['order_status'] = Variable<String>(orderStatus.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (invoicePath.present) {
      map['invoice_path'] = Variable<String>(invoicePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersTableCompanion(')
          ..write('id: $id, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('orderSource: $orderSource, ')
          ..write('deliveryAppName: $deliveryAppName, ')
          ..write('deliveryAppOrderId: $deliveryAppOrderId, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('deliveryAddress: $deliveryAddress, ')
          ..write('subtotal: $subtotal, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('sgstAmount: $sgstAmount, ')
          ..write('cgstAmount: $cgstAmount, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('deliveryFee: $deliveryFee, ')
          ..write('platformFee: $platformFee, ')
          ..write('grossAmount: $grossAmount, ')
          ..write('netEarnings: $netEarnings, ')
          ..write('finalTotal: $finalTotal, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('orderStatus: $orderStatus, ')
          ..write('notes: $notes, ')
          ..write('invoicePath: $invoicePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTableTable extends OrderItemsTable
    with TableInfo<$OrderItemsTableTable, OrderItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
      'order_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES orders (id)'));
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _itemNameMeta =
      const VerificationMeta('itemName');
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
      'item_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _priceAtOrderMeta =
      const VerificationMeta('priceAtOrder');
  @override
  late final GeneratedColumn<double> priceAtOrder = GeneratedColumn<double>(
      'price_at_order', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _specialInstructionsMeta =
      const VerificationMeta('specialInstructions');
  @override
  late final GeneratedColumn<String> specialInstructions =
      GeneratedColumn<String>('special_instructions', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderId,
        itemId,
        itemName,
        quantity,
        priceAtOrder,
        specialInstructions
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items';
  @override
  VerificationContext validateIntegrity(
      Insertable<OrderItemsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('item_name')) {
      context.handle(_itemNameMeta,
          itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta));
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price_at_order')) {
      context.handle(
          _priceAtOrderMeta,
          priceAtOrder.isAcceptableOrUnknown(
              data['price_at_order']!, _priceAtOrderMeta));
    } else if (isInserting) {
      context.missing(_priceAtOrderMeta);
    }
    if (data.containsKey('special_instructions')) {
      context.handle(
          _specialInstructionsMeta,
          specialInstructions.isAcceptableOrUnknown(
              data['special_instructions']!, _specialInstructionsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItemsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id'])!,
      itemName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_name'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      priceAtOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price_at_order'])!,
      specialInstructions: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}special_instructions'])!,
    );
  }

  @override
  $OrderItemsTableTable createAlias(String alias) {
    return $OrderItemsTableTable(attachedDatabase, alias);
  }
}

class OrderItemsTableData extends DataClass
    implements Insertable<OrderItemsTableData> {
  final int id;
  final int orderId;
  final int itemId;
  final String itemName;
  final int quantity;
  final double priceAtOrder;
  final String specialInstructions;
  const OrderItemsTableData(
      {required this.id,
      required this.orderId,
      required this.itemId,
      required this.itemName,
      required this.quantity,
      required this.priceAtOrder,
      required this.specialInstructions});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['item_id'] = Variable<int>(itemId);
    map['item_name'] = Variable<String>(itemName);
    map['quantity'] = Variable<int>(quantity);
    map['price_at_order'] = Variable<double>(priceAtOrder);
    map['special_instructions'] = Variable<String>(specialInstructions);
    return map;
  }

  OrderItemsTableCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsTableCompanion(
      id: Value(id),
      orderId: Value(orderId),
      itemId: Value(itemId),
      itemName: Value(itemName),
      quantity: Value(quantity),
      priceAtOrder: Value(priceAtOrder),
      specialInstructions: Value(specialInstructions),
    );
  }

  factory OrderItemsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItemsTableData(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      itemId: serializer.fromJson<int>(json['itemId']),
      itemName: serializer.fromJson<String>(json['itemName']),
      quantity: serializer.fromJson<int>(json['quantity']),
      priceAtOrder: serializer.fromJson<double>(json['priceAtOrder']),
      specialInstructions:
          serializer.fromJson<String>(json['specialInstructions']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'itemId': serializer.toJson<int>(itemId),
      'itemName': serializer.toJson<String>(itemName),
      'quantity': serializer.toJson<int>(quantity),
      'priceAtOrder': serializer.toJson<double>(priceAtOrder),
      'specialInstructions': serializer.toJson<String>(specialInstructions),
    };
  }

  OrderItemsTableData copyWith(
          {int? id,
          int? orderId,
          int? itemId,
          String? itemName,
          int? quantity,
          double? priceAtOrder,
          String? specialInstructions}) =>
      OrderItemsTableData(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        itemId: itemId ?? this.itemId,
        itemName: itemName ?? this.itemName,
        quantity: quantity ?? this.quantity,
        priceAtOrder: priceAtOrder ?? this.priceAtOrder,
        specialInstructions: specialInstructions ?? this.specialInstructions,
      );
  OrderItemsTableData copyWithCompanion(OrderItemsTableCompanion data) {
    return OrderItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      priceAtOrder: data.priceAtOrder.present
          ? data.priceAtOrder.value
          : this.priceAtOrder,
      specialInstructions: data.specialInstructions.present
          ? data.specialInstructions.value
          : this.specialInstructions,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsTableData(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('itemId: $itemId, ')
          ..write('itemName: $itemName, ')
          ..write('quantity: $quantity, ')
          ..write('priceAtOrder: $priceAtOrder, ')
          ..write('specialInstructions: $specialInstructions')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, orderId, itemId, itemName, quantity,
      priceAtOrder, specialInstructions);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItemsTableData &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.itemId == this.itemId &&
          other.itemName == this.itemName &&
          other.quantity == this.quantity &&
          other.priceAtOrder == this.priceAtOrder &&
          other.specialInstructions == this.specialInstructions);
}

class OrderItemsTableCompanion extends UpdateCompanion<OrderItemsTableData> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<int> itemId;
  final Value<String> itemName;
  final Value<int> quantity;
  final Value<double> priceAtOrder;
  final Value<String> specialInstructions;
  const OrderItemsTableCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.priceAtOrder = const Value.absent(),
    this.specialInstructions = const Value.absent(),
  });
  OrderItemsTableCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required int itemId,
    required String itemName,
    required int quantity,
    required double priceAtOrder,
    this.specialInstructions = const Value.absent(),
  })  : orderId = Value(orderId),
        itemId = Value(itemId),
        itemName = Value(itemName),
        quantity = Value(quantity),
        priceAtOrder = Value(priceAtOrder);
  static Insertable<OrderItemsTableData> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<int>? itemId,
    Expression<String>? itemName,
    Expression<int>? quantity,
    Expression<double>? priceAtOrder,
    Expression<String>? specialInstructions,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (itemId != null) 'item_id': itemId,
      if (itemName != null) 'item_name': itemName,
      if (quantity != null) 'quantity': quantity,
      if (priceAtOrder != null) 'price_at_order': priceAtOrder,
      if (specialInstructions != null)
        'special_instructions': specialInstructions,
    });
  }

  OrderItemsTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? orderId,
      Value<int>? itemId,
      Value<String>? itemName,
      Value<int>? quantity,
      Value<double>? priceAtOrder,
      Value<String>? specialInstructions}) {
    return OrderItemsTableCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      priceAtOrder: priceAtOrder ?? this.priceAtOrder,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (priceAtOrder.present) {
      map['price_at_order'] = Variable<double>(priceAtOrder.value);
    }
    if (specialInstructions.present) {
      map['special_instructions'] = Variable<String>(specialInstructions.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('itemId: $itemId, ')
          ..write('itemName: $itemName, ')
          ..write('quantity: $quantity, ')
          ..write('priceAtOrder: $priceAtOrder, ')
          ..write('specialInstructions: $specialInstructions')
          ..write(')'))
        .toString();
  }
}

class $DailyInventoryTableTable extends DailyInventoryTable
    with TableInfo<$DailyInventoryTableTable, DailyInventoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyInventoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES items (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _madeQtyMeta =
      const VerificationMeta('madeQty');
  @override
  late final GeneratedColumn<int> madeQty = GeneratedColumn<int>(
      'made_qty', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _soldQtyMeta =
      const VerificationMeta('soldQty');
  @override
  late final GeneratedColumn<int> soldQty = GeneratedColumn<int>(
      'sold_qty', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _wastedQtyMeta =
      const VerificationMeta('wastedQty');
  @override
  late final GeneratedColumn<int> wastedQty = GeneratedColumn<int>(
      'wasted_qty', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, itemId, date, madeQty, soldQty, wastedQty, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_inventory';
  @override
  VerificationContext validateIntegrity(
      Insertable<DailyInventoryTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('made_qty')) {
      context.handle(_madeQtyMeta,
          madeQty.isAcceptableOrUnknown(data['made_qty']!, _madeQtyMeta));
    }
    if (data.containsKey('sold_qty')) {
      context.handle(_soldQtyMeta,
          soldQty.isAcceptableOrUnknown(data['sold_qty']!, _soldQtyMeta));
    }
    if (data.containsKey('wasted_qty')) {
      context.handle(_wastedQtyMeta,
          wastedQty.isAcceptableOrUnknown(data['wasted_qty']!, _wastedQtyMeta));
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
  DailyInventoryTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyInventoryTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      madeQty: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}made_qty'])!,
      soldQty: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sold_qty'])!,
      wastedQty: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}wasted_qty'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DailyInventoryTableTable createAlias(String alias) {
    return $DailyInventoryTableTable(attachedDatabase, alias);
  }
}

class DailyInventoryTableData extends DataClass
    implements Insertable<DailyInventoryTableData> {
  final int id;
  final int itemId;
  final String date;
  final int madeQty;
  final int soldQty;
  final int wastedQty;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DailyInventoryTableData(
      {required this.id,
      required this.itemId,
      required this.date,
      required this.madeQty,
      required this.soldQty,
      required this.wastedQty,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_id'] = Variable<int>(itemId);
    map['date'] = Variable<String>(date);
    map['made_qty'] = Variable<int>(madeQty);
    map['sold_qty'] = Variable<int>(soldQty);
    map['wasted_qty'] = Variable<int>(wastedQty);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailyInventoryTableCompanion toCompanion(bool nullToAbsent) {
    return DailyInventoryTableCompanion(
      id: Value(id),
      itemId: Value(itemId),
      date: Value(date),
      madeQty: Value(madeQty),
      soldQty: Value(soldQty),
      wastedQty: Value(wastedQty),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyInventoryTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyInventoryTableData(
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<int>(json['itemId']),
      date: serializer.fromJson<String>(json['date']),
      madeQty: serializer.fromJson<int>(json['madeQty']),
      soldQty: serializer.fromJson<int>(json['soldQty']),
      wastedQty: serializer.fromJson<int>(json['wastedQty']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<int>(itemId),
      'date': serializer.toJson<String>(date),
      'madeQty': serializer.toJson<int>(madeQty),
      'soldQty': serializer.toJson<int>(soldQty),
      'wastedQty': serializer.toJson<int>(wastedQty),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailyInventoryTableData copyWith(
          {int? id,
          int? itemId,
          String? date,
          int? madeQty,
          int? soldQty,
          int? wastedQty,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      DailyInventoryTableData(
        id: id ?? this.id,
        itemId: itemId ?? this.itemId,
        date: date ?? this.date,
        madeQty: madeQty ?? this.madeQty,
        soldQty: soldQty ?? this.soldQty,
        wastedQty: wastedQty ?? this.wastedQty,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DailyInventoryTableData copyWithCompanion(DailyInventoryTableCompanion data) {
    return DailyInventoryTableData(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      date: data.date.present ? data.date.value : this.date,
      madeQty: data.madeQty.present ? data.madeQty.value : this.madeQty,
      soldQty: data.soldQty.present ? data.soldQty.value : this.soldQty,
      wastedQty: data.wastedQty.present ? data.wastedQty.value : this.wastedQty,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyInventoryTableData(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('date: $date, ')
          ..write('madeQty: $madeQty, ')
          ..write('soldQty: $soldQty, ')
          ..write('wastedQty: $wastedQty, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, itemId, date, madeQty, soldQty, wastedQty, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyInventoryTableData &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.date == this.date &&
          other.madeQty == this.madeQty &&
          other.soldQty == this.soldQty &&
          other.wastedQty == this.wastedQty &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DailyInventoryTableCompanion
    extends UpdateCompanion<DailyInventoryTableData> {
  final Value<int> id;
  final Value<int> itemId;
  final Value<String> date;
  final Value<int> madeQty;
  final Value<int> soldQty;
  final Value<int> wastedQty;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DailyInventoryTableCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.date = const Value.absent(),
    this.madeQty = const Value.absent(),
    this.soldQty = const Value.absent(),
    this.wastedQty = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DailyInventoryTableCompanion.insert({
    this.id = const Value.absent(),
    required int itemId,
    required String date,
    this.madeQty = const Value.absent(),
    this.soldQty = const Value.absent(),
    this.wastedQty = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : itemId = Value(itemId),
        date = Value(date);
  static Insertable<DailyInventoryTableData> custom({
    Expression<int>? id,
    Expression<int>? itemId,
    Expression<String>? date,
    Expression<int>? madeQty,
    Expression<int>? soldQty,
    Expression<int>? wastedQty,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (date != null) 'date': date,
      if (madeQty != null) 'made_qty': madeQty,
      if (soldQty != null) 'sold_qty': soldQty,
      if (wastedQty != null) 'wasted_qty': wastedQty,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DailyInventoryTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? itemId,
      Value<String>? date,
      Value<int>? madeQty,
      Value<int>? soldQty,
      Value<int>? wastedQty,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return DailyInventoryTableCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      date: date ?? this.date,
      madeQty: madeQty ?? this.madeQty,
      soldQty: soldQty ?? this.soldQty,
      wastedQty: wastedQty ?? this.wastedQty,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (madeQty.present) {
      map['made_qty'] = Variable<int>(madeQty.value);
    }
    if (soldQty.present) {
      map['sold_qty'] = Variable<int>(soldQty.value);
    }
    if (wastedQty.present) {
      map['wasted_qty'] = Variable<int>(wastedQty.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyInventoryTableCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('date: $date, ')
          ..write('madeQty: $madeQty, ')
          ..write('soldQty: $soldQty, ')
          ..write('wastedQty: $wastedQty, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $InventoryAdjustmentsTableTable extends InventoryAdjustmentsTable
    with
        TableInfo<$InventoryAdjustmentsTableTable,
            InventoryAdjustmentsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryAdjustmentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dailyInventoryIdMeta =
      const VerificationMeta('dailyInventoryId');
  @override
  late final GeneratedColumn<int> dailyInventoryId = GeneratedColumn<int>(
      'daily_inventory_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES daily_inventory (id)'));
  static const VerificationMeta _adjustmentTypeMeta =
      const VerificationMeta('adjustmentType');
  @override
  late final GeneratedColumn<String> adjustmentType = GeneratedColumn<String>(
      'adjustment_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deltaMeta = const VerificationMeta('delta');
  @override
  late final GeneratedColumn<int> delta = GeneratedColumn<int>(
      'delta', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, dailyInventoryId, adjustmentType, delta, reason, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_adjustments';
  @override
  VerificationContext validateIntegrity(
      Insertable<InventoryAdjustmentsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('daily_inventory_id')) {
      context.handle(
          _dailyInventoryIdMeta,
          dailyInventoryId.isAcceptableOrUnknown(
              data['daily_inventory_id']!, _dailyInventoryIdMeta));
    } else if (isInserting) {
      context.missing(_dailyInventoryIdMeta);
    }
    if (data.containsKey('adjustment_type')) {
      context.handle(
          _adjustmentTypeMeta,
          adjustmentType.isAcceptableOrUnknown(
              data['adjustment_type']!, _adjustmentTypeMeta));
    } else if (isInserting) {
      context.missing(_adjustmentTypeMeta);
    }
    if (data.containsKey('delta')) {
      context.handle(
          _deltaMeta, delta.isAcceptableOrUnknown(data['delta']!, _deltaMeta));
    } else if (isInserting) {
      context.missing(_deltaMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
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
  InventoryAdjustmentsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryAdjustmentsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      dailyInventoryId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}daily_inventory_id'])!,
      adjustmentType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}adjustment_type'])!,
      delta: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}delta'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $InventoryAdjustmentsTableTable createAlias(String alias) {
    return $InventoryAdjustmentsTableTable(attachedDatabase, alias);
  }
}

class InventoryAdjustmentsTableData extends DataClass
    implements Insertable<InventoryAdjustmentsTableData> {
  final int id;
  final int dailyInventoryId;
  final String adjustmentType;
  final int delta;
  final String reason;
  final DateTime createdAt;
  const InventoryAdjustmentsTableData(
      {required this.id,
      required this.dailyInventoryId,
      required this.adjustmentType,
      required this.delta,
      required this.reason,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['daily_inventory_id'] = Variable<int>(dailyInventoryId);
    map['adjustment_type'] = Variable<String>(adjustmentType);
    map['delta'] = Variable<int>(delta);
    map['reason'] = Variable<String>(reason);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InventoryAdjustmentsTableCompanion toCompanion(bool nullToAbsent) {
    return InventoryAdjustmentsTableCompanion(
      id: Value(id),
      dailyInventoryId: Value(dailyInventoryId),
      adjustmentType: Value(adjustmentType),
      delta: Value(delta),
      reason: Value(reason),
      createdAt: Value(createdAt),
    );
  }

  factory InventoryAdjustmentsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryAdjustmentsTableData(
      id: serializer.fromJson<int>(json['id']),
      dailyInventoryId: serializer.fromJson<int>(json['dailyInventoryId']),
      adjustmentType: serializer.fromJson<String>(json['adjustmentType']),
      delta: serializer.fromJson<int>(json['delta']),
      reason: serializer.fromJson<String>(json['reason']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dailyInventoryId': serializer.toJson<int>(dailyInventoryId),
      'adjustmentType': serializer.toJson<String>(adjustmentType),
      'delta': serializer.toJson<int>(delta),
      'reason': serializer.toJson<String>(reason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  InventoryAdjustmentsTableData copyWith(
          {int? id,
          int? dailyInventoryId,
          String? adjustmentType,
          int? delta,
          String? reason,
          DateTime? createdAt}) =>
      InventoryAdjustmentsTableData(
        id: id ?? this.id,
        dailyInventoryId: dailyInventoryId ?? this.dailyInventoryId,
        adjustmentType: adjustmentType ?? this.adjustmentType,
        delta: delta ?? this.delta,
        reason: reason ?? this.reason,
        createdAt: createdAt ?? this.createdAt,
      );
  InventoryAdjustmentsTableData copyWithCompanion(
      InventoryAdjustmentsTableCompanion data) {
    return InventoryAdjustmentsTableData(
      id: data.id.present ? data.id.value : this.id,
      dailyInventoryId: data.dailyInventoryId.present
          ? data.dailyInventoryId.value
          : this.dailyInventoryId,
      adjustmentType: data.adjustmentType.present
          ? data.adjustmentType.value
          : this.adjustmentType,
      delta: data.delta.present ? data.delta.value : this.delta,
      reason: data.reason.present ? data.reason.value : this.reason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryAdjustmentsTableData(')
          ..write('id: $id, ')
          ..write('dailyInventoryId: $dailyInventoryId, ')
          ..write('adjustmentType: $adjustmentType, ')
          ..write('delta: $delta, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, dailyInventoryId, adjustmentType, delta, reason, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryAdjustmentsTableData &&
          other.id == this.id &&
          other.dailyInventoryId == this.dailyInventoryId &&
          other.adjustmentType == this.adjustmentType &&
          other.delta == this.delta &&
          other.reason == this.reason &&
          other.createdAt == this.createdAt);
}

class InventoryAdjustmentsTableCompanion
    extends UpdateCompanion<InventoryAdjustmentsTableData> {
  final Value<int> id;
  final Value<int> dailyInventoryId;
  final Value<String> adjustmentType;
  final Value<int> delta;
  final Value<String> reason;
  final Value<DateTime> createdAt;
  const InventoryAdjustmentsTableCompanion({
    this.id = const Value.absent(),
    this.dailyInventoryId = const Value.absent(),
    this.adjustmentType = const Value.absent(),
    this.delta = const Value.absent(),
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  InventoryAdjustmentsTableCompanion.insert({
    this.id = const Value.absent(),
    required int dailyInventoryId,
    required String adjustmentType,
    required int delta,
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : dailyInventoryId = Value(dailyInventoryId),
        adjustmentType = Value(adjustmentType),
        delta = Value(delta);
  static Insertable<InventoryAdjustmentsTableData> custom({
    Expression<int>? id,
    Expression<int>? dailyInventoryId,
    Expression<String>? adjustmentType,
    Expression<int>? delta,
    Expression<String>? reason,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dailyInventoryId != null) 'daily_inventory_id': dailyInventoryId,
      if (adjustmentType != null) 'adjustment_type': adjustmentType,
      if (delta != null) 'delta': delta,
      if (reason != null) 'reason': reason,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  InventoryAdjustmentsTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? dailyInventoryId,
      Value<String>? adjustmentType,
      Value<int>? delta,
      Value<String>? reason,
      Value<DateTime>? createdAt}) {
    return InventoryAdjustmentsTableCompanion(
      id: id ?? this.id,
      dailyInventoryId: dailyInventoryId ?? this.dailyInventoryId,
      adjustmentType: adjustmentType ?? this.adjustmentType,
      delta: delta ?? this.delta,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dailyInventoryId.present) {
      map['daily_inventory_id'] = Variable<int>(dailyInventoryId.value);
    }
    if (adjustmentType.present) {
      map['adjustment_type'] = Variable<String>(adjustmentType.value);
    }
    if (delta.present) {
      map['delta'] = Variable<int>(delta.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryAdjustmentsTableCompanion(')
          ..write('id: $id, ')
          ..write('dailyInventoryId: $dailyInventoryId, ')
          ..write('adjustmentType: $adjustmentType, ')
          ..write('delta: $delta, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BackupLogsTableTable extends BackupLogsTable
    with TableInfo<$BackupLogsTableTable, BackupLogsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BackupLogsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileSizeMeta =
      const VerificationMeta('fileSize');
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
      'file_size', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, filePath, fileSize, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'backup_logs';
  @override
  VerificationContext validateIntegrity(
      Insertable<BackupLogsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(_fileSizeMeta,
          fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta));
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
  BackupLogsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BackupLogsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      fileSize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}file_size'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $BackupLogsTableTable createAlias(String alias) {
    return $BackupLogsTableTable(attachedDatabase, alias);
  }
}

class BackupLogsTableData extends DataClass
    implements Insertable<BackupLogsTableData> {
  final int id;
  final String filePath;
  final int fileSize;
  final DateTime createdAt;
  const BackupLogsTableData(
      {required this.id,
      required this.filePath,
      required this.fileSize,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['file_path'] = Variable<String>(filePath);
    map['file_size'] = Variable<int>(fileSize);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BackupLogsTableCompanion toCompanion(bool nullToAbsent) {
    return BackupLogsTableCompanion(
      id: Value(id),
      filePath: Value(filePath),
      fileSize: Value(fileSize),
      createdAt: Value(createdAt),
    );
  }

  factory BackupLogsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BackupLogsTableData(
      id: serializer.fromJson<int>(json['id']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'filePath': serializer.toJson<String>(filePath),
      'fileSize': serializer.toJson<int>(fileSize),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BackupLogsTableData copyWith(
          {int? id, String? filePath, int? fileSize, DateTime? createdAt}) =>
      BackupLogsTableData(
        id: id ?? this.id,
        filePath: filePath ?? this.filePath,
        fileSize: fileSize ?? this.fileSize,
        createdAt: createdAt ?? this.createdAt,
      );
  BackupLogsTableData copyWithCompanion(BackupLogsTableCompanion data) {
    return BackupLogsTableData(
      id: data.id.present ? data.id.value : this.id,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BackupLogsTableData(')
          ..write('id: $id, ')
          ..write('filePath: $filePath, ')
          ..write('fileSize: $fileSize, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, filePath, fileSize, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BackupLogsTableData &&
          other.id == this.id &&
          other.filePath == this.filePath &&
          other.fileSize == this.fileSize &&
          other.createdAt == this.createdAt);
}

class BackupLogsTableCompanion extends UpdateCompanion<BackupLogsTableData> {
  final Value<int> id;
  final Value<String> filePath;
  final Value<int> fileSize;
  final Value<DateTime> createdAt;
  const BackupLogsTableCompanion({
    this.id = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BackupLogsTableCompanion.insert({
    this.id = const Value.absent(),
    required String filePath,
    this.fileSize = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : filePath = Value(filePath);
  static Insertable<BackupLogsTableData> custom({
    Expression<int>? id,
    Expression<String>? filePath,
    Expression<int>? fileSize,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (filePath != null) 'file_path': filePath,
      if (fileSize != null) 'file_size': fileSize,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BackupLogsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? filePath,
      Value<int>? fileSize,
      Value<DateTime>? createdAt}) {
    return BackupLogsTableCompanion(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BackupLogsTableCompanion(')
          ..write('id: $id, ')
          ..write('filePath: $filePath, ')
          ..write('fileSize: $fileSize, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BusinessSettingsTableTable businessSettingsTable =
      $BusinessSettingsTableTable(this);
  late final $TaxSettingsTableTable taxSettingsTable =
      $TaxSettingsTableTable(this);
  late final $DeliveryAppSettingsTableTable deliveryAppSettingsTable =
      $DeliveryAppSettingsTableTable(this);
  late final $CategoriesTableTable categoriesTable =
      $CategoriesTableTable(this);
  late final $ItemsTableTable itemsTable = $ItemsTableTable(this);
  late final $OrdersTableTable ordersTable = $OrdersTableTable(this);
  late final $OrderItemsTableTable orderItemsTable =
      $OrderItemsTableTable(this);
  late final $DailyInventoryTableTable dailyInventoryTable =
      $DailyInventoryTableTable(this);
  late final $InventoryAdjustmentsTableTable inventoryAdjustmentsTable =
      $InventoryAdjustmentsTableTable(this);
  late final $BackupLogsTableTable backupLogsTable =
      $BackupLogsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        businessSettingsTable,
        taxSettingsTable,
        deliveryAppSettingsTable,
        categoriesTable,
        itemsTable,
        ordersTable,
        orderItemsTable,
        dailyInventoryTable,
        inventoryAdjustmentsTable,
        backupLogsTable
      ];
}

typedef $$BusinessSettingsTableTableCreateCompanionBuilder
    = BusinessSettingsTableCompanion Function({
  Value<int> id,
  Value<String> businessName,
  Value<String> phone,
  Value<String> address,
  Value<String> gstId,
  Value<String?> logoPath,
});
typedef $$BusinessSettingsTableTableUpdateCompanionBuilder
    = BusinessSettingsTableCompanion Function({
  Value<int> id,
  Value<String> businessName,
  Value<String> phone,
  Value<String> address,
  Value<String> gstId,
  Value<String?> logoPath,
});

class $$BusinessSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BusinessSettingsTableTable> {
  $$BusinessSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessName => $composableBuilder(
      column: $table.businessName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gstId => $composableBuilder(
      column: $table.gstId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logoPath => $composableBuilder(
      column: $table.logoPath, builder: (column) => ColumnFilters(column));
}

class $$BusinessSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BusinessSettingsTableTable> {
  $$BusinessSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessName => $composableBuilder(
      column: $table.businessName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gstId => $composableBuilder(
      column: $table.gstId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logoPath => $composableBuilder(
      column: $table.logoPath, builder: (column) => ColumnOrderings(column));
}

class $$BusinessSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BusinessSettingsTableTable> {
  $$BusinessSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get businessName => $composableBuilder(
      column: $table.businessName, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get gstId =>
      $composableBuilder(column: $table.gstId, builder: (column) => column);

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);
}

class $$BusinessSettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BusinessSettingsTableTable,
    BusinessSettingsTableData,
    $$BusinessSettingsTableTableFilterComposer,
    $$BusinessSettingsTableTableOrderingComposer,
    $$BusinessSettingsTableTableAnnotationComposer,
    $$BusinessSettingsTableTableCreateCompanionBuilder,
    $$BusinessSettingsTableTableUpdateCompanionBuilder,
    (
      BusinessSettingsTableData,
      BaseReferences<_$AppDatabase, $BusinessSettingsTableTable,
          BusinessSettingsTableData>
    ),
    BusinessSettingsTableData,
    PrefetchHooks Function()> {
  $$BusinessSettingsTableTableTableManager(
      _$AppDatabase db, $BusinessSettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BusinessSettingsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$BusinessSettingsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BusinessSettingsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> businessName = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String> address = const Value.absent(),
            Value<String> gstId = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
          }) =>
              BusinessSettingsTableCompanion(
            id: id,
            businessName: businessName,
            phone: phone,
            address: address,
            gstId: gstId,
            logoPath: logoPath,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> businessName = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String> address = const Value.absent(),
            Value<String> gstId = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
          }) =>
              BusinessSettingsTableCompanion.insert(
            id: id,
            businessName: businessName,
            phone: phone,
            address: address,
            gstId: gstId,
            logoPath: logoPath,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BusinessSettingsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $BusinessSettingsTableTable,
        BusinessSettingsTableData,
        $$BusinessSettingsTableTableFilterComposer,
        $$BusinessSettingsTableTableOrderingComposer,
        $$BusinessSettingsTableTableAnnotationComposer,
        $$BusinessSettingsTableTableCreateCompanionBuilder,
        $$BusinessSettingsTableTableUpdateCompanionBuilder,
        (
          BusinessSettingsTableData,
          BaseReferences<_$AppDatabase, $BusinessSettingsTableTable,
              BusinessSettingsTableData>
        ),
        BusinessSettingsTableData,
        PrefetchHooks Function()>;
typedef $$TaxSettingsTableTableCreateCompanionBuilder
    = TaxSettingsTableCompanion Function({
  Value<int> id,
  Value<double> sgstPct,
  Value<double> cgstPct,
  Value<double> igstPct,
  Value<String> taxMode,
  Value<bool> taxEnabled,
});
typedef $$TaxSettingsTableTableUpdateCompanionBuilder
    = TaxSettingsTableCompanion Function({
  Value<int> id,
  Value<double> sgstPct,
  Value<double> cgstPct,
  Value<double> igstPct,
  Value<String> taxMode,
  Value<bool> taxEnabled,
});

class $$TaxSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TaxSettingsTableTable> {
  $$TaxSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sgstPct => $composableBuilder(
      column: $table.sgstPct, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cgstPct => $composableBuilder(
      column: $table.cgstPct, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get igstPct => $composableBuilder(
      column: $table.igstPct, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taxMode => $composableBuilder(
      column: $table.taxMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get taxEnabled => $composableBuilder(
      column: $table.taxEnabled, builder: (column) => ColumnFilters(column));
}

class $$TaxSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TaxSettingsTableTable> {
  $$TaxSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sgstPct => $composableBuilder(
      column: $table.sgstPct, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cgstPct => $composableBuilder(
      column: $table.cgstPct, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get igstPct => $composableBuilder(
      column: $table.igstPct, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taxMode => $composableBuilder(
      column: $table.taxMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get taxEnabled => $composableBuilder(
      column: $table.taxEnabled, builder: (column) => ColumnOrderings(column));
}

class $$TaxSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaxSettingsTableTable> {
  $$TaxSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get sgstPct =>
      $composableBuilder(column: $table.sgstPct, builder: (column) => column);

  GeneratedColumn<double> get cgstPct =>
      $composableBuilder(column: $table.cgstPct, builder: (column) => column);

  GeneratedColumn<double> get igstPct =>
      $composableBuilder(column: $table.igstPct, builder: (column) => column);

  GeneratedColumn<String> get taxMode =>
      $composableBuilder(column: $table.taxMode, builder: (column) => column);

  GeneratedColumn<bool> get taxEnabled => $composableBuilder(
      column: $table.taxEnabled, builder: (column) => column);
}

class $$TaxSettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TaxSettingsTableTable,
    TaxSettingsTableData,
    $$TaxSettingsTableTableFilterComposer,
    $$TaxSettingsTableTableOrderingComposer,
    $$TaxSettingsTableTableAnnotationComposer,
    $$TaxSettingsTableTableCreateCompanionBuilder,
    $$TaxSettingsTableTableUpdateCompanionBuilder,
    (
      TaxSettingsTableData,
      BaseReferences<_$AppDatabase, $TaxSettingsTableTable,
          TaxSettingsTableData>
    ),
    TaxSettingsTableData,
    PrefetchHooks Function()> {
  $$TaxSettingsTableTableTableManager(
      _$AppDatabase db, $TaxSettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaxSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaxSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaxSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> sgstPct = const Value.absent(),
            Value<double> cgstPct = const Value.absent(),
            Value<double> igstPct = const Value.absent(),
            Value<String> taxMode = const Value.absent(),
            Value<bool> taxEnabled = const Value.absent(),
          }) =>
              TaxSettingsTableCompanion(
            id: id,
            sgstPct: sgstPct,
            cgstPct: cgstPct,
            igstPct: igstPct,
            taxMode: taxMode,
            taxEnabled: taxEnabled,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> sgstPct = const Value.absent(),
            Value<double> cgstPct = const Value.absent(),
            Value<double> igstPct = const Value.absent(),
            Value<String> taxMode = const Value.absent(),
            Value<bool> taxEnabled = const Value.absent(),
          }) =>
              TaxSettingsTableCompanion.insert(
            id: id,
            sgstPct: sgstPct,
            cgstPct: cgstPct,
            igstPct: igstPct,
            taxMode: taxMode,
            taxEnabled: taxEnabled,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TaxSettingsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TaxSettingsTableTable,
    TaxSettingsTableData,
    $$TaxSettingsTableTableFilterComposer,
    $$TaxSettingsTableTableOrderingComposer,
    $$TaxSettingsTableTableAnnotationComposer,
    $$TaxSettingsTableTableCreateCompanionBuilder,
    $$TaxSettingsTableTableUpdateCompanionBuilder,
    (
      TaxSettingsTableData,
      BaseReferences<_$AppDatabase, $TaxSettingsTableTable,
          TaxSettingsTableData>
    ),
    TaxSettingsTableData,
    PrefetchHooks Function()>;
typedef $$DeliveryAppSettingsTableTableCreateCompanionBuilder
    = DeliveryAppSettingsTableCompanion Function({
  Value<int> id,
  required String appName,
  Value<double> commissionPct,
  Value<double> fixedFee,
  Value<bool> isActive,
});
typedef $$DeliveryAppSettingsTableTableUpdateCompanionBuilder
    = DeliveryAppSettingsTableCompanion Function({
  Value<int> id,
  Value<String> appName,
  Value<double> commissionPct,
  Value<double> fixedFee,
  Value<bool> isActive,
});

class $$DeliveryAppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DeliveryAppSettingsTableTable> {
  $$DeliveryAppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get appName => $composableBuilder(
      column: $table.appName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get commissionPct => $composableBuilder(
      column: $table.commissionPct, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fixedFee => $composableBuilder(
      column: $table.fixedFee, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));
}

class $$DeliveryAppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DeliveryAppSettingsTableTable> {
  $$DeliveryAppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get appName => $composableBuilder(
      column: $table.appName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get commissionPct => $composableBuilder(
      column: $table.commissionPct,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fixedFee => $composableBuilder(
      column: $table.fixedFee, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$DeliveryAppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeliveryAppSettingsTableTable> {
  $$DeliveryAppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get appName =>
      $composableBuilder(column: $table.appName, builder: (column) => column);

  GeneratedColumn<double> get commissionPct => $composableBuilder(
      column: $table.commissionPct, builder: (column) => column);

  GeneratedColumn<double> get fixedFee =>
      $composableBuilder(column: $table.fixedFee, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$DeliveryAppSettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DeliveryAppSettingsTableTable,
    DeliveryAppSettingsTableData,
    $$DeliveryAppSettingsTableTableFilterComposer,
    $$DeliveryAppSettingsTableTableOrderingComposer,
    $$DeliveryAppSettingsTableTableAnnotationComposer,
    $$DeliveryAppSettingsTableTableCreateCompanionBuilder,
    $$DeliveryAppSettingsTableTableUpdateCompanionBuilder,
    (
      DeliveryAppSettingsTableData,
      BaseReferences<_$AppDatabase, $DeliveryAppSettingsTableTable,
          DeliveryAppSettingsTableData>
    ),
    DeliveryAppSettingsTableData,
    PrefetchHooks Function()> {
  $$DeliveryAppSettingsTableTableTableManager(
      _$AppDatabase db, $DeliveryAppSettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeliveryAppSettingsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$DeliveryAppSettingsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeliveryAppSettingsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> appName = const Value.absent(),
            Value<double> commissionPct = const Value.absent(),
            Value<double> fixedFee = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              DeliveryAppSettingsTableCompanion(
            id: id,
            appName: appName,
            commissionPct: commissionPct,
            fixedFee: fixedFee,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String appName,
            Value<double> commissionPct = const Value.absent(),
            Value<double> fixedFee = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              DeliveryAppSettingsTableCompanion.insert(
            id: id,
            appName: appName,
            commissionPct: commissionPct,
            fixedFee: fixedFee,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DeliveryAppSettingsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $DeliveryAppSettingsTableTable,
        DeliveryAppSettingsTableData,
        $$DeliveryAppSettingsTableTableFilterComposer,
        $$DeliveryAppSettingsTableTableOrderingComposer,
        $$DeliveryAppSettingsTableTableAnnotationComposer,
        $$DeliveryAppSettingsTableTableCreateCompanionBuilder,
        $$DeliveryAppSettingsTableTableUpdateCompanionBuilder,
        (
          DeliveryAppSettingsTableData,
          BaseReferences<_$AppDatabase, $DeliveryAppSettingsTableTable,
              DeliveryAppSettingsTableData>
        ),
        DeliveryAppSettingsTableData,
        PrefetchHooks Function()>;
typedef $$CategoriesTableTableCreateCompanionBuilder = CategoriesTableCompanion
    Function({
  Value<int> id,
  required String name,
  Value<int> sortOrder,
  Value<bool> isActive,
  Value<String> colorHex,
});
typedef $$CategoriesTableTableUpdateCompanionBuilder = CategoriesTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<int> sortOrder,
  Value<bool> isActive,
  Value<String> colorHex,
});

final class $$CategoriesTableTableReferences extends BaseReferences<
    _$AppDatabase, $CategoriesTableTable, CategoriesTableData> {
  $$CategoriesTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ItemsTableTable, List<ItemsTableData>>
      _itemsTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.itemsTable,
              aliasName: $_aliasNameGenerator(
                  db.categoriesTable.id, db.itemsTable.categoryId));

  $$ItemsTableTableProcessedTableManager get itemsTableRefs {
    final manager = $$ItemsTableTableTableManager($_db, $_db.itemsTable)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnFilters(column));

  Expression<bool> itemsTableRefs(
      Expression<bool> Function($$ItemsTableTableFilterComposer f) f) {
    final $$ItemsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.itemsTable,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableTableFilterComposer(
              $db: $db,
              $table: $db.itemsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnOrderings(column));
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  Expression<T> itemsTableRefs<T extends Object>(
      Expression<T> Function($$ItemsTableTableAnnotationComposer a) f) {
    final $$ItemsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.itemsTable,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.itemsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTableTable,
    CategoriesTableData,
    $$CategoriesTableTableFilterComposer,
    $$CategoriesTableTableOrderingComposer,
    $$CategoriesTableTableAnnotationComposer,
    $$CategoriesTableTableCreateCompanionBuilder,
    $$CategoriesTableTableUpdateCompanionBuilder,
    (CategoriesTableData, $$CategoriesTableTableReferences),
    CategoriesTableData,
    PrefetchHooks Function({bool itemsTableRefs})> {
  $$CategoriesTableTableTableManager(
      _$AppDatabase db, $CategoriesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String> colorHex = const Value.absent(),
          }) =>
              CategoriesTableCompanion(
            id: id,
            name: name,
            sortOrder: sortOrder,
            isActive: isActive,
            colorHex: colorHex,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String> colorHex = const Value.absent(),
          }) =>
              CategoriesTableCompanion.insert(
            id: id,
            name: name,
            sortOrder: sortOrder,
            isActive: isActive,
            colorHex: colorHex,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategoriesTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({itemsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (itemsTableRefs) db.itemsTable],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (itemsTableRefs)
                    await $_getPrefetchedData<CategoriesTableData,
                            $CategoriesTableTable, ItemsTableData>(
                        currentTable: table,
                        referencedTable: $$CategoriesTableTableReferences
                            ._itemsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableTableReferences(db, table, p0)
                                .itemsTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoriesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTableTable,
    CategoriesTableData,
    $$CategoriesTableTableFilterComposer,
    $$CategoriesTableTableOrderingComposer,
    $$CategoriesTableTableAnnotationComposer,
    $$CategoriesTableTableCreateCompanionBuilder,
    $$CategoriesTableTableUpdateCompanionBuilder,
    (CategoriesTableData, $$CategoriesTableTableReferences),
    CategoriesTableData,
    PrefetchHooks Function({bool itemsTableRefs})>;
typedef $$ItemsTableTableCreateCompanionBuilder = ItemsTableCompanion Function({
  Value<int> id,
  required int categoryId,
  required String name,
  Value<String> description,
  required double sellingPrice,
  Value<double> costPrice,
  Value<String?> imageUrl,
  Value<int> lowStockThreshold,
  Value<int> defaultPrepQty,
  Value<bool> isAvailable,
  Value<bool> isDeleted,
  Value<bool> isBestSeller,
});
typedef $$ItemsTableTableUpdateCompanionBuilder = ItemsTableCompanion Function({
  Value<int> id,
  Value<int> categoryId,
  Value<String> name,
  Value<String> description,
  Value<double> sellingPrice,
  Value<double> costPrice,
  Value<String?> imageUrl,
  Value<int> lowStockThreshold,
  Value<int> defaultPrepQty,
  Value<bool> isAvailable,
  Value<bool> isDeleted,
  Value<bool> isBestSeller,
});

final class $$ItemsTableTableReferences
    extends BaseReferences<_$AppDatabase, $ItemsTableTable, ItemsTableData> {
  $$ItemsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTableTable _categoryIdTable(_$AppDatabase db) =>
      db.categoriesTable.createAlias($_aliasNameGenerator(
          db.itemsTable.categoryId, db.categoriesTable.id));

  $$CategoriesTableTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager =
        $$CategoriesTableTableTableManager($_db, $_db.categoriesTable)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$DailyInventoryTableTable,
      List<DailyInventoryTableData>> _dailyInventoryTableRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.dailyInventoryTable,
          aliasName: $_aliasNameGenerator(
              db.itemsTable.id, db.dailyInventoryTable.itemId));

  $$DailyInventoryTableTableProcessedTableManager get dailyInventoryTableRefs {
    final manager =
        $$DailyInventoryTableTableTableManager($_db, $_db.dailyInventoryTable)
            .filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_dailyInventoryTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ItemsTableTable> {
  $$ItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sellingPrice => $composableBuilder(
      column: $table.sellingPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get costPrice => $composableBuilder(
      column: $table.costPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lowStockThreshold => $composableBuilder(
      column: $table.lowStockThreshold,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get defaultPrepQty => $composableBuilder(
      column: $table.defaultPrepQty,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isBestSeller => $composableBuilder(
      column: $table.isBestSeller, builder: (column) => ColumnFilters(column));

  $$CategoriesTableTableFilterComposer get categoryId {
    final $$CategoriesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categoriesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableTableFilterComposer(
              $db: $db,
              $table: $db.categoriesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> dailyInventoryTableRefs(
      Expression<bool> Function($$DailyInventoryTableTableFilterComposer f) f) {
    final $$DailyInventoryTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dailyInventoryTable,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DailyInventoryTableTableFilterComposer(
              $db: $db,
              $table: $db.dailyInventoryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemsTableTable> {
  $$ItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sellingPrice => $composableBuilder(
      column: $table.sellingPrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get costPrice => $composableBuilder(
      column: $table.costPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lowStockThreshold => $composableBuilder(
      column: $table.lowStockThreshold,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get defaultPrepQty => $composableBuilder(
      column: $table.defaultPrepQty,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isBestSeller => $composableBuilder(
      column: $table.isBestSeller,
      builder: (column) => ColumnOrderings(column));

  $$CategoriesTableTableOrderingComposer get categoryId {
    final $$CategoriesTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categoriesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableTableOrderingComposer(
              $db: $db,
              $table: $db.categoriesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemsTableTable> {
  $$ItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get sellingPrice => $composableBuilder(
      column: $table.sellingPrice, builder: (column) => column);

  GeneratedColumn<double> get costPrice =>
      $composableBuilder(column: $table.costPrice, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<int> get lowStockThreshold => $composableBuilder(
      column: $table.lowStockThreshold, builder: (column) => column);

  GeneratedColumn<int> get defaultPrepQty => $composableBuilder(
      column: $table.defaultPrepQty, builder: (column) => column);

  GeneratedColumn<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<bool> get isBestSeller => $composableBuilder(
      column: $table.isBestSeller, builder: (column) => column);

  $$CategoriesTableTableAnnotationComposer get categoryId {
    final $$CategoriesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categoriesTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.categoriesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> dailyInventoryTableRefs<T extends Object>(
      Expression<T> Function($$DailyInventoryTableTableAnnotationComposer a)
          f) {
    final $$DailyInventoryTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.dailyInventoryTable,
            getReferencedColumn: (t) => t.itemId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DailyInventoryTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.dailyInventoryTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ItemsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ItemsTableTable,
    ItemsTableData,
    $$ItemsTableTableFilterComposer,
    $$ItemsTableTableOrderingComposer,
    $$ItemsTableTableAnnotationComposer,
    $$ItemsTableTableCreateCompanionBuilder,
    $$ItemsTableTableUpdateCompanionBuilder,
    (ItemsTableData, $$ItemsTableTableReferences),
    ItemsTableData,
    PrefetchHooks Function({bool categoryId, bool dailyInventoryTableRefs})> {
  $$ItemsTableTableTableManager(_$AppDatabase db, $ItemsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<double> sellingPrice = const Value.absent(),
            Value<double> costPrice = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<int> lowStockThreshold = const Value.absent(),
            Value<int> defaultPrepQty = const Value.absent(),
            Value<bool> isAvailable = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<bool> isBestSeller = const Value.absent(),
          }) =>
              ItemsTableCompanion(
            id: id,
            categoryId: categoryId,
            name: name,
            description: description,
            sellingPrice: sellingPrice,
            costPrice: costPrice,
            imageUrl: imageUrl,
            lowStockThreshold: lowStockThreshold,
            defaultPrepQty: defaultPrepQty,
            isAvailable: isAvailable,
            isDeleted: isDeleted,
            isBestSeller: isBestSeller,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int categoryId,
            required String name,
            Value<String> description = const Value.absent(),
            required double sellingPrice,
            Value<double> costPrice = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<int> lowStockThreshold = const Value.absent(),
            Value<int> defaultPrepQty = const Value.absent(),
            Value<bool> isAvailable = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<bool> isBestSeller = const Value.absent(),
          }) =>
              ItemsTableCompanion.insert(
            id: id,
            categoryId: categoryId,
            name: name,
            description: description,
            sellingPrice: sellingPrice,
            costPrice: costPrice,
            imageUrl: imageUrl,
            lowStockThreshold: lowStockThreshold,
            defaultPrepQty: defaultPrepQty,
            isAvailable: isAvailable,
            isDeleted: isDeleted,
            isBestSeller: isBestSeller,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ItemsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {categoryId = false, dailyInventoryTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (dailyInventoryTableRefs) db.dailyInventoryTable
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
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$ItemsTableTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$ItemsTableTableReferences._categoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (dailyInventoryTableRefs)
                    await $_getPrefetchedData<ItemsTableData, $ItemsTableTable,
                            DailyInventoryTableData>(
                        currentTable: table,
                        referencedTable: $$ItemsTableTableReferences
                            ._dailyInventoryTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ItemsTableTableReferences(db, table, p0)
                                .dailyInventoryTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.itemId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ItemsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ItemsTableTable,
    ItemsTableData,
    $$ItemsTableTableFilterComposer,
    $$ItemsTableTableOrderingComposer,
    $$ItemsTableTableAnnotationComposer,
    $$ItemsTableTableCreateCompanionBuilder,
    $$ItemsTableTableUpdateCompanionBuilder,
    (ItemsTableData, $$ItemsTableTableReferences),
    ItemsTableData,
    PrefetchHooks Function({bool categoryId, bool dailyInventoryTableRefs})>;
typedef $$OrdersTableTableCreateCompanionBuilder = OrdersTableCompanion
    Function({
  Value<int> id,
  required String orderNumber,
  required String orderSource,
  Value<String?> deliveryAppName,
  Value<String?> deliveryAppOrderId,
  Value<String?> customerPhone,
  Value<String?> deliveryAddress,
  Value<double> subtotal,
  Value<double> taxAmount,
  Value<double> sgstAmount,
  Value<double> cgstAmount,
  Value<double> discountAmount,
  Value<double> deliveryFee,
  Value<double> platformFee,
  Value<double> grossAmount,
  Value<double> netEarnings,
  Value<double> finalTotal,
  Value<String> paymentMethod,
  Value<String> paymentStatus,
  Value<String> orderStatus,
  Value<String> notes,
  Value<String?> invoicePath,
  Value<DateTime> createdAt,
  Value<DateTime?> completedAt,
});
typedef $$OrdersTableTableUpdateCompanionBuilder = OrdersTableCompanion
    Function({
  Value<int> id,
  Value<String> orderNumber,
  Value<String> orderSource,
  Value<String?> deliveryAppName,
  Value<String?> deliveryAppOrderId,
  Value<String?> customerPhone,
  Value<String?> deliveryAddress,
  Value<double> subtotal,
  Value<double> taxAmount,
  Value<double> sgstAmount,
  Value<double> cgstAmount,
  Value<double> discountAmount,
  Value<double> deliveryFee,
  Value<double> platformFee,
  Value<double> grossAmount,
  Value<double> netEarnings,
  Value<double> finalTotal,
  Value<String> paymentMethod,
  Value<String> paymentStatus,
  Value<String> orderStatus,
  Value<String> notes,
  Value<String?> invoicePath,
  Value<DateTime> createdAt,
  Value<DateTime?> completedAt,
});

final class $$OrdersTableTableReferences
    extends BaseReferences<_$AppDatabase, $OrdersTableTable, OrdersTableData> {
  $$OrdersTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrderItemsTableTable, List<OrderItemsTableData>>
      _orderItemsTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.orderItemsTable,
              aliasName: $_aliasNameGenerator(
                  db.ordersTable.id, db.orderItemsTable.orderId));

  $$OrderItemsTableTableProcessedTableManager get orderItemsTableRefs {
    final manager =
        $$OrderItemsTableTableTableManager($_db, $_db.orderItemsTable)
            .filter((f) => f.orderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_orderItemsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$OrdersTableTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTableTable> {
  $$OrdersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orderNumber => $composableBuilder(
      column: $table.orderNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orderSource => $composableBuilder(
      column: $table.orderSource, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deliveryAppName => $composableBuilder(
      column: $table.deliveryAppName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deliveryAppOrderId => $composableBuilder(
      column: $table.deliveryAppOrderId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deliveryAddress => $composableBuilder(
      column: $table.deliveryAddress,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get taxAmount => $composableBuilder(
      column: $table.taxAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sgstAmount => $composableBuilder(
      column: $table.sgstAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cgstAmount => $composableBuilder(
      column: $table.cgstAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discountAmount => $composableBuilder(
      column: $table.discountAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get deliveryFee => $composableBuilder(
      column: $table.deliveryFee, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get platformFee => $composableBuilder(
      column: $table.platformFee, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get grossAmount => $composableBuilder(
      column: $table.grossAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get netEarnings => $composableBuilder(
      column: $table.netEarnings, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get finalTotal => $composableBuilder(
      column: $table.finalTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentStatus => $composableBuilder(
      column: $table.paymentStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orderStatus => $composableBuilder(
      column: $table.orderStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get invoicePath => $composableBuilder(
      column: $table.invoicePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> orderItemsTableRefs(
      Expression<bool> Function($$OrderItemsTableTableFilterComposer f) f) {
    final $$OrderItemsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItemsTable,
        getReferencedColumn: (t) => t.orderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableTableFilterComposer(
              $db: $db,
              $table: $db.orderItemsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OrdersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTableTable> {
  $$OrdersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orderNumber => $composableBuilder(
      column: $table.orderNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orderSource => $composableBuilder(
      column: $table.orderSource, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deliveryAppName => $composableBuilder(
      column: $table.deliveryAppName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deliveryAppOrderId => $composableBuilder(
      column: $table.deliveryAppOrderId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deliveryAddress => $composableBuilder(
      column: $table.deliveryAddress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get taxAmount => $composableBuilder(
      column: $table.taxAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sgstAmount => $composableBuilder(
      column: $table.sgstAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cgstAmount => $composableBuilder(
      column: $table.cgstAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discountAmount => $composableBuilder(
      column: $table.discountAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get deliveryFee => $composableBuilder(
      column: $table.deliveryFee, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get platformFee => $composableBuilder(
      column: $table.platformFee, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get grossAmount => $composableBuilder(
      column: $table.grossAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get netEarnings => $composableBuilder(
      column: $table.netEarnings, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get finalTotal => $composableBuilder(
      column: $table.finalTotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentStatus => $composableBuilder(
      column: $table.paymentStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orderStatus => $composableBuilder(
      column: $table.orderStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get invoicePath => $composableBuilder(
      column: $table.invoicePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));
}

class $$OrdersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTableTable> {
  $$OrdersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orderNumber => $composableBuilder(
      column: $table.orderNumber, builder: (column) => column);

  GeneratedColumn<String> get orderSource => $composableBuilder(
      column: $table.orderSource, builder: (column) => column);

  GeneratedColumn<String> get deliveryAppName => $composableBuilder(
      column: $table.deliveryAppName, builder: (column) => column);

  GeneratedColumn<String> get deliveryAppOrderId => $composableBuilder(
      column: $table.deliveryAppOrderId, builder: (column) => column);

  GeneratedColumn<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone, builder: (column) => column);

  GeneratedColumn<String> get deliveryAddress => $composableBuilder(
      column: $table.deliveryAddress, builder: (column) => column);

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get taxAmount =>
      $composableBuilder(column: $table.taxAmount, builder: (column) => column);

  GeneratedColumn<double> get sgstAmount => $composableBuilder(
      column: $table.sgstAmount, builder: (column) => column);

  GeneratedColumn<double> get cgstAmount => $composableBuilder(
      column: $table.cgstAmount, builder: (column) => column);

  GeneratedColumn<double> get discountAmount => $composableBuilder(
      column: $table.discountAmount, builder: (column) => column);

  GeneratedColumn<double> get deliveryFee => $composableBuilder(
      column: $table.deliveryFee, builder: (column) => column);

  GeneratedColumn<double> get platformFee => $composableBuilder(
      column: $table.platformFee, builder: (column) => column);

  GeneratedColumn<double> get grossAmount => $composableBuilder(
      column: $table.grossAmount, builder: (column) => column);

  GeneratedColumn<double> get netEarnings => $composableBuilder(
      column: $table.netEarnings, builder: (column) => column);

  GeneratedColumn<double> get finalTotal => $composableBuilder(
      column: $table.finalTotal, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<String> get paymentStatus => $composableBuilder(
      column: $table.paymentStatus, builder: (column) => column);

  GeneratedColumn<String> get orderStatus => $composableBuilder(
      column: $table.orderStatus, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get invoicePath => $composableBuilder(
      column: $table.invoicePath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  Expression<T> orderItemsTableRefs<T extends Object>(
      Expression<T> Function($$OrderItemsTableTableAnnotationComposer a) f) {
    final $$OrderItemsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItemsTable,
        getReferencedColumn: (t) => t.orderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.orderItemsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OrdersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrdersTableTable,
    OrdersTableData,
    $$OrdersTableTableFilterComposer,
    $$OrdersTableTableOrderingComposer,
    $$OrdersTableTableAnnotationComposer,
    $$OrdersTableTableCreateCompanionBuilder,
    $$OrdersTableTableUpdateCompanionBuilder,
    (OrdersTableData, $$OrdersTableTableReferences),
    OrdersTableData,
    PrefetchHooks Function({bool orderItemsTableRefs})> {
  $$OrdersTableTableTableManager(_$AppDatabase db, $OrdersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> orderNumber = const Value.absent(),
            Value<String> orderSource = const Value.absent(),
            Value<String?> deliveryAppName = const Value.absent(),
            Value<String?> deliveryAppOrderId = const Value.absent(),
            Value<String?> customerPhone = const Value.absent(),
            Value<String?> deliveryAddress = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> taxAmount = const Value.absent(),
            Value<double> sgstAmount = const Value.absent(),
            Value<double> cgstAmount = const Value.absent(),
            Value<double> discountAmount = const Value.absent(),
            Value<double> deliveryFee = const Value.absent(),
            Value<double> platformFee = const Value.absent(),
            Value<double> grossAmount = const Value.absent(),
            Value<double> netEarnings = const Value.absent(),
            Value<double> finalTotal = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<String> paymentStatus = const Value.absent(),
            Value<String> orderStatus = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<String?> invoicePath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
          }) =>
              OrdersTableCompanion(
            id: id,
            orderNumber: orderNumber,
            orderSource: orderSource,
            deliveryAppName: deliveryAppName,
            deliveryAppOrderId: deliveryAppOrderId,
            customerPhone: customerPhone,
            deliveryAddress: deliveryAddress,
            subtotal: subtotal,
            taxAmount: taxAmount,
            sgstAmount: sgstAmount,
            cgstAmount: cgstAmount,
            discountAmount: discountAmount,
            deliveryFee: deliveryFee,
            platformFee: platformFee,
            grossAmount: grossAmount,
            netEarnings: netEarnings,
            finalTotal: finalTotal,
            paymentMethod: paymentMethod,
            paymentStatus: paymentStatus,
            orderStatus: orderStatus,
            notes: notes,
            invoicePath: invoicePath,
            createdAt: createdAt,
            completedAt: completedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String orderNumber,
            required String orderSource,
            Value<String?> deliveryAppName = const Value.absent(),
            Value<String?> deliveryAppOrderId = const Value.absent(),
            Value<String?> customerPhone = const Value.absent(),
            Value<String?> deliveryAddress = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> taxAmount = const Value.absent(),
            Value<double> sgstAmount = const Value.absent(),
            Value<double> cgstAmount = const Value.absent(),
            Value<double> discountAmount = const Value.absent(),
            Value<double> deliveryFee = const Value.absent(),
            Value<double> platformFee = const Value.absent(),
            Value<double> grossAmount = const Value.absent(),
            Value<double> netEarnings = const Value.absent(),
            Value<double> finalTotal = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<String> paymentStatus = const Value.absent(),
            Value<String> orderStatus = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<String?> invoicePath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
          }) =>
              OrdersTableCompanion.insert(
            id: id,
            orderNumber: orderNumber,
            orderSource: orderSource,
            deliveryAppName: deliveryAppName,
            deliveryAppOrderId: deliveryAppOrderId,
            customerPhone: customerPhone,
            deliveryAddress: deliveryAddress,
            subtotal: subtotal,
            taxAmount: taxAmount,
            sgstAmount: sgstAmount,
            cgstAmount: cgstAmount,
            discountAmount: discountAmount,
            deliveryFee: deliveryFee,
            platformFee: platformFee,
            grossAmount: grossAmount,
            netEarnings: netEarnings,
            finalTotal: finalTotal,
            paymentMethod: paymentMethod,
            paymentStatus: paymentStatus,
            orderStatus: orderStatus,
            notes: notes,
            invoicePath: invoicePath,
            createdAt: createdAt,
            completedAt: completedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$OrdersTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({orderItemsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (orderItemsTableRefs) db.orderItemsTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (orderItemsTableRefs)
                    await $_getPrefetchedData<OrdersTableData,
                            $OrdersTableTable, OrderItemsTableData>(
                        currentTable: table,
                        referencedTable: $$OrdersTableTableReferences
                            ._orderItemsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$OrdersTableTableReferences(db, table, p0)
                                .orderItemsTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.orderId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$OrdersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrdersTableTable,
    OrdersTableData,
    $$OrdersTableTableFilterComposer,
    $$OrdersTableTableOrderingComposer,
    $$OrdersTableTableAnnotationComposer,
    $$OrdersTableTableCreateCompanionBuilder,
    $$OrdersTableTableUpdateCompanionBuilder,
    (OrdersTableData, $$OrdersTableTableReferences),
    OrdersTableData,
    PrefetchHooks Function({bool orderItemsTableRefs})>;
typedef $$OrderItemsTableTableCreateCompanionBuilder = OrderItemsTableCompanion
    Function({
  Value<int> id,
  required int orderId,
  required int itemId,
  required String itemName,
  required int quantity,
  required double priceAtOrder,
  Value<String> specialInstructions,
});
typedef $$OrderItemsTableTableUpdateCompanionBuilder = OrderItemsTableCompanion
    Function({
  Value<int> id,
  Value<int> orderId,
  Value<int> itemId,
  Value<String> itemName,
  Value<int> quantity,
  Value<double> priceAtOrder,
  Value<String> specialInstructions,
});

final class $$OrderItemsTableTableReferences extends BaseReferences<
    _$AppDatabase, $OrderItemsTableTable, OrderItemsTableData> {
  $$OrderItemsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTableTable _orderIdTable(_$AppDatabase db) =>
      db.ordersTable.createAlias(
          $_aliasNameGenerator(db.orderItemsTable.orderId, db.ordersTable.id));

  $$OrdersTableTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<int>('order_id')!;

    final manager = $$OrdersTableTableTableManager($_db, $_db.ordersTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$OrderItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemsTableTable> {
  $$OrderItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemName => $composableBuilder(
      column: $table.itemName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get priceAtOrder => $composableBuilder(
      column: $table.priceAtOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get specialInstructions => $composableBuilder(
      column: $table.specialInstructions,
      builder: (column) => ColumnFilters(column));

  $$OrdersTableTableFilterComposer get orderId {
    final $$OrdersTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.ordersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableTableFilterComposer(
              $db: $db,
              $table: $db.ordersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemsTableTable> {
  $$OrderItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemName => $composableBuilder(
      column: $table.itemName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get priceAtOrder => $composableBuilder(
      column: $table.priceAtOrder,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get specialInstructions => $composableBuilder(
      column: $table.specialInstructions,
      builder: (column) => ColumnOrderings(column));

  $$OrdersTableTableOrderingComposer get orderId {
    final $$OrdersTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.ordersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableTableOrderingComposer(
              $db: $db,
              $table: $db.ordersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemsTableTable> {
  $$OrderItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get priceAtOrder => $composableBuilder(
      column: $table.priceAtOrder, builder: (column) => column);

  GeneratedColumn<String> get specialInstructions => $composableBuilder(
      column: $table.specialInstructions, builder: (column) => column);

  $$OrdersTableTableAnnotationComposer get orderId {
    final $$OrdersTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.ordersTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableTableAnnotationComposer(
              $db: $db,
              $table: $db.ordersTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrderItemsTableTable,
    OrderItemsTableData,
    $$OrderItemsTableTableFilterComposer,
    $$OrderItemsTableTableOrderingComposer,
    $$OrderItemsTableTableAnnotationComposer,
    $$OrderItemsTableTableCreateCompanionBuilder,
    $$OrderItemsTableTableUpdateCompanionBuilder,
    (OrderItemsTableData, $$OrderItemsTableTableReferences),
    OrderItemsTableData,
    PrefetchHooks Function({bool orderId})> {
  $$OrderItemsTableTableTableManager(
      _$AppDatabase db, $OrderItemsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> orderId = const Value.absent(),
            Value<int> itemId = const Value.absent(),
            Value<String> itemName = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<double> priceAtOrder = const Value.absent(),
            Value<String> specialInstructions = const Value.absent(),
          }) =>
              OrderItemsTableCompanion(
            id: id,
            orderId: orderId,
            itemId: itemId,
            itemName: itemName,
            quantity: quantity,
            priceAtOrder: priceAtOrder,
            specialInstructions: specialInstructions,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int orderId,
            required int itemId,
            required String itemName,
            required int quantity,
            required double priceAtOrder,
            Value<String> specialInstructions = const Value.absent(),
          }) =>
              OrderItemsTableCompanion.insert(
            id: id,
            orderId: orderId,
            itemId: itemId,
            itemName: itemName,
            quantity: quantity,
            priceAtOrder: priceAtOrder,
            specialInstructions: specialInstructions,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$OrderItemsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({orderId = false}) {
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
                if (orderId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.orderId,
                    referencedTable:
                        $$OrderItemsTableTableReferences._orderIdTable(db),
                    referencedColumn:
                        $$OrderItemsTableTableReferences._orderIdTable(db).id,
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

typedef $$OrderItemsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrderItemsTableTable,
    OrderItemsTableData,
    $$OrderItemsTableTableFilterComposer,
    $$OrderItemsTableTableOrderingComposer,
    $$OrderItemsTableTableAnnotationComposer,
    $$OrderItemsTableTableCreateCompanionBuilder,
    $$OrderItemsTableTableUpdateCompanionBuilder,
    (OrderItemsTableData, $$OrderItemsTableTableReferences),
    OrderItemsTableData,
    PrefetchHooks Function({bool orderId})>;
typedef $$DailyInventoryTableTableCreateCompanionBuilder
    = DailyInventoryTableCompanion Function({
  Value<int> id,
  required int itemId,
  required String date,
  Value<int> madeQty,
  Value<int> soldQty,
  Value<int> wastedQty,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$DailyInventoryTableTableUpdateCompanionBuilder
    = DailyInventoryTableCompanion Function({
  Value<int> id,
  Value<int> itemId,
  Value<String> date,
  Value<int> madeQty,
  Value<int> soldQty,
  Value<int> wastedQty,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$DailyInventoryTableTableReferences extends BaseReferences<
    _$AppDatabase, $DailyInventoryTableTable, DailyInventoryTableData> {
  $$DailyInventoryTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTableTable _itemIdTable(_$AppDatabase db) =>
      db.itemsTable.createAlias($_aliasNameGenerator(
          db.dailyInventoryTable.itemId, db.itemsTable.id));

  $$ItemsTableTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<int>('item_id')!;

    final manager = $$ItemsTableTableTableManager($_db, $_db.itemsTable)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$InventoryAdjustmentsTableTable,
      List<InventoryAdjustmentsTableData>> _inventoryAdjustmentsTableRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.inventoryAdjustmentsTable,
          aliasName: $_aliasNameGenerator(db.dailyInventoryTable.id,
              db.inventoryAdjustmentsTable.dailyInventoryId));

  $$InventoryAdjustmentsTableTableProcessedTableManager
      get inventoryAdjustmentsTableRefs {
    final manager = $$InventoryAdjustmentsTableTableTableManager(
            $_db, $_db.inventoryAdjustmentsTable)
        .filter(
            (f) => f.dailyInventoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult
        .readTableOrNull(_inventoryAdjustmentsTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DailyInventoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $DailyInventoryTableTable> {
  $$DailyInventoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get madeQty => $composableBuilder(
      column: $table.madeQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get soldQty => $composableBuilder(
      column: $table.soldQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wastedQty => $composableBuilder(
      column: $table.wastedQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$ItemsTableTableFilterComposer get itemId {
    final $$ItemsTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.itemsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableTableFilterComposer(
              $db: $db,
              $table: $db.itemsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> inventoryAdjustmentsTableRefs(
      Expression<bool> Function(
              $$InventoryAdjustmentsTableTableFilterComposer f)
          f) {
    final $$InventoryAdjustmentsTableTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.inventoryAdjustmentsTable,
            getReferencedColumn: (t) => t.dailyInventoryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$InventoryAdjustmentsTableTableFilterComposer(
                  $db: $db,
                  $table: $db.inventoryAdjustmentsTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$DailyInventoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyInventoryTableTable> {
  $$DailyInventoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get madeQty => $composableBuilder(
      column: $table.madeQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get soldQty => $composableBuilder(
      column: $table.soldQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wastedQty => $composableBuilder(
      column: $table.wastedQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$ItemsTableTableOrderingComposer get itemId {
    final $$ItemsTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.itemsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableTableOrderingComposer(
              $db: $db,
              $table: $db.itemsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DailyInventoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyInventoryTableTable> {
  $$DailyInventoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get madeQty =>
      $composableBuilder(column: $table.madeQty, builder: (column) => column);

  GeneratedColumn<int> get soldQty =>
      $composableBuilder(column: $table.soldQty, builder: (column) => column);

  GeneratedColumn<int> get wastedQty =>
      $composableBuilder(column: $table.wastedQty, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ItemsTableTableAnnotationComposer get itemId {
    final $$ItemsTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.itemsTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableTableAnnotationComposer(
              $db: $db,
              $table: $db.itemsTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> inventoryAdjustmentsTableRefs<T extends Object>(
      Expression<T> Function(
              $$InventoryAdjustmentsTableTableAnnotationComposer a)
          f) {
    final $$InventoryAdjustmentsTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.inventoryAdjustmentsTable,
            getReferencedColumn: (t) => t.dailyInventoryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$InventoryAdjustmentsTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.inventoryAdjustmentsTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$DailyInventoryTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailyInventoryTableTable,
    DailyInventoryTableData,
    $$DailyInventoryTableTableFilterComposer,
    $$DailyInventoryTableTableOrderingComposer,
    $$DailyInventoryTableTableAnnotationComposer,
    $$DailyInventoryTableTableCreateCompanionBuilder,
    $$DailyInventoryTableTableUpdateCompanionBuilder,
    (DailyInventoryTableData, $$DailyInventoryTableTableReferences),
    DailyInventoryTableData,
    PrefetchHooks Function({bool itemId, bool inventoryAdjustmentsTableRefs})> {
  $$DailyInventoryTableTableTableManager(
      _$AppDatabase db, $DailyInventoryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyInventoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyInventoryTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyInventoryTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> itemId = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<int> madeQty = const Value.absent(),
            Value<int> soldQty = const Value.absent(),
            Value<int> wastedQty = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              DailyInventoryTableCompanion(
            id: id,
            itemId: itemId,
            date: date,
            madeQty: madeQty,
            soldQty: soldQty,
            wastedQty: wastedQty,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int itemId,
            required String date,
            Value<int> madeQty = const Value.absent(),
            Value<int> soldQty = const Value.absent(),
            Value<int> wastedQty = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              DailyInventoryTableCompanion.insert(
            id: id,
            itemId: itemId,
            date: date,
            madeQty: madeQty,
            soldQty: soldQty,
            wastedQty: wastedQty,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DailyInventoryTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {itemId = false, inventoryAdjustmentsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (inventoryAdjustmentsTableRefs) db.inventoryAdjustmentsTable
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
                if (itemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.itemId,
                    referencedTable:
                        $$DailyInventoryTableTableReferences._itemIdTable(db),
                    referencedColumn: $$DailyInventoryTableTableReferences
                        ._itemIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (inventoryAdjustmentsTableRefs)
                    await $_getPrefetchedData<
                            DailyInventoryTableData,
                            $DailyInventoryTableTable,
                            InventoryAdjustmentsTableData>(
                        currentTable: table,
                        referencedTable: $$DailyInventoryTableTableReferences
                            ._inventoryAdjustmentsTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DailyInventoryTableTableReferences(db, table, p0)
                                .inventoryAdjustmentsTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.dailyInventoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DailyInventoryTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailyInventoryTableTable,
    DailyInventoryTableData,
    $$DailyInventoryTableTableFilterComposer,
    $$DailyInventoryTableTableOrderingComposer,
    $$DailyInventoryTableTableAnnotationComposer,
    $$DailyInventoryTableTableCreateCompanionBuilder,
    $$DailyInventoryTableTableUpdateCompanionBuilder,
    (DailyInventoryTableData, $$DailyInventoryTableTableReferences),
    DailyInventoryTableData,
    PrefetchHooks Function({bool itemId, bool inventoryAdjustmentsTableRefs})>;
typedef $$InventoryAdjustmentsTableTableCreateCompanionBuilder
    = InventoryAdjustmentsTableCompanion Function({
  Value<int> id,
  required int dailyInventoryId,
  required String adjustmentType,
  required int delta,
  Value<String> reason,
  Value<DateTime> createdAt,
});
typedef $$InventoryAdjustmentsTableTableUpdateCompanionBuilder
    = InventoryAdjustmentsTableCompanion Function({
  Value<int> id,
  Value<int> dailyInventoryId,
  Value<String> adjustmentType,
  Value<int> delta,
  Value<String> reason,
  Value<DateTime> createdAt,
});

final class $$InventoryAdjustmentsTableTableReferences extends BaseReferences<
    _$AppDatabase,
    $InventoryAdjustmentsTableTable,
    InventoryAdjustmentsTableData> {
  $$InventoryAdjustmentsTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $DailyInventoryTableTable _dailyInventoryIdTable(_$AppDatabase db) =>
      db.dailyInventoryTable.createAlias($_aliasNameGenerator(
          db.inventoryAdjustmentsTable.dailyInventoryId,
          db.dailyInventoryTable.id));

  $$DailyInventoryTableTableProcessedTableManager get dailyInventoryId {
    final $_column = $_itemColumn<int>('daily_inventory_id')!;

    final manager =
        $$DailyInventoryTableTableTableManager($_db, $_db.dailyInventoryTable)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dailyInventoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$InventoryAdjustmentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryAdjustmentsTableTable> {
  $$InventoryAdjustmentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get adjustmentType => $composableBuilder(
      column: $table.adjustmentType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get delta => $composableBuilder(
      column: $table.delta, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$DailyInventoryTableTableFilterComposer get dailyInventoryId {
    final $$DailyInventoryTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dailyInventoryId,
        referencedTable: $db.dailyInventoryTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DailyInventoryTableTableFilterComposer(
              $db: $db,
              $table: $db.dailyInventoryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InventoryAdjustmentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryAdjustmentsTableTable> {
  $$InventoryAdjustmentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get adjustmentType => $composableBuilder(
      column: $table.adjustmentType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get delta => $composableBuilder(
      column: $table.delta, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$DailyInventoryTableTableOrderingComposer get dailyInventoryId {
    final $$DailyInventoryTableTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.dailyInventoryId,
            referencedTable: $db.dailyInventoryTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DailyInventoryTableTableOrderingComposer(
                  $db: $db,
                  $table: $db.dailyInventoryTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$InventoryAdjustmentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryAdjustmentsTableTable> {
  $$InventoryAdjustmentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get adjustmentType => $composableBuilder(
      column: $table.adjustmentType, builder: (column) => column);

  GeneratedColumn<int> get delta =>
      $composableBuilder(column: $table.delta, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$DailyInventoryTableTableAnnotationComposer get dailyInventoryId {
    final $$DailyInventoryTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.dailyInventoryId,
            referencedTable: $db.dailyInventoryTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$DailyInventoryTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.dailyInventoryTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$InventoryAdjustmentsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InventoryAdjustmentsTableTable,
    InventoryAdjustmentsTableData,
    $$InventoryAdjustmentsTableTableFilterComposer,
    $$InventoryAdjustmentsTableTableOrderingComposer,
    $$InventoryAdjustmentsTableTableAnnotationComposer,
    $$InventoryAdjustmentsTableTableCreateCompanionBuilder,
    $$InventoryAdjustmentsTableTableUpdateCompanionBuilder,
    (InventoryAdjustmentsTableData, $$InventoryAdjustmentsTableTableReferences),
    InventoryAdjustmentsTableData,
    PrefetchHooks Function({bool dailyInventoryId})> {
  $$InventoryAdjustmentsTableTableTableManager(
      _$AppDatabase db, $InventoryAdjustmentsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryAdjustmentsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryAdjustmentsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryAdjustmentsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> dailyInventoryId = const Value.absent(),
            Value<String> adjustmentType = const Value.absent(),
            Value<int> delta = const Value.absent(),
            Value<String> reason = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              InventoryAdjustmentsTableCompanion(
            id: id,
            dailyInventoryId: dailyInventoryId,
            adjustmentType: adjustmentType,
            delta: delta,
            reason: reason,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int dailyInventoryId,
            required String adjustmentType,
            required int delta,
            Value<String> reason = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              InventoryAdjustmentsTableCompanion.insert(
            id: id,
            dailyInventoryId: dailyInventoryId,
            adjustmentType: adjustmentType,
            delta: delta,
            reason: reason,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$InventoryAdjustmentsTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({dailyInventoryId = false}) {
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
                if (dailyInventoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.dailyInventoryId,
                    referencedTable: $$InventoryAdjustmentsTableTableReferences
                        ._dailyInventoryIdTable(db),
                    referencedColumn: $$InventoryAdjustmentsTableTableReferences
                        ._dailyInventoryIdTable(db)
                        .id,
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

typedef $$InventoryAdjustmentsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $InventoryAdjustmentsTableTable,
        InventoryAdjustmentsTableData,
        $$InventoryAdjustmentsTableTableFilterComposer,
        $$InventoryAdjustmentsTableTableOrderingComposer,
        $$InventoryAdjustmentsTableTableAnnotationComposer,
        $$InventoryAdjustmentsTableTableCreateCompanionBuilder,
        $$InventoryAdjustmentsTableTableUpdateCompanionBuilder,
        (
          InventoryAdjustmentsTableData,
          $$InventoryAdjustmentsTableTableReferences
        ),
        InventoryAdjustmentsTableData,
        PrefetchHooks Function({bool dailyInventoryId})>;
typedef $$BackupLogsTableTableCreateCompanionBuilder = BackupLogsTableCompanion
    Function({
  Value<int> id,
  required String filePath,
  Value<int> fileSize,
  Value<DateTime> createdAt,
});
typedef $$BackupLogsTableTableUpdateCompanionBuilder = BackupLogsTableCompanion
    Function({
  Value<int> id,
  Value<String> filePath,
  Value<int> fileSize,
  Value<DateTime> createdAt,
});

class $$BackupLogsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BackupLogsTableTable> {
  $$BackupLogsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$BackupLogsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BackupLogsTableTable> {
  $$BackupLogsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$BackupLogsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BackupLogsTableTable> {
  $$BackupLogsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BackupLogsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BackupLogsTableTable,
    BackupLogsTableData,
    $$BackupLogsTableTableFilterComposer,
    $$BackupLogsTableTableOrderingComposer,
    $$BackupLogsTableTableAnnotationComposer,
    $$BackupLogsTableTableCreateCompanionBuilder,
    $$BackupLogsTableTableUpdateCompanionBuilder,
    (
      BackupLogsTableData,
      BaseReferences<_$AppDatabase, $BackupLogsTableTable, BackupLogsTableData>
    ),
    BackupLogsTableData,
    PrefetchHooks Function()> {
  $$BackupLogsTableTableTableManager(
      _$AppDatabase db, $BackupLogsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BackupLogsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BackupLogsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BackupLogsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<int> fileSize = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              BackupLogsTableCompanion(
            id: id,
            filePath: filePath,
            fileSize: fileSize,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String filePath,
            Value<int> fileSize = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              BackupLogsTableCompanion.insert(
            id: id,
            filePath: filePath,
            fileSize: fileSize,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BackupLogsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BackupLogsTableTable,
    BackupLogsTableData,
    $$BackupLogsTableTableFilterComposer,
    $$BackupLogsTableTableOrderingComposer,
    $$BackupLogsTableTableAnnotationComposer,
    $$BackupLogsTableTableCreateCompanionBuilder,
    $$BackupLogsTableTableUpdateCompanionBuilder,
    (
      BackupLogsTableData,
      BaseReferences<_$AppDatabase, $BackupLogsTableTable, BackupLogsTableData>
    ),
    BackupLogsTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BusinessSettingsTableTableTableManager get businessSettingsTable =>
      $$BusinessSettingsTableTableTableManager(_db, _db.businessSettingsTable);
  $$TaxSettingsTableTableTableManager get taxSettingsTable =>
      $$TaxSettingsTableTableTableManager(_db, _db.taxSettingsTable);
  $$DeliveryAppSettingsTableTableTableManager get deliveryAppSettingsTable =>
      $$DeliveryAppSettingsTableTableTableManager(
          _db, _db.deliveryAppSettingsTable);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$ItemsTableTableTableManager get itemsTable =>
      $$ItemsTableTableTableManager(_db, _db.itemsTable);
  $$OrdersTableTableTableManager get ordersTable =>
      $$OrdersTableTableTableManager(_db, _db.ordersTable);
  $$OrderItemsTableTableTableManager get orderItemsTable =>
      $$OrderItemsTableTableTableManager(_db, _db.orderItemsTable);
  $$DailyInventoryTableTableTableManager get dailyInventoryTable =>
      $$DailyInventoryTableTableTableManager(_db, _db.dailyInventoryTable);
  $$InventoryAdjustmentsTableTableTableManager get inventoryAdjustmentsTable =>
      $$InventoryAdjustmentsTableTableTableManager(
          _db, _db.inventoryAdjustmentsTable);
  $$BackupLogsTableTableTableManager get backupLogsTable =>
      $$BackupLogsTableTableTableManager(_db, _db.backupLogsTable);
}
