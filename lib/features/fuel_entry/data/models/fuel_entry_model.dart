import 'package:hive/hive.dart';

/// Fuel Entry Model (Data Layer - Local Storage)
@HiveType(typeId: 0)
class FuelEntryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String vehicleId;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final int odometer;

  @HiveField(5)
  final double liters;

  @HiveField(6)
  final double pricePerLiter;

  @HiveField(7)
  final double totalCost;

  @HiveField(8)
  final String fuelType;

  @HiveField(9)
  final bool isFullTank;

  @HiveField(10)
  final String? note;

  @HiveField(11)
  final String? stationName;

  @HiveField(12)
  final double? consumption;

  @HiveField(13)
  final double? costPerKm;

  @HiveField(14)
  final String syncStatus;

  @HiveField(15)
  final DateTime createdAt;

  @HiveField(16)
  final DateTime updatedAt;

  FuelEntryModel({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.date,
    required this.odometer,
    required this.liters,
    required this.pricePerLiter,
    required this.totalCost,
    required this.fuelType,
    required this.isFullTank,
    this.note,
    this.stationName,
    this.consumption,
    this.costPerKm,
    required this.syncStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert to Domain Entity
  Map<String, dynamic> toEntity() {
    return {
      'id': id,
      'userId': userId,
      'vehicleId': vehicleId,
      'date': date.toIso8601String(),
      'odometer': odometer,
      'liters': liters,
      'pricePerLiter': pricePerLiter,
      'totalCost': totalCost,
      'fuelType': fuelType,
      'isFullTank': isFullTank,
      'note': note,
      'stationName': stationName,
      'consumption': consumption,
      'costPerKm': costPerKm,
      'syncStatus': syncStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Convert from Domain Entity
  factory FuelEntryModel.fromEntity(Map<String, dynamic> entity) {
    return FuelEntryModel(
      id: entity['id'] as String,
      userId: entity['userId'] as String,
      vehicleId: entity['vehicleId'] as String,
      date: DateTime.parse(entity['date'] as String),
      odometer: entity['odometer'] as int,
      liters: (entity['liters'] as num).toDouble(),
      pricePerLiter: (entity['pricePerLiter'] as num).toDouble(),
      totalCost: (entity['totalCost'] as num).toDouble(),
      fuelType: entity['fuelType'] as String,
      isFullTank: entity['isFullTank'] as bool? ?? true,
      note: entity['note'] as String?,
      stationName: entity['stationName'] as String?,
      consumption: (entity['consumption'] as num?)?.toDouble(),
      costPerKm: (entity['costPerKm'] as num?)?.toDouble(),
      syncStatus: entity['syncStatus'] as String? ?? 'synced',
      createdAt: DateTime.parse(entity['createdAt'] as String),
      updatedAt: DateTime.parse(entity['updatedAt'] as String),
    );
  }

  /// Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'vehicleId': vehicleId,
      'date': date.toIso8601String(),
      'odometer': odometer,
      'liters': liters,
      'pricePerLiter': pricePerLiter,
      'totalCost': totalCost,
      'fuelType': fuelType,
      'isFullTank': isFullTank,
      'note': note,
      'stationName': stationName,
      'consumption': consumption,
      'costPerKm': costPerKm,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Convert from Firestore
  factory FuelEntryModel.fromFirestore(String id, Map<String, dynamic> data) {
    return FuelEntryModel(
      id: id,
      userId: data['userId'] as String,
      vehicleId: data['vehicleId'] as String,
      date: DateTime.parse(data['date'] as String),
      odometer: data['odometer'] as int,
      liters: (data['liters'] as num).toDouble(),
      pricePerLiter: (data['pricePerLiter'] as num).toDouble(),
      totalCost: (data['totalCost'] as num).toDouble(),
      fuelType: data['fuelType'] as String,
      isFullTank: data['isFullTank'] as bool? ?? true,
      note: data['note'] as String?,
      stationName: data['stationName'] as String?,
      consumption: (data['consumption'] as num?)?.toDouble(),
      costPerKm: (data['costPerKm'] as num?)?.toDouble(),
      syncStatus: 'synced',
      createdAt: DateTime.parse(data['createdAt'] as String),
      updatedAt: DateTime.parse(data['updatedAt'] as String),
    );
  }
}
