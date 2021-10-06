class ScriptDetector {
  ScriptDetector._();
  static final _regexMM = RegExp('[\u1000-\u109F]');
  static final _regexRoman = RegExp(r'[a-zA-ZāīūṅñṭḍṇḷṃĀĪŪṄÑṬḌHṆḶṂ]');
  static String getLanguage(String scriptText) {
    if (scriptText.contains(_regexMM)) return 'မြန်မာ';
    if (scriptText.contains(_regexRoman)) return 'Roman';
    // default
    return 'Roman';
  }
}
