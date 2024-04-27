import 'package:flutter/material.dart';
import 'calculator_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String title = 'Calculator';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        primaryColor: Colors.indigo, // Change the primary color to indigo
        hintColor:
            Colors.orangeAccent, // Change the accent color to orangeAccent
        scaffoldBackgroundColor:
            Colors.grey[200], // Set background color to light grey
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.black, // Set headline text color to black
            fontWeight: FontWeight.bold, // Set headline text weight to bold
            fontSize: 24, // Set headline font size to 24
          ),
        ),
      ),
      home: const CalculatorScreen(),
    );
  }
}
