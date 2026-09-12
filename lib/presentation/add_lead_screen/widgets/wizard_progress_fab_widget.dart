import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class WizardProgressFabWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<bool> completedSteps;

  const WizardProgressFabWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.completedSteps,
  });

  @override
  Widget build(BuildContext context) {
    final completed = completedSteps.where((c) => c).length;
    final progress = completed / totalSteps;

    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.surface200,
              valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
              strokeWidth: 3,
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withAlpha(77),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${(progress * 100).round()}%',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
