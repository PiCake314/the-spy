import 'package:flutter/material.dart';
import 'package:thespy/Components/ScrollableBlocks.dart';

class GameOptionsPage extends StatelessWidget {
  const GameOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 60),
        child: ScrollableBlocks(
          settings: false,
        ),
      ),
    );
  }
}
