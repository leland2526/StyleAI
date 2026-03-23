import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'core/constants/app_theme.dart';
import 'core/di/injection.dart';
import 'presentation/bloc/wardrobe/wardrobe_cubit.dart';
import 'presentation/bloc/outfit/outfit_cubit.dart';
import 'presentation/bloc/user/user_cubit.dart';
import 'presentation/pages/splash/splash_page.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/wardrobe/add_clothing_page.dart';
import 'presentation/pages/outfit/recommend_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 设置状态栏样式
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // 初始化依赖
  await setupDependencies();

  runApp(const StyleAIApp());
}

class StyleAIApp extends StatelessWidget {
  const StyleAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WardrobeCubit>(
          create: (_) => getIt<WardrobeCubit>(),
        ),
        BlocProvider<OutfitCubit>(
          create: (_) => getIt<OutfitCubit>(),
        ),
        BlocProvider<UserCubit>(
          create: (_) => getIt<UserCubit>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            title: 'StyleAI',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}

// 路由配置
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/wardrobe/add',
      builder: (context, state) => const AddClothingPage(),
    ),
    GoRoute(
      path: '/outfit/recommend',
      builder: (context, state) => const RecommendPage(),
    ),
  ],
);
