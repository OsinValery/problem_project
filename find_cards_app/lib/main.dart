import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ui/root/root_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
