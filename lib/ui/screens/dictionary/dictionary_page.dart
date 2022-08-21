import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/dictionary_controller.dart';
import 'widget/dict_algo_selector.dart';
import 'widget/dict_content_view.dart';
import 'widget/dict_search_field.dart';

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
          child: Column(children: [
            Row(
              children: const [
                DictionarySearchField(),
                DictionaryAlgorithmModeView(),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            const Expanded(child: DictionaryContentView())
          ]),
        ),
      ),
    );
  }
}
