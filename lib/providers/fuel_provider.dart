import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/fuel_record.dart';
import '../services/storage_service.dart';
import 'vehicle_provider.dart';

// Fuel Records Provider
final fuelRecordsProvider = StateNotifierProvider<FuelRecordsNotifier, List<FuelRecord>>((ref) {
  return FuelRecordsNotifier();
});

class FuelRecordsNotifier extends StateNotifier<List<FuelRecord>> {
  FuelRecordsNotifier() : super([]) {
    loadRecords();
  }

  void loadRecords() {
    state = StorageService.getAllFuelRecords();
  }

  Future<void> addRecord(FuelRecord record) async {
    await StorageService.saveFuelRecord(record);
    state = [record, ...state];
  }

  Future<void> updateRecord(FuelRecord record) async {
    await StorageService.saveFuelRecord(record);
    state = [
      for (final r in state)
        if (r.id == record.id) record else r,
    ];
  }

  Future<void> deleteRecord(String id) async {
    await StorageService.deleteFuelRecord(id);
    state = state.where((r) => r.id != id).toList();
  }

  Future<FuelRecord> createRecord({
    required String vehicleId,
    required double liters,
    required double pricePerLiter,
    double? odometer,
    String? station,
    String? city,
    bool isFullTank = true,
    String? notes,
  }) async {
    final record = FuelRecord(
      id: const Uuid().v4(),
      vehicleId: vehicleId,
      date: DateTime.now(),
      liters: liters,
      pricePerLiter: pricePerLiter,
      totalCost: liters * pricePerLiter,
      odometer: odometer,
      station: station,
      city: city,
      isFullTank: isFullTank,
      notes: notes,
      createdAt: DateTime.now(),
    );
    await addRecord(record);
    return record;
  }
}

// Records for Current Vehicle
final currentVehicleRecordsProvider = Provider<List<FuelRecord>>((ref) {
  final currentVehicle = ref.watch(currentVehicleProvider);
  final allRecords = ref.watch(fuelRecordsProvider);
  
  if (currentVehicle == null) return [];
  
  return allRecords.where((r) => r.vehicleId == currentVehicle.id).toList();
});

// Analytics Provider
final fuelAnalyticsProvider = Provider<FuelAnalytics>((ref) {
  final records = ref.watch(currentVehicleRecordsProvider);
  return FuelAnalytics(records);
});

class FuelAnalytics {
  final List<FuelRecord> records;

  FuelAnalytics(this.records);

  // Toplam harcama
  double get totalSpent {
    return records.fold(0.0, (sum, record) => sum + record.totalCost);
  }

  // Toplam litre
  double get totalLiters {
    return records.fold(0.0, (sum, record) => sum + record.liters);
  }

  // Ortalama litre fiyatı
  double get averagePricePerLiter {
    if (records.isEmpty) return 0.0;
    return totalSpent / totalLiters;
  }

  // Ortalama yakıt tüketimi (L/100km)
  double? get averageConsumption {
    final consumptions = <double>[];
    
    for (int i = 0; i < records.length - 1; i++) {
      final current = records[i];
      final previous = records[i + 1];
      final consumption = current.calculateConsumption(previous);
      if (consumption != null && consumption > 0 && consumption < 50) {
        consumptions.add(consumption);
      }
    }

    if (consumptions.isEmpty) return null;
    return consumptions.reduce((a, b) => a + b) / consumptions.length;
  }

  // Bu ayki harcama
  double get thisMonthSpent {
    final now = DateTime.now();
    return records
        .where((r) => r.date.year == now.year && r.date.month == now.month)
        .fold(0.0, (sum, record) => sum + record.totalCost);
  }

  // Geçen ayki harcama
  double get lastMonthSpent {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1);
    return records
        .where((r) => r.date.year == lastMonth.year && r.date.month == lastMonth.month)
        .fold(0.0, (sum, record) => sum + record.totalCost);
  }

  // Bu ay vs geçen ay değişim yüzdesi
  double get monthlyChangePercentage {
    if (lastMonthSpent == 0) return 0;
    return ((thisMonthSpent - lastMonthSpent) / lastMonthSpent) * 100;
  }

  // Son dolum tarihi
  DateTime? get lastFuelDate {
    if (records.isEmpty) return null;
    return records.first.date;
  }

  // En çok yakıt alınan istasyon
  String? get mostUsedStation {
    if (records.isEmpty) return null;
    
    final stationCounts = <String, int>{};
    for (final record in records) {
      if (record.station != null) {
        stationCounts[record.station!] = (stationCounts[record.station!] ?? 0) + 1;
      }
    }

    if (stationCounts.isEmpty) return null;

    return stationCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}
