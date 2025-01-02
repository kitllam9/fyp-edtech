import 'package:fyp_edtech/model/user.dart';
import 'package:fyp_edtech/service/api.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;
final lStorage = getIt.get<SharedPreferences>();
final User user = getIt.get<User>();

class Auth {
  static Future<ApiResponse?> register({
    required String username,
    required String email,
    required String password,
  }) async {
    var res = await Api().post(
      path: '/user/register',
      payload: {
        'username': username,
        'email': email,
        'password': password,
      },
    );
    if (res?.success ?? false) {
      Map<String, dynamic> userData = res!.data!['user'];
      user.token = res.data!['access_token'];
      lStorage.setString('token', user.token!);
      user.username = userData['username'];
      user.email = userData['email'];
    }
    return res;
  }

  static Future<ApiResponse?> login({
    required String username,
    required String password,
  }) async {
    var res = await Api().post(
      path: '/user/login',
      payload: {
        'username': username,
        'password': password,
      },
    );
    if (res?.success ?? false) {
      Map<String, dynamic> userData = res!.data!['user'];
      user.token = res.data!['access_token'];
      lStorage.setString('token', user.token!);
      user.username = userData['username'];
      user.email = userData['email'];
    }
    return res;
  }
}
