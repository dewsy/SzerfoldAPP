import 'package:flutter/material.dart';
import 'package:szeretet_foldje/blocs/daily_bloc.dart';
import 'package:szeretet_foldje/data/data_handler.dart';
import '../models/daily.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:connectivity/connectivity.dart';

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
    _collectDailies();
    dataHandler.loadDailies(null);
    _updateOnStreamEvent();
    _pageController.addListener(() => {
          if (_pageController.position.pixels ==
              _pageController.position.maxScrollExtent)
            {_displayMoreDailies()}
        });
    _pageController.addListener(() => {
          if (_pageController.position.pixels ==
              _pageController.position.minScrollExtent)
            {dataHandler.loadDailies(null), _updateOnStreamEvent()}
        });
    super.initState();
  }

  _displayMoreDailies() async {
    int originalLength = dailies.length;
    List<Daily> newDailies = await dataHandler.loadDailies(dailies.last.date);
    if (newDailies != null) {
      for (Daily daily in newDailies) {
        dailies.retainWhere((d) => d.date != daily.date);
        dailies.add(daily);
      }
      _dailySorter();
      if (originalLength >= dailies.length) {
        _displayMoreDailies();
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    dailyBloc.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _collectDailies() async {
    var stored = await dataHandler.getStoredDailies(DateTime.now());
    setState(() {
      for (Daily daily in stored) {
        dailies.retainWhere((d) => d.date != daily.date);
        dailies.add(daily);
      }
      _dailySorter();
    });
  }

  void _updateOnStreamEvent() {
    dailyBloc.getDailies.listen((onData) => {_collectDailies()});
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
                    child: Text("szeretetföldje.hu"),
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
          scrollDirection: Axis.horizontal,
          controller: _pageController,
          itemCount: dailies.length,
          itemBuilder: (BuildContext context, int index) {
            return _cardBuilder(dailies[index]);
          },
        ),
      );
    } else {
      return _isThereInternet();
    }
  }

  Widget _isThereInternet() {
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder:
          (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
        switch (snapshot.data) {
          case ConnectivityResult.wifi:
          case ConnectivityResult.mobile:
            dataHandler.loadDailies(null);
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
