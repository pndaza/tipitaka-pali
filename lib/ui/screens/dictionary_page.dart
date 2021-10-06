import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/business_logic/view_models/dictionary_view_model.dart';
import 'package:tipitaka_pali/ui/dialogs/dictionary_dialog.dart';

class DictionaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dictionary'),
      ),
      body: ChangeNotifierProvider<DictionaryViewModel>(
        create: (content) => DictionaryViewModel( null),
        child: Material(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 56.0),
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
