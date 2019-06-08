import 'package:rxdart/rxdart.dart';
import '../models/daily.dart';

class DailyBloc {
  final _dailyFetcer = PublishSubject<Daily>();

  Observable<Daily> get getDailies => _dailyFetcer.stream;

  Daily streamDaily(Daily daily) {
    _dailyFetcer.sink.add(daily);
    return daily;
  }

  dispose() {
    _dailyFetcer.close();
  }
}

final dailyBloc = DailyBloc();
