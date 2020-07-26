class JournalDatabaseTransfer {
  int id;
  String title;
  String body;
  double rating;
  DateTime date;

  JournalDatabaseTransfer(
      {this.id, this.title, this.body, this.rating, this.date});

  JournalDatabaseTransfer.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    body = map['body'];
    rating = map['rating'].toDouble();
    date = DateTime.parse(map['date']);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'body': body,
      'rating': rating.toDouble(),
      'date': DateTime.now().toString(),
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
