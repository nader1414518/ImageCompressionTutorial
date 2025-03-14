import 'package:flutter/material.dart';
import 'package:image_compression/screens/home_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Compression Tutorial',
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}
