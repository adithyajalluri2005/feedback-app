import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // router is created once and never replaced — go_router handles
    // auth redirects internally via _RouterNotifier's refreshListenable
    final router = ref.read(routerProvider);
    return MaterialApp.router(
      title: 'Local Vyapari Admin',
      debugShowCheckedModeBanner: false,
      theme: _buildDarkTheme(),
      routerConfig: router,
    );
  }

  ThemeData _buildDarkTheme() {
    const surface = Color(0xFF1A1A2E);
    const card = Color(0xFF16213E);
    const accent = Color(0xFF0F3460);
    const primary = Color(0xFFE94560);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: Color(0xFF533483),
        surface: surface,
        surfaceContainerHighest: card,
        onSurface: Colors.white,
        outline: Colors.white12,
      ),
      scaffoldBackgroundColor: surface,
      cardColor: card,
      appBarTheme: AppBarTheme(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primary),
        ),
        labelStyle: const TextStyle(color: Colors.white54),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: accent,
        selectedColor: primary,
        labelStyle: const TextStyle(color: Colors.white70),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
