import 'package:szeretet_foldje/blocs/daily_bloc.dart';
import 'package:szeretet_foldje/data/database_helper.dart';
import 'package:szeretet_foldje/data/scraper.dart';
import 'package:szeretet_foldje/models/daily.dart';

class DataHandler {
  final _scraper = Scraper();
  int _queryOffset = 0;
  int _scraperPage = 0;

  Daily putDataToDb(Daily daily) {
    dbHelper.insertOrUpdate(daily.asMap());
    return daily;
  }

  Future<List<Daily>> getStoredDailies() async {
    //dbHelper.deleteAll();
    var listOfMaps = await dbHelper.query10Rows(_queryOffset);
    ++_queryOffset;
    return listOfMaps.map((data) => _createDailyFromMap(data)).toList();
  }

  Future<List<Daily>> getNewDailies(int page) async {
    List<Daily> returnList = List();
    List<String> links = await _scraper.getLinks(page);
    if (!(links == null)) {
      for (String link in links) {
        await _scraper
            .getDaily(link)
            .then((onValue) => dataHandler.putDataToDb(onValue))
            .then((onValue) => {dailyBloc.streamDaily(onValue)})
            .then((onValue) => returnList.addAll(onValue));
      }
    }
    return returnList;
  }

  Daily _createDailyFromMap(Map<String, dynamic> map) {
    return Daily.fromMap(map);
  }

  Future<List<Daily>> loadDailies(DateTime lastDisplayedDate) async {
    if (lastDisplayedDate == null) {
      return getNewDailies(_scraperPage);
    } else {
      DateTime prewDay = lastDisplayedDate.add(Duration(days: -1));
      List<Map<String, dynamic>> next = await dbHelper.queryByDate(prewDay);
      if (next.isNotEmpty) {
        return await getStoredDailies();
      } else {
        _scraperPage += 11;
        return getNewDailies(_scraperPage);
      }
    }
  }
}

final dataHandler = DataHandler();
