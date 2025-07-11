import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/shared.dart';
import '../../../../core/core.dart';

/// Account Setup Screen - Optional profile completion after sign up
/// Features username, T&Cs acceptance, and optional preferences
class AccountSetupScreen extends ConsumerStatefulWidget {
  const AccountSetupScreen({super.key});

  @override
  ConsumerState<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends ConsumerState<AccountSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  
  bool _agreeToTerms = false;
  bool _agreeToPrivacy = false;
  bool _allowNotifications = true;
  bool _allowAnalytics = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _handleSetupComplete() async {
    if (!_formKey.currentState!.validate() || !_agreeToTerms || !_agreeToPrivacy) {
      if (!_agreeToTerms || !_agreeToPrivacy) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please accept the Terms of Service and Privacy Policy to continue'),
            backgroundColor: WismeColors.error,
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Save user preferences and setup
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      // Navigate to onboarding or home
      if (mounted) {
        // TODO: Navigate to onboarding flow
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Welcome to Wisme! Let\'s get you started.'),
            backgroundColor: WismeColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Setup failed: ${e.toString()}'),
            backgroundColor: WismeColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Setup'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ===== HEADER =====
                const SizedBox(height: 20),
                
                Text(
                  'Almost There!',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: WismeColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Just a few quick details to personalize your learning experience',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: WismeColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // ===== FORM FIELDS =====
                
                // Username Field (Optional)
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username (Optional)',
                    hintText: 'Choose a unique username',
                    prefixIcon: Icon(Icons.alternate_email),
                    helperText: 'You can always change this later',
                  ),
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      if (value.trim().length < 3) {
                        return 'Username must be at least 3 characters';
                      }
                      if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                        return 'Username can only contain letters, numbers, and underscores';
                      }
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 32),
                
                // ===== PREFERENCES SECTION =====
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Privacy & Preferences',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: WismeColors.textPrimary,
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Notifications Toggle
                        Row(
                          children: [
                            Icon(
                              Icons.notifications_outlined,
                              color: WismeColors.textSecondary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Daily Learning Reminders',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Get gentle nudges to keep your streak alive',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: WismeColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _allowNotifications,
                              onChanged: (value) {
                                setState(() {
                                  _allowNotifications = value;
                                });
                              },
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Analytics Toggle
                        Row(
                          children: [
                            Icon(
                              Icons.analytics_outlined,
                              color: WismeColors.textSecondary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Help Improve Wisme',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Share anonymous usage data to make the app better',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: WismeColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _allowAnalytics,
                              onChanged: (value) {
                                setState(() {
                                  _allowAnalytics = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // ===== TERMS AND CONDITIONS =====
                
                // Terms of Service Checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _agreeToTerms = !_agreeToTerms;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: WismeColors.textSecondary,
                              ),
                              children: [
                                const TextSpan(text: 'I agree to the '),
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: WismeColors.primaryBlue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Privacy Policy Checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _agreeToPrivacy,
                      onChanged: (value) {
                        setState(() {
                          _agreeToPrivacy = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _agreeToPrivacy = !_agreeToPrivacy;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: WismeColors.textSecondary,
                              ),
                              children: [
                                const TextSpan(text: 'I agree to the '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: WismeColors.primaryBlue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // ===== COMPLETE SETUP BUTTON =====
                WismeButton(
                  text: 'Complete Setup',
                  onPressed: _isLoading ? null : _handleSetupComplete,
                  size: WismeButtonSize.large,
                  state: _isLoading ? WismeButtonState.loading : WismeButtonState.enabled,
                ),
                
                const SizedBox(height: 16),
                
                // ===== SKIP BUTTON =====
                WismeButton(
                  text: 'Skip for Now',
                  onPressed: () {
                    // TODO: Navigate to onboarding with minimal setup
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You can complete setup later in Settings'),
                      ),
                    );
                  },
                  variant: WismeButtonVariant.ghost,
                  size: WismeButtonSize.medium,
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
