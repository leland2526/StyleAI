import 'package:hive/hive.dart';
import '../models/wardrobe/clothing_item.dart';

class WardrobeRepository {
  static const String _boxName = 'clothing_items';
  late Box<ClothingItem> _box;

  Future<void> init() async {
    _box = await Hive.openBox<ClothingItem>(_boxName);
  }

  Future<List<ClothingItem>> getAllItems(String userId) async {
    return _box.values.where((item) => item.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<List<ClothingItem>> getItemsByCategory(
      String userId, String category) async {
    if (category == '全部') {
      return getAllItems(userId);
    }
    return _box.values
        .where((item) => item.userId == userId && item.category == category)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<ClothingItem?> getItemById(String id) async {
    return _box.values.where((item) => item.id == id).firstOrNull;
  }

  Future<void> addItem(ClothingItem item) async {
    await _box.put(item.id, item);
  }

  Future<void> updateItem(ClothingItem item) async {
    await _box.put(item.id, item);
  }

  Future<void> deleteItem(String id) async {
    await _box.delete(id);
  }

  Future<void> toggleFavorite(String id) async {
    final item = _box.get(id);
    if (item != null) {
      item.isFavorite = !item.isFavorite;
      item.updatedAt = DateTime.now();
      await item.save();
    }
  }

  Future<List<ClothingItem>> searchItems(String userId, String query) async {
    final lowerQuery = query.toLowerCase();
    return _box.values
        .where((item) =>
            item.userId == userId &&
            (item.name.toLowerCase().contains(lowerQuery) ||
                item.color.toLowerCase().contains(lowerQuery) ||
                (item.brand?.toLowerCase().contains(lowerQuery) ?? false)))
        .toList();
  }

  Future<Map<String, int>> getCategoryStats(String userId) async {
    final items = await getAllItems(userId);
    final stats = <String, int>{};
    for (final item in items) {
      stats[item.category] = (stats[item.category] ?? 0) + 1;
    }
    return stats;
  }

  Future<int> getTotalCount(String userId) async {
    return _box.values.where((item) => item.userId == userId).length;
  }
}
