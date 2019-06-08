class Daily {
  String title;
  DateTime date;
  String html;

  Daily(this.title, this.date, this.html);

  Map<String, dynamic> asMap() {
    return {
      "title": this.title,
      "date": '${this.date.year}-${this.date.month}-${this.date.day}',
      "html": this.html
    };
  }

  Daily.fromMap(Map<String, dynamic> map) {
    String dateString = map["date"];
    if (dateString.length < 10) {
      dateString = (dateString.substring(0, 5) + "0" + dateString.substring(5));
    }
    if (dateString.length == 9) {
      dateString = (dateString.substring(0, 8) + "0" + dateString.substring(8));
    }
    this.date = DateTime.parse(dateString);
    this.html = map["html"];
    this.title = map["title"];
  }
}
