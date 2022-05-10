import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(),
    fontFamily: 'Roboto',
    primarySwatch: Colors.green,
    primaryColor: Colors.green,
    hintColor: Colors.white,
    dividerColor: Colors.grey,
  );
}
