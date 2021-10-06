import './mm_pali.dart';

class PaliScript {
  PaliScript._();
  static String getScriptOf(
      {required String language,
      required String romanText,
      bool isHtmlText = false}) {
    if (language == 'မြန်မာ') {
      if (!isHtmlText) return MmPali.fromRoman(romanText);

      // pali word not inside html tag
      final regexPaliWord =
          RegExp(r'[0-9a-zA-ZāīūṅñṭḍṇḷṃĀĪŪṄÑṬḌHṆḶṂ\.]+(?![^<>]*>)');
      return romanText.replaceAllMapped(regexPaliWord, (match) {
        return MmPali.fromRoman(match.group(0)!);
      });
    }

    return romanText;
  }

  static String getRomanScriptFrom(
      {required String language, required String text}) {
    if (language == 'မြန်မာ') {
      return MmPali.toRoman(text);
    }
    return text;
  }
}
