import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/business_logic/view_models/dictionary_view_model.dart';
import 'package:tipitaka_pali/ui/dialogs/dictionary_dialog.dart';

class DictionaryPage extends StatelessWidget {
  const DictionaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary'),
      ),
      body: ChangeNotifierProvider<DictionaryViewModel>(
        create: (context) => DictionaryViewModel(context, null),
        child: Material(
          child: Stack(
            children: const [
              Padding(
                padding: EdgeInsets.only(top: 56.0),
                child: DictionaryContentView(),
              ),
              ListTile(
                title: DictionarySearchField(),
                trailing: DictionaryAlgorithmModeView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
