import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 2)
class UserProfile extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String nickname;

  @HiveField(2)
  String? avatarPath;

  @HiveField(3)
  String? gender;

  @HiveField(4)
  DateTime? birthday;

  @HiveField(5)
  int? heightCm;

  @HiveField(6)
  int? weightKg;

  @HiveField(7)
  String? bodyShape;

  @HiveField(8)
  List<String> stylePreferences;

  @HiveField(9)
  List<String> colorPreferences;

  @HiveField(10)
  List<String> avoidColors;

  @HiveField(11)
  String? styleTestResult;

  @HiveField(12)
  DateTime createdAt;

  @HiveField(13)
  DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.nickname,
    this.avatarPath,
    this.gender,
    this.birthday,
    this.heightCm,
    this.weightKg,
    this.bodyShape,
    required this.stylePreferences,
    required this.colorPreferences,
    required this.avoidColors,
    this.styleTestResult,
    required this.createdAt,
    required this.updatedAt,
  });

  UserProfile copyWith({
    String? id,
    String? nickname,
    String? avatarPath,
    String? gender,
    DateTime? birthday,
    int? heightCm,
    int? weightKg,
    String? bodyShape,
    List<String>? stylePreferences,
    List<String>? colorPreferences,
    List<String>? avoidColors,
    String? styleTestResult,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      avatarPath: avatarPath ?? this.avatarPath,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      bodyShape: bodyShape ?? this.bodyShape,
      stylePreferences: stylePreferences ?? this.stylePreferences,
      colorPreferences: colorPreferences ?? this.colorPreferences,
      avoidColors: avoidColors ?? this.avoidColors,
      styleTestResult: styleTestResult ?? this.styleTestResult,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'avatarPath': avatarPath,
      'gender': gender,
      'birthday': birthday?.toIso8601String(),
      'heightCm': heightCm,
      'weightKg': weightKg,
      'bodyShape': bodyShape,
      'stylePreferences': stylePreferences,
      'colorPreferences': colorPreferences,
      'avoidColors': avoidColors,
      'styleTestResult': styleTestResult,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      avatarPath: json['avatarPath'] as String?,
      gender: json['gender'] as String?,
      birthday: json['birthday'] != null
          ? DateTime.parse(json['birthday'] as String)
          : null,
      heightCm: json['heightCm'] as int?,
      weightKg: json['weightKg'] as int?,
      bodyShape: json['bodyShape'] as String?,
      stylePreferences: List<String>.from(json['stylePreferences'] as List),
      colorPreferences: List<String>.from(json['colorPreferences'] as List),
      avoidColors: List<String>.from(json['avoidColors'] as List),
      styleTestResult: json['styleTestResult'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  factory UserProfile.createDefault(String id) {
    final now = DateTime.now();
    return UserProfile(
      id: id,
      nickname: '用户',
      stylePreferences: [],
      colorPreferences: [],
      avoidColors: [],
      createdAt: now,
      updatedAt: now,
    );
  }
}
