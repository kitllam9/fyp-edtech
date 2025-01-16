import 'dart:convert';

import 'package:fyp_edtech/model/paginated_data.dart';
import 'package:fyp_edtech/model/question.dart';
import 'package:fyp_edtech/service/api.dart';

enum ContentType {
  notes,
  exercise;

  static ContentType fromString(String? str) {
    switch (str) {
      case 'notes':
        return notes;
      case 'exercise':
        return exercise;
      default:
        return notes;
    }
  }
}

class Content {
  final int id;
  final String title;
  final String description;
  final ContentType type;
  final String? pdfUrl;
  final List<Question>? exerciseDetails;
  final List<dynamic> tags;

  Content({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.pdfUrl,
    this.exerciseDetails,
    required this.tags,
  });

  static Content fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: ContentType.fromString(json['type']),
      pdfUrl: json['pdf_url'],
      exerciseDetails: json['exercise_details'] != null
          ? [for (var q in jsonDecode(json['exercise_details']).cast<Map<String, dynamic>>()) Question.fromJson(q)]
          : null,
      tags: jsonDecode(json['tags']),
    );
  }

  static Future<PaginatedData<Content>?> fetchContent({
    required int page,
  }) async {
    var res = await Api().get(
      path: '/content',
      queries: {
        'page': page.toString(),
      },
    );
    if (res?.success ?? false) {
      return PaginatedData<Content>.fromJson(
        res!.data!,
        (item) => Content.fromJson(item),
      );
    }
    return null;
  }

  static Future<bool> complete(int id) async {
    var res = await Api().get(path: '/content/complete/$id');
    return res?.success ?? false;
  }
}
