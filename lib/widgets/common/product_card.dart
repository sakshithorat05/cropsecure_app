import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_assets.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import 'cart_stepper.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCard extends ConsumerWidget {
  final ProductModel product;
  final bool isCompact;

  const ProductCard({
    super.key,
    required this.product,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartItem = cartItems.cast<dynamic>().firstWhere(
      (item) => item.product.id == product.id, 
      orElse: () => null,
    );
    final quantity = cartItem?.quantity ?? 0;

    final String lowerName = product.name.toLowerCase();
    final bool isOrganic = lowerName.contains('trichoderma') || lowerName.contains('psuedomonas');
    final bool isChemical = lowerName.contains('blue copper') || lowerName.contains('metaxel');

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withAlpha(90),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.cardBorder.withAlpha(80), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Section
          Container(
            height: isCompact ? 70 : 85,
            margin: const EdgeInsets.fromLTRB(AppSpacing.xs, AppSpacing.xs, AppSpacing.xs, 0),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withAlpha(150),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: Center(
               child: product.imageUrls.isNotEmpty
                   ? CachedNetworkImage(
                       imageUrl: product.imageUrls.first,
                       fit: BoxFit.contain,
                       placeholder: (context, url) => Image.asset(AppAssets.placeholderProduct),
                       errorWidget: (context, url, error) => Image.asset(AppAssets.placeholderProduct),
                     )
                   : Image.asset(AppAssets.placeholderProduct, fit: BoxFit.contain),
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isCompact)
                    Row(
                      children: [
                        Text('Fungicide', style: AppTextStyles.labelSmall.copyWith(fontSize: 8, color: AppColors.textSecondary)),
                        const SizedBox(width: 4),
                        if (isOrganic)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.eco, size: 6, color: AppColors.white),
                                const SizedBox(width: 2),
                                Text('Organic', style: AppTextStyles.labelSmall.copyWith(fontSize: 7, color: AppColors.white)),
                              ],
                            ),
                          ),
                        if (isChemical)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.science, size: 6, color: AppColors.white),
                                const SizedBox(width: 2),
                                Text('Chemical', style: AppTextStyles.labelSmall.copyWith(fontSize: 7, color: AppColors.white)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: AppTextStyles.headingMedium.copyWith(fontSize: 14, color: AppColors.textPrimary, height: 1.1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (!isCompact) 
                        Text(
                          product.brandName,
                          style: AppTextStyles.bodySmall.copyWith(fontSize: 9, color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withAlpha(150),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${AppStrings.currencyFormatting}${product.pricePerUnit.toStringAsFixed(0)}',
                              style: AppTextStyles.headingSmall.copyWith(fontSize: 11, color: AppColors.primaryGreen, height: 1.0),
                            ),
                            Text(
                              product.unitLabel,
                              style: AppTextStyles.labelSmall.copyWith(fontSize: 7, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: CartStepper(
                          quantity: quantity,
                          onIncrement: () {
                            if (quantity == 0) {
                              ref.read(cartProvider.notifier).addItem(product);
                            } else {
                              ref.read(cartProvider.notifier).increment(product.id);
                            }
                          },
                          onDecrement: () => ref.read(cartProvider.notifier).decrement(product.id),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
