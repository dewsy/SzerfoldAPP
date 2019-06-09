import 'package:flutter/material.dart';
import 'app.dart';
import 'package:background_fetch/background_fetch.dart';

/// This "Headless Task" is run when app is terminated.
void backgroundFetchHeadlessTask() async {
  BackgroundFetch.finish();
}



void main() {
  runApp(App());
    // Register to receive BackgroundFetch events after app is terminated.
  // Requires {stopOnTerminate: false, enableHeadless: true}
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  }
 
