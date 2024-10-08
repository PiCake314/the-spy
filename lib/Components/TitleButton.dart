import 'package:flutter/material.dart';


class TitleButton extends StatelessWidget {
  final String text;
  final Widget page;
  const TitleButton({super.key, required this.text, required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 25,
            ),
          ),
          style: ButtonStyle(
            // backgroundColor: const WidgetStatePropertyAll(Colors.grey.shade900),
            backgroundColor: const WidgetStatePropertyAll(Color(0xFF3A4454)),
            foregroundColor: WidgetStatePropertyAll(Theme.of(context).primaryColor),
            minimumSize: WidgetStateProperty.all(const Size(300, 80)),
            // maximumSize: WidgetStateProperty.all(const Size(300, 80)),
          ),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => page, settings: const RouteSettings(name: "/home")));
          }),
    );
  }
}

