import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/fuel_entry.dart';
import '../../domain/repositories/fuel_entry_repository.dart';
import '../datasources/fuel_entry_local_datasource.dart';
import '../datasources/fuel_entry_remote_datasource.dart';
import '../models/fuel_entry_model.dart';

/// Fuel Entry Repository Implementation
class FuelEntryRepositoryImpl implements FuelEntryRepository {
  final FuelEntryLocalDataSource localDataSource;
  final FuelEntryRemoteDataSource remoteDataSource;
  final Uuid uuid;

  FuelEntryRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.uuid,
  });

  @override
  Future<Either<String, FuelEntry>> createEntry(FuelEntry entry) async {
    try {
      // Generate ID if not provided
      final id = entry.id.isEmpty ? uuid.v4() : entry.id;
      
      final model = FuelEntryModel.fromEntity({
        ...entry.toJson(),
        'id': id,
        'syncStatus': 'pending',
        'updatedAt': DateTime.now().toIso8601String(),
      });

      // Save locally first
      await localDataSource.createEntry(model);

      // Try to sync to remote
      try {
        await remoteDataSource.syncEntry(model);
        await localDataSource.markAsSynced(id);
      } catch (e) {
        // Continue if remote sync fails (offline mode)
      }

      return Right(FuelEntry.fromJson(model.toEntity()));
    } catch (e) {
      return Left('Yakıt kaydı oluşturulamadı: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<FuelEntry>>> getEntriesByVehicle(
      String vehicleId) async {
    try {
      // Get from local first
      final localEntries = await localDataSource.getEntriesByVehicle(vehicleId);

      // Try to sync from remote
      try {
        final remoteEntries =
            await remoteDataSource.getEntriesByVehicle(vehicleId);
        
        // Save remote entries to local
        for (final entry in remoteEntries) {
          await localDataSource.createEntry(entry);
        }
        
        // Get updated local entries
        final updatedEntries =
            await localDataSource.getEntriesByVehicle(vehicleId);
        return Right(updatedEntries
            .map((e) => FuelEntry.fromJson(e.toEntity()))
            .toList());
      } catch (e) {
        // Return local entries if remote fetch fails
        return Right(localEntries
            .map((e) => FuelEntry.fromJson(e.toEntity()))
            .toList());
      }
    } catch (e) {
      return Left('Yakıt kayıtları getirilemedi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, FuelEntry>> getEntryById(String id) async {
    try {
      final entry = await localDataSource.getEntryById(id);
      if (entry == null) {
        return const Left('Kayıt bulunamadı');
      }
      return Right(FuelEntry.fromJson(entry.toEntity()));
    } catch (e) {
      return Left('Kayıt getirilemedi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, FuelEntry>> updateEntry(FuelEntry entry) async {
    try {
      final model = FuelEntryModel.fromEntity({
        ...entry.toJson(),
        'syncStatus': 'pending',
        'updatedAt': DateTime.now().toIso8601String(),
      });

      // Update locally first
      await localDataSource.updateEntry(model);

      // Try to sync to remote
      try {
        await remoteDataSource.updateEntry(model);
        await localDataSource.markAsSynced(entry.id);
      } catch (e) {
        // Continue if remote sync fails
      }

      return Right(FuelEntry.fromJson(model.toEntity()));
    } catch (e) {
      return Left('Kayıt güncellenemedi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> deleteEntry(String id) async {
    try {
      // Delete locally first
      await localDataSource.deleteEntry(id);

      // Try to delete from remote
      try {
        await remoteDataSource.deleteEntry(id);
      } catch (e) {
        // Continue if remote delete fails
      }

      return const Right(null);
    } catch (e) {
      return Left('Kayıt silinemedi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, FuelEntry?>> getLatestEntry(String vehicleId) async {
    try {
      final entry = await localDataSource.getLatestEntry(vehicleId);
      if (entry == null) {
        return const Right(null);
      }
      return Right(FuelEntry.fromJson(entry.toEntity()));
    } catch (e) {
      return Left('En son kayıt getirilemedi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<FuelEntry>>> getEntriesByDateRange(
    String vehicleId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final entries = await localDataSource.getEntriesByDateRange(
        vehicleId,
        startDate,
        endDate,
      );
      return Right(
          entries.map((e) => FuelEntry.fromJson(e.toEntity())).toList());
    } catch (e) {
      return Left('Kayıtlar getirilemedi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, double>> calculateAverageConsumption(
      String vehicleId) async {
    try {
      final entries = await localDataSource.getEntriesByVehicle(vehicleId);
      
      if (entries.length < 2) {
        return const Right(0.0);
      }

      // Filter full tank entries for accurate consumption calculation
      final fullTankEntries =
          entries.where((e) => e.isFullTank).toList();
      
      if (fullTankEntries.length < 2) {
        return const Right(0.0);
      }

      double totalConsumption = 0;
      int count = 0;

      for (int i = 0; i < fullTankEntries.length - 1; i++) {
        final current = fullTankEntries[i];
        final previous = fullTankEntries[i + 1];

        final distance = (current.odometer - previous.odometer).toDouble();
        final consumption = (current.liters / distance) * 100;

        if (consumption > 0 && consumption < 50) {
          // Reasonable consumption range
          totalConsumption += consumption;
          count++;
        }
      }

      if (count == 0) return const Right(0.0);

      return Right(totalConsumption / count);
    } catch (e) {
      return Left('Ortalama tüketim hesaplanamadı: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> syncPendingEntries() async {
    try {
      final pendingEntries = await localDataSource.getPendingEntries();

      for (final entry in pendingEntries) {
        try {
          await remoteDataSource.syncEntry(entry);
          await localDataSource.markAsSynced(entry.id);
        } catch (e) {
          // Continue with next entry if one fails
          continue;
        }
      }

      return const Right(null);
    } catch (e) {
      return Left('Senkronizasyon başarısız: ${e.toString()}');
    }
  }
}
