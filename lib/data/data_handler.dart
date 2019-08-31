import 'package:szeretet_foldje/blocs/daily_bloc.dart';
import 'package:szeretet_foldje/data/database_helper.dart';
import 'package:szeretet_foldje/data/scraper.dart';
import 'package:szeretet_foldje/models/daily.dart';

class DataHandler {
  final _scraper = Scraper();
  int _scraperPage = 0;

  Daily putDataToDb(Daily daily) {
    dbHelper.insertOrUpdate(daily.asMap());
    return daily;
  }

  Future<List<Daily>> getStoredDailies(DateTime lastDisplayedDate) async {
    //dbHelper.deleteAll();
    dbHelper.deleteDatabase();
    var listOfMaps = await dbHelper.query10Rows(lastDisplayedDate);
    listOfMaps.map((data) => _streamDailyFromMap(data));
  }

  Future<void> getNewDailies(int page) async {
    List<String> links = await _scraper.getLinks(page);
    if (!(links == null)) {
      for (String link in links) {
        _scraper
            .getDaily(link)
            .then((onValue) => dataHandler.putDataToDb(onValue))
            .then((onValue) => dailyBloc.streamDaily(onValue));
      }
    }
  }

  void _streamDailyFromMap(Map<String, dynamic> map) {
    dailyBloc.streamDaily(Daily.fromMap(map));
  }

  Future<List<Daily>> loadDailies(DateTime lastDisplayedDate) async {
    if (lastDisplayedDate == null) {
      return null; // getNewDailies(_scraperPage);
    } else {
      DateTime prewDay = lastDisplayedDate.add(Duration(days: -1));
      List<Map<String, dynamic>> next = await dbHelper.queryByDate(prewDay);
      if (next.isNotEmpty) {
        return await getStoredDailies(lastDisplayedDate);
      } else {
        _scraperPage += 11;
        return null; // getNewDailies(_scraperPage);
      }
    }
  }
}

final dataHandler = DataHandler();
