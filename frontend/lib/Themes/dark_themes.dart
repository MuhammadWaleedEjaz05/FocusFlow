import 'package:flutter/material.dart';
import 'package:frontend/core/extensions/theme_extensions.dart';

final ThemeData darkPurpleTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.blueGrey.shade900,
  primaryColor: Colors.deepPurple,
  primaryColorLight: Colors.purple,
  shadowColor: Colors.blueGrey.shade700,
  hintColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.dark,
    primary: Colors.deepPurple,
    surface: Colors.blueGrey.shade900,
  ),
  extensions: [AppColorsDark.purple],
);

final ThemeData darkBlueTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.blueGrey.shade900,
  primaryColor: Colors.blue,
  primaryColorLight: Colors.lightBlue,
  shadowColor: Colors.blueGrey.shade700,
  hintColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
    primary: Colors.blue,
    surface: Colors.blueGrey.shade900,
  ),
  extensions: [AppColorsDark.blue],
);

final ThemeData darkGreenTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.blueGrey.shade900,
  primaryColor: Colors.green,
  primaryColorLight: Colors.lightGreen,
  shadowColor: Colors.blueGrey.shade700,
  hintColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.dark,
    primary: Colors.green,
    surface: Colors.blueGrey.shade900,
  ),
  extensions: [AppColorsDark.green],
);

final ThemeData darkOrangeTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.blueGrey.shade900,
  primaryColor: Colors.orange,
  primaryColorLight: Colors.deepOrange,
  shadowColor: Colors.blueGrey.shade700,
  hintColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.orange,
    brightness: Brightness.dark,
    primary: Colors.orange,
    surface: Colors.blueGrey.shade900,
  ),
  extensions: [AppColorsDark.orange],
);
