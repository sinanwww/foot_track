import 'package:hive/hive.dart';
import 'package:foot_track/model/team/team_model.dart';

class TeamRepo {
  static const String _boxName = 'teams';

  // Initialize Hive box
  Future<Box<TeamModel>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<TeamModel>(_boxName);
    }
    return Hive.box<TeamModel>(_boxName);
  }
// 
  // Create a new team
  Future<String> addTeam(TeamModel team) async {
    try {
      final box = await _getBox();
      final key = DateTime.now().millisecondsSinceEpoch.toString();
      team.key = key;
      await box.put(key, team);
      return key;
    } catch (e) {
      throw Exception('Failed to add team: $e');
    }
  }

  // Read a team by key
  Future<TeamModel?> getTeam(String key) async {
    try {
      final box = await _getBox();
      return box.get(key);
    } catch (e) {
      throw Exception('Failed to get team: $e');
    }
  }

  // Read all teams
  Future<List<TeamModel>> getAllTeams() async {
    try {
      final box = await _getBox();
      return box.values.toList();
    } catch (e) {
      throw Exception('Failed to get all teams: $e');
    }
  }

  // Update a team
  Future<void> updateTeam(String key, TeamModel updatedTeam) async {
    try {
      final box = await _getBox();
      if (box.containsKey(key)) {
        // Check jersey number uniqueness if teamPlayer is updated
        if (updatedTeam.teamPlayer != null) {
          final currentTeam = await box.get(key);
          final currentPlayers = currentTeam?.teamPlayer ?? {};
          for (var entry in updatedTeam.teamPlayer!.entries) {
            if (currentPlayers[entry.key] != entry.value &&
                currentPlayers.values.contains(entry.value)) {
              throw Exception('Jersey number ${entry.value} is already in use');
            }
          }
        }
        updatedTeam.key = key;
        await box.put(key, updatedTeam);
      } else {
        throw Exception('Team not found');
      }
    } catch (e) {
      throw Exception('Failed to update team: $e');
    }
  }

  // Delete a team
  Future<void> deleteTeam(String key) async {
    try {
      final box = await _getBox();
      if (box.containsKey(key)) {
        await box.delete(key);
      } else {
        throw Exception('Team not found');
      }
    } catch (e) {
      throw Exception('Failed to delete team: $e');
    }
  }
}
