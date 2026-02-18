import 'package:dartz/dartz.dart';
import '../entities/fuel_entry.dart';
import '../repositories/fuel_entry_repository.dart';

/// Create Fuel Entry Use Case
class CreateFuelEntry {
  final FuelEntryRepository repository;

  CreateFuelEntry(this.repository);

  Future<Either<String, FuelEntry>> call(FuelEntry entry) async {
    // Validate entry
    if (entry.liters <= 0) {
      return const Left('Litre değeri 0\'dan büyük olmalıdır');
    }
    if (entry.pricePerLiter <= 0) {
      return const Left('Litre fiyatı 0\'dan büyük olmalıdır');
    }
    if (entry.odometer <= 0) {
      return const Left('Kilometre değeri 0\'dan büyük olmalıdır');
    }

    return await repository.createEntry(entry);
  }
}
