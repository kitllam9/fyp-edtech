import 'package:fyp_edtech/service/api.dart';

class Quest {
  final int id;
  final String name;
  final String description;
  final int target;
  final num progress;
  final bool completed;
  final bool? claimed;
  final int reward;

  Quest({
    required this.id,
    required this.name,
    required this.description,
    required this.target,
    required this.progress,
    required this.completed,
    this.claimed,
    required this.reward,
  });

  Future<bool> complete() async {
    var res = await Api().get(
      path: '/quest/complete/$id',
    );
    return res?.success ?? false;
  }

  static Quest fromJson(Map<String, dynamic> json) {
    return Quest(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      target: json['target'],
      progress: json['progress'],
      completed: json['completed'],
      claimed: json['claimed'],
      reward: json['reward'],
    );
  }

  static Future<List<Quest>?> fetch() async {
    var res = await Api().get(
      path: '/quest',
    );
    if (res?.success ?? false) {
      return [for (var json in res!.data!['quests']) Quest.fromJson(json)];
    }
    return null;
  }
}
