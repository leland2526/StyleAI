import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

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

  /// Get Supabase instance
  static SupabaseClient get instance => Supabase.instance.client;

  /// Sign in with phone OTP
  Future<void> signInWithPhone(String phone) async {
    await Supabase.instance.client.auth.signInWithOtp(
      phone: phone,
    );
  }

  /// Verify OTP
  Future<AuthResponse> verifyOtp(String phone, String token) async {
    return await Supabase.instance.client.auth.verifyOTP(
      phone: phone,
      token: token,
      type: OtpType.sms,
    );
  }

  /// Sign in with Apple
  Future<AuthResponse> signInWithApple() async {
    return await Supabase.instance.client.auth.signInWithIdToken(
      provider: Provider.apple,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }

  /// Get current user
  User? get currentUser => Supabase.instance.client.auth.currentUser;

  /// Listen to auth state changes
  Stream<AuthState> get onAuthStateChange =>
      Supabase.instance.client.auth.onAuthStateChange;

  /// Upload image to storage
  Future<String?> uploadImage(
    String userId,
    Uint8List bytes,
    String fileName,
  ) async {
    try {
      final path = '$userId/$fileName';

      await Supabase.instance.client.storage
          .from('clothing-images')
          .uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
            ),
          );

      // Get public URL
      final url = Supabase.instance.client.storage
          .from('clothing-images')
          .getPublicUrl(path);

      return url;
    } catch (e) {
      debugPrint('Upload error: $e');
      return null;
    }
  }
}
