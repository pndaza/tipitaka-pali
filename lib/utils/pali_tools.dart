class PaliTools {
  PaliTools._();
  static String velthuisToUni({required String velthiusInput}) {
    if (velthiusInput.isEmpty) return velthiusInput;

    final nigahita = 'ṃ';
    final capitalNigahita = 'Ṃ';

    final uni = velthiusInput
        .replaceAll('aa', 'ā')
        .replaceAll('ii', 'ī')
        .replaceAll('uu', 'ū')
        .replaceAll('\.t', 'ṭ')
        .replaceAll('\.d', 'ḍ')
        .replaceAll('\"nk', 'ṅk')
        .replaceAll('\"ng', 'ṅg')
        .replaceAll('\.n', 'ṇ')
        .replaceAll('\.m', nigahita)
        .replaceAll('\u1E41', nigahita)
        .replaceAll('\~n', 'ñ')
        .replaceAll('\.l', 'ḷ')
        .replaceAll('AA', 'Ā')
        .replaceAll('II', 'Ī')
        .replaceAll('UU', 'Ū')
        .replaceAll('\.T', 'Ṭ')
        .replaceAll('\.D', 'Ḍ')
        .replaceAll('\"N', 'Ṅ')
        .replaceAll('\.N', 'Ṇ')
        .replaceAll('\.M', capitalNigahita)
        .replaceAll('\~N', 'Ñ')
        .replaceAll('\.L', 'Ḷ')
        .replaceAll('\.ll', 'ḹ')
        .replaceAll('\.r', 'ṛ')
        .replaceAll('\.rr', 'ṝ')
        .replaceAll('\.s', 'ṣ')
        .replaceAll('"s', 'ś')
        .replaceAll('\.h', 'ḥ');

    return uni;
  }
}
