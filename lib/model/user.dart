import 'package:fyp_edtech/service/api.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String? token;
  bool get loggedIn => token != null;

  String? username;
  String? email;

  Future<bool> logout() async {
    var res = await Api().get(
      path: '/user/logout',
    );
    if (res?.success ?? false) {
      final lStorage = GetIt.instance.get<SharedPreferences>();
      token = null;
      lStorage.remove('token');
      return true;
    } else {
      return false;
    }
  }
}
