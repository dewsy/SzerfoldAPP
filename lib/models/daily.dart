class Daily {
  String title;
  DateTime date;
  String html;
  String url;

  Daily(this.title, this.date, this.html, this.url);

  Map<String, dynamic> asMap() {
    return {
      "title": this.title,
      "date": this.date.millisecondsSinceEpoch,
      "html": this.html,
      "url": this.url
    };
  }

  Daily.fromMap(Map<String, dynamic> map) {
    this.date = DateTime.fromMillisecondsSinceEpoch(map["date"]);
    this.html = map["html"];
    this.title = map["title"];
    this.url = map["url"];
  }
}
