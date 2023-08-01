// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:quran_application/screens/home_screen.dart';
import 'package:quran_application/screens/splash_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Quran App',
    theme: ThemeData(),
    routes: {
      '/': (context) => const SplashScreen(),
      '/home': (context) => const MyHomePage(
            title: 'Quran',
          ),
    },
  ));
}
