import 'package:flutter/material.dart';
import 'package:thespy/Components/OptionInput.dart';


class PlayerFields extends StatefulWidget {
  final List<TextEditingController> player_controllers;
  const PlayerFields({super.key, required this.player_controllers});

  @override
  State<PlayerFields> createState() => _PlayerFieldsState();
}

class _PlayerFieldsState extends State<PlayerFields> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: ListView.builder(
        itemCount: widget.player_controllers.length +1, // plus one for the add player button
        itemBuilder: (context, index) {
          if (index < widget.player_controllers.length){
            return OptionInput(
              hint: "Player",
              index: index,
              controller: widget.player_controllers[index],
              callback: () => setState(() {
                widget.player_controllers.removeAt(index);
              }),
            );
          }
          else{
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 70, // 20 plus button width
                  child: IconButton(
                    icon: const Icon(Icons.add_circle_outline_sharp, size: 50,),
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(
                        Theme.of(context).primaryColor),
                    ),
                    onPressed: () => setState(() {
                      widget.player_controllers.add(TextEditingController());
                    }),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}