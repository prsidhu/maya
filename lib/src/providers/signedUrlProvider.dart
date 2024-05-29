import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:morpheus/src/config/constants.dart';
import 'package:morpheus/src/models/signedUrl.dart';

final signedUrlProvider =
    FutureProvider.family<SignedUrl, String>((ref, fileName) async {
  try {
    print('url: ${Constants.signedUrlEndpoint(fileName)}');
    final response =
        await http.get(Uri.parse(Constants.signedUrlEndpoint(fileName)));
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
