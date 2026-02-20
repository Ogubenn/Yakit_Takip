import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants/api_constants.dart';
import '../models/vehicle.dart';
import '../models/fuel_record.dart';
import 'api_client.dart';
import 'storage_service.dart';

enum SyncStatus { idle, syncing, success, error }

class SyncService {
  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  SyncStatus _status = SyncStatus.idle;
  String? _lastError;
  DateTime? _lastSyncTime;

  SyncStatus get status => _status;
  String? get lastError => _lastError;
  DateTime? get lastSyncTime => _lastSyncTime;

  // Full sync: Upload local data to server
  Future<bool> syncToServer() async {
    try {
      _status = SyncStatus.syncing;
      
      // Get all local data
      final vehicles = StorageService.getAllVehicles();
      final fuelRecords = StorageService.getAllFuelRecords();

      // Upload to server
      await _apiClient.post(
        ApiConstants.syncUpload,
        data: {
          'vehicles': vehicles.map((v) => v.toJson()).toList(),
          'fuel_records': fuelRecords.map((r) => r.toJson()).toList(),
        },
      );

      _status = SyncStatus.success;
      _lastError = null;
      _lastSyncTime = DateTime.now();
      await _saveLastSyncTime();

      return true;
    } catch (e) {
      _status = SyncStatus.error;
      _lastError = e.toString();
      return false;
    } finally {
      _status = SyncStatus.idle;
    }
  }

  // Full sync: Download server data to local
  Future<bool> syncFromServer() async {
    try {
      _status = SyncStatus.syncing;
      
      final response = await _apiClient.get(ApiConstants.syncDownload);
      
      // Clear local data
      final vehiclesBox = await Hive.openBox<Vehicle>('vehicles');
      final recordsBox = await Hive.openBox<FuelRecord>('fuelRecords');
      
      await vehiclesBox.clear();
      await recordsBox.clear();

      // Save server data locally
      final vehicles = (response.data['vehicles'] as List)
          .map((json) => Vehicle.fromJson(json))
          .toList();
      
      final records = (response.data['fuel_records'] as List)
          .map((json) => FuelRecord.fromJson(json))
          .toList();

      for (var vehicle in vehicles) {
        await vehiclesBox.put(vehicle.id, vehicle);
      }

      for (var record in records) {
        await recordsBox.put(record.id, record);
      }

      _status = SyncStatus.success;
      _lastError = null;
      _lastSyncTime = DateTime.now();
      await _saveLastSyncTime();

      return true;
    } catch (e) {
      _status = SyncStatus.error;
      _lastError = e.toString();
      return false;
    } finally {
      _status = SyncStatus.idle;
    }
  }

  // Incremental sync: Only sync changes
  Future<bool> syncChanges() async {
    try {
      _status = SyncStatus.syncing;
      
      final lastSync = await _getLastSyncTime();
      final queryParams = lastSync != null 
          ? {'since': lastSync.toIso8601String()}
          : null;

      final response = await _apiClient.get(
        ApiConstants.syncChanges,
        queryParameters: queryParams,
      );

      // Merge server changes with local data
      final vehiclesBox = await Hive.openBox<Vehicle>('vehicles');
      final recordsBox = await Hive.openBox<FuelRecord>('fuelRecords');

      final vehicles = (response.data['vehicles'] as List)
          .map((json) => Vehicle.fromJson(json))
          .toList();
      
      final records = (response.data['fuel_records'] as List)
          .map((json) => FuelRecord.fromJson(json))
          .toList();

      for (var vehicle in vehicles) {
        await vehiclesBox.put(vehicle.id, vehicle);
      }

      for (var record in records) {
        await recordsBox.put(record.id, record);
      }

      _status = SyncStatus.success;
      _lastError = null;
      _lastSyncTime = DateTime.now();
      await _saveLastSyncTime();

      return true;
    } catch (e) {
      _status = SyncStatus.error;
      _lastError = e.toString();
      return false;
    } finally {
      _status = SyncStatus.idle;
    }
  }

  // Auto sync (smart sync based on last sync time)
  Future<bool> autoSync() async {
    final lastSync = await _getLastSyncTime();
    
    if (lastSync == null) {
      // First time, full download from server
      return await syncFromServer();
    } else {
      // Incremental sync
      return await syncChanges();
    }
  }

  Future<void> _saveLastSyncTime() async {
    await _storage.write(
      key: ApiConstants.lastSyncKey,
      value: DateTime.now().toIso8601String(),
    );
  }

  Future<DateTime?> _getLastSyncTime() async {
    final value = await _storage.read(key: ApiConstants.lastSyncKey);
    return value != null ? DateTime.parse(value) : null;
  }

  // Check if sync is needed (>1 hour since last sync)
  Future<bool> needsSync() async {
    final lastSync = await _getLastSyncTime();
    if (lastSync == null) return true;
    
    final hoursSinceSync = DateTime.now().difference(lastSync).inHours;
    return hoursSinceSync > 1;
  }
}
