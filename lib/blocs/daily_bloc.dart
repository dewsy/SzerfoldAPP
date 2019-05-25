import 'package:rxdart/rxdart.dart';
import 'package:szeretet_foldje/data/data_handler.dart';
import '../models/daily.dart';

class DailyBloc {
  final _dailyFetcer = PublishSubject<Daily>();

  Observable<Daily> get getDailies => _dailyFetcer.stream;

  void fetchDailies(int start) async {
    await dataHandler.getNewDailies(start);
  }

  void streamDaily(Daily daily) {
    _dailyFetcer.sink.add(daily);
  }

  dispose() {
    _dailyFetcer.close();
  }
}

final dailyBloc = DailyBloc();
