import 'dart:io';

class PlatformInfo {
  static final bool _isDesktop =
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  static bool get isDesktop => _isDesktop;
}
