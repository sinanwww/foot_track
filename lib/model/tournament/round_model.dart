import 'package:hive/hive.dart';

part 'round_model.g.dart';

@HiveType(typeId: 6)
class RoundModel extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  DateTime? date;

  @HiveField(2)
  List<String> matchKeys;

  @HiveField(3)
  String? description;

  RoundModel({
    this.name,
    this.date,
    this.matchKeys = const [],
    this.description,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date?.toIso8601String(),
        'matchKeys': matchKeys,
        'description': description,
      };
}