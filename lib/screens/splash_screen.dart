//screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'purpose_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin { 
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _lotusRotateController;
  late AnimationController _lotusBloomController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _lotusRotateController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _lotusBloomController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _startAnimations();
    _navigateToNext();
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _scaleController.forward();
    });
  }

  void _navigateToNext() {
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const PurposeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _lotusRotateController.dispose();
    _lotusBloomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: Container(
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
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _fadeAnimation,
              _scaleAnimation,
            ]),
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Simple Book Icon
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFFF9800),
                                  Color(0xFFFF6F00),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.auto_stories,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 40),
                          // App Title with larger font
                          Text(
                            'Pragya',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 48,
                              color: const Color(0xFF4A4A4A),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Subtitle with larger font
                          Text(
                            'प्रज्ञा - Wisdom in Practice',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontSize: 20,
                              color: const Color(0xFF666666),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      // 3D Pink Lotus Animation
                      Positioned(
                        bottom: 40,
                        child: AnimatedBuilder(
                          animation: _lotusRotateController,
                          builder: (context, child) {
                            return Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001) // Perspective
                                ..rotateX(1.22) // ~70 degrees in radians
                                ..rotateZ(_lotusRotateController.value * 2 * 3.14159),
                              alignment: Alignment.center,
                              child: _buildLotusFlower(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLotusFlower() {
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer layer (8 petals)
          for (int i = 0; i < 8; i++)
            AnimatedBuilder(
              animation: _lotusBloomController,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..rotateZ(i * (2 * 3.14159 / 8))
                    ..rotateX(0.26) // ~15 degrees
                    ..rotateY(0.087), // ~5 degrees
                  alignment: Alignment.topCenter,
                  child: Transform.scale(
                    scale: _lotusBloomController.value,
                    child: CustomPaint(
                      size: const Size(72, 72),
                      painter: _LotusPetalPainter(
                        color1: const Color(0xFFF48FB1),
                        color2: const Color(0xFFEC407A),
                      ),
                    ),
                  ),
                );
              },
            ),
          
          // Middle layer (6 petals)
          for (int i = 0; i < 6; i++)
            AnimatedBuilder(
              animation: _lotusBloomController,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..rotateZ(i * (2 * 3.14159 / 6))
                    ..rotateX(0.52) // ~30 degrees
                    ..rotateY(0.087), // ~5 degrees
                  alignment: Alignment.topCenter,
                  child: Transform.scale(
                    scale: _lotusBloomController.value,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: CustomPaint(
                        size: const Size(60, 60),
                        painter: _LotusPetalPainter(
                          color1: const Color(0xFFF06292),
                          color2: const Color(0xFFE91E63),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          
          // Inner layer (3 petals)
          for (int i = 0; i < 3; i++)
            AnimatedBuilder(
              animation: _lotusBloomController,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..rotateZ(i * (2 * 3.14159 / 3))
                    ..rotateX(1.05) // ~60 degrees
                    ..rotateY(0.087), // ~5 degrees
                  alignment: Alignment.topCenter,
                  child: Transform.scale(
                    scale: _lotusBloomController.value,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: CustomPaint(
                        size: const Size(48, 48),
                        painter: _LotusPetalPainter(
                          color1: const Color(0xFFE91E63),
                          color2: const Color(0xFFC2185B),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          
          // Center circle
          Transform.scale(
            scale: _lotusBloomController.value,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFE91E63),
                    const Color(0xFFAD1457),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LotusPetalPainter extends CustomPainter {
  final Color color1;
  final Color color2;

  _LotusPetalPainter({required this.color1, required this.color2});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [color1, color2],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.quadraticBezierTo(
      size.width * 0.8, size.height * 0.3,
      size.width / 2, size.height,
    );
    path.quadraticBezierTo(
      size.width * 0.2, size.height * 0.3,
      size.width / 2, 0,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LotusPetalPainter oldDelegate) =>
      oldDelegate.color1 != color1 || oldDelegate.color2 != color2;
}