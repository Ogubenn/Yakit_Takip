import 'package:dartz/dartz.dart';
import '../entities/vehicle.dart';

/// Vehicle Repository Interface (Domain Layer)
abstract class VehicleRepository {
  /// Create new vehicle
  Future<Either<String, Vehicle>> createVehicle(Vehicle vehicle);

  /// Get all vehicles for current user
  Future<Either<String, List<Vehicle>>> getUserVehicles();

  /// Get vehicle by ID
  Future<Either<String, Vehicle>> getVehicleById(String id);

  /// Update vehicle
  Future<Either<String, Vehicle>> updateVehicle(Vehicle vehicle);

  /// Delete vehicle
  Future<Either<String, void>> deleteVehicle(String id);

  /// Set primary vehicle
  Future<Either<String, void>> setPrimaryVehicle(String id);

  /// Get primary vehicle
  Future<Either<String, Vehicle?>> getPrimaryVehicle();

  /// Sync pending vehicles to cloud
  Future<Either<String, void>> syncPendingVehicles();
}
