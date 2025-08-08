import 'package:hive/hive.dart';

part 'match_model.g.dart';

@HiveType(typeId: 4)
class MatchModel extends HiveObject {
  @HiveField(0)
  String? key;

  @HiveField(1)
  String? homeTeamKey;

  @HiveField(2)
  String? awayTeamKey;

  @HiveField(3)
  List<String>? homeLineup;

  @HiveField(4)
  List<String>? awayLineup;

  @HiveField(5)
  int? homeScore;

  @HiveField(6)
  int? awayScore;

  @HiveField(7)
  DateTime? date;

  @HiveField(8)
  DateTime? startTime;

  @HiveField(9)
  String? description;

  @HiveField(10)
  List<Map<String, dynamic>>? goalScorers;

  @HiveField(11)
  List<Map<String, dynamic>>? yellowCards;

  @HiveField(12)
  List<Map<String, dynamic>>? redCards;

  @HiveField(13)
  List<Map<String, dynamic>>? substitutions;

  @HiveField(14)
  List<String>? homeBench;

  @HiveField(15)
  List<String>? awayBench;

  @HiveField(16)
  String? status;

  MatchModel({
    this.key,
    this.homeTeamKey,
    this.awayTeamKey,
    this.homeLineup,
    this.awayLineup,
    this.homeScore,
    this.awayScore,
    this.date,
    this.startTime,
    this.description,
    this.goalScorers,
    this.yellowCards,
    this.redCards,
    this.substitutions,
    this.homeBench,
    this.awayBench,
    this.status,
  });
}