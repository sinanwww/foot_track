// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MatchModelAdapter extends TypeAdapter<MatchModel> {
  @override
  final int typeId = 4;

  @override
  MatchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MatchModel(
      key: fields[0] as String?,
      homeTeamKey: fields[1] as String?,
      awayTeamKey: fields[2] as String?,
      homeLineup: (fields[3] as List?)?.cast<String>(),
      awayLineup: (fields[4] as List?)?.cast<String>(),
      homeScore: fields[5] as int?,
      awayScore: fields[6] as int?,
      date: fields[7] as DateTime?,
      startTime: fields[8] as DateTime?,
      description: fields[9] as String?,
      goalScorers: (fields[10] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      yellowCards: (fields[11] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      redCards: (fields[12] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      substitutions: (fields[13] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      homeBench: (fields[14] as List?)?.cast<String>(),
      awayBench: (fields[15] as List?)?.cast<String>(),
      status: fields[16] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MatchModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.homeTeamKey)
      ..writeByte(2)
      ..write(obj.awayTeamKey)
      ..writeByte(3)
      ..write(obj.homeLineup)
      ..writeByte(4)
      ..write(obj.awayLineup)
      ..writeByte(5)
      ..write(obj.homeScore)
      ..writeByte(6)
      ..write(obj.awayScore)
      ..writeByte(7)
      ..write(obj.date)
      ..writeByte(8)
      ..write(obj.startTime)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.goalScorers)
      ..writeByte(11)
      ..write(obj.yellowCards)
      ..writeByte(12)
      ..write(obj.redCards)
      ..writeByte(13)
      ..write(obj.substitutions)
      ..writeByte(14)
      ..write(obj.homeBench)
      ..writeByte(15)
      ..write(obj.awayBench)
      ..writeByte(16)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
