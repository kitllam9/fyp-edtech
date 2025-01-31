import 'package:fyp_edtech/service/api.dart';

class Quest {
  final String name;
  final String description;
  final int target;
  final num progress;
  final bool completed;
  final int reward;

  Quest({
    required this.name,
    required this.description,
    required this.target,
    required this.progress,
    required this.completed,
    required this.reward,
  });

  static Quest fromJson(Map<String, dynamic> json) {
    return Quest(
      name: json['name'],
      description: json['description'],
      target: json['target'],
      progress: json['progress'],
      completed: json['completed'],
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
