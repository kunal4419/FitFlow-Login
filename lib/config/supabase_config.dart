/// Supabase configuration using --dart-define for secure credential management
/// 
/// Usage:
/// flutter run --dart-define=SUPABASE_URL=https://xxxxx.supabase.co --dart-define=SUPABASE_ANON_KEY=xxxxx
class SupabaseConfig {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  /// Validate that configuration is properly set
  static bool isConfigured() {
    return supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  }

  /// Get configuration error message if not properly configured
  static String? getConfigError() {
    if (supabaseUrl.isEmpty) {
      return 'SUPABASE_URL is not configured. Please run with --dart-define=SUPABASE_URL=your_url';
    }
    if (supabaseAnonKey.isEmpty) {
      return 'SUPABASE_ANON_KEY is not configured. Please run with --dart-define=SUPABASE_ANON_KEY=your_key';
    }
    return null;
  }
}
