import 'package:hive/hive.dart';
import 'package:foot_track/model/match/match_model.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class MatchService {
  static const String _boxName = 'matches';

  Future<Box<MatchModel>> _getBox() async {
    try {
      if (!Hive.isBoxOpen(_boxName)) {
        await Hive.openBox<MatchModel>(_boxName);
        print('Opened Hive box: $_boxName');
      }
      return Hive.box<MatchModel>(_boxName);
    } catch (e) {
      print('Error opening Hive box $_boxName: $e');
      throw HiveError('Failed to open box: $e');
    }
  }

  Future<String> createMatch({
    required String homeTeamKey,
    required String awayTeamKey,
    List<String>? homeLineup,
    List<String>? awayLineup,
    DateTime? date,
    DateTime? startTime,
    String? description,
    List<Map<String, dynamic>>? substitutions,
    List<String>? homeBench,
    List<String>? awayBench,
  }) async {
    var uuid = Uuid();
    final box = await _getBox();
    final matchKey = uuid.v4();
    final existingMatch = box.get(matchKey);
    if (existingMatch != null) {
      print(
        'Warning: Match with key $matchKey already exists, generating new key',
      );
      return createMatch(
        homeTeamKey: homeTeamKey,
        awayTeamKey: awayTeamKey,
        homeLineup: homeLineup,
        awayLineup: awayLineup,
        date: date,
        startTime: startTime,
        description: description,
        substitutions: substitutions,
        homeBench: homeBench,
        awayBench: awayBench,
      );
    }
    final match = MatchModel(
      key: matchKey,
      homeTeamKey: homeTeamKey,
      awayTeamKey: awayTeamKey,
      homeLineup: homeLineup ?? [],
      awayLineup: awayLineup ?? [],
      homeScore: 0,
      awayScore: 0,
      date: date,
      startTime: startTime,
      description: description,
      goalScorers: [],
      yellowCards: [],
      redCards: [],
      substitutions: substitutions ?? [],
      homeBench: homeBench ?? [],
      awayBench: awayBench ?? [],
      status: 'Not Started',
    );
    await box.put(match.key, match);
    print('Created match with key: ${match.key}');
    return match.key!;
  }

  Future<MatchModel?> getMatch(String key) async {
    try {
      final box = await _getBox();
      return box.get(key);
    } catch (e) {
      print('Error getting match $key: $e');
      return null;
    }
  }

  Future<List<MatchModel>> getAllMatches() async {
    try {
      final box = await _getBox();
      final matches = box.values.toList();
      print('Retrieved ${matches.length} matches');
      return matches;
    } catch (e) {
      print('Error getting all matches: $e');
      return [];
    }
  }

  Future<void> updateScores({
    required String matchKey,
    required int homeScore,
    required int awayScore,
  }) async {
    final box = await _getBox();
    final match = box.get(matchKey);
    if (match != null) {
      match.homeScore = homeScore;
      match.awayScore = awayScore;
      match.status = "In Progress";
      await match.save();
      print('Updated scores for match $matchKey: $homeScore-$awayScore');
    } else {
      print('Error: Match $matchKey not found for score update');
      throw Exception('Match not found');
    }
  }

  Future<void> updateLineups({
    required String matchKey,
    List<String>? homeLineup,
    List<String>? awayLineup,
  }) async {
    final box = await _getBox();
    final match = box.get(matchKey);
    if (match != null) {
      match.homeLineup = homeLineup ?? match.homeLineup;
      match.awayLineup = awayLineup ?? match.awayLineup;
      await match.save();
      print('Updated lineups for match $matchKey');
    } else {
      print('Error: Match $matchKey not found for lineup update');
      throw Exception('Match not found');
    }
  }

  Future<void> updateMatchDetails({
    required String matchKey,
    DateTime? startTime,
    String? description,
  }) async {
    final box = await _getBox();
    final match = box.get(matchKey);
    if (match != null) {
      match.startTime = startTime ?? match.startTime;
      match.description = description ?? match.description;
      await match.save();
      print('Updated details for match $matchKey');
    } else {
      print('Error: Match $matchKey not found for details update');
      throw Exception('Match not found');
    }
  }

  Future<void> addGoalScorer({
    required String matchKey,
    required String playerKey,
    required DateTime time,
    required bool isHome,
  }) async {
    final box = await _getBox();
    final match = box.get(matchKey);
    if (match != null) {
      // Check if player has a red card or two yellows
      final redCount =
          (match.redCards ?? [])
              .where((r) => r['playerKey'] == playerKey)
              .length;
      final yellowCount =
          (match.yellowCards ?? [])
              .where((y) => y['playerKey'] == playerKey)
              .length;
      if (redCount > 0 || yellowCount >= 2) {
        throw Exception('Player has been sent off and cannot score');
      }
      // Verify player is in the correct lineup or was substituted
      bool isPlayerInTeam =
          isHome
              ? (match.homeLineup ?? []).contains(playerKey) ||
                  (match.substitutions ?? []).any(
                    (sub) => sub['outPlayerKey'] == playerKey && sub['isHome'],
                  )
              : (match.awayLineup ?? []).contains(playerKey) ||
                  (match.substitutions ?? []).any(
                    (sub) => sub['outPlayerKey'] == playerKey && !sub['isHome'],
                  );
      if (!isPlayerInTeam) {
        throw Exception('Player is not in ${isHome ? 'home' : 'away'} team');
      }
      match.goalScorers ??= [];
      match.goalScorers!.add({'playerKey': playerKey, 'time': time});
      // Increment team score
      if (isHome) {
        match.homeScore = (match.homeScore ?? 0) + 1;
      } else {
        match.awayScore = (match.awayScore ?? 0) + 1;
      }
      await match.save();
      print('Added goal scorer for match $matchKey: $playerKey, updated score');
    } else {
      print('Error: Match $matchKey not found for goal scorer');
      throw Exception('Match not found');
    }
  }

  Future<void> updatePlayerGoals({
    required String matchKey,
    required String playerKey,
    required int goalCount,
    required DateTime time,
    required bool isHome,
  }) async {
    final box = await _getBox();
    final match = box.get(matchKey);
    if (match != null) {
      // Validate goal count
      if (goalCount < 0) {
        throw Exception('Goal count cannot be negative');
      }
      // Verify player is in the correct lineup or was substituted
      bool isPlayerInTeam =
          isHome
              ? (match.homeLineup ?? []).contains(playerKey) ||
                  (match.substitutions ?? []).any(
                    (sub) => sub['outPlayerKey'] == playerKey && sub['isHome'],
                  )
              : (match.awayLineup ?? []).contains(playerKey) ||
                  (match.substitutions ?? []).any(
                    (sub) => sub['outPlayerKey'] == playerKey && !sub['isHome'],
                  );
      if (!isPlayerInTeam) {
        throw Exception('Player is not in ${isHome ? 'home' : 'away'} team');
      }
      // Check if player has a red card or two yellows
      final redCount =
          (match.redCards ?? [])
              .where((r) => r['playerKey'] == playerKey)
              .length;
      final yellowCount =
          (match.yellowCards ?? [])
              .where((y) => y['playerKey'] == playerKey)
              .length;
      if (redCount > 0 || yellowCount >= 2) {
        throw Exception('Player has been sent off and cannot score');
      }
      // Calculate current goals for the player
      final currentGoals =
          (match.goalScorers ?? [])
              .where((g) => g['playerKey'] == playerKey)
              .length;
      // Update goalScorers
      match.goalScorers =
          (match.goalScorers ?? [])
              .where((g) => g['playerKey'] != playerKey)
              .toList();
      for (int i = 0; i < goalCount; i++) {
        match.goalScorers!.add({'playerKey': playerKey, 'time': time});
      }
      // Adjust team score
      final goalDiff = goalCount - currentGoals;
      if (isHome) {
        final newHomeScore = (match.homeScore ?? 0) + goalDiff;
        if (newHomeScore < 0) {
          throw Exception('Home score cannot be negative');
        }
        match.homeScore = newHomeScore;
      } else {
        final newAwayScore = (match.awayScore ?? 0) + goalDiff;
        if (newAwayScore < 0) {
          throw Exception('Away score cannot be negative');
        }
        match.awayScore = newAwayScore;
      }
      await match.save();
      print(
        'Updated goals for match $matchKey, player $playerKey: $goalCount goals, score adjusted by $goalDiff',
      );
    } else {
      print('Error: Match $matchKey not found for goal update');
      throw Exception('Match not found');
    }
  }

  Future<void> addYellowCard({
    required String matchKey,
    required String playerKey,
    required DateTime time,
  }) async {
    final box = await _getBox();
    final match = box.get(matchKey);
    if (match != null) {
      match.yellowCards ??= [];
      match.redCards ??= [];
      // Check existing cards
      final yellowCount =
          (match.yellowCards ?? [])
              .where((y) => y['playerKey'] == playerKey)
              .length;
      final redCount =
          (match.redCards ?? [])
              .where((r) => r['playerKey'] == playerKey)
              .length;
      if (redCount > 0 || yellowCount >= 2) {
        throw Exception(
          'Player has been sent off and cannot receive more cards',
        );
      }
      match.yellowCards!.add({'playerKey': playerKey, 'time': time});
      // If this is the second yellow, add a red card
      if (yellowCount + 1 == 2) {
        match.redCards!.add({'playerKey': playerKey, 'time': time});
        print('Second yellow for $playerKey, issued red card');
      }
      await match.save();
      print('Added yellow card for match $matchKey: $playerKey');
    } else {
      print('Error: Match $matchKey not found for yellow card');
      throw Exception('Match not found');
    }
  }

  Future<void> addRedCard({
    required String matchKey,
    required String playerKey,
    required DateTime time,
  }) async {
    final box = await _getBox();
    final match = box.get(matchKey);
    if (match != null) {
      match.redCards ??= [];
      // Check if player already has a red card or two yellows
      final redCount =
          (match.redCards ?? [])
              .where((r) => r['playerKey'] == playerKey)
              .length;
      final yellowCount =
          (match.yellowCards ?? [])
              .where((y) => y['playerKey'] == playerKey)
              .length;
      if (redCount > 0 || yellowCount >= 2) {
        throw Exception('Player has already been sent off');
      }
      match.redCards!.add({'playerKey': playerKey, 'time': time});
      await match.save();
      print('Added red card for match $matchKey: $playerKey');
    } else {
      print('Error: Match $matchKey not found for red card');
      throw Exception('Match not found');
    }
  }

  Future<void> updatePlayerCards({
    required String matchKey,
    required String playerKey,
    required int yellowCount,
    required int redCount,
    required DateTime time,
  }) async {
    final box = await _getBox();
    final match = box.get(matchKey);
    if (match != null) {
      // Validate card counts
      if (yellowCount < 0 || yellowCount > 2) {
        throw Exception('Yellow card count must be between 0 and 2');
      }
      if (redCount < 0 || redCount > 1) {
        throw Exception('Red card count must be 0 or 1');
      }
      if (yellowCount == 2 && redCount == 0) {
        throw Exception('Two yellow cards require a red card');
      }
      if (redCount == 1 && yellowCount >= 2) {
        throw Exception('Cannot have two yellows with a direct red card');
      }
      // Update yellow cards
      match.yellowCards =
          (match.yellowCards ?? [])
              .where((y) => y['playerKey'] != playerKey)
              .toList();
      for (int i = 0; i < yellowCount; i++) {
        match.yellowCards!.add({'playerKey': playerKey, 'time': time});
      }
      // Update red cards
      match.redCards =
          (match.redCards ?? [])
              .where((r) => r['playerKey'] != playerKey)
              .toList();
      if (redCount == 1) {
        match.redCards!.add({'playerKey': playerKey, 'time': time});
      }
      await match.save();
      print(
        'Updated cards for match $matchKey, player $playerKey: $yellowCount yellow, $redCount red',
      );
    } else {
      print('Error: Match $matchKey not found for card update');
      throw Exception('Match not found');
    }
  }

  Future<void> addSubstitution({
    required String matchKey,
    required String outPlayerKey,
    required String inPlayerKey,
    required DateTime time,
    required bool isHome,
  }) async {
    final box = await _getBox();
    final match = box.get(matchKey);
    if (match != null) {
      match.substitutions ??= [];
      // Check if outPlayerKey has already been substituted
      if (match.substitutions!.any(
        (sub) => sub['outPlayerKey'] == outPlayerKey,
      )) {
        throw Exception('Player $outPlayerKey has already been substituted');
      }
      // Check if outPlayerKey has a red card or two yellows
      final redCount =
          (match.redCards ?? [])
              .where((r) => r['playerKey'] == outPlayerKey)
              .length;
      final yellowCount =
          (match.yellowCards ?? [])
              .where((y) => y['playerKey'] == outPlayerKey)
              .length;
      if (redCount > 0 || yellowCount >= 2) {
        throw Exception(
          'Player $outPlayerKey has been sent off and cannot be substituted',
        );
      }
      // Check if inPlayerKey is in the appropriate bench
      final validBench = isHome ? match.homeBench : match.awayBench;
      if (!validBench!.contains(inPlayerKey)) {
        throw Exception('Player $inPlayerKey is not in the bench');
      }
      match.substitutions!.add({
        'outPlayerKey': outPlayerKey,
        'inPlayerKey': inPlayerKey,
        'time': time,
        'isHome': isHome,
      });
      if (isHome) {
        match.homeLineup =
            (match.homeLineup ?? [])
                .where((key) => key != outPlayerKey)
                .toList()
              ..add(inPlayerKey);
        match.homeBench =
            (match.homeBench ?? []).where((key) => key != inPlayerKey).toList();
      } else {
        match.awayLineup =
            (match.awayLineup ?? [])
                .where((key) => key != outPlayerKey)
                .toList()
              ..add(inPlayerKey);
        match.awayBench =
            (match.awayBench ?? []).where((key) => key != inPlayerKey).toList();
      }
      await match.save();
      print(
        'Added substitution for match $matchKey: $outPlayerKey -> $inPlayerKey',
      );
    } else {
      print('Error: Match $matchKey not found for substitution');
      throw Exception('Match not found');
    }
  }

  Future<void> deleteMatch(String key) async {
    final box = await _getBox();
    await box.delete(key);
    print('Deleted match with key: $key');
  }

  Future<void> deleteAllMatches() async {
    final box = await _getBox();
    final count = box.length;
    await box.clear();
    print('Deleted all $count matches');
  }

  Future<void> cleanInvalidMatches() async {
    final box = await _getBox();
    final invalidKeys = <String>[];
    final dateFormat = DateFormat('dd-MM-yyyy');
    final timeFormat = DateFormat('HH:mm');

    for (var match in box.values) {
      if (match.key == null ||
          match.homeTeamKey == null ||
          match.awayTeamKey == null) {
        if (match.key != null) {
          invalidKeys.add(match.key!);
        }
        continue;
      }
      try {
        if (match.date is String) {
          match.date = dateFormat.parse(match.date as String);
          await match.save();
          print('Migrated date for match ${match.key} to DateTime');
        }
        if (match.startTime is String) {
          match.startTime = timeFormat.parse(match.startTime as String);
          await match.save();
          print('Migrated startTime for match ${match.key} to DateTime');
        }
        if (match.homeBench == null) {
          match.homeBench = [];
          await match.save();
          print('Initialized homeBench for match ${match.key}');
        }
        if (match.awayBench == null) {
          match.awayBench = [];
          await match.save();
          print('Initialized awayBench for match ${match.key}');
        }
        if (match.homeScore == null) {
          match.homeScore = 0;
          await match.save();
          print('Initialized homeScore for match ${match.key} to 0');
        }
        if (match.awayScore == null) {
          match.awayScore = 0;
          await match.save();
          print('Initialized awayScore for match ${match.key} to 0');
        }
      } catch (e) {
        print('Error migrating data for match ${match.key}: $e');
        invalidKeys.add(match.key!);
      }
    }

    for (var key in invalidKeys) {
      await box.delete(key);
      print('Deleted invalid match with key: $key');
    }
    print('Cleaned ${invalidKeys.length} invalid matches');
  }
}
