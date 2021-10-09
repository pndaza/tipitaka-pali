import 'package:flutter/material.dart';
import 'package:tipitaka_pali/business_logic/models/book.dart';
import 'package:tipitaka_pali/services/database/database_helper.dart';
import 'package:tipitaka_pali/services/repositories/paragraph_repo.dart';

enum Goto { page, paragraph }

class GotoViewModel with ChangeNotifier {
  GotoViewModel(this.book);
  final Book book;

  int? firstParagraph;
  int? lastParagraph;
  String pagehintText = '';
  String parahintText = '';
  Goto selected = Goto.page;
  bool isValid = false;
  int? inputValue;

  final ParagraphRepository repository =
      ParagraphDatabaseRepository(DatabaseHelper());

  Future init() async {
    firstParagraph = await repository.getFirstParagraph(book.id);
    lastParagraph = await repository.getLastParagraph(book.id);
    pagehintText = '(${book.firstPage}-${book.lastPage}) စာမျက်နှာ';
    parahintText = '($firstParagraph-$lastParagraph) စာပိုဒ်';
    notifyListeners();
  }

  void setSelected(Goto value) {
    selected = value;
    notifyListeners();
  }

  void validate(String inputString) {
    if (inputString.isEmpty) {
      isValid = false;
      notifyListeners();
      return;
    }

    inputValue = int.parse(inputString.trim());

    switch (selected) {
      case Goto.page:
        isValid = isValidPageNumber(inputValue!) ? true : false;
        break;
      case Goto.paragraph:
        isValid = isValidParagraphNumber(inputValue!) ? true : false;
        break;
    }
    notifyListeners();
  }

  bool isValidPageNumber(int pageNumber) {
    return book.firstPage! <= pageNumber && pageNumber <= book.lastPage!;
  }

  bool isValidParagraphNumber(int paragraphNumber) {
    return firstParagraph! <= paragraphNumber &&
        paragraphNumber <= lastParagraph!;
  }

  Future<int> getPageNumber(int paragraphNumber) async {
    return await repository.getPageNumber(book.id, inputValue!);
  }
}
