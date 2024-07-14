import 'package:flutter/material.dart';
import 'package:thespy/Components/ScrollableBlocks.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: ScrollableBlocks(settings: false,),
      ),
    );
  }
}
