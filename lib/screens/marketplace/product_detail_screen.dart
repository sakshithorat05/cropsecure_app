import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_assets.dart';
import '../../models/product_model.dart';
import '../../models/cart_item_model.dart';
import '../../providers/marketplace_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/common/product_card.dart';

// Simulated API call for a single product
final productDetailProvider = FutureProvider.family<ProductModel, String>((ref, productId) async {
  await Future.delayed(const Duration(milliseconds: 100)); // Simulating network
  final allProducts = ref.read(marketplaceProvider).allProducts;
  return allProducts.firstWhere((p) => p.id == productId, 
    orElse: () => throw Exception('Product not found'));
});

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.productId));
    final cartItems = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: Colors.transparent, // Allows underlying background/patterns
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (product) {
          final cartItem = cartItems.cast<dynamic>().firstWhere(
            (item) => item.product.id == product.id, 
            orElse: () => null,
          );
          
          final int quantity = cartItem?.quantity ?? 1; // Default selector explicitly rendered as 1 in target UI

          return Column(
            children: [
              // Custom Dark Green Solid Header
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + AppSpacing.sm,
                  bottom: AppSpacing.sm,
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                ),
                decoration: const BoxDecoration(color: Color(0xFF4A7D59)), // Custom match to target dark green
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: 20),
                    ),
                    Stack(
                       clipBehavior: Clip.none,
                       children: [
                         Container(
                           padding: const EdgeInsets.all(6),
                           decoration: BoxDecoration(
                             color: AppColors.white,
                             borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                           ),
                           child: const Icon(Icons.shopping_cart, color: AppColors.textPrimary, size: 20),
                         ),
                         if (cartItems.isNotEmpty)
                           Positioned(
                             top: -6,
                             right: -6,
                             child: Container(
                               padding: const EdgeInsets.all(4),
                               decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                               child: Text(
                                 cartItems.fold<int>(0, (sum, i) => sum + i.quantity).toString(),
                                 style: AppTextStyles.labelSmall.copyWith(color: AppColors.white, fontSize: 10, height: 1),
                               ),
                             )
                           ),
                       ]
                    ),
                  ],
                ),
              ),
              
              // Scrollable Detail View Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // White Image Section with indicators
                      Container(
                        color: AppColors.white,
                        height: 280,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              onPageChanged: (index) => setState(() => _currentImageIndex = index),
                              itemCount: product.imageUrls.isNotEmpty ? product.imageUrls.length : 1,
                              itemBuilder: (context, index) {
                                final url = product.imageUrls.isNotEmpty ? product.imageUrls[index] : '';
                                if (url.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(AppSpacing.xl),
                                    child: Image.asset(AppAssets.placeholderProduct, fit: BoxFit.contain),
                                  );
                                }
                                return CachedNetworkImage(
                                  imageUrl: url,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => Image.asset(AppAssets.placeholderProduct),
                                  errorWidget: (context, url, err) => Image.asset(AppAssets.placeholderProduct),
                                );
                              },
                            ),
                            if (product.imageUrls.length > 1 || true) // Show dots for mockup mimic
                              Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(3, (index) { // Hardcoding 3 for mockup accuracy visually
                                    final isActive = index == _currentImageIndex;
                                    return Container(
                                      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs / 2),
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: isActive ? Color(0xFF4A7D59) : AppColors.cardBorder,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: isActive ? Color(0xFF4A7D59) : AppColors.textHint, width: 0.5)
                                      ),
                                    );
                                  }),
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      // Highlight Detail Banner (Light Green)
                      Container(
                        color: AppColors.primaryContainer.withAlpha(160),
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.name, style: AppTextStyles.headingLarge.copyWith(color: AppColors.textPrimary, fontSize: 24, height: 1.1)),
                                  const SizedBox(height: 2),
                                  Text(product.brandName, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontSize: 13)),
                                  const SizedBox(height: AppSpacing.xs),
                                  Row(
                                    children: [
                                      Row(
                                        children: List.generate(5, (index) => Icon(
                                          index < product.rating.floor() ? Icons.star : Icons.star_border, 
                                          size: 10, 
                                          color: AppColors.warning
                                        )),
                                      ),
                                      const SizedBox(width: AppSpacing.xs),
                                      Text('${product.rating} (${product.reviewCount} reviews)', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${AppStrings.currencyFormatting}${product.pricePerUnit.toStringAsFixed(0)}', style: AppTextStyles.headingLarge.copyWith(color: Color(0xFF4A7D59), fontSize: 24)),
                                const SizedBox(height: AppSpacing.sm),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text('In Stock', style: AppTextStyles.labelSmall.copyWith(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // -------------------------
                            // DOSAGE CALCULATOR CARD
                            // -------------------------
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.cardBorder.withAlpha(150)),
                                boxShadow: [BoxShadow(color: AppColors.black.withAlpha(8), blurRadius: 10, offset: const Offset(0, 4))],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Dosage Calculator', style: AppTextStyles.headingMedium.copyWith(fontSize: 14)),
                                  const SizedBox(height: AppSpacing.sm),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 40,
                                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                                          decoration: BoxDecoration(
                                            color: AppColors.white,
                                            border: Border.all(color: AppColors.cardBorder),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          alignment: Alignment.centerLeft,
                                          child: Text('Enter water volume (Liters)', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint, fontSize: 12)),
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF4A7D59), // custom matte dark green for button
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text('Calculate Dosage', style: AppTextStyles.labelMedium.copyWith(color: AppColors.white, fontSize: 11)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                   Text('Recommended Dosage: ${product.dosagePerAcre} ${product.dosageUnit} per acre', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, fontSize: 9)),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: AppSpacing.md),
                            
                            // -------------------------
                            // TARGET DISEASES CARD
                            // -------------------------
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECA39A), // Salmon matching mockup
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Text('Target Diseases', style: AppTextStyles.headingMedium.copyWith(fontSize: 14)),
                                  const SizedBox(height: AppSpacing.md),
                                  if (product.targetDiseases.isEmpty) 
                                    Text('General protection', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary))
                                  else
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: product.targetDiseases.take(3).map((d) => _buildMockDiseaseAvatar(d, Icons.eco)).toList(),
                                    ),
                                ],
                              ),
                            ),

                            const SizedBox(height: AppSpacing.md),
                            
                            // -------------------------
                            // SAFETY INSTRUCTIONS CARD
                            // -------------------------
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6D673), // Amber matching mockup
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: AppColors.error,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.priority_high, color: AppColors.white, size: 10),
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Text('Safety Instructions', style: AppTextStyles.headingMedium.copyWith(fontSize: 14)),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ...product.safetyInstructions.split('.').where((s) => s.trim().isNotEmpty).map((s) => _buildBullet(s.trim()))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: AppSpacing.md),

                            // -------------------------
                            // RELATED PRODUCTS STRIP
                            // -------------------------
                            Text('Complete your Jasmine Care', style: AppTextStyles.headingMedium.copyWith(fontSize: 16, color: const Color(0xFF4A7D59))),
                            const SizedBox(height: AppSpacing.sm),
                            SizedBox(
                              height: 80, // Increased height to prevent pixel overflow
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 2, 
                                itemBuilder: (context, index) {
                                  // Mock identical related products based on Figma layout
                                  return _buildMockRelatedCard();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Sticky Bottom Action Container (Floating Look)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, MediaQuery.of(context).padding.bottom + AppSpacing.md),
                  child: Row(
                    children: [
                      // 1. Customized Grey Stepper
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E0E0), 
                          borderRadius: BorderRadius.circular(25), // Pill shaped
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 4),
                            GestureDetector(
                               onTap: () {
                                  if (quantity > 1) {
                                      // Simulated decrement implementation
                                  }
                               },
                               child: const Icon(Icons.remove, size: 20, color: AppColors.textPrimary),
                            ),
                            const SizedBox(width: 16),
                            Text(quantity.toString(), style: AppTextStyles.headingLarge.copyWith(fontSize: 20)),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () {
                                  // Simulated increment implementation
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                                child: const Icon(Icons.add, size: 16, color: Color(0xFF4A7D59)),
                              ),
                            ),
                            const SizedBox(width: 4),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      // 2. Add to Cart Button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                             ref.read(cartProvider.notifier).addItem(product);
                             // Further navigation or UI feedback could go here
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A7D59), // matching the dark green button in design
                              borderRadius: BorderRadius.circular(25), // Pill shaped
                            ),
                            alignment: Alignment.center,
                            child: Text('Add to Cart', style: AppTextStyles.headingLarge.copyWith(color: AppColors.white, fontSize: 18)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Uses icons for simulation since physical mock images aren't present in assets
  Widget _buildMockDiseaseAvatar(String title, IconData mockIcon) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
            border: Border.all(color: AppColors.surfaceWhite, width: 2), // Gives a slightly visible white ring effect
            image: DecorationImage(
                image: AssetImage(AppAssets.placeholderProduct),
                fit: BoxFit.cover,
            ),
          ),
          child: Container(
             decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFF4A7D59).withOpacity(0.3)),
             child: Icon(mockIcon, color: AppColors.white.withOpacity(0.8), size: 30)
          ),
        ),
        const SizedBox(height: 6),
        Text(title, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.black, fontSize: 11)),
      ],
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(child: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(text, style: AppTextStyles.bodyMedium.copyWith(fontSize: 10, color: AppColors.textPrimary)),
          )),
        ],
      ),
    );
  }

  Widget _buildMockRelatedCard() {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withAlpha(120),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryGreen.withAlpha(50), width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Simulated mock image block
          Container(
            width: 80,
            decoration: BoxDecoration(
               color: AppColors.white,
               borderRadius: BorderRadius.circular(6),
            ),
            child: Center(child: Image.asset(AppAssets.placeholderProduct)),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Trichoderma', style: AppTextStyles.headingSmall.copyWith(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('Tricoderma Viride Powder', style: AppTextStyles.bodySmall.copyWith(fontSize: 8, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(2)),
                  child: Text('Organic', style: AppTextStyles.labelSmall.copyWith(fontSize: 6, color: AppColors.white)),
                ),
                const Spacer(),
                Text('₹ 250 per kg', style: AppTextStyles.headingSmall.copyWith(color: const Color(0xFF4A7D59), fontSize: 11)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
