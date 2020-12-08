class MmNumber {
  static String get(int input) {
    String engNumber = input.toString();
    String mmNumber = '';

    Map<String, String> map = {
      '0': '၀',
      '1': '၁',
      '2': '၂',
      '3': '၃',
      '4': '၄',
      '5': '၅',
      '6': '၆',
      '7': '၇',
      '8': '၈',
      '9': '၉',
    };

    for (int i = 0; i < engNumber.length; i++) {
      mmNumber += map[engNumber[i]];
    }
    return mmNumber;
  }
}
