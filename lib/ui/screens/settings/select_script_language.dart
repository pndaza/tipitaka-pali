import 'package:flutter/material.dart';

import '../../widgets/colored_text.dart';

class SelectScriptLanguageWidget extends StatelessWidget {
  SelectScriptLanguageWidget(
      {Key? key, required this.languages, required this.current, this.onChanged})
      : super(key: key);
  final List<String> languages;
  final String current;
  final Function(String? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: current,
        // style: TextStyle(color: Theme.of(context).primaryColor),
        onChanged: onChanged,
        items: languages.map<DropdownMenuItem<String>>(
          (String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: ColoredText(
                value,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Theme.of(context).primaryColor,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            );
          },
        ).toList());
  }
}
