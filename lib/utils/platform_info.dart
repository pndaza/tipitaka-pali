import 'dart:io';

import 'package:flutter/material.dart';

class PlatformInfo {
  static final bool _isDesktop =
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  static bool get isDesktop => _isDesktop;
}

// In flutter, there are roughly 96 logical pixels per inch or 38 per cm.
// 8 inch ipad mini have 744 logical pixels of width.
class Mobile {
  static bool isTablet(BuildContext context) =>
      !PlatformInfo.isDesktop && MediaQuery.of(context).size.width >= 700;

  static bool isPhone(BuildContext context) =>
      !PlatformInfo.isDesktop && MediaQuery.of(context).size.width < 700;
}
