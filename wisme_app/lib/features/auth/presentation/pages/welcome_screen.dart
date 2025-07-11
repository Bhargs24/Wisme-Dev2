import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/components/wisme_button.dart';

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
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 
                        MediaQuery.of(context).padding.top - 
                        MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
            children: [
              // ===== TOP SPACING =====
              const SizedBox(height: 40),
              
              // ===== HERO SECTION =====
              Expanded(
                flex: 3,
                child: Column(
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
                      child: Icon(
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
                      'Learn anything in just 10 minutes daily with your AI-powered learning coach',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              // ===== FEATURES HIGHLIGHT =====
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _FeatureItem(
                      icon: Icons.psychology_rounded,
                      title: 'AI-Powered Learning',
                      subtitle: 'Personalized lessons adapted to your pace',
                    ),
                    const SizedBox(height: 24),
                    _FeatureItem(
                      icon: Icons.timer_rounded,
                      title: '10 Minutes Daily',
                      subtitle: 'Build knowledge with micro-learning sessions',
                    ),
                    const SizedBox(height: 24),
                    _FeatureItem(
                      icon: Icons.emoji_events_rounded,
                      title: 'Track Progress',
                      subtitle: 'Celebrate achievements and maintain streaks',
                    ),
                  ],
                ),
              ),
              
              // ===== ACTION BUTTONS =====
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    // Primary CTA
                    WismeButton(
                      text: 'Get Started',
                      variant: WismeButtonVariant.primary,
                      size: WismeButtonSize.large,
                      onPressed: () {
                        // TODO: Navigate to Sign Up
                        _navigateToSignUp(context);
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
                        // TODO: Navigate to Sign In
                        _navigateToSignIn(context);
                      },
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToSignUp(BuildContext context) {
    // TODO: Implement navigation to sign up screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sign Up screen coming soon! 🚀'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToSignIn(BuildContext context) {
    // TODO: Implement navigation to sign in screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sign In screen coming soon! 🔑'),
        behavior: SnackBarBehavior.floating,
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
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
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
