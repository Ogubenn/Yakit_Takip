import 'package:freezed_annotation/freezed_annotation.dart';

part 'fuel_entry.freezed.dart';
part 'fuel_entry.g.dart';

/// Fuel Entry Entity (Domain Layer)
@freezed
class FuelEntry with _$FuelEntry {
  const factory FuelEntry({
    required String id,
    required String userId,
    required String vehicleId,
    required DateTime date,
    required int odometer,
    required double liters,
    required double pricePerLiter,
    required double totalCost,
    required String fuelType,
    @Default(true) bool isFullTank,
    String? note,
    String? stationName,
    double? consumption,  // L/100km
    double? costPerKm,
    @Default('synced') String syncStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _FuelEntry;

  factory FuelEntry.fromJson(Map<String, dynamic> json) =>
      _$FuelEntryFromJson(json);
}

/// Fuel Type Enum
enum FuelType {
  @JsonValue('95')
  benzin95,
  @JsonValue('diesel')
  diesel,
  @JsonValue('lpg')
  lpg,
  @JsonValue('electric')
  electric,
}

extension FuelTypeExtension on FuelType {
  String get displayName {
    switch (this) {
      case FuelType.benzin95:
        return 'Benzin 95';
      case FuelType.diesel:
        return 'Dizel';
      case FuelType.lpg:
        return 'LPG';
      case FuelType.electric:
        return 'Elektrik';
    }
  }
  
  String get value {
    switch (this) {
      case FuelType.benzin95:
        return '95';
      case FuelType.diesel:
        return 'diesel';
      case FuelType.lpg:
        return 'lpg';
      case FuelType.electric:
        return 'electric';
    }
  }
}
