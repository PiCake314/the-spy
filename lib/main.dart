import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thespy/Components/TitleButton.dart';
import 'package:thespy/Pages/GameOptionsPage.dart';
import 'package:thespy/Pages/SettingsPage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "The Spy!",
      initialRoute: "/main_menu",
      // home: const TitlePage(),
      routes: { "/main_menu": (context) => const TitlePage() },
      theme: ThemeData(
        primaryColor: Colors.black54,
        focusColor: Colors.blueGrey,
        scaffoldBackgroundColor: const Color.fromARGB(255, 153, 190, 208),
        brightness: Brightness.light,
        fontFamily: GoogleFonts.bebasNeue().fontFamily, // GoogleFonts.permanentMarker().fontFamily
        textTheme: const TextTheme(
          titleMedium: TextStyle(color: Colors.black),
          titleLarge: TextStyle(color: Colors.black),
        ),
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
              child: Image.asset("assets/main_menu.png"),
              padding: const EdgeInsets.all(8),
            ),
            const Padding(
              child: Divider(),
              padding: EdgeInsets.all(32),
            ),
            const TitleButton(text: "Start Game!", page: GameOptionsPage()),
            const TitleButton(text: "Settings", page: SettingsPage()),
          ],
        ),
      ),
    );
  }
}
