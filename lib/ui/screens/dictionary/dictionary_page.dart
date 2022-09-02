import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/dictionary_controller.dart';
import 'widget/dict_algo_selector.dart';
import 'widget/dict_content_view.dart';
import 'widget/dict_search_field.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({Key? key}) : super(key: key);

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary'),
      ),
      body: ChangeNotifierProvider<DictionaryController>(
        create: (context) => DictionaryController(
          context: context,
        )..onLoad(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            Row(
              children: const [
                Expanded(child: DictionarySearchField()),
                SizedBox(width: 8), // padding
                DictionaryAlgorithmModeView(),
              ],
            ),
            const SizedBox(height: 4), // padding
            const Expanded(child: DictionaryContentView())
          ]),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
