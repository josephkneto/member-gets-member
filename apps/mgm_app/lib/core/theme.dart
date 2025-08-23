import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    appBarTheme: const AppBarTheme(centerTitle: true),
    cardTheme: const CardThemeData(margin: EdgeInsets.all(8)),
  );
}
