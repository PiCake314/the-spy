// import 'dart:convert';
// import 'dart:math';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:thespy/GameData.dart';
// import 'package:thespy/Pages/AddPlayersPage.dart';
// import 'package:thespy/Pages/CreateNewPage.dart';

// class MainCard extends StatelessWidget {
//   final GameSaveData game_data;
//   final bool settings;
//   final void Function() callback;
//   const MainCard(
//       {super.key,
//       required this.game_data,
//       required this.settings,
//       required this.callback});

//   ElevatedButton button(BuildContext context) => ElevatedButton(
//     child: Center(
//       child: FittedBox(
//         fit: BoxFit.contain,
//         child: Text(
//           game_data.title,
//           textAlign: TextAlign.center,
//           style: const TextStyle(fontSize: 28),
//         ),
//       ),
//     ),
//     style: ElevatedButton.styleFrom(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       maximumSize: Size(
//         MediaQuery.of(context).size.width / 2 - 30,
//         MediaQuery.of(context).size.width / 2 - 30,
//       ),
//     ),
//     onPressed: () {
//       if (!settings) // main page
//         Navigator.of(context).push(
//           MaterialPageRoute(builder: (_) => PlayersPage(
//             title: game_data.title,
//             topic: game_data.topic_list[Random().nextInt(game_data.topic_list.length)],
//             topic_list: game_data.topic_list,
//           )),
//         );
//     },
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(15),
//       child: settings
//           ? CupertinoContextMenu(
//               child: button(context),
//               actions: [
//                 CupertinoContextMenuAction(
//                   child: const Text("Modify"),
//                   trailingIcon: Icons.edit_outlined,
//                   onPressed: () async {
//                     await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => CreateNew(
//                           modifying: true,
//                           title: game_data.title,
//                           topics: game_data.topic_list,
//                         ),
//                       ),
//                     );

//                     callback();
//                     if (context.mounted) Navigator.of(context).pop();
//                   },
//                 ),
//                 CupertinoContextMenuAction(
//                   child: const Text("Delete", style: TextStyle(color: Colors.red)),
//                   isDefaultAction: true,
//                   trailingIcon: Icons.delete_outline,
//                   onPressed: () async {
//                     final prefs = await SharedPreferences.getInstance();

//                     final data_string = prefs.getString("data");
//                     final Map<String, dynamic> data =
//                         data_string != null ? jsonDecode(data_string) : {};

//                     data["options"]
//                         .removeAt(data["titles"].indexOf(game_data.title));
//                     data["titles"].remove(game_data.title);
//                     // data["options"] = [];

//                     await prefs.setString("data", jsonEncode(data));

//                     callback();
//                     if (context.mounted) Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             )
//           : button(context),
//     );
//   }
// }
