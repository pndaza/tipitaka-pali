import 'package:flutter/material.dart';

import 'unicode_pali_letters.dart';

String toUni(String input) {
  if (input.isEmpty) return input;

  return input
      .replaceAll(r'aa', 'ā')
      .replaceAll(r'ii', 'ī')
      .replaceAll(r'uu', 'ū')
      .replaceAll(r'.t', 'ṭ')
      .replaceAll(r'.d', 'ḍ')
      .replaceAll(r'"nk', 'ṅk')
      .replaceAll(r'"ng', 'ṅg')
      .replaceAll(r'.n', 'ṇ')
      .replaceAll(r'.m', UnicodePali.lowerNigahita)
      .replaceAll(r'\u1E41', UnicodePali.lowerNigahita)
      .replaceAll(r'~n', 'ñ')
      .replaceAll(r'.l', 'ḷ')
      .replaceAll(r'AA', 'Ā')
      .replaceAll(r'II', 'Ī')
      .replaceAll(r'UU', 'Ū')
      .replaceAll(r'.T', 'Ṭ')
      .replaceAll(r'.D', 'Ḍ')
      .replaceAll(r'"N', 'Ṅ')
      .replaceAll(r'.N', 'Ṇ')
      .replaceAll(r'.M', UnicodePali.upperNigahita)
      .replaceAll(r'~N', 'Ñ')
      .replaceAll(r'.L', 'Ḷ')
      .replaceAll(r'.ll', 'ḹ')
      .replaceAll(r'.r', 'ṛ')
      .replaceAll(r'.rr', 'ṝ')
      .replaceAll(r'.s', 'ṣ')
      .replaceAll(r'"s', 'ś')
      .replaceAll(r'.h', 'ḥ');
}

String toVel(String input) {
  if (input.isEmpty) return input;
  return input
      .replaceAll(r'"', '"')
      .replaceAll(r'\u0101', 'aa')
      .replaceAll(r'\u012B', 'ii')
      .replaceAll(r'\u016B', 'uu')
      .replaceAll(r'\u1E6D', '.t')
      .replaceAll(r'\u1E0D', '.d')
      .replaceAll(r'\u1E45', '"n')
      .replaceAll(r'\u1E47', '.n')
      .replaceAll(r'\u1E43', '.m')
      .replaceAll(r'\u1E41', '.m')
      .replaceAll(r'\u00F1', '~n')
      .replaceAll(r'\u1E37', '.l')
      .replaceAll(r'\u0100', 'AA')
      .replaceAll(r'\u012A', 'II')
      .replaceAll(r'\u016A', 'UU')
      .replaceAll(r'\u1E6C', '.T')
      .replaceAll(r'\u1E0C', '.D')
      .replaceAll(r'\u1E44', '"N')
      .replaceAll(r'\u1E46', '.N')
      .replaceAll(r'\u1E42', '.M')
      .replaceAll(r'\u00D1', '~N')
      .replaceAll(r'\u1E36', '.L')
      .replaceAll(r'ḹ', '.ll')
      .replaceAll(r'ṛ', '.r')
      .replaceAll(r'ṝ', '.rr')
      .replaceAll(r'ṣ', '.s')
      .replaceAll(r'ś', '"s')
      .replaceAll(r'ḥ', '.h');
}

String toVelRegEx(String input) {
  if (input.isEmpty) return input;
  return input
      .replaceAll(r'\u0101', 'aa')
      .replaceAll(r'\u012B', 'ii')
      .replaceAll(r'\u016B', 'uu')
      .replaceAll(r'\u1E6D', '\\.t')
      .replaceAll(r'\u1E0D', '\\.d')
      .replaceAll(r'\u1E45', '"n')
      .replaceAll(r'\u1E47', '\\.n')
      .replaceAll(r'\u1E43', '\\.m')
      .replaceAll(r'\u1E41', '\\.m')
      .replaceAll(r'\u00F1', '~n')
      .replaceAll(r'\u1E37', '\\.l')
      .replaceAll(r'\u0100', 'AA')
      .replaceAll(r'\u012A', 'II')
      .replaceAll(r'\u016A', 'UU')
      .replaceAll(r'\u1E6C', '\\.T')
      .replaceAll(r'\u1E0C', '\\.D')
      .replaceAll(r'\u1E44', '"N')
      .replaceAll(r'\u1E46', '\\.N')
      .replaceAll(r'\u1E42', '\\.M')
      .replaceAll(r'\u00D1', '~N')
      .replaceAll(r'\u1E36', '\\.L');
}

String toFuzzy(String input) {
  if (input.isEmpty) return input;
  return toVel(input)
      .replaceAllMapped(r'\.([tdnlmTDNLM])', (match) => match.group(0) ?? '')
      .replaceAllMapped(r'~([nN])', (match) => match.group(0) ?? '')
      .replaceAllMapped(r'([nN])', (match) => match.group(0) ?? '')
      .replaceAll(r'aa', 'a')
      .replaceAll(r'ii', 'i')
      .replaceAll(r'uu', 'u')
      .replaceAll(r'nn', 'n')
      .replaceAll(r'mm', 'm')
      .replaceAll(r'yy', 'y')
      .replaceAll(r'll', 'l')
      .replaceAll(r'ss', 's')
      .replaceAllMapped(
          r'([kgcjtdpb])[kgcjtdpb]{0,1}h*', (match) => match.group(0) ?? '');
}

String toSkt(String input, bool rv) {
  if (input.isEmpty) return input;

  if (rv) {
    return input
        .replaceAll(r'A', 'aa')
        .replaceAll(r'I', 'ii')
        .replaceAll(r'U', 'uu')
        .replaceAll(r'f', '.r')
        .replaceAll(r'F', '.rr')
        .replaceAll(r'x', '.l')
        .replaceAll(r'X', '.ll')
        .replaceAll(r'E', 'ai')
        .replaceAll(r'O', 'au')
        .replaceAll(r'K', 'kh')
        .replaceAll(r'G', 'gh')
        .replaceAll(r'N', '"n')
        .replaceAll(r'C', 'ch')
        .replaceAll(r'J', 'jh')
        .replaceAll(r'Y', '~n')
        .replaceAll(r'w', '.t')
        .replaceAll(r'q', '.d')
        .replaceAll(r'W', '.th')
        .replaceAll(r'Q', '.dh')
        .replaceAll(r'R', '.n')
        .replaceAll(r'T', 'th')
        .replaceAll(r'D', 'dh')
        .replaceAll(r'P', 'ph')
        .replaceAll(r'B', 'bh')
        .replaceAll(r'S', '"s')
        .replaceAll(r'z', '.s')
        .replaceAll(r'M', '.m')
        .replaceAll(r'H', '.h');
  } else {
    return input
        .replaceAll(r'aa', 'A')
        .replaceAll(r'ii', 'I')
        .replaceAll(r'uu', 'U')
        .replaceAll(r'\.r', 'f')
        .replaceAll(r'\.rr', 'F')
        .replaceAll(r'\.l', 'x')
        .replaceAll(r'\.ll', 'X')
        .replaceAll(r'ai', 'E')
        .replaceAll(r'au', 'O')
        .replaceAll(r'kh', 'K')
        .replaceAll(r'gh', 'G')
        .replaceAll(r'"nk', 'Nk')
        .replaceAll(r'"ng', 'Ng')
        .replaceAll(r'ch', 'C')
        .replaceAll(r'jh', 'J')
        .replaceAll(r'~n', 'Y')
        .replaceAll(r'\.t', 'w')
        .replaceAll(r'\.d', 'q')
        .replaceAll(r'\.th', 'W')
        .replaceAll(r'\.dh', 'Q')
        .replaceAll(r'\.n', 'R')
        .replaceAll(r'th', 'T')
        .replaceAll(r'dh', 'D')
        .replaceAll(r'ph', 'P')
        .replaceAll(r'bh', 'B')
        .replaceAll(r'"s', 'S')
        .replaceAll(r'\.s', 'z')
        .replaceAll(r'\.m', 'M')
        .replaceAll(r'\.h', 'H');
  }
}

String charAt(String input, position) {
  if (input.isEmpty) {
    return '';
  }
  if (position < 0 || position >= input.length) {
    return '';
  }
  return input[position];
}

String toSin(String input) {
  input = input.toLowerCase().replaceAll(r'ṁ', 'ṃ');
  final Map<String, String> vowel = {};

  vowel['a'] = 'අ';
  vowel['ā'] = 'ආ';
  vowel['i'] = 'ඉ';
  vowel['ī'] = 'ඊ';
  vowel['u'] = 'උ';
  vowel['ū'] = 'ඌ';
  vowel['e'] = 'එ';
  vowel['o'] = 'ඔ';

  final Map<String, String> sinhala = {};

  sinhala['ā'] = 'ා';
  sinhala['i'] = 'ි';
  sinhala['ī'] = 'ී';
  sinhala['u'] = 'ු';
  sinhala['ū'] = 'ූ';
  sinhala['e'] = 'ෙ';
  sinhala['o'] = 'ො';
  sinhala['ṃ'] = 'ං';
  sinhala['k'] = 'ක';
  sinhala['g'] = 'ග';
  sinhala['ṅ'] = 'ඞ';
  sinhala['c'] = 'ච';
  sinhala['j'] = 'ජ';
  sinhala['ñ'] = 'ඤ';
  sinhala['ṭ'] = 'ට';
  sinhala['ḍ'] = 'ඩ';
  sinhala['ṇ'] = 'ණ';
  sinhala['t'] = 'ත';
  sinhala['d'] = 'ද';
  sinhala['n'] = 'න';
  sinhala['p'] = 'ප';
  sinhala['b'] = 'බ';
  sinhala['m'] = 'ම';
  sinhala['y'] = 'ය';
  sinhala['r'] = 'ර';
  sinhala['l'] = 'ල';
  sinhala['ḷ'] = 'ළ';
  sinhala['v'] = 'ව';
  sinhala['s'] = 'ස';
  sinhala['h'] = 'හ';

  final Map<String, String> conj = {};

  conj['kh'] = 'ඛ';
  conj['gh'] = 'ඝ';
  conj['ch'] = 'ඡ';
  conj['jh'] = 'ඣ';
  conj['ṭh'] = 'ඨ';
  conj['ḍh'] = 'ඪ';
  conj['th'] = 'ථ';
  conj['dh'] = 'ධ';
  conj['ph'] = 'ඵ';
  conj['bh'] = 'භ';
  conj['jñ'] = 'ඥ';
  conj['ṇḍ'] = 'ඬ';
  conj['nd'] = 'ඳ';
  conj['mb'] = 'ඹ';
  conj['rg'] = 'ඟ';

  final Map<String, String> cons = {};

  cons['k'] = 'ක';
  cons['g'] = 'ග';
  cons['ṅ'] = 'ඞ';
  cons['c'] = 'ච';
  cons['j'] = 'ජ';
  cons['ñ'] = 'ඤ';
  cons['ṭ'] = 'ට';
  cons['ḍ'] = 'ඩ';
  cons['ṇ'] = 'ණ';
  cons['t'] = 'ත';
  cons['d'] = 'ද';
  cons['n'] = 'න';
  cons['p'] = 'ප';
  cons['b'] = 'බ';
  cons['m'] = 'ම';
  cons['y'] = 'ය';
  cons['r'] = 'ර';
  cons['l'] = 'ල';
  cons['ḷ'] = 'ළ';
  cons['v'] = 'ව';
  cons['s'] = 'ස';
  cons['h'] = 'හ';

  var im, i0, i1, i2, i3;
  var output = '';
  var i = 0;

  input = input.replaceAll(r'\&quot;', '`');

  while (i < input.length) {
    im = charAt(input, i - 2);
    i0 = charAt(input, i - 1);
    i1 = charAt(input, i);
    i2 = charAt(input, i + 1);
    i3 = charAt(input, i + 2);

    final vi1 = vowel[i1];
    if (vi1 != null) {
      if (i == 0 || i0 == 'a') {
        output += vi1;
      } else if (i1 != 'a') {
        final si1 = sinhala[i1];
        if (si1 != null) {
          output += si1;
        }
      }
      i++;
    } else if (conj[i1 + i2] != null) {
      // two character match
      output += conj[i1 + i2]!;
      i += 2;
      if (cons[i3] != null) {
        output += '්';
      }
    } else if (sinhala[i1] != null && i1 != 'a') {
      // one character match except a
      output += sinhala[i1]!;
      i++;
      if (cons[i2] != null && i1 != 'ṃ') {
        output += '්';
      }
    } else if (sinhala[i1] == null) {
      if (cons[i0] != null || (i0 == 'h' && cons[im] != null)) {
        output += '්'; // end word consonant
      }
      output += i1;
      i++;
      if (vowel[i2] != null) {
        // word-beginning vowel marker
        output += vowel[i2]!;
        i++;
      }
    } else {
      i++;
    }
  }

  if (cons[i1] != null) {
    output += '්';
  }

  // fudges

  // "‍" zero-width joiner inside of quotes

  return output
      .replaceAll(r'ඤ්ජ', 'ඦ')
      .replaceAll(r'ණ්ඩ', 'ඬ')
      .replaceAll(r'න්ද', 'ඳ')
      .replaceAll(r'ම්බ', 'ඹ')
      .replaceAll(r'්ර', '්‍ර')
      .replaceAll(r'\`+', '"');
}

String fromSin(String input, type) {
  var vowel = {};

  vowel['අ'] = 'a';
  vowel['ආ'] = 'ā';
  vowel['ඉ'] = 'i';
  vowel['ඊ'] = 'ī';
  vowel['උ'] = 'u';
  vowel['ඌ'] = 'ū';
  vowel['එ'] = 'e';
  vowel['ඔ'] = 'o';

  vowel['ඒ'] = 'ē';
  vowel['ඇ'] = 'ai';
  vowel['ඈ'] = 'āi';
  vowel['ඕ'] = 'ō';
  vowel['ඖ'] = 'au';

  vowel['ා'] = 'ā';
  vowel['ි'] = 'i';
  vowel['ී'] = 'ī';
  vowel['ු'] = 'u';
  vowel['ූ'] = 'ū';
  vowel['ෙ'] = 'e';
  vowel['ො'] = 'o';

  vowel['ෘ'] = 'ṛ';
  vowel['ෟ'] = 'ḷ';
  vowel['ෲ'] = 'ṝ';
  vowel['ෳ'] = 'ḹ';

  vowel['ේ'] = 'ē';
  vowel['ැ'] = 'ae';
  vowel['ෑ'] = 'āe';
  vowel['ෛ'] = 'ai';
  vowel['ෝ'] = 'ō';
  vowel['ෞ'] = 'au';

  var sinhala = {};

  sinhala['ං'] = 'ṃ';
  sinhala['ක'] = 'k';
  sinhala['ඛ'] = 'kh';
  sinhala['ග'] = 'g';
  sinhala['ඝ'] = 'gh';
  sinhala['ඞ'] = 'ṅ';
  sinhala['ච'] = 'c';
  sinhala['ඡ'] = 'ch';
  sinhala['ජ'] = 'j';
  sinhala['ඣ'] = 'jh';
  sinhala['ඤ'] = 'ñ';
  sinhala['ට'] = 'ṭ';
  sinhala['ඨ'] = 'ṭh';
  sinhala['ඩ'] = 'ḍ';
  sinhala['ඪ'] = 'ḍh';
  sinhala['ණ'] = 'ṇ';
  sinhala['ත'] = 't';
  sinhala['ථ'] = 'th';
  sinhala['ද'] = 'd';
  sinhala['ධ'] = 'dh';
  sinhala['න'] = 'n';
  sinhala['ප'] = 'p';
  sinhala['ඵ'] = 'ph';
  sinhala['බ'] = 'b';
  sinhala['භ'] = 'bh';
  sinhala['ම'] = 'm';
  sinhala['ය'] = 'y';
  sinhala['ර'] = 'r';

  sinhala['ල'] = 'l';
  sinhala['ළ'] = 'ḷ';
  sinhala['ව'] = 'v';
  sinhala['ස'] = 's';
  sinhala['හ'] = 'h';

  sinhala['ෂ'] = 'ṣ';
  sinhala['ශ'] = 'ś';

  sinhala['ඥ'] = 'jñ';
  sinhala['ඬ'] = 'ṇḍ';
  sinhala['ඳ'] = 'nd';
  sinhala['ඹ'] = 'mb';
  sinhala['ඟ'] = 'rg';

  var im, i0, i1, i2, i3;
  var output = '';
  var i = 0;

  input = input.replaceAll(r'\&quot;', '`');

  while (i < input.length) {
    i1 = input[i];
    debugPrint('i1: $i1');

    if (vowel[i1]) {
      if (output[output.length - 1] == 'a') {
        output = output.substring(0, output.length - 1);
      }
      output += vowel[i1];
    } else if (sinhala[i1]) {
      output += sinhala[i1] + 'a';
    } else {
      output += i1;
    }
    i++;
  }

  // fudges

  // "‍" zero-width joiner inside of quotes

  output = output.replaceAll(r'a්', '');
  return output;
}

String toDeva(String input) {
  input = input.toLowerCase().replaceAll(r'ṁ', 'ṃ');

  var vowel = {};
  vowel['a'] = " अ";
  vowel['i'] = " इ";
  vowel['u'] = " उ";
  vowel['ā'] = " आ";
  vowel['ī'] = " ई";
  vowel['ū'] = " ऊ";
  vowel['e'] = " ए";
  vowel['o'] = " ओ";

  var devar = {};

  devar['ā'] = 'ा';
  devar['i'] = 'ि';
  devar['ī'] = 'ी';
  devar['u'] = 'ु';
  devar['ū'] = 'ू';
  devar['e'] = 'े';
  devar['o'] = 'ो';
  devar['ṃ'] = 'ं';
  devar['k'] = 'क';
  devar['kh'] = 'ख';
  devar['g'] = 'ग';
  devar['gh'] = 'घ';
  devar['ṅ'] = 'ङ';
  devar['c'] = 'च';
  devar['ch'] = 'छ';
  devar['j'] = 'ज';
  devar['jh'] = 'झ';
  devar['ñ'] = 'ञ';
  devar['ṭ'] = 'ट';
  devar['ṭh'] = 'ठ';
  devar['ḍ'] = 'ड';
  devar['ḍh'] = 'ढ';
  devar['ṇ'] = 'ण';
  devar['t'] = 'त';
  devar['th'] = 'थ';
  devar['d'] = 'द';
  devar['dh'] = 'ध';
  devar['n'] = 'न';
  devar['p'] = 'प';
  devar['ph'] = 'फ';
  devar['b'] = 'ब';
  devar['bh'] = 'भ';
  devar['m'] = 'म';
  devar['y'] = 'य';
  devar['r'] = 'र';
  devar['l'] = 'ल';
  devar['ḷ'] = 'ळ';
  devar['v'] = 'व';
  devar['s'] = 'स';
  devar['h'] = 'ह';

  var i0 = '';
  var i1 = '';
  var i2 = '';
  var i3 = '';
  var i4 = '';
  var i5 = '';
  var output = '';
  var cons = 0;
  var i =1;

  // input = input.replace(r'\&quot;', '`');

  while (i < input.length) {
    i0 = charAt(input, i - 1);
    i1 = charAt(input, i );
    i2 = charAt(input, i + 1);
    i3 = charAt(input, i + 2);
    i4 = charAt(input, i + 3);
    i5 = charAt(input, i + 4);

    if (i == 0 && vowel[i1]) {
      // first letter vowel
      output += vowel[i1];
      i += 1;
    } else if (i2 == 'h' && devar[i1 + i2]) {
      // two character match
      output += devar[i1 + i2];
      if (i3 != null && !vowel[i3] && i2 != 'ṃ') {
        output += '्';
      }
      i += 2;
    } else if (devar[i1]) {
      // one character match except a
      output += devar[i1];
      if (i2 != null && !vowel[i2] && !vowel[i1] && i1 != 'ṃ') {
        output += '्';
      }
      i++;
    } else if (i1 != 'a') {
      if (devar[i0] != null || (i0 == 'h' && devar[i1] != null)) {
        output += '्'; // end word consonant
      }
      output += i1;
      i++;
      if (vowel[i2]) {
        output += vowel[i2];
        i++;
      }
    } else {
      i++;
    } // a
  }
  if (devar[i1]) {
    output += '्';
  }
  output = output.replaceAll(r'\`+', '"');
  return output;
}

String fromThai(String input) {
  return input
      .replaceAllMapped(r'([อกขคฆงจฉชฌญฏฐฑฒณตถทธนปผพภมยรลฬวสห])(?!ฺ)',
          (match) => match.group(0) ?? '')
      .replaceAllMapped(r'([เโ])([อกขคฆงจฉชฌญฏฐฑฒณตถทธนปผพภมยรลฬวสหฺฺ]+a)',
          (match) => '${match.group(1) ?? ''}${match.group(0) ?? ''}')
      .replaceAllMapped(r'[a]([าิีึุูเโ])', (match) => match.group(0) ?? '')
      .replaceAll(r'ฺ', "")
      .replaceAll(r'อ', '')
      .replaceAll(r'า', 'ā')
      .replaceAll(r'ิ', 'i')
      .replaceAll(r'ี', 'ī')
      .replaceAll(r'ึ', 'iṃ')
      .replaceAll(r'ุ', 'u')
      .replaceAll(r'ู', 'ū')
      .replaceAll(r'เ', 'e')
      .replaceAll(r'โ', 'o')
      .replaceAll(r'ํ', 'ṃ')
      .replaceAll(r'ก', 'k')
      .replaceAll(r'ข', 'kh')
      .replaceAll(r'ค', 'g')
      .replaceAll(r'ฆ', 'gh')
      .replaceAll(r'ง', 'ṅ')
      .replaceAll(r'จ', 'c')
      .replaceAll(r'ฉ', 'ch')
      .replaceAll(r'ช', 'j')
      .replaceAll(r'ฌ', 'jh')
      .replaceAll(r'', 'ñ')
      .replaceAll(r'ญ', 'ñ')
      .replaceAll(r'ฏ', 'ṭ')
      .replaceAll(r'', 'ṭh')
      .replaceAll(r'ฐ', 'ṭh')
      .replaceAll(r'ฑ', 'ḍ')
      .replaceAll(r'ฒ', 'ḍh')
      .replaceAll(r'ณ', 'ṇ')
      .replaceAll(r'ต', 't')
      .replaceAll(r'ถ', 'th')
      .replaceAll(r'ท', 'd')
      .replaceAll(r'ธ', 'dh')
      .replaceAll(r'น', 'n')
      .replaceAll(r'ป', 'p')
      .replaceAll(r'ผ', 'ph')
      .replaceAll(r'พ', 'b')
      .replaceAll(r'ภ', 'bh')
      .replaceAll(r'ม', 'm')
      .replaceAll(r'ย', 'y')
      .replaceAll(r'ร', 'r')
      .replaceAll(r'ล', 'l')
      .replaceAll(r'ฬ', 'ḷ')
      .replaceAll(r'ว', 'v')
      .replaceAll(r'ส', 's')
      .replaceAll(r'ห', 'h')
      .replaceAll(r'๐', '0')
      .replaceAll(r'๑', '1')
      .replaceAll(r'๒', '2')
      .replaceAll(r'๓', '3')
      .replaceAll(r'๔', '4')
      .replaceAll(r'๕', '5')
      .replaceAll(r'๖', '6')
      .replaceAll(r'๗', '7')
      .replaceAll(r'๘', '8')
      .replaceAll(r'๙', '9')
      .replaceAll(r'ฯ', '...')
      .replaceAll(r'', '');
}
