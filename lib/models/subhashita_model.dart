class Subhashita {
  final String id;
  final String sanskrit;
  final String transliteration;
  final String translation;
  final String meaning;
  final String category;
  final bool isFavorite;

  Subhashita({
    required this.id,
    required this.sanskrit,
    required this.transliteration,
    required this.translation,
    required this.meaning,
    required this.category,
    this.isFavorite = false,
  });

  Subhashita copyWith({
    String? id,
    String? sanskrit,
    String? transliteration,
    String? translation,
    String? meaning,
    String? category,
    bool? isFavorite,
  }) {
    return Subhashita(
      id: id ?? this.id,
      sanskrit: sanskrit ?? this.sanskrit,
      transliteration: transliteration ?? this.transliteration,
      translation: translation ?? this.translation,
      meaning: meaning ?? this.meaning,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class SubhashitaRepository {
  static List<Subhashita> getDummyData() {
    return [
      Subhashita(
        id: '1',
        sanskrit: 'विद्या ददाति विनयं विनयाद्याति पात्रताम्।\nपात्रत्वाद्धनमाप्नोति धनाद्धर्मं ततः सुखम्॥',
        transliteration: 'Vidya dadati vinayam vinayad yati patratam.\nPatratvad dhanam apnoti dhanad dharmam tatah sukham.',
        translation: 'Knowledge gives humility, from humility comes worthiness, from worthiness one gets wealth, from wealth comes righteousness, and from righteousness comes happiness.',
        meaning: 'This verse describes the progressive journey of personal development through knowledge.',
        category: 'Education',
      ),
      Subhashita(
        id: '2',
        sanskrit: 'सत्यं ब्रूयात् प्रियं ब्रूयात् न ब्रूयात् सत्यमप्रियम्।\nप्रियं च नानृतं ब्रूयात् एष धर्मः सनातनः॥',
        transliteration: 'Satyam bruyat priyam bruyat na bruyat satyam apriyam.\nPriyam cha nanritam bruyat esha dharmah sanatanah.',
        translation: 'Speak the truth, speak pleasantly, do not speak unpleasant truths. Do not speak pleasant lies. This is eternal dharma.',
        meaning: 'This teaches the art of righteous communication - balancing truth with kindness.',
        category: 'Ethics',
      ),
      Subhashita(
        id: '3',
        sanskrit: 'काल: पच्यति सर्वाणि भूतानि सह तेजसा।\nकाले तु सुप्रयुक्ते च तत्काल: स्यात् सुखावहः॥',
        transliteration: 'Kalah pachyati sarvani bhutani saha tejasa.\nKale tu suprayukte cha tatkalah syat sukhavahah.',
        translation: 'Time ripens all beings with its power. When time is used properly, that time brings happiness.',
        meaning: 'This emphasizes the importance of using time wisely for personal growth and happiness.',
        category: 'Life Wisdom',
      ),
      Subhashita(
        id: '4',
        sanskrit: 'अहिंसा परमो धर्मः धर्म हिंसा तथैव च।',
        transliteration: 'Ahimsa paramo dharmah dharma himsa tathaiva cha.',
        translation: 'Non-violence is the highest dharma, so too is violence in service of dharma.',
        meaning: 'This explores the complex nature of righteousness and when action is necessary.',
        category: 'Ethics',
        isFavorite: true,
      ),
    ];
  }

  static List<String> getCategories() {
    return [
      'Education',
      'Ethics', 
      'Life Wisdom',
      'Devotion', // Locked
      'Leadership', // Locked
      'Philosophy', // Locked
    ];
  }

  static List<String> getUnlockedCategories() {
    return ['Education'];
  }

  static Subhashita getTodaysSubhashita() {
    final today = DateTime.now();
    final allSubhashitas = getDummyData();
    final index = today.day % allSubhashitas.length;
    return allSubhashitas[index];
  }

  static List<Subhashita> getSubhashitasByCategory(String category) {
    return getDummyData().where((s) => s.category == category).toList();
  }
}