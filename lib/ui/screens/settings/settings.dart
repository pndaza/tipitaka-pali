import 'package:flutter/material.dart';
import 'package:tipitaka_pali/ui/widgets/select_dictionary_widget.dart';
import 'package:tipitaka_pali/ui/widgets/select_language_widget.dart';
import 'package:tipitaka_pali/ui/widgets/select_theme_widget.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          actions: [],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              ThemeSettingView(),
              LanguageSettingView(),
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
          title: Text(
            'Theme',
            style: Theme.of(context).textTheme.headline6,
          ),
          trailing: SelectThemeWidget()),
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
        title: Text(
          'Launguage',
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
        title:
            Text('Dictionaries', style: Theme.of(context).textTheme.headline6),
        children: [SelectDictionaryWidget()],
      ),
    );
  }
}


