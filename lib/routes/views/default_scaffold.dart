import 'package:flutter/material.dart';
import 'package:journal/theme/theme_controller.dart';
import 'package:journal/theme/theme_drawer.dart';
import 'package:journal/theme/theme_drawer_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool darkMode = false;

class DefaultScaffold extends StatefulWidget {
  final String title;
  final Widget child;

  DefaultScaffold({@required this.title, @required this.child});

  @override
  _DefaultScaffoldState createState() => _DefaultScaffoldState();
}

class _DefaultScaffoldState extends State<DefaultScaffold> {
  ThemeController themeController;

  void initState() {
    super.initState();
    themeController = ThemeController(darkMode: darkMode);
  }

  // void persistThemeFlavor() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   this.darkMode = prefs.getBool(darkMode) ?? false;
  // }

  // bool getThemeFlavor() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.getBool('darkMode') ==  ? true : false;
  //   return true;
  // }

  void toggleDarkMode() => setState(() {
        themeController = ThemeController(darkMode: !themeController.darkMode);
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

          // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}
