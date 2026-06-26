import 'package:flutter/material.dart';
import '../../../../core/theme/kala_colors.dart';
import 'onboarding_progress_bar.dart';

class OnboardingLaptopLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final int stepNumber;
  final Widget child;
  final VoidCallback? onBackPressed;
  final Widget continueButton;
  final Widget? illustration;

  const OnboardingLaptopLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.stepNumber,
    required this.child,
    this.onBackPressed,
    required this.continueButton,
    this.illustration,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KalaColors.ivory,
      body: SafeArea(
        child: Row(
          children: [
            // Left Panel (Expanded)
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
                color: KalaColors.ivory,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button
                    if (onBackPressed != null)
                      InkWell(
                        onTap: onBackPressed,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.arrow_back, size: 20, color: KalaColors.charcoal),
                              const SizedBox(width: 8),
                              Text(
                                'Back',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: KalaColors.charcoal,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title & Subtitle
                              Text(
                                title,
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                      color: KalaColors.charcoal,
                                      fontSize: 36,
                                      height: 1.2,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: 32,
                                height: 2,
                                color: KalaColors.burntOrange,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                subtitle,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: KalaColors.mediumGrey,
                                      fontSize: 15,
                                      height: 1.5,
                                    ),
                              ),
                              const SizedBox(height: 32),
                              // Illustration area
                              Center(
                                child: illustration ??
                                    Container(
                                      height: 200,
                                      width: 250,
                                      decoration: BoxDecoration(
                                        color: KalaColors.softBeige.withValues(alpha: 0.5),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Center(
                                        child: Icon(Icons.palette_outlined, size: 64, color: KalaColors.burntOrange),
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Vertical Divider
            Container(width: 1, color: KalaColors.softBeige),
            
            // Right Panel (Expanded)
            Expanded(
              flex: 6,
              child: Container(
                color: KalaColors.ivory,
                padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 40),
                child: Column(
                  children: [
                    // Top Header: Step Indicator & Help
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 100), // Balance the Need Help text
                        SizedBox(
                          width: 350,
                          child: OnboardingProgressBar(currentStep: stepNumber),
                        ),
                        Row(
                          children: [
                            Text(
                              'Need help?',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: KalaColors.charcoal,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.help_outline, size: 18, color: KalaColors.charcoal),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    
                    // Main Form Content
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: child,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Bottom Right Continue Button
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        height: 50,
                        width: 200,
                        child: continueButton,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
