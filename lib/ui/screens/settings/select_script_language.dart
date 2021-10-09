import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/provider/script_language_provider.dart';
import '../../widgets/colored_text.dart';

class SelectScriptLanguageWidget extends StatelessWidget {
  const SelectScriptLanguageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scriptLanguageProvider = context.watch<ScriptLanguageProvider>();
    return DropdownButton<String>(
        value: scriptLanguageProvider.currentLanguage,
        // style: TextStyle(color: Theme.of(context).primaryColor),
        onChanged: (value) {
          scriptLanguageProvider.onLanguageChage(value);
        },
        items: scriptLanguageProvider.languages.map<DropdownMenuItem<String>>(
          (String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: ColoredText(
                value,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Theme.of(context).primaryColor,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            );
          },
        ).toList());
  }
}
