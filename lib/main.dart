import 'package:flutter/material.dart';

import 'modul02/studi_kasus/ruang_praktikum.dart';

void main() => runApp(const RuangKitaApp());

class RuangKitaApp extends StatefulWidget {
  const RuangKitaApp({super.key});

  @override
  State<RuangKitaApp> createState() => _RuangKitaAppState();
}

class _RuangKitaAppState extends State<RuangKitaApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color seedColor = Colors.indigo;

    final ColorScheme lightScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );
    final ColorScheme darkScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );

        return MaterialApp(
      title: 'RuangKita',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightScheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkScheme,
      ),
      home: RuangPraktikumScreen(
        themeMode: _themeMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}
