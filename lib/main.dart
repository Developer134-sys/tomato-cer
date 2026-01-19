import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testing_aplikasi/screen/authentication/edit_profile_screen.dart';
import 'package:testing_aplikasi/screen/authentication/login.screen.dart';
import 'package:testing_aplikasi/screen/authentication/user_profile_screen.dart';
import 'package:testing_aplikasi/screen/history_page.dart';
import 'package:testing_aplikasi/screen/home_Page.dart';

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
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomePage(),
        '/profil': (context) => const UserProfileScreen(),
        '/edit_profile': (context) => const EditProfileScreen(),
        '/HistoryPage': (context) => HistoryPage(),
        // '/edit_profile': (context) => const EditProfileScreen(),
      },
    );
  }
}