import 'package:flutter/material.dart';

class OptionInput extends StatelessWidget {
  final String hint;
  final int index;
  final TextEditingController controller;
  final void Function() callback;
  const OptionInput({
      super.key,
      required this.hint,
      required this.index,
      required this.controller,
      required this.callback,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "$hint ${index + 1}:",
          enabledBorder: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          suffixIcon: index >= 3
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
