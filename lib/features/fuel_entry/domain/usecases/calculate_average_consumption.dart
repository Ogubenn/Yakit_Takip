import 'package:dartz/dartz.dart';
import '../repositories/fuel_entry_repository.dart';

/// Calculate Average Consumption Use Case
class CalculateAverageConsumption {
  final FuelEntryRepository repository;

  CalculateAverageConsumption(this.repository);

  Future<Either<String, double>> call(String vehicleId) async {
    if (vehicleId.isEmpty) {
      return const Left('Araç ID\'si gerekli');
    }

    return await repository.calculateAverageConsumption(vehicleId);
  }
}
