import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/business_logic/view_models/initial_setup_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tipitaka_pali/ui/widgets/colored_text.dart';
import 'package:tipitaka_pali/ui/widgets/select_language_widget.dart';
import 'package:tipitaka_pali/ui/screens/settings/select_script_language.dart';

class InitialSetup extends StatelessWidget {
  final bool isUpdateMode;
  const InitialSetup({Key? key, this.isUpdateMode = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ChangeNotifierProvider<InitialSetupViewModel>(
        create: (context) =>
            InitialSetupViewModel(context)..setUp(isUpdateMode),
        builder: (context, child) {
          final vm = Provider.of<InitialSetupViewModel>(context);
          return Center(child: _buildHomeView(context, vm));
        },
      ),
    );
  }

  Widget _buildHomeView(BuildContext context, InitialSetupViewModel vm) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // first load, select language "hard-coded in all supported languages"
        const Text(
            "Set Language \nသင်၏ဘာသာစကားကိုရွေးပါ\nඔබේ භාෂාව තෝරන්න\n选择你的语言\nChọn ngôn ngữ\nभाषा चयन करें\n"),
        const SizedBox(
          height: 20,
        ),
        SelectLanguageWidget(),
        const SizedBox(
          height: 20,
        ),
        const SelectScriptLanguageWidget(),
        const SizedBox(
          height: 20,
        ),
        const CircularProgressIndicator(),
        const SizedBox(
          height: 10,
        ),
        isUpdateMode
            ? Text(
                AppLocalizations.of(context)!.updatingStatus,
                textAlign: TextAlign.center,
              )
            : Text(AppLocalizations.of(context)!.copyingStatus,
                textAlign: TextAlign.center),
        const SizedBox(
          height: 10,
        ),
        ColoredText(vm.status)
      ],
    );
  }
}
