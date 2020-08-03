/// filename: default_scaffold.dart
/// last modified: 08/03/2020
/// description: Default scaffold used in journal app. Provides theme change
///   user interface, floating action button to add new entries, etc. Pass
///   in the title and child when using DefaultScaffold.

import 'package:flutter/material.dart';
import 'package:journal/theme/theme_controller.dart';
import 'package:journal/theme/theme_drawer.dart';
import 'package:journal/theme/theme_drawer_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool darkMode = false;

class DefaultScaffold extends StatefulWidget {
  final String title;
  final Widget child;
  final Widget floatingActionButton;

  DefaultScaffold(
      {@required this.title, @required this.child, this.floatingActionButton});

  @override
  _DefaultScaffoldState createState() => _DefaultScaffoldState();
}

class _DefaultScaffoldState extends State<DefaultScaffold> {
  ThemeController themeController;
  void initState() {
    super.initState();

    //Initialize darkMode to false, since SharedPreferences is async,
    // to prevent the build method from accessing themeController before
    // SharedPreferences.getInstance() returns with previous settings.
    themeController = ThemeController(darkMode: false);
    initThemeFlavor();
  }

  void persistThemeFlavor(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', isDarkMode);
  }

  void initThemeFlavor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var darkMode = prefs.getBool('darkMode');
      // Explicitly check truth value, to prevent comparison with null if this
      // is the first time user is loading app. Eg, darkMode could be null here.
      if (darkMode == true) {
        themeController = ThemeController(darkMode: darkMode);
      } else {
        themeController = ThemeController(darkMode: false);
      }
    });
  }

  void toggleDarkMode() => setState(() {
        themeController = ThemeController(darkMode: !themeController.darkMode);
        persistThemeFlavor(themeController.darkMode);
      });

  AppBar buildAppBar() {
    return AppBar(centerTitle: true, title: Text(widget.title), actions: [
      ThemeDrawerIcon(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: themeController.themeData,
        child: Scaffold(
            appBar: buildAppBar(),
            body: widget.child,
            endDrawer: ThemeDrawer(
              themeController: themeController,
              toggleDarkMode: toggleDarkMode,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: widget.floatingActionButton));
  }
}
