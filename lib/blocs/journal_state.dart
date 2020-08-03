/// filename: journal_state.dart
/// last modified: 08/03/2020
/// description: Journal state management. We use an inherited wigdget
///   with a stateful widget to manage the state of the journal mobile app.

import 'package:flutter/material.dart';
import 'package:journal/blocs/journal_bloc.dart';
import 'package:journal/services/journal_service.dart';

class JournalStateContainer extends StatefulWidget {
  final Widget child;
  final BlocProvider blocProvider;

  const JournalStateContainer({
    Key key,
    @required this.child,
    @required this.blocProvider,
  });
  @override
  JournalState createState() => JournalState();

  static JournalState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_JournalContainer)
            as _JournalContainer)
        .journalData;
  }
}

class JournalState extends State<JournalStateContainer> {
  BlocProvider get blocProvider => widget.blocProvider;
  int _selectedIndex = 0;

  get selectedIndex => _selectedIndex;

  set selectedIndex(int index) => setState(() {
        _selectedIndex = index;
      });

  @override
  Widget build(BuildContext context) {
    print('build');
    return _JournalContainer(
      journalData: this,
      blocProvider: widget.blocProvider,
      selectedIndex: _selectedIndex,
      child: widget.child,
    );
  }

  void dispose() {
    super.dispose();
  }
}

class _JournalContainer extends InheritedWidget {
  final JournalState journalData;
  final BlocProvider blocProvider;
  final int selectedIndex;

  _JournalContainer({
    Key key,
    @required this.journalData,
    @required child,
    @required this.blocProvider,
    @required this.selectedIndex,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_JournalContainer oldWidget) {
    return oldWidget.journalData != this.journalData ||
        oldWidget.selectedIndex != this.selectedIndex;
    ;
  }
}

class ServiceProvider {
  final JournalService journalService;

  ServiceProvider({
    @required this.journalService,
  });
}

class BlocProvider {
  JournalBloc journalBloc;

  BlocProvider({
    @required this.journalBloc,
  });
}
