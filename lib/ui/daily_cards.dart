import 'package:flutter/material.dart';
import 'package:szeretet_foldje/blocs/daily_bloc.dart';
import 'package:szeretet_foldje/data/data_handler.dart';
import '../models/daily.dart';

import 'package:flutter_html/flutter_html.dart';

class DailyCards extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DailyCardsState();
  }
}

class DailyCardsState extends State<DailyCards> {
  List<Daily> dailies = List<Daily>();

  @override
  void initState() {
    dailyBloc.fetchDailies(0);
    _collectDailies();
    _updateOnStreamEvent();
    super.initState();
  }

  @override
  void dispose() {
    dailyBloc.dispose();
    super.dispose();
  }

  _collectDailies() async {
    var stored = await dataHandler.getStoredDailies();
    setState(() {
      dailies = stored;
      _dailySorter();
    });
  }

  _updateOnStreamEvent() {
    dailyBloc.getDailies.listen((onData) => {_collectDailies()});
  }

  void _dailySorter() {
    dailies.sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: dailies.length,
      itemBuilder: (BuildContext context, int index) {
        return _cardBuilder(dailies[index]);
      },
    );
  }

  Widget _cardBuilder(Daily daily) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
          width: 200,
          height: 300,
          child: Column(
            children: <Widget>[
              Text(daily.title),
              Text('${daily.date.year}-${daily.date.month}-${daily.date.day}'),
              Html(data: daily.html)
            ],
          )),
    );
  }
}
