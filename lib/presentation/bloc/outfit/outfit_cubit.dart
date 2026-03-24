import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/outfit/outfit.dart';
import '../../../data/repositories/outfit_repository.dart';
import '../../../data/repositories/wardrobe_repository.dart';
import '../../../services/ai_service.dart';
import '../../../services/weather_service.dart';
import '../../../data/models/weather/weather_data.dart';

// Events
abstract class OutfitEvent extends Equatable {
  const OutfitEvent();

  @override
  List<Object?> get props => [];
}

class LoadOutfits extends OutfitEvent {}

class LoadFavoriteOutfits extends OutfitEvent {}

class GenerateRecommendations extends OutfitEvent {
  final String occasion;
  final String? style;
  final List<String>? specialNeeds;

  const GenerateRecommendations({
    required this.occasion,
    this.style,
    this.specialNeeds,
  });

  @override
  List<Object?> get props => [occasion, style, specialNeeds];
}

class ToggleOutfitFavorite extends OutfitEvent {
  final String id;
  const ToggleOutfitFavorite(this.id);

  @override
  List<Object?> get props => [id];
}

class SaveOutfit extends OutfitEvent {
  final Outfit outfit;
  const SaveOutfit(this.outfit);

  @override
  List<Object?> get props => [outfit];
}

class DeleteOutfit extends OutfitEvent {
  final String id;
  const DeleteOutfit(this.id);

  @override
  List<Object?> get props => [id];
}

// States
abstract class OutfitState extends Equatable {
  const OutfitState();

  @override
  List<Object?> get props => [];
}

class OutfitInitial extends OutfitState {}

class OutfitLoading extends OutfitState {}

class OutfitsLoaded extends OutfitState {
  final List<Outfit> outfits;
  final WeatherData? weather;

  const OutfitsLoaded({
    required this.outfits,
    this.weather,
  });

  @override
  List<Object?> get props => [outfits, weather];
}

class RecommendationsLoading extends OutfitState {}

class RecommendationsLoaded extends OutfitState {
  final List<Map<String, dynamic>> recommendations;
  final String occasion;
  final WeatherData? weather;

  const RecommendationsLoaded({
    required this.recommendations,
    required this.occasion,
    this.weather,
  });

  @override
  List<Object?> get props => [recommendations, occasion, weather];
}

class OutfitError extends OutfitState {
  final String message;
  const OutfitError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class OutfitCubit extends Cubit<OutfitState> {
  final OutfitRepository _outfitRepository;
  final WardrobeRepository _wardrobeRepository;
  final AiService _aiService;
  final WeatherService _weatherService;
  static const String _userId = 'default_user';

  OutfitCubit(
    this._outfitRepository,
    this._wardrobeRepository,
    this._aiService,
    this._weatherService,
  ) : super(OutfitInitial());

  Future<void> loadOutfits() async {
    emit(OutfitLoading());
    try {
      final outfits = await _outfitRepository.getAllOutfits(_userId);
      final weather = await _weatherService.getCurrentWeather();
      emit(OutfitsLoaded(outfits: outfits, weather: weather));
    } catch (e) {
      emit(OutfitError(e.toString()));
    }
  }

  Future<void> loadFavorites() async {
    emit(OutfitLoading());
    try {
      final outfits = await _outfitRepository.getFavoriteOutfits(_userId);
      final weather = await _weatherService.getCurrentWeather();
      emit(OutfitsLoaded(outfits: outfits, weather: weather));
    } catch (e) {
      emit(OutfitError(e.toString()));
    }
  }

  Future<void> generateRecommendations({
    required String occasion,
    String? style,
    List<String>? specialNeeds,
  }) async {
    emit(RecommendationsLoading());
    try {
      final wardrobeItems = await _wardrobeRepository.getAllItems(_userId);
      final weather = await _weatherService.getCurrentWeather();

      final wardrobeJson = wardrobeItems
          .map((item) => {
                'id': item.id,
                'name': item.name,
                'category': item.category,
                'color': item.color,
                'imagePath': item.imagePath,
              })
          .toList();

      final recommendations = await _aiService.recommendOutfits(
        wardrobeItems: wardrobeJson,
        occasion: occasion,
        style: style,
        weather: weather?.toJson(),
      );

      emit(RecommendationsLoaded(
        recommendations: recommendations,
        occasion: occasion,
        weather: weather,
      ));
    } catch (e) {
      emit(OutfitError(e.toString()));
    }
  }

  Future<void> saveOutfit(Outfit outfit) async {
    try {
      await _outfitRepository.addOutfit(outfit);
      await loadOutfits();
    } catch (e) {
      emit(OutfitError(e.toString()));
    }
  }

  Future<void> toggleFavorite(String id) async {
    try {
      await _outfitRepository.toggleFavorite(id);
      await loadOutfits();
    } catch (e) {
      emit(OutfitError(e.toString()));
    }
  }

  Future<void> deleteOutfit(String id) async {
    try {
      await _outfitRepository.deleteOutfit(id);
      await loadOutfits();
    } catch (e) {
      emit(OutfitError(e.toString()));
    }
  }
}
