import 'package:flutter/material.dart';
import 'package:szeretet_foldje/data/database_helper.dart';
import 'ui/daily_cards.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Napi gondolatok",
      home: Scaffold(
          appBar: AppBar(
            title: Text('A mai napra'),
            actions: <Widget>[
              GestureDetector(
                  onTap: () => dbHelper.deleteAll(),
                  child: Icon(
                    Icons.backspace,
                  )),
            ],
          ),
          body: DailyCards()),
    );
  }
}
