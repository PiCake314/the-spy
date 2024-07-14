import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thespy/Components/OptionInput.dart';


class PlayersPage extends StatefulWidget {
  const PlayersPage({super.key});

  @override
  State<PlayersPage> createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  List<TextEditingController> player_controllers = [];

  Future<void> loadPlayers() async {
    final prefs = await SharedPreferences.getInstance();

    final players = prefs.getStringList("players") ?? [];

    player_controllers = players.map((player) => TextEditingController(text: player)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: loadPlayers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
      
          return ListView.builder(
            itemCount: player_controllers.length +1, // plus one for the add player button
            itemBuilder: (context, index) {
              if (index < player_controllers.length){
                return OptionInput(
                  hint: "Player",
                  index: index,
                  controller: player_controllers[index],
                  callback: () => setState(() {
                    player_controllers.removeAt(index);
                  }),
                );
              }
              else{

              }
            },
          );
        },
      ),
    );
  }
}