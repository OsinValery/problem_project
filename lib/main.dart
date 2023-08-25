import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:problem_project/ui/root/root_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: const RootView(),
    theme: ThemeData(
      primaryColor: Colors.brown,
      scaffoldBackgroundColor: Colors.brown.withAlpha(100),
      elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.brown),
        ),
      ),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.brown),
    ),
  ));
}
