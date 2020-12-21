import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/business_logic/view_models/initial_setup_view_model.dart';

class InitialSetup extends StatelessWidget {
  final bool isUpdateMode;
  const InitialSetup({Key key, this.isUpdateMode = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ChangeNotifierProvider<InitialSetupViewModel>(
        create: (context) => InitialSetupViewModel(context),
        builder: (context, child) {
          final vm = Provider.of<InitialSetupViewModel>(context);
          vm.setUp(isUpdateMode);
          return Center(child: _buildHomeView(vm));
        },
      ),
    );
  }

  Widget _buildHomeView(InitialSetupViewModel vm) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(
          height: 10,
        ),
        isUpdateMode?
        Text('အချက်အလက်အသစ်များ ထည့်သွင်းနေပါသည်။\nခေတ္တစောင့်ပါ', textAlign: TextAlign.center,) :
        Text('အချက်အလက်များ ထည့်သွင်းနေပါသည်။\nခေတ္တစောင့်ပါ', textAlign: TextAlign.center)
      ],
    );
  }
}
