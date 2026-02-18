import 'package:dartz/dartz.dart';
import '../entities/vehicle.dart';
import '../repositories/vehicle_repository.dart';

/// Create Vehicle Use Case
class CreateVehicle {
  final VehicleRepository repository;

  CreateVehicle(this.repository);

  Future<Either<String, Vehicle>> call(Vehicle vehicle) async {
    // Validate vehicle
    if (vehicle.brand.isEmpty) {
      return const Left('Marka alanı zorunludur');
    }
    if (vehicle.model.isEmpty) {
      return const Left('Model alanı zorunludur');
    }
    if (vehicle.year < 1900 || vehicle.year > DateTime.now().year + 1) {
      return const Left('Geçersiz model yılı');
    }
    if (vehicle.tankCapacity <= 0) {
      return const Left('Depo kapasitesi 0\'dan büyük olmalıdır');
    }

    return await repository.createVehicle(vehicle);
  }
}
