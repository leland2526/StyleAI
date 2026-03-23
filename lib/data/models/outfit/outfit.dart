import 'package:hive/hive.dart';

part 'outfit.g.dart';

@HiveType(typeId: 1)
class Outfit extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  String? name;

  @HiveField(3)
  List<String> itemIds;

  @HiveField(4)
  String occasion;

  @HiveField(5)
  String? style;

  @HiveField(6)
  String? season;

  @HiveField(7)
  String? weatherCondition;

  @HiveField(8)
  int? weatherTempMin;

  @HiveField(9)
  int? weatherTempMax;

  @HiveField(10)
  String? note;

  @HiveField(11)
  bool isFavorite;

  @HiveField(12)
  bool aiGenerated;

  @HiveField(13)
  String? aiReasoning;

  @HiveField(14)
  DateTime createdAt;

  @HiveField(15)
  DateTime updatedAt;

  Outfit({
    required this.id,
    required this.userId,
    this.name,
    required this.itemIds,
    required this.occasion,
    this.style,
    this.season,
    this.weatherCondition,
    this.weatherTempMin,
    this.weatherTempMax,
    this.note,
    this.isFavorite = false,
    this.aiGenerated = false,
    this.aiReasoning,
    required this.createdAt,
    required this.updatedAt,
  });

  Outfit copyWith({
    String? id,
    String? userId,
    String? name,
    List<String>? itemIds,
    String? occasion,
    String? style,
    String? season,
    String? weatherCondition,
    int? weatherTempMin,
    int? weatherTempMax,
    String? note,
    bool? isFavorite,
    bool? aiGenerated,
    String? aiReasoning,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Outfit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      itemIds: itemIds ?? this.itemIds,
      occasion: occasion ?? this.occasion,
      style: style ?? this.style,
      season: season ?? this.season,
      weatherCondition: weatherCondition ?? this.weatherCondition,
      weatherTempMin: weatherTempMin ?? this.weatherTempMin,
      weatherTempMax: weatherTempMax ?? this.weatherTempMax,
      note: note ?? this.note,
      isFavorite: isFavorite ?? this.isFavorite,
      aiGenerated: aiGenerated ?? this.aiGenerated,
      aiReasoning: aiReasoning ?? this.aiReasoning,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'itemIds': itemIds,
      'occasion': occasion,
      'style': style,
      'season': season,
      'weatherCondition': weatherCondition,
      'weatherTempMin': weatherTempMin,
      'weatherTempMax': weatherTempMax,
      'note': note,
      'isFavorite': isFavorite,
      'aiGenerated': aiGenerated,
      'aiReasoning': aiReasoning,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Outfit.fromJson(Map<String, dynamic> json) {
    return Outfit(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String?,
      itemIds: List<String>.from(json['itemIds'] as List),
      occasion: json['occasion'] as String,
      style: json['style'] as String?,
      season: json['season'] as String?,
      weatherCondition: json['weatherCondition'] as String?,
      weatherTempMin: json['weatherTempMin'] as int?,
      weatherTempMax: json['weatherTempMax'] as int?,
      note: json['note'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      aiGenerated: json['aiGenerated'] as bool? ?? false,
      aiReasoning: json['aiReasoning'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
