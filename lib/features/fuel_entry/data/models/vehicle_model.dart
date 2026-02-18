import 'package:hive/hive.dart';

/// Vehicle Model (Data Layer - Local Storage)
@HiveType(typeId: 1)
class VehicleModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String brand;

  @HiveField(3)
  final String model;

  @HiveField(4)
  final int year;

  @HiveField(5)
  final String? plate;

  @HiveField(6)
  final String fuelType;

  @HiveField(7)
  final double tankCapacity;

  @HiveField(8)
  final int initialOdometer;

  @HiveField(9)
  final bool isPrimary;

  @HiveField(10)
  final bool isActive;

  @HiveField(11)
  final String? imageUrl;

  @HiveField(12)
  final String? color;

  @HiveField(13)
  final String syncStatus;

  @HiveField(14)
  final DateTime createdAt;

  @HiveField(15)
  final DateTime updatedAt;

  VehicleModel({
    required this.id,
    required this.userId,
    required this.brand,
    required this.model,
    required this.year,
    this.plate,
    required this.fuelType,
    required this.tankCapacity,
    required this.initialOdometer,
    required this.isPrimary,
    required this.isActive,
    this.imageUrl,
    this.color,
    required this.syncStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert to Domain Entity
  Map<String, dynamic> toEntity() {
    return {
      'id': id,
      'userId': userId,
      'brand': brand,
      'model': model,
      'year': year,
      'plate': plate,
      'fuelType': fuelType,
      'tankCapacity': tankCapacity,
      'initialOdometer': initialOdometer,
      'isPrimary': isPrimary,
      'isActive': isActive,
      'imageUrl': imageUrl,
      'color': color,
      'syncStatus': syncStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Convert from Domain Entity
  factory VehicleModel.fromEntity(Map<String, dynamic> entity) {
    return VehicleModel(
      id: entity['id'] as String,
      userId: entity['userId'] as String,
      brand: entity['brand'] as String,
      model: entity['model'] as String,
      year: entity['year'] as int,
      plate: entity['plate'] as String?,
      fuelType: entity['fuelType'] as String,
      tankCapacity: (entity['tankCapacity'] as num).toDouble(),
      initialOdometer: entity['initialOdometer'] as int,
      isPrimary: entity['isPrimary'] as bool? ?? false,
      isActive: entity['isActive'] as bool? ?? true,
      imageUrl: entity['imageUrl'] as String?,
      color: entity['color'] as String?,
      syncStatus: entity['syncStatus'] as String? ?? 'synced',
      createdAt: DateTime.parse(entity['createdAt'] as String),
      updatedAt: DateTime.parse(entity['updatedAt'] as String),
    );
  }

  /// Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'brand': brand,
      'model': model,
      'year': year,
      'plate': plate,
      'fuelType': fuelType,
      'tankCapacity': tankCapacity,
      'initialOdometer': initialOdometer,
      'isPrimary': isPrimary,
      'isActive': isActive,
      'imageUrl': imageUrl,
      'color': color,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Convert from Firestore
  factory VehicleModel.fromFirestore(String id, Map<String, dynamic> data) {
    return VehicleModel(
      id: id,
      userId: data['userId'] as String,
      brand: data['brand'] as String,
      model: data['model'] as String,
      year: data['year'] as int,
      plate: data['plate'] as String?,
      fuelType: data['fuelType'] as String,
      tankCapacity: (data['tankCapacity'] as num).toDouble(),
      initialOdometer: data['initialOdometer'] as int,
      isPrimary: data['isPrimary'] as bool? ?? false,
      isActive: data['isActive'] as bool? ?? true,
      imageUrl: data['imageUrl'] as String?,
      color: data['color'] as String?,
      syncStatus: 'synced',
      createdAt: DateTime.parse(data['createdAt'] as String),
      updatedAt: DateTime.parse(data['updatedAt'] as String),
    );
  }
}
