class JournalDatabaseTransfer {
  int id;
  String title;
  String body;
  int rating;
  DateTime date;

  JournalDatabaseTransfer(
      {this.id, this.title, this.body, this.rating, this.date});

  JournalDatabaseTransfer.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    body = map['body'];
    rating = map['rating'];
    date = DateTime.parse(map['date']);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'body': body,
      'rating': rating,
      'date': DateTime.now().toString(),
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
