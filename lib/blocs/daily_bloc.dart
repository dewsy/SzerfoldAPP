import 'package:rxdart/rxdart.dart';
import '../models/daily.dart';
import '../resources/scraper.dart';

class DailyBloc {
  final _scraper = Scraper();
  final _dailyFetcer = PublishSubject<Daily>();

  Observable<Daily> get getDailies => _dailyFetcer.stream;

  collectDailies(int start) async {
    List<String> links = await _scraper.getLinks(start);
    for (String link in links) {
      _dailyFetcer.sink.add(await _scraper.getDaily(link));
    }
  }

  dispose() {
    _dailyFetcer.close();
  }
}

final bloc = DailyBloc();
