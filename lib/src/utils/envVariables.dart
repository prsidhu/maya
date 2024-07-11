import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvVariables {
  String getAmplitudeInstanceId() {
    return dotenv.env['AMPLITUDE_INSTANCE_ID'] ?? '';
  }
}
