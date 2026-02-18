import 'package:hive/hive.dart';
import '../models/vehicle_model.dart';

/// Local Data Source for Vehicles (Hive)
class VehicleLocalDataSource {
  static const String boxName = 'vehicles';

  Future<Box<VehicleModel>> get _box async =>
      await Hive.openBox<VehicleModel>(boxName);

  /// Create vehicle
  Future<VehicleModel> createVehicle(VehicleModel vehicle) async {
    final box = await _box;
    await box.put(vehicle.id, vehicle);
    return vehicle;
  }

  /// Get all vehicles for user
  Future<List<VehicleModel>> getUserVehicles(String userId) async {
    final box = await _box;
    return box.values
        .where((vehicle) => vehicle.userId == userId && vehicle.isActive)
        .toList()
      ..sort((a, b) {
        if (a.isPrimary) return -1;
        if (b.isPrimary) return 1;
        return b.createdAt.compareTo(a.createdAt);
      });
  }

  /// Get vehicle by ID
  Future<VehicleModel?> getVehicleById(String id) async {
    final box = await _box;
    return box.get(id);
  }

  /// Update vehicle
  Future<VehicleModel> updateVehicle(VehicleModel vehicle) async {
    final box = await _box;
    await box.put(vehicle.id, vehicle);
    return vehicle;
  }

  /// Delete vehicle
  Future<void> deleteVehicle(String id) async {
    final box = await _box;
    final vehicle = box.get(id);
    if (vehicle != null) {
      final updated = VehicleModel(
        id: vehicle.id,
        userId: vehicle.userId,
        brand: vehicle.brand,
        model: vehicle.model,
        year: vehicle.year,
        plate: vehicle.plate,
        fuelType: vehicle.fuelType,
        tankCapacity: vehicle.tankCapacity,
        initialOdometer: vehicle.initialOdometer,
        isPrimary: false,
        isActive: false,
        imageUrl: vehicle.imageUrl,
        color: vehicle.color,
        syncStatus: 'pending',
        createdAt: vehicle.createdAt,
        updatedAt: DateTime.now(),
      );
      await box.put(id, updated);
    }
  }

  /// Set primary vehicle
  Future<void> setPrimaryVehicle(String userId, String vehicleId) async {
    final box = await _box;
    final vehicles = await getUserVehicles(userId);

    for (final vehicle in vehicles) {
      final updated = VehicleModel(
        id: vehicle.id,
        userId: vehicle.userId,
        brand: vehicle.brand,
        model: vehicle.model,
        year: vehicle.year,
        plate: vehicle.plate,
        fuelType: vehicle.fuelType,
        tankCapacity: vehicle.tankCapacity,
        initialOdometer: vehicle.initialOdometer,
        isPrimary: vehicle.id == vehicleId,
        isActive: vehicle.isActive,
        imageUrl: vehicle.imageUrl,
        color: vehicle.color,
        syncStatus: 'pending',
        createdAt: vehicle.createdAt,
        updatedAt: DateTime.now(),
      );
      await box.put(vehicle.id, updated);
    }
  }

  /// Get primary vehicle
  Future<VehicleModel?> getPrimaryVehicle(String userId) async {
    final vehicles = await getUserVehicles(userId);
    try {
      return vehicles.firstWhere((v) => v.isPrimary);
    } catch (e) {
      return vehicles.isEmpty ? null : vehicles.first;
    }
  }

  /// Get pending sync vehicles
  Future<List<VehicleModel>> getPendingVehicles() async {
    final box = await _box;
    return box.values.where((v) => v.syncStatus == 'pending').toList();
  }

  /// Mark vehicle as synced
  Future<void> markAsSynced(String id) async {
    final box = await _box;
    final vehicle = box.get(id);
    if (vehicle != null) {
      final updated = VehicleModel(
        id: vehicle.id,
        userId: vehicle.userId,
        brand: vehicle.brand,
        model: vehicle.model,
        year: vehicle.year,
        plate: vehicle.plate,
        fuelType: vehicle.fuelType,
        tankCapacity: vehicle.tankCapacity,
        initialOdometer: vehicle.initialOdometer,
        isPrimary: vehicle.isPrimary,
        isActive: vehicle.isActive,
        imageUrl: vehicle.imageUrl,
        color: vehicle.color,
        syncStatus: 'synced',
        createdAt: vehicle.createdAt,
        updatedAt: DateTime.now(),
      );
      await box.put(id, updated);
    }
  }

  /// Clear all vehicles
  Future<void> clearAll() async {
    final box = await _box;
    await box.clear();
  }
}
