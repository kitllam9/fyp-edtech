import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fyp_edtech/model/user.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class Api {
  Api({String? host, this.pathPrefix = '/api'}) {
    if (host != null) this.host = host;
  }

  /// Default header for making requests to the backend
  Map<String, String> get defaultHeaders => {
        'Accept': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Authorization': 'Bearer ${user.token}',
        'Content-type': 'application/json',
      };

  final String pathPrefix;

  User user = GetIt.instance.get<User>();
  String host = dotenv.env['API_DEV']!;

  Future<ApiResponse>? get({
    required String path,
    Map<String, String>? headers,
    Map<String, String?>? queries,
  }) {
    try {
      return request(
        method: 'get',
        path: path,
        headers: headers,
        queries: queries,
      );
    } catch (_) {
      return null;
    }
  }

  Future<ApiResponse>? post({
    required String path,
    Map<String, String>? headers,
    Map<String, dynamic>? queries,
    Map<String, dynamic>? payload,
  }) {
    try {
      return request(
        method: 'post',
        path: path,
        headers: headers,
        queries: queries,
        payload: payload,
      );
    } catch (_) {
      return null;
    }
  }

  Future<ApiResponse>? put({
    required String path,
    Map<String, String>? headers,
    Map<String, dynamic>? queries,
    Map<String, dynamic>? payload,
  }) {
    try {
      return request(
        method: 'put',
        path: path,
        headers: headers,
        queries: queries,
        payload: payload,
      );
    } catch (_) {
      return null;
    }
  }

  Future<ApiResponse>? delete({
    required String path,
    Map<String, String>? headers,
    Map<String, dynamic>? queries,
    Map<String, dynamic>? payload,
  }) {
    try {
      return request(
        method: 'delete',
        path: path,
        headers: headers,
        queries: queries,
        payload: payload,
      );
    } catch (_) {
      return null;
    }
  }

  /// Make a **JSON [method] request** to `/[path]?[queries]`.
  /// The default `content-type` header is `application/json`.
  ///
  /// For more fine-grained control over the request, use [requests] or  [http] module instead.
  ///
  /// Supported [method]: `get`, `post`, `put`, `delete`
  Future<ApiResponse> request({
    required String method,
    required String path,
    Map<String, String>? headers,
    Map<String, dynamic>? queries,
    Map<String, dynamic>? payload,
  }) async {
    var uri = Uri.http(host, pathPrefix + path, queries);
    late Future<http.Response> request;

    switch (method.toLowerCase()) {
      case 'get':
        request = http.get(
          uri,
          headers: headers ?? defaultHeaders,
        );
        break;
      case 'post':
        request = http.post(
          uri,
          body: jsonEncode(payload),
          headers: headers ?? defaultHeaders,
        );
        break;
      case 'put':
        request = http.put(
          uri,
          body: jsonEncode(payload),
          headers: headers ?? defaultHeaders,
        );
        break;
      case 'delete':
        request = http.delete(
          uri,
          body: payload,
          headers: headers ?? defaultHeaders,
        );
        break;
      default:
        throw UnsupportedError('Request method is not supported: ${method.toLowerCase()}.');
    }

    return request.then(
      (response) {
        // print(response.body);
        var apiResponse = ApiResponse.fromJson(
          json.decode(response.body),
          ResponseInfo.fromResponse(response),
        );

        return apiResponse;
      },
    ).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      throw error as Error;
    });
  }
}

class ApiResponse {
  late bool success;
  late String message;
  Map<String, dynamic>? data = {};
  Map<String, dynamic>? errors = {};
  late ResponseInfo details;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    required this.details,
  });

  ApiResponse.fromJson(Map<String, dynamic> json, this.details) {
    success = json['success'];
    message = json['message'] ?? '';
    data = json['data'];
    errors = json['errors'];
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': json.encode(data),
      'responseDetails': details.toJson(),
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

class ResponseInfo {
  const ResponseInfo({
    this.status,
    this.contentLength,
    this.headers,
  });

  static ResponseInfo fromResponse(http.Response res) {
    return ResponseInfo(
      status: res.statusCode,
      contentLength: res.contentLength,
      headers: res.headers,
    );
  }

  final int? status;
  final int? contentLength;
  final Map<String, String>? headers;

  Map<String, dynamic> toJson() {
    return {'status': status, 'contentLength': contentLength, 'headers': headers};
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
