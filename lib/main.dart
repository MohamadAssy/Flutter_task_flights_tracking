import 'package:flutter/material.dart';
import 'welcome_page.dart';

void main() {
  runApp(FlightApp());
}

class FlightApp extends StatelessWidget {
  const FlightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomePage(),
    );
  }
}
