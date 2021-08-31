

String performRegex(Map<String, String> regexMap, String input){
  regexMap.entries.forEach((pair) { 
    input  = input.replaceAllMapped(RegExp(pair.key), (match) {
  return pair.value;
});
  });
  return input;
}


String toUni(String input){
  var nigahita = 'ṃ';
	var Nigahita = 'Ṃ';
  if(input==null || input =="") return input;
  Map<String, String> regexMap = {r'/aa/g': 'ā',r'/ii/g':'ī',r'/uu/g': 'ū','/\.t/g': 'ṭ','/\.d/g': 'ḍ',r'/\"nk/g': 'ṅk',r'/\"ng/g': 'ṅg',r'/\.n/g': 'ṇ',r'/\.m/g': nigahita,r'/\u1E41/g': nigahita,r'/\~n/g': 'ñ',r'/\.l/g': 'ḷ',r'/AA/g': 'Ā',r'/II/g': 'Ī',r'/UU/g': 'Ū',r'/\.T/g': 'Ṭ',r'/\.D/g': 'Ḍ',r'/\"N/g': 'Ṅ',r'/\.N/g': 'Ṇ',r'/\.M/g': Nigahita,r'/\~N/g': 'Ñ',r'/\.L/g': 'Ḷ',r'/\.ll/g':'ḹ',r'/\.r/g':'ṛ',r'/\.rr/g':'ṝ',r'/\.s/g':'ṣ',r'/"s/g':'ś',r'/\.h/g':'ḥ'};
	return performRegex(regexMap,input);
}

String toVel(String input){
  if(input==null || input =="") return input;
  Map<String, String> regexMap = {r'/\"/g': '\"',r'/\u0101/g': 'aa',r'/\u012B/g': 'ii',r'/\u016B/g': 'uu',r'/\u1E6D/g': '\.t',r'/\u1E0D/g': '\.d',r'/\u1E45/g': '\"n',r'/\u1E47/g': '\.n',r'/\u1E43/g': '\.m',r'/\u1E41/g': '\.m',r'/\u00F1/g': '\~n',r'/\u1E37/g': '\.l',r'/\u0100/g': 'AA',r'/\u012A/g': 'II',r'/\u016A/g': 'UU',r'/\u1E6C/g': '\.T',r'/\u1E0C/g': '\.D',r'/\u1E44/g': '\"N',r'/\u1E46/g': '\.N',r'/\u1E42/g': '\.M',r'/\u00D1/g':'\~N',r'/\u1E36/g': '\.L',r'/ḹ/g': '\.ll',r'/ṛ/g': '\.r',r'/ṝ/g': '\.rr',r'/ṣ/g': '\.s',r'/ś/g': '"s',r'/ḥ/g': '\.h'};
  return performRegex(regexMap,input);
}
