import 'package:flutter/material.dart';
import '../blocs/daily_bloc.dart';
import '../models/daily.dart';

import 'package:flutter_html/flutter_html.dart';

class DailyCards extends StatelessWidget {
  final int pageNumber = 0;
  final List<Daily> dailies = List<Daily>();

  @override
  Widget build(BuildContext context) {
    bloc.collectDailies(pageNumber);
    return StreamBuilder(
        stream: bloc.getDailies,
        builder: (context, AsyncSnapshot<Daily> snapshot) {
          if (snapshot.hasData) {
            dailies.add(snapshot.data);
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: dailies.length,
              itemBuilder: (BuildContext context, int index) {
                return Html(
                  data: dailies[index].html
                );
              },
            );
          } else {
            return Container();
          }
        });
  }
}
