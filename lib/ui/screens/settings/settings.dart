import 'package:flutter/material.dart';
import 'package:tipitaka_pali/services/provider/theme_change_notifier.dart';
import 'package:tipitaka_pali/ui/widgets/select_dictionary_widget.dart';
import 'package:tipitaka_pali/ui/widgets/select_language_widget.dart';
import 'package:tipitaka_pali/ui/widgets/select_theme_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'script_setting_view.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settings),
          actions: const [],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: const <Widget>[
              ThemeSettingView(),
              DarkModeSettingView(),
              LanguageSettingView(),
              ScriptSettingView(),
              DictionarySettingView(),
            ],
          ),
        ));
  }
}

class ThemeSettingView extends StatelessWidget {
  const ThemeSettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: ListTile(
          leading: const Icon(Icons.palette_outlined),
          title: Text(
            AppLocalizations.of(context)!.theme,
            style: Theme.of(context).textTheme.headline6,
          ),
          trailing: const SelectThemeWidget()),
    );
  }
}

class DarkModeSettingView extends StatelessWidget {
  const DarkModeSettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: ListTile(
          leading: const Icon(Icons.brightness_2_outlined),
          title: Text(
            AppLocalizations.of(context)!.darkMode,
            style: Theme.of(context).textTheme.headline6,
          ),
          trailing: Switch(
            onChanged: (value) {
              context.read<ThemeChangeNotifier>().toggleTheme(value);
            },
            value: context.read<ThemeChangeNotifier>().isDarkMode,
          )),
    );
  }
}

class LanguageSettingView extends StatelessWidget {
  const LanguageSettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: ListTile(
        leading: const Icon(Icons.language_outlined),
        title: Text(
          AppLocalizations.of(context)!.language,
          style: Theme.of(context).textTheme.headline6,
        ),
        trailing: SelectLanguageWidget(),
      ),
    );
  }
}

class DictionarySettingView extends StatelessWidget {
  const DictionarySettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: ExpansionTile(
        leading: const Icon(Icons.sort_by_alpha_outlined),
        title: Text(AppLocalizations.of(context)!.dictionaries,
            style: Theme.of(context).textTheme.headline6),
        children: const [SelectDictionaryWidget()],
      ),
    );
  }
}
