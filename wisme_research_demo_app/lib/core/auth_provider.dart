import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;
  bool get isSignedIn => _user != null;

  Future<void> signInAnonymously() async {
    _user = await FirebaseService.signInAnonymously();
    notifyListeners();
  }

  void signOut() async {
    await FirebaseService.auth.signOut();
    _user = null;
    notifyListeners();
  }
} 