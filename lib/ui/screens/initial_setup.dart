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
          return Center(child: _buildHomeView(vm));
        },
      ),
    );
  }

  Widget _buildHomeView(InitialSetupViewModel vm) {
    var state = vm.state;
    if (state == SetupState.afterDownload) return _showCopingView();
    if (state == SetupState.downlading) return _showDownloadingView(vm);
    return _showDownloadView(vm);
  }

  Widget _showCopingView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(
          height: 10,
        ),
        Text('အချက်အလက်များ ထည့်သွင်းနေပါသည်။ ခေတ္တစောင့်ပါ')
      ],
    );
  }

  Widget _showDownloadView(InitialSetupViewModel vm) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isUpdateMode
            ? const Text(
                'အချက်အလက် အသစ်များ ထပ်မံ ဒေါင်းလုပ် ပြုလုပ်ရန် လိုအပ်ပါသည်။')
            : const Text(
                'အချက်အလက်များကို ⁠ဒေါင်းလုပ်ပြုလုပ်ရန် လိုအပ်ပါသည်။\n' +
                    '၁၂၀ မီဂါဘိုက်ခန့် ကုန်ပါမည်။\n' +
                    'ထည့်သွင်းပြီးနောက် ၆၀၀ မီဂါဘိုက်မျှ စက်ထဲ နေရာယူပါလိမ့်မည်',
                textAlign: TextAlign.center,
              ),
        SizedBox(height: 10),
        FloatingActionButton.extended(
            onPressed: vm.download, label: Text('Download'))
      ],
    );
  }

  Widget _showDownloadingView(InitialSetupViewModel vm) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ဒေါင်းလုပ် ပြုလုပ်နေပါသည်။\n' + 'ပြီးစီးမှုအခြေအနေ ${vm.progress}%',
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        FloatingActionButton.extended(
            onPressed: vm.cancelDownload, label: Text('Cancel'))
      ],
    );
  }
}
