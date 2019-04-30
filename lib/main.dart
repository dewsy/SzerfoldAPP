import 'package:flutter/material.dart';
import 'scraper.dart';
import 'daily.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getInfo(0),
      builder: (BuildContext context, AsyncSnapshot<List<Daily>> snapshot) {
        if (snapshot.hasData) {
        return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    Text(snapshot.data[index].title),
                    Divider(
                      height: 2.0),
                      Text(snapshot.data[index].date),
                    Divider(
                      height: 2.0),
                      Text(snapshot.data[index].quote),
                    Divider(
                      height: 2.0),
                      Text(snapshot.data[index].verse),
                    Divider(
                      height: 2.0),
                      Text(snapshot.data[index].toughts),
                    Divider(
                      height: 2.0),
                      Text(snapshot.data[index].prayer),
                    Divider(
                      height: 2.0),
                    Divider(
                      height: 2.0),
                    Divider(
                      height: 2.0),
                  ],
                );
              },
            )
        );
    
      } else {
      return Container();
      }
      },
    ); 
  }
}
