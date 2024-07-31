import 'package:flutter/material.dart';
import 'package:thespy/GameData.dart';
import 'package:thespy/Pages/SpyRevealPage.dart';

class VotingPage extends StatefulWidget {
  final GameInfo game_info;

  const VotingPage({super.key, required this.game_info});

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  int index = 0;
  late final votes = List.filled(widget.game_info.players.length, "");

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Text(
              "${widget.game_info.players[index]}, vote for the spy!",
              style: const TextStyle(fontSize: 32),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.game_info.players.length,
              itemBuilder: (ctx, idx) {
                if (index == idx) return const SizedBox();

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .08,
                    child: ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.game_info.players[idx],
                              style: const TextStyle(fontSize: 28)),
                          const Icon(Icons.fingerprint_sharp, size: 40),
                        ],
                      ),
                      // trailing:
                      onPressed: () => setState(() {
                        votes[index] = widget.game_info.players[idx];

                        if (index == widget.game_info.players.length - 1)
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = 0.0;
                                  const end = 1.0;
                                  const curve = Curves.ease;

                                  final tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));

                                  return ScaleTransition(
                                    scale: animation.drive(tween),
                                    child: child,
                                  );
                                },
                                pageBuilder: (_, __, ___) => SpyReveal(
                                  game_info: GameInfo(
                                    spy: widget.game_info.spy,
                                    players: widget.game_info.players,
                                    topic: widget.game_info.topic,
                                    topic_list: widget.game_info.topic_list,
                                  ),
                                  votes: votes,
                                ),
                              ));
                        else
                          ++index;
                      }),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      )),
    );
  }
}
