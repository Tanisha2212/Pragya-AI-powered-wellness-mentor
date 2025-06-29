// screens/daily_wisdom_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sanskrit_daily_subhasita/screens/subhashita_service.dart';
import 'package:sanskrit_daily_subhasita/models/subhashita_model.dart';

class DailyWisdomScreen extends StatefulWidget {
  const DailyWisdomScreen({super.key});

  @override
  State<DailyWisdomScreen> createState() => _DailyWisdomScreenState();
}

class _DailyWisdomScreenState extends State<DailyWisdomScreen> {
  Subhashita? todaysSubhashita;
  bool isLoading = true;
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _loadTodaysWisdom();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await flutterTts.setLanguage("hi-IN");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
  }

  Future<void> _loadTodaysWisdom() async {
    await SubhashitaService.loadSubhashitas();
    setState(() {
      todaysSubhashita = SubhashitaService.getTodaysSubhashita();
      isLoading = false;
    });
  }

  Future<void> _speakText(String text) async {
    await flutterTts.speak(text);
  }

  Future<void> _getNewWisdom() async {
    setState(() {
      isLoading = true;
    });
    
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      todaysSubhashita = SubhashitaService.getRandomSubhashita();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Wisdom'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _getNewWisdom,
            icon: const Icon(Icons.refresh),
            tooltip: 'Get New Wisdom',
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
                    Text(
                      'Today\'s Wisdom',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: const Color(0xFF4A4A4A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (todaysSubhashita != null) 
                      _buildSubhashitaCard(todaysSubhashita!),
                    const SizedBox(height: 32),
                    _buildActionButtons(),
                    const SizedBox(height: 24),
                    _buildInsightCard(),
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
          Row(
            children: [
              Expanded(
                child: Text(
                  subhashita.sanskrit,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6A4C93),
                    height: 1.8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                onPressed: () => _speakText(subhashita.sanskrit),
                icon: Icon(Icons.volume_up, color: Colors.orange[700]),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(height: 1, color: Colors.orange.withOpacity(0.3)),
          const SizedBox(height: 24),
          Text(
            subhashita.english,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF4A4A4A),
              height: 1.7,
            ),
            textAlign: TextAlign.center,
          ),
          if (subhashita.marathi.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              subhashita.marathi,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
                height: 1.6,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
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
            label: const Text('Save to Favorites'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange[700],
              side: BorderSide(color: Colors.orange[300]!),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.share, size: 20),
            label: const Text('Share Wisdom'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInsightCard() {
    if (todaysSubhashita == null) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.orange[700]),
              const SizedBox(width: 8),
              const Text(
                'Today\'s Insight',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A4A4A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'This ${todaysSubhashita!.category} verse from ${todaysSubhashita!.deity} teaches us about ${todaysSubhashita!.keywords.join(", ")}. Reflect on how this wisdom can guide your day.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
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