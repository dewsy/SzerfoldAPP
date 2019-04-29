import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'daily.dart';

Future<List<Daily>> getInfo(int start) async {
  List<String> links = await getLinks(start);
  return getDailies(links);
}

String subtractLink(String outerHtml) {
  List<String> split = outerHtml.split('"');
  return "http://szeretetfoldje.hu" + split[1];
}

Future<List<String>> getLinks(int start) async {
  Response response = await Client().get('http://szeretetfoldje.hu/index.php/a-mai-napra?start=${start}');
  var document = parse(response.body);
  List <Element> elements = document.querySelectorAll('.item-page-title a');
  List<String>  dailies = List();
  for (Element element in elements) {
    dailies.add(subtractLink(element.outerHtml));
  }
  return dailies;
}

Future<List<Daily>> getDailies(List<String> links) async {
  List<Daily> dailies = [];
  for (String link in links) {
    dailies.add(await extractDaily(link));
  }
  return dailies;
}

Future<Daily>extractDaily(String link) async {
  Response response = await Client().get(link);
  var document = parse(response.body);
  String title = document.querySelector('.item-page-title a').innerHtml;
  String date = document.querySelector('.published').text.trim();
  String quote = document.querySelector("p > strong").text;
  String htmlString = document.querySelector("#comp-wrap p").outerHtml;
  String verse = htmlString.substring(htmlString.indexOf("</strong>") + 10, htmlString.indexOf("<br>"));
  String toughts = htmlString.substring(htmlString.indexOf("<br>") + 4,htmlString.lastIndexOf("<br>"));
  String prayer = htmlString.substring(htmlString.lastIndexOf("<strong>") + 8, htmlString.lastIndexOf("Ámen.") + 5);
  return Daily(title, date, quote, verse, toughts, prayer);
}