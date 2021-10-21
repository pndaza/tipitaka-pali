import 'package:tipitaka_pali/services/provider/locale_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/services/prefs.dart';
import 'package:tipitaka_pali/ui/widgets/colored_text.dart';

class SelectLanguageWidget extends StatelessWidget {
  SelectLanguageWidget({Key? key}) : super(key: key);
  final _languageItmes = <String>[
    'English',
    'မြန်မာ',
    'සිංහල',
    '中文',
    'Tiếng Việt',
    'हिंदी'
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: _languageItmes[Prefs.localeVal],
        // style: TextStyle(color: Theme.of(context).primaryColor),
        // isDense: true,
        onChanged: (newValue) {
          Prefs.localeVal = _languageItmes.indexOf(newValue!);
          final localeProvider =
              Provider.of<LocaleChangeNotifier>(context, listen: false);
          localeProvider.localeVal = Prefs.localeVal;
        },
        items: _languageItmes.map<DropdownMenuItem<String>>(
          (String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: ColoredText(
                value,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Theme.of(context).primaryColor,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            );
          },
        ).toList());
  }
}
