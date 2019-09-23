import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import '../models/daily.dart';
import 'dart:io';

class Scraper {
  String SEPARATOR = '---';
  String _subtractLink(String outerHtml) {
    List<String> split = outerHtml.split('"');
    return "http://szeretetfoldje.hu" + split[1];
  }

  Future<List<String>> getLinks(int start) async {
    if (await _isNetAvailable()) {
      Response response = await Client()
          .get('http://szeretetfoldje.hu/index.php/a-mai-napra?start=${start}');
      if (response.statusCode == 200) {
        var document = parse(response.body);
        List<Element> elements =
            document.querySelectorAll('.item-page-title a');
        List<String> dailies = List();
        for (Element element in elements) {
          dailies.add(element.outerHtml);
        }
        return dailies;
      } else {
        throw Exception('Failed to load post');
        //TODO: Implement response!
      }
    }
    return null;
  }

  Future<Daily> getDaily(String link) async {
    return await _extractDaily(_subtractLink(link));
  }

  Future<bool> _isNetAvailable() async {
    try {
      final result = await InternetAddress.lookup('szeretetfoldje.hu');
      return (result.isNotEmpty && result[0].rawAddress.isNotEmpty);
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<Daily> _extractDaily(String link) async {
    try {
      Response response = await Client().get(link);
      if (response.statusCode == 200) {
        var document = parse(response.body);
        String title = document.querySelector('.item-page-title a').innerHtml;
        DateTime date = _convertToDate(
            document.querySelector('.published').text.trim().substring(11));
        String htmlString = document
            .querySelector("#comp-wrap p")
            .outerHtml
            .split(SEPARATOR)[0];
        return Daily(title, date, htmlString, link);
      } else {
        throw Exception('Failed to load post');
        //TODO implement no response
      }
    } catch (e) {}
  }

  DateTime _convertToDate(String dateString) {
    int year = int.parse(dateString.substring(0, 4));
    int month = _getMonth(dateString);
    int day = int.parse(dateString.substring(
        dateString.lastIndexOf(".") - 2, dateString.lastIndexOf(".")));
    return DateTime(year, month, day);
  }

  int _getMonth(String dateString) {
    if (dateString.contains("január")) {
      return 1;
    } else if (dateString.contains("február")) {
      return 2;
    } else if (dateString.contains("március")) {
      return 3;
    } else if (dateString.contains("április")) {
      return 4;
    } else if (dateString.contains("május")) {
      return 5;
    } else if (dateString.contains("június")) {
      return 6;
    } else if (dateString.contains("július")) {
      return 7;
    } else if (dateString.contains("augusztus")) {
      return 8;
    } else if (dateString.contains("szeptember")) {
      return 9;
    } else if (dateString.contains("október")) {
      return 10;
    } else if (dateString.contains("november")) {
      return 11;
    } else if (dateString.contains("december")) {
      return 12;
    }
    return 0;
  }
}
