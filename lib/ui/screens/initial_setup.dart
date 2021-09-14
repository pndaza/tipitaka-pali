import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/business_logic/view_models/initial_setup_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InitialSetup extends StatelessWidget {
  final bool isUpdateMode;
  const InitialSetup({Key? key, this.isUpdateMode = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ChangeNotifierProvider<InitialSetupViewModel>(
        create: (context) => InitialSetupViewModel(context),
        builder: (context, child) {
          final vm = Provider.of<InitialSetupViewModel>(context);
          vm.setUp(isUpdateMode);
          return Center(child: _buildHomeView(context, vm));
        },
      ),
    );
  }

  Widget _buildHomeView(BuildContext context, InitialSetupViewModel vm) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(
          height: 10,
        ),
        isUpdateMode
            ? Text(
                AppLocalizations.of(context)!.new_info_adding,
                textAlign: TextAlign.center,
              )
            : Text(AppLocalizations.of(context)!.entering_info,
                textAlign: TextAlign.center)
      ],
    );
  }
}
