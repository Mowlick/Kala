import 'package:flutter/material.dart';
import '../../../../core/theme/kala_colors.dart';

class OnboardingProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OnboardingProgressBar({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text step indicator (e.g. "Step 1 of 4")
        Text(
          'Step $currentStep of $totalSteps',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: KalaColors.burntOrange,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        // Progress segments
        Row(
          children: List.generate(totalSteps, (index) {
            final stepNum = index + 1;
            final isActive = stepNum <= currentStep;
            
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(
                  right: index == totalSteps - 1 ? 0 : 8,
                ),
                decoration: BoxDecoration(
                  color: isActive ? KalaColors.burntOrange : KalaColors.softBeige,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
