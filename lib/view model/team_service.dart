import 'package:hive/hive.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'dart:typed_data';

class TeamService {
  static const String _boxName = 'teams';

  Future<Box<TeamModel>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<TeamModel>(_boxName);
    }
    return Hive.box<TeamModel>(_boxName);
  }

  Future<void> createTeam({
    required String name,
    Map<String, int>? teamPlayer,
    Uint8List? logoImage,
    String? captainKey,
  }) async {
    final box = await _getBox();
    final team = TeamModel(
      key: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      teamPlayer: teamPlayer ?? {},
      logoImage: logoImage,
      captainKey: captainKey,
      //logoimagePath: null, // Ensure old field is null
    );
    await box.put(team.key, team);
  }

  Future<TeamModel?> getTeam(String key) async {
    final box = await _getBox();
    return box.get(key);
  }

  Future<List<TeamModel>> getAllTeams() async {
    final box = await _getBox();
    return box.values.toList();
  }

  Future<void> updateTeam({
    required String key,
    String? name,
    Map<String, int>? teamPlayer,
    Uint8List? logoImage,
    String? captainKey,
  }) async {
    final box = await _getBox();
    final team = await box.get(key);
    if (team != null) {
      team.name = name ?? team.name;
      team.teamPlayer = teamPlayer ?? team.teamPlayer;
      team.logoImage = logoImage ?? team.logoImage;
      team.captainKey = captainKey ?? team.captainKey;
    //  team.logoimagePath = null; // Clear old field
      await team.save();
    }
  }

  Future<void> deleteTeam(String key) async {
    final box = await _getBox();
    await box.delete(key);
  }

  Future<void> addPlayerToTeam({
    required String teamKey,
    required String playerKey,
    required int jerseyNumber,
  }) async {
    final box = await _getBox();
    final team = await box.get(teamKey);
    if (team != null) {
      team.teamPlayer ??= {};
      if (team.teamPlayer!.values.contains(jerseyNumber)) {
        throw Exception('Jersey number $jerseyNumber is already in use');
      }
      team.teamPlayer![playerKey] = jerseyNumber;
      await team.save();
    } else {
      throw Exception('Team not found');
    }
  }

  Future<void> removePlayerFromTeam({
    required String teamKey,
    required String playerKey,
  }) async {
    final box = await _getBox();
    final team = await box.get(teamKey);
    if (team != null && team.teamPlayer != null) {
      team.teamPlayer!.remove(playerKey);
      if (team.captainKey == playerKey) {
        team.captainKey = null;
      }
      await team.save();
    }
  }

  Future<void> updatePlayerJerseyNumber({
    required String teamKey,
    required String playerKey,
    required int newJerseyNumber,
  }) async {
    final box = await _getBox();
    final team = await box.get(teamKey);
    if (team != null && team.teamPlayer != null) {
      if (team.teamPlayer![playerKey] != newJerseyNumber &&
          team.teamPlayer!.values.contains(newJerseyNumber)) {
        throw Exception('Jersey number $newJerseyNumber is already in use');
      }
      team.teamPlayer![playerKey] = newJerseyNumber;
      await team.save();
    }
  }

  Future<void> setCaptain({
    required String teamKey,
    required String playerKey,
  }) async {
    final box = await _getBox();
    final team = await box.get(teamKey);
    if (team != null) {
      if (team.teamPlayer == null || !team.teamPlayer!.containsKey(playerKey)) {
        throw Exception('Player not found in team');
      }
      team.captainKey = playerKey;
      await team.save();
    } else {
      throw Exception('Team not found');
    }
  }

  Future<void> removeCaptain({
    required String teamKey,
  }) async {
    final box = await _getBox();
    final team = await box.get(teamKey);
    if (team != null) {
      team.captainKey = null;
      await team.save();
    }
  }

  Future<Map<String, int>?> getTeamPlayers(String teamKey) async {
    final box = await _getBox();
    final team = await box.get(teamKey);
    return team?.teamPlayer;
  }

  Future<List<String>> getTeamPlayerKeys(String teamKey) async {
    final teamPlayers = await getTeamPlayers(teamKey);
    return teamPlayers?.keys.toList() ?? [];
  }

  Future<bool> isJerseyNumberUnique(String teamKey, int jerseyNumber) async {
    final teamPlayers = await getTeamPlayers(teamKey);
    if (teamPlayers == null) return true;
    return !teamPlayers.values.contains(jerseyNumber);
  }

  Future<String?> getCaptainKey(String teamKey) async {
    final box = await _getBox();
    final team = await box.get(teamKey);
    return team?.captainKey;
  }

  // Future<void> migrateTeams() async {
  //   final box = await _getBox();
  //   for (var teeam in box.values) {
  //     if (team.logoImage != null && team.logoImage == null) {
  //       try {
  //         final bytes = await File(team.logoImage!).readAsBytes();
  //         team.logoImage = bytes;
  //         team.logoImage = null;
  //         await team.save();
  //       } catch (e) {
  //         print('Error migrating team ${team.name}: $e');
  //         team.logoImage = null;
  //         team.logoImage = null;
  //         await team.save();
  //       }
  //     }
  //   }
  // }
}