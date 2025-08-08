import 'package:hive/hive.dart';
part 'player_model.g.dart';

@HiveType(typeId: 3)
class PlayerModel extends HiveObject {
  @HiveField(0)
  String? key;
  @HiveField(1)
  String name;
  @HiveField(2)
  String? imagePath;
  @HiveField(3)
  String position;
  @HiveField(4)
  String dateOfBirth;

  PlayerModel({
    this.key,
    this.imagePath,
    required this.name,
    required this.position,
    required this.dateOfBirth,
  });
}
