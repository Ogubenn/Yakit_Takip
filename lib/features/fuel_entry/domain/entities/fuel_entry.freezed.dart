// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fuel_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FuelEntry _$FuelEntryFromJson(Map<String, dynamic> json) {
  return _FuelEntry.fromJson(json);
}

/// @nodoc
mixin _$FuelEntry {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get vehicleId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int get odometer => throw _privateConstructorUsedError;
  double get liters => throw _privateConstructorUsedError;
  double get pricePerLiter => throw _privateConstructorUsedError;
  double get totalCost => throw _privateConstructorUsedError;
  String get fuelType => throw _privateConstructorUsedError;
  bool get isFullTank => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  String? get stationName => throw _privateConstructorUsedError;
  double? get consumption => throw _privateConstructorUsedError; // L/100km
  double? get costPerKm => throw _privateConstructorUsedError;
  String get syncStatus => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this FuelEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FuelEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FuelEntryCopyWith<FuelEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FuelEntryCopyWith<$Res> {
  factory $FuelEntryCopyWith(FuelEntry value, $Res Function(FuelEntry) then) =
      _$FuelEntryCopyWithImpl<$Res, FuelEntry>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String vehicleId,
      DateTime date,
      int odometer,
      double liters,
      double pricePerLiter,
      double totalCost,
      String fuelType,
      bool isFullTank,
      String? note,
      String? stationName,
      double? consumption,
      double? costPerKm,
      String syncStatus,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$FuelEntryCopyWithImpl<$Res, $Val extends FuelEntry>
    implements $FuelEntryCopyWith<$Res> {
  _$FuelEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FuelEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? vehicleId = null,
    Object? date = null,
    Object? odometer = null,
    Object? liters = null,
    Object? pricePerLiter = null,
    Object? totalCost = null,
    Object? fuelType = null,
    Object? isFullTank = null,
    Object? note = freezed,
    Object? stationName = freezed,
    Object? consumption = freezed,
    Object? costPerKm = freezed,
    Object? syncStatus = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      odometer: null == odometer
          ? _value.odometer
          : odometer // ignore: cast_nullable_to_non_nullable
              as int,
      liters: null == liters
          ? _value.liters
          : liters // ignore: cast_nullable_to_non_nullable
              as double,
      pricePerLiter: null == pricePerLiter
          ? _value.pricePerLiter
          : pricePerLiter // ignore: cast_nullable_to_non_nullable
              as double,
      totalCost: null == totalCost
          ? _value.totalCost
          : totalCost // ignore: cast_nullable_to_non_nullable
              as double,
      fuelType: null == fuelType
          ? _value.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String,
      isFullTank: null == isFullTank
          ? _value.isFullTank
          : isFullTank // ignore: cast_nullable_to_non_nullable
              as bool,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      stationName: freezed == stationName
          ? _value.stationName
          : stationName // ignore: cast_nullable_to_non_nullable
              as String?,
      consumption: freezed == consumption
          ? _value.consumption
          : consumption // ignore: cast_nullable_to_non_nullable
              as double?,
      costPerKm: freezed == costPerKm
          ? _value.costPerKm
          : costPerKm // ignore: cast_nullable_to_non_nullable
              as double?,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FuelEntryImplCopyWith<$Res>
    implements $FuelEntryCopyWith<$Res> {
  factory _$$FuelEntryImplCopyWith(
          _$FuelEntryImpl value, $Res Function(_$FuelEntryImpl) then) =
      __$$FuelEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String vehicleId,
      DateTime date,
      int odometer,
      double liters,
      double pricePerLiter,
      double totalCost,
      String fuelType,
      bool isFullTank,
      String? note,
      String? stationName,
      double? consumption,
      double? costPerKm,
      String syncStatus,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$FuelEntryImplCopyWithImpl<$Res>
    extends _$FuelEntryCopyWithImpl<$Res, _$FuelEntryImpl>
    implements _$$FuelEntryImplCopyWith<$Res> {
  __$$FuelEntryImplCopyWithImpl(
      _$FuelEntryImpl _value, $Res Function(_$FuelEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of FuelEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? vehicleId = null,
    Object? date = null,
    Object? odometer = null,
    Object? liters = null,
    Object? pricePerLiter = null,
    Object? totalCost = null,
    Object? fuelType = null,
    Object? isFullTank = null,
    Object? note = freezed,
    Object? stationName = freezed,
    Object? consumption = freezed,
    Object? costPerKm = freezed,
    Object? syncStatus = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$FuelEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleId: null == vehicleId
          ? _value.vehicleId
          : vehicleId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      odometer: null == odometer
          ? _value.odometer
          : odometer // ignore: cast_nullable_to_non_nullable
              as int,
      liters: null == liters
          ? _value.liters
          : liters // ignore: cast_nullable_to_non_nullable
              as double,
      pricePerLiter: null == pricePerLiter
          ? _value.pricePerLiter
          : pricePerLiter // ignore: cast_nullable_to_non_nullable
              as double,
      totalCost: null == totalCost
          ? _value.totalCost
          : totalCost // ignore: cast_nullable_to_non_nullable
              as double,
      fuelType: null == fuelType
          ? _value.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String,
      isFullTank: null == isFullTank
          ? _value.isFullTank
          : isFullTank // ignore: cast_nullable_to_non_nullable
              as bool,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      stationName: freezed == stationName
          ? _value.stationName
          : stationName // ignore: cast_nullable_to_non_nullable
              as String?,
      consumption: freezed == consumption
          ? _value.consumption
          : consumption // ignore: cast_nullable_to_non_nullable
              as double?,
      costPerKm: freezed == costPerKm
          ? _value.costPerKm
          : costPerKm // ignore: cast_nullable_to_non_nullable
              as double?,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FuelEntryImpl implements _FuelEntry {
  const _$FuelEntryImpl(
      {required this.id,
      required this.userId,
      required this.vehicleId,
      required this.date,
      required this.odometer,
      required this.liters,
      required this.pricePerLiter,
      required this.totalCost,
      required this.fuelType,
      this.isFullTank = true,
      this.note,
      this.stationName,
      this.consumption,
      this.costPerKm,
      this.syncStatus = 'synced',
      required this.createdAt,
      required this.updatedAt});

  factory _$FuelEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$FuelEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String vehicleId;
  @override
  final DateTime date;
  @override
  final int odometer;
  @override
  final double liters;
  @override
  final double pricePerLiter;
  @override
  final double totalCost;
  @override
  final String fuelType;
  @override
  @JsonKey()
  final bool isFullTank;
  @override
  final String? note;
  @override
  final String? stationName;
  @override
  final double? consumption;
// L/100km
  @override
  final double? costPerKm;
  @override
  @JsonKey()
  final String syncStatus;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'FuelEntry(id: $id, userId: $userId, vehicleId: $vehicleId, date: $date, odometer: $odometer, liters: $liters, pricePerLiter: $pricePerLiter, totalCost: $totalCost, fuelType: $fuelType, isFullTank: $isFullTank, note: $note, stationName: $stationName, consumption: $consumption, costPerKm: $costPerKm, syncStatus: $syncStatus, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FuelEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.odometer, odometer) ||
                other.odometer == odometer) &&
            (identical(other.liters, liters) || other.liters == liters) &&
            (identical(other.pricePerLiter, pricePerLiter) ||
                other.pricePerLiter == pricePerLiter) &&
            (identical(other.totalCost, totalCost) ||
                other.totalCost == totalCost) &&
            (identical(other.fuelType, fuelType) ||
                other.fuelType == fuelType) &&
            (identical(other.isFullTank, isFullTank) ||
                other.isFullTank == isFullTank) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.stationName, stationName) ||
                other.stationName == stationName) &&
            (identical(other.consumption, consumption) ||
                other.consumption == consumption) &&
            (identical(other.costPerKm, costPerKm) ||
                other.costPerKm == costPerKm) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      vehicleId,
      date,
      odometer,
      liters,
      pricePerLiter,
      totalCost,
      fuelType,
      isFullTank,
      note,
      stationName,
      consumption,
      costPerKm,
      syncStatus,
      createdAt,
      updatedAt);

  /// Create a copy of FuelEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FuelEntryImplCopyWith<_$FuelEntryImpl> get copyWith =>
      __$$FuelEntryImplCopyWithImpl<_$FuelEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FuelEntryImplToJson(
      this,
    );
  }
}

abstract class _FuelEntry implements FuelEntry {
  const factory _FuelEntry(
      {required final String id,
      required final String userId,
      required final String vehicleId,
      required final DateTime date,
      required final int odometer,
      required final double liters,
      required final double pricePerLiter,
      required final double totalCost,
      required final String fuelType,
      final bool isFullTank,
      final String? note,
      final String? stationName,
      final double? consumption,
      final double? costPerKm,
      final String syncStatus,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$FuelEntryImpl;

  factory _FuelEntry.fromJson(Map<String, dynamic> json) =
      _$FuelEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get vehicleId;
  @override
  DateTime get date;
  @override
  int get odometer;
  @override
  double get liters;
  @override
  double get pricePerLiter;
  @override
  double get totalCost;
  @override
  String get fuelType;
  @override
  bool get isFullTank;
  @override
  String? get note;
  @override
  String? get stationName;
  @override
  double? get consumption; // L/100km
  @override
  double? get costPerKm;
  @override
  String get syncStatus;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of FuelEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FuelEntryImplCopyWith<_$FuelEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
