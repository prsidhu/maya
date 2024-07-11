import 'package:morpheus/src/utils/analytics.dart';

class Events {
  /* Auth Events */
  void loginWithEmail() {
    Analytics().logEvent('login_with_email');
  }

  void loginWithGoogle() {
    Analytics().logEvent('login_with_google');
  }

  void choreoClickedEvent(String id, String title) {
    Analytics().logEvent('choreo_clicked', {'id': id, 'title': title});
  }

  void selectGoalEvent(String goal) {
    Analytics().logEvent('select_goal', {'goal': goal});
  }

  /* CHOREO DETAIL SCREEN EVENTS */

  void audioDownloadedEvent(String mediaName) {
    Analytics().logEvent('audio_downloaded', {'mediaName': mediaName});
  }

  void audioDownloadingEvent(String mediaName) {
    Analytics().logEvent('audio_downloading', {'mediaName': mediaName});
  }

  void audioDownloadError(String mediaName, String error) {
    Analytics().logEvent(
        'audio_download_error', {'mediaName': mediaName, 'error': error});
  }

  void startTherapyEvent(String id, String title, int duration) {
    Analytics().logEvent(
        'start_therapy', {'id': id, 'title': title, 'duration': duration});
  }

  void stopTherapyEvent(String id, String title, int duration) {
    Analytics().logEvent(
        'stop_therapy', {'id': id, 'title': title, 'duration': duration});
  }

  /* Torchlight events */

  void torchLightAvailable() {
    Analytics().logEvent('torchlight_available');
  }

  void torchLightNotAvailable() {
    Analytics().logEvent('torchlight_not_available');
  }
}
