import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/utils/pali_script_converter.dart';

import '../../../services/provider/script_language_provider.dart';
import '../../widgets/colored_text.dart';

class SelectScriptLanguageWidget extends StatelessWidget {
  const SelectScriptLanguageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scriptLanguageProvider = context.watch<ScriptLanguageProvider>();
    return DropdownButton<ScriptInfo>(
        value: scriptLanguageProvider.currentScriptInfo,
        // style: TextStyle(color: Theme.of(context).primaryColor),
        onChanged: (value) {
          scriptLanguageProvider.onLanguageChage(value);
        },
        items: scriptLanguageProvider.languages.map<DropdownMenuItem<ScriptInfo>>(
          (ScriptInfo value) {
            return DropdownMenuItem<ScriptInfo>(
              value: value,
              child: ColoredText(
                value.nameInLocale,
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
