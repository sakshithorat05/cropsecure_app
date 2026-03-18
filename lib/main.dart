import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() {
  // getIt.registerLazySingleton<ApiService>(() => ApiService());
  // getIt.registerLazySingleton<StorageService>(() => StorageService());
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencyInjection();

  runApp(
    const ProviderScope(
      child: CropSecureApp(),
    ),
  );
}

class CropSecureApp extends ConsumerWidget {
  const CropSecureApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'CropSecure',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}
