import 'package:hive/hive.dart';
import 'dart:typed_data';

part 'player_model.g.dart';

@HiveType(typeId: 3)
class PlayerModel extends HiveObject {
  @HiveField(0)
  String? key;

  @HiveField(1)
  String name;

  @HiveField(2)
  Uint8List? imageData;

  @HiveField(3)
  String position;

  @HiveField(4)
  String dateOfBirth;

  PlayerModel({
    this.key,
    required this.name,
    this.imageData,
    required this.position,
    required this.dateOfBirth,
  });
}