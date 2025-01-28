import 'dart:convert';

import 'package:fyp_edtech/service/api.dart';

class MyBadge {
  final String name;
  final String description;

  MyBadge({
    required this.name,
    required this.description,
  });

  static MyBadge fromJson(Map<String, dynamic> json) {
    return MyBadge(
      name: json['name'],
      description: json['description'],
    );
  }

  static Future<List<MyBadge>?> fetchBadges({
    required List<int> ids,
  }) async {
    var res = await Api().get(
      path: '/badge',
      queries: {
        'badge_ids': jsonEncode(ids),
      },
    );
    if (res?.success ?? false) {
      return [for (var json in res!.data!['badges']) MyBadge.fromJson(json)];
    }
    return null;
  }
}
