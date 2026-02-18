import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../features/fuel_entry/domain/entities/fuel_entry.dart';
import '../features/fuel_entry/domain/repositories/fuel_entry_repository.dart';
import 'app_providers.dart';

part 'fuel_entry_provider.freezed.dart';

/// Fuel Entry List State
@freezed
class FuelEntryListState with _$FuelEntryListState {
  const factory FuelEntryListState.initial() = _Initial;
  const factory FuelEntryListState.loading() = _Loading;
  const factory FuelEntryListState.loaded(List<FuelEntry> entries) = _Loaded;
  const factory FuelEntryListState.error(String message) = _Error;
}

/// Fuel Entry List Notifier
class FuelEntryListNotifier extends StateNotifier<FuelEntryListState> {
  final FuelEntryRepository _repository;
  String? _currentVehicleId;

  FuelEntryListNotifier(this._repository)
      : super(const FuelEntryListState.initial());

  Future<void> loadEntriesForVehicle(String vehicleId) async {
    _currentVehicleId = vehicleId;
    state = const FuelEntryListState.loading();

    final result = await _repository.getEntriesByVehicle(vehicleId);
    result.fold(
      (error) => state = FuelEntryListState.error(error),
      (entries) => state = FuelEntryListState.loaded(entries),
    );
  }

  Future<void> createEntry(FuelEntry entry) async {
    final currentState = state;
    state = const FuelEntryListState.loading();

    final result = await _repository.createEntry(entry);
    result.fold(
      (error) {
        state = FuelEntryListState.error(error);
        Future.delayed(const Duration(seconds: 2), () {
          state = currentState;
        });
      },
      (_) {
        if (_currentVehicleId != null) {
          loadEntriesForVehicle(_currentVehicleId!);
        }
      },
    );
  }

  Future<void> updateEntry(FuelEntry entry) async {
    final currentState = state;
    state = const FuelEntryListState.loading();

    final result = await _repository.updateEntry(entry);
    result.fold(
      (error) {
        state = FuelEntryListState.error(error);
        Future.delayed(const Duration(seconds: 2), () {
          state = currentState;
        });
      },
      (_) {
        if (_currentVehicleId != null) {
          loadEntriesForVehicle(_currentVehicleId!);
        }
      },
    );
  }

  Future<void> deleteEntry(String id) async {
    final currentState = state;
    state = const FuelEntryListState.loading();

    final result = await _repository.deleteEntry(id);
    result.fold(
      (error) {
        state = FuelEntryListState.error(error);
        Future.delayed(const Duration(seconds: 2), () {
          state = currentState;
        });
      },
      (_) {
        if (_currentVehicleId != null) {
          loadEntriesForVehicle(_currentVehicleId!);
        }
      },
    );
  }

  Future<double> getAverageConsumption(String vehicleId) async {
    final result = await _repository.calculateAverageConsumption(vehicleId);
    return result.fold(
      (_) => 0.0,
      (consumption) => consumption,
    );
  }

  List<FuelEntry> get entries {
    return state.maybeWhen(
      loaded: (entries) => entries,
      orElse: () => [],
    );
  }

  FuelEntry? get latestEntry {
    return entries.isEmpty ? null : entries.first;
  }
}

// Provider for FuelEntryListNotifier
final fuelEntryListProvider =
    StateNotifierProvider<FuelEntryListNotifier, FuelEntryListState>((ref) {
  final repository = ref.watch(fuelEntryRepositoryProvider);
  return FuelEntryListNotifier(repository);
});

// Convenience providers
final fuelEntriesProvider = Provider<List<FuelEntry>>((ref) {
  return ref.watch(fuelEntryListProvider.notifier).entries;
});

final latestFuelEntryProvider = Provider<FuelEntry?>((ref) {
  return ref.watch(fuelEntryListProvider.notifier).latestEntry;
});

// Provider for average consumption
final averageConsumptionProvider =
    FutureProvider.family<double, String>((ref, vehicleId) async {
  final repository = ref.watch(fuelEntryRepositoryProvider);
  final result = await repository.calculateAverageConsumption(vehicleId);
  return result.fold(
    (_) => 0.0,
    (consumption) => consumption,
  );
});
