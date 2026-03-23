import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final SupabaseClient _client = Supabase.instance.client;

  SupabaseClient get client => _client;

  bool get isInitialized => _client.auth.currentSession != null;

  /// Initialize Supabase
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }

  /// Sign in with phone OTP
  Future<AuthResponse> signInWithPhone(String phone) async {
    return await _client.auth.signInWithOtp(
      phone: phone,
      options: OtpOptions(
        channel: OTPSChannel.sms,
      ),
    );
  }

  /// Verify OTP
  Future<AuthResponse> verifyOtp(String phone, String token) async {
    return await _client.auth.verifyOTP(
      phone: phone,
      token: token,
      type: OtpType.sms,
    );
  }

  /// Sign in with Apple
  Future<AuthResponse> signInWithApple() async {
    return await _client.auth.signInWithIdToken(
      provider: Provider.apple,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Get current user
  User? get currentUser => _client.auth.currentUser;

  /// Listen to auth state changes
  Stream<AuthState> get onAuthStateChange => _client.auth.onAuthStateChange;

  /// Upload image to storage
  Future<String?> uploadImage(
    String userId,
    String filePath,
    String fileName,
  ) async {
    try {
      final bytes = await _readFileBytes(filePath);
      final path = '$userId/$fileName';

      final response = await _client.storage.from('clothing-images').uploadBinary(
        path,
        bytes,
        fileOptions: const FileOptions(
          contentType: 'image/jpeg',
          upsert: true,
        ),
      );

      // Get public URL
      final url = _client.storage.from('clothing-images').getPublicUrl(response);

      return url;
    } catch (e) {
      debugPrint('Upload error: $e');
      return null;
    }
  }

  Future<List<int>> _readFileBytes(String path) async {
    // This is a placeholder - implement based on your file reading method
    return await Future.value(<int>[]);
  }
}
