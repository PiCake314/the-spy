import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thespy/Components/OptionInput.dart';
import 'package:thespy/SharedData.dart';

class CreateNew extends StatefulWidget {
  final bool modifying;
  final String title;
  final List<String> topics;

  const CreateNew({super.key, required this.modifying, this.title = "", this.topics = const []});

  @override
  State<CreateNew> createState() => _CreateNewState();
}

class _CreateNewState extends State<CreateNew> {
  final title_controller = TextEditingController();
  late List<TextEditingController> option_controllers;


  Map<String, dynamic> data = {};


  @override
  void initState() {
    super.initState();

    if(widget.modifying) {
      assert(widget.topics.isNotEmpty);
      assert(widget.title.isNotEmpty);

      title_controller.text = widget.title;
      option_controllers = widget.topics.map((e) => TextEditingController(text: e)).toList();
    } else {
      option_controllers = List.generate(3, (index) => TextEditingController(), growable: true);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Column(
          children: [
            Text(
              "${widget.modifying ? "Modifying" : "Creating"} Topic",
              style: const TextStyle(fontSize: 32),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: title_controller,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintText: "Category Name:",
                ),
                style: TextStyle(fontSize: 24, fontFamily: GoogleFonts.quicksand().fontFamily),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: option_controllers.length +
                    1, // plus one for the done button
                itemBuilder: (context, index) {
                  if (index < option_controllers.length) {
                    // the text fields
                    return OptionInput(
                      hint: "Option",
                      index: index,
                      controller: option_controllers[index],
                      callback: () => setState(() {
                        option_controllers.removeAt(index);
                      }),
                    );
                  } else {
                    // the done button
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 70, // 20 plus button width
                          child: IconButton(
                            icon: const Icon(
                              Icons.add_circle_outline_sharp,
                              size: 50,
                            ),
                            style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all(
                                  Theme.of(context).primaryColor),
                            ),
                            onPressed: () => setState(() {
                              option_controllers
                                  .add(TextEditingController());
                            }),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 40, left: 40, bottom: 40),
              child: ElevatedButton(
                child: const Text(
                  "Done",
                  style: TextStyle(fontSize: 32),
                ),
                style: ButtonStyle(
                  minimumSize:
                      const WidgetStatePropertyAll(Size(300, 70)),
                  foregroundColor: WidgetStateProperty.all(
                      Theme.of(context).primaryColor),
                ),
                onPressed: () async {
                  if (title_controller.text.trim().isEmpty ||
                      option_controllers
                          .any((element) => element.text.trim().isEmpty))
                    return errMsg(context, "Please fill-in all the fields.");

                  if (option_controllers.map((e) => e.text.trim().toUpperCase()).toSet().length != option_controllers.length)
                    return errMsg(context, "Options must be unique.");

                  if (title_controller.text.trim().length > 10)
                    return errMsg(context, "Category name too long.");

                  final prefs = await SharedPreferences.getInstance();

                  final data_string = prefs.getString("data");

                  data = data_string != null
                      ? Map<String, dynamic>.from(jsonDecode(data_string))
                      : <String, Object>{};

                  // store the data
                  data["titles"] ??= [];
                  data["options"] ??= [];

                  if(widget.modifying){
                    final int index = data["titles"].indexOf(widget.title);
                    data["titles"][index] = title_controller.text.trim().toUpperCase();
                    data["options"][index] = option_controllers.map((e) => e.text.trim().toUpperCase()).toList();
                  }
                  else{
                    data["titles"].add(title_controller.text.trim().toUpperCase());
                    data["options"].add(option_controllers.map((e) => e.text.trim().toUpperCase()).toList());
                  }


                  final value = jsonEncode(data);
                  prefs.setString("data", value);

                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
