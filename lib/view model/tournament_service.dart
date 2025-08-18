import 'package:hive/hive.dart';
import 'package:foot_track/model/tournament/tournament_model.dart';
import 'package:foot_track/model/tournament/round_model.dart';
import 'package:foot_track/model/match/match_model.dart';
import 'package:foot_track/view%20model/match_service.dart';

class TournamentService {
  static const String _boxName = 'tournaments';

  Future<Box<TournamentModel>> _openBox() async {
    return await Hive.openBox<TournamentModel>(_boxName);
  }

  Future<void> createTournament(TournamentModel tournament) async {
    final box = await _openBox();
    final key =
        tournament.key ?? DateTime.now().millisecondsSinceEpoch.toString();
    tournament.key = key;
    await box.put(key, tournament);
  }

  Future<TournamentModel?> getTournament(String key) async {
    final box = await _openBox();
    return box.get(key);
  }

  Future<List<TournamentModel>> getAllTournaments() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> updateTournament(TournamentModel tournament) async {
    if (tournament.key == null) {
      throw Exception('Tournament key is null');
    }
    final box = await _openBox();
    await box.put(tournament.key!, tournament);
  }

  Future<void> deleteTournament(String tournamentKey) async {
    final box = await _openBox();
    final matchBox = await Hive.openBox<MatchModel>('matches');
    final tournament = box.get(tournamentKey);
    if (tournament == null) {
      throw Exception('Tournament not found');
    }
    // Delete all matches in all rounds
    for (var round in tournament.rounds) {
      for (var matchKey in round.matchKeys) {
        await matchBox.delete(matchKey);
      }
    }
    await box.delete(tournamentKey);
  }

  Future<void> addRound(String tournamentKey, RoundModel round) async {
    final box = await _openBox();
    final tournament = box.get(tournamentKey);
    if (tournament == null) {
      throw Exception('Tournament not found');
    }
    tournament.rounds = [...tournament.rounds, round];
    await box.put(tournamentKey, tournament);
  }

  Future<void> updateRound(
    String tournamentKey,
    int roundIndex,
    RoundModel round,
  ) async {
    final box = await _openBox();
    final tournament = box.get(tournamentKey);
    if (tournament == null) {
      throw Exception('Tournament not found');
    }
    if (roundIndex < 0 || roundIndex >= tournament.rounds.length) {
      throw Exception('Invalid round index');
    }
    tournament.rounds[roundIndex] = round;
    await box.put(tournamentKey, tournament);
  }

  Future<void> deleteRound(String tournamentKey, int roundIndex) async {
    final box = await _openBox();
    final matchBox = await Hive.openBox<MatchModel>('matches');
    final tournament = box.get(tournamentKey);
    if (tournament == null) {
      throw Exception('Tournament not found');
    }
    if (roundIndex < 0 || roundIndex >= tournament.rounds.length) {
      throw Exception('Invalid round index');
    }
    // Delete all matches in the round
    final round = tournament.rounds[roundIndex];
    for (var matchKey in round.matchKeys) {
      await matchBox.delete(matchKey);
    }
    // Remove the round
    tournament.rounds.removeAt(roundIndex);
    await box.put(tournamentKey, tournament);
  }

  Future<void> addMatchToRound(
    String tournamentKey,
    int roundIndex,
    String matchKey,
  ) async {
    final box = await _openBox();
    final tournament = box.get(tournamentKey);
    if (tournament == null) {
      throw Exception('Tournament not found');
    }
    if (roundIndex < 0 || roundIndex >= tournament.rounds.length) {
      throw Exception('Invalid round index');
    }
    final round = tournament.rounds[roundIndex];
    round.matchKeys = [...round.matchKeys, matchKey];
    tournament.rounds[roundIndex] = round;
    await box.put(tournamentKey, tournament);
  }

  Future<String> createMatchInRound({
    required String tournamentKey,
    required int roundIndex,
    required String homeTeamKey,
    required String awayTeamKey,
    required List<String> homeLineup,
    required List<String> awayLineup,
    List<String>? homeBench,
    List<String>? awayBench,
    DateTime? date,
    DateTime? startTime,
  }) async {
    final matchService = MatchService();
    final matchKey = await matchService.createMatch(
      homeTeamKey: homeTeamKey,
      awayTeamKey: awayTeamKey,
      homeLineup: homeLineup,
      awayLineup: awayLineup,
      homeBench: homeBench,
      awayBench: awayBench,
      date: date,
      startTime: startTime,
    );
    await addMatchToRound(tournamentKey, roundIndex, matchKey);
    return matchKey;
  }

  Future<void> addTeamToTournament(String tournamentKey, String teamKey) async {
    final box = await _openBox();
    final tournament = box.get(tournamentKey);
    if (tournament == null) {
      throw Exception('Tournament not found');
    }
    if (tournament.teamKeys.contains(teamKey)) {
      throw Exception('Team already in tournament');
    }
    tournament.teamKeys = [...tournament.teamKeys, teamKey];
    await box.put(tournamentKey, tournament);
  }

  Future<void> removeTeamFromTournament(
    String tournamentKey,
    String teamKey,
  ) async {
    final box = await _openBox();
    final matchBox = await Hive.openBox<MatchModel>('matches');
    final tournament = box.get(tournamentKey);
    if (tournament == null) {
      throw Exception('Tournament not found');
    }
    if (!tournament.teamKeys.contains(teamKey)) {
      throw Exception('Team not in tournament');
    }
    // Check for matches involving the team
    for (var round in tournament.rounds) {
      for (var matchKey in round.matchKeys) {
        final match = await matchBox.get(matchKey);
        if (match != null &&
            (match.homeTeamKey == teamKey || match.awayTeamKey == teamKey)) {
          throw Exception('Cannot remove team with existing matches');
        }
      }
    }
    // Prevent removing the winner team
    if (tournament.winner == teamKey) {
      throw Exception('Cannot remove the team declared as winner');
    }
    tournament.teamKeys =
        tournament.teamKeys.where((key) => key != teamKey).toList();
    await box.put(tournamentKey, tournament);
  }
}
