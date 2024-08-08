import 'package:flutter/material.dart';
import 'package:thespy/GameData.dart';
import 'package:thespy/SharedData.dart';

class ResultsPage extends StatelessWidget {
  final GameInfo game_info;
  final List<String> votes;
  final String spy_vote;

  const ResultsPage({
    super.key,
    required this.game_info,
    required this.votes,
    required this.spy_vote
  });


  @override
  Widget build(BuildContext context) {

    for(int i = 0; i < game_info.players.length; ++i){
      final name = game_info.players[i];

      scores[name] ??= 0;

      if(votes[i] == game_info.spy) // players vote for a spy
          scores[name] = scores[name] !+ 100;
    }

    if(spy_vote == game_info.topic) // spy votes for a topic
      scores[game_info.spy] = scores[game_info.spy] !+ 100;

    final sorted_scores = Map.fromEntries(
      scores.entries.toList()..sort((e1, e2) => -e1.value.compareTo(e2.value)),
    );

    final List<Pair<String, int>> sorted_scores_list =
      sorted_scores.entries.map((e) => Pair(e.key, e.value)).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.sensor_door_outlined),
          onPressed: () => showExitModal(context),
        ),
        forceMaterialTransparency: true,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 150),
            child: Text("Results!", style: TextStyle(fontSize: 48)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sorted_scores_list.length,
              itemBuilder: (_, idx){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(sorted_scores_list[idx].first, style: const TextStyle(fontSize: 24)),
                      Text(sorted_scores_list[idx].second.toString(), style: const TextStyle(fontSize: 24))
                    ],
                  ),
                );
              }
            )
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: ElevatedButton(
              child: const Text("Play again", style: TextStyle(fontSize: 32)),
              style: ButtonStyle(
                padding: const WidgetStatePropertyAll(EdgeInsets.all(20)),
                minimumSize: const WidgetStatePropertyAll(Size(300, 70)),
                foregroundColor: WidgetStateProperty.all(
                    Theme.of(context).primaryColor),
              ),

              onPressed: () {
                Navigator.of(context).popUntil((route) => route.settings.name == "/home");
              },
            ),
          ),
        ],
      ),
    );
  }
}
