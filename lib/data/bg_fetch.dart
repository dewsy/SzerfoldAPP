import 'dart:async';
import 'package:background_fetch/background_fetch.dart';
import 'package:szeretet_foldje/data/database_helper.dart';
import 'package:szeretet_foldje/models/daily.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BackgroundDailyFetch {
  Future<void> initPlatformState() async {
    BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true),
        callBackOperation);
  }

  void callBackOperation() async {
    /*List<Map<String, dynamic>> latestList = await dbHelper.queryLatest();
    Daily latest = Daily.fromMap(latestList[0]);
    if (DateTime.now().isAfter(latest.date.add(Duration(days: 1, hours: 11)))) { */
    sendNotification();
    // }

    BackgroundFetch.finish();
  }

  Future<void> sendNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '1', 'Értesítések', 'Új napi igéről szóló értesítések',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'Új napi ige:',
        'Nézd meg ma is a napi igét!', platformChannelSpecifics);
  }

  void eanbleFetch() {
    BackgroundFetch.start();
  }
}

final bgFetch = BackgroundDailyFetch();
