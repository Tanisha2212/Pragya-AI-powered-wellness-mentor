class Subhashita {
  final int id;
  final String sanskrit;
  final String marathi;
  final String english;
  final String meaning;
  final String category;
  final String deity;
  final List<String> keywords;
  final List<String> moodRelevance;

  Subhashita({
    required this.id,
    required this.sanskrit,
    required this.marathi,
    required this.english,
    required this.meaning,
    required this.category,
    required this.deity,
    required this.keywords,
    required this.moodRelevance,
    // Removed the extra parameters that don't have corresponding fields
  });

  // Your factory method and other methods also need to be updated
  factory Subhashita.fromJson(Map<String, dynamic> json) {
    return Subhashita(
      id: json['id'] ?? 0,
      sanskrit: json['sanskrit'] ?? '',
      marathi: json['marathi'] ?? '',
      english: json['english'] ?? '',
      meaning: json['meaning'] ?? '',
      category: json['category'] ?? 'general',
      deity: json['deity'] ?? 'Universal',
      keywords: List<String>.from(json['keywords'] ?? []),
      moodRelevance: List<String>.from(json['mood_relevance'] ?? []),
      // Removed the extra parameters here too
    );
  }

  // Update copyWith method as well
  Subhashita copyWith({
    int? id,
    String? sanskrit,
    String? marathi,
    String? english,
    String? meaning,
    String? category,
    String? deity,
    List<String>? keywords,
    List<String>? moodRelevance,
  }) {
    return Subhashita(
      id: id ?? this.id,
      sanskrit: sanskrit ?? this.sanskrit,
      marathi: marathi ?? this.marathi,
      english: english ?? this.english,
      meaning: meaning ?? this.meaning,
      category: category ?? this.category,
      deity: deity ?? this.deity,
      keywords: keywords ?? this.keywords,
      moodRelevance: moodRelevance ?? this.moodRelevance,
      // No extra parameters needed here
    );
  }

  // Rest of your methods remain the same...
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sanskrit': sanskrit,
      'marathi': marathi,
      'english': english,
      'meaning': meaning,
      'category': category,
      'deity': deity,
      'keywords': keywords,
      'mood_relevance': moodRelevance,
    };
  }

  @override
  String toString() {
    return 'Subhashita(id: $id, sanskrit: $sanskrit, english: $english, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Subhashita && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  String get shortEnglish {
    if (english.length <= 50) return english;
    return '${english.substring(0, 47)}...';
  }

  String get categoryCapitalized {
    return category.split('_').map((word) => 
        word[0].toUpperCase() + word.substring(1)).join(' ');
  }

  bool get hasMarathi => marathi.isNotEmpty;

  bool matchesQuery(String query) {
    final lowerQuery = query.toLowerCase();
    return sanskrit.toLowerCase().contains(lowerQuery) ||
           english.toLowerCase().contains(lowerQuery) ||
           marathi.toLowerCase().contains(lowerQuery) ||
           meaning.toLowerCase().contains(lowerQuery) ||
           category.toLowerCase().contains(lowerQuery) ||
           deity.toLowerCase().contains(lowerQuery) ||
           keywords.any((keyword) => keyword.toLowerCase().contains(lowerQuery));
  }

  bool isRelevantForMood(String mood) {
    return moodRelevance.contains(mood.toLowerCase()) ||
           keywords.any((keyword) => _getMoodKeywords(mood).contains(keyword));
  }

  static List<String> _getMoodKeywords(String mood) {
    switch (mood.toLowerCase()) {
      case 'stressed':
      case 'anxious':
        return ['peace', 'calm', 'patience', 'strength'];
      case 'sad':
      case 'depressed':
        return ['hope', 'courage', 'joy', 'strength'];
      case 'angry':
        return ['patience', 'forgiveness', 'peace', 'wisdom'];
      case 'happy':
      case 'joyful':
        return ['gratitude', 'celebration', 'success', 'joy'];
      case 'confused':
        return ['wisdom', 'clarity', 'knowledge', 'guidance'];
      case 'motivated':
        return ['success', 'determination', 'achievement', 'effort'];
      case 'peaceful':
        return ['meditation', 'spirituality', 'inner_peace', 'divine'];
      default:
        return ['wisdom', 'life', 'knowledge'];
    }
  }
}