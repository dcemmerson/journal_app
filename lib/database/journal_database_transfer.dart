class JournalDatabaseTransfer {
  int id;
  String title;
  String body;
  double rating;
  DateTime date;
  int sort;

  JournalDatabaseTransfer(
      {this.id, this.title, this.body, this.rating, this.date, this.sort});

  JournalDatabaseTransfer.sort({this.sort});

  JournalDatabaseTransfer.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    body = map['body'];
    rating = map['rating'].toDouble();
    date = DateTime.parse(map['date']);
    sort = map['sort'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'body': body,
      'rating': rating.toDouble(),
      'date': DateTime.now().toString(),
      'sort': sort,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
