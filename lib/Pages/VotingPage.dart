

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thespy/main.dart';

class VotingPage extends StatefulWidget {
  const VotingPage({super.key});

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("go back"),
          onPressed: () => Navigator.popUntil(context, (router) => router.settings.name == "/home")
        ),
      ),
    );
  }
}