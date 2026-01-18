import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabase;

  AuthRepository(this._supabase);

  /// Get current user session
  Session? get currentSession => _supabase.auth.currentSession;

  /// Get current user
  User? get currentUser => _supabase.auth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: name != null ? {'name': name} : null,
    );
  }

  /// Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  /// Stream auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// Reset password (send reset email)
  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  /// Get user profile from user_profiles table
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('user_profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return response;
    } catch (e) {
      return null;
    }
  }

  /// Update user name in both user_metadata and user_profiles table
  Future<void> updateUserName(String userId, String newName) async {
    // Update user_metadata
    await _supabase.auth.updateUser(
      UserAttributes(data: {'name': newName}),
    );
    
    // Update user_profiles table
    await _supabase
        .from('user_profiles')
        .update({'name': newName, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', userId);
  }

  /// Update user password after verifying current password
  Future<void> updatePassword(String email, String currentPassword, String newPassword) async {
    // Verify current password by attempting to sign in with a separate client call
    // We need to catch the error properly to know if password is wrong
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: currentPassword,
      );
      
      // If sign-in failed, response.user will be null
      if (response.user == null) {
        throw Exception('Current password is incorrect');
      }
    } on AuthException catch (e) {
      // Auth exception means wrong password or other auth error
      throw Exception('Current password is incorrect');
    } catch (e) {
      throw Exception('Current password is incorrect');
    }
    
    // Update to new password
    await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }
}
