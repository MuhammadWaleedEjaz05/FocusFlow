import 'package:flutter/material.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';

final ThemeData lightPurpleTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.deepPurple,
  primaryColorLight: Colors.purple,
  shadowColor: Colors.blueGrey.shade100,
  hintColor: Colors.black,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.light,
    primary: Colors.deepPurple,
  ),
  extensions: [AppColorsLight.purple],
);

final ThemeData lightBlueTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.blue,
  primaryColorLight: Colors.lightBlue,
  shadowColor: Colors.blueGrey.shade100,
  hintColor: Colors.black,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
    primary: Colors.blue,
  ),
  extensions: [AppColorsLight.blue],
);

final ThemeData lightGreenTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.green,
  primaryColorLight: Colors.lightGreen,
  shadowColor: Colors.blueGrey.shade100,
  hintColor: Colors.black,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.light,
    primary: Colors.green,
  ),
  extensions: [AppColorsLight.green],
);

final ThemeData lightOrangeTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.orange,
  primaryColorLight: Colors.deepOrange,
  shadowColor: Colors.blueGrey.shade100,
  hintColor: Colors.black,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.orange,
    brightness: Brightness.light,
    primary: Colors.orange,
  ),
  extensions: [AppColorsLight.orange],
);
