import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/business_logic/view_models/settings_page_view_model.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingPageViewModel>(
        create: (context) {
          var vm = SettingPageViewModel();
          vm.fetchUserDicts();
          return vm;
        },
        child: Scaffold(
            appBar: AppBar(title: Text('Settings')),
            body: Consumer<SettingPageViewModel>(builder: (context, vm, child) {
              // var userDicts = vm.userDicts;
              // print(userDicts);
              return vm.userDicts.isEmpty
                  ? Container()
                  : _buildDictionaryList(context, vm);
            })));
  }

  Widget _buildDictionaryList(BuildContext context, SettingPageViewModel vm) {
    // return ReorderableListView(
    //   onReorder: (oldIndex, newIndex) => vm.changeOrder(oldIndex, newIndex),
    //   children: [
    //     for (int index = 0; index < vm.userDicts.length; index++)
    //       ListTile(
    //         key: Key('${vm.userDicts[index].bookID}'),
    //         leading: Checkbox(
    //           value: vm.userDicts[index].userChoice,
    //           onChanged: (value) => vm.onCheckedChange(index, value!),
    //         ),
    //         title: Text('${vm.userDicts[index].name}'),
    //         // subtitle: Text('${vm.userDicts[index].userOrder}'),
    //         trailing: Icon(Icons.drag_handle),
    //       )
    //   ],
    // );
    final dictionaries = vm.userDicts;
    return ReorderableListView.builder(
      itemCount: dictionaries.length,
      itemBuilder: (context, index) {
        return Column(
          key: Key('${dictionaries[index].bookID}'),
          children: [
            ListTile(
              leading: Checkbox(
                value: dictionaries[index].userChoice,
                onChanged: (value) => vm.onCheckedChange(index, value!),
              ),
              title: Text('${dictionaries[index].name}'),
              // subtitle: Text('${vm.userDicts[index].userOrder}'),
              trailing: Icon(Icons.drag_handle),
            ),
            Divider(
              height: 1.0,
            )
          ],
        );
      },
      onReorder: (oldIndex, newIndex) => vm.changeOrder(oldIndex, newIndex),
      header: Center(
        child: Text(
          'Dictionaries',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
