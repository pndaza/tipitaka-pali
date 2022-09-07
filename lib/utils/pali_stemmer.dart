class PaliStemmer {
  static String getStem(String word) {
    String stemWord = word.trim();
    // remove punctuation
    stemWord =
        stemWord.replaceAll(RegExp(r'[\u104a\u104b\u2018\u2019",\.\?]'), '');

    // various ending of pada
    List<RegExp> endings = [];

    // endings.add(new RegExp(r'\u1031\u1014$')); // ena ေန
    // endings.add(new RegExp(r'\u1031[\u101f\u1018]\u102d$')); // ehi ebhi ေဟိ ေဘိ
    //endings.add(new RegExp(r'\u103f$')); // ssa ဿ

    endings.add(RegExp(r'ena$')); // ena ေန
    endings.add(RegExp(r'e(h|bh)i$')); // ehi ebhi ေဟိ ေဘိ
    endings.add(RegExp(r'ssa$')); // ssa ဿ
    // naṃ (နံ) preceded by vowel ā or ī or ū
    // first, will find with dīgha vowel in dict
    // if not find , convert to rassa vowel and will find again
    /*
    endings.add(new RegExp(r'(?<=[\u102b\u102c\u102e\u1030])\u1014\u1036$'));
    endings.add(new RegExp(r'\u101e\u1039\u1019\u102c$')); // smā သ္မာ
    endings.add(new RegExp(r'\u1019\u103e\u102c$')); // mhā မှာ
    endings.add(new RegExp(r'\u101e\u1039\u1019\u102d\u1036$')); // smiṃ သ္မိံ
    endings.add(new RegExp(r'\u1019\u103e\u102d$')); // mhi မှိ
    endings.add(new RegExp(r'\u1031\u101e\u102f$')); // esu ေသု
    */

    endings.add(RegExp(r'(?<=[āīū])naṃ$'));
    endings.add(RegExp(r'smāc$')); // smā သ္မာ
    endings.add(RegExp(r'mhā$')); // mhā မှာ
    endings.add(RegExp(r'smiṃ$')); // smiṃ သ္မိံ
    endings.add(RegExp(r'mhi$')); // mhi မှိ
    endings.add(RegExp(r'esu$')); // esu ေသု
    // cittādigana
    endings.add(RegExp(r'[\u102b\u102c]\u1014\u102d$')); // āni ါနိ /  ာနိ
    endings.add(RegExp(r'āni$')); // āni ါနိ /  ာနိ
    // kannādigana etc
    // endings.add(new RegExp(
    //    r'(?<=[\u102b\u102c\u102d])\u101a\u1031\u102c$')); // āyo ါယော or ာယော
    endings.add(RegExp(r'(?<=ā)yo$')); // āyo ါယော or ာယော
    // endings.add(new RegExp(r'(?<=[\u102d])\u101a\u102c$')); // iyā ိယာ
    endings.add(RegExp(r'(?<=i)yā$')); // iyā ိယာ
    // endings.add(new RegExp(
    //     r'(?<=[\u102b\u102c])\u101a\u1036?$')); //  āya or āyaṃ  ါယ or ါယံ or ာယ or ာယံ
    endings.add(RegExp(r'(?<=ā)yaṃ?$')); //  āya or āyaṃ  ါယ or ါယံ or ာယ or ာယံ
    // su (သု) preceded by vowel ā or ī or ū
    // first, will find with dīgha vowel in dict
    // if not find , convert to rassa vowel and will find again
    // endings.add(new RegExp(
    //     r'(?<=[\u102b\u102c\u102d\u102e\u102f\u1030])\u101e\u102f?$'));
    endings.add(RegExp(r'(?<=[āiīuū])su$'));

    /*
    endings.add(new RegExp(r'\u1031[\u102b\u102c]$')); // dependent vowel O ော
    endings.add(new RegExp(r'\u1031$')); // dependent vowel E ေ
    endings.add(new RegExp(r'\u1036$')); // niggahita ṃ ံ
    */
    endings.add(RegExp(r'o$')); // dependent vowel o  ော
    endings.add(RegExp(r'e$')); // dependent vowel E ေ
    //endings.add(RegExp(r'ṃ$')); // niggahita ṃ ံ

    for (RegExp ending in endings) {
      if (ending.hasMatch(stemWord)) {
        stemWord = stemWord.replaceAll(ending, 'a');
        break;
      }
    }
    // fix for nigahitta in roman  for cittaṃ
    if (stemWord.endsWith("ṃ")) {
      stemWord = stemWord.substring(0, stemWord.length - 1);
    }
    return stemWord;
  }

  static bool isEndWithRassa(String word) {
    // return new RegExp(r'[\u1000-\u1020\u102d\u102f]').hasMatch(word);
    return RegExp(r'[aiu]').hasMatch(word);
  }

  static bool isEndWithDigha(String word) {
    // return new RegExp(r'[\u102b\u102c\u102e\u1030]').hasMatch(word);
    return RegExp(r'[āīū]').hasMatch(word);
  }

/*
  static String convertToDigha(String word) {
    String _word = word;
    int length = _word.length;

    if (word.endsWith('\u102d')) {
      _word = _word.substring(0, length - 1) + "\u102e";
    } else if (word.endsWith("\u102f")) {
      _word = _word.substring(0, length - 1) + "\u1030";
    } else {
      // TODO to insert suitable shape of dependent vowel ā
      String lastChar = _word.substring(length - 1, length);
      if ("ခဂဒပဝ".contains(lastChar))
        _word = _word + "\u102b";
      else
        _word = _word + "\u102c";
    }
*/
  static String convertToDigha(String word) {
    String _word = word;
    int length = _word.length;

    var vowelPair = {
      'a': 'ā',
      'i': 'ī',
      'u': 'ū',
    };
    String? lastVowel = vowelPair[_word[length - 1]];

    return _word.substring(0, length - 1) + lastVowel!;
  }

/*
  static String convertToRassa(String word) {
    String _word = word;
    int length = _word.length;

    if (word.endsWith("\u102e")) {
      _word = _word.substring(0, length - 1) + "\u102d";
    } else if (word.endsWith("\u1030")) {
      _word = _word.substring(0, length - 1) + "\u102f";
    } else {
      _word = _word.substring(0, length - 1);
    }

    return _word;
  }
*/
  static String convertToRassa(String word) {
    String _word = word;
    int length = _word.length;

    var vowelPair = {
      'ā': 'a',
      'ī': 'u',
      'ū': 'u',
    };
    String? lastVowel = vowelPair[_word[length - 1]];
    return _word.substring(0, length - 1) + lastVowel!;
  }
}
