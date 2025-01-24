import 'package:fyp_edtech/service/api.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String? token;
  bool get loggedIn => token != null;

  String? username;
  String? email;
  int? points;
  List<String>? interest;

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

  Future<void> getUserData() async {
    var res = await Api().get(
      path: '/user',
    );
    if (res?.success ?? false) {
      username = res!.data!['username'];
      email = res.data!['email'];
      points = res.data!['points'];
      interest = List<String>.from(res.data!['interest'] ?? []);
    }
  }

  Future<Map<String, dynamic>?> checkBadges({
    required int points,
  }) async {
    var res = await Api().get(
      path: '/badge/check',
      queries: {
        'points': points.toString(),
      },
    );
    if (res?.success ?? false) {
      return res!.data!;
    }
    return null;
  }
}
