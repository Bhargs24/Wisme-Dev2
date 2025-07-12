import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../../features/onboarding/onboarding_flow.dart';
import '../../../../features/auth/presentation/pages/sign_up_screen_complete.dart';

/// Welcome Screen - First user touchpoint with professional onboarding
/// Implements WismeAnimations, WismeTheme, WismeResponsive, WismeAccessibility
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: WismeAnimations.medium,
      vsync: this,
    );
    _controller.forward();
    
    // Track screen view
    WismeAnalytics.trackScreenView('welcome_screen');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: WismeTheme.primaryGradient,
        ),
        child: SafeArea(
          child: WismeResponsive.responsiveWrap(
            context: context,
            child: Padding(
              padding: WismeResponsive.responsivePadding(context),
              child: Column(
                children: [
                  // Logo Section
                  WismeAnimations.fadeIn(
                    child: WismeAnimations.heroLogo(
                      child: Container(
                        height: WismeResponsive.responsiveImageSize(context),
                        width: WismeResponsive.responsiveImageSize(context),
                        decoration: BoxDecoration(
                          color: WismeTheme.neutralWhite,
                          shape: BoxShape.circle,
                          boxShadow: WismeTheme.shadowLG,
                        ),
                        child: Icon(
                          Icons.psychology,
                          size: WismeResponsive.responsiveIconSize(context) * 2,
                          color: WismeTheme.primaryBlue,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: WismeResponsive.responsiveVerticalSpacing(context)),
                  
                  // Title Section
                  WismeAnimations.slideInFromBottom(
                    delay: const Duration(milliseconds: 200),
                    child: Column(
                      children: [
                        Text(
                          'Welcome to Wisme',
                          style: WismeTheme.displayLarge.copyWith(
                            color: WismeTheme.neutralWhite,
                            fontSize: WismeResponsive.responsiveFontSize(
                              context,
                              baseFontSize: 32,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: WismeTheme.spaceSM),
                        Text(
                          'Your AI Learning Companion\nBeyond Duolingo Quality',
                          style: WismeTheme.bodyLarge.copyWith(
                            color: WismeTheme.neutralWhite.withOpacity(0.9),
                            fontSize: WismeResponsive.responsiveFontSize(
                              context,
                              baseFontSize: 16,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: WismeResponsive.responsiveVerticalSpacing(context)),
                  
                  // Features Section
                  Expanded(
                    child: WismeAnimations.staggeredList(
                      children: [
                        _FeatureItem(
                          icon: Icons.psychology_outlined,
                          title: 'AI-Powered Learning',
                          description: 'Personalized curriculum that adapts to your pace',
                        ),
                        _FeatureItem(
                          icon: Icons.trending_up,
                          title: 'Progress Tracking',
                          description: 'Beautiful visualizations of your learning journey',
                        ),
                        _FeatureItem(
                          icon: Icons.people_outline,
                          title: 'Community Learning',
                          description: 'Connect with learners worldwide',
                        ),
                      ],
                      staggerDelay: const Duration(milliseconds: 100),
                    ),
                  ),
                  
                  // CTA Section
                  WismeAnimations.slideInFromBottom(
                    delay: const Duration(milliseconds: 600),
                    child: Column(
                      children: [
                        // Primary CTA
                        WismeAccessibility.accessibleButton(
                          label: 'Create new account',
                          onPressed: () {
                            WismeAnalytics.trackButtonPress('sign_up_button', 'welcome_screen');
                            WismeAccessibility.lightHaptic();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: WismeResponsive.responsiveButtonSize(context).height,
                            decoration: BoxDecoration(
                              color: WismeTheme.neutralWhite,
                              borderRadius: BorderRadius.circular(WismeTheme.radiusMD),
                              boxShadow: WismeTheme.shadowMD,
                            ),
                            child: Center(
                              child: Text(
                                'Get Started',
                                style: WismeTheme.labelLarge.copyWith(
                                  color: WismeTheme.primaryBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: WismeTheme.spaceMD),
                        
                        // Secondary CTA
                        WismeAccessibility.accessibleButton(
                          label: 'Sign in to existing account',
                          onPressed: () {
                            WismeAnalytics.trackButtonPress('sign_in_button', 'welcome_screen');
                            WismeAccessibility.lightHaptic();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignInScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: WismeResponsive.responsiveButtonSize(context).height,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(WismeTheme.radiusMD),
                              border: Border.all(
                                color: WismeTheme.neutralWhite,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Sign In',
                                style: WismeTheme.labelLarge.copyWith(
                                  color: WismeTheme.neutralWhite,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Feature item widget for highlighting app benefits
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return WismeAccessibility.accessibleCard(
      label: '$title: $description',
      child: Padding(
        padding: EdgeInsets.all(WismeTheme.spaceMD),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(WismeTheme.spaceSM),
              decoration: BoxDecoration(
                color: WismeTheme.neutralWhite.withOpacity(0.2),
                borderRadius: BorderRadius.circular(WismeTheme.radiusSM),
              ),
              child: Icon(
                icon,
                color: WismeTheme.neutralWhite,
                size: WismeResponsive.responsiveIconSize(context),
              ),
            ),
            SizedBox(width: WismeTheme.spaceMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: WismeTheme.titleMedium.copyWith(
                      color: WismeTheme.neutralWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: WismeTheme.spaceXS),
                  Text(
                    description,
                    style: WismeTheme.bodySmall.copyWith(
                      color: WismeTheme.neutralWhite.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
