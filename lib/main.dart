import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testing_aplikasi/screen/authentication/FORGOT_PASSWORD/create_new_password_page.dart';
import 'package:testing_aplikasi/screen/authentication/FORGOT_PASSWORD/verify_otp_page.dart';
import 'package:testing_aplikasi/screen/authentication/edit_profile_screen.dart';
import 'dart:convert';
import 'package:testing_aplikasi/screen/authentication/login.screen.dart';
import 'package:testing_aplikasi/screen/authentication/FORGOT_PASSWORD/Forgotpasswordpage.dart';
import 'package:testing_aplikasi/screen/authentication/user_profile_screen.dart';
import 'package:testing_aplikasi/screen/disease_detail_page.dart';
import 'package:testing_aplikasi/screen/history_page.dart';
import 'package:testing_aplikasi/screen/home_page.dart';
import 'package:testing_aplikasi/screen/prediction_page.dart';
import 'package:testing_aplikasi/screen/pustaka_penyakit_page.dart';
import 'package:testing_aplikasi/screen/onboarding_screen.dart'; // IMPORT ONBOARDING
import 'package:testing_aplikasi/screen/splash_screen.dart'; // IMPORT SPLASH SCREEN

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://vpkuuwexgdjbodgwqcni.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZwa3V1d2V4Z2RqYm9kZ3dxY25pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM0NTgyNDUsImV4cCI6MjA3OTAzNDI0NX0.QMybl6pDOkSXOErH0wFqpWXej_kmQWX3SWAaFJFK-QU',
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TomatoCare',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFFBF9F9),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash', // CHANGE: dari _getInitialRoute() menjadi '/splash'
      routes: {
        '/splash': (context) => const SplashScreen(), // ROUTE SPLASH SCREEN
        '/onboarding': (context) => const OnboardingScreen(), // ROUTE ONBOARDING
        '/login': (context) => const LoginScreen(),
        '/forget_password': (context) => const ForgotPasswordPage(),
        '/home': (context) => const HomePage(),
        "/info": (context) => const PustakaPenyakitPage(),
        '/profil': (context) => const UserProfileScreen(),
        '/edit_profile': (context) => const EditProfileScreen(),
        '/HistoryPage': (context) => const HistoryPage(),
        '/prediction': (context) => const PredictionPage(),
      },
    );
  }
}