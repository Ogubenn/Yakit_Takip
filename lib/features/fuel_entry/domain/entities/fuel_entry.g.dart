// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fuel_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FuelEntryImpl _$$FuelEntryImplFromJson(Map<String, dynamic> json) =>
    _$FuelEntryImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      vehicleId: json['vehicleId'] as String,
      date: DateTime.parse(json['date'] as String),
      odometer: (json['odometer'] as num).toInt(),
      liters: (json['liters'] as num).toDouble(),
      pricePerLiter: (json['pricePerLiter'] as num).toDouble(),
      totalCost: (json['totalCost'] as num).toDouble(),
      fuelType: json['fuelType'] as String,
      isFullTank: json['isFullTank'] as bool? ?? true,
      note: json['note'] as String?,
      stationName: json['stationName'] as String?,
      consumption: (json['consumption'] as num?)?.toDouble(),
      costPerKm: (json['costPerKm'] as num?)?.toDouble(),
      syncStatus: json['syncStatus'] as String? ?? 'synced',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$FuelEntryImplToJson(_$FuelEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'vehicleId': instance.vehicleId,
      'date': instance.date.toIso8601String(),
      'odometer': instance.odometer,
      'liters': instance.liters,
      'pricePerLiter': instance.pricePerLiter,
      'totalCost': instance.totalCost,
      'fuelType': instance.fuelType,
      'isFullTank': instance.isFullTank,
      'note': instance.note,
      'stationName': instance.stationName,
      'consumption': instance.consumption,
      'costPerKm': instance.costPerKm,
      'syncStatus': instance.syncStatus,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
