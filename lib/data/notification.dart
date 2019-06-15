import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Noti {
  createNoti() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings("app_icon");
    var iOS = IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings);

    var time = new Time(17, 40, 0);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'Értesítések',
        'Napi emlékeztető az üzenetekről');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'Napi üzenet!',
        'Ne feledd ma is megnézni a napi üzenetet!',
        time,
        platformChannelSpecifics);
  }
}
