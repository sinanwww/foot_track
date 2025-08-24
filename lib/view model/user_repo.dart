import 'package:hive/hive.dart';
import 'package:foot_track/model/user/user_model.dart';

class UserRepo {
  static const String _boxName = 'userBox';
  static const String _userKey = 'currentUser';

  Future<void> init() async {
    await Hive.openBox<UserModel>(_boxName);
  }

  Future<void> saveUser(UserModel user) async {
    final box = Hive.box<UserModel>(_boxName);
    await box.put(_userKey, user);
    print('User saved: ${user.name}, ${user.email}');
  }

  Future<UserModel?> getUser() async {
    await init();
    final box = Hive.box<UserModel>(_boxName);
    final user = box.get(_userKey);
    print('Retrieved user: ${user?.name}, ${user?.email}');
    return user;
  }

  Future<bool> hasUser() async {
    final box = Hive.box<UserModel>(_boxName);
    return box.containsKey(_userKey);
  }

  Future<void> deleteUser() async {
    final box = Hive.box<UserModel>(_boxName);
    await box.delete(_userKey);
    print('User deleted');
  }

  Future<void> close() async {
    await Hive.close();
  }
}
