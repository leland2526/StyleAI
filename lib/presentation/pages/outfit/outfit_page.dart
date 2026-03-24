import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/outfit/outfit.dart';
import '../../bloc/outfit/outfit_cubit.dart';
import '../../widgets/common/app_widgets.dart';

class OutfitPage extends StatefulWidget {
  const OutfitPage({super.key});

  @override
  State<OutfitPage> createState() => _OutfitPageState();
}

class _OutfitPageState extends State<OutfitPage> {
  @override
  void initState() {
    super.initState();
    context.read<OutfitCubit>().loadOutfits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('穿搭'),
      ),
      body: BlocBuilder<OutfitCubit, OutfitState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 天气卡片
                if (state is OutfitsLoaded && state.weather != null)
                  WeatherCard(
                    location: state.weather!.location,
                    temperature: state.weather!.temperatureDisplay,
                    condition: state.weather!.condition,
                    emoji: state.weather!.conditionDisplay,
                  )
                else
                  const WeatherCard(
                    location: '北京',
                    temperature: '22°C',
                    condition: '晴',
                    emoji: '☀️',
                  ),

                const SizedBox(height: 24),

                // 开始搭配按钮
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/outfit/recommend'),
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text(
                      '开始搭配',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // 收藏的穿搭
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '收藏的穿搭',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<OutfitCubit>().loadFavorites();
                      },
                      child: const Text('查看全部'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (state is OutfitLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  )
                else if (state is OutfitsLoaded)
                  _buildOutfitList(state.outfits)
                else
                  const EmptyState(
                    icon: Icons.favorite_border,
                    title: '还没有收藏',
                    subtitle: '快去搭配并收藏喜欢的穿搭吧',
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOutfitList(List<Outfit> outfits) {
    if (outfits.isEmpty) {
      return const EmptyState(
        icon: Icons.favorite_border,
        title: '还没有收藏的穿搭',
        subtitle: '开始搭配后可以收藏喜欢的方案',
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: outfits.length.clamp(0, 5),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final outfit = outfits[index];
        return _OutfitCard(
          outfit: outfit,
          onTap: () {},
          onFavorite: () {
            context.read<OutfitCubit>().toggleFavorite(outfit.id);
          },
        );
      },
    );
  }
}

class _OutfitCard extends StatelessWidget {
  final Outfit outfit;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const _OutfitCard({
    required this.outfit,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.checkroom,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    outfit.name ?? '穿搭方案',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    outfit.occasion,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (outfit.note != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      outfit.note!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              onPressed: onFavorite,
              icon: Icon(
                outfit.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: outfit.isFavorite ? AppColors.error : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
