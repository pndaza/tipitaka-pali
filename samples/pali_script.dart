// Copyright Path Nirvana 2018
// The code and character mapping defined in this file can not be used for any commercial purposes.
// Permission from the auther is required for all other purposes.

// ported to dart by pndaza 2022

// total 17 languages
// scripts are ordered

enum Script {
  sinhala,
  devanagari,
  roman,
  thai,
  laos,
  myanmar,
  khmer,
  bengali,
  gurmukhi,
  taitham,
  gujarati,
  telugu,
  kannada,
  malayalam,
  brahmi,
  tibetan,
  cyrillic
}

class _CodePointRange {
  final int start;
  final int end;
  const _CodePointRange({
    required this.start,
    required this.end,
  });
}

class _ScriptInfo {
  final String name;
  final String nameInLocale;
  final String localeCode;
  final List<_CodePointRange> codePointRanges;
  const _ScriptInfo({
    required this.name,
    required this.nameInLocale,
    required this.localeCode,
    required this.codePointRanges,
  });
}

const Map<Script, _ScriptInfo> paliScriptInfos = {
  Script.sinhala: _ScriptInfo(
      name: 'Sinhala',
      nameInLocale: 'සිංහල',
      localeCode: 'si',
      codePointRanges: [_CodePointRange(start: 0x0D80, end: 0x0DFF)]),
  Script.devanagari: _ScriptInfo(
      name: 'Devanagari',
      nameInLocale: 'हिन्दी',
      localeCode: 'hi',
      codePointRanges: [_CodePointRange(start: 0x0900, end: 0x097F)]),
  Script.roman: _ScriptInfo(
      name: 'Roman',
      nameInLocale: 'Roman',
      localeCode: 'ro',
      codePointRanges: [
        _CodePointRange(start: 0x0000, end: 0x017F),
        _CodePointRange(start: 0x1E00, end: 0x1EFF),
      ]), // latin extended and latin extended additional blocks
  Script.thai: _ScriptInfo(
      name: 'Thai',
      nameInLocale: 'ไทย',
      localeCode: 'th',
      codePointRanges: [
        _CodePointRange(start: 0x0E00, end: 0x0E7F),
        _CodePointRange(start: 0xF70F, end: 0xF70F),
      ]),
  Script.laos: _ScriptInfo(
      name: 'Laos',
      nameInLocale: 'ລາວ',
      localeCode: 'lo',
      codePointRanges: [_CodePointRange(start: 0x0E80, end: 0x0EFF)]),
  Script.myanmar: _ScriptInfo(
      name: 'Myanmar',
      nameInLocale: 'ဗမာစာ',
      localeCode: 'my',
      codePointRanges: [_CodePointRange(start: 0x1000, end: 0x107F)]),
  Script.khmer: _ScriptInfo(
      name: 'Khmer',
      nameInLocale: 'ភាសាខ្មែរ',
      localeCode: 'km',
      codePointRanges: [_CodePointRange(start: 0x1780, end: 0x17FF)]),
  Script.bengali: _ScriptInfo(
      name: 'Bengali',
      nameInLocale: 'বাংলা',
      localeCode: 'be',
      codePointRanges: [_CodePointRange(start: 0x0980, end: 0x09FF)]),
  Script.gurmukhi: _ScriptInfo(
      name: 'Gurmukhi',
      nameInLocale: 'ਗੁਰਮੁਖੀ',
      localeCode: 'gm',
      codePointRanges: [_CodePointRange(start: 0x0A00, end: 0x0A7F)]),
  Script.taitham: _ScriptInfo(
      name: 'Tai Tham',
      nameInLocale: 'Tai Tham LN',
      localeCode: 'tt',
      codePointRanges: [_CodePointRange(start: 0x1A20, end: 0x1AAF)]),
  Script.gujarati: _ScriptInfo(
      name: 'Gujarati',
      nameInLocale: 'ગુજરાતી',
      localeCode: 'gj',
      codePointRanges: [_CodePointRange(start: 0x0A80, end: 0x0AFF)]),
  Script.telugu: _ScriptInfo(
      name: 'Telugu',
      nameInLocale: 'తెలుగు',
      localeCode: 'te',
      codePointRanges: [_CodePointRange(start: 0x0C00, end: 0x0C7F)]),
  Script.kannada: _ScriptInfo(
      name: 'Kannada',
      nameInLocale: 'ಕನ್ನಡ',
      localeCode: 'ka',
      codePointRanges: [_CodePointRange(start: 0x0C80, end: 0x0CFF)]),
  Script.malayalam: _ScriptInfo(
      name: 'Malayalam',
      nameInLocale: 'മലയാളം',
      localeCode: 'mm',
      codePointRanges: [_CodePointRange(start: 0x0D00, end: 0x0D7F)]),
  Script.brahmi:
      _ScriptInfo(name: 'Brahmi', nameInLocale: 'Brāhmī', localeCode: 'br',
          //charCodeAt returns two codes for each letter [[0x11000, 0x1107F]]
          codePointRanges: [
        _CodePointRange(start: 0xD804, end: 0xD804),
        _CodePointRange(start: 0xDC00, end: 0xDC7F),
      ]),
  Script.tibetan: _ScriptInfo(
      name: 'Tibetan',
      nameInLocale: 'བོད་སྐད།',
      localeCode: 'tb',
      codePointRanges: [_CodePointRange(start: 0x0F00, end: 0x0FFF)]),
  Script.cyrillic: _ScriptInfo(
      name: 'Cyrillic',
      nameInLocale: 'кириллица',
      localeCode: 'cy',
      codePointRanges: [
        _CodePointRange(start: 0x0400, end: 0x04FF),
        _CodePointRange(start: 0x0300, end: 0x036F),
      ]), //charCodeAt returns two codes for each letter [[0x11000, 0x1107F]]
};

Script? _getScriptForCode(int charCode) {
  for (final entry in paliScriptInfos.entries) {
    final ranges = entry.value.codePointRanges;
    for (final range in ranges) {
      if (charCode >= range.start && charCode <= range.end) {
        return entry.key;
      }
    }
  }
  return null;
}

const specials = [
  // independent vowels
  [
    'අ',
    'अ',
    'a',
    'อ',
    'ອ',
    'အ',
    'អ',
    'অ',
    'ਅ',
    '\u1A4B',
    'અ',
    'అ',
    'ಅ',
    'അ',
    '𑀅',
    'ཨ',
    'а'
  ],
  [
    'ආ',
    'आ',
    'ā',
    'อา',
    'ອາ',
    'အာ',
    'អា',
    'আ',
    'ਆ',
    '\u1A4C',
    'આ',
    'ఆ',
    'ಆ',
    'ആ',
    '𑀆',
    'ཨཱ',
    'а̄'
  ],
  [
    'ඉ',
    'इ',
    'i',
    'อิ',
    'ອິ',
    'ဣ',
    'ឥ',
    'ই',
    'ਇ',
    '\u1A4D',
    'ઇ',
    'ఇ',
    'ಇ',
    'ഇ',
    '𑀇',
    'ཨི',
    'и'
  ],
  [
    'ඊ',
    'ई',
    'ī',
    'อี',
    'ອີ',
    'ဤ',
    'ឦ',
    'ঈ',
    'ਈ',
    '\u1A4E',
    'ઈ',
    'ఈ',
    'ಈ',
    'ഈ',
    '𑀈',
    'ཨཱི',
    'ӣ'
  ],
  [
    'උ',
    'उ',
    'u',
    'อุ',
    'ອຸ',
    'ဥ',
    'ឧ',
    'উ',
    'ਉ',
    '\u1A4F',
    'ઉ',
    'ఉ',
    'ಉ',
    'ഉ',
    '𑀉',
    'ཨུ',
    'у'
  ],
  [
    'ඌ',
    'ऊ',
    'ū',
    'อู',
    'ອູ',
    'ဦ',
    'ឩ',
    'ঊ',
    'ਊ',
    '\u1A50',
    'ઊ',
    'ఊ',
    'ಊ',
    'ഊ',
    '𑀊',
    'ཨཱུ',
    'ӯ'
  ],
  [
    'එ',
    'ए',
    'e',
    'อเ',
    'ອເ',
    'ဧ',
    'ឯ',
    'এ',
    'ਏ',
    '\u1A51',
    'એ',
    'ఏ',
    'ಏ',
    'ഏ',
    '𑀏',
    'ཨེ',
    'е'
  ],
  [
    'ඔ',
    'ओ',
    'o',
    'อโ',
    'ອໂ',
    'ဩ',
    'ឱ',
    'ও',
    'ਓ',
    '\u1A52',
    'ઓ',
    'ఓ',
    'ಓ',
    'ഓ',
    '𑀑',
    'ཨོ',
    'о'
  ],
  // various signs
  [
    'ං',
    'ं',
    'ṃ',
    '\u0E4D',
    '\u0ECD',
    'ံ',
    'ំ',
    'ং',
    'ਂ',
    '\u1A74',
    'ં',
    'ం',
    'ಂ',
    'ം',
    '𑀁',
    '\u0F7E',
    'м̣'
  ], // niggahita - anusawara
  // visarga - not in pali but deva original text has it (thai/lao/tt - not found. using the closest equivalent per wikipedia)
  [
    'ඃ',
    'ः',
    'ḥ',
    'ะ',
    'ະ',
    'း',
    'ះ',
    'ঃ',
    'ਃ',
    '\u1A61',
    'ઃ',
    'ః',
    'ಃ',
    'ഃ',
    '𑀂',
    '\u0F7F',
    'х̣'
  ],
  // virama (al - hal). roman/cyrillic need special handling
  [
    '්',
    '्',
    '',
    '\u0E3A',
    '\u0EBA',
    '္',
    '្',
    '্',
    '੍',
    '\u1A60',
    '્',
    '్',
    '್',
    '്',
    '\uD804\uDC46',
    '\u0F84',
    ''
  ],
  // digits
  [
    '0',
    '०',
    '0',
    '๐',
    '໐',
    '၀',
    '០',
    '০',
    '੦',
    '\u1A90',
    '૦',
    '౦',
    '೦',
    '൦',
    '𑁦',
    '༠',
    '0'
  ],
  [
    '1',
    '१',
    '1',
    '๑',
    '໑',
    '၁',
    '១',
    '১',
    '੧',
    '\u1A91',
    '૧',
    '౧',
    '೧',
    '൧',
    '𑁧',
    '༡',
    '1'
  ],
  [
    '2',
    '२',
    '2',
    '๒',
    '໒',
    '၂',
    '២',
    '২',
    '੨',
    '\u1A92',
    '૨',
    '౨',
    '೨',
    '൨',
    '𑁨',
    '༢',
    '2'
  ],
  [
    '3',
    '३',
    '3',
    '๓',
    '໓',
    '၃',
    '៣',
    '৩',
    '੩',
    '\u1A93',
    '૩',
    '౩',
    '೩',
    '൩',
    '𑁩',
    '༣',
    '3'
  ],
  [
    '4',
    '४',
    '4',
    '๔',
    '໔',
    '၄',
    '៤',
    '৪',
    '੪',
    '\u1A94',
    '૪',
    '౪',
    '೪',
    '൪',
    '𑁪',
    '༤',
    '4'
  ],
  [
    '5',
    '५',
    '5',
    '๕',
    '໕',
    '၅',
    '៥',
    '৫',
    '੫',
    '\u1A95',
    '૫',
    '౫',
    '೫',
    '൫',
    '𑁫',
    '༥',
    '5'
  ],
  [
    '6',
    '६',
    '6',
    '๖',
    '໖',
    '၆',
    '៦',
    '৬',
    '੬',
    '\u1A96',
    '૬',
    '౬',
    '೬',
    '൬',
    '𑁬',
    '༦',
    '6'
  ],
  [
    '7',
    '७',
    '7',
    '๗',
    '໗',
    '၇',
    '៧',
    '৭',
    '੭',
    '\u1A97',
    '૭',
    '౭',
    '೭',
    '൭',
    '𑁭',
    '༧',
    '7'
  ],
  [
    '8',
    '८',
    '8',
    '๘',
    '໘',
    '၈',
    '៨',
    '৮',
    '੮',
    '\u1A98',
    '૮',
    '౮',
    '೮',
    '൮',
    '𑁮',
    '༨',
    '8'
  ],
  [
    '9',
    '९',
    '9',
    '๙',
    '໙',
    '၉',
    '៩',
    '৯',
    '੯',
    '\u1A99',
    '૯',
    '౯',
    '೯',
    '൯',
    '𑁯',
    '༩',
    '9'
  ]
];

const consos = [
  // velar stops
  [
    'ක',
    'क',
    'k',
    'ก',
    'ກ',
    'က',
    'ក',
    'ক',
    'ਕ',
    '\u1A20',
    'ક',
    'క',
    'ಕ',
    'ക',
    '𑀓',
    'ཀ',
    'к'
  ],
  [
    'ඛ',
    'ख',
    'kh',
    'ข',
    'ຂ',
    'ခ',
    'ខ',
    'খ',
    'ਖ',
    '\u1A21',
    'ખ',
    'ఖ',
    'ಖ',
    'ഖ',
    '𑀔',
    'ཁ',
    'кх'
  ],
  [
    'ග',
    'ग',
    'g',
    'ค',
    'ຄ',
    'ဂ',
    'គ',
    'গ',
    'ਗ',
    '\u1A23',
    'ગ',
    'గ',
    'ಗ',
    'ഗ',
    '𑀕',
    'ག',
    'г'
  ],
  [
    'ඝ',
    'घ',
    'gh',
    'ฆ',
    '\u0E86',
    'ဃ',
    'ឃ',
    'ঘ',
    'ਘ',
    '\u1A25',
    'ઘ',
    'ఘ',
    'ಘ',
    'ഘ',
    '𑀖',
    'གྷ',
    'гх'
  ],
  [
    'ඞ',
    'ङ',
    'ṅ',
    'ง',
    'ງ',
    'င',
    'ង',
    'ঙ',
    'ਙ',
    '\u1A26',
    'ઙ',
    'ఙ',
    'ಙ',
    'ങ',
    '𑀗',
    'ང',
    'н̇'
  ],
  // palatal stops
  [
    'ච',
    'च',
    'c',
    'จ',
    'ຈ',
    'စ',
    'ច',
    'চ',
    'ਚ',
    '\u1A27',
    'ચ',
    'చ',
    'ಚ',
    'ച',
    '𑀘',
    'ཙ',
    'ч'
  ],
  [
    'ඡ',
    'छ',
    'ch',
    'ฉ',
    '\u0E89',
    'ဆ',
    'ឆ',
    'ছ',
    'ਛ',
    '\u1A28',
    'છ',
    'ఛ',
    'ಛ',
    'ഛ',
    '𑀙',
    'ཚ',
    'чх'
  ],
  [
    'ජ',
    'ज',
    'j',
    'ช',
    'ຊ',
    'ဇ',
    'ជ',
    'জ',
    'ਜ',
    '\u1A29',
    'જ',
    'జ',
    'ಜ',
    'ജ',
    '𑀚',
    'ཛ',
    'дж'
  ],
  [
    'ඣ',
    'झ',
    'jh',
    'ฌ',
    '\u0E8C',
    'ဈ',
    'ឈ',
    'ঝ',
    'ਝ',
    '\u1A2B',
    'ઝ',
    'ఝ',
    'ಝ',
    'ഝ',
    '𑀛',
    'ཛྷ',
    'джх'
  ],
  [
    'ඤ',
    'ञ',
    'ñ',
    'ญ',
    '\u0E8E',
    'ဉ',
    'ញ',
    'ঞ',
    'ਞ',
    '\u1A2C',
    'ઞ',
    'ఞ',
    'ಞ',
    'ഞ',
    '𑀜',
    'ཉ',
    'н̃'
  ],
  // retroflex stops
  [
    'ට',
    'ट',
    'ṭ',
    'ฏ',
    '\u0E8F',
    'ဋ',
    'ដ',
    'ট',
    'ਟ',
    '\u1A2D',
    'ટ',
    'ట',
    'ಟ',
    'ട',
    '𑀝',
    'ཊ',
    'т̣'
  ],
  [
    'ඨ',
    'ठ',
    'ṭh',
    'ฐ',
    '\u0E90',
    'ဌ',
    'ឋ',
    'ঠ',
    'ਠ',
    '\u1A2E',
    'ઠ',
    'ఠ',
    'ಠ',
    'ഠ',
    '𑀞',
    'ཋ',
    'т̣х'
  ],
  [
    'ඩ',
    'ड',
    'ḍ',
    'ฑ',
    '\u0E91',
    'ဍ',
    'ឌ',
    'ড',
    'ਡ',
    '\u1A2F',
    'ડ',
    'డ',
    'ಡ',
    'ഡ',
    '𑀟',
    'ཌ',
    'д̣'
  ],
  [
    'ඪ',
    'ढ',
    'ḍh',
    'ฒ',
    '\u0E92',
    'ဎ',
    'ឍ',
    'ঢ',
    'ਢ',
    '\u1A30',
    'ઢ',
    'ఢ',
    'ಢ',
    'ഢ',
    '𑀠',
    'ཌྷ',
    'д̣х'
  ],
  [
    'ණ',
    'ण',
    'ṇ',
    'ณ',
    '\u0E93',
    'ဏ',
    'ណ',
    'ণ',
    'ਣ',
    '\u1A31',
    'ણ',
    'ణ',
    'ಣ',
    'ണ',
    '𑀡',
    'ཎ',
    'н̣'
  ],
  // dental stops
  [
    'ත',
    'त',
    't',
    'ต',
    'ຕ',
    'တ',
    'ត',
    'ত',
    'ਤ',
    '\u1A32',
    'ત',
    'త',
    'ತ',
    'ത',
    '𑀢',
    'ཏ',
    'т'
  ],
  [
    'ථ',
    'थ',
    'th',
    'ถ',
    'ຖ',
    'ထ',
    'ថ',
    'থ',
    'ਥ',
    '\u1A33',
    'થ',
    'థ',
    'ಥ',
    'ഥ',
    '𑀣',
    'ཐ',
    'тх'
  ],
  [
    'ද',
    'द',
    'd',
    'ท',
    'ທ',
    'ဒ',
    'ទ',
    'দ',
    'ਦ',
    '\u1A34',
    'દ',
    'ద',
    'ದ',
    'ദ',
    '𑀤',
    'ད',
    'д'
  ],
  [
    'ධ',
    'ध',
    'dh',
    'ธ',
    '\u0E98',
    'ဓ',
    'ធ',
    'ধ',
    'ਧ',
    '\u1A35',
    'ધ',
    'ధ',
    'ಧ',
    'ധ',
    '𑀥',
    'དྷ',
    'дх'
  ],
  [
    'න',
    'न',
    'n',
    'น',
    'ນ',
    'န',
    'ន',
    'ন',
    'ਨ',
    '\u1A36',
    'ન',
    'న',
    'ನ',
    'ന',
    '𑀦',
    'ན',
    'н'
  ],
  // labial stops
  [
    'ප',
    'प',
    'p',
    'ป',
    'ປ',
    'ပ',
    'ប',
    'প',
    'ਪ',
    '\u1A38',
    'પ',
    'ప',
    'ಪ',
    'പ',
    '𑀧',
    'པ',
    'п'
  ],
  [
    'ඵ',
    'फ',
    'ph',
    'ผ',
    'ຜ',
    'ဖ',
    'ផ',
    'ফ',
    'ਫ',
    '\u1A39',
    'ફ',
    'ఫ',
    'ಫ',
    'ഫ',
    '𑀨',
    'ཕ',
    'пх'
  ],
  [
    'බ',
    'ब',
    'b',
    'พ',
    'ພ',
    'ဗ',
    'ព',
    'ব',
    'ਬ',
    '\u1A3B',
    'બ',
    'బ',
    'ಬ',
    'ബ',
    '𑀩',
    'བ',
    'б'
  ],
  [
    'භ',
    'भ',
    'bh',
    'ภ',
    '\u0EA0',
    'ဘ',
    'ភ',
    'ভ',
    'ਭ',
    '\u1A3D',
    'ભ',
    'భ',
    'ಭ',
    'ഭ',
    '𑀪',
    'བྷ',
    'бх'
  ],
  [
    'ම',
    'म',
    'm',
    'ม',
    'ມ',
    'မ',
    'ម',
    'ম',
    'ਮ',
    '\u1A3E',
    'મ',
    'మ',
    'ಮ',
    'മ',
    '𑀫',
    'མ',
    'м'
  ],
  // liquids, fricatives, etc.
  [
    'ය',
    'य',
    'y',
    'ย',
    'ຍ',
    'ယ',
    'យ',
    'য',
    'ਯ',
    '\u1A3F',
    'ય',
    'య',
    'ಯ',
    'യ',
    '𑀬',
    'ཡ',
    'й'
  ],
  [
    'ර',
    'र',
    'r',
    'ร',
    'ຣ',
    'ရ',
    'រ',
    'র',
    'ਰ',
    '\u1A41',
    'ર',
    'ర',
    'ರ',
    'ര',
    '𑀭',
    'ར',
    'р'
  ],
  [
    'ල',
    'ल',
    'l',
    'ล',
    'ລ',
    'လ',
    'ល',
    'ল',
    'ਲ',
    '\u1A43',
    'લ',
    'ల',
    'ಲ',
    'ല',
    '𑀮',
    'ལ',
    'л'
  ],
  [
    'ළ',
    'ळ',
    'ḷ',
    'ฬ',
    '\u0EAC',
    'ဠ',
    'ឡ',
    'ল়',
    'ਲ਼',
    '\u1A4A',
    'ળ',
    'ళ',
    'ಳ',
    'ള',
    '𑀴',
    'ལ༹',
    'л̣'
  ],
  [
    'ව',
    'व',
    'v',
    'ว',
    'ວ',
    'ဝ',
    'វ',
    'ৰ',
    'ਵ',
    '\u1A45',
    'વ',
    'వ',
    'ವ',
    'വ',
    '𑀯',
    'ཝ',
    'в'
  ],
  [
    'ස',
    'स',
    's',
    'ส',
    'ສ',
    'သ',
    'ស',
    'স',
    'ਸ',
    '\u1A48',
    'સ',
    'స',
    'ಸ',
    'സ',
    '𑀲',
    'ས',
    'с'
  ],
  [
    'හ',
    'ह',
    'h',
    'ห',
    'ຫ',
    'ဟ',
    'ហ',
    'হ',
    'ਹ',
    '\u1A49',
    'હ',
    'హ',
    'ಹ',
    'ഹ',
    '𑀳',
    'ཧ',
    'х'
  ]
];

const vowels = [
  // dependent vowel signs 1A6E-1A63
  [
    'ා',
    'ा',
    'ā',
    'า',
    'າ',
    'ာ',
    'ា',
    'া',
    'ਾ',
    '\u1A63',
    'ા',
    'ా',
    'ಾ',
    'ാ',
    '𑀸',
    '\u0F71',
    'а̄'
  ],
  [
    'ි',
    'ि',
    'i',
    '\u0E34',
    '\u0EB4',
    'ိ',
    'ិ',
    'ি',
    'ਿ',
    '\u1A65',
    'િ',
    'ి',
    'ಿ',
    'ി',
    '𑀺',
    '\u0F72',
    'и'
  ],
  [
    'ී',
    'ी',
    'ī',
    '\u0E35',
    '\u0EB5',
    'ီ',
    'ី',
    'ী',
    'ੀ',
    '\u1A66',
    'ી',
    'ీ',
    'ೀ',
    'ീ',
    '𑀻',
    '\u0F71\u0F72',
    'ӣ'
  ],
  [
    'ු',
    'ु',
    'u',
    '\u0E38',
    '\u0EB8',
    'ု',
    'ុ',
    'ু',
    'ੁ',
    '\u1A69',
    'ુ',
    'ు',
    'ು',
    'ു',
    '𑀼',
    '\u0F74',
    'у'
  ],
  [
    'ූ',
    'ू',
    'ū',
    '\u0E39',
    '\u0EB9',
    'ူ',
    'ូ',
    'ূ',
    'ੂ',
    '\u1A6A',
    'ૂ',
    'ూ',
    'ೂ',
    'ൂ',
    '𑀽',
    '\u0F71\u0F74',
    'ӯ'
  ],
  [
    'ෙ',
    'े',
    'e',
    'เ',
    'ເ',
    'ေ',
    'េ',
    'ে',
    'ੇ',
    '\u1A6E',
    'ે',
    'ే',
    'ೇ',
    'േ',
    '𑁂',
    '\u0F7A',
    'е'
  ], //for th/lo - should appear in front
  [
    'ො',
    'ो',
    'o',
    'โ',
    'ໂ',
    'ော',
    'ោ',
    'ো',
    'ੋ',
    '\u1A6E\u1A63',
    'ો',
    'ో',
    'ೋ',
    'ോ',
    '𑁄',
    '\u0F7C',
    'о'
  ] //for th/lo - should appear in front
];
const sinhalaConsonantRange = 'ක-ෆ';
const thaiConsonantRange = 'ก-ฮ';
const laoConsonantRange = 'ກ-ຮ';
const myanmarConsonantRange = 'က-ဠ';

String beautifySinhala(String text, {Script? script, String rendType = ''}) {
  // change joiners before U+0DBA Yayanna and U+0DBB Rayanna to Virama + ZWJ
  return text.replaceAllMapped(RegExp('\u0DCA([\u0DBA\u0DBB])'),
      (match) => '\u0DCA\u200D${match.group(1)}');
}

String unbeautifySinhala(String text) {
  // long vowels replaced by short vowels as sometimes people type long vowels by mistake
  text = text.replaceAll('ඒ', 'එ').replaceAll('ඕ', 'ඔ');
  return text.replaceAll('ේ', 'ෙ').replaceAll('ෝ', 'ො');
}

String beautifyMyanmar(String text, {Script? script, String rendType = ''}) {
  // new unicode 5.1 spec https://www.unicode.org/notes/tn11/UTN11_3.pdf
  text = text.replaceAll('[,;]', '၊'); // comma/semicolon -> single line
  text = text.replaceAll('[\u2026\u0964\u0965]+',
      '။'); // ellipsis/danda/double danda -> double line
  text = text.replaceAll('ဉ\u1039ဉ', 'ည'); // kn + kna has a single char
  text =
      text.replaceAll('သ\u1039သ', 'ဿ'); // s + sa has a single char (great sa)
  text = text.replaceAllMapped(RegExp('င္([က-ဠ])'),
      (match) => 'င\u103A္${match.group(1)}'); // kinzi - ඞ + al
  text = text.replaceAll('္ယ', 'ျ'); // yansaya  - yapin
  text = text.replaceAll('္ရ', 'ြ'); // rakar - yayit
  text = text.replaceAll('္ဝ', 'ွ'); // al + wa - wahswe
  text = text.replaceAll('္ဟ', 'ှ'); // al + ha - hahto
  // following code for tall aa is from https://www.facebook.com/pndaza.mlm
  text = text.replaceAllMapped(RegExp('([ခဂငဒပဝ]ေ?)\u102c'),
      (match) => "${match.group(1)}\u102b"); // aa to tall aa
  text = text.replaceAllMapped(
      RegExp('(က္ခ|န္ဒ|ပ္ပ|မ္ပ)(ေ?)\u102b'),
      (match) =>
          "${match.group(1)}${match.group(2)}\u102c"); // restore back tall aa to aa for some pattern
  text = text.replaceAllMapped(RegExp('(ဒ္ဓ|ဒွ)(ေ?)\u102c'),
      (match) => "${match.group(1)}${match.group(2)}\u102b");
  return text.replaceAll('သင်္ဃ', 'သံဃ');
}

String unbeautifyMyanmar(String text) {
  // reverse of beautify above
  text = text.replaceAll('\u102B', 'ာ');
  text = text.replaceAll('ှ', '္ဟ'); // al + ha - hahto
  text = text.replaceAll('ွ', '္ဝ'); // al + wa - wahswe
  text = text.replaceAll('ြ', '္ရ'); // rakar - yayit
  text = text.replaceAll('ျ', '္ယ'); // yansaya  - yapin
  text = text.replaceAll('\u103A', ''); // kinzi
  text =
      text.replaceAll('ဿ', 'သ\u1039သ'); // s + sa has a single char (great sa)
  text = text.replaceAll('ည', 'ဉ\u1039ဉ'); // nnga
  text = text.replaceAll('သံဃ',
      'သင္ဃ'); // nigghahita to ṅ for this word for searching - from Pn Daza

  text = text.replaceAll('၊', ','); // single line -> comma
  return text.replaceAll('။', '.'); // double line -> period
}

/// Each script need additional steps when rendering on screen
/// e.g. for sinh needs converting dandas/abbrev, removing spaces, and addition ZWJ

String beautifyCommon(String text, {Script? script, String rendType = ''}) {
  if (rendType == 'cen') {
    // remove double dandas around namo tassa
    text = text.replaceAll('॥', '');
  } else if (rendType.startsWith('ga')) {
    // in gathas, single dandas convert to semicolon, double to period
    text = text.replaceAll('।', ';');
    text = text.replaceAll('॥', '.');
  }

  // remove Dev abbreviation sign before an ellipsis. We don't want a 4th dot after pe.
  text = text.replaceAll('॰…', '…');

  text = text.replaceAll(
      '॰', '·'); // abbre sign changed - prevent capitalization in notes
  text = text.replaceAll(
      '[।॥]', '.'); //all other single and double dandas converted to period

  // cleanup punctuation 1) two spaces to one
  // 2) There should be no spaces before these punctuation marks.
  text = text.replaceAllMapped(
      RegExp('\\s([\\s,!;\\?\\.])'), (match) => '${match.group(1)}');
  return text;
}

// for roman text only
String capitalize(String text, {Script? script, String rendType = ''}) {
  // not works for html text

  /*
  // the adding of <w> tags around the words before the beautification makes it harder - (?:<w>)? added
  // begining of a line
  text = text.replaceAllMapped(
      RegExp(r'^((?:<w>)?\S)'), (match) => match.group(1)!.toUpperCase());
  // beginning of sentence
  text = text.replaceAllMapped(RegExp(r'([\.\?]\s(?:<w>)?)(\S)'),
      (match) => '${match.group(1)}${match.group(2)!.toUpperCase()}');
  // starting from a quote
  text = text.replaceAllMapped(RegExp(r'([\u201C‘](?:<w>)?)(\S)'),
      (match) => '${match.group(1)}${match.group(2)!.toUpperCase()}');
*/
  return text;
}

String unCapitalize(String text) => text.toLowerCase();
// for thai text - this can also be done in the convert stage

String swap_e_o(String text, {Script? script, String rendType = ''}) {
  if (script == Script.thai) {
    return text.replaceAllMapped(RegExp('([ก-ฮ])([เโ])'),
        (match) => '${match.group(2)}${match.group(1)}');
  }
  if (script == Script.laos) {
    return text.replaceAllMapped(RegExp('([ກ-ຮ])([ເໂ])'),
        (match) => '${match.group(2)}${match.group(1)}');
  }
  return text;
  // throw new Error(`Unsupported script ${script} for swap_e_o method.`);
}

// to be used when converting from
String un_swap_e_o(String text, {Script? script}) {
  if (script == Script.thai) {
    return text.replaceAllMapped(RegExp('([เโ])([ก-ฮ])'),
        (match) => '${match.group(2)}${match.group(1)}');
  }
  if (script == Script.laos) {
    return text.replaceAllMapped(RegExp('([ເໂ])([ກ-ຮ])'),
        (match) => '${match.group(2)}${match.group(1)}');
  }
  return text;
  // throw new Error(`Unsupported script ${script} for un_swap_e_o method.`);
}

// in thai pali these two characters have special glyphs (using the encoding used in the THSarabunNew Font)
String beautifyThai(String text, {Script? script}) {
  // 'iṃ' has a single unicode in thai
  text = text.replaceAll('\u0E34\u0E4D', '\u0E36');
  text = text.replaceAll('ญ', '\uF70F');
  return text.replaceAll('ฐ', '\uF700');
}

String unbeautifyThai(String text, {Script? script}) {
  // sometimes people use ฎ instead of the correct ฏ which is used in the tipitaka
  text = text.replaceAll('ฎ', 'ฏ');
  // 'iṃ' has a single unicode in thai which is split into two here
  text = text.replaceAll('\u0E36', '\u0E34\u0E4D');
  text = text.replaceAll('\uF70F', 'ญ');
  return text.replaceAll('\uF700', 'ฐ');
}

String unbeautifykhmer(String text, {Script? script}) {
  // 'iṃ' has a single unicode in khmer which is split into two here
  text = text.replaceAll('\u17B9', '\u17B7\u17C6');
  // end of word virama is different in khmer
  return text.replaceAll('\u17D1', '\u17D2');
}

/* zero-width joiners - replace both ways
['\u200C', ''], // ZWNJ (remove) not in sinh (or deva?)
['\u200D', ''], // ZWJ (remove) will be added when displaying*/
String cleanupZWJ(String inputText) {
  return inputText.replaceAll(RegExp('\u200C|\u200D'), '');
}

String beautifyBrahmi(String text, {Script? script}) {
  // just replace deva danda with brahmi danda
  text = text.replaceAll('।', '𑁇');
  text = text.replaceAll('॥', '𑁈');
  return text.replaceAll('–', '𑁋');
}

String beautifyTham(String text, {Script? script}) {
  // todo - unbeautify needed
  text = text.replaceAll('\u1A60\u1A41', '\u1A55'); // medial ra - rakar
  text = text.replaceAll('\u1A48\u1A60\u1A48', '\u1A54'); // great sa - ssa
  text = text.replaceAll('।', '\u1AA8');
  return text.replaceAll('॥', '\u1AA9');
}

String beautifyTibet(String text, {Script? script}) {
  // copied form csharp - consider removing subjoined as it makes it hard to read
  // not adding the intersyllabic tsheg between "syllables" (done in csharp code) since no visible change
  text = text.replaceAll('।', '།'); // tibet dandas
  text = text.replaceAll('॥', '༎');
  // Iterate over all of the consonants, looking for tibetan halant + consonant.
  // Replace with the corresponding subjoined consonant (without halant)
  for (int i = 0; i <= 39; i++) {
    final String source =
        String.fromCharCode(0x0F84) + String.fromCharCode(0x0F40 + i);
    text = text.replaceAll(RegExp(source), String.fromCharCode(0x0F90 + i));
  }
  // exceptions: yya and vva use the "fixed-form subjoined consonants as the 2nd one
  text = text.replaceAll('\u0F61\u0FB1', '\u0F61\u0FBB'); //yya
  text = text.replaceAll('\u0F5D\u0FAD', '\u0F5D\u0FBA'); //vva

  // exceptions: jjha, yha and vha use explicit (visible) halant between
  text = text.replaceAll('\u0F5B\u0FAC', '\u0F5B\u0F84\u0F5C'); //jjha
  text = text.replaceAll('\u0F61\u0FB7', '\u0F61\u0F84\u0F67'); //yha
  return text.replaceAll('\u0F5D\u0FB7', '\u0F5D\u0F84\u0F67'); //vha
}

String unbeautifyTibet(String text, {Script? script}) {
  return text; // todo undo the subjoining done above
}

List<Function> beautifyFunc(Script script) {
  switch (script) {
    case Script.sinhala:
      return [beautifySinhala, beautifyCommon];
    case Script.roman:
      return [beautifyCommon, capitalize];
    case Script.thai:
      return [swap_e_o, beautifyThai, beautifyCommon];
    case Script.laos:
      return [swap_e_o, beautifyCommon];
    case Script.myanmar:
      return [beautifyMyanmar, beautifyCommon];
    case Script.khmer:
      return [beautifyCommon];
    case Script.taitham:
      return [beautifyTham];
    case Script.gujarati:
      return [beautifyCommon];
    case Script.telugu:
      return [beautifyCommon];
    case Script.malayalam:
      return [beautifyCommon];
    case Script.brahmi:
      return [beautifyBrahmi, beautifyCommon];
    case Script.tibetan:
      return [beautifyTibet];
    case Script.cyrillic:
      return [beautifyCommon];
    default:
      return [];
  }
}

List<Function> unbeautifyFucn(Script script) {
  switch (script) {
    case Script.sinhala:
      return [cleanupZWJ, unbeautifySinhala];
    case Script.devanagari:
      // original deva script (from tipitaka.org) text has zwj
      return [cleanupZWJ];
    case Script.roman:
      return [unCapitalize];
    case Script.thai:
      return [unbeautifyThai, un_swap_e_o];
    case Script.laos:
      return [un_swap_e_o];
    case Script.khmer:
      return [unbeautifykhmer];
    case Script.myanmar:
      return [unbeautifyMyanmar];
    case Script.tibetan:
      return [unbeautifyTibet];
    default:
      return [];
  }
}

List<List<Object>> prepareHashMaps(int fromIndex, int toIndex,
    [bool useVowels = true]) {
  var _vowels = useVowels ? vowels : [];
  final List<List<String>> fullAr = [...consos, ...specials, ..._vowels];
  final List<List<List<String>>> finalAr = [[], [], []];
  for (List<String> val in fullAr) {
    if (val[fromIndex].isNotEmpty) {
      // empty mapping - e.g in roman
      finalAr[val[fromIndex].length - 1].add([val[fromIndex], val[toIndex]]);
    }
  }
  finalAr.where((element) => element.isNotEmpty).toList();
  return List.from(finalAr
      .where((element) => element.isNotEmpty)
      .toList()
      .map((element) => [
            element[0][0].length,
            {for (var v in element) v[0]: v[1]}
          ])
      .toList()
      .reversed); // longest is first
}

String replaceByMaps(String inputText, List<List<Object>> hashMaps) {
  var outputAr = [];
  int start = 0;
  int length = inputText.length;
  // print('input count: $length');

  while (start < length) {
    var match = false;
    for (var element in hashMaps) {
      final len = element[0] as int;
      final hashMap = element[1] as Map<String, String>;
      final end = start + len <= length ? start + len : start + 1;
      // print('b: $start');
      // print('len: $len');
      final inChars = inputText.substring(start, end);
      // print('inChars: $inChars');
      // print(hashMap);
      if (hashMap.containsKey(inChars)) {
        outputAr.add(hashMap[inChars]); // note: can be empty string too
        match = true;
        start += len;
        break;
      }
    }
    if (!match) {
      // did not match the hashmaps
      outputAr.add(inputText[start]);
      start++;
    }
  }
  return outputAr.join('');
}

// for roman/cyrl text - insert 'a' after all consonants that are not followed by virama, dependent vowel or 'a'
// cyrillic mapping extracted from https://dhamma.ru/scripts/transdisp.js - TODO capitalize cyrl too
String insert_a(String text, Script script) {
  final a = (script == Script.cyrillic) ? '\u0430' : 'a'; // roman a or cyrl a
  text = text.replaceAllMapped(RegExp('([ක-ෆ])([^\u0DCF-\u0DDF\u0DCA$a])'),
      (match) => '${match.group(1)}$a${match.group(2)}');
  text = text.replaceAllMapped(RegExp('([ක-ෆ])([^\u0DCF-\u0DDF\u0DCA$a])'),
      (match) => '${match.group(1)}$a${match.group(2)}');
  // conso at the end of string not matched by regex above
  return text.replaceAllMapped(
      RegExp(r'([ක-ෆ])$'), (match) => '${match.group(1)}$a');
}

const IV_TO_DV = {
  'අ': '',
  'ආ': 'ා',
  'ඉ': 'ි',
  'ඊ': 'ී',
  'උ': 'ු',
  'ඌ': 'ූ',
  'එ': 'ෙ',
  'ඔ': 'ො'
};
String remove_a(String text, Script script) {
  text = text.replaceAllMapped(RegExp('([ක-ෆ])([^අආඉඊඋඌඑඔ\u0DCA])'),
      (match) => '${match.group(1)}\u0DCA${match.group(2)}');
  // done twice to match successive hal
  text = text.replaceAllMapped(RegExp('([ක-ෆ])([^අආඉඊඋඌඑඔ\u0DCA])'),
      (match) => '${match.group(1)}\u0DCA${match.group(2)}');
  text = text.replaceAllMapped(RegExp(r'([ක-ෆ])$'),
      (match) => '${match.group(1)}\u0DCA'); // last conso not matched by above
  text = text.replaceAllMapped(RegExp(r'([ක-ෆ])([අආඉඊඋඌඑඔ])'),
      (match) => '${match.group(1)}${IV_TO_DV[match.group(2)]}');
  return text;
}

// per ven anandajothi request
String fix_m_above(String text, Script script) {
  return text.replaceAll('ṁ', 'ං');
}

List<Function> convertToFunc(Script script) {
  switch (script) {
    case Script.sinhala:
      return [];
    case Script.roman:
      return [insert_a, _convertTo];
    case Script.cyrillic:
      return [insert_a, _convertTo];
    default:
      return [_convertTo];
  }
}

List<Function> convertFromFunc(Script script) {
  switch (script) {
    case Script.sinhala:
      return [];
    case Script.roman:
      return [convert_from_w_v, fix_m_above, remove_a];
    case Script.cyrillic:
      return [convert_from_w_v, remove_a];
    default:
      return [_convertFrom];
  }
}

String _convertTo(String text, Script script) {
  final hashMaps = prepareHashMaps(Script.sinhala.index, script.index);
  return replaceByMaps(text, hashMaps);
}

String _convertFrom(String text, Script script) {
  // TODO create maps initially and reuse them
  final hashMaps = prepareHashMaps(script.index, Script.sinhala.index);
  return replaceByMaps(text, hashMaps);
}

String convert_from_w_v(String text, Script script) {
  // without vowels for roman
  final hashMaps = prepareHashMaps(script.index, Script.sinhala.index, false);
  return replaceByMaps(text, hashMaps);
}

class TextProcessor {
  TextProcessor._();
  // convert from sinhala to another script
  static basicConvert(String text, Script script) {
    convertToFunc(script).forEach((func) => text = func(text, script));
    // (convert_to_func[script] || convert_to_func_default).forEach(func => text = func(text, script));
    return text;
  }

  // convert from another script to sinhala
  static basicConvertFrom(String text, Script script) {
    convertFromFunc(script).forEach((func) => text = func(text, script));
    // (convert_from_func[script] || convert_from_func_default).forEach(func => text = func(text, script));
    return text;
  }

  // script specific beautification
  static beautify(String text, Script script, {String rendType = ''}) {
    beautifyFunc(script).forEach((func) => text = func(text, script: script));
    // (beautify_func[script] || beautify_func_default).forEach(func => text = func(text, script, rendType));
    return text;
  }

  // from Sinhala to other script
  static convert(String text, Script script) {
    text = basicConvert(text, script);
    text = cleanupZWJ(text);
    return beautify(text, script);
  }

  // from other script to Sinhala - one script
  static convertFrom(String text, Script script) {
    unbeautifyFucn(script).forEach((func) => text = func(text));
    // (un_beautify_func[script] || un_beautify_func_default).forEach(func => text = func(text, script));
    return basicConvertFrom(text, script);
  }

  // from other scripts (mixed) to Sinhala
  static convertFromMixed(String mixedText) {
    // zwj messes with computing runs + hack to process last char
    mixedText = cleanupZWJ(mixedText) + ' ';
    Script? curScript;
    String run = '', output = '';
    for (int i = 0, length = mixedText.length; i < length; i++) {
      final newScript = _getScriptForCode(mixedText.codeUnitAt(i));
      if (newScript != curScript || (i == mixedText.length - 1)) {
        // make sure to process the last run
        output += convertFrom(run, curScript!);
        curScript = newScript;
        run = mixedText[i];
      } else {
        run += mixedText[i];
      }
    }
    return output;
  }
}
