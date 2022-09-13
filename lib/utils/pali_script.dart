import 'package:tipitaka_pali/utils/roman_to_sinhala.dart';

import './mm_pali.dart';
import './pali_script_converter.dart';

class PaliScript {
  // pali word not inside html tag
  static final _regexPaliWord =
      RegExp(r'[0-9a-zA-ZāīūṅñṭḍṇḷṃĀĪŪṄÑṬḌHṆḶṂ\.]+(?![^<>]*>)');
  PaliScript._();
  static String getScriptOf({
    required Script script,
    required String romanText,
    bool isHtmlText = false,
  }) {
    if (romanText.isEmpty) return romanText;

    if (script == Script.myanmar) {
      if (!isHtmlText) {
        return MmPali.fromRoman(romanText);
      } else {
        return romanText.replaceAllMapped(
            _regexPaliWord, (match) => MmPali.fromRoman(match.group(0)!));
      }
    }

    // else if (script == Script.sinhala) {
    //   if (!isHtmlText) {
    //     return toSin(romanText);
    //   } else {
    //     return romanText.replaceAllMapped(
    //         _regexPaliWord, (match) => toSin(match.group(0)!));
    //   }
    // }

    else if (script == Script.devanagari) {
      if (!isHtmlText) {
        return toDeva(romanText);
      } else {
        return romanText.replaceAllMapped(
            _regexPaliWord, (match) => toDeva(match.group(0)!));
      }
    } else {
      if (!isHtmlText) {
        final sinhala = TextProcessor.convertFrom(romanText, Script.roman);
        return TextProcessor.convert(sinhala, script);
      } else {
        return romanText.replaceAllMapped(_regexPaliWord, (match) {
          final sinhala =
              TextProcessor.convertFrom(match.group(0)!, Script.roman);
          return TextProcessor.convert(sinhala, script);
        });
      }
    }

  }

  static String getRomanScriptFrom(
      {required Script script, required String text}) {
    if (script == Script.myanmar) {
      return MmPali.toRoman(text);
    // } else if (script == Script.sinhala) {
    //   return fromSin(text);
    } else {
      final sinhala = TextProcessor.convertFrom(text, script);
      return TextProcessor.convert(sinhala, Script.roman);
    }
  }
}
