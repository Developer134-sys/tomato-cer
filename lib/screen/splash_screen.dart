import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    // Tambahkan delay untuk efek splash
    await Future.delayed(const Duration(seconds: 2));

    // Cek apakah sudah pernah melihat onboarding
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

    if (!mounted) return;

    if (!hasSeenOnboarding) {
      // Belum pernah lihat onboarding
      Navigator.pushReplacementNamed(context, '/onboarding');
      return;
    }

    // Sudah pernah lihat onboarding, cek session login
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      // Cek apakah token masih valid
      try {
        final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        final expiresAt = session.expiresAt;

        if (currentTime < expiresAt!) {
          // Token valid, langsung ke home
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Token expired, ke login
          Navigator.pushReplacementNamed(context, '/login');
        }
      } catch (e) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      // Tidak ada session, ke login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0D631B),
              const Color(0xFF2E7D32),
              const Color(0xFF1B5E20),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Container
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.5, end: 1.0),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutBack,
                builder: (context, double scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/logo_1.png',
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Title
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                builder: (context, double opacity, child) {
                  return Opacity(opacity: opacity, child: child);
                },
                child: const Column(
                  children: [
                    Text(
                      "TomatoCare",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Deteksi Penyakit Daun Tomat",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),

              // Loading indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
