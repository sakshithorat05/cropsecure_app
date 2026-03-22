import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/services/mongodb_service.dart';
import 'core/services/cloudinary_service.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() {
  getIt.registerLazySingleton<MongoDBService>(() => MongoDBService());
  getIt.registerLazySingleton<CloudinaryService>(() => CloudinaryService());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize MongoDB
  final mongoService = MongoDBService();
  await mongoService.connect();

  // Initialize Cloudinary
  final cloudinaryService = CloudinaryService();
  cloudinaryService.initialize();

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
