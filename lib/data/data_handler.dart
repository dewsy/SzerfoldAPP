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
    if (lastDisplayedDate != null) {
      var listOfMaps = await dbHelper.query11Rows(lastDisplayedDate);
      if (listOfMaps.isNotEmpty) {
        listOfMaps.forEach((data) => dailyBloc.streamDaily(Daily.fromMap(data)));
      } else {
        _scraperPage += 11;
        getNewDailies(_scraperPage);
      }
    } else {
      getNewDailies(0);
    }
  }
}

final dataHandler = DataHandler();
