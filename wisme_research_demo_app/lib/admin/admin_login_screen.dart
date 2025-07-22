import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../analytics/analytics_dashboard_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  // Simple admin password - in production, use proper authentication
  static const String _adminPassword = "REDACTED_ADMIN_PASSWORD_SET_VIA_ENV";

  void _attemptLogin() {
    if (_passwordController.text == _adminPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AnalyticsDashboardScreen()),
      );
    } else {
      setState(() {
        _errorMessage = "Invalid admin password";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.admin_panel_settings,
                size: 48,
                color: AppColors.accentGreen,
              ),
              const SizedBox(height: 24),
              Text(
                'Admin Access',
                style: AppTextStyles.heading1.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter admin password to access analytics',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Admin Password',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.accentGreen),
                  ),
                ),
                onSubmitted: (_) => _attemptLogin(),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: AppColors.accentRed, fontSize: 14),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _attemptLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'Access Analytics',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
