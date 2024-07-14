import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thespy/Components/MainCard.dart';
import 'package:thespy/GameData.dart';
import 'package:thespy/Pages/CreateNewPage.dart';


class ScrollableBlocks extends StatefulWidget {
  final bool settings;
  const ScrollableBlocks({super.key, required this.settings});

  @override
  State<ScrollableBlocks> createState() => _ScrollableBlocksState();
}

class _ScrollableBlocksState extends State<ScrollableBlocks> {
  List<GameData> cards = []; 

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
      // debugPrint(data_string);

      cards = List<GameData>.generate(
        data["titles"].length,
        (index) => GameData(
          title: data["titles"][index],
          options: List<String>.from(data["options"][index]),
        )
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (widget.settings)
                  Row(
                    mainAxisAlignment: cards.isEmpty
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all(
                                Theme.of(context).primaryColor),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            minimumSize: WidgetStateProperty.all(
                              Size(
                                MediaQuery.of(context).size.width / 2 - 30,
                                MediaQuery.of(context).size.width / 2 - 30,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CreateNew(),
                              ),
                            )
                            .then((_){
                              setState((){}); // refresh the page
                            });
                            
                          },
                          child: const Center(
                            child: Text(
                              "Create\nnew",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 28),
                            ),
                          ),
                        ),
                      ),
                      if (cards.isNotEmpty) MainCard(game_data: cards[0], settings: widget.settings, callback: () => setState(() {})),
                    ],
                  ),


                // disgusting, refactor.
                for (int i = widget.settings ? 1 : 0;
                    i < cards.length - 1;
                    i += 2)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MainCard(game_data: cards[i], settings: widget.settings, callback: () => setState(() {})),
                      MainCard(game_data: cards[i + 1], settings: widget.settings, callback: () => setState(() {})),
                    ],
                  ),
                
                if (!widget.settings && cards.length == 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [MainCard(game_data: cards.first, settings: widget.settings, callback: () => setState(() {}))],
                  ),

                if (!widget.settings && cards.length != 1 && cards.length % 2 == 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [MainCard(game_data: cards.last, settings: widget.settings, callback: () => setState(() {}))],
                  ),
                
                if(widget.settings && cards.isNotEmpty && cards.length % 2 == 0) // 1 element
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [MainCard(game_data: cards.last, settings: widget.settings, callback: () => setState(() {}))],
                  )

              ],
            ),
          );
        });
  }
}
