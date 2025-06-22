import 'dart:convert';

class StreakData {
  final int currentStreak;
  final int longestStreak;
  final DateTime lastVisitDate;
  final List<DateTime> visitDates;
  final int totalVisits;

  StreakData({
    required this.currentStreak,
    required this.longestStreak,
    required this.lastVisitDate,
    required this.visitDates,
    required this.totalVisits,
  });

  factory StreakData.fromJson(Map<String, dynamic> json) {
    return StreakData(
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      lastVisitDate: DateTime.parse(json['lastVisitDate'] ?? DateTime.now().toIso8601String()),
      visitDates: (json['visitDates'] as List<dynamic>?)
          ?.map((date) => DateTime.parse(date))
          .toList() ?? [],
      totalVisits: json['totalVisits'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastVisitDate': lastVisitDate.toIso8601String(),
      'visitDates': visitDates.map((date) => date.toIso8601String()).toList(),
      'totalVisits': totalVisits,
    };
  }

  StreakData copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastVisitDate,
    List<DateTime>? visitDates,
    int? totalVisits,
  }) {
    return StreakData(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastVisitDate: lastVisitDate ?? this.lastVisitDate,
      visitDates: visitDates ?? this.visitDates,
      totalVisits: totalVisits ?? this.totalVisits,
    );
  }
}

class StreakService {
  static const String _streakKey = 'user_streak_data';
  static Map<String, dynamic>? _memoryStorage;

  // Initialize with default data if no storage exists
  static StreakData _getDefaultStreakData() {
    return StreakData(
      currentStreak: 0,
      longestStreak: 0,
      lastVisitDate: DateTime.now(),
      visitDates: [],
      totalVisits: 0,
    );
  }

  // Simulate storage operations (in real app, use SharedPreferences)
  static Future<void> _saveToStorage(String key, String value) async {
    _memoryStorage ??= {};
    _memoryStorage![key] = value;
  }

  static Future<String?> _getFromStorage(String key) async {
    return _memoryStorage?[key];
  }

  // Get current streak data
  static Future<StreakData> getStreakData() async {
    try {
      final jsonString = await _getFromStorage(_streakKey);
      if (jsonString != null) {
        final json = jsonDecode(jsonString);
        return StreakData.fromJson(json);
      }
    } catch (e) {
      print('Error loading streak data: $e');
    }
    return _getDefaultStreakData();
  }

  // Save streak data
  static Future<void> _saveStreakData(StreakData streakData) async {
    try {
      final jsonString = jsonEncode(streakData.toJson());
      await _saveToStorage(_streakKey, jsonString);
    } catch (e) {
      print('Error saving streak data: $e');
    }
  }

  // Check if user visited today
  static bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  // Check if dates are consecutive days
  static bool _areConsecutiveDays(DateTime earlier, DateTime later) {
    final difference = later.difference(earlier).inDays;
    return difference == 1;
  }

  // Update streak when user opens the app
  static Future<StreakData> updateDailyStreak() async {
    final currentData = await getStreakData();
    final today = DateTime.now();
    
    // If user already visited today, return current data
    if (_isSameDay(currentData.lastVisitDate, today)) {
      return currentData;
    }

    // Calculate new streak
    int newCurrentStreak;
    if (_areConsecutiveDays(currentData.lastVisitDate, today)) {
      // Consecutive day - increment streak
      newCurrentStreak = currentData.currentStreak + 1;
    } else if (_isSameDay(currentData.lastVisitDate, today.subtract(const Duration(days: 1)))) {
      // Same as yesterday, maintain streak
      newCurrentStreak = currentData.currentStreak;
    } else {
      // Streak broken - reset to 1
      newCurrentStreak = 1;
    }

    // Update longest streak if necessary
    final newLongestStreak = newCurrentStreak > currentData.longestStreak 
        ? newCurrentStreak 
        : currentData.longestStreak;

    // Add today to visit dates (keep only last 30 days for performance)
    final updatedVisitDates = [...currentData.visitDates, today];
    final recentVisits = updatedVisitDates
        .where((date) => today.difference(date).inDays <= 30)
        .toList();

    // Create updated streak data
    final updatedData = currentData.copyWith(
      currentStreak: newCurrentStreak,
      longestStreak: newLongestStreak,
      lastVisitDate: today,
      visitDates: recentVisits,
      totalVisits: currentData.totalVisits + 1,
    );

    // Save updated data
    await _saveStreakData(updatedData);
    
    return updatedData;
  }

  // Get streak status message
  static String getStreakMessage(int currentStreak) {
    if (currentStreak == 0) {
      return "Start your wisdom journey today!";
    } else if (currentStreak == 1) {
      return "Great start! Keep it up tomorrow.";
    } else if (currentStreak < 7) {
      return "Building momentum! $currentStreak days strong.";
    } else if (currentStreak < 30) {
      return "Excellent habit! $currentStreak day streak.";
    } else if (currentStreak < 100) {
      return "Wisdom master! $currentStreak days of learning.";
    } else {
      return "Legendary dedication! $currentStreak days!";
    }
  }

  // Get streak icon based on current streak
  static String getStreakIcon(int currentStreak) {
    if (currentStreak == 0) return "🌱";
    if (currentStreak < 7) return "🔥";
    if (currentStreak < 30) return "⚡";
    if (currentStreak < 100) return "🌟";
    return "👑";
  }

  // Reset streak (for testing or user request)
  static Future<void> resetStreak() async {
    final defaultData = _getDefaultStreakData();
    await _saveStreakData(defaultData);
  }

  // Get weekly streak pattern (last 7 days)
  static Future<List<bool>> getWeeklyPattern() async {
    final streakData = await getStreakData();
    final today = DateTime.now();
    final weekPattern = <bool>[];

    for (int i = 6; i >= 0; i--) {
      final checkDate = today.subtract(Duration(days: i));
      final hasVisit = streakData.visitDates.any((date) => 
          _isSameDay(date, checkDate));
      weekPattern.add(hasVisit);
    }

    return weekPattern;
  }

  // Get achievement level based on longest streak
  static String getAchievementLevel(int longestStreak) {
    if (longestStreak < 7) return "Beginner";
    if (longestStreak < 30) return "Dedicated";
    if (longestStreak < 100) return "Master";
    if (longestStreak < 365) return "Sage";
    return "Enlightened";
  }

  // Check if streak milestone reached
  static bool isStreakMilestone(int streak) {
    return [7, 14, 30, 50, 100, 200, 365].contains(streak);
  }

  // Get milestone message
  static String getMilestoneMessage(int streak) {
    switch (streak) {
      case 7:
        return "🎉 One week of wisdom! You're building a great habit.";
      case 14:
        return "🌟 Two weeks strong! Knowledge is becoming second nature.";
      case 30:
        return "🏆 One month milestone! You're officially a wisdom seeker.";
      case 50:
        return "💎 50 days of learning! Your dedication is inspiring.";
      case 100:
        return "🎯 Century mark! You've reached wisdom master level.";
      case 200:
        return "🚀 200 days! Your journey is truly remarkable.";
      case 365:
        return "👑 One full year! You've achieved enlightenment status.";
      default:
        return "🔥 Amazing streak! Keep the momentum going.";
    }
  }
}