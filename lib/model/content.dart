import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_edtech/model/paginated_data.dart';
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
  final List<Map<String, dynamic>>? exerciseDetails;
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
    String? originalUrl = json['pdf_url'];
    String? newUrl;
    if (originalUrl != null) {
      String newHost = '10.0.2.2:8000';
      // String newHost = dotenv.get('API_DEV');

      Uri originalUri = Uri.parse(originalUrl);
      String path = originalUri.path;
      String query = originalUri.query;
      String fragment = originalUri.fragment;

      // Create a new URL with the IPv4 address as the host
      newUrl = 'http://$newHost$path';
      if (query.isNotEmpty) {
        newUrl += '?$query';
      }
      if (fragment.isNotEmpty) {
        newUrl += '#$fragment';
      }
    }

    return Content(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: ContentType.fromString(json['type']),
      pdfUrl: newUrl,
      tags: jsonDecode(json['tags']),
    );
  }

  static Future<PaginatedData<Content>?> fetchContent() async {
    var res = await Api().get(path: '/content');
    if (res?.success ?? false) {
      return PaginatedData<Content>.fromJson(
        res!.data!,
        (item) => Content.fromJson(item),
      );
    }
    return null;
  }
}
