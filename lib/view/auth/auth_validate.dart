import 'package:foot_track/utls/widgets/com.dart';

class AuthValidate {
  userNameValidate(val) {
    if (val == null || val == "") {
      return "enter a user name";
    }
    if (val != HiveAuth().user) {
      return "user not found";
    }

    return null;
  }

  passwordValidate(val) {
    if (val == null || val == "") {
      return "enter password";
    }
    if (val != HiveAuth().password) {
      return "password not not found";
    }

    return null;
  }
}
