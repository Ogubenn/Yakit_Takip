import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../datasources/vehicle_local_datasource.dart';
import '../datasources/vehicle_remote_datasource.dart';
import '../models/vehicle_model.dart';

/// Vehicle Repository Implementation
class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleLocalDataSource localDataSource;
  final VehicleRemoteDataSource remoteDataSource;
  final Uuid uuid;
  final String userId; // Current user ID

  VehicleRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.uuid,
    required this.userId,
  });

  @override
  Future<Either<String, Vehicle>> createVehicle(Vehicle vehicle) async {
    try {
      // Generate ID if not provided
      final id = vehicle.id.isEmpty ? uuid.v4() : vehicle.id;
      
      final model = VehicleModel.fromEntity({
        ...vehicle.toJson(),
        'id': id,
        'userId': userId,
        'syncStatus': 'pending',
        'updatedAt': DateTime.now().toIso8601String(),
      });

      // Save locally first
      await localDataSource.createVehicle(model);

      // Try to sync to remote
      try {
        await remoteDataSource.syncVehicle(model);
        await localDataSource.markAsSynced(id);
      } catch (e) {
        // Continue if remote sync fails
      }

      return Right(Vehicle.fromJson(model.toEntity()));
    } catch (e) {
      return Left('Araç oluşturulamadı: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<Vehicle>>> getUserVehicles() async {
    try {
      // Get from local first
      final localVehicles = await localDataSource.getUserVehicles(userId);

      // Try to sync from remote
      try {
        final remoteVehicles = await remoteDataSource.getUserVehicles(userId);
        
        // Save remote vehicles to local
        for (final vehicle in remoteVehicles) {
          await localDataSource.createVehicle(vehicle);
        }
        
        // Get updated local vehicles
        final updatedVehicles = await localDataSource.getUserVehicles(userId);
        return Right(updatedVehicles
            .map((v) => Vehicle.fromJson(v.toEntity()))
            .toList());
      } catch (e) {
        // Return local vehicles if remote fetch fails
        return Right(localVehicles
            .map((v) => Vehicle.fromJson(v.toEntity()))
            .toList());
      }
    } catch (e) {
      return Left('Araçlar getirilemedi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, Vehicle>> getVehicleById(String id) async {
    try {
      final vehicle = await localDataSource.getVehicleById(id);
      if (vehicle == null) {
        return const Left('Araç bulunamadı');
      }
      return Right(Vehicle.fromJson(vehicle.toEntity()));
    } catch (e) {
      return Left('Araç getirilemedi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, Vehicle>> updateVehicle(Vehicle vehicle) async {
    try {
      final model = VehicleModel.fromEntity({
        ...vehicle.toJson(),
        'syncStatus': 'pending',
        'updatedAt': DateTime.now().toIso8601String(),
      });

      // Update locally first
      await localDataSource.updateVehicle(model);

      // Try to sync to remote
      try {
        await remoteDataSource.updateVehicle(model);
        await localDataSource.markAsSynced(vehicle.id);
      } catch (e) {
        // Continue if remote sync fails
      }

      return Right(Vehicle.fromJson(model.toEntity()));
    } catch (e) {
      return Left('Araç güncellenemedi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> deleteVehicle(String id) async {
    try {
      // Delete locally first
      await localDataSource.deleteVehicle(id);

      // Try to delete from remote
      try {
        await remoteDataSource.deleteVehicle(id);
      } catch (e) {
        // Continue if remote delete fails
      }

      return const Right(null);
    } catch (e) {
      return Left('Araç silinemedi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> setPrimaryVehicle(String id) async {
    try {
      // Set locally first
      await localDataSource.setPrimaryVehicle(userId, id);

      // Try to sync to remote
      try {
        await remoteDataSource.setPrimaryVehicle(userId, id);
      } catch (e) {
        // Continue if remote sync fails
      }

      return const Right(null);
    } catch (e) {
      return Left('Ana araç ayarlanamadı: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, Vehicle?>> getPrimaryVehicle() async {
    try {
      final vehicle = await localDataSource.getPrimaryVehicle(userId);
      if (vehicle == null) {
        return const Right(null);
      }
      return Right(Vehicle.fromJson(vehicle.toEntity()));
    } catch (e) {
      return Left('Ana araç getirilemedi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> syncPendingVehicles() async {
    try {
      final pendingVehicles = await localDataSource.getPendingVehicles();

      for (final vehicle in pendingVehicles) {
        try {
          await remoteDataSource.syncVehicle(vehicle);
          await localDataSource.markAsSynced(vehicle.id);
        } catch (e) {
          // Continue with next vehicle if one fails
          continue;
        }
      }

      return const Right(null);
    } catch (e) {
      return Left('Senkronizasyon başarısız: ${e.toString()}');
    }
  }
}
