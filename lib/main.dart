import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure plugin services are initialized first
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: 'AIzaSyDMGEDWJBzlmNuGWloRPJlpI0ZseCyn-k8',
      appId: '1:1034642639369:android:342b7db399a36d8cdb86d8',
      messagingSenderId: '1034642639369',
      projectId: 'yume-fa6f1',
      storageBucket: 'yume-fa6f1.appspot.com',
    ));
  }

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(ProviderScope(child: MyApp(settingsController: settingsController)));
}
