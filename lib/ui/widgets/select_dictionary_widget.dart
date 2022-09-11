import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/business_logic/view_models/dictionary_settings_view_model.dart';

class SelectDictionaryWidget extends StatelessWidget {
  const SelectDictionaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DictionarySettingController>(
      create: (context) {
        var vm = DictionarySettingController();
        vm.fetchUserDicts();
        return vm;
      },
      child:
          Consumer<DictionarySettingController>(builder: (context, vm, child) {
        final dictionaries = vm.userDicts;
        // print(userDicts);
        return ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dictionaries.length,
          itemBuilder: (context, index) {
            return Column(
              key: Key('${dictionaries[index].bookID}'),
              children: [
                ListTile(
                  leading: Checkbox(
                    value: dictionaries[index].userChoice,
                    onChanged: (value) => vm.onCheckedChange(
                        index, value!, dictionaries[index].bookID),
                  ),
                  title: Text(dictionaries[index].name),
                  // subtitle: Text('${vm.userDicts[index].userOrder}'),
                  trailing: const Icon(Icons.drag_handle),
                ),
                const Divider(
                  height: 1.0,
                )
              ],
            );
          },
          onReorder: (oldIndex, newIndex) => vm.changeOrder(oldIndex, newIndex),
        );
      }),
    );
  }
}
