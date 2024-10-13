import 'dart:async';
import 'dart:convert';
import 'package:fyp_edtech/model/user.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:requests/requests.dart';

class Api {
  bool isTiming = false;

  Api({String? host, this.pathPrefix = ''}) {
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
  String host = 'google.com';

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
    var uri = Uri.https(host, pathPrefix + path, queries);
    late Future<http.Response> request;

    switch (method.toLowerCase()) {
      case 'get':
        request = Requests.get(
          uri.toString(),
          headers: headers ?? defaultHeaders,
          bodyEncoding: RequestBodyEncoding.JSON,
          timeoutSeconds: 60,
        );
        break;
      case 'post':
        request = Requests.post(
          uri.toString(),
          body: payload,
          bodyEncoding: RequestBodyEncoding.JSON,
          headers: headers ?? defaultHeaders,
          timeoutSeconds: 60,
        );
        break;
      case 'put':
        request = Requests.put(
          uri.toString(),
          body: payload,
          bodyEncoding: RequestBodyEncoding.JSON,
          headers: headers ?? defaultHeaders,
          timeoutSeconds: 60,
        );
        break;
      case 'delete':
        request = Requests.delete(
          uri.toString(),
          body: payload,
          bodyEncoding: RequestBodyEncoding.JSON,
          headers: headers ?? defaultHeaders,
          timeoutSeconds: 60,
        );
        break;
      default:
        throw UnsupportedError('Request method is not supported: ${method.toLowerCase()}.');
    }

    return request.then(
      (response) {
        if (response.contentType != null && response.contentType!.contains('application/json')) {
          isTiming = false;
          var apiResponse = ApiResponse.fromJson(
            response.json() as Map<String, dynamic>,
            ResponseInfo.fromResponse(response),
          );

          if (!apiResponse.success) {
            // if (apiResponse.data?['errors'] != null) {
            //   final validationErrors = apiResponse.validationErrors();
            //   final errorMessages = validationErrors.values
            //       .map(
            //         (errorList) => errorList.join(', '),
            //       )
            //       .join(
            //         '\n>\t',
            //       );
            // }
          }
          return apiResponse;
        }

        throw UnsupportedError('Response content type \'${response.contentType}\' is not supported'
            'with the request: ${response.request}');
      },
    ).onError((error, stackTrace) {
      isTiming = false;
      throw error as Exception;
    });
  }
}

class ApiResponse {
  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    required this.details,
  });

  ApiResponse.fromJson(Map<String, dynamic> json, this.details) {
    success = json['success'];
    message = json['message'];
    data = json['data'];
  }

  late bool success;
  late String message;
  Map<String, dynamic>? data = {};
  late ResponseInfo details;

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': json.encode(data),
      'responseDetails': details.toJson(),
    };
  }

  Map<String, dynamic> validationErrors() {
    return data?['errors'] ?? {};
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
