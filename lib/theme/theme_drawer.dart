/// filename: theme_drawer.dart
/// last modified: 08/03/2020
/// description: Stateless widget to add drawer to journal app which allows
///   user to switch between dark and light mode. The current theme should
///   be passed into constructor as ThemeController instance with method
///   to toggle theme.

import 'package:flutter/material.dart';
import 'package:journal/theme/theme_controller.dart';

class ThemeDrawer extends StatelessWidget {
  final Key drawerKey = GlobalKey();
  final Function toggleDarkMode;
  final ThemeController themeController;

  ThemeDrawer({this.themeController, @required this.toggleDarkMode});

  DrawerHeader drawerHeader(BuildContext context) {
    return DrawerHeader(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: Text('Theme settings',
            style: TextStyle(
                fontSize: 24, color: Theme.of(context).primaryColorLight)));
  }

  Widget createThemeSwitch() {
    return Row(children: [
      Text('Dark Mode ', style: TextStyle(fontSize: 24)),
      Switch(
          value: themeController.darkMode,
          onChanged: (value) => toggleDarkMode())
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        key: drawerKey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            drawerHeader(context),
            createThemeSwitch(),
          ],
        ));
  }
}
