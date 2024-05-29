class Constants {
  static const String baseUrl =
      'https://6uvte70cd0.execute-api.us-east-1.amazonaws.com/prod/';

  static String signedUrlEndpoint(String fileName) =>
      '${baseUrl}signed-url?fileName=$fileName';
}
