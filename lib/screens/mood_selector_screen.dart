// screens/mood_selector_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sanskrit_daily_subhasita/screens/subhashita_service.dart';

import 'package:sanskrit_daily_subhasita/models/subhashita_model.dart';

class MoodSelectorScreen extends StatefulWidget {
  const MoodSelectorScreen({super.key});

  @override
  State<MoodSelectorScreen> createState() => _MoodSelectorScreenState();
}

class _MoodSelectorScreenState extends State<MoodSelectorScreen> {
  String? selectedMood;
  List<Subhashita> recommendations = [];
  bool isLoading = false;
  final FlutterTts flutterTts = FlutterTts();

  final List<MoodOption> moods = [
    MoodOption('Happy', Icons.sentiment_very_satisfied, Colors.amber),
    MoodOption('Sad', Icons.sentiment_very_dissatisfied, Colors.blue),
    MoodOption('Stressed', Icons.sentiment_dissatisfied, Colors.red),
    MoodOption('Anxious', Icons.psychology, Colors.purple),
    MoodOption('Angry', Icons.sentiment_very_dissatisfied, Colors.deepOrange),
    MoodOption('Peaceful', Icons.self_improvement, Colors.green),
    MoodOption('Confused', Icons.help_outline, Colors.grey),
    MoodOption('Motivated', Icons.trending_up, Colors.teal),
  ];

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await flutterTts.setLanguage("hi-IN");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
  }

  Future<void> _onMoodSelected(String mood) async {
    setState(() {
      selectedMood = mood;
      isLoading = true;
    });

    await SubhashitaService.loadSubhashitas();
    final moodRecommendations = SubhashitaService.getSubhashitasForMood(mood);

    setState(() {
      recommendations = moodRecommendations;
      isLoading = false;
    });
  }

  Future<void> _speakText(String text) async {
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood-Based Guidance'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF8E1), Color(0xFFFFE0B2)],
          ),
        ),
        child: selectedMood == null
            ? _buildMoodSelector()
            : _buildRecommendations(),
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'How are you feeling today?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFF4A4A4A),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: moods.length,
              itemBuilder: (context, index) {
                final mood = moods[index];
                return _buildMoodCard(mood);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodCard(MoodOption mood) {
    return GestureDetector(
      onTap: () => _onMoodSelected(mood.name),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              mood.icon,
              size: 48,
              color: mood.color,
            ),
            const SizedBox(height: 12),
            Text(
              mood.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A4A4A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              IconButton(
                onPressed: () => setState(() {
                  selectedMood = null;
                  recommendations.clear();
                }),
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Text(
                  'Wisdom for $selectedMood mood',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFF4A4A4A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: recommendations.length,
                  itemBuilder: (context, index) {
                    return _buildRecommendationCard(recommendations[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(Subhashita subhashita) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  subhashita.sanskrit,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6A4C93),
                    height: 1.6,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _speakText(subhashita.sanskrit),
                icon: Icon(Icons.volume_up, color: Colors.orange[700]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: Colors.orange.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            subhashita.english,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF4A4A4A),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subhashita.meaning,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border, size: 18),
                  label: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.orange[700],
                    side: BorderSide(color: Colors.orange[300]!),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text('Share'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}

class MoodOption {
  final String name;
  final IconData icon;
  final Color color;

  MoodOption(this.name, this.icon, this.color);
}