import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/vehicle.dart';
import '../services/storage_service.dart';

// Selected Vehicle Provider
final selectedVehicleIdProvider = StateProvider<String?>((ref) {
  return StorageService.selectedVehicleId;
});

// Vehicles List Provider
final vehiclesProvider = StateNotifierProvider<VehiclesNotifier, List<Vehicle>>((ref) {
  return VehiclesNotifier();
});

class VehiclesNotifier extends StateNotifier<List<Vehicle>> {
  VehiclesNotifier() : super([]) {
    loadVehicles();
  }

  void loadVehicles() {
    state = StorageService.getAllVehicles();
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    await StorageService.saveVehicle(vehicle);
    state = [...state, vehicle];
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    await StorageService.saveVehicle(vehicle);
    state = [
      for (final v in state)
        if (v.id == vehicle.id) vehicle else v,
    ];
  }

  Future<void> deleteVehicle(String id) async {
    await StorageService.deleteVehicle(id);
    state = state.where((v) => v.id != id).toList();
  }

  Future<Vehicle> createDefaultVehicle({
    required String brand,
    required String model,
    required int year,
    required String fuelType,
  }) async {
    final vehicle = Vehicle(
      id: const Uuid().v4(),
      brand: brand,
      model: model,
      year: year,
      fuelType: fuelType,
      createdAt: DateTime.now(),
    );
    await addVehicle(vehicle);
    return vehicle;
  }
}

// Current Vehicle Provider (combines selected ID with vehicles list)
final currentVehicleProvider = Provider<Vehicle?>((ref) {
  final selectedId = ref.watch(selectedVehicleIdProvider);
  final vehicles = ref.watch(vehiclesProvider);
  
  if (selectedId == null && vehicles.isNotEmpty) {
    // Auto-select first vehicle if none selected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedVehicleIdProvider.notifier).state = vehicles.first.id;
      StorageService.setSelectedVehicleId(vehicles.first.id);
    });
    return vehicles.first;
  }
  
  return vehicles.where((v) => v.id == selectedId).firstOrNull;
});

