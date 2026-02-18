import 'package:hive/hive.dart';
import '../models/fuel_entry_model.dart';

/// Local Data Source for Fuel Entries (Hive)
class FuelEntryLocalDataSource {
  static const String boxName = 'fuel_entries';

  Future<Box<FuelEntryModel>> get _box async =>
      await Hive.openBox<FuelEntryModel>(boxName);

  /// Create fuel entry
  Future<FuelEntryModel> createEntry(FuelEntryModel entry) async {
    final box = await _box;
    await box.put(entry.id, entry);
    return entry;
  }

  /// Get all entries for a vehicle
  Future<List<FuelEntryModel>> getEntriesByVehicle(String vehicleId) async {
    final box = await _box;
    return box.values
        .where((entry) => entry.vehicleId == vehicleId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Get entry by ID
  Future<FuelEntryModel?> getEntryById(String id) async {
    final box = await _box;
    return box.get(id);
  }

  /// Update entry
  Future<FuelEntryModel> updateEntry(FuelEntryModel entry) async {
    final box = await _box;
    await box.put(entry.id, entry);
    return entry;
  }

  /// Delete entry
  Future<void> deleteEntry(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  /// Get latest entry for vehicle
  Future<FuelEntryModel?> getLatestEntry(String vehicleId) async {
    final entries = await getEntriesByVehicle(vehicleId);
    return entries.isEmpty ? null : entries.first;
  }

  /// Get entries by date range
  Future<List<FuelEntryModel>> getEntriesByDateRange(
    String vehicleId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final box = await _box;
    return box.values
        .where((entry) =>
            entry.vehicleId == vehicleId &&
            entry.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
            entry.date.isBefore(endDate.add(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Get pending sync entries
  Future<List<FuelEntryModel>> getPendingEntries() async {
    final box = await _box;
    return box.values.where((entry) => entry.syncStatus == 'pending').toList();
  }

  /// Mark entry as synced
  Future<void> markAsSynced(String id) async {
    final box = await _box;
    final entry = box.get(id);
    if (entry != null) {
      final updated = FuelEntryModel(
        id: entry.id,
        userId: entry.userId,
        vehicleId: entry.vehicleId,
        date: entry.date,
        odometer: entry.odometer,
        liters: entry.liters,
        pricePerLiter: entry.pricePerLiter,
        totalCost: entry.totalCost,
        fuelType: entry.fuelType,
        isFullTank: entry.isFullTank,
        note: entry.note,
        stationName: entry.stationName,
        consumption: entry.consumption,
        costPerKm: entry.costPerKm,
        syncStatus: 'synced',
        createdAt: entry.createdAt,
        updatedAt: DateTime.now(),
      );
      await box.put(id, updated);
    }
  }

  /// Clear all entries
  Future<void> clearAll() async {
    final box = await _box;
    await box.clear();
  }
}
