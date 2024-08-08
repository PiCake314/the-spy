import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thespy/GameData.dart';
import 'package:thespy/Pages/AddPlayersPage.dart';
import 'package:thespy/Pages/CreateNewPage.dart';

class GameSelectionPage extends StatefulWidget {
  const GameSelectionPage({super.key});

  @override
  State<GameSelectionPage> createState() => _GameSelectionPageState();
}

class _GameSelectionPageState extends State<GameSelectionPage> {
  List<GameSaveData> cards = [];

  // used for caching the data
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final data_string = prefs.getString("data");
    final data =
        data_string != null ? jsonDecode(data_string) : <String, dynamic>{};

    // data["titles"] = [];
    // data["options"] = [];

    // prefs.setString("data", jsonEncode(data));

    if (data_string != null) {
      cards = List<GameSaveData>.generate(
        data["titles"].length,
        (index) => GameSaveData(
          title: data["titles"][index],
          topic_list: List<String>.from(data["options"][index]),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: FutureBuilder(
            future: loadData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
        
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                      Row(
                        mainAxisAlignment: cards.isEmpty
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: const WidgetStatePropertyAll(EdgeInsets.all(5)),
                                backgroundColor: const WidgetStatePropertyAll(Color(0xFF3a4454)),
                                foregroundColor: WidgetStatePropertyAll(
                                    Theme.of(context).primaryColor),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                maximumSize: WidgetStatePropertyAll(
                                  Size(
                                    MediaQuery.of(context).size.width / 2 - 30,
                                    MediaQuery.of(context).size.width / 2 - 30,
                                  ),
                                ),
                              ),
                              child: Container(
                                width:  MediaQuery.of(context).size.width / 2 - 30,
                                height: MediaQuery.of(context).size.width / 2 - 30,
                                child: const Center(
                                  child: Text(
                                    "Create\nnew",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontSize: 28),
                                  ),
                                ),
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/AddCatBG.png"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CreateNew(modifying: false),
                                  ),
                                ).then((_) {
                                  setState(() {}); // refresh the page
                                });
                              },
                            ),
                          ),
                          if (cards.isNotEmpty)
                            MainCard(
                              context,
                              cards[0],
                              () => setState(() {}),
                            ),
                        ],
                      ),
        
                    // disgusting, refactor.
                    for (int i = 1;
                        i < cards.length - 1;
                        i += 2)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MainCard(
                            context,
                            cards[i],
                            () => setState(() {}),
                          ),
        
                          MainCard(
                            context,
                            cards[i + 1],
                            () => setState(() {}),
                          ),
                        ],
                      ),
        
                    // if (!widget.settings && cards.length == 1)
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: [
                    //       MainCard(
                    //         context,
                    //         widget.settings,
                    //         cards.first,
                    //         () => setState(() {}),
                    //       )
                    //     ],
                    //   ),
        
                    // if (!widget.settings &&
                    //     cards.length != 1 &&
                    //     cards.length % 2 == 1)
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: [
                    //       MainCard(
                    //         context,
                    //         widget.settings,
                    //         cards.last,
                    //         () => setState(() {}),
                    //       )
                    //     ],
                    //   ),
        
                    if (cards.isNotEmpty &&
                        cards.length % 2 == 0) // 1 element
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          MainCard(
                            context,
                            cards.last,
                            () => setState(() {}),
                          )
                        ],
                      )
                  ],
                ),
              );
            }),
      ),
    );
  }
}



// a bug was found where the topic would *NOT* change when we popped back into the page
// moved from MainCard.dart to functions to force flutter to re-run whenever we pop back into it
// this avoids the RNG to re-run and generate a new topic
Widget button(
  BuildContext context,
  GameSaveData game_data,
) => ElevatedButton(
  child: Container(
    // don't why but these are needed again here for the image to show
    width:  MediaQuery.of(context).size.width / 2 - 30,
    height: MediaQuery.of(context).size.width / 2 - 30,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/block_bg3.png"),
        fit: BoxFit.cover,
      ),
    ),
    child: Center(
      child: Text(
        game_data.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey.shade300,
          fontSize: 28,
        ),
      ),
    ),
  ),
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.all(2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    backgroundColor: const Color(0xFF3a4454),
    maximumSize: Size(
      MediaQuery.of(context).size.width / 2 - 30,
      MediaQuery.of(context).size.width / 2 - 30,
    ),
  ),
  onPressed: () => Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => PlayersPage(
      title: game_data.title,
      topic: game_data.topic_list[Random().nextInt(game_data.topic_list.length)],
      topic_list: game_data.topic_list,
    )),
  )
);


Widget MainCard(
  BuildContext context,
  GameSaveData game_data,
  callback) => Padding(
    padding: const EdgeInsets.all(15),
    
    child: CupertinoContextMenu(
            child: button(context, game_data),
            actions: [
              CupertinoContextMenuAction(
                child: const Text("Modify"),
                trailingIcon: Icons.edit_outlined,
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateNew(
                        modifying: true,
                        title: game_data.title,
                        topics: game_data.topic_list,
                      ),
                    ),
                  );

                  callback();
                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
              CupertinoContextMenuAction(
                child: const Text("Delete", style: TextStyle(color: Colors.red)),
                isDefaultAction: true,
                trailingIcon: Icons.delete_outline,
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();

                  final data_string = prefs.getString("data");
                  final Map<String, dynamic> data =
                      data_string != null ? jsonDecode(data_string) : {};

                  data["options"]
                      .removeAt(data["titles"].indexOf(game_data.title));
                  data["titles"].remove(game_data.title);
                  // data["options"] = [];

                  await prefs.setString("data", jsonEncode(data));

                  callback();
                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
            ],
          )
  );