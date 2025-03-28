import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/retry.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

Future<File> getFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.create(recursive: true);
  await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}

Future<String> downloadFile(String url, String fileName, String dir) async {
  HttpClient httpClient = HttpClient();
  File file;
  String filePath = '';

  print(url);
  try {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      var bytes = await consolidateHttpClientResponseBytes(response);
      filePath = '$dir/$fileName';
      file = File(filePath);
      await file.writeAsBytes(bytes);
    } else {
      filePath = 'Error code: ${response.statusCode}';
    }
  } catch (ex) {
    filePath = 'Can not fetch url';
  }

  return filePath;
}

/// TEMPORARY
/// Use the actual url when deployed
Future<File?> getPdf(int id) async {
  var client = RetryClient(http.Client(), retries: 3);
  var response = await client
      .get(
        Uri.http(
          dotenv.get('API_DEV'),
          '/api/content/get-pdf/$id',
        ),
      )
      .timeout(
        const Duration(seconds: 15),
      );

  if (response.statusCode == 200) {
    Directory tempDir = await getTemporaryDirectory();
    File file = File('${tempDir.path}/$id.pdf');
    await file.writeAsBytes(response.bodyBytes);
    return file;
  } else {
    return null;
  }
}
