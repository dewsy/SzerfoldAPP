import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'daily.dart';

Future<List<String>> getInfo(int start) async {
  List<String> links = await getLinks(start);
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

}
