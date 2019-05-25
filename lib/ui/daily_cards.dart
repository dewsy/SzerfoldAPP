import 'package:flutter/material.dart';
import 'package:szeretet_foldje/blocs/daily_bloc.dart';
import 'package:szeretet_foldje/data/data_handler.dart';
import '../models/daily.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return Column(children: <Widget>[
      Center(
          child: Container(
        margin: EdgeInsets.only(top: 30),
        height: MediaQuery.of(context).size.height * 0.7,
        child: PageView.builder(
          scrollDirection: Axis.horizontal,
          controller: PageController(viewportFraction: 0.9, initialPage: 0),
          itemCount: dailies.length,
          itemBuilder: (BuildContext context, int index) {
            return _cardBuilder(dailies[index]);
          },
        ),
      )),
      Expanded(
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: GestureDetector(
                      onTap: _launchURL,
                      child: Text("Látogass el honlapunkra!")))))
    ]);
  }

  Widget _cardBuilder(Daily daily) {
    return Container(
        child: Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Container(
                  padding: EdgeInsets.only(top: 4),
                  child: Column(
                    children: <Widget>[
                      Text(daily.title,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 2)),
                      Text(
                          '${daily.date.year}-${daily.date.month}-${daily.date.day}'),
                      Expanded(
                          child: SingleChildScrollView(
                              child: Html(
                        data: daily.html,
                        defaultTextStyle: TextStyle(
                          fontSize: 17,
                        ),
                        padding: EdgeInsets.all(20),
                      )))
                    ],
                  )),
            )));
  }

  _launchURL() async {
    const url = 'http://szeretetfoldje.hu';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
