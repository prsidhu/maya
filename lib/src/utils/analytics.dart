import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';
import 'package:morpheus/src/utils/envVariables.dart';

class Analytics {
  static final Analytics _instance = Analytics._internal();
  final Amplitude _amplitude;

  Analytics._internal()
      : _amplitude = Amplitude(EnvVariables().getAmplitudeInstanceId()) {
    _amplitude.init(EnvVariables().getAmplitudeInstanceId());
  }

  factory Analytics() {
    return _instance;
  }

  void logEvent(String eventName, [Map<String, dynamic>? properties]) {
    _amplitude.logEvent(eventName, eventProperties: properties);
  }

  void setIdentity(Map<String, dynamic> identity) {
    final Identify identify = Identify();
    identity.forEach((key, value) {
      identify.setOnce(key, value);
    });
    _amplitude.identify(identify);
  }
}
