//screens/main_navigatiomn.dart

import 'package:flutter/material.dart';
import 'package:sanskrit_daily_subhasita/models/subhashita_model.dart';
import 'package:sanskrit_daily_subhasita/services/streak_services.dart';


class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  StreakData? _streakData;

  @override
  void initState() {
    super.initState();
    _initializeStreak();
  }



  Future<void> _initializeStreak() async {
    final streakData = await StreakService.updateDailyStreak();
    if (mounted) {
      setState(() {
        _streakData = streakData;
      });
      
      // Show milestone celebration if reached
      if (StreakService.isStreakMilestone(streakData.currentStreak)) {
        _showMilestoneCelebration(streakData.currentStreak);
      }
    }
  }

  void _showMilestoneCelebration(int streak) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Milestone Reached! ${StreakService.getStreakIcon(streak)}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Text(
          StreakService.getMilestoneMessage(streak),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue Journey'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DailyWisdomScreen(streakData: _streakData),
          const CollectionScreen(),
          ProfileScreen(streakData: _streakData),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.orange[700],
          unselectedItemColor: Colors.grey[500],
          backgroundColor: Colors.white,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.wb_sunny_outlined),
              activeIcon: Icon(Icons.wb_sunny),
              label: 'Daily Wisdom',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books_outlined),
              activeIcon: Icon(Icons.library_books),
              label: 'Collection',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class DailyWisdomScreen extends StatelessWidget {
  final StreakData? streakData;
  
  const DailyWisdomScreen({Key? key, this.streakData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todaysSubhashita = SubhashitaRepository.getTodaysSubhashita();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Wisdom'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF8E1), Color(0xFFFFE0B2)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              if (streakData != null) ...[StreakCard(streakData: streakData!)],


              const SizedBox(height: 20),
              Text(
                'Today\'s Wisdom',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: const Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(height: 30),
              _buildSubhashitaCard(todaysSubhashita),
              const SizedBox(height: 30),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubhashitaCard(Subhashita subhashita) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            subhashita.sanskrit,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6A4C93),
              height: 1.8,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(height: 1, color: Colors.orange.withOpacity(0.3)),
          const SizedBox(height: 24),
          Text(
            subhashita.translation,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF4A4A4A),
              height: 1.7,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            subhashita.meaning,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border, size: 20),
            label: const Text('Save'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange[700],
              side: BorderSide(color: Colors.orange[300]!),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.share, size: 20),
            label: const Text('Share'),
          ),
        ),
      ],
    );
  }
}



class CollectionScreen extends StatelessWidget {
  const CollectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = SubhashitaRepository.getCategories();
    final unlockedCategories = SubhashitaRepository.getUnlockedCategories();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collection'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF8E1), Color(0xFFFFE0B2)],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isUnlocked = unlockedCategories.contains(category);
            
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isUnlocked ? Colors.orange[100] : Colors.grey[200],
                    child: Icon(
                      isUnlocked ? Icons.menu_book : Icons.lock,
                      color: isUnlocked ? Colors.orange[700] : Colors.grey[500],
                    ),
                  ),
                  title: Text(
                    category,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isUnlocked ? const Color(0xFF4A4A4A) : Colors.grey[500],
                    ),
                  ),
                  subtitle: Text(
                    isUnlocked ? 'Tap to explore' : 'Coming soon',
                    style: TextStyle(
                      color: isUnlocked ? Colors.grey[600] : Colors.grey[400],
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: isUnlocked ? Colors.orange[700] : Colors.grey[400],
                  ),
                  onTap: isUnlocked ? () => _showCategoryDetails(context, category) : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showCategoryDetails(BuildContext context, String category) {
    final subhashitas = SubhashitaRepository.getSubhashitasByCategory(category);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              child: Text(
                category,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: subhashitas.length,
                itemBuilder: (context, index) {
                  final subhashita = subhashitas[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subhashita.sanskrit,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF6A4C93),
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            subhashita.translation,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4A4A4A),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final StreakData? streakData;
  
  const ProfileScreen({Key? key, this.streakData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF8E1), Color(0xFFFFE0B2)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.orange,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 24),
              Text(
                'Wisdom Seeker',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 40),
              _buildStatsCard(),
              const SizedBox(height: 24),
              _buildMenuItems(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Current Streak', '${streakData?.currentStreak ?? 0}'),
                _buildStat('Longest Streak', '${streakData?.longestStreak ?? 0}'),
                _buildStat('Total Visits', '${streakData?.totalVisits ?? 0}'),
              ],
            ),
            if (streakData != null) ...[
              const SizedBox(height: 20),
              Text(
                'Achievement: ${StreakService.getAchievementLevel(streakData!.longestStreak)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A4A4A),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(Icons.favorite, 'My Favorites', () {}),
        _buildMenuItem(Icons.settings, 'Settings', () {}),
        _buildMenuItem(Icons.info, 'About', () {}),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange[700]),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
class StreakCard extends StatelessWidget {
  final StreakData streakData;

  const StreakCard({Key? key, required this.streakData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            StreakService.getStreakIcon(streakData.currentStreak),
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${streakData.currentStreak} Day Streak',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                Text(
                  StreakService.getStreakMessage(streakData.currentStreak),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
