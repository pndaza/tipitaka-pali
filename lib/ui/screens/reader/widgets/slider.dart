import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tipitaka_pali/business_logic/view_models/reader_view_model.dart';

class MySlider extends StatefulWidget {
  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  @override
  Widget build(BuildContext context) {
    final themeData = ThemeProvider.themeOf(context).data;
    final vm = Provider.of<ReaderViewModel>(context);
    if (vm.pages != null) {
      return SliderTheme(
        data: SliderThemeData(
            activeTrackColor: themeData.accentColor,
            inactiveTrackColor: Colors.grey,
            thumbColor: themeData.accentColor,
            trackHeight: 2.0,
            valueIndicatorColor: themeData.accentColor,
            valueIndicatorTextStyle: themeData.accentTextTheme.bodyText1),
        child: Slider(
          value: vm.currentPage.toDouble(),
          min: vm.book.firstPage.toDouble(),
          max: vm.book.lastPage.toDouble(),
          label: vm.currentPage.toString(),
          divisions: (vm.book.lastPage - vm.book.firstPage) + 1,
          onChanged: vm.setCurrentPage,
          // onChangeStart: null,
          onChangeEnd: vm.gotoPage,
        ),
      );
    } else {
      return Container();
    }
  }
}
