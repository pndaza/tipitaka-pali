import '../../business_logic/models/definition.dart';
import '../../utils/pali_stemmer.dart';
import '../repositories/ditionary_repo.dart';

const kdartTheme = 'default_dark_theme';
const kblackTheme = 'black';

class DictionarySerice {
  DictionarySerice(this.dictionaryRepository);
  final DictionaryRepository dictionaryRepository;

  Future<List<Definition>> getDefinition(String word,
      {bool isAlreadyStem = false}) async {
    if (!isAlreadyStem) {
      word = PaliStemmer.getStem(word);
    }

    // final DatabaseHelper databaseHelper = DatabaseHelper();
    // final DictionaryRepository dictRepository =
    //     DictionaryDatabaseRepository(databaseHelper);

    // lookup using estimated stem word
    // print('dict word: $stemWord');
    final definitions = await dictionaryRepository.getDefinition(word);
    return definitions;

    // return _formatDefinitions(definitions);
  }

  Future<List<String>> getSuggestions(String word) async {
    return dictionaryRepository.getSuggestions(word);
  }

  Future<String> getBreakup(String word) async {
    return dictionaryRepository.getBreakup(word);
    
  }
}
