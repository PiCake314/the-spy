import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thespy/Components/TitleButton.dart';
import 'package:thespy/Pages/GameSelectionPage.dart';
// import 'package:thespy/Pages/SettingsPage.dart';

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
      routes: {"/main_menu": (context) => const TitlePage()},
      theme: ThemeData(
        primaryColor: Colors.black54,
        focusColor: Colors.blueGrey,
        // scaffoldBackgroundColor: const Color.fromARGB(255, 153, 190, 208),
        // scaffoldBackgroundColor: const Color.fromARGB(255, 62, 97, 114),
        scaffoldBackgroundColor: const Color(0xFF53687e),
        brightness: Brightness.light,
        fontFamily: GoogleFonts.bebasNeue()
            .fontFamily, // GoogleFonts.permanentMarker().fontFamily
        textTheme: const TextTheme(
          titleMedium: TextStyle(color: Colors.black),
          titleLarge: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

class TitlePage extends StatefulWidget {
  const TitlePage({super.key});

  @override
  State<TitlePage> createState() => _TitlePageState();
}

class _TitlePageState extends State<TitlePage> {
  double scale = 10;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () => setState(() => scale = 1));

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      "The Spy",
                      style: TextStyle(
                        fontSize: 86,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: AnimatedOpacity(
                      opacity: scale == 1 ? 1 : 0,
                      duration: const Duration(milliseconds: 100),
                      child: AnimatedScale(
                        scale: scale,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.bounceOut,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Image.asset(
                            "assets/top_secret.png",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Container(
              width: 300,
              child: Image.asset("assets/main_menu.png"),
              padding: const EdgeInsets.all(8),
            ),
            const Padding(
              child: Divider(),
              padding: EdgeInsets.all(32),
            ),
            const TitleButton(text: "Start Game!", page: GameSelectionPage()),
            // const TitleButton(text: "Settings", page: SettingsPage()),
          ],
        ),
      ),
    );
  }
}
