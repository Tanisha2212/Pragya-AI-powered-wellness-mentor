import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const PeacefulWisdomApp());
}

class PeacefulWisdomApp extends StatelessWidget {
  const PeacefulWisdomApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      title: 'Peaceful Wisdom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: const Color(0xFFFF9800),
        scaffoldBackgroundColor: const Color(0xFFFFF8E1),
        fontFamily: 'Serif',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A4A4A),
            letterSpacing: 0.5,
          ),
          displayMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Color(0xFF4A4A4A),
          ),
          headlineLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6A4C93),
          ),
          headlineMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF4A4A4A),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF555555),
            height: 1.6,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
            height: 1.5,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF9800),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 3,
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: Colors.black26,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFF8E1),
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF4A4A4A)),
          titleTextStyle: TextStyle(
            color: Color(0xFF4A4A4A),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// Color palette for the app
class AppColors {
  static const primary = Color(0xFFFF9800);
  static const secondary = Color(0xFF6A4C93);
  static const background = Color(0xFFFFF8E1);
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF4A4A4A);
  static const textSecondary = Color(0xFF666666);
  static const accent = Color(0xFFFFCC80);
  static const divider = Color(0xFFE0E0E0);
}