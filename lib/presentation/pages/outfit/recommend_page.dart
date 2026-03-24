import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/outfit/outfit.dart';
import '../../bloc/outfit/outfit_cubit.dart';
import '../../widgets/common/app_widgets.dart';
import '../../widgets/common/category_chips.dart';

class RecommendPage extends StatefulWidget {
  const RecommendPage({super.key});

  @override
  State<RecommendPage> createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
  String _selectedOccasion = '通勤';
  String? _selectedStyle;
  List<String> _selectedNeeds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('开始搭配'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<OutfitCubit, OutfitState>(
        builder: (context, state) {
          if (state is RecommendationsLoading) {
            return LoadingOverlay(
              isLoading: true,
              message: 'AI搭配中...',
              child: const SizedBox(),
            );
          }

          if (state is RecommendationsLoaded) {
            return _buildResults(state);
          }

          return _buildSelection();
        },
      ),
    );
  }

  Widget _buildSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 场景选择
          const Text(
            '今天是什么场合？',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: AppStrings.occasions.map((occasion) {
              final isSelected = occasion == _selectedOccasion;
              return GestureDetector(
                onTap: () => setState(() => _selectedOccasion = occasion),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.card,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textHint.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    occasion,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // 风格选择
          const Text(
            '想要什么风格？（可选）',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: AppStrings.styles.map((style) {
              final isSelected = style == _selectedStyle;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedStyle = isSelected ? null : style;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.secondary : AppColors.card,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.secondary
                          : AppColors.textHint.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    style,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // 特殊需求
          const Text(
            '有什么特殊需求？（可选）',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          MultiSelectChips(
            options: const ['显瘦', '显高', '舒服', '遮瑕', '保暖', '清爽'],
            selected: _selectedNeeds,
            onChanged: (selected) {
              setState(() => _selectedNeeds = selected);
            },
          ),

          const SizedBox(height: 48),

          // 开始推荐按钮
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _startRecommend,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    '开始AI搭配',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(RecommendationsLoaded state) {
    return Column(
      children: [
        // 天气信息
        if (state.weather != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: WeatherCard(
              location: state.weather!.location,
              temperature: state.weather!.temperatureDisplay,
              condition: state.weather!.condition,
              emoji: state.weather!.conditionDisplay,
            ),
          ),

        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.recommendations.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final recommendation = state.recommendations[index];
              return _RecommendationCard(
                recommendation: recommendation,
                onSave: () => _saveRecommendation(recommendation),
                onRetry: _startRecommend,
              );
            },
          ),
        ),
      ],
    );
  }

  void _startRecommend() {
    context.read<OutfitCubit>().generateRecommendations(
          occasion: _selectedOccasion,
          style: _selectedStyle,
          specialNeeds: _selectedNeeds.isNotEmpty ? _selectedNeeds : null,
        );
  }

  void _saveRecommendation(Map<String, dynamic> recommendation) {
    final outfit = Outfit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'default_user',
      name: recommendation['name'] as String?,
      itemIds: (recommendation['items'] as List)
          .map((item) => item['id'] as String)
          .toList(),
      occasion: recommendation['occasion'] as String? ?? _selectedOccasion,
      style: recommendation['style'] as String?,
      note: recommendation['reasoning'] as String?,
      isFavorite: true,
      aiGenerated: true,
      aiReasoning: recommendation['reasoning'] as String?,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    context.read<OutfitCubit>().saveOutfit(outfit);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('穿搭方案已收藏'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final Map<String, dynamic> recommendation;
  final VoidCallback onSave;
  final VoidCallback onRetry;

  const _RecommendationCard({
    required this.recommendation,
    required this.onSave,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final items = recommendation['items'] as List;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 方案名称
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  recommendation['name'] as String? ?? '穿搭方案',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 14, color: AppColors.secondary),
                    SizedBox(width: 4),
                    Text(
                      'AI推荐',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 衣物预览
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                return Container(
                  width: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.checkroom,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['name'] as String? ?? '',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // 推荐理由
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.warning,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    recommendation['reasoning'] as String? ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 操作按钮
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('换一套'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.textHint),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onSave,
                  icon: const Icon(Icons.favorite_border, size: 18),
                  label: const Text('收藏'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
