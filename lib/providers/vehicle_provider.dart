import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../features/fuel_entry/domain/entities/vehicle.dart';
import '../features/fuel_entry/domain/repositories/vehicle_repository.dart';
import 'app_providers.dart';

part 'vehicle_provider.freezed.dart';

/// Vehicle List State
@freezed
class VehicleListState with _$VehicleListState {
  const factory VehicleListState.initial() = _Initial;
  const factory VehicleListState.loading() = _Loading;
  const factory VehicleListState.loaded(List<Vehicle> vehicles) = _Loaded;
  const factory VehicleListState.error(String message) = _Error;
}

/// Vehicle List Notifier
class VehicleListNotifier extends StateNotifier<VehicleListState> {
  final VehicleRepository _repository;

  VehicleListNotifier(this._repository) : super(const VehicleListState.initial()) {
    loadVehicles();
  }

  Future<void> loadVehicles() async {
    state = const VehicleListState.loading();

    final result = await _repository.getUserVehicles();
    result.fold(
      (error) => state = VehicleListState.error(error),
      (vehicles) => state = VehicleListState.loaded(vehicles),
    );
  }

  Future<void> createVehicle(Vehicle vehicle) async {
    final currentState = state;
    state = const VehicleListState.loading();

    final result = await _repository.createVehicle(vehicle);
    result.fold(
      (error) {
        state = VehicleListState.error(error);
        // Restore previous state after a delay
        Future.delayed(const Duration(seconds: 2), () {
          state = currentState;
        });
      },
      (_) => loadVehicles(),
    );
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    final currentState = state;
    state = const VehicleListState.loading();

    final result = await _repository.updateVehicle(vehicle);
    result.fold(
      (error) {
        state = VehicleListState.error(error);
        Future.delayed(const Duration(seconds: 2), () {
          state = currentState;
        });
      },
      (_) => loadVehicles(),
    );
  }

  Future<void> deleteVehicle(String id) async {
    final currentState = state;
    state = const VehicleListState.loading();

    final result = await _repository.deleteVehicle(id);
    result.fold(
      (error) {
        state = VehicleListState.error(error);
        Future.delayed(const Duration(seconds: 2), () {
          state = currentState;
        });
      },
      (_) => loadVehicles(),
    );
  }

  Future<void> setPrimaryVehicle(String id) async {
    final currentState = state;
    state = const VehicleListState.loading();

    final result = await _repository.setPrimaryVehicle(id);
    result.fold(
      (error) {
        state = VehicleListState.error(error);
        Future.delayed(const Duration(seconds: 2), () {
          state = currentState;
        });
      },
      (_) => loadVehicles(),
    );
  }

  List<Vehicle> get vehicles {
    return state.maybeWhen(
      loaded: (vehicles) => vehicles,
      orElse: () => [],
    );
  }

  Vehicle? get primaryVehicle {
    return vehicles.isEmpty ? null : vehicles.firstWhere(
      (v) => v.isPrimary,
      orElse: () => vehicles.first,
    );
  }
}

// Provider for VehicleListNotifier
final vehicleListProvider = StateNotifierProvider<VehicleListNotifier, VehicleListState>((ref) {
  final repository = ref.watch(vehicleRepositoryProvider);
  return VehicleListNotifier(repository);
});

// Convenience providers
final vehiclesProvider = Provider<List<Vehicle>>((ref) {
  return ref.watch(vehicleListProvider.notifier).vehicles;
});

final primaryVehicleProvider = Provider<Vehicle?>((ref) {
  return ref.watch(vehicleListProvider.notifier).primaryVehicle;
});
