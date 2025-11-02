import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/university_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated,
  emailNotVerified,
}

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  AuthStatus _status = AuthStatus.uninitialized;
  UserModel? _currentUser;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  AuthStatus get status => _status;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    // Listen to auth state changes
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  // Handle auth state changes
  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = AuthStatus.unauthenticated;
      _currentUser = null;
      notifyListeners();
    } else {
      // Check if email is verified
      if (!firebaseUser.emailVerified) {
        _status = AuthStatus.emailNotVerified;
        notifyListeners();
        return;
      }

      // Load user data from Firestore
      try {
        final userData = await _firestoreService.getUserById(firebaseUser.uid);
        if (userData != null) {
          _currentUser = userData;
          _status = AuthStatus.authenticated;
          
          // Update last active
          await _firestoreService.updateLastActive(firebaseUser.uid);
        } else {
          _status = AuthStatus.unauthenticated;
        }
      } catch (e) {
        _status = AuthStatus.unauthenticated;
        _errorMessage = 'Failed to load user data';
      }
      notifyListeners();
    }
  }

  // Sign up with email
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String gender,
    required University university,
    String? studentId,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Create auth account
      final userCredential = await _authService.signUpWithEmail(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      final newUser = UserModel(
        userId: userCredential.user!.uid,
        name: name,
        email: email,
        phone: phone,
        gender: gender,
        universityId: university.id,
        universityName: university.name,
        verifiedEmail: email,
        studentId: studentId,
        verified: true, // Email domain is verified
        verifiedAt: DateTime.now(),
        createdAt: DateTime.now(),
      );

      await _firestoreService.createUser(newUser);

      _status = AuthStatus.emailNotVerified;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Sign in with email
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      _status = AuthStatus.authenticating;
      notifyListeners();

      await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _status = AuthStatus.unauthenticated;
      _setLoading(false);
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  // Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      _setLoading(true);
      _clearError();
      await _authService.sendPasswordResetEmail(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Resend verification email
  Future<bool> resendVerificationEmail() async {
    try {
      _setLoading(true);
      _clearError();
      await _authService.resendVerificationEmail();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Check email verification
  Future<bool> checkEmailVerification() async {
    try {
      final isVerified = await _authService.isEmailVerified();
      if (isVerified) {
        // Reload user data
        final user = _authService.currentUser;
        if (user != null) {
          final userData = await _firestoreService.getUserById(user.uid);
          if (userData != null) {
            _currentUser = userData;
            _status = AuthStatus.authenticated;
            notifyListeners();
          }
        }
      }
      return isVerified;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile(Map<String, dynamic> updates) async {
    try {
      _setLoading(true);
      _clearError();

      if (_currentUser != null) {
        await _firestoreService.updateUser(_currentUser!.userId, updates);
        
        // Reload user data
        final updatedUser = await _firestoreService.getUserById(_currentUser!.userId);
        if (updatedUser != null) {
          _currentUser = updatedUser;
        }
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Reload current user
  Future<void> reloadUser() async {
    if (_currentUser != null) {
      try {
        final userData = await _firestoreService.getUserById(_currentUser!.userId);
        if (userData != null) {
          _currentUser = userData;
          notifyListeners();
        }
      } catch (e) {
        _setError('Failed to reload user data');
      }
    }
  }

  // Helper methods
  void _setLoading(bool value) {
    _isLoading = value;
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

  void clearError() {
    _clearError();
  }
}
