import 'package:flutter/material.dart';
import 'package:journal/theme/theme_controller.dart';
import 'package:journal/theme/theme_drawer.dart';
import 'package:journal/theme/theme_drawer_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    themeController = ThemeController(darkMode: false);
    initThemeFlavor();
  }

  void persistThemeFlavor(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', isDarkMode);
  }

  void initThemeFlavor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = false;
    if (prefs.getBool('darkMode') != null)
      isDarkMode = prefs.getBool('darkMode');
    setState(() => themeController = ThemeController(darkMode: isDarkMode));
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
