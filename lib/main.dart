import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thespy/Components/TitleButton.dart';
import 'package:thespy/Pages/GamePage.dart';
import 'package:thespy/Pages/SettingsPage.dart';

void main() { runApp(const MyApp()); }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "The Spy!",
      home: const TitlePage(), 
      theme: ThemeData(
        primaryColor: Colors.black54,
        focusColor: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.blueGrey,
        brightness: Brightness.light,
        fontFamily: GoogleFonts.permanentMarker().fontFamily,
        textTheme: const TextTheme(
          titleMedium: TextStyle(color: Colors.black),
          titleLarge: TextStyle(color: Colors.black),
        )
      ),
    );
  }
}

class TitlePage extends StatelessWidget {
  const TitlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              child: Image.asset("assets/logo.png"),
              padding: const EdgeInsets.all(8),
            ), 
            const Padding(child: Divider(), padding: EdgeInsets.all(32),),
            const TitleButton(text: "Start Game!", page: GamePage()),
            const TitleButton(text: "Settings", page: SettingsPage()),
          ],
        ),
      ),
    );
  }
}
