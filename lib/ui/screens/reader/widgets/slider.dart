import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tipitaka_pali/business_logic/view_models/reader_view_model.dart';

class MySlider extends StatelessWidget {
  const MySlider({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final themeData = ThemeProvider.themeOf(context).data;
    final vm = Provider.of<ReaderViewModel>(context);

    return SliderTheme(
      data: SliderThemeData(
          activeTrackColor: themeData.accentColor,
          inactiveTrackColor: Colors.grey,
          thumbColor: themeData.accentColor,
          trackHeight: 2.0,
          valueIndicatorColor: themeData.accentColor,
          valueIndicatorTextStyle: themeData.accentTextTheme.bodyText1),
      child: Slider(
        value: vm.currentPage!.toDouble(),
        min: vm.book.firstPage!.toDouble(),
        max: vm.book.lastPage!.toDouble(),
        label: vm.currentPage.toString(),
        divisions: vm.pages.length,
        onChanged: (value) {
            // vm.currentPage = value.toInt();
            vm.onSliderChanged(value);
        },
        // onChangeStart: null,
        onChangeEnd: (value) {

            vm.gotoPage(value);

        },
      ),
    );
  }
}
