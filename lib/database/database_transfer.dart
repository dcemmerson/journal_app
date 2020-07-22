class DatabaseTransfer {
  final int id;
  final String title;
  final String body;
  final int rating;
  final DateTime date;

  const DatabaseTransfer(
      {this.id, this.title, this.body, this.rating, this.date});
}
