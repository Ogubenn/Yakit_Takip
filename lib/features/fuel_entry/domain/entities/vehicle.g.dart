// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VehicleImpl _$$VehicleImplFromJson(Map<String, dynamic> json) =>
    _$VehicleImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: (json['year'] as num).toInt(),
      plate: json['plate'] as String?,
      fuelType: json['fuelType'] as String,
      tankCapacity: (json['tankCapacity'] as num).toDouble(),
      initialOdometer: (json['initialOdometer'] as num).toInt(),
      isPrimary: json['isPrimary'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      imageUrl: json['imageUrl'] as String?,
      color: json['color'] as String?,
      syncStatus: json['syncStatus'] as String? ?? 'synced',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$VehicleImplToJson(_$VehicleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'brand': instance.brand,
      'model': instance.model,
      'year': instance.year,
      'plate': instance.plate,
      'fuelType': instance.fuelType,
      'tankCapacity': instance.tankCapacity,
      'initialOdometer': instance.initialOdometer,
      'isPrimary': instance.isPrimary,
      'isActive': instance.isActive,
      'imageUrl': instance.imageUrl,
      'color': instance.color,
      'syncStatus': instance.syncStatus,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
