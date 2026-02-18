import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/datasources/user_local_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/get_current_user.dart';
import '../features/auth/domain/usecases/sign_in_with_email.dart';
import '../features/auth/domain/usecases/sign_up_with_email.dart';
import '../features/fuel_entry/data/datasources/fuel_entry_local_datasource.dart';
import '../features/fuel_entry/data/datasources/fuel_entry_remote_datasource.dart';
import '../features/fuel_entry/data/datasources/vehicle_local_datasource.dart';
import '../features/fuel_entry/data/datasources/vehicle_remote_datasource.dart';
import '../features/fuel_entry/data/repositories/fuel_entry_repository_impl.dart';
import '../features/fuel_entry/data/repositories/vehicle_repository_impl.dart';
import '../features/fuel_entry/domain/repositories/fuel_entry_repository.dart';
import '../features/fuel_entry/domain/repositories/vehicle_repository.dart';
import '../features/fuel_entry/domain/usecases/calculate_average_consumption.dart';
import '../features/fuel_entry/domain/usecases/create_fuel_entry.dart';
import '../features/fuel_entry/domain/usecases/create_vehicle.dart';
import '../features/fuel_entry/domain/usecases/get_user_vehicles.dart';
import '../features/fuel_entry/domain/usecases/get_vehicle_entries.dart';

// ============================================================================
// External Dependencies
// ============================================================================

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn();
});

final uuidProvider = Provider<Uuid>((ref) {
  return const Uuid();
});

// ============================================================================
// Data Sources
// ============================================================================

final userLocalDataSourceProvider = Provider<UserLocalDataSource>((ref) {
  return UserLocalDataSource();
});

final fuelEntryLocalDataSourceProvider =
    Provider<FuelEntryLocalDataSource>((ref) {
  return FuelEntryLocalDataSource();
});

final vehicleLocalDataSourceProvider = Provider<VehicleLocalDataSource>((ref) {
  return VehicleLocalDataSource();
});

// Auth Data Sources
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(
    ref.watch(firebaseAuthProvider),
    ref.watch(firebaseFirestoreProvider),
    ref.watch(googleSignInProvider),
  );
});

// Fuel Entry Data Sources
final fuelEntryRemoteDataSourceProvider =
    Provider<FuelEntryRemoteDataSource>((ref) {
  return FuelEntryRemoteDataSource(
    ref.watch(firebaseFirestoreProvider),
  );
});

// Vehicle Data Sources
final vehicleRemoteDataSourceProvider =
    Provider<VehicleRemoteDataSource>((ref) {
  return VehicleRemoteDataSource(
    ref.watch(firebaseFirestoreProvider),
  );
});

// ============================================================================
// Repositories
// ============================================================================

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(userLocalDataSourceProvider),
  );
});

final fuelEntryRepositoryProvider = Provider<FuelEntryRepository>((ref) {
  return FuelEntryRepositoryImpl(
    localDataSource: ref.watch(fuelEntryLocalDataSourceProvider),
    remoteDataSource: ref.watch(fuelEntryRemoteDataSourceProvider),
    uuid: ref.watch(uuidProvider),
  );
});

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  // Get current user ID - this will be replaced with actual user ID from auth
  final userId = ref.watch(firebaseAuthProvider).currentUser?.uid ?? '';
  
  return VehicleRepositoryImpl(
    localDataSource: ref.watch(vehicleLocalDataSourceProvider),
    remoteDataSource: ref.watch(vehicleRemoteDataSourceProvider),
    uuid: ref.watch(uuidProvider),
    userId: userId,
  );
});

// ============================================================================
// Use Cases
// ============================================================================

// Auth Use Cases
final getCurrentUserUseCaseProvider = Provider<GetCurrentUser>((ref) {
  return GetCurrentUser(ref.watch(authRepositoryProvider));
});

final signInWithEmailUseCaseProvider = Provider<SignInWithEmail>((ref) {
  return SignInWithEmail(ref.watch(authRepositoryProvider));
});

final signUpWithEmailUseCaseProvider = Provider<SignUpWithEmail>((ref) {
  return SignUpWithEmail(ref.watch(authRepositoryProvider));
});

// Fuel Entry Use Cases
final createFuelEntryUseCaseProvider = Provider<CreateFuelEntry>((ref) {
  return CreateFuelEntry(ref.watch(fuelEntryRepositoryProvider));
});

final getVehicleEntriesUseCaseProvider = Provider<GetVehicleEntries>((ref) {
  return GetVehicleEntries(ref.watch(fuelEntryRepositoryProvider));
});

final calculateAverageConsumptionUseCaseProvider =
    Provider<CalculateAverageConsumption>((ref) {
  return CalculateAverageConsumption(ref.watch(fuelEntryRepositoryProvider));
});

// Vehicle Use Cases
final createVehicleUseCaseProvider = Provider<CreateVehicle>((ref) {
  return CreateVehicle(ref.watch(vehicleRepositoryProvider));
});

final getUserVehiclesUseCaseProvider = Provider<GetUserVehicles>((ref) {
  return GetUserVehicles(ref.watch(vehicleRepositoryProvider));
});
