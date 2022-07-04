import 'package:flutter/material.dart';

import 'home.dart';

class LyricsApp extends StatelessWidget {
  const LyricsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lyrics App',
      initialRoute : '/home',
      routes:{
        '/home' : (BuildContext context) => const HomePage(),

      },
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
      ),
      );
  }
}