

import 'package:flutter/material.dart';


class Pair<T1, T2>{
  T1 first;
  T2 second;

  Pair(this.first, this.second);
}

Map<String, int> scores = {};


void errMsg(BuildContext context, final String label) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(label),
      behavior: SnackBarBehavior.floating,
    ),
  );
}


void showExitModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Quit Game?", style: TextStyle(fontSize: 32)),
      content: const Text("You will lose your current scores.", style: TextStyle(fontSize: 20)),
      actions: [
        TextButton(
          child: const Text("No", style: TextStyle(fontSize: 20)),
          onPressed: () => Navigator.of(context).pop(),
        ),

        TextButton(
          child: const Text("Yes", style: TextStyle(fontSize: 20, color: Colors.red)),
          onPressed: () {
            scores.clear();
            Navigator.of(context).popUntil((route) => route.settings.name == "/main_menu");
          },
        ),
      ],
    ),
  );
}

