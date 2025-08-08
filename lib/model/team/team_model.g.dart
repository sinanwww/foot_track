// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TeamModelAdapter extends TypeAdapter<TeamModel> {
  @override
  final int typeId = 2;

  @override
  TeamModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TeamModel(
      key: fields[0] as String?,
      name: fields[1] as String?,
      teamPlayer: (fields[2] as Map?)?.cast<String, int>(),
      logoimagePath: fields[3] as String?,
      captainKey: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TeamModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.teamPlayer)
      ..writeByte(3)
      ..write(obj.logoimagePath)
      ..writeByte(4)
      ..write(obj.captainKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
