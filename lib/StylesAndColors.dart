import 'package:flutter/material.dart';

final branchList = <String>[
  'CSE',
  'ECE',
  'EEE',
  'Mech',
  'Civil',
  'Chemical',
  'Bio-Tech',
  'Metullurgy',
];

final appLightThemeData = ThemeData(
  fontFamily: 'Cabin',
  primaryColor: Colors.blue,
  accentColor: Colors.amberAccent,
);

final appDarkThemeData = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Cabin',
);

const TextStyle titleStyle = TextStyle(fontSize: 22.0);

const TextStyle textStyle = TextStyle(fontSize: 15.0);

const TextStyle darkText =
TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold);

const TextStyle primaryText = TextStyle(fontSize: 14.0);

const TextStyle lightText = TextStyle(fontSize: 12.0);

class AppColors {
  // Drawer colors
  Color get activity => Colors.purple;

  Color get profile => Colors.indigo;

  Color get todoList => Colors.green;

  Color get clubs => Colors.red;

  Color get savedImages => Colors.teal;

  Color get settings => Colors.brown;

  Color get logout => Colors.red;

  Color get about => Colors.pink;

  Color get developer => Colors.indigo;

  // other colors
  Color get refreshColor => Colors.red;
}

final appColors = AppColors();

Widget appMenuButton(VoidCallback openDrawerFunction) {
  return IconButton(
    onPressed: openDrawerFunction,
    icon: Icon(Icons.menu),
    tooltip: 'Open Drawer Menu',
  );
}
