class Daily {
  String title;
  DateTime date;
  String html;

  Daily(this.title, this.date, this.html);

  Map<String, dynamic> asMap() {
    return {
      "title": this.title,
      "date": this.date.millisecondsSinceEpoch,
      "html": this.html
    };
  }

  Daily.fromMap(Map<String, dynamic> map) {
    this.date = DateTime.fromMillisecondsSinceEpoch(map["date"]);
    this.html = map["html"];
    this.title = map["title"];
  }
}
