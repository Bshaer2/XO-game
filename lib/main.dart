import 'package:flutter/material.dart';
import 'package:xo_game/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF00061a),
        primarySwatch: Colors.blue,
        shadowColor:const Color(0xFF001456) ,
        splashColor: const Color (0xFF4169e8),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
