import 'package:flutter/material.dart';
import 'package:weather_app/screens/weather_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weathercast',

      // to hide debug banner
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const WeatherScreen(),
    );
  }
}