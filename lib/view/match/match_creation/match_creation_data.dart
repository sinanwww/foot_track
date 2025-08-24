import 'package:foot_track/model/team/team_model.dart';

class MatchCreationData {
  TeamModel? homeTeam;
  TeamModel? awayTeam;
  List<String> homeLineup;
  List<String> awayLineup;
  List<String> homeBench;
  List<String> awayBench;
  final DateTime? date;
  final DateTime? startTime;
  final int maxLinup;

  MatchCreationData({
    this.homeTeam,
    this.awayTeam,
    this.homeLineup = const [],
    this.awayLineup = const [],
    this.homeBench = const [],
    this.awayBench = const [],
    required this.date,
    required this.startTime,
    required this.maxLinup,
  });

  MatchCreationData copyWith({
    TeamModel? homeTeam,
    TeamModel? awayTeam,
    List<String>? homeLineup,
    List<String>? awayLineup,
    List<String>? homeBench,
    List<String>? awayBench,
  }) {
    return MatchCreationData(
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      homeLineup: homeLineup ?? this.homeLineup,
      awayLineup: awayLineup ?? this.awayLineup,
      homeBench: homeBench ?? this.homeBench,
      awayBench: awayBench ?? this.awayBench,
      date: date,
      startTime: startTime,
      maxLinup: maxLinup,
    );
  }
}