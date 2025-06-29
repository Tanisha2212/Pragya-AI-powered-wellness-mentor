// services/subhashita_service.dart
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:sanskrit_daily_subhasita/models/subhashita_model.dart';

class SubhashitaService {
  static List<Subhashita> _allSubhashitas = [];
  static bool _isLoaded = false;

  // Load subhashitas from JSON file in root folder
  static Future<void> loadSubhashitas() async {
    if (_isLoaded) return;
    
    try {
      // For Flutter web, you might need to use http package
      // For mobile/desktop, use File from dart:io
      final String jsonString = await rootBundle.loadString('assets/subhashitas.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> subhashitasList = jsonData['subhashitas'];
      
      _allSubhashitas = subhashitasList
          .map((json) => Subhashita.fromJson(json))
          .toList();
      _isLoaded = true;
    } catch (e) {
      print('Error loading subhashitas from root: $e');
      // Fallback to default data if file not found
      _loadDefaultData();
    }
  }

  // Fallback method to load some default data
  static void _loadDefaultData() {
    _allSubhashitas = [
      Subhashita(
        id: 1,
        sanskrit: "वक्रतुण्ड महाकाय सूर्यकोटीसमप्रभ।\nनिर्विघ्नं कुरू मे देव सर्वकार्येषु सर्वदा॥",
        marathi: "बळणदार सोंड असणाऱ्या, विशाल आकाराच्या व कोट्यवधी सूर्यांच्या तेजासारखे तेज असणाऱ्या हे (गणेश) देवा।",
        english: "O Lord with curved trunk, massive body, and radiance like a million suns, make all my endeavors always free from obstacles.",
        meaning: "Prayer to Lord Ganesha for removing obstacles",
        category: "prayer",
        deity: "Ganesha",
        keywords: ["obstacles", "beginnings", "success"],
        moodRelevance: ["anxious", "new_venture"],
      ),
    ];
    _isLoaded = true;
  }

  // Get today's random subhashita
  static Subhashita getTodaysSubhashita() {
    if (_allSubhashitas.isEmpty) return _getDefaultSubhashita();
    
    final today = DateTime.now();
    final seed = today.year * 1000 + today.month * 100 + today.day;
    final random = Random(seed);
    
    return _allSubhashitas[random.nextInt(_allSubhashitas.length)];
  }

  // AI-powered mood-based recommendation
  static List<Subhashita> getSubhashitasForMood(String mood) {
    if (_allSubhashitas.isEmpty) return [_getDefaultSubhashita()];

    // Filter subhashitas based on mood relevance
    List<Subhashita> moodRelevant = _allSubhashitas
        .where((s) => s.moodRelevance.contains(mood.toLowerCase()))
        .toList();

    // If no direct matches, use keyword matching
    if (moodRelevant.isEmpty) {
      moodRelevant = _getSubhashitasByKeywords(_getMoodKeywords(mood));
    }

    // Ensure we have at least 3 recommendations
    if (moodRelevant.length < 3) {
      final additional = _allSubhashitas
          .where((s) => !moodRelevant.contains(s))
          .take(3 - moodRelevant.length)
          .toList();
      moodRelevant.addAll(additional);
    }

    return moodRelevant.take(5).toList();
  }

  // Get subhashitas by keywords
  static List<Subhashita> _getSubhashitasByKeywords(List<String> keywords) {
    return _allSubhashitas
        .where((s) => keywords.any((keyword) => 
            s.keywords.contains(keyword) || 
            s.meaning.toLowerCase().contains(keyword.toLowerCase())))
        .toList();
  }

  // Map mood to relevant keywords
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

  // Get all unique categories
  static List<String> getCategories() {
    return _allSubhashitas
        .map((s) => s.category)
        .toSet()
        .toList();
  }

  // Get subhashitas by category
  static List<Subhashita> getSubhashitasByCategory(String category) {
    return _allSubhashitas
        .where((s) => s.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  // Get random subhashita
  static Subhashita getRandomSubhashita() {
    if (_allSubhashitas.isEmpty) return _getDefaultSubhashita();
    final random = Random();
    return _allSubhashitas[random.nextInt(_allSubhashitas.length)];
  }

  // Search subhashitas
  static List<Subhashita> searchSubhashitas(String query) {
    if (query.isEmpty) return _allSubhashitas;
    
    final lowerQuery = query.toLowerCase();
    return _allSubhashitas
        .where((s) => 
            s.sanskrit.toLowerCase().contains(lowerQuery) ||
            s.english.toLowerCase().contains(lowerQuery) ||
            s.meaning.toLowerCase().contains(lowerQuery) ||
            s.keywords.any((k) => k.toLowerCase().contains(lowerQuery)))
        .toList();
  }

  // Get favorite subhashitas (mock implementation)
  static List<Subhashita> getFavorites() {
    // In a real app, this would fetch from local storage
    return _allSubhashitas.take(5).toList();
  }

  // Default subhashita for fallback
  static Subhashita _getDefaultSubhashita() {
    return Subhashita(
      id: 0,
      sanskrit: "यत्र नार्यस्तु पूज्यन्ते रमन्ते तत्र देवताः।",
      marathi: "जेथे स्त्रियांची पूजा होते तेथे देवता राहतात.",
      english: "Where women are honored, there the gods dwell.",
      meaning: "Respect for women brings divine blessings",
      category: "social",
      deity: "Universal",
      keywords: ["respect", "women", "society"],
      moodRelevance: ["peaceful", "thoughtful"],
    );
  }

  // Get all subhashitas
  static List<Subhashita> getAllSubhashitas() {
    return _allSubhashitas;
  }
}