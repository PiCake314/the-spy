import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNew extends StatefulWidget {
  const CreateNew({super.key});

  @override
  State<CreateNew> createState() => _CreateNewState();
}

class _CreateNewState extends State<CreateNew> {
  // var options =
  //     List.generate(3, (ind) => OptionInput(num: ind, callback: (_) {}));
  int num_option = 3;
  final title_controller = TextEditingController();
  List<TextEditingController> option_controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  Map<String, dynamic> data = {};

  Future loadData() async {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            const Text(
              "Creating Topic",
              style: TextStyle(fontSize: 32),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: title_controller,
                onSubmitted: (value) {},
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  hintText: "Category Name:",
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: ListView.builder(
                    itemCount: option_controllers.length + 1, // plus one for the done button
                    itemBuilder: (context, index) {
                      if (index < option_controllers.length) {
                        return OptionInput(
                          num: index,
                          controller: option_controllers[index],
                          callback: () {
                            setState(() {
                              option_controllers.removeAt(index);
                            });
                          },
                        );
                      } else {
                        return Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 100),
                          child: ElevatedButton(
                              child: const Text("Done!",
                                  style: TextStyle(fontSize: 24)),
                              style: ButtonStyle(
                                minimumSize: const WidgetStatePropertyAll(
                                    Size(0, 70)),
                                foregroundColor: WidgetStateProperty.all(
                                    Theme.of(context).primaryColor),
                              ),
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();

                                final data_string = prefs.getString("data");

                                data = data_string != null
                                  ? Map<String, dynamic>.from(jsonDecode(data_string))
                                  : <String, Object>{};

                                // store the data
                                data["titles"] ??= [];
                                data["titles"].add(title_controller.text.toUpperCase());
                                data["options"] ??= [];
                                data["options"].add(option_controllers
                                    .map((e) => e.text.toUpperCase())
                                    .toList());

                                final value = jsonEncode(data);
                                prefs.setString("data", value);

                                if (context.mounted){
                                  Navigator.of(context).pop();
                                }
                              }),
                        );
                      }
                    },

                    // children: [
                    //   const Center(
                    //     child: Text(
                    //       "Add the options",
                    //       style: TextStyle(fontSize: 32),
                    //     ),
                    //   ),
                    //   ...options,
                    //     ),
                    //   )
                    // ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ElevatedButton(
                      child: const Text(
                        "Add another option",
                        style: TextStyle(fontSize: 22),
                      ),
                      style: ButtonStyle(
                        minimumSize:
                            const WidgetStatePropertyAll(Size(300, 70)),
                        foregroundColor: WidgetStateProperty.all(
                            Theme.of(context).primaryColor),
                      ),
                      onPressed: () => setState(() {
                        option_controllers.add(TextEditingController());
                      }),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OptionInput extends StatelessWidget {
  final int num;
  final TextEditingController controller;
  final void Function() callback;
  const OptionInput(
      {super.key,
      required this.num,
      required this.controller,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Option ${num + 1}:",
          enabledBorder: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          suffixIcon: num >= 3
              ? ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        const WidgetStatePropertyAll(Colors.transparent),
                    elevation: const WidgetStatePropertyAll(0),
                    foregroundColor:
                        WidgetStateProperty.all(Theme.of(context).primaryColor),
                  ),
                  onPressed: () => callback(),
                  child: const Icon(Icons.remove_outlined),
                )
              : null,
        ),
      ),
    );
  }
}
