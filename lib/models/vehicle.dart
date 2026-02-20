import 'package:hive/hive.dart';
import '../core/constants/fuel_types.dart';

part 'vehicle.g.dart';

@HiveType(typeId: 0)
class Vehicle extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String brand;

  @HiveField(2)
  String model;

  @HiveField(3)
  int year;

  @HiveField(4)
  String fuelType; // FuelType enum'ın name'i

  @HiveField(5)
  double? engineSize;

  @HiveField(6)
  String? plateNumber;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  bool isActive;

  @HiveField(9)
  String? color;

  @HiveField(10)
  double? tankCapacity;

  Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.fuelType,
    this.engineSize,
    this.plateNumber,
    required this.createdAt,
    this.isActive = true,
    this.color,
    this.tankCapacity,
  });

  FuelType get fuelTypeEnum {
    return FuelType.values.firstWhere(
      (e) => e.name == fuelType,
      orElse: () => FuelType.benzin95,
    );
  }

  String get displayName => '$brand $model ($year)';

  Map<String, dynamic> toJson() => {
        'id': id,
        'brand': brand,
        'model': model,
        'year': year,
        'fuelType': fuelType,
        'engineSize': engineSize,
        'plateNumber': plateNumber,
        'createdAt': createdAt.toIso8601String(),
        'isActive': isActive,
        'color': color,
        'tankCapacity': tankCapacity,
      };

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json['id'],
        brand: json['brand'],
        model: json['model'],
        year: json['year'],
        fuelType: json['fuelType'],
        engineSize: json['engineSize'],
        plateNumber: json['plateNumber'],
        createdAt: DateTime.parse(json['createdAt']),
        isActive: json['isActive'] ?? true,
        color: json['color'],
        tankCapacity: json['tankCapacity'],
      );
}
