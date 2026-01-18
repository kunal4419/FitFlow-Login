import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/auth_repository.dart';

/// Auth controller that manages authentication state
/// Use with Provider to make auth state available throughout the app
class AuthController with ChangeNotifier {
  final AuthRepository _authRepository;
  User? _currentUser;
  Map<String, dynamic>? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  AuthController(this._authRepository) {
    _currentUser = _authRepository.currentUser;
    _listenToAuthChanges();
  }

  User? get currentUser => _currentUser;
  Map<String, dynamic>? get userProfile => _userProfile;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _listenToAuthChanges() {
    _authRepository.authStateChanges.listen((AuthState data) {
      _currentUser = data.session?.user;
      if (_currentUser != null) {
        loadUserProfile();
      } else {
        _userProfile = null;
      }
      notifyListeners();
    });
  }

  /// Load user profile from user_profiles table
  Future<void> loadUserProfile() async {
    if (_currentUser != null) {
      _userProfile = await _authRepository.getUserProfile(_currentUser!.id);
      notifyListeners();
    }
  }

  /// Sign up with email and password
  Future<bool> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _authRepository.signUp(
        email: email,
        password: password,
        name: name,
      );

      _currentUser = response.user;
      if (_currentUser != null) {
        await loadUserProfile();
      }
      _isLoading = false;
      notifyListeners();
      return response.user != null;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _authRepository.signIn(
        email: email,
        password: password,
      );

      _currentUser = response.user;
      if (_currentUser != null) {
        await loadUserProfile();
      }
      _isLoading = false;
      notifyListeners();
      return response.user != null;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authRepository.signOut();
      _currentUser = null;
      _userProfile = null;
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to sign out';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authRepository.resetPassword(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Failed to send reset email';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update user name
  Future<bool> updateUserName(String newName) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (_currentUser == null) {
        throw Exception('No user logged in');
      }

      await _authRepository.updateUserName(_currentUser!.id, newName);
      await loadUserProfile();

      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Failed to update name';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update password with current password verification
  Future<bool> updatePassword(String currentPassword, String newPassword) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (_currentUser == null) {
        throw Exception('No user logged in');
      }

      await _authRepository.updatePassword(
        _currentUser!.email!,
        currentPassword,
        newPassword,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
