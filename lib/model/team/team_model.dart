import 'package:hive/hive.dart';
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
  String? logoimagePath;
    @HiveField(4)
  String? captainKey;

  TeamModel({this.key, this.name, this.teamPlayer, this.logoimagePath,this.captainKey});
}
