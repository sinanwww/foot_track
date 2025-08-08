import 'package:hive/hive.dart';
import 'package:foot_track/model/team/team_model.dart';

class TeamService {
  static const String _boxName = 'teams';

  // Initialize Hive and open the box
  Future<Box<TeamModel>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<TeamModel>(_boxName);
    }
    return Hive.box<TeamModel>(_boxName);
  }

  // Create a new team
  Future<void> createTeam({
    required String name,
    Map<String, int>? teamPlayer,
    String? logoimagePath,
    String? captainKey,
  }) async {
    final box = await _getBox();
    final team = TeamModel(
      key: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      teamPlayer: teamPlayer ?? {},
      logoimagePath: logoimagePath,
      captainKey: captainKey,
    );
    await box.put(team.key, team);
  }

  // Read a team by key
  Future<TeamModel?> getTeam(String key) async {
    final box = await _getBox();
    return box.get(key);
  }

  // Read all teams
  Future<List<TeamModel>> getAllTeams() async {
    final box = await _getBox();
    return box.values.toList();
  }

  // Update a team
  Future<void> updateTeam({
    required String key,
    String? name,
    Map<String, int>? teamPlayer,
    String? logoimagePath,
    String? captainKey,
  }) async {
    final box = await _getBox();
    final team = await box.get(key);
    if (team != null) {
      team.name = name ?? team.name;
      team.teamPlayer = teamPlayer ?? team.teamPlayer;
      team.logoimagePath = logoimagePath ?? team.logoimagePath;
      team.captainKey = captainKey ?? team.captainKey;
      await team.save();
    }
  }

  // Delete a team
  Future<void> deleteTeam(String key) async {
    final box = await _getBox();
    await box.delete(key);
  }

  // Add a player to teamPlayer map
  Future<void> addPlayerToTeam({
    required String teamKey,
    required String playerKey,
    required int jerseyNumber,
  }) async {
    final box = await _getBox();
    final team = await box.get(teamKey);
    if (team != null) {
      team.teamPlayer ??= {};
      // Check if jersey number is unique
      if (team.teamPlayer!.values.contains(jerseyNumber)) {
        throw Exception('Jersey number $jerseyNumber is already in use');
      }
      team.teamPlayer![playerKey] = jerseyNumber;
      await team.save();
    } else {
      throw Exception('Team not found');
    }
  }

  // Remove a player from teamPlayer map
  Future<void> removePlayerFromTeam({
    required String teamKey,
    required String playerKey,
  }) async {
    final box = await _getBox();
    final team = await box.get(teamKey);
    if (team != null && team.teamPlayer != null) {
      team.teamPlayer!.remove(playerKey);
      // Clear captainKey if the removed player was the captain
      if (team.captainKey == playerKey) {
        team.captainKey = null;
      }
      await team.save();
    }
  }

  // Update a player's jersey number
  Future<void> updatePlayerJerseyNumber({
    required String teamKey,
    required String playerKey,
    required int newJerseyNumber,
  }) async {
    final box = await _getBox();
    final team = await box.get(teamKey);
    if (team != null && team.teamPlayer != null) {
      // Check if new jersey number is unique (excluding the current player's number)
      if (team.teamPlayer![playerKey] != newJerseyNumber &&
          team.teamPlayer!.values.contains(newJerseyNumber)) {
        throw Exception('Jersey number $newJerseyNumber is already in use');
      }
      team.teamPlayer![playerKey] = newJerseyNumber;
      await team.save();
    }
  }

  // Set a player as captain
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

  // Remove captain
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

  // Get all players for a team
  Future<Map<String, int>?> getTeamPlayers(String teamKey) async {
    final box = await _getBox();
    final team = await box.get(teamKey);
    return team?.teamPlayer;
  }

  // Get list of player keys in the team
  Future<List<String>> getTeamPlayerKeys(String teamKey) async {
    final teamPlayers = await getTeamPlayers(teamKey);
    return teamPlayers?.keys.toList() ?? [];
  }

  // Check if jersey number is unique for the team
  Future<bool> isJerseyNumberUnique(String teamKey, int jerseyNumber) async {
    final teamPlayers = await getTeamPlayers(teamKey);
    if (teamPlayers == null) return true;
    return !teamPlayers.values.contains(jerseyNumber);
  }

  // Get captain key
  Future<String?> getCaptainKey(String teamKey) async {
    final box = await _getBox();
    final team = await box.get(teamKey);
    return team?.captainKey;
  }
}