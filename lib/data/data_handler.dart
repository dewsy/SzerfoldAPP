import 'package:szeretet_foldje/blocs/daily_bloc.dart';
import 'package:szeretet_foldje/data/database_helper.dart';
import 'package:szeretet_foldje/data/scraper.dart';
import 'package:szeretet_foldje/models/daily.dart';

class DataHandler {
  final _scraper = Scraper();

  Daily putDataToDb(Daily daily) {
    dbHelper.insertOrUpdate(daily.asMap());
    return daily;
  }

  Future<List<Daily>> getStoredDailies() async {
    //dbHelper.deleteAll();
    var listOfMaps = await dbHelper.queryAllRows();
    return listOfMaps.map((data) => _createDailyFromMap(data)).toList();
  }

  Future<List<Daily>> getNewDailies(int start) async {
    List<Daily> returnList = List();
    List<String> links = await _scraper.getLinks(start);
    if (!(links == null)) {
      for (String link in links) {
        await _scraper
            .getDaily(link)
            .then((onValue) => dataHandler.putDataToDb(onValue))
            .then((onValue) => {
                  print("NEWDAILY: " + onValue.title),
                  dailyBloc.streamDaily(onValue)
                });
      }
    }
    return returnList;
  }

  Daily _createDailyFromMap(Map<String, dynamic> map) {
    return Daily.fromMap(map);
  }

}

final dataHandler = DataHandler();
