import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/fuel_entry_model.dart';

/// Remote Data Source for Fuel Entries (Firestore)
class FuelEntryRemoteDataSource {
  final FirebaseFirestore _firestore;

  FuelEntryRemoteDataSource(this._firestore);

  CollectionReference get _collection =>
      _firestore.collection('fuel_entries');

  /// Create fuel entry
  Future<FuelEntryModel> createEntry(FuelEntryModel entry) async {
    final docRef = await _collection.add(entry.toFirestore());
    return FuelEntryModel.fromFirestore(
      docRef.id,
      entry.toFirestore(),
    );
  }

  /// Get all entries for a vehicle
  Future<List<FuelEntryModel>> getEntriesByVehicle(String vehicleId) async {
    final snapshot = await _collection
        .where('vehicleId', isEqualTo: vehicleId)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) =>
            FuelEntryModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Get entry by ID
  Future<FuelEntryModel?> getEntryById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return FuelEntryModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
  }

  /// Update entry
  Future<FuelEntryModel> updateEntry(FuelEntryModel entry) async {
    await _collection.doc(entry.id).update(entry.toFirestore());
    return entry;
  }

  /// Delete entry
  Future<void> deleteEntry(String id) async {
    await _collection.doc(id).delete();
  }

  /// Get latest entry for vehicle
  Future<FuelEntryModel?> getLatestEntry(String vehicleId) async {
    final snapshot = await _collection
        .where('vehicleId', isEqualTo: vehicleId)
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return FuelEntryModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
  }

  /// Get entries by date range
  Future<List<FuelEntryModel>> getEntriesByDateRange(
    String vehicleId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final snapshot = await _collection
        .where('vehicleId', isEqualTo: vehicleId)
        .where('date', isGreaterThanOrEqualTo: startDate.toIso8601String())
        .where('date', isLessThanOrEqualTo: endDate.toIso8601String())
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) =>
            FuelEntryModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Sync entry to Firestore
  Future<void> syncEntry(FuelEntryModel entry) async {
    if (entry.id.isEmpty) {
      await createEntry(entry);
    } else {
      await _collection.doc(entry.id).set(
            entry.toFirestore(),
            SetOptions(merge: true),
          );
    }
  }
}
