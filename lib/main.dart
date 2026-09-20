import 'package:flutter/material.dart';

import 'modul02/studi_kasus/ruang_praktikum.dart';

void main() => runApp(const RuangKitaApp());

class RuangKitaApp extends StatelessWidget {
  const RuangKitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RuangKita',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const RuangPraktikumScreen(),
    );
  }
}