import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thespy/Components/OptionInput.dart';

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

  void errMsg(final String label){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(label),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
                      if (index < option_controllers.length) { // the text fields
                        return OptionInput(
                          hint: "Option",
                          index: index,
                          controller: option_controllers[index],
                          callback: () => setState(() {
                            option_controllers.removeAt(index);
                          }),
                        );
                      } else { // the done button
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
                                  option_controllers.add(TextEditingController());
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
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    child: const Text(
                      "Done",
                      style: TextStyle(fontSize: 22),
                    ),
                    style: ButtonStyle(
                      minimumSize:
                          const WidgetStatePropertyAll(Size(300, 70)),
                      foregroundColor: WidgetStateProperty.all(
                          Theme.of(context).primaryColor),
                    ),
                    onPressed: () async {
                      if(title_controller.text.trim().isEmpty || option_controllers.any((element) => element.text.isEmpty))
                        return errMsg("Please fill-in all the fields.");

                      if(title_controller.text.trim().length > 10)
                        return errMsg("Category name too long.");

                      final prefs =
                          await SharedPreferences.getInstance();

                      final data_string = prefs.getString("data");

                      data = data_string != null
                        ? Map<String, dynamic>.from(jsonDecode(data_string))
                        : <String, Object>{};

                      // store the data
                      data["titles"] ??= [];
                      data["titles"].add(title_controller.text.trim().toUpperCase());
                      data["options"] ??= [];
                      data["options"].add(option_controllers
                          .map((e) => e.text.trim().toUpperCase())
                          .toList());

                      final value = jsonEncode(data);
                      prefs.setString("data", value);

                      if (context.mounted){
                        Navigator.of(context).pop();
                      }
                    }
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
