import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routes.dart';
import 'design_system/themes/app_theme.dart';
import 'providers/settings_provider.dart';
import 'UI/widgets/auth_wrapper.dart';

class WismeApp extends StatelessWidget {
  const WismeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp(
          title: 'Wisme - Microlearning App',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: settingsProvider.themeMode,
          home: const AuthWrapper(), // ✅ CRITICAL FIX: Proper authentication flow
          routes: AppRoutes.routes,
          onGenerateRoute: AppRoutes.generateRoute,
        );
      },
    );
  }
}

