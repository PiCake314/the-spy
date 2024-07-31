import 'dart:math';

import 'package:flutter/material.dart';
import 'package:thespy/GameData.dart';
import 'package:thespy/Pages/TestingPage.dart';
import 'package:thespy/SharedData.dart';

class SpyReveal extends StatefulWidget {
  final GameInfo game_info;

  final List<String> votes;

  const SpyReveal({
    super.key,
    required this.game_info,
    required this.votes,
  });

  @override
  State<SpyReveal> createState() => _SpyRevealState();
}

class _SpyRevealState extends State<SpyReveal> {
  late String name;
  int bottom = 0;
  int opacity = 0;

  Future<void> showSpy() async {
    final random = Random();
    final limit = random.nextInt(20) + 10 + (10 * (widget.game_info.players.length) / 5);
    for (int i = 0; i < limit; ++i) {
      await Future.delayed(
        const Duration(milliseconds: 100),
        () => setState(() => name = widget.game_info
            .players[random.nextInt(widget.game_info.players.length)]),
      );
    }
    // this is to set the name to the spy
    await Future.delayed(
      const Duration(milliseconds: 100),
      () => setState(() {
          name = widget.game_info.spy;
          bottom = 150;
          opacity = 1;
        }),
      );

    // change position
  }

  @override
  void initState() {
    super.initState();

    name = widget
        .game_info.players[Random().nextInt(widget.game_info.players.length)];
    showSpy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.sensor_door_outlined),
          onPressed: () => showExitModal(context),
        ),
        forceMaterialTransparency: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 150),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text("The SPY is..:", style: TextStyle(fontSize: 32)),
            ),
          ),
          Center(
            child: Container(
              width: 200,
              height: 200,
              margin: const EdgeInsets.all(40),
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black, blurRadius: 50)],
              ),
            ),
          ),
          Text(name, style: const TextStyle(fontSize: 32)),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            bottom: bottom.toDouble(),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: opacity.toDouble(),
              child: ElevatedButton(
                child: const Text("Next!", style: TextStyle(fontSize: 32)),
                style: const ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(Size(300, 70))),
                onPressed: () => Navigator.of(context).push(PageRouteBuilder(
                  transitionsBuilder: (_, animation, __, child) {
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
                  pageBuilder: (_, __, ___) => TestingPage(
                    game_info: GameInfo(
                      spy: widget.game_info.spy,
                      players: widget.game_info.players,
                      topic: widget.game_info.topic,
                      topic_list: widget.game_info.topic_list,
                    ),
                    votes: widget.votes,
                  ),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
