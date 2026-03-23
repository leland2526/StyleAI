import 'package:hive/hive.dart';
import '../models/outfit/outfit.dart';

class OutfitRepository {
  static const String _boxName = 'outfits';
  late Box<Outfit> _box;

  Future<void> init() async {
    _box = await Hive.openBox<Outfit>(_boxName);
  }

  Future<List<Outfit>> getAllOutfits(String userId) async {
    return _box.values.where((outfit) => outfit.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<List<Outfit>> getFavoriteOutfits(String userId) async {
    return _box.values
        .where((outfit) => outfit.userId == userId && outfit.isFavorite)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<Outfit?> getOutfitById(String id) async {
    return _box.values.where((outfit) => outfit.id == id).firstOrNull;
  }

  Future<void> addOutfit(Outfit outfit) async {
    await _box.put(outfit.id, outfit);
  }

  Future<void> updateOutfit(Outfit outfit) async {
    await _box.put(outfit.id, outfit);
  }

  Future<void> deleteOutfit(String id) async {
    await _box.delete(id);
  }

  Future<void> toggleFavorite(String id) async {
    final outfit = _box.get(id);
    if (outfit != null) {
      outfit.isFavorite = !outfit.isFavorite;
      outfit.updatedAt = DateTime.now();
      await outfit.save();
    }
  }

  Future<List<Outfit>> getOutfitsByOccasion(String userId, String occasion) async {
    return _box.values
        .where((outfit) => outfit.userId == userId && outfit.occasion == occasion)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<int> getTotalCount(String userId) async {
    return _box.values.where((outfit) => outfit.userId == userId).length;
  }
}
