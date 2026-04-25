import 'package:flutter/material.dart';
import '../../core/services/database_service.dart';
import '../../core/services/user_session_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import 'models/purchase_model.dart';

class PurchaseInputsScreen extends StatefulWidget {
  const PurchaseInputsScreen({super.key});

  @override
  State<PurchaseInputsScreen> createState() => _PurchaseInputsScreenState();
}

class _PurchaseInputsScreenState extends State<PurchaseInputsScreen> {
  final DatabaseService _db = DatabaseService();
  final UserSessionService _session = UserSessionService();
  late Future<List<PurchaseModel>> _purchaseFuture;

  @override
  void initState() {
    super.initState();
    _purchaseFuture = _loadPurchases();
  }

  Future<List<PurchaseModel>> _loadPurchases() async {
    final uid = await _session.getCurrentUserId();
    return _db.getUserPurchases(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Purchase History', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: FutureBuilder<List<PurchaseModel>>(
        future: _purchaseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final purchases = snapshot.data ?? [];

          if (purchases.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: purchases.length,
            itemBuilder: (context, index) {
              return _buildPurchaseCard(purchases[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No purchases found',
            style: AppTextStyles.headingMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Items you buy from the marketplace will appear here.',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseCard(PurchaseModel purchase) {
    final dateStr = '${purchase.purchaseDate.day}/${purchase.purchaseDate.month}/${purchase.purchaseDate.year}';
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [AppColors.softShadow],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // Product Icon/Thumbnail
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getCategoryIcon(purchase.productCategory),
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    purchase.productName,
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Qty: ${purchase.quantity} • $dateStr',
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            // Price & Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${purchase.price.toStringAsFixed(0)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    purchase.status,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.success,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'seeds':
        return Icons.grass;
      case 'fertilizers':
        return Icons.science_outlined;
      case 'pesticides':
        return Icons.bug_report_outlined;
      case 'tools':
        return Icons.construction;
      default:
        return Icons.inventory_2_outlined;
    }
  }
}
