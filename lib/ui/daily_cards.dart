import 'package:flutter/material.dart';
import '../blocs/daily_bloc.dart';
import '../models/daily.dart';

import 'package:flutter_html/flutter_html.dart';

class DailyCards extends StatefulWidget {

@override
State<StatefulWidget> createState() {
return DailyCardsState();
}
}

class DailyCardsState extends State<DailyCards> {

  @override
  void initState() { 
    super.initState();
    bloc.collectDailies(pageNumber);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  final int pageNumber = 0;
  final List<Daily> dailies = List<Daily>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bloc.getDailies,
        builder: (context, AsyncSnapshot<Daily> snapshot) {
          if (snapshot.hasData) {
            dailies.add(snapshot.data);
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: dailies.length,
              itemBuilder: (BuildContext context, int index) {
                return _cardBuilder(dailies[index]);
              },
            );
          } else {
            return Container();
          }
        });
  }

  Widget _cardBuilder(Daily daily) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: 200,
          height: 300,
          child: Html(
            data: daily.html,
          ),
        ),
      );
  }
}
