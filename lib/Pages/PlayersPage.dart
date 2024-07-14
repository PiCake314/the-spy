import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PlayersPage extends StatefulWidget {
  const PlayersPage({super.key});

  @override
  State<PlayersPage> createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  List<String> players = [];

  Future<void> loadPlayers() async {
    final prefs = await SharedPreferences.getInstance();

    players = prefs.getStringList("players") ?? [];
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
            itemCount: players.length +1, // plus one for the add player button
            itemBuilder: (context, index) {
              return ListTile(
                title: const Text("Player"),
                subtitle: const Text("Role"),
              );
            },
          );
        },
      ),
    );
  }
}