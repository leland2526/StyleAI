import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AiRecognitionResult {
  final String category;
  final String? subCategory;
  final String color;
  final String? colorHex;
  final String? brand;
  final String? material;
  final List<String> styleTags;
  final List<String> season;
  final List<String> occasion;
  final double confidence;

  AiRecognitionResult({
    required this.category,
    this.subCategory,
    required this.color,
    this.colorHex,
    this.brand,
    this.material,
    required this.styleTags,
    required this.season,
    required this.occasion,
    required this.confidence,
  });

  factory AiRecognitionResult.fromJson(Map<String, dynamic> json) {
    return AiRecognitionResult(
      category: json['category'] as String,
      subCategory: json['subCategory'] as String?,
      color: json['color'] as String,
      colorHex: json['colorHex'] as String?,
      brand: json['brand'] as String?,
      material: json['material'] as String?,
      styleTags: List<String>.from(json['styleTags'] as List? ?? []),
      season: List<String>.from(json['season'] as List? ?? []),
      occasion: List<String>.from(json['occasion'] as List? ?? []),
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.8,
    );
  }
}

class AiService {
  final Dio _dio;
  final String? _openAiKey;

  AiService({Dio? dio, String? openAiKey})
      : _dio = dio ?? Dio(),
        _openAiKey = openAiKey ?? const String.fromEnvironment('OPENAI_API_KEY');

  /// 使用本地模拟的AI识别（演示用）
  /// 实际项目中替换为真实的API调用
  Future<AiRecognitionResult> recognizeClothing(String imagePath) async {
    // 模拟API延迟
    await Future.delayed(const Duration(seconds: 1));

    // 演示用：基于图像名的简单模拟
    // 实际项目中应调用真实AI API
    return _simulateRecognition(imagePath);
  }

  AiRecognitionResult _simulateRecognition(String imagePath) {
    // 随机选择一个分类
    final categories = ['上衣', '裤子', '裙子', '外套', '配饰', '鞋', '包'];
    final colors = [
      {'name': '黑色', 'hex': '#1A1A1A'},
      {'name': '白色', 'hex': '#FFFFFF'},
      {'name': '灰色', 'hex': '#808080'},
      {'name': '米色', 'hex': '#F5F5DC'},
      {'name': '蓝色', 'hex': '#4169E1'},
      {'name': '粉色', 'hex': '#FFB6C1'},
      {'name': '绿色', 'hex': '#228B22'},
      {'name': '棕色', 'hex': '#8B4513'},
    ];

    final styles = ['简约', '休闲', '通勤', '运动', '甜美'];
    final seasons = ['春', '夏', '秋', '冬'];
    final occasions = ['通勤', '约会', '休闲', '运动', '聚会'];

    final category = categories[(imagePath.hashCode.abs()) % categories.length];
    final color = colors[(imagePath.hashCode.abs() + 1) % colors.length];

    return AiRecognitionResult(
      category: category,
      subCategory: _getSubCategory(category),
      color: color['name']!,
      colorHex: color['hex'],
      styleTags: [styles[(imagePath.hashCode.abs() + 2) % styles.length]],
      season: [
        seasons[(imagePath.hashCode.abs()) % seasons.length],
      ],
      occasion: [
        occasions[(imagePath.hashCode.abs()) % occasions.length],
      ],
      confidence: 0.85 + (imagePath.hashCode.abs() % 15) / 100,
    );
  }

  String _getSubCategory(String category) {
    switch (category) {
      case '上衣':
        return ['T恤', '衬衫', '毛衣', '卫衣', '针织衫'][
            category.hashCode.abs() % 5];
      case '裤子':
        return ['牛仔裤', '休闲裤', '短裤', '阔腿裤'][
            category.hashCode.abs() % 4];
      case '裙子':
        return ['连衣裙', '半身裙', '短裙'][category.hashCode.abs() % 3];
      case '外套':
        return ['夹克', '大衣', '风衣', '羽绒服'][
            category.hashCode.abs() % 4];
      case '鞋':
        return ['运动鞋', '帆布鞋', '高跟鞋', '靴子'][
            category.hashCode.abs() % 4];
      case '包':
        return ['单肩包', '双肩包', '手提包', '钱包'][
            category.hashCode.abs() % 4];
      default:
        return '配件';
    }
  }

  /// 使用OpenAI进行真实识别（需要配置API Key）
  Future<AiRecognitionResult?> recognizeWithOpenAI(String imageBase64) async {
    if (_openAiKey == null || _openAiKey!.isEmpty) {
      debugPrint('OpenAI API key not configured, using simulation');
      return null;
    }

    try {
      final response = await _dio.post(
        'https://api.openai.com/v1/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_openAiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text': '''分析这张衣物图片，以JSON格式返回识别结果：
{
  "category": "上衣/裤子/裙子/外套/配饰/鞋/包/首饰/口红",
  "subCategory": "具体类型",
  "color": "主要颜色中文",
  "colorHex": "#RRGGBB",
  "styleTags": ["风格标签"],
  "season": ["适用季节"],
  "occasion": ["适用场合"],
  "confidence": 0.0-1.0
}'''
                },
                {
                  'type': 'image_url',
                  'image_url': {'url': 'data:image/jpeg;base64,$imageBase64'}
                }
              ]
            }
          ],
          'max_tokens': 500,
        },
      );

      final content = response.data['choices'][0]['message']['content']
          as String;
      final jsonStart = content.indexOf('{');
      final jsonEnd = content.lastIndexOf('}');
      if (jsonStart != -1 && jsonEnd != -1) {
        final jsonStr = content.substring(jsonStart, jsonEnd + 1);
        return AiRecognitionResult.fromJson(jsonDecode(jsonStr));
      }
    } catch (e) {
      debugPrint('OpenAI recognition error: $e');
    }
    return null;
  }

  /// AI穿搭推荐
  Future<List<Map<String, dynamic>>> recommendOutfits({
    required List<Map<String, dynamic>> wardrobeItems,
    required String occasion,
    String? style,
    Map<String, dynamic>? weather,
  }) async {
    // 模拟AI推荐延迟
    await Future.delayed(const Duration(seconds: 1));

    // 简单规则推荐
    final recommendations = <Map<String, dynamic>>[];

    // 按分类筛选衣物
    final tops = wardrobeItems.where((i) => i['category'] == '上衣').toList();
    final bottoms =
        wardrobeItems.where((i) => ['裤子', '裙子'].contains(i['category'])).toList();
    final outer =
        wardrobeItems.where((i) => i['category'] == '外套').toList();
    final shoes = wardrobeItems.where((i) => i['category'] == '鞋').toList();

    // 生成3个推荐方案
    for (int i = 0; i < 3; i++) {
      if (tops.isEmpty) continue;

      final top = tops[i % tops.length];
      final bottom = bottoms.isNotEmpty ? bottoms[i % bottoms.length] : null;
      final coat = outer.isNotEmpty ? outer[i % outer.length] : null;
      final shoe = shoes.isNotEmpty ? shoes[i % shoes.length] : null;

      final items = [top];
      if (bottom != null) items.add(bottom);
      if (coat != null) items.add(coat);
      if (shoe != null) items.add(shoe);

      recommendations.add({
        'name': '${style ?? occasion}穿搭方案${i + 1}',
        'items': items,
        'reasoning': _getReasoning(occasion, style),
        'occasion': occasion,
        'style': style,
      });
    }

    return recommendations;
  }

  String _getReasoning(String occasion, String? style) {
    final styleStr = style ?? occasion;
    switch (styleStr) {
      case '通勤':
        return '简约干练，适合职场穿搭，显专业气质';
      case '约会':
        return '温柔优雅，突显个人魅力';
      case '休闲':
        return '轻松自在，日常出街必备';
      case '运动':
        return '活力满满，舒适又时尚';
      default:
        return '得体大方，适合多种场合';
    }
  }
}
