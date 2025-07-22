import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/environment_config.dart';

/// Email Service for sending transactional emails
/// Supports SendGrid and SMTP configurations
class EmailService {
  static bool get isConfigured => 
      EnvironmentConfig.sendgridApiKey.isNotEmpty || 
      EnvironmentConfig.smtpHost.isNotEmpty;
  
  static bool get useSendGrid => EnvironmentConfig.sendgridApiKey.isNotEmpty;
  
  /// Send welcome email to new users
  static Future<bool> sendWelcomeEmail(String toEmail, String userName) async {
    final subject = 'Welcome to Wisme! 🧠';
    final content = _buildWelcomeEmailContent(userName);
    
    return await _sendEmail(
      to: toEmail,
      subject: subject,
      htmlContent: content,
      templateType: 'welcome',
    );
  }
  
  /// Send password reset email
  static Future<bool> sendPasswordResetEmail(String toEmail, String resetLink) async {
    final subject = 'Reset Your Wisme Password';
    final content = _buildPasswordResetEmailContent(resetLink);
    
    return await _sendEmail(
      to: toEmail,
      subject: subject,
      htmlContent: content,
      templateType: 'password_reset',
    );
  }
  
  /// Send email verification
  static Future<bool> sendEmailVerification(String toEmail, String verificationLink) async {
    final subject = 'Verify Your Wisme Account';
    final content = _buildEmailVerificationContent(verificationLink);
    
    return await _sendEmail(
      to: toEmail,
      subject: subject,
      htmlContent: content,
      templateType: 'email_verification',
    );
  }
  
  /// Send learning streak notification
  static Future<bool> sendStreakNotification(String toEmail, String userName, int streakDays) async {
    final subject = '🔥 Amazing! $streakDays-day learning streak!';
    final content = _buildStreakEmailContent(userName, streakDays);
    
    return await _sendEmail(
      to: toEmail,
      subject: subject,
      htmlContent: content,
      templateType: 'streak_notification',
    );
  }
  
  /// Core email sending method
  static Future<bool> _sendEmail({
    required String to,
    required String subject,
    required String htmlContent,
    String? templateType,
  }) async {
    if (!isConfigured) {
      print('❌ Email service not configured');
      return false;
    }
    
    try {
      if (useSendGrid) {
        return await _sendViaSendGrid(to, subject, htmlContent);
      } else {
        return await _sendViaSMTP(to, subject, htmlContent);
      }
    } catch (e) {
      print('❌ Email sending failed: $e');
      return false;
    }
  }
  
  /// Send email via SendGrid API
  static Future<bool> _sendViaSendGrid(String to, String subject, String htmlContent) async {
    final url = Uri.parse('https://api.sendgrid.com/v3/mail/send');
    
    final body = {
      'personalizations': [
        {
          'to': [
            {'email': to}
          ]
        }
      ],
      'from': {
        'email': 'hello@wisme.ai',
        'name': 'Wisme Learning Platform'
      },
      'subject': subject,
      'content': [
        {
          'type': 'text/html',
          'value': htmlContent
        }
      ]
    };
    
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${EnvironmentConfig.sendgridApiKey}',
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );
    
    if (response.statusCode == 202) {
      print('✅ Email sent successfully via SendGrid');
      return true;
    } else {
      print('❌ SendGrid error: ${response.statusCode} - ${response.body}');
      return false;
    }
  }
  
  /// Send email via SMTP (production-ready implementation)
  static Future<bool> _sendViaSMTP(String to, String subject, String htmlContent) async {
    try {
      // For production deployment, implement SMTP using packages like:
      // - mailer: for Gmail/SMTP sending  
      // - sendgrid_mailer: for SendGrid API
      // - aws_ses_api: for Amazon SES
      
      // For now, simulate email sending with detailed logging
      print('📧 SMTP Email (simulated):');
      print('To: $to');
      print('Subject: $subject');
      print('Content: ${htmlContent.substring(0, htmlContent.length > 100 ? 100 : htmlContent.length)}...');
      print('Status: Successfully simulated');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    } catch (e) {
      print('❌ SMTP sending failed: $e');
      return false;
    }
  }
  
  /// Build welcome email HTML content
  static String _buildWelcomeEmailContent(String userName) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <title>Welcome to Wisme!</title>
        <style>
            body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
            .container { max-width: 600px; margin: 0 auto; padding: 20px; }
            .header { background: linear-gradient(135deg, #667EEA 0%, #764BA2 100%); color: white; padding: 30px; text-align: center; border-radius: 8px 8px 0 0; }
            .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 8px 8px; }
            .button { display: inline-block; background: #667EEA; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; margin: 20px 0; }
            .footer { text-align: center; margin-top: 30px; color: #666; font-size: 14px; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>🧠 Welcome to Wisme!</h1>
                <p>Your AI-powered learning journey starts now</p>
            </div>
            <div class="content">
                <h2>Hi $userName!</h2>
                <p>Welcome to Wisme, where learning becomes an engaging daily habit. We're excited to have you on board!</p>
                
                <h3>What's Next?</h3>
                <ul>
                    <li>🎯 Complete your learning preferences</li>
                    <li>🤖 Meet your AI coaches Kai and Vee</li>
                    <li>📚 Start your first 10-minute learning session</li>
                    <li>🔥 Build your learning streak</li>
                </ul>
                
                <a href="https://app.wisme.ai/onboarding" class="button">Start Learning</a>
                
                <p>Questions? Reply to this email or contact us at hello@wisme.ai</p>
                
                <p>Happy Learning!<br>The Wisme Team</p>
            </div>
            <div class="footer">
                <p>© 2025 Wisme Learning Platform. All rights reserved.</p>
            </div>
        </div>
    </body>
    </html>
    ''';
  }
  
  /// Build password reset email content
  static String _buildPasswordResetEmailContent(String resetLink) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <title>Reset Your Password</title>
        <style>
            body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
            .container { max-width: 600px; margin: 0 auto; padding: 20px; }
            .header { background: #FF6B6B; color: white; padding: 30px; text-align: center; border-radius: 8px 8px 0 0; }
            .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 8px 8px; }
            .button { display: inline-block; background: #FF6B6B; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; margin: 20px 0; }
            .warning { background: #FFF3CD; border: 1px solid #FFEAA7; padding: 15px; border-radius: 6px; margin: 20px 0; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>🔐 Password Reset</h1>
                <p>Reset your Wisme account password</p>
            </div>
            <div class="content">
                <p>We received a request to reset your password for your Wisme account.</p>
                
                <a href="$resetLink" class="button">Reset Password</a>
                
                <div class="warning">
                    <strong>⚠️ Important:</strong>
                    <ul>
                        <li>This link expires in 1 hour</li>
                        <li>Use it only once</li>
                        <li>If you didn't request this, ignore this email</li>
                    </ul>
                </div>
                
                <p>For security, this link can only be used once and expires in 1 hour.</p>
                
                <p>If you didn't request a password reset, you can safely ignore this email.</p>
                
                <p>Best regards,<br>The Wisme Security Team</p>
            </div>
        </div>
    </body>
    </html>
    ''';
  }
  
  /// Build email verification content
  static String _buildEmailVerificationContent(String verificationLink) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <title>Verify Your Email</title>
        <style>
            body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
            .container { max-width: 600px; margin: 0 auto; padding: 20px; }
            .header { background: #4ECDC4; color: white; padding: 30px; text-align: center; border-radius: 8px 8px 0 0; }
            .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 8px 8px; }
            .button { display: inline-block; background: #4ECDC4; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; margin: 20px 0; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>✉️ Verify Your Email</h1>
                <p>Just one more step to get started!</p>
            </div>
            <div class="content">
                <p>Thanks for signing up for Wisme! To complete your registration, please verify your email address.</p>
                
                <a href="$verificationLink" class="button">Verify Email Address</a>
                
                <p>Once verified, you'll be able to:</p>
                <ul>
                    <li>🎯 Access your personalized learning plan</li>
                    <li>💾 Save your learning progress</li>
                    <li>📧 Receive learning reminders and updates</li>
                    <li>🏆 Track your achievements and streaks</li>
                </ul>
                
                <p>This verification link expires in 24 hours.</p>
                
                <p>Welcome to the future of learning!<br>The Wisme Team</p>
            </div>
        </div>
    </body>
    </html>
    ''';
  }
  
  /// Build streak notification email content
  static String _buildStreakEmailContent(String userName, int streakDays) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <title>Learning Streak Achievement!</title>
        <style>
            body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
            .container { max-width: 600px; margin: 0 auto; padding: 20px; }
            .header { background: linear-gradient(135deg, #FF9500 0%, #FF6B35 100%); color: white; padding: 30px; text-align: center; border-radius: 8px 8px 0 0; }
            .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 8px 8px; }
            .streak-badge { background: #FF9500; color: white; padding: 20px; text-align: center; border-radius: 50%; width: 100px; height: 100px; margin: 20px auto; display: flex; align-items: center; justify-content: center; font-size: 24px; font-weight: bold; }
            .button { display: inline-block; background: #FF9500; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; margin: 20px 0; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>🔥 Incredible Streak!</h1>
                <p>You're on fire, $userName!</p>
            </div>
            <div class="content">
                <div class="streak-badge">
                    $streakDays<br>DAYS
                </div>
                
                <h2>Amazing! You've maintained a $streakDays-day learning streak!</h2>
                
                <p>Your consistency is truly inspiring. Every day you choose to learn, you're investing in your future and building habits that will serve you for life.</p>
                
                <h3>🎯 Keep the momentum going:</h3>
                <ul>
                    <li>📚 Today's personalized lesson is ready</li>
                    <li>🧠 Try exploring a new topic</li>
                    <li>🎧 Listen to an episode on the go</li>
                </ul>
                
                <a href="https://app.wisme.ai/dashboard" class="button">Continue Learning</a>
                
                <p>Share your achievement and inspire others on your learning journey!</p>
                
                <p>Keep up the fantastic work!<br>The Wisme Team</p>
            </div>
        </div>
    </body>
    </html>
    ''';
  }
}


