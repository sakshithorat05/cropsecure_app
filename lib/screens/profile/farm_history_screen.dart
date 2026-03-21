import 'package:flutter/material.dart';
import '../../core/services/database_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'models/farm_history_model.dart';
// Removed intl import to bypass build issues

class FarmHistoryScreen extends StatefulWidget {
  const FarmHistoryScreen({super.key});

  @override
  State<FarmHistoryScreen> createState() => _FarmHistoryScreenState();
}

class _FarmHistoryScreenState extends State<FarmHistoryScreen> {
  final DatabaseService _db = DatabaseService();
  final String _tempUid = 'user_123'; // Temporary UID for development
  late Future<List<FarmHistoryModel>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _db.getUserFarmHistory(_tempUid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text('Farm History', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<FarmHistoryModel>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final logs = snapshot.data ?? [];

          if (logs.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: logs.length,
            itemBuilder: (context, index) {
              return _buildTimelineItem(logs[index], index == logs.length - 1);
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
          Icon(Icons.history_toggle_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No history yet',
            style: AppTextStyles.headingMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Your scans and treatments will appear here.',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(FarmHistoryModel log, bool isLast) {
    final bool isScan = log.type == FarmHistoryType.scan;
    final date = log.createdAt;
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    final dateStr = '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year} • ${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $amPm';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isScan ? AppColors.accentLime : AppColors.info,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: (isScan ? AppColors.accentLime : AppColors.info).withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 2,
                    )
                  ],
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey[200],
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dateStr, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200] ?? Colors.grey),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isScan ? Icons.qr_code_scanner : Icons.medical_services_outlined,
                              size: 18,
                              color: isScan ? AppColors.primaryGreen : AppColors.info,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              log.title,
                              style: AppTextStyles.headingSmall.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(log.subtitle, style: AppTextStyles.bodyMedium),
                        if (log.metadata.containsKey('disease')) ...[
                           const SizedBox(height: 8),
                           Row(
                             children: [
                               Container(
                                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                 decoration: BoxDecoration(
                                   color: AppColors.riskMedium.withOpacity(0.1),
                                   borderRadius: BorderRadius.circular(4),
                                 ),
                                 child: Text(
                                   log.metadata['severity'] ?? 'Unknown Risk',
                                   style: AppTextStyles.labelSmall.copyWith(color: AppColors.riskMedium),
                                 ),
                               ),
                             ],
                           )
                        ]
                      ],
                    ),
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
