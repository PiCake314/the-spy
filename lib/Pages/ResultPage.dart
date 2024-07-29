import 'dart:math';

import 'package:flutter/material.dart';
import 'package:thespy/GameData.dart';
import 'package:thespy/Pages/TestingPage.dart';



class ResultPage extends StatefulWidget {
  final GameInfo game_info;

  final List<String> votes;

  const ResultPage({
    super.key,
    required this.game_info,
    required this.votes,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late String name;
  int bottom = 0;

  
  Future<void> showSpy() async {
    final limit = Random().nextInt(20) + 10;
    for(int i = 0; i < limit; ++i){
      await Future.delayed(const Duration(milliseconds: 100), // speeding effect
        () => setState(
          () {
            name = widget.game_info.players[Random().nextInt(widget.game_info.players.length)];
          }
        )
      );

    }
    // this is to set the name to the spy
    await Future.delayed(const Duration(milliseconds: 100),
      () => setState(
        () {
          name = widget.game_info.spy;
          bottom = 200;
        }
      ));
  }

  @override
  void initState() {
    super.initState();

    name = widget.game_info.players[Random().nextInt(widget.game_info.players.length)];
    showSpy();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: GestureDetector(
              child: Container(width: 200, height: 200,
              margin: const EdgeInsets.all(40),
                decoration: const BoxDecoration(
                  color: Colors.blueGrey, 
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 50)]
                ),
              ),
              // onTap: showModal,
            ),
          ),
          Text(name, style: const TextStyle(fontSize: 32)),

          // SlideTransition(
          //   position: ,
          //   child: ElevatedButton(
          //     child: const Text("Next!", style: TextStyle(fontSize: 32)),
          //     onPressed: (){},
          //   ),
          // )

          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                child: const Text("Next!", style: TextStyle(fontSize: 32)),
                style: const ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size(300, 70))
                ),
                onPressed: () => Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = 0.0;
                      const end = 1.0;
                      const curve = Curves.ease;

                      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

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
                    ),
                  )
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }
}