import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_assets.dart';
import '../../providers/marketplace_provider.dart';
import '../../widgets/common/product_card.dart';

final searchProvider = NotifierProvider<SearchNotifier, String>(() => SearchNotifier());
class SearchNotifier extends Notifier<String> {
  @override
  String build() => '';
  void updateState(String query) => state = query;
}

final recentSearchesProvider = NotifierProvider<RecentSearchesNotifier, List<String>>(() => RecentSearchesNotifier());
class RecentSearchesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => ['Blue Copper', 'Urea', 'Trichoderma'];
  void updateState(List<String> r) => state = r;
}

class SearchOverlayScreen extends ConsumerStatefulWidget {
  const SearchOverlayScreen({super.key});

  @override
  ConsumerState<SearchOverlayScreen> createState() => _SearchOverlayScreenState();
}

class _SearchOverlayScreenState extends ConsumerState<SearchOverlayScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(searchProvider.notifier).updateState(query);
      ref.read(marketplaceProvider.notifier).search(query);
    });
  }

  void _commitSearch(String query) {
    if (query.trim().isEmpty) return;
    
    final recents = ref.read(recentSearchesProvider);
    if (!recents.contains(query.trim())) {
      ref.read(recentSearchesProvider.notifier).updateState([query.trim(), ...recents].take(5).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchProvider);
    final recents = ref.watch(recentSearchesProvider);
    final marketplaceState = ref.watch(marketplaceProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search Input Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(Icons.arrow_back_ios_new, color: AppColors.primaryGreen, size: 24),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: AppColors.textHint),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              autofocus: true,
                              showCursor: true,
                              cursorColor: AppColors.primaryGreen,
                              onChanged: _onSearchChanged,
                              onSubmitted: _commitSearch,
                              decoration: InputDecoration(
                                hintText: AppStrings.searchPlaceholder,
                                hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      AppStrings.cancel,
                      style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryGreen),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: query.length >= 2
                  ? _buildSearchResults(marketplaceState)
                  : _buildIdleState(context, ref, recents),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(MarketplaceState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen));
    }
    
    if (state.filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: AppColors.textHint),
            const SizedBox(height: AppSpacing.md),
            Text(AppStrings.noSearchResults, style: AppTextStyles.headingMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(AppStrings.noSearchResultsSubtitle, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      );
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.55,
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
    );
  }

  Widget _buildIdleState(BuildContext context, WidgetRef ref, List<String> recents) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (recents.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.recentSearches, style: AppTextStyles.headingSmall),
                TextButton(
                  onPressed: () => ref.read(recentSearchesProvider.notifier).updateState([]),
                  child: Text(AppStrings.clearAll, style: AppTextStyles.labelMedium.copyWith(color: AppColors.error)),
                ),
              ],
            ),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: recents.map((r) {
                return InputChip(
                  label: Text(r, style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryGreen)),
                  backgroundColor: AppColors.primaryContainer,
                  deleteIcon: const Icon(Icons.close, size: 14, color: AppColors.textSecondary),
                  onDeleted: () {
                    ref.read(recentSearchesProvider.notifier).updateState(
                        recents.where((e) => e != r).toList());
                  },
                  onPressed: () {
                    _controller.text = r;
                    _onSearchChanged(r);
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusSm)),
                  side: BorderSide.none,
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          
          Text(AppStrings.popularProducts, style: AppTextStyles.headingSmall),
          const SizedBox(height: AppSpacing.md),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3, 
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    child: Image.asset(AppAssets.placeholderProduct, fit: BoxFit.cover),
                  ),
                ),
                title: Text('Popular Product ${index + 1}', style: AppTextStyles.bodyMedium),
                subtitle: Text('Brand name', style: AppTextStyles.bodySmall),
                trailing: Text('${AppStrings.currencyFormatting}250', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primaryGreen)),
                onTap: () {
                  context.push('/market/product/p1');
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
