import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? leftMostOfRightZone;
  static double? rightMostOfRightZone;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData?.size.width;
    screenHeight = _mediaQueryData?.size.height;
    leftMostOfRightZone = screenWidth! - (30 / 100 * screenWidth!);
    rightMostOfRightZone = screenWidth! - (10 / 100 * screenWidth!);
  }

}
