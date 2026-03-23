import 'package:hive/hive.dart';
import '../models/user/user_profile.dart';

class UserRepository {
  static const String _boxName = 'user_profile';
  late Box<UserProfile> _box;

  Future<void> init() async {
    _box = await Hive.openBox<UserProfile>(_boxName);
  }

  Future<UserProfile> getCurrentUser() async {
    final users = _box.values.toList();
    if (users.isEmpty) {
      final defaultUser = UserProfile.createDefault('default_user');
      await _box.put(defaultUser.id, defaultUser);
      return defaultUser;
    }
    return users.first;
  }

  Future<void> updateUser(UserProfile user) async {
    user.updatedAt = DateTime.now();
    await _box.put(user.id, user);
  }

  Future<void> updateStyleTestResult(String userId, String result) async {
    final user = _box.get(userId);
    if (user != null) {
      user.styleTestResult = result;
      user.updatedAt = DateTime.now();
      await user.save();
    }
  }

  Future<void> updateBodyData(
    String userId, {
    int? heightCm,
    int? weightKg,
    String? bodyShape,
  }) async {
    final user = _box.get(userId);
    if (user != null) {
      if (heightCm != null) user.heightCm = heightCm;
      if (weightKg != null) user.weightKg = weightKg;
      if (bodyShape != null) user.bodyShape = bodyShape;
      user.updatedAt = DateTime.now();
      await user.save();
    }
  }

  Future<void> updatePreferences(
    String userId, {
    List<String>? stylePreferences,
    List<String>? colorPreferences,
    List<String>? avoidColors,
  }) async {
    final user = _box.get(userId);
    if (user != null) {
      if (stylePreferences != null) user.stylePreferences = stylePreferences;
      if (colorPreferences != null) user.colorPreferences = colorPreferences;
      if (avoidColors != null) user.avoidColors = avoidColors;
      user.updatedAt = DateTime.now();
      await user.save();
    }
  }
}
