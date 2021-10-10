class ScriptDetector {
  ScriptDetector._();
  static final _regexMM = RegExp('[\u1000-\u109F]');
  static final _regexRoman = RegExp(r'[a-zA-ZāīūṅñṭḍṇḷṃĀĪŪṄÑṬḌHṆḶṂ]');
  static final _regexSinhala = RegExp('[\u0D80-\u0DFF]');
  static String getLanguage(String scriptText) {
    if (scriptText.contains(_regexMM)) return 'မြန်မာ';
    if (scriptText.contains(_regexRoman)) return 'Roman';
    if (scriptText.contains(_regexSinhala)) return 'සිංහල';
    // default
    return 'Roman';
  }
}
