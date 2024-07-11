import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:maya/src/config/constants.dart';
import 'package:maya/src/models/signedUrl.dart';

class SignedUrlRequest {
  final String fileName;
  final bool isImage;

  SignedUrlRequest({required this.fileName, required this.isImage});
}

final signedUrlProvider =
    FutureProvider.family<SignedUrl, SignedUrlRequest>((ref, request) async {
  try {
    String url = request.isImage
        ? Constants.imageUrl(request.fileName)
        : Constants.signedUrlEndpoint(request.fileName);

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return SignedUrl(
        signedUrl: data['signedUrl'],
        expiryDate: DateTime.parse(data['expiryDate']),
      );
    } else {
      throw Exception('Failed to fetch signed URL');
    }
  } catch (e) {
    print('Error fetching signed URL: $e');
    throw Exception('Failed to fetch signed URL');
  }
});
