import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase için ekledik
import 'home_screen.dart';

// Tema değişimini yönetmek için ValueNotifier kullanıyoruz.
ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Firebase başlatmadan önce gerekli!
  await Firebase.initializeApp(); // Firebase'i başlat

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, ThemeMode currentTheme, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bitki Teşhis Sistemi',
          theme: ThemeData(primarySwatch: Colors.green),
          darkTheme: ThemeData.dark(),
          themeMode: currentTheme, // Koyu veya açık temayı buradan yönetiyoruz.
          home: AnimatedSplashScreen(
            splashIconSize: 3131,
            duration: 2500,
            splash: 'assets/pladidilogo.jpg',
            nextScreen: MainScreen(),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.white,
          ),
        );
      },
    );
  }
}
