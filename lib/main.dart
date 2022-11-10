import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:notion_test/screens/budget.dart';
import 'package:notion_test/screens/home.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bestway Marketing',
      debugShowCheckedModeBanner: false,
      home: const Home(),
      // home: const Budget(),
      theme: ThemeData(
        backgroundColor: const Color(0xFF282828),
      ),
    );
  }
}