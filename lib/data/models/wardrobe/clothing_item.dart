import 'package:hive/hive.dart';

part 'clothing_item.g.dart';

@HiveType(typeId: 0)
class ClothingItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  String name;

  @HiveField(3)
  String category;

  @HiveField(4)
  String? subCategory;

  @HiveField(5)
  String color;

  @HiveField(6)
  String? colorHex;

  @HiveField(7)
  String? brand;

  @HiveField(8)
  String? material;

  @HiveField(9)
  List<String> season;

  @HiveField(10)
  List<String> occasion;

  @HiveField(11)
  List<String> styleTags;

  @HiveField(12)
  String imagePath;

  @HiveField(13)
  String? thumbnailPath;

  @HiveField(14)
  bool isFavorite;

  @HiveField(15)
  double? purchasePrice;

  @HiveField(16)
  DateTime createdAt;

  @HiveField(17)
  DateTime updatedAt;

  @HiveField(18)
  String? notes;

  @HiveField(19)
  double? aiConfidence;

  ClothingItem({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    this.subCategory,
    required this.color,
    this.colorHex,
    this.brand,
    this.material,
    required this.season,
    required this.occasion,
    required this.styleTags,
    required this.imagePath,
    this.thumbnailPath,
    this.isFavorite = false,
    this.purchasePrice,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.aiConfidence,
  });

  ClothingItem copyWith({
    String? id,
    String? userId,
    String? name,
    String? category,
    String? subCategory,
    String? color,
    String? colorHex,
    String? brand,
    String? material,
    List<String>? season,
    List<String>? occasion,
    List<String>? styleTags,
    String? imagePath,
    String? thumbnailPath,
    bool? isFavorite,
    double? purchasePrice,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
    double? aiConfidence,
  }) {
    return ClothingItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      color: color ?? this.color,
      colorHex: colorHex ?? this.colorHex,
      brand: brand ?? this.brand,
      material: material ?? this.material,
      season: season ?? this.season,
      occasion: occasion ?? this.occasion,
      styleTags: styleTags ?? this.styleTags,
      imagePath: imagePath ?? this.imagePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      isFavorite: isFavorite ?? this.isFavorite,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
      aiConfidence: aiConfidence ?? this.aiConfidence,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'category': category,
      'subCategory': subCategory,
      'color': color,
      'colorHex': colorHex,
      'brand': brand,
      'material': material,
      'season': season,
      'occasion': occasion,
      'styleTags': styleTags,
      'imagePath': imagePath,
      'thumbnailPath': thumbnailPath,
      'isFavorite': isFavorite,
      'purchasePrice': purchasePrice,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'notes': notes,
      'aiConfidence': aiConfidence,
    };
  }

  factory ClothingItem.fromJson(Map<String, dynamic> json) {
    return ClothingItem(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      subCategory: json['subCategory'] as String?,
      color: json['color'] as String,
      colorHex: json['colorHex'] as String?,
      brand: json['brand'] as String?,
      material: json['material'] as String?,
      season: List<String>.from(json['season'] as List),
      occasion: List<String>.from(json['occasion'] as List),
      styleTags: List<String>.from(json['styleTags'] as List),
      imagePath: json['imagePath'] as String,
      thumbnailPath: json['thumbnailPath'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      notes: json['notes'] as String?,
      aiConfidence: (json['aiConfidence'] as num?)?.toDouble(),
    );
  }
}
