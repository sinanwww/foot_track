import 'package:foot_track/model/team_model.dart';

class MatchModel {
  TeamModel homeTeam;
  TeamModel awayTeam;
  int homeGoal;
  int awayGoal;
  String duration;
  String date;
  MatchModel({
    required this.homeTeam,
    required this.awayTeam,
    required this.date,
    required this.duration,
    this.homeGoal = 0,
    this.awayGoal = 0,
  });
}
