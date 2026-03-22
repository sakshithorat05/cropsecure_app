import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/marketplace_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/common/product_card.dart';
import 'voice_search_overlay.dart';

class MarketplaceScreen extends ConsumerWidget {
  const MarketplaceScreen({super.key});

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Filters', style: AppTextStyles.headingMedium),
              const SizedBox(height: AppSpacing.md),
              ListTile(
                title: Text('Sort by Price: Low to High', style: AppTextStyles.bodyLarge),
                onTap: () {
                  ref.read(marketplaceProvider.notifier).setSortOption('price_low');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Sort by Price: High to Low', style: AppTextStyles.bodyLarge),
                onTap: () {
                  ref.read(marketplaceProvider.notifier).setSortOption('price_high');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Clear Filters', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error)),
                onTap: () {
                  ref.read(marketplaceProvider.notifier).setSortOption('');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(marketplaceProvider);
    final cartItems = ref.watch(cartProvider);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + AppSpacing.md,
              bottom: AppSpacing.md,
              left: AppSpacing.md,
              right: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withAlpha(240),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withAlpha(20),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.marketplaceTitle, style: AppTextStyles.headingLarge.copyWith(color: AppColors.white, fontSize: 28)),
                    Stack(
                       clipBehavior: Clip.none,
                       children: [
                         Container(
                           padding: const EdgeInsets.all(8),
                           decoration: BoxDecoration(
                             color: AppColors.white,
                             borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                           ),
                           child: const Icon(Icons.shopping_cart, color: AppColors.textPrimary, size: 24),
                         ),
                         if (cartItems.isNotEmpty)
                           Positioned(
                             top: -6,
                             right: -6,
                             child: Container(
                               padding: const EdgeInsets.all(6),
                               decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                               child: Text(
                                 cartItems.fold<int>(0, (sum, i) => sum + i.quantity).toString(),
                                 style: AppTextStyles.labelSmall.copyWith(color: AppColors.white, fontSize: 10, height: 1),
                               ),
                             )
                           ),
                       ]
                    ),
                  ]
                ),
                const SizedBox(height: AppSpacing.lg),
                GestureDetector(
                  onTap: () => context.push('/market/search'),
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withAlpha(220),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: AppColors.primaryGreen),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            AppStrings.searchPlaceholder,
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const VoiceSearchOverlay(),
                            );
                          },
                          child: const Icon(Icons.mic_none, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Tab Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTab(context, ref, 0, AppStrings.tabFungicide, state.selectedTab == 0),
                  const SizedBox(width: AppSpacing.sm),
                  _buildTab(context, ref, 1, AppStrings.tabFertiliser, state.selectedTab == 1),
                  const SizedBox(width: AppSpacing.sm),
                  _buildTab(context, ref, 2, AppStrings.tabPesticide, state.selectedTab == 2),
                ],
              ),
            ),
          ),
          
          // Filter Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${state.filteredProducts.length} items',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                GestureDetector(
                  onTap: () => _showFilterSheet(context, ref),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Filters', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(width: 4),
                        const Icon(Icons.filter_alt_outlined, size: 16, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Product Grid
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primaryGreen,
              onRefresh: () => ref.read(marketplaceProvider.notifier).loadProducts(),
              child: state.isLoading 
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
                : state.filteredProducts.isEmpty
                    ? Center(
                        child: Text(
                          AppStrings.noSearchResults,
                          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: AppSpacing.md,
                          crossAxisSpacing: AppSpacing.md,
                          childAspectRatio: 0.62,
                        ),
                        itemCount: state.filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = state.filteredProducts[index];
                          return GestureDetector(
                            onTap: () {
                              context.push('/market/product/${product.id}');
                            },
                            child: ProductCard(product: product),
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, WidgetRef ref, int index, String label, bool isActive) {
    return GestureDetector(
      onTap: () => ref.read(marketplaceProvider.notifier).selectTab(index),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryGreen : AppColors.surfaceWhite.withAlpha(150),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: isActive ? null : Border.all(color: AppColors.primaryLight, width: 1.5),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isActive ? AppColors.white : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
