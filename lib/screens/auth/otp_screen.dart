import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';

class OTPScreen extends ConsumerStatefulWidget {
  const OTPScreen({super.key});

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  // Note: login is called directly from the button handler per app routing requirements.

  void _resend() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP resent')));
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 48,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
        style: AppTextStyles.displayMedium,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index + 1 < _focusNodes.length) {
              _focusNodes[index + 1].requestFocus();
            } else {
              _focusNodes[index].unfocus();
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Verify OTP', style: AppTextStyles.displayMedium, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Sent OTP to mobile number', style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) => _buildOtpBox(i)).map((w) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: w,
                )).toList(),
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
                  onPressed: () {
                    ref.read(authProvider.notifier).login('', _otp);
                    context.go('/home');
                  },
                  child: Text('Verify', style: AppTextStyles.displayMedium.copyWith(color: AppColors.white)),
                ),
              ),

              const SizedBox(height: 12),
              TextButton(
                onPressed: _resend,
                child: Text('Resend OTP', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryGreen)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

