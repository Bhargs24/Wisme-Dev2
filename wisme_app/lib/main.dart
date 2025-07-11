import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared/themes/app_theme.dart';
import 'features/auth/auth.dart';

void main() {
  runApp(
    ProviderScope(
      child: WismeApp(),
    ),
  );
}

class WismeApp extends StatelessWidget {
  const WismeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wisme - AI Learning Coach',
      debugShowCheckedModeBanner: false,
      
      // ===== THEME CONFIGURATION =====
      theme: WismeTheme.lightTheme,
      darkTheme: WismeTheme.darkTheme,
      themeMode: ThemeMode.system,
      
      // ===== NAVIGATION =====
      home: WelcomeScreen(),
      
      // ===== PERFORMANCE OPTIMIZATIONS =====
      builder: (context, child) {
        // Ensure text doesn't scale beyond reasonable limits
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.3),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
