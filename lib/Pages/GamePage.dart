import 'dart:math';

import 'package:flutter/material.dart';
import 'package:thespy/Pages/VotingPage.dart';


class GameLogic extends StatefulWidget {
  final String title;
  final String topic;
  final List<String> players;
  late final String the_spy = players[Random().nextInt(players.length)];

  GameLogic({super.key, required this.title, required this.topic, required this.players});

  @override
  State<GameLogic> createState() => GameLogicState();
}

class GameLogicState extends State<GameLogic> {
  int index = 0;
  bool show = false;
  bool start_game = false;
  bool question_time = true;

  // late List<String> askers = widget.players.toList(); // copies the list
  // late List<String> answerers = [...widget.players]; // also copies the list
  int asker_ind = -1;
  // String asker = "";
  int answerer_ind = -1;
  // String answerer = "";
  late int start_index;

  int state_ind = 0;



  String givePhoneTo(String name){
    return "Give the phone to $name.\n$name, press (next) to see whether you're the spy or not.\nDon't let anyone peek into the screen!";
  }

  String showTo(String name){
    return name == widget.the_spy ?
    "You are THE SPY!!\nYour goal is to know what the topic is without drawing suspicion towards you.\nHint: the topic is about ${widget.title}"
    :
    "You are not the spy.\nThe topic is:\n${widget.topic}.\nYour goal is to know which one of the rest is the spy.";
  }

  String getText(){
    if(!start_game){
      return !show ? givePhoneTo(widget.players[index]) : showTo(widget.players[index]);
    }
      // pick someone who didn't ask and another who didn't answer at random
    else if(question_time){
      question_time = false; // will get updated when setState is called
      return "Each person will ask another person a question related to the topic.\nPress (next) to start!";
    }

    return "";
  }


  // for future self: implement multiple algorithms for choosing the asker and answerer and pick one at random

  void setAskerAnswered(){

    // final asker = askers.removeAt(Random().nextInt(askers.length));
    // final int answerer_index = Random().nextInt(answerers.length);
    // if(answerers[answerer_index] == asker) index = (index + 1) % answerers.length;
    // final answerer = answerers.removeAt(answerer_index);

    // final asker = widget.players[asker_ind++];
    ++asker_ind;
    asker_ind %= widget.players.length;

    // final answerer = widget.players[answerer_ind++];
    ++answerer_ind;
    answerer_ind %= widget.players.length;

    if(asker_ind == start_index) state_ind = 2;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // alignment: Alignment.center,
          children: [

            Flexible(
              flex: 2,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    index < widget.players.length ? widget.players[index] : "Question Time",
                    style: const TextStyle(fontSize: 64, color: Colors.black),
                  ),
                ),
              ),
            ),


            !start_game ? // before starting the game
              Flexible(
                flex: 3,
                child: Center(child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    getText(),
                    style: TextStyle(fontSize: 26, color: Colors.blueGrey.shade900),
                    textAlign: TextAlign.center, 
                  )
                )),
              )
            : // after starting the game
            Flexible(
              flex: 3,
              child: Center(child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: widget.players[asker_ind],
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      const TextSpan(text: ", ask "),

                      TextSpan(text: widget.players[answerer_ind],
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),

                      const TextSpan(text: " a question related to the topic.\nPick your question wisely so that the spy doesn't know the topic."),
                    ],
                    style: TextStyle(fontSize: 26, color: Colors.blueGrey.shade900),
                  ),
                  textAlign: TextAlign.center, 
                ),
              )),
            ),

            // Flexible(child: child)


            Flexible(
              flex: 1,
              child: ElevatedButton(
                child: const Text("Next", style: TextStyle(fontSize: 32),),
                style: ButtonStyle(
                  padding: const WidgetStatePropertyAll(EdgeInsets.all(20)),
                  minimumSize: const WidgetStatePropertyAll(Size(300, 70)),
                  foregroundColor: WidgetStateProperty.all(
                      Theme.of(context).primaryColor),
                ),
              
                onPressed: () => setState(() {

                  switch (state_ind) {
                    case 0:
                      show = !show;
                      if(!show) ++index;

                      if(index == widget.players.length){ // every player has gotten their role by now
                        start_game = true;

                        asker_ind = Random().nextInt(widget.players.length);
                        answerer_ind = Random().nextInt(widget.players.length);

                        if(answerer_ind == asker_ind) answerer_ind = (answerer_ind + 1) % widget.players.length;

                        start_index = (asker_ind -1) % widget.players.length;
                        debugPrint("start_index: $start_index");
                        

                        state_ind = 1;
                      }

                      break;

                    case 1:
                      setAskerAnswered();
                      break;

                    case 2:
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const VotingPage())
                      );

                      break;

                    default:
                  }

                }), 
              ),
            )
          ],
        ),
      ),
    );
  }
}