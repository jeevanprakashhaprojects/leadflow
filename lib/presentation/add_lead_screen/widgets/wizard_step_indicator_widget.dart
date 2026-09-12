import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class WizardStepIndicatorWidget extends StatelessWidget {
  final List<String> steps;
  final int currentStep;
  final List<bool> completedSteps;
  final ValueChanged<int> onStepTap;

  const WizardStepIndicatorWidget({
    super.key,
    required this.steps,
    required this.currentStep,
    required this.completedSteps,
    required this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surfaceLight,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          // Step dots row
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: steps.length,
              itemBuilder: (context, index) {
                final isActive = index == currentStep;
                final isCompleted = completedSteps[index];
                final isPast = index < currentStep;

                return GestureDetector(
                  onTap: () => onStepTap(index),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: isActive ? 28 : 24,
                            height: isActive ? 28 : 24,
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? AppTheme.success
                                  : isActive
                                  ? AppTheme.primary
                                  : isPast
                                  ? AppTheme.primaryMuted
                                  : AppTheme.surface200,
                              shape: BoxShape.circle,
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: AppTheme.primary.withAlpha(89),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: isCompleted
                                  ? const Icon(
                                      Icons.check_rounded,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : Text(
                                      '${index + 1}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: isActive || isPast
                                            ? Colors.white
                                            : AppTheme.textMuted,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      if (index < steps.length - 1)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 20,
                          height: 2,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: isPast || isCompleted
                                ? AppTheme.primary
                                : AppTheme.surface200,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Step ${currentStep + 1} of ${steps.length}: ${steps[currentStep]}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
