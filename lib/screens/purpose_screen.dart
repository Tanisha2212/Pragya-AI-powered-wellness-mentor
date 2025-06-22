import 'package:flutter/material.dart';
import 'welcome_screen.dart';

class PurposeScreen extends StatefulWidget {
  const PurposeScreen({Key? key}) : super(key: key);

  @override
  State<PurposeScreen> createState() => _PurposeScreenState();
}

class _PurposeScreenState extends State<PurposeScreen>
    with TickerProviderStateMixin {
  late AnimationController _sunController;
  late Animation<double> _sunScaleAnimation;
  late Animation<double> _sunOpacityAnimation;
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Sun animation setup - slower expansion and fade out
    _sunController = AnimationController(
      duration: const Duration(seconds: 5), // Longer duration for slower effect
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _sunController.reverse(); // Optional: makes the sun shrink back
        }
      });

    // Sun grows slowly from small to very large
    _sunScaleAnimation = Tween<double>(
      begin: 0.2,  // Very small start
      end: 3.0,    // Very large end
    ).animate(
      CurvedAnimation(
        parent: _sunController,
        curve: Curves.easeInOutSine, // Smooth slow expansion
      ),
    );

    // Sun fades in quickly, stays visible, then fades out slowly
    _sunOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 0.2), // Fade in quickly
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.0), weight: 0.5), // Stay visible
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0),weight: 0.5), // Fade out slowly
    ]).animate(
      CurvedAnimation(
        parent: _sunController,
        curve: Curves.easeInOut,
      ),
    );

    // Start sun animation immediately
    _sunController.forward();

    // Content animations
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeIn,
      ),
    );

    // Delay content animations slightly to let sun animation start first
    Future.delayed(const Duration(milliseconds: 800), () {
      _slideController.forward();
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _sunController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF8E1),
                  Color(0xFFFFE0B2),
                ],
              ),
            ),
          ),

          // Sun animation - centered and expanding
          Center(
            child: AnimatedBuilder(
              animation: _sunController,
              builder: (context, child) {
                return Opacity(
                  opacity: _sunOpacityAnimation.value,
                  child: Transform.scale(
                    scale: _sunScaleAnimation.value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.orange.shade400.withOpacity(0.8),
                            Colors.orange.shade200.withOpacity(0.6),
                            Colors.yellow.shade100.withOpacity(0.4),
                          ],
                          stops: const [0.1, 0.6, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepOrange.withOpacity(0.3 * _sunOpacityAnimation.value),
                            blurRadius: 100,
                            spreadRadius: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Rest of your content remains the same...
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          // Cultural Symbol
                          SlideTransition(
                            position: _slideAnimation,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.orange.withOpacity(0.2),
                                      blurRadius: 30,
                                      offset: const Offset(0, 15),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'ॐ',
                                    style: TextStyle(
                                      fontSize: 80,
                                      color: Colors.orange[700],
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          // Purpose Text
                          SlideTransition(
                            position: _slideAnimation,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Column(
                                children: [
                                  Text(
                                    'Discover Ancient Wisdom',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                      color: const Color(0xFF4A4A4A),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'When people think of Sanskrit, they often recall the Bhagavad Gita, Ramayana, or Mahabharata — epic texts with known authors and grand stories. Yet, the simple two-line Subhashitas, often penned by unknown thinkers, quietly hold centuries of practical wisdom. These gems, though overlooked, teach us about ethics, clarity, joy, and human nature in the most concise and poetic way.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                      height: 1.8,
                                      color: const Color(0xFF555555),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Feature Cards
                          SlideTransition(
                            position: _slideAnimation,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Column(
                                children: [
                                  _buildFeatureCard(
                                    icon: Icons.wb_sunny_outlined,
                                    title: 'Daily Wisdom',
                                    description:
                                        'Start each day with a meaningful Subhashita',
                                  ),
                                  const SizedBox(height: 20),
                                  _buildFeatureCard(
                                    icon: Icons.library_books_outlined,
                                    title: 'Rich Collection',
                                    description:
                                        'Explore categorized ancient texts and their meanings',
                                  ),
                                  const SizedBox(height: 20),
                                  _buildFeatureCard(
                                    icon: Icons.translate_outlined,
                                    title: 'Clear Translations',
                                    description:
                                        'Understand the depth with English and Marathi translations',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Continue Button
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 24),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                pageBuilder: (context, animation,
                                        secondaryAnimation) =>
                                    const WelcomeScreen(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                                transitionDuration:
                                    const Duration(milliseconds: 600),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Begin Journey',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
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
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.orange[700],
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                    height: 1.4,
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