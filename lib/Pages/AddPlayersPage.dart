import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thespy/Components/PlayerFields.dart';
import 'package:thespy/Pages/GamePage.dart';
import 'package:thespy/SharedData.dart';

class PlayersPage extends StatefulWidget {
  final String title;
  final String topic;
  final List<String> topic_list;
  const PlayersPage({super.key, required this.title, required this.topic, required this.topic_list});

  @override
  State<PlayersPage> createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  List<TextEditingController> player_controllers = [];

  Future<void> loadPlayers() async {
    final prefs = await SharedPreferences.getInstance();

    final players = prefs.getStringList("players") ?? [];

    player_controllers =
        players.map((player) => TextEditingController(text: player)).toList();

    for (int i = player_controllers.length; i < 3; i++) {
      player_controllers.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Column(
          children: [
            const Text(
              "Add Players",
              style: TextStyle(fontSize: 44),
            ),
            FutureBuilder(
              future: loadPlayers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }

                return PlayerFields(player_controllers: player_controllers);
              },
            ),

            Padding(
              padding: const EdgeInsets.only(right: 40, left: 40, bottom: 40),
              child: ElevatedButton(
                child: Text(
                  "Done",
                  style: TextStyle(color: Colors.grey.shade300, fontSize: 32),
                ),
                style: ButtonStyle(
                  minimumSize: const WidgetStatePropertyAll(Size(300, 70)),
                  backgroundColor: const WidgetStatePropertyAll(Color(0xFF3a4454)),
                  foregroundColor:
                      WidgetStateProperty.all(Theme.of(context).primaryColor),
                ),
                onPressed: () async {
                  if(player_controllers.any((e) => e.text.isEmpty))
                    return errMsg(context, "Please fill-in all the fields.");

                  if (player_controllers
                      .map((e) => e.text.trim().toUpperCase())
                      .toSet()
                      .length != player_controllers.length)
                    return errMsg(context, "Players must be unique.");
            
                  final prefs = await SharedPreferences.getInstance();
            
                  final players =
                      player_controllers.map((e) => e.text.trim()).toList();
                  prefs.setStringList(
                    "players",
                    players,
                  );
            
                  if (context.mounted)
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => GameLogic(
                          title: widget.title,
                          topic: widget.topic,
                          topic_list: widget.topic_list,
                          players: players,
                        ),
                        settings: const RouteSettings(name: "/game"),
                      ),
                    );
            
                  // if (context.mounted){
                  //   Navigator.of(context).pop();
                  // }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
