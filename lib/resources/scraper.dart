import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import '../models/daily.dart';

class Scraper {
  Future<List<Daily>> getInfo(int start) async {
    List<String> links = await getLinks(start);
    return _getDailies(links);
  }

  String _subtractLink(String outerHtml) {
    List<String> split = outerHtml.split('"');
    return "http://szeretetfoldje.hu" + split[1];
  }

  Future<List<String>> getLinks(int start) async {
    Response response = await Client()
        .get('http://szeretetfoldje.hu/index.php/a-mai-napra?start=${start}');
    if (response.statusCode == 200) {
      var document = parse(response.body);
      List<Element> elements = document.querySelectorAll('.item-page-title a');
      List<String> dailies = List();
      for (Element element in elements) {
        dailies.add(_subtractLink(element.outerHtml));
      }
      return dailies;
    } else {
      throw Exception('Failed to load post');
      //TODO: Implement response!
    }
  }

  Future<List<Daily>> _getDailies(List<String> links) async {
    List<Daily> dailies = [];
    for (String link in links) {
      dailies.add(await _extractDaily(link));
    }
    return dailies;
  }

  Future<Daily> getDaily(String link) async {
    return _extractDaily(link);
  }

//TODO: Add HTML TAG REMOVER!
  Future<Daily> _extractDaily(String link) async {
    Response response = await Client().get(link);
    if (response.statusCode == 200) {
      var document = parse(response.body);
      String title = document.querySelector('.item-page-title a').innerHtml;
      String date =
          document.querySelector('.published').text.trim().substring(10);
      String quote = document.querySelector("p > strong").text;
      String htmlString = document.querySelector("#comp-wrap p").outerHtml;
      String verse = "";
      try {
        verse = htmlString.substring(
            htmlString.indexOf("</strong>") + 10, htmlString.indexOf("<br>"));
      } catch (e) {}
      String toughts = "";
      try {
        toughts = htmlString.substring(
            htmlString.indexOf("<br>") + 4, htmlString.lastIndexOf("<br>"));
      } catch (e) {}
      String prayer = "";
      try {
        prayer = htmlString.substring(htmlString.lastIndexOf("<strong>") + 8,
            htmlString.indexOf("Ámen") + 5);
      } catch (e) {}
      return Daily(title, date, quote, verse, toughts, prayer);
    } else {
      throw Exception('Failed to load post');
      //TODO implement no response
    }
  }
}
