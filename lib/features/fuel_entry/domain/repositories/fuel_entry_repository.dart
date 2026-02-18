import 'package:dartz/dartz.dart';
import '../entities/fuel_entry.dart';

/// Fuel Entry Repository Interface (Domain Layer)
abstract class FuelEntryRepository {
  /// Create new fuel entry
  Future<Either<String, FuelEntry>> createEntry(FuelEntry entry);

  /// Get all fuel entries for a vehicle
  Future<Either<String, List<FuelEntry>>> getEntriesByVehicle(String vehicleId);

  /// Get fuel entry by ID
  Future<Either<String, FuelEntry>> getEntryById(String id);

  /// Update fuel entry
  Future<Either<String, FuelEntry>> updateEntry(FuelEntry entry);

  /// Delete fuel entry
  Future<Either<String, void>> deleteEntry(String id);

  /// Get latest fuel entry for a vehicle
  Future<Either<String, FuelEntry?>> getLatestEntry(String vehicleId);

  /// Get fuel entries by date range
  Future<Either<String, List<FuelEntry>>> getEntriesByDateRange(
    String vehicleId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Calculate average consumption for a vehicle
  Future<Either<String, double>> calculateAverageConsumption(String vehicleId);

  /// Sync pending entries to cloud
  Future<Either<String, void>> syncPendingEntries();
}
