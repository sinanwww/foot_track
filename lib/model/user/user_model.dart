import 'package:hive/hive.dart';

part 'user_model.g.dart'; // Generated file for Hive adapter

@HiveType(typeId: 0)
class UserModel extends HiveObject{
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int age;

  @HiveField(2)
  final String mobileNumber;

  @HiveField(3)
  final String email;

  UserModel({
    required this.name,
    required this.age,
    required this.mobileNumber,
    required this.email,
  });
}