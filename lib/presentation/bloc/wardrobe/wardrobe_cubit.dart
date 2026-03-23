import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/wardrobe/clothing_item.dart';
import '../../../data/repositories/wardrobe_repository.dart';

// Events
abstract class WardrobeEvent extends Equatable {
  const WardrobeEvent();

  @override
  List<Object?> get props => [];
}

class LoadWardrobe extends WardrobeEvent {}

class FilterByCategory extends WardrobeEvent {
  final String category;
  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class AddClothingItem extends WardrobeEvent {
  final ClothingItem item;
  const AddClothingItem(this.item);

  @override
  List<Object?> get props => [item];
}

class UpdateClothingItem extends WardrobeEvent {
  final ClothingItem item;
  const UpdateClothingItem(this.item);

  @override
  List<Object?> get props => [item];
}

class DeleteClothingItem extends WardrobeEvent {
  final String id;
  const DeleteClothingItem(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleFavorite extends WardrobeEvent {
  final String id;
  const ToggleFavorite(this.id);

  @override
  List<Object?> get props => [id];
}

// States
abstract class WardrobeState extends Equatable {
  const WardrobeState();

  @override
  List<Object?> get props => [];
}

class WardrobeInitial extends WardrobeState {}

class WardrobeLoading extends WardrobeState {}

class WardrobeLoaded extends WardrobeState {
  final List<ClothingItem> items;
  final String selectedCategory;

  const WardrobeLoaded({
    required this.items,
    this.selectedCategory = '全部',
  });

  @override
  List<Object?> get props => [items, selectedCategory];

  WardrobeLoaded copyWith({
    List<ClothingItem>? items,
    String? selectedCategory,
  }) {
    return WardrobeLoaded(
      items: items ?? this.items,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class WardrobeError extends WardrobeState {
  final String message;
  const WardrobeError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class WardrobeCubit extends Cubit<WardrobeState> {
  final WardrobeRepository _repository;
  String _currentCategory = '全部';
  static const String _userId = 'default_user';

  WardrobeCubit(this._repository) : super(WardrobeInitial());

  Future<void> loadItems() async {
    emit(WardrobeLoading());
    try {
      final items = await _repository.getItemsByCategory(_userId, _currentCategory);
      emit(WardrobeLoaded(items: items, selectedCategory: _currentCategory));
    } catch (e) {
      emit(WardrobeError(e.toString()));
    }
  }

  Future<void> filterByCategory(String category) async {
    _currentCategory = category;
    emit(WardrobeLoading());
    try {
      final items = await _repository.getItemsByCategory(_userId, category);
      emit(WardrobeLoaded(items: items, selectedCategory: category));
    } catch (e) {
      emit(WardrobeError(e.toString()));
    }
  }

  Future<void> addItem(ClothingItem item) async {
    try {
      await _repository.addItem(item);
      await loadItems();
    } catch (e) {
      emit(WardrobeError(e.toString()));
    }
  }

  Future<void> updateItem(ClothingItem item) async {
    try {
      await _repository.updateItem(item);
      await loadItems();
    } catch (e) {
      emit(WardrobeError(e.toString()));
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await _repository.deleteItem(id);
      await loadItems();
    } catch (e) {
      emit(WardrobeError(e.toString()));
    }
  }

  Future<void> toggleFavorite(String id) async {
    try {
      await _repository.toggleFavorite(id);
      await loadItems();
    } catch (e) {
      emit(WardrobeError(e.toString()));
    }
  }
}
