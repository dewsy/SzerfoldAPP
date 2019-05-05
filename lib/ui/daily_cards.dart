import 'package:flutter/material.dart';
import '../blocs/daily_bloc.dart';
import '../models/daily.dart';

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
                return Column(
                  children: <Widget>[
                    Text(dailies[index].title),
                    Divider(height: 2.0),
                    Text(dailies[index].date),
                    Divider(height: 2.0),
                    Text(dailies[index].quote),
                    Divider(height: 2.0),
                    Text(dailies[index].verse),
                    Divider(height: 2.0),
                    Text(dailies[index].toughts),
                    Divider(height: 2.0),
                    Text(dailies[index].prayer),
                    Divider(height: 6.0),
                  ],
                );
              },
            );
          } else {
            return Container();
          }
        });
  }
}
