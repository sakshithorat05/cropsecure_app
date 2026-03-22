import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ScanPreviewScreen extends StatelessWidget {
  final String? imagePath;
  const ScanPreviewScreen({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Top Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 24,
              bottom: 24,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    Text('Scan Affected Area', 
                      style: AppTextStyles.displayMedium.copyWith(
                        color: AppColors.white,
                        fontSize: 24,
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    'Take a clear photo in daylight focusing on the affected area',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  
                  // Image Preview Card
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.width * 0.85,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [AppColors.softShadow],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: imagePath != null 
                              ? (kIsWeb 
                                  ? Image.network(imagePath!, fit: BoxFit.cover)
                                  : Image.file(File(imagePath!), fit: BoxFit.cover))
                              : const Center(
                                  child: Icon(Icons.image, size: 80, color: Colors.grey),
                                ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            context.push('/home/scan/analyzing');
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            color: AppColors.primaryGreen,
                            alignment: Alignment.center,
                            child: Text(
                              'Analyze',
                              style: AppTextStyles.headingLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Capture Again Button
                  ElevatedButton.icon(
                    onPressed: () {
                      context.pop(); // Go back to camera
                    },
                    icon: const Icon(Icons.camera_alt_outlined, color: AppColors.white),
                    label: Text('Capture Again', style: AppTextStyles.labelLarge),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
