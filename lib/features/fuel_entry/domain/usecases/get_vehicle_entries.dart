import 'package:dartz/dartz.dart';
import '../entities/fuel_entry.dart';
import '../repositories/fuel_entry_repository.dart';

/// Get Vehicle Fuel Entries Use Case
class GetVehicleEntries {
  final FuelEntryRepository repository;

  GetVehicleEntries(this.repository);

  Future<Either<String, List<FuelEntry>>> call(String vehicleId) async {
    if (vehicleId.isEmpty) {
      return const Left('Araç ID\'si gerekli');
    }

    return await repository.getEntriesByVehicle(vehicleId);
  }
}
