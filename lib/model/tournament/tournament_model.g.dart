// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TournamentModelAdapter extends TypeAdapter<TournamentModel> {
  @override
  final int typeId = 5;

  @override
  TournamentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TournamentModel(
      key: fields[0] as String?,
      name: fields[1] as String?,
      venue: fields[2] as String?,
      date: fields[3] as DateTime?,
      teamKeys: (fields[4] as List).cast<String>(),
      rounds: (fields[5] as List).cast<RoundModel>(),
      description: fields[6] as String?,
      winner: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TournamentModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.venue)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.teamKeys)
      ..writeByte(5)
      ..write(obj.rounds)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.winner);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TournamentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
