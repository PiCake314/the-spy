import 'dart:math';

import 'package:flutter/material.dart';
import 'package:thespy/GameData.dart';
import 'package:thespy/Pages/ResultsPage.dart';
import 'package:thespy/SharedData.dart';



class TestingPage extends StatefulWidget {

  final GameInfo game_info;
  // voting indecies matches game_info.players indecies
  final List<String> votes;

  const TestingPage({
    super.key,
    required this.game_info,
    required this.votes
  });

  @override
  State<TestingPage> createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  late final List<String> choices = (){
    widget.game_info.topic_list.shuffle(); // shuffling to ensure we don't add the same set of players every time
    final int limit = min(7, widget.game_info.topic_list.length); // I pulled 7 out of my ass. Can be really anything.

    final List<String> choices = [];
    for(int i = 0; i < limit; ++i) // add random 7 names (or less)
      choices.add(widget.game_info.topic_list[i]);

    // make sure the spy is in there haha (didn't catch me bitch)
    if(!choices.contains(widget.game_info.topic))
      // removing 1 element to remain the size at 7 (or less)
      choices..removeLast()..add(widget.game_info.topic);

    choices.shuffle(); // re-shuffling just for good measure

    return choices;
  }(); // gotta love IIFE

  late List<Color> colors = List.filled(choices.length, Colors.white);
  bool chosen = false;

  @override
  Widget build(BuildContext context) => Scaffold(
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
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Text("Okay Mr. ${widget.game_info.spy}", style: const TextStyle(fontSize: 32)),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: choices.length,
            itemBuilder: (context, idx) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .08,
                child: ElevatedButton(
                  child: Text(choices[idx], style: const TextStyle(fontSize: 28)),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      colors[idx]
                    )
                  ),
                  onPressed: () async {
                    if(chosen) return; chosen = true;


                    if(choices[idx] == widget.game_info.topic)
                      setState(() => colors[idx] = Colors.green.shade300);
                    else{
                      setState(() => colors[idx] = Colors.red);

                      for(int i = 0; i < colors.length; ++i)
                        if(choices[i] == widget.game_info.topic)
                          setState(() => colors[i] = Colors.green.shade300);
                      
                      for(int i = 0; i < 2; ++i){
                        await Future.delayed(const Duration(milliseconds: 250),
                          () => setState(() => colors[idx] = Colors.white),
                        );
                        
                        await Future.delayed(const Duration(milliseconds: 250),
                          () => setState(() => colors[idx] = Colors.red),
                        );
                      }
                    }

                    await Future.delayed(const Duration(milliseconds: 1000))
                    .then((_) => Navigator.of(context).push(PageRouteBuilder(
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

                      pageBuilder: (_, __, ___) => ResultsPage(
                        game_info: widget.game_info,
                        votes: widget.votes,
                        spy_vote: choices[idx],
                      ),
                    )));
                  },
                )
              )
            ),
          ),
        ),
      ],
    ),
  );
}