import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maya/src/config/events.dart';
import 'package:maya/src/providers/signedUrlProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:io';

final audioFileProvider =
    FutureProvider.family<String, String>((ref, fileName) async {
  try {
    if (fileName.isEmpty) return "";
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    // Check if the file exists locally
    if (await file.exists()) {
      return filePath;
    } else {
      Events().audioDownloadingEvent(fileName);
      // Fetch signed URL from the API using signedUrlProvider
      final signedUrlAsyncValue = await ref.watch(signedUrlProvider(
              SignedUrlRequest(fileName: fileName, isImage: false))
          .future);
      final String signedUrl = signedUrlAsyncValue.signedUrl;
      // Download the file locally
      final dio = Dio();
      await dio.download(signedUrl, filePath);
      Events().audioDownloadedEvent(fileName);
      return filePath;
    }
  } catch (e) {
    print('Error fetching audio file: $e');
    Events().audioDownloadError(fileName, e.toString());
    return "";
  }
});
