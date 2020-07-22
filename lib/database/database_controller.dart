import 'package:journal/io/json_reader.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseController {
  final filename;

  List<Map<String, String>> dbQueries;
  Database db;

  DatabaseController({this.filename: 'journal.sqlite3.db'});

  void readInJsonDbQueries() async {
    this.dbQueries =
        await JsonReader.read('assets/database/database_queries.json');

    print(dbQueries);
  }

  Future<void> openDb() async {
    db = await openDatabase(filename);
  }

  Future<void> closeDb() async {
    await db.close();
  }

  Future<List<Map>> getAllJournalEntries() {}
}
