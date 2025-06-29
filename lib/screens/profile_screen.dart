// screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:sanskrit_daily_subhasita/screens/subhashita_service.dart';

import 'package:sanskrit_daily_subhasita/models/subhashita_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Subhashita> favorites = [];
  bool isLoading = true;
  String username = 'Wisdom Seeker';
  int dailyGoal = 1;
  bool notificationsEnabled = true;
  String preferredLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await SubhashitaService.loadSubhashitas();
    favorites = SubhashitaService.getFavorites();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF8E1), Color(0xFFFFE0B2)],
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildProfileHeader(),
                    const SizedBox(height: 32),
                    _buildStatsCards(),
                    const SizedBox(height: 24),
                    _buildFavoritesSection(),
                    const SizedBox(height: 24),
                    _buildMenuItems(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.orange[100],
              child: Icon(Icons.person, size: 60, color: Colors.orange[700]),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.orange[700],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          username,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4A4A4A),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Wisdom Explorer',
            style: TextStyle(
              color: Colors.orange[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Favorites', '${favorites.length}', Icons.favorite)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Shared', '12', Icons.share)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Days Active', '45', Icons.calendar_today)),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Icon(icon, color: Colors.orange[700]),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
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
      ),
    );
  }

  Widget _buildFavoritesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Favorites',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A4A4A),
              ),
            ),
            TextButton(
              onPressed: () => _showAllFavorites(),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: favorites.take(5).length,
            itemBuilder: (context, index) {
              final shloka = favorites[index];
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shloka.english,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Text(
                      shloka.category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.orange[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        _buildMenuItem(Icons.favorite, 'My Favorites', () => _showAllFavorites()),
        _buildMenuItem(Icons.share, 'My Shared Posts', () {}),
        _buildMenuItem(Icons.notifications, 'Notifications', () => _showSettings()),
        _buildMenuItem(Icons.language, 'Language Settings', () => _showLanguageSettings()),
        _buildMenuItem(Icons.info, 'About App', () => _showAbout()),
        _buildMenuItem(Icons.help, 'Help & Support', () {}),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: ListTile(
          leading: Icon(icon, color: Colors.orange[700]),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              SwitchListTile(
                title: const Text('Daily Notifications'),
                subtitle: const Text('Get reminded for daily wisdom'),
                value: notificationsEnabled,
                onChanged: (value) => setState(() => notificationsEnabled = value),
                activeColor: Colors.orange[700],
              ),
              ListTile(
                title: const Text('Daily Goal'),
                subtitle: Text('Read $dailyGoal shloka per day'),
                trailing: DropdownButton<int>(
                  value: dailyGoal,
                  items: [1, 2, 3, 5].map((int value) {
                    return DropdownMenuItem<int>(value: value, child: Text('$value'));
                  }).toList(),
                  onChanged: (value) => setState(() => dailyGoal = value!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Marathi', 'Hindi'].map((lang) => 
            RadioListTile<String>(
              title: Text(lang),
              value: lang,
              groupValue: preferredLanguage,
              onChanged: (value) {
                setState(() => preferredLanguage = value!);
                Navigator.pop(context);
              },
              activeColor: Colors.orange[700],
            ),
          ).toList(),
        ),
      ),
    );
  }

  void _showAllFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('My Favorites')),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final shloka = favorites[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(shloka.english, maxLines: 2),
                  subtitle: Text(shloka.category.toUpperCase()),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {},
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Sanskrit Daily Subhashita'),
        content: const Text(
          'Discover the timeless wisdom of Sanskrit shlokas with AI-powered mood-based recommendations. '
          'Share your favorite verses with the community and embark on a journey of spiritual growth.\n\n'
          'Version 1.0.0',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}