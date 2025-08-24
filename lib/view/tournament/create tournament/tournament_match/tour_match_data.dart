class TournamentMatchData {
  final String tournamentKey;
  final int roundIndex;
  final List<String> teamKeys;
  String? homeTeamKey;
  String? awayTeamKey;
  List<String> homeLineup;
  List<String> awayLineup;
  List<String> homeBench;
  List<String> awayBench;
  int? maxLinup;
  DateTime? date;
  DateTime? time;

  TournamentMatchData({
    required this.tournamentKey,
    required this.roundIndex,
    required this.teamKeys,
    this.homeTeamKey,
    this.awayTeamKey,
    this.homeLineup = const [],
    this.awayLineup = const [],
    this.homeBench = const [],
    this.awayBench = const [],
    this.maxLinup,
    this.date,
    this.time,
  });

  TournamentMatchData copyWith({
    String? homeTeamKey,
    String? awayTeamKey,
    List<String>? homeLineup,
    List<String>? awayLineup,
    List<String>? homeBench,
    List<String>? awayBench,
  }) {
    return TournamentMatchData(
      tournamentKey: tournamentKey,
      roundIndex: roundIndex,
      teamKeys: teamKeys,
      homeTeamKey: homeTeamKey ?? this.homeTeamKey,
      awayTeamKey: awayTeamKey ?? this.awayTeamKey,
      homeLineup: homeLineup ?? this.homeLineup,
      awayLineup: awayLineup ?? this.awayLineup,
      homeBench: homeBench ?? this.homeBench,
      awayBench: awayBench ?? this.awayBench,
      maxLinup: maxLinup,
      date: date,
      time: time,

    );
  }
}
