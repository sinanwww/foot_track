import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(0)
  String key;
  @HiveField(1)
  String userName;
  @HiveField(2)
  String password;

  UserModel({
    required this.password,
    required this.userName,
    required this.key,
  });
}
