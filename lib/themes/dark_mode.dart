import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: const ColorScheme.dark(
    // very dark - app bar + drawer color
    surface: Colors.black,
    // slightly light
    primary: Colors.white,
    // dark
    secondary: Colors.black,
    // slightly dark
    tertiary: Colors.black,
    // very light
    shadow: Color.fromARGB(21, 158, 158, 158),
    inversePrimary: Colors.white,
  ), // ColorScheme.dark
  // ThemeData
  scaffoldBackgroundColor: Colors.black,
);
