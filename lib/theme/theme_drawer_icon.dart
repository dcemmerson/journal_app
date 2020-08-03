/// filename: theme_drawer_icon.dart
/// last modified: 08/03/2020
/// description: Used to implement gear style button to access
///   theme drawer in journal app.

import 'package:flutter/material.dart';

class ThemeDrawerIcon extends StatelessWidget {
  void showThemeDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
      child: Icon(Icons.settings),
      onTap: () => showThemeDrawer(context),
    ));
  }
}
