import 'package:foot_track/model/tournament/round_model.dart';
import 'package:hive/hive.dart';

part 'tournament_model.g.dart';

@HiveType(typeId: 5)
class TournamentModel extends HiveObject {
  @HiveField(0)
  String? key;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? venue;

  @HiveField(3)
  DateTime? date;

  @HiveField(4)
  List<String> teamKeys;

  @HiveField(5)
  List<RoundModel> rounds;

  @HiveField(6)
  String? description; 

  @HiveField(7)
  String? winner;

  TournamentModel({
    this.key,
    this.name,
    this.venue,
    this.date,
    this.teamKeys = const [],
    this.rounds = const [],
    this.description,
    this.winner,
  });

  Map<String, dynamic> toJson() => {
        'key': key,
        'name': name,
        'venue': venue,
        'date': date?.toIso8601String(),
        'teamKeys': teamKeys,
        'rounds': rounds.map((r) => r.toJson()).toList(),
        'description':description,
        'winner':winner
      };
}