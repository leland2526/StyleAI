import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/wardrobe/clothing_item.dart';
import '../../data/models/outfit/outfit.dart';
import '../../data/models/user/user_profile.dart';
import '../../data/repositories/wardrobe_repository.dart';
import '../../data/repositories/outfit_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../services/ai_service.dart';
import '../../services/weather_service.dart';
import '../../presentation/bloc/wardrobe/wardrobe_cubit.dart';
import '../../presentation/bloc/outfit/outfit_cubit.dart';
import '../../presentation/bloc/user/user_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // 初始化 Hive
  await Hive.initFlutter();

  // 注册 Hive Adapters
  Hive.registerAdapter(ClothingItemAdapter());
  Hive.registerAdapter(OutfitAdapter());
  Hive.registerAdapter(UserProfileAdapter());

  // 初始化 Repository
  final wardrobeRepository = WardrobeRepository();
  await wardrobeRepository.init();
  getIt.registerSingleton<WardrobeRepository>(wardrobeRepository);

  final outfitRepository = OutfitRepository();
  await outfitRepository.init();
  getIt.registerSingleton<OutfitRepository>(outfitRepository);

  final userRepository = UserRepository();
  await userRepository.init();
  getIt.registerSingleton<UserRepository>(userRepository);

  // 初始化 Services
  getIt.registerSingleton<AiService>(AiService());
  getIt.registerSingleton<WeatherService>(WeatherService());

  // 注册 Cubits
  getIt.registerFactory<WardrobeCubit>(
    () => WardrobeCubit(getIt<WardrobeRepository>()),
  );

  getIt.registerFactory<OutfitCubit>(
    () => OutfitCubit(
      getIt<OutfitRepository>(),
      getIt<WardrobeRepository>(),
      getIt<AiService>(),
      getIt<WeatherService>(),
    ),
  );

  getIt.registerFactory<UserCubit>(
    () => UserCubit(getIt<UserRepository>()),
  );
}
