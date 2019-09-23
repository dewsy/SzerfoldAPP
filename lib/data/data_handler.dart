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

  Future<void> getNewDailies(int page) async {
    List<String> links = await _scraper.getLinks(page);
    if (links != null) {
      for (String link in links) {
        _scraper
            .getDaily(link)
            .then((onValue) => dataHandler.putDataToDb(onValue))
            .then((onValue) => dailyBloc.streamDaily(onValue));
      }
    }
  }

  Future<void> loadDailies(DateTime lastDisplayedDate) async {
    //dbHelper.deleteDatabase();
    if (lastDisplayedDate != null) {
      var listOfMaps =
          await dbHelper.query11Rows(lastDisplayedDate.add(Duration(days: -1)));
      if (listOfMaps.isNotEmpty) {
        listOfMaps
            .forEach((data) => dailyBloc.streamDaily(Daily.fromMap(data)));
      } else {
        _scraperPage = _getPaginationNumber(lastDisplayedDate);
        getNewDailies(_scraperPage);
      }
    } else {
      getNewDailies(0);
    }
  }
}

int _getPaginationNumber(DateTime lastDisplayed) {
  return DateTime.now().difference(lastDisplayed).inDays;
}

final dataHandler = DataHandler();
