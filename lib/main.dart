import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sky_hack/constants.dart';
import 'package:sky_hack/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    debug: true,
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nebula Horizon App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kDeepSpace,
        fontFamily: 'monospace',
        useMaterial3: true,

        // AppBar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: kNeonBlue),
          titleTextStyle: TextStyle(
            color: kNeonBlue,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.2,
          ),
        ),

        // Text Theme
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white70),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: kAquaGlow, fontWeight: FontWeight.bold),
        ),

        // ElevatedButton Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kNeonBlue,
            foregroundColor: kDeepSpace,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.4,
            ),
          ),
        ),

        // TextField Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kTransparentWhite,
          labelStyle: TextStyle(color: kNeonBlue.withOpacity(0.6)),
          prefixIconColor: kNeonBlue,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: kNeonBlue, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: kAquaGlow, width: 2),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
