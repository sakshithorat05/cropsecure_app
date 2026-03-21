import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/app_shell.dart';
import '../core/theme/app_colors.dart';

// Import Screens
import '../screens/splash/splash_screen.dart';
import '../screens/language/language_selection_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/scan/scan_screen.dart';
import '../screens/scan/scan_preview_screen.dart';
import '../screens/scan/analyzing_screen.dart';
import '../screens/scan/diagnosis_result_screen.dart';
import '../screens/treatment/treatment_advisory_screen.dart';
import '../screens/treatment/disease_details_screen.dart';
import '../screens/treatment/models/disease_details_model.dart';
import '../screens/treatment/models/treatment_advisory_model.dart';
import '../screens/treatment/chemical_treatment_screen.dart';
import '../screens/treatment/organic_treatment_screen.dart';
import '../screens/treatment/pests_and_diseases_screen.dart';
import '../screens/treatment/stage_expanded_screen.dart';
import '../screens/treatment/models/disease_details_model.dart';
import '../screens/marketplace/marketplace_screen.dart';
import '../screens/marketplace/product_detail_screen.dart';
import '../screens/marketplace/cart_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/farm_history_screen.dart';
import '../screens/profile/purchase_inputs_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

/// Provides the GoRouter instance
final routerProvider = Provider<GoRouter>((ref) {
  // final authState = ref.watch(authProvider); // Removed unused variable

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/language',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/signup',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/auth/otp',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OTPScreen(),
      ),
      
      GoRoute(
         path: '/home/scan',
         parentNavigatorKey: _rootNavigatorKey, // Full screen camera
         builder: (context, state) => const ScanScreen(),
      ),
      GoRoute(
         path: '/disease-details',
         parentNavigatorKey: _rootNavigatorKey,
         builder: (context, state) => DiseaseDetailsScreen(
           data: state.extra as DiseaseDetailsModel,
         ),
      ),

      // App Shell with Bottom Navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          // 0. Dashboard
          GoRoute(
            path: '/home',
            builder: (context, state) => const DashboardScreen(),
            routes: [
              GoRoute(
                path: 'scan/preview',
                builder: (context, state) => const ScanPreviewScreen(),
              ),
              GoRoute(
                path: 'scan/analyzing',
                builder: (context, state) => const AnalyzingScreen(),
              ),
              GoRoute(
                path: 'scan/result',
                builder: (context, state) => const DiagnosisResultScreen(),
              ),
            ],
          ),
          
          // 1. Treatment
          GoRoute(
            path: '/treatment',
            builder: (context, state) => const TreatmentAdvisoryScreen(),
            routes: [
              GoRoute(
                path: 'chemical',
                builder: (context, state) {
                  final data = state.extra as TreatmentModel?;
                  if (data == null) {
                    return const Scaffold(
                      body: Center(child: Text('Treatment data missing.')),
                    );
                  }
                  return ChemicalTreatmentScreen(data: data);
                },
              ),
              GoRoute(
                path: 'organic',
                builder: (context, state) {
                  final data = state.extra as TreatmentModel?;
                  if (data == null) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('Error'),
                        backgroundColor: AppColors.primaryGreen,
                      ),
                      body: const Center(
                        child: Text('Treatment data missing or invalid.'),
                      ),
                    );
                  }
                  return OrganicTreatmentScreen(data: data);
                },
              ),
              GoRoute(
                path: 'pests',
                builder: (context, state) => const PestsAndDiseasesScreen(),
              ),
              GoRoute(
                path: 'stage-expanded',
                builder: (context, state) {
                  final args = state.extra as Map<String, dynamic>;
                  return StageExpandedScreen(
                    stageTitle: args['title'] as String,
                    diseases: args['diseases'] as List<DiseaseDetailsModel>,
                  );
                },
              ),
            ],
          ),

          
          // 2. Marketplace
          GoRoute(
            path: '/market',
            builder: (context, state) => const MarketplaceScreen(),
            routes: [
              GoRoute(
                path: 'product/:id',
                builder: (context, state) => const ProductDetailScreen(),
              ),
              GoRoute(
                path: 'cart',
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          
          // 3. Profile
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'farm-history',
                builder: (context, state) => const FarmHistoryScreen(),
              ),
              GoRoute(
                path: 'purchase-inputs',
                builder: (context, state) => const PurchaseInputsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
