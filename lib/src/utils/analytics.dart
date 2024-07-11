import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class Analytics {
  static final Analytics _instance = Analytics._internal();
  final Amplitude _amplitude;

  Analytics._internal()
      : _amplitude = Amplitude('d22a5cda21c4feacf91c927b3a9818d2') {
    _amplitude.init('d22a5cda21c4feacf91c927b3a9818d2');
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
