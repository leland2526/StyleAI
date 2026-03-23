import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../bloc/wardrobe/wardrobe_cubit.dart';
import '../../widgets/common/clothing_card.dart';
import '../../widgets/common/app_widgets.dart';
import '../../widgets/common/category_chips.dart';
import 'package:go_router/go_router.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({super.key});

  @override
  State<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  @override
  void initState() {
    super.initState();
    context.read<WardrobeCubit>().loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('衣橱'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          BlocBuilder<WardrobeCubit, WardrobeState>(
            builder: (context, state) {
              final selectedCategory = state is WardrobeLoaded
                  ? state.selectedCategory
                  : '全部';
              return CategoryChips(
                categories: AppStrings.categories,
                selectedCategory: selectedCategory,
                onSelected: (category) {
                  context.read<WardrobeCubit>().filterByCategory(category);
                },
              );
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<WardrobeCubit, WardrobeState>(
              builder: (context, state) {
                if (state is WardrobeLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (state is WardrobeError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  );
                }

                if (state is WardrobeLoaded) {
                  if (state.items.isEmpty) {
                    return EmptyState(
                      icon: Icons.checkroom_outlined,
                      title: '还没有衣物',
                      subtitle: '添加你的第一件衣服吧',
                      buttonText: '添加衣物',
                      onButtonPressed: () => context.push('/wardrobe/add'),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return ClothingCard(
                        imagePath: item.imagePath,
                        name: item.name,
                        subtitle: item.color,
                        isFavorite: item.isFavorite,
                        onTap: () => context.push('/wardrobe/detail/${item.id}'),
                        onLongPress: () {
                          context.read<WardrobeCubit>().toggleFavorite(item.id);
                        },
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/wardrobe/add'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
