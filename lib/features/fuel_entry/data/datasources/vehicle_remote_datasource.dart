import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle_model.dart';

/// Remote Data Source for Vehicles (Firestore)
class VehicleRemoteDataSource {
  final FirebaseFirestore _firestore;

  VehicleRemoteDataSource(this._firestore);

  CollectionReference get _collection => _firestore.collection('vehicles');

  /// Create vehicle
  Future<VehicleModel> createVehicle(VehicleModel vehicle) async {
    final docRef = await _collection.add(vehicle.toFirestore());
    return VehicleModel.fromFirestore(
      docRef.id,
      vehicle.toFirestore(),
    );
  }

  /// Get all vehicles for user
  Future<List<VehicleModel>> getUserVehicles(String userId) async {
    final snapshot = await _collection
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) =>
            VehicleModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
        .toList()
      ..sort((a, b) {
        if (a.isPrimary) return -1;
        if (b.isPrimary) return 1;
        return b.createdAt.compareTo(a.createdAt);
      });
  }

  /// Get vehicle by ID
  Future<VehicleModel?> getVehicleById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return VehicleModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
  }

  /// Update vehicle
  Future<VehicleModel> updateVehicle(VehicleModel vehicle) async {
    await _collection.doc(vehicle.id).update(vehicle.toFirestore());
    return vehicle;
  }

  /// Delete vehicle (soft delete)
  Future<void> deleteVehicle(String id) async {
    await _collection.doc(id).update({
      'isActive': false,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  /// Set primary vehicle
  Future<void> setPrimaryVehicle(String userId, String vehicleId) async {
    final batch = _firestore.batch();

    // Get all user vehicles
    final snapshot = await _collection
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .get();

    // Update all vehicles
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {
        'isPrimary': doc.id == vehicleId,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    }

    await batch.commit();
  }

  /// Get primary vehicle
  Future<VehicleModel?> getPrimaryVehicle(String userId) async {
    final snapshot = await _collection
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .where('isPrimary', isEqualTo: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      // If no primary vehicle, get the first one
      final allSnapshot = await _collection
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (allSnapshot.docs.isEmpty) return null;
      final doc = allSnapshot.docs.first;
      return VehicleModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
    }

    final doc = snapshot.docs.first;
    return VehicleModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
  }

  /// Sync vehicle to Firestore
  Future<void> syncVehicle(VehicleModel vehicle) async {
    if (vehicle.id.isEmpty) {
      await createVehicle(vehicle);
    } else {
      await _collection.doc(vehicle.id).set(
            vehicle.toFirestore(),
            SetOptions(merge: true),
          );
    }
  }
}
