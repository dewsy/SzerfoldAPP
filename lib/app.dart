import 'package:flutter/material.dart';
import 'ui/daily_cards.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "A mai napra",
      theme: ThemeData(accentColor: Colors.lightGreenAccent),
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightGreen,
            title: Text('A mai napra'),
          ),
          body: DailyCards()),
    );
  }
}
