import 'package:flutter/material.dart';
import 'package:szeretet_foldje/blocs/daily_bloc.dart';
import 'package:szeretet_foldje/data/data_handler.dart';
import '../models/daily.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DailyCards extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DailyCardsState();
  }
}

class DailyCardsState extends State<DailyCards> {
  PageController _pageController =
      PageController(viewportFraction: 0.9, initialPage: 0);
  List<Daily> dailies = List<Daily>();

  @override
  void initState() {
    dataHandler.getNewDailies(0);
    _updateOnStreamEvent();
    dataHandler.loadDailies(DateTime.now());
    _pageController.addListener(() => {
          if (_pageController.position.pixels ==
              _pageController.position.maxScrollExtent)
            {_displayMoreDailies()}
        });
    _pageController.addListener(() => {
          if (_pageController.position.pixels ==
              _pageController.position.minScrollExtent)
            {dataHandler.loadDailies(null)}
        });
    super.initState();
  }

  _displayMoreDailies() async {
    dataHandler.loadDailies(dailies.last.date);
    Fluttertoast.showToast(
      msg: "Újabb üzenetek betöltése",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _addOrUpdateDaily(Daily onData) {
    setState(() {
      Daily pair;
      try {
        pair = dailies.firstWhere((daily) => daily.date == onData.date);
      } catch (error) {
        pair = null;
      }
      if (pair != null) {
        dailies[dailies.indexOf(pair)] = onData;
      } else {
        dailies.add(onData);
      }
      _dailySorter();
    });
  }

  void _dailySorter() {
    dailies.sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Center(child: _homeScreenSelector()),
      Expanded(
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: <Widget>[
                  Text("Látogass el naponta frissülő honlapunkra:"),
                  Container(
                      child: RaisedButton(
                    onPressed: _launchURL,
                    textColor: Colors.white,
                    color: Colors.lightGreen,
                    elevation: 4,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    child: Text("szeretetfoldje.hu"),
                  ))
                ],
              )))
    ]);
  }

  Widget _cardBuilder(Daily daily) {
    return Container(
        child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Container(
                  padding: EdgeInsets.only(top: 3),
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: Text(daily.title,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))),
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

  Widget _homeScreenSelector() {
    if (dailies.length > 0) {
      return Container(
        margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
        height: MediaQuery.of(context).size.height * 0.7,
        child: PageView.builder(
          itemCount: dailies.length,
          scrollDirection: Axis.horizontal,
          controller: _pageController,
          itemBuilder: (BuildContext context, int index) {
            return _cardBuilder(dailies[index]);
          },
        ),
      );
    } else {
      return _isThereInternet();
    }
  }

  void _updateOnStreamEvent() {
    dailyBloc.getDailies.listen((onData) => _addOrUpdateDaily(onData));
  }

  Widget _isThereInternet() {
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder:
          (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
        switch (snapshot.data) {
          case ConnectivityResult.wifi:
          case ConnectivityResult.mobile:
            return Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                  child: CircularProgressIndicator(),
                ));
            break;
          default:
            return Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(child: Text("Kérlek kapcsolj internetet!")));
        }
      },
    );
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
