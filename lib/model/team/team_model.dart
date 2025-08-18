import 'package:hive/hive.dart';
import 'dart:typed_data';

part 'team_model.g.dart';

@HiveType(typeId: 2)
class TeamModel extends HiveObject {
  @HiveField(0)
  String? key;

  @HiveField(1)
  String? name;

  @HiveField(2)
  Map<String, int>? teamPlayer;

  @HiveField(3)
  Uint8List? logoImage;

  @HiveField(4)
  String? captainKey;

  TeamModel({
    this.key,
    this.name,
    this.teamPlayer,
    this.logoImage,
    this.captainKey,
  });
}