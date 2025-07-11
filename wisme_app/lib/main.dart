import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared/themes/app_theme.dart';

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
      home: WismeHomePage(),
      
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

/// Temporary homepage to demonstrate our design system
/// This will be replaced with proper authentication and onboarding flows
class WismeHomePage extends ConsumerWidget {
  const WismeHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wisme'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== HERO SECTION =====
              Text(
                'Welcome to Wisme',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Your AI-powered learning companion. Learn anything in 10 minutes daily.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              
              // ===== DESIGN SYSTEM SHOWCASE =====
              Text(
                'Design System Components',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              
              // Button Examples
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Primary Button'),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: Text('Secondary Button'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Text Button'),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Card Example
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sample Learning Card',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This demonstrates our card styling with proper typography, spacing, and colors.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: 0.6,
                        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '60% Complete',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Footer
              Center(
                child: Text(
                  'Building the future of learning 🚀',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome to Wisme! 🎉'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        tooltip: 'Start Learning',
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
