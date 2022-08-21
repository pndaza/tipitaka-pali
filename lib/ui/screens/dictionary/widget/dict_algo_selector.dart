import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/dictionary_controller.dart';

class DictionaryAlgorithmModeView extends StatelessWidget {
  const DictionaryAlgorithmModeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final algoMode = context.select<DictionaryController, DictAlgorithm>(
        (vm) => vm.currentAlgorithmMode);

    return DropdownButton<DictAlgorithm>(
      value: algoMode,
      items: DictAlgorithm.values
          .map((algo) => DropdownMenuItem<DictAlgorithm>(
              value: algo, child: Text(algo.toStr())))
          .toList(),
      onChanged: context.read<DictionaryController>().onModeChanged,
    );
  }
}
