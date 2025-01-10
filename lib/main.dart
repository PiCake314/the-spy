import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thespy/Pages/GameSelectionPage.dart';
// import 'package:thespy/Pages/GameSelectionPage.dart';
// import 'package:thespy/Pages/SettingsPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final data_string = prefs.getString("data");
  final data = data_string != null
    ? Map<String, dynamic>.from(jsonDecode(data_string))
    : <String, dynamic>{};

  debugPrint(data.toString());

  if(!data.containsKey("titles") || (data["titles"] as List).isEmpty) {
    // typically all these should be uppercase but it seems to be working fine so.. :)
    const titles = ["Animals", "Clothes", "Fruits"];
    const options = [
      ["Dog", "Cat", "Elephant", "Lion", "Tiger", "Bear", "Panda", "Penguin", "Kangaroo", "Koala"],
      ["Shirt", "Pants", "Dress", "Skirt", "Shoes", "Socks", "Hat", "Gloves", "Scarf", "Jacket"],
      ["Apple", "Banana", "Orange", "Grapes", "Strawberry", "Watermelon", "Pineapple", "Mango", "Peach", "Pear"],
    ];

    data["titles"] = titles;
    data["options"] = options;

    final value = jsonEncode(data);
    prefs.setString("data", value);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: const FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            "The Spy",
                            style: TextStyle(
                              // fontSize: 86,
                              color: Colors.white,
                            ),
                          ),
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
              TitleButton(context),
              // const TitleButton(text: "Settings", page: SettingsPage()),
            ],
          ),
        ),
      ),
    );
  }
}



TitleButton(context) =>
  ElevatedButton(
    child: Text(
      "Start Game!",
      style: TextStyle(
        color: Colors.grey.shade300,
        fontSize: 25,
      ),
    ),
    style: ButtonStyle(
      // backgroundColor: const WidgetStatePropertyAll(Colors.grey.shade900),
      backgroundColor: const WidgetStatePropertyAll(Color(0xFF3A4454)),
      foregroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
      minimumSize: WidgetStateProperty.all(const Size(300, 80)),
      // maximumSize: WidgetStateProperty.all(const Size(300, 80)),
    ),
    onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (_) => const GameSelectionPage(), settings: const RouteSettings(name: "/home")));
    }
  );