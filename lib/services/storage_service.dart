import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vehicle.dart';
import '../models/fuel_record.dart';
import '../models/user.dart';
import '../core/constants/app_constants.dart';

class StorageService {
  static late Box<Vehicle> _vehiclesBox;
  static late Box<FuelRecord> _fuelRecordsBox;
  static late SharedPreferences _prefs;

  // Initialize Hive and boxes
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(VehicleAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(FuelRecordAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(UserAdapter());
    }

    // Open boxes
    _vehiclesBox = await Hive.openBox<Vehicle>(AppConstants.vehiclesBox);
    _fuelRecordsBox = await Hive.openBox<FuelRecord>(AppConstants.fuelRecordsBox);
    
    // Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();
  }

  // Vehicles
  static Box<Vehicle> get vehiclesBox => _vehiclesBox;
  
  static Future<void> saveVehicle(Vehicle vehicle) async {
    await _vehiclesBox.put(vehicle.id, vehicle);
  }

  static Vehicle? getVehicle(String id) {
    return _vehiclesBox.get(id);
  }

  static List<Vehicle> getAllVehicles() {
    return _vehiclesBox.values.where((v) => v.isActive).toList();
  }

  static Future<void> deleteVehicle(String id) async {
    final vehicle = _vehiclesBox.get(id);
    if (vehicle != null) {
      vehicle.isActive = false;
      await vehicle.save();
    }
  }

  // Fuel Records
  static Box<FuelRecord> get fuelRecordsBox => _fuelRecordsBox;

  static Future<void> saveFuelRecord(FuelRecord record) async {
    await _fuelRecordsBox.put(record.id, record);
  }

  static FuelRecord? getFuelRecord(String id) {
    return _fuelRecordsBox.get(id);
  }

  static List<FuelRecord> getFuelRecordsForVehicle(String vehicleId) {
    return _fuelRecordsBox.values
        .where((r) => r.vehicleId == vehicleId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static List<FuelRecord> getAllFuelRecords() {
    return _fuelRecordsBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static Future<void> deleteFuelRecord(String id) async {
    await _fuelRecordsBox.delete(id);
  }

  // Settings
  static SharedPreferences get prefs => _prefs;

  static bool get isPremium {
    return _prefs.getBool(AppConstants.premiumKey) ?? false;
  }

  static Future<void> setPremium(bool value) async {
    await _prefs.setBool(AppConstants.premiumKey, value);
  }

  static String? get selectedVehicleId {
    return _prefs.getString('selected_vehicle_id');
  }

  static Future<void> setSelectedVehicleId(String? id) async {
    if (id != null) {
      await _prefs.setString('selected_vehicle_id', id);
    } else {
      await _prefs.remove('selected_vehicle_id');
    }
  }

  // Clear all data
  static Future<void> clearAll() async {
    await _vehiclesBox.clear();
    await _fuelRecordsBox.clear();
    await _prefs.clear();
  }
}
