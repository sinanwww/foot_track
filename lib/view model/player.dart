import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:foot_track/model/match/match_model.dart';

class PlayerRepo {
  ValueNotifier<List<PlayerModel>> playersNotifier = ValueNotifier([]);
  static const String _boxName = 'players_db';
  late Box<PlayerModel> _box;

  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<PlayerModel>(_boxName);
    } else {
      _box = Hive.box<PlayerModel>(_boxName);
    }
    playersNotifier.value = _box.values.toList();
  }

  Future<bool> addPlayer({
    required String name,
    required String position,
    required String dateOfBirth,
    Uint8List? imageData,
  }) async {
    await init();
    var uuid = const Uuid();
    final player = PlayerModel(
      key: uuid.v4(),
      name: name,
      position: position,
      dateOfBirth: dateOfBirth,
      imageData: imageData,
    );
    try {
      await _box.put(player.key, player);
      playersNotifier.value = _box.values.toList();
      return true;
    } catch (e) {
      print('Error adding player: $e');
      return false;
    }
  }

  Future<PlayerModel?> getPlayer(String key) async {
    await init();
    return _box.get(key);
  }

  Future<List<PlayerModel>> getAllPlayers() async {
    await init();
    return _box.values.toList();
  }

  Future<bool> updatePlayer({
    required String key,
    String? name,
    String? position,
    String? dateOfBirth,
    Uint8List? imageData,
  }) async {
    await init();
    final player = await _box.get(key);
    if (player != null) {
      player.name = name ?? player.name;
      player.position = position ?? player.position;
      player.dateOfBirth = dateOfBirth ?? player.dateOfBirth;
      player.imageData = imageData ?? player.imageData;
      await _box.put(player.key, player);
      playersNotifier.value = _box.values.toList();
      return true;
    } else {
      throw Exception('Player with key $key does not exist');
    }
  }

  Future<void> deletePlayer(String key) async {
    await init();
    if (!_box.containsKey(key)) {
      throw Exception('Player with key $key does not exist');
    }
    final matchBox = await Hive.openBox<MatchModel>('matches');
    for (var match in matchBox.values) {
      if ((match.homeLineup?.contains(key) ?? false) ||
          (match.awayLineup?.contains(key) ?? false) ||
          (match.homeBench?.contains(key) ?? false) ||
          (match.awayBench?.contains(key) ?? false)) {
        throw Exception('Cannot delete player: used in match lineup or bench');
      }
    }
    await _box.delete(key);
    playersNotifier.value = _box.values.toList();
    print('Player deleted, new list length: ${playersNotifier.value.length}');
  }

  Future<void> deleteAllPlayers() async {
    await init();
    final matchBox = await Hive.openBox<MatchModel>('matches');
    for (var playerKey in _box.keys) {
      for (var match in matchBox.values) {
        if ((match.homeLineup?.contains(playerKey) ?? false) ||
            (match.awayLineup?.contains(playerKey) ?? false) ||
            (match.homeBench?.contains(playerKey) ?? false) ||
            (match.awayBench?.contains(playerKey) ?? false)) {
          throw Exception('Cannot delete all players: some are used in matches');
        }
      }
    }
    await _box.clear();
    playersNotifier.value = [];
  }

  Future<void> close() async {
    await _box.close();
    playersNotifier.value = [];
  }
}