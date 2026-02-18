import 'package:dartz/dartz.dart';
import '../entities/vehicle.dart';
import '../repositories/vehicle_repository.dart';

/// Get User Vehicles Use Case
class GetUserVehicles {
  final VehicleRepository repository;

  GetUserVehicles(this.repository);

  Future<Either<String, List<Vehicle>>> call() async {
    return await repository.getUserVehicles();
  }
}
