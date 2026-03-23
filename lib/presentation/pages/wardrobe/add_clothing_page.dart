import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/wardrobe/clothing_item.dart';
import '../../../services/ai_service.dart';
import '../../bloc/wardrobe/wardrobe_cubit.dart';
import '../../widgets/common/app_widgets.dart';
import '../../widgets/common/category_chips.dart';
import 'package:get_it/get_it.dart';

class AddClothingPage extends StatefulWidget {
  const AddClothingPage({super.key});

  @override
  State<AddClothingPage> createState() => _AddClothingPageState();
}

class _AddClothingPageState extends State<AddClothingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imagePicker = ImagePicker();

  String? _imagePath;
  String _selectedCategory = '上衣';
  String _selectedColor = '黑色';
  String? _selectedSubCategory;
  List<String> _selectedSeasons = ['春'];
  List<String> _selectedOccasions = ['日常'];
  bool _isAnalyzing = false;

  final List<String> _colors = [
    '黑色', '白色', '灰色', '米色', '蓝色', '粉色', '绿色', '棕色', '红色', '黄色', '紫色', '橙色'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imagePath = image.path;
          _isAnalyzing = true;
        });
        await _analyzeImage(image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('选择图片失败: $e')),
        );
      }
    }
  }

  Future<void> _analyzeImage(String path) async {
    try {
      final aiService = GetIt.instance<AiService>();
      final result = await aiService.recognizeClothing(path);

      if (mounted) {
        setState(() {
          _selectedCategory = result.category;
          _selectedSubCategory = result.subCategory;
          _selectedColor = result.color;
          _nameController.text = '${result.color}${result.subCategory ?? result.category}';
          _selectedSeasons = result.season.isNotEmpty ? result.season : ['春'];
          _selectedOccasions = result.occasion.isNotEmpty ? result.occasion : ['日常'];
          _isAnalyzing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  void _saveItem() {
    if (_formKey.currentState!.validate() && _imagePath != null) {
      final item = ClothingItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'default_user',
        name: _nameController.text,
        category: _selectedCategory,
        subCategory: _selectedSubCategory,
        color: _selectedColor,
        colorHex: _getColorHex(_selectedColor),
        season: _selectedSeasons,
        occasion: _selectedOccasions,
        styleTags: [],
        imagePath: _imagePath!,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      context.read<WardrobeCubit>().addItem(item);
      Navigator.of(context).pop();
    } else if (_imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先添加图片')),
      );
    }
  }

  String? _getColorHex(String colorName) {
    final colors = {
      '黑色': '#1A1A1A',
      '白色': '#FFFFFF',
      '灰色': '#808080',
      '米色': '#F5F5DC',
      '蓝色': '#4169E1',
      '粉色': '#FFB6C1',
      '绿色': '#228B22',
      '棕色': '#8B4513',
      '红色': '#DC143C',
      '黄色': '#FFD700',
      '紫色': '#8B008B',
      '橙色': '#FFA500',
    };
    return colors[colorName];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('添加衣物'),
        actions: [
          TextButton(
            onPressed: _saveItem,
            child: const Text('保存'),
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: _isAnalyzing,
        message: 'AI分析中...',
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 图片选择
                GestureDetector(
                  onTap: () => _showImageSourceDialog(),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.textHint.withOpacity(0.3),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: _imagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.file(
                              File(_imagePath!),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.add_a_photo_outlined,
                                size: 48,
                                color: AppColors.textHint,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '点击添加图片',
                                style: TextStyle(
                                  color: AppColors.textHint,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // 名称
                const Text(
                  '名称',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: '输入衣物名称',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入名称';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // 分类
                const Text(
                  '分类',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AppStrings.categories
                      .where((c) => c != '全部')
                      .map((category) {
                    final isSelected = category == _selectedCategory;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = category),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.card,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // 颜色
                const Text(
                  '颜色',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                MultiSelectChips(
                  options: _colors,
                  selected: [_selectedColor],
                  onChanged: (selected) {
                    if (selected.isNotEmpty) {
                      setState(() => _selectedColor = selected.first);
                    }
                  },
                ),
                const SizedBox(height: 20),

                // 季节
                const Text(
                  '适合季节',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                MultiSelectChips(
                  options: AppStrings.seasons,
                  selected: _selectedSeasons,
                  onChanged: (selected) {
                    setState(() => _selectedSeasons = selected);
                  },
                ),
                const SizedBox(height: 20),

                // 场合
                const Text(
                  '适合场合',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                MultiSelectChips(
                  options: AppStrings.occasions,
                  selected: _selectedOccasions,
                  onChanged: (selected) {
                    setState(() => _selectedOccasions = selected);
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                  title: const Text('拍照'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: AppColors.secondary),
                  title: const Text('从相册选择'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
