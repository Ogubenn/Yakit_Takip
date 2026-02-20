// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fuel_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FuelRecordAdapter extends TypeAdapter<FuelRecord> {
  @override
  final int typeId = 1;

  @override
  FuelRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FuelRecord(
      id: fields[0] as String,
      vehicleId: fields[1] as String,
      date: fields[2] as DateTime,
      liters: fields[3] as double,
      pricePerLiter: fields[4] as double,
      totalCost: fields[5] as double,
      odometer: fields[6] as double?,
      station: fields[7] as String?,
      city: fields[8] as String?,
      isFullTank: fields[9] as bool,
      notes: fields[10] as String?,
      createdAt: fields[11] as DateTime,
      latitude: fields[12] as double?,
      longitude: fields[13] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, FuelRecord obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.vehicleId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.liters)
      ..writeByte(4)
      ..write(obj.pricePerLiter)
      ..writeByte(5)
      ..write(obj.totalCost)
      ..writeByte(6)
      ..write(obj.odometer)
      ..writeByte(7)
      ..write(obj.station)
      ..writeByte(8)
      ..write(obj.city)
      ..writeByte(9)
      ..write(obj.isFullTank)
      ..writeByte(10)
      ..write(obj.notes)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.latitude)
      ..writeByte(13)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FuelRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
