import 'package:flutter/material.dart';
import 'package:journal/blocs/journal_bloc.dart';
import 'package:journal/blocs/journal_state.dart';
import 'package:journal/routes/routes.dart';
import 'package:journal/services/journal_service.dart';
import 'package:journal/views/screens/journal.dart';

import 'database/journal_database_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JournalDatabaseController.init();
  var journalService =
      JournalDatabaseService(JournalDatabaseController.getInstance());
  var blocProvider = BlocProvider(journalBloc: JournalBloc(journalService));
  runApp(JournalStateContainer(blocProvider: blocProvider, child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
//      home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: Routes.routes,
      initialRoute: Journal.route,
    );
  }
}
