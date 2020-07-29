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
        print('setting state ' + index.toString());
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
