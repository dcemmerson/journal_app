import 'package:journal/views/home.dart';
import 'package:journal/views/journal/journal_entry_form.dart';
import 'package:journal/views/journal_entries.dart';

class Routes {
  static final routes = {
    Home.route: (context) => Home(),
    JournalEntries.route: (context) => JournalEntries(),
    JournalEntryForm.route: (context) => JournalEntryForm(),
  };
}
