import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maya/src/providers/signedUrlProvider.dart';
import 'package:path_provider/path_provider.dart';

final dioProvider = Provider((ref) => Dio());

final imageProvider =
    FutureProvider.family<Uint8List, String>((ref, fileName) async {
  try {
    if (fileName.isEmpty) return Uint8List(0);
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    // Check if the file exists locally
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      return bytes;
    } else {
      // Fetch signed URL from the API using signedUrlProvider
      final signedUrlAsyncValue = await ref.watch(
          signedUrlProvider(SignedUrlRequest(fileName: fileName, isImage: true))
              .future);
      final String signedUrl = signedUrlAsyncValue.signedUrl;

      // Download the file locally
      final dio = Dio();
      await dio.download(signedUrl, filePath);

      return await File(filePath).readAsBytes();
    }
  } catch (e) {
    print('Error fetching image: $e');
    return Uint8List(0);
  }
});
