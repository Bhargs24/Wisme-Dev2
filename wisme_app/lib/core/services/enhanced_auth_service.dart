import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/environment_config.dart';
import '../services/supabase_service.dart';

/// Enhanced Authentication Service with OAuth Integration
/// Handles email/password, Google, and Apple authentication
class EnhancedAuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  
  /// Initialize the auth service
  void initialize() {
    _currentUser = SupabaseService.currentUser;
    
    // Listen to auth state changes
    SupabaseService.client.auth.onAuthStateChange.listen((data) {
      _currentUser = data.session?.user;
      notifyListeners();
    });
  }
  
  /// Sign up with email and password
  Future<bool> signUpWithEmail(String email, String password, String name) async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await SupabaseService.signUpWithEmail(email, password, name);
      
      if (response.user != null) {
        _currentUser = response.user;
        _setLoading(false);
        return true;
      } else {
        _setError('Failed to create account. Please try again.');
        _setLoading(false);
        return false;
      }
    } on AuthException catch (e) {
      _setError(_getReadableAuthError(e.message));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      _setLoading(false);
      return false;
    }
  }
  
  /// Sign in with email and password
  Future<bool> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      final response = await SupabaseService.signInWithEmail(email, password);
      
      if (response.user != null) {
        _currentUser = response.user;
        _setLoading(false);
        return true;
      } else {
        _setError('Invalid email or password.');
        _setLoading(false);
        return false;
      }
    } on AuthException catch (e) {
      _setError(_getReadableAuthError(e.message));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      _setLoading(false);
      return false;
    }
  }
  
  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();
    
    try {
      // Check if Google OAuth is configured
      if (EnvironmentConfig.googleClientId.isEmpty) {
        _setError('Google Sign-In is not configured. Please contact support.');
        _setLoading(false);
        return false;
      }
      
      final result = await SupabaseService.signInWithGoogle();
      
      if (result) {
        // OAuth flow initiated successfully (web redirect or mobile app)
        _setLoading(false);
        return true;
      } else {
        _setError('Google sign-in failed. Please try again.');
        _setLoading(false);
        return false;
      }
    } on AuthException catch (e) {
      _setError(_getReadableAuthError(e.message));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Google sign-in failed. Please try again.');
      _setLoading(false);
      return false;
    }
  }
  
  /// Sign in with Apple
  Future<bool> signInWithApple() async {
    _setLoading(true);
    _clearError();
    
    try {
      // Check if Apple Sign-In is configured
      if (EnvironmentConfig.appleClientId.isEmpty) {
        _setError('Apple Sign-In is not configured. Please contact support.');
        _setLoading(false);
        return false;
      }
      
      final result = await SupabaseService.signInWithApple();
      
      if (result) {
        // OAuth flow initiated successfully (web redirect or mobile app)
        _setLoading(false);
        return true;
      } else {
        _setError('Apple sign-in failed. Please try again.');
        _setLoading(false);
        return false;
      }
    } on AuthException catch (e) {
      _setError(_getReadableAuthError(e.message));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Apple sign-in failed. Please try again.');
      _setLoading(false);
      return false;
    }
  }
  
  /// Sign out
  Future<void> signOut() async {
    _setLoading(true);
    _clearError();
    
    try {
      await SupabaseService.signOut();
      _currentUser = null;
      _setLoading(false);
    } catch (e) {
      _setError('Failed to sign out. Please try again.');
      _setLoading(false);
    }
  }
  
  /// Reset password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();
    
    try {
      await SupabaseService.client.auth.resetPasswordForEmail(email);
      _setLoading(false);
      return true;
    } on AuthException catch (e) {
      _setError(_getReadableAuthError(e.message));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Failed to send reset email. Please try again.');
      _setLoading(false);
      return false;
    }
  }
  
  /// Update user email
  Future<bool> updateEmail(String newEmail) async {
    if (_currentUser == null) return false;
    
    _setLoading(true);
    _clearError();
    
    try {
      await SupabaseService.client.auth.updateUser(
        UserAttributes(email: newEmail),
      );
      _setLoading(false);
      return true;
    } on AuthException catch (e) {
      _setError(_getReadableAuthError(e.message));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Failed to update email. Please try again.');
      _setLoading(false);
      return false;
    }
  }
  
  /// Update user password
  Future<bool> updatePassword(String newPassword) async {
    if (_currentUser == null) return false;
    
    _setLoading(true);
    _clearError();
    
    try {
      await SupabaseService.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      _setLoading(false);
      return true;
    } on AuthException catch (e) {
      _setError(_getReadableAuthError(e.message));
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Failed to update password. Please try again.');
      _setLoading(false);
      return false;
    }
  }
  
  /// Get user profile data
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (_currentUser == null) return null;
    
    try {
      return await SupabaseService.getUserProfile();
    } catch (e) {
      _setError('Failed to load user profile.');
      return null;
    }
  }
  
  /// Update user profile
  Future<bool> updateUserProfile(Map<String, dynamic> updates) async {
    if (_currentUser == null) return false;
    
    _setLoading(true);
    _clearError();
    
    try {
      await SupabaseService.updateUserProfile(updates);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update profile. Please try again.');
      _setLoading(false);
      return false;
    }
  }
  
  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  /// Convert technical auth errors to user-friendly messages
  String _getReadableAuthError(String errorMessage) {
    final message = errorMessage.toLowerCase();
    
    if (message.contains('invalid login credentials')) {
      return 'Invalid email or password. Please check your credentials and try again.';
    } else if (message.contains('email not confirmed')) {
      return 'Please check your email and click the confirmation link to verify your account.';
    } else if (message.contains('email already registered')) {
      return 'An account with this email already exists. Please sign in instead.';
    } else if (message.contains('weak password')) {
      return 'Password is too weak. Please use at least 8 characters with a mix of letters and numbers.';
    } else if (message.contains('invalid email')) {
      return 'Please enter a valid email address.';
    } else if (message.contains('email not confirmed')) {
      return 'Please check your email and click the confirmation link before signing in.';
    } else if (message.contains('rate limit')) {
      return 'Too many attempts. Please wait a few minutes before trying again.';
    } else if (message.contains('network')) {
      return 'Network error. Please check your internet connection and try again.';
    } else {
      return 'Authentication failed. Please try again.';
    }
  }
}


