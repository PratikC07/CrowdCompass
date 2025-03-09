import 'package:flutter/material.dart';

import 'package:test_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BLE Scanner',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: const HomeScreen(),
    );
  }
}
