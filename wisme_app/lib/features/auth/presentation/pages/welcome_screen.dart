import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/shared.dart';
import 'sign_up_screen.dart';
import 'sign_in_screen.dart';

/// Welcome Screen - First screen users see when opening Wisme
/// Features beautiful animations, brand messaging, and clear CTAs
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // ===== TOP SPACING =====
              const SizedBox(height: 40),
              
              // ===== HERO SECTION =====
              Column(
                children: [
                  // App Logo/Icon - We'll add this later
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Main Headline
                  Text(
                    'Welcome to Wisme',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Subtitle
                  Text(
                    'AI-powered learning that adapts to you.\nJust 10 minutes a day to master any topic.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              
              const SizedBox(height: 60),
              
              // ===== FEATURES SECTION =====
              Column(
                children: [
                  _FeatureItem(
                    icon: Icons.psychology_outlined,
                    title: 'AI-Powered Learning',
                    subtitle: 'Personalized content that adapts to your learning style',
                  ),
                  const SizedBox(height: 20),
                  _FeatureItem(
                    icon: Icons.timer_outlined,
                    title: '10-Minute Daily Sessions',
                    subtitle: 'Bite-sized lessons that fit your busy schedule',
                  ),
                  const SizedBox(height: 20),
                  _FeatureItem(
                    icon: Icons.trending_up_outlined,
                    title: 'Track Your Progress',
                    subtitle: 'See your knowledge grow with detailed insights',
                  ),
                ],
              ),
              
              const SizedBox(height: 60),
              
              // ===== ACTION BUTTONS =====
              Column(
                children: [
                  // Primary CTA
                  WismeButton(
                    text: 'Get Started',
                    variant: WismeButtonVariant.primary,
                    size: WismeButtonSize.large,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    isFullWidth: true,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Secondary CTA
                  WismeButton(
                    text: 'I already have an account',
                    variant: WismeButtonVariant.ghost,
                    size: WismeButtonSize.medium,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Feature highlight widget for the welcome screen
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Text Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
