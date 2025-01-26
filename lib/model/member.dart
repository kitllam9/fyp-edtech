import 'package:fyp_edtech/model/paginated_data.dart';
import 'package:fyp_edtech/service/api.dart';

class Member {
  final String username;
  final int points;

  Member({
    required this.username,
    required this.points,
  });

  static Member fromJson(Map<String, dynamic> json) {
    return Member(
      username: json['username'],
      points: json['points'],
    );
  }

  static Future<PaginatedData<Member>?> getRanking({
    required int page,
  }) async {
    var res = await Api().get(
      path: '/user/rank',
      queries: {
        'page': page.toString(),
      },
    );
    if (res?.success ?? false) {
      return PaginatedData<Member>.fromJson(
        res!.data!,
        (e) => Member.fromJson(e),
      );
    }
    return null;
  }
}
