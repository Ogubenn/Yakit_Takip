import 'package:hive/hive.dart';

part 'fuel_record.g.dart';

@HiveType(typeId: 1)
class FuelRecord extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String vehicleId;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  double liters;

  @HiveField(4)
  double pricePerLiter;

  @HiveField(5)
  double totalCost;

  @HiveField(6)
  double? odometer; // Kilometre (opsiyonel)

  @HiveField(7)
  String? station; // FuelStation enum'ın name'i

  @HiveField(8)
  String? city;

  @HiveField(9)
  bool isFullTank;

  @HiveField(10)
  String? notes;

  @HiveField(11)
  DateTime createdAt;

  @HiveField(12)
  double? latitude;

  @HiveField(13)
  double? longitude;

  FuelRecord({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.liters,
    required this.pricePerLiter,
    required this.totalCost,
    this.odometer,
    this.station,
    this.city,
    this.isFullTank = true,
    this.notes,
    required this.createdAt,
    this.latitude,
    this.longitude,
  });

  // Yakıt tüketimi hesaplama (L/100km)
  double? calculateConsumption(FuelRecord? previousRecord) {
    if (previousRecord == null || odometer == null || previousRecord.odometer == null) {
      return null;
    }

    final distance = odometer! - previousRecord.odometer!;
    if (distance <= 0) return null;

    return (liters / distance) * 100;
  }

  // Kilometre başına maliyet
  double? get costPerKm {
    if (odometer == null) return null;
    return totalCost / odometer!;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'vehicleId': vehicleId,
        'date': date.toIso8601String(),
        'liters': liters,
        'pricePerLiter': pricePerLiter,
        'totalCost': totalCost,
        'odometer': odometer,
        'station': station,
        'city': city,
        'isFullTank': isFullTank,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
        'latitude': latitude,
        'longitude': longitude,
      };

  factory FuelRecord.fromJson(Map<String, dynamic> json) => FuelRecord(
        id: json['id'],
        vehicleId: json['vehicleId'],
        date: DateTime.parse(json['date']),
        liters: json['liters'],
        pricePerLiter: json['pricePerLiter'],
        totalCost: json['totalCost'],
        odometer: json['odometer'],
        station: json['station'],
        city: json['city'],
        isFullTank: json['isFullTank'] ?? true,
        notes: json['notes'],
        createdAt: DateTime.parse(json['createdAt']),
        latitude: json['latitude'],
        longitude: json['longitude'],
      );
}
