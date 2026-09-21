// lib/main.dart

import 'package:flutter/material.dart';

import 'modul02/studi_kasus/ruang_praktikum.dart';

void main() => runApp(const RuangKitaApp());

/// Root aplikasi RuangKita.
///
/// StatefulWidget dipakai untuk menyimpan [ThemeMode] (Light/Dark).
/// Perubahan mode memicu rebuild `MaterialApp` sehingga `themeMode`
/// di `MaterialApp` ikut berubah, dan seluruh subtree (termasuk halaman
/// studi kasus) di-rebuild dengan ColorScheme baru.
class RuangKitaApp extends StatefulWidget {
  const RuangKitaApp({super.key});

  @override
  State<RuangKitaApp> createState() => _RuangKitaAppState();
}

class _RuangKitaAppState extends State<RuangKitaApp> {
  /// Mode tema aktif. Mulai dari Light agar screenshot default
  /// konsisten; user dapat mengubah lewat tombol di AppBar.
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
    // Seed color terpusat. Nilai ini menjadi dasar seluruh palette
    // Material 3 (primary, secondary, surface, onSurface, dst).
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
      theme: ThemeData(useMaterial3: true, colorScheme: lightScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkScheme),
      home: RuangPraktikumScreen(
        themeMode: _themeMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}
