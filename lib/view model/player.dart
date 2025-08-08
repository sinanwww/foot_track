import 'package:flutter/material.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class PlayerRepo {
  ValueNotifier<List<PlayerModel>> playersNotifier = ValueNotifier([]);

  static const String _boxName = 'players_db';
  late Box<PlayerModel> _box;

  // Initialize the Hive box and populate ValueNotifier
  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<PlayerModel>(_boxName);
    } else {
      _box = Hive.box<PlayerModel>(_boxName);
    }
    // Update ValueNotifier with initial data
    playersNotifier.value = _box.values.toList();
  }

  // Add a new player to the Hive box
  Future<bool> addPlayer(PlayerModel player) async {
    await init();
    // Generate unique key
    var uuid = Uuid();
    player.key = uuid.v4();
    try {
      await _box.put(player.key, player);
      // Update ValueNotifier
      playersNotifier.value = _box.values.toList();
      return true;
    } catch (e) {
      print('Error adding player: $e');
      return false;
    }
  }

  // Get a player by key
  Future<PlayerModel?> getPlayer(String key) async {
    await init();
    return _box.get(key);
  }

  // Get all players
  Future<List<PlayerModel>> getAllPlayers() async {
    await init();
    return _box.values.toList();
  }

  // Update an existing player
  Future<bool> updatePlayer(PlayerModel player) async {
    await init();
    if (_box.containsKey(player.key)) {
      await _box.put(player.key, player);
      // Update ValueNotifier
      playersNotifier.value = _box.values.toList();
    } else {
      throw Exception('Player with key ${player.key} does not exist');
    }
    return true;
  }

  // Remove a player
  Future<void> deletePlayer(String key) async {
    await init();
    if (_box.containsKey(key)) {
      await _box.delete(key);
      // Update ValueNotifier for instant UI update
      playersNotifier.value = _box.values.toList();
      print('Player deleted, new list length: ${playersNotifier.value.length}');
    } else {
      throw Exception('Player with key $key does not exist');
    }
  }

  // Delete all players
  Future<void> deleteAllPlayers() async {
    await init();
    await _box.clear();
    // Update ValueNotifier
    playersNotifier.value = [];
  }

  // Close the box when done
  Future<void> close() async {
    await _box.close();
    // Clear ValueNotifier
    playersNotifier.value = [];
  }
}
