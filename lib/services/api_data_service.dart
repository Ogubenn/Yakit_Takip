import '../core/constants/api_constants.dart';
import '../models/vehicle.dart';
import '../models/fuel_record.dart';
import 'api_client.dart';

class ApiDataService {
  final ApiClient _apiClient = ApiClient();

  // ========== Vehicles ==========
  
  Future<List<Vehicle>> getVehicles() async {
    final response = await _apiClient.get(ApiConstants.vehicles);
    return (response.data as List)
        .map((json) => Vehicle.fromJson(json))
        .toList();
  }

  Future<Vehicle> createVehicle(Vehicle vehicle) async {
    final response = await _apiClient.post(
      ApiConstants.vehicles,
      data: vehicle.toJson(),
    );
    return Vehicle.fromJson(response.data);
  }

  Future<Vehicle> updateVehicle(Vehicle vehicle) async {
    final response = await _apiClient.put(
      '${ApiConstants.vehicles}/${vehicle.id}',
      data: vehicle.toJson(),
    );
    return Vehicle.fromJson(response.data);
  }

  Future<void> deleteVehicle(String id) async {
    await _apiClient.delete('${ApiConstants.vehicles}/$id');
  }

  // ========== Fuel Records ==========
  
  Future<List<FuelRecord>> getFuelRecords({String? vehicleId}) async {
    final queryParams = vehicleId != null ? {'vehicle_id': vehicleId} : null;
    final response = await _apiClient.get(
      ApiConstants.fuelRecords,
      queryParameters: queryParams,
    );
    return (response.data as List)
        .map((json) => FuelRecord.fromJson(json))
        .toList();
  }

  Future<FuelRecord> createFuelRecord(FuelRecord record) async {
    final response = await _apiClient.post(
      ApiConstants.fuelRecords,
      data: record.toJson(),
    );
    return FuelRecord.fromJson(response.data);
  }

  Future<FuelRecord> updateFuelRecord(FuelRecord record) async {
    final response = await _apiClient.put(
      '${ApiConstants.fuelRecords}/${record.id}',
      data: record.toJson(),
    );
    return FuelRecord.fromJson(response.data);
  }

  Future<void> deleteFuelRecord(String id) async {
    await _apiClient.delete('${ApiConstants.fuelRecords}/$id');
  }

  Future<List<FuelRecord>> getVehicleFuelRecords(String vehicleId) async {
    final response = await _apiClient.get(
      '${ApiConstants.fuelRecords}/vehicle/$vehicleId',
    );
    return (response.data as List)
        .map((json) => FuelRecord.fromJson(json))
        .toList();
  }

  // ========== Fuel Prices ==========
  
  Future<Map<String, dynamic>> getFuelPrices({String? city}) async {
    final queryParams = city != null ? {'city': city} : null;
    final response = await _apiClient.get(
      ApiConstants.fuelPrices,
      queryParameters: queryParams,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getFuelPricesByCity(String city) async {
    final response = await _apiClient.get(
      '${ApiConstants.fuelPrices}/city/$city',
    );
    return response.data;
  }

  Future<List<dynamic>> getFuelPriceHistory({
    String? city,
    String? fuelType,
    int days = 30,
  }) async {
    final queryParams = <String, dynamic>{'days': days};
    if (city != null) queryParams['city'] = city;
    if (fuelType != null) queryParams['fuel_type'] = fuelType;

    final response = await _apiClient.get(
      '${ApiConstants.fuelPrices}/history',
      queryParameters: queryParams,
    );
    return response.data;
  }
}
