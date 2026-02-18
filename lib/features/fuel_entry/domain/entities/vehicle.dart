import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle.freezed.dart';
part 'vehicle.g.dart';

/// Vehicle Entity (Domain Layer)
@freezed
class Vehicle with _$Vehicle {
  const factory Vehicle({
    required String id,
    required String userId,
    required String brand,
    required String model,
    required int year,
    String? plate,
    required String fuelType,
    required double tankCapacity,
    required int initialOdometer,
    @Default(false) bool isPrimary,
    @Default(true) bool isActive,
    String? imageUrl,
    String? color,
    @Default('synced') String syncStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Vehicle;

  factory Vehicle.fromJson(Map<String, dynamic> json) =>
      _$VehicleFromJson(json);
}
