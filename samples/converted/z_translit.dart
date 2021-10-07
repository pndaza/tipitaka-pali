String performRegex(Map<String, String> regexMap, String input) {
  regexMap.entries.forEach((pair) {
    input = input.replaceAllMapped(RegExp(pair.key), (match) {
      return pair.value;
    });
  });
  return input;
}

String toUni(String input) {
  var nigahita = 'ṃ';
  var capitalNigahita = 'Ṃ';
  if (input.isEmpty) return input;
  Map<String, String> regexMap = {
    r'aa': 'ā',
    r'ii': 'ī',
    r'uu': 'ū',
    r'.t': 'ṭ',
    r'.d': 'ḍ',
    r'"nk': 'ṅk',
    r'"ng': 'ṅg',
    r'.n': 'ṇ',
    r'.m': nigahita,
    '\u1E41': nigahita,
    r'~n': 'ñ',
    r'.l': 'ḷ',
    r'AA': 'Ā',
    r'II': 'Ī',
    r'UU': 'Ū',
    r'.T': 'Ṭ',
    r'.D': 'Ḍ',
    r'"N': 'Ṅ',
    r'.N': 'Ṇ',
    r'.M': capitalNigahita,
    r'~N': 'Ñ',
    r'.L': 'Ḷ',
    r'.ll': 'ḹ',
    r'.r': 'ṛ',
    r'.rr': 'ṝ',
    r'.s': 'ṣ',
    r'"s': 'ś',
    r'.h': 'ḥ',
  };
  return performRegex(regexMap, input);
}

String toVel(String input) {
  if (input.isEmpty) return input;
  Map<String, String> regexMap = {
    // r'"': '"',
    r'\u0101': 'aa',
    r'\u012B': 'ii',
    r'\u016B': 'uu',
    r'\u1E6D': '.t',
    r'\u1E0D': '.d',
    r'\u1E45': '"n',
    r'\u1E47': '.n',
    r'\u1E43': '.m',
    r'\u1E41': '.m',
    r'\u00F1': '\~n',
    r'\u1E37': '.l',
    r'\u0100': 'AA',
    r'\u012A': 'II',
    r'\u016A': 'UU',
    r'\u1E6C': '.T',
    r'\u1E0C': '.D',
    r'\u1E44': '"N',
    r'\u1E46': '.N',
    r'\u1E42': '.M',
    r'\u00D1': '\~N',
    r'\u1E36': '.L',
    r'ḹ': '.ll',
    r'ṛ': '.r',
    r'ṝ': '.rr',
    r'ṣ': '.s',
    r'ś': '"s',
    r'ḥ': '.h',
  };
  return performRegex(regexMap, input);
}
