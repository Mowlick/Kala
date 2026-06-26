import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../onboarding_controller.dart';
import '../widgets/onboarding_progress_bar.dart';
import '../widgets/onboarding_laptop_layout.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final List<Map<String, dynamic>> _goalsList = [
    {'title': 'Build my personal brand', 'icon': Icons.stars},
    {'title': 'Find gigs & paid opportunities', 'icon': Icons.payments},
    {'title': 'Collaborate with other artists', 'icon': Icons.palette},
    {'title': 'Work on exciting projects', 'icon': Icons.rocket_launch},
    {'title': 'Learn and grow', 'icon': Icons.psychology},
    {'title': 'Go full-time as a creator', 'icon': Icons.work},
  ];

  final List<String> _selectedGoals = [
    'Build my personal brand',
    'Find gigs & paid opportunities',
    'Collaborate with other artists'
  ];

  void _onContinue(OnboardingController controller) {
    // Save goals to controller
    for (final goal in _selectedGoals) {
      if (!controller.model.goals.contains(goal)) {
        controller.toggleGoal(goal);
      }
    }
    controller.nextStep(context, '/portfolio-links');
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OnboardingController>();

    return Scaffold(
      backgroundColor: KalaColors.ivory,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 1000) {
              return _buildLaptopLayout(context, controller);
            }
            return _buildMobileLayout(context, controller);
          },
        ),
      ),
    );
  }

  Widget _buildLaptopLayout(BuildContext context, OnboardingController controller) {
    return OnboardingLaptopLayout(
      title: 'What are your\ngoals?',
      subtitle: 'Choose what matters most to you\nso we can tailor your experience.',
      stepNumber: 3,
      illustration: Image.asset('assets/images/onboarding/illustration_3.png'),
      onBackPressed: () => controller.prevStep(context),
      continueButton: ElevatedButton(
        onPressed: () => _onContinue(controller),
        style: ElevatedButton.styleFrom(
          backgroundColor: KalaColors.burntOrange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 0,
        ),
        child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      child: _buildFormContent(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context, OnboardingController controller) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => controller.prevStep(context),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const OnboardingProgressBar(currentStep: 3),
                    const SizedBox(height: 32),
                    Text(
                      'What are your goals?',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose what matters most to you.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: KalaColors.mediumGrey,
                          ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: _buildFormContent(context),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _onContinue(controller),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Continue'),
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

  Widget _buildFormContent(BuildContext context) {
    return ListView.builder(
      itemCount: _goalsList.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final goal = _goalsList[index]['title'] as String;
        final icon = _goalsList[index]['icon'] as IconData;
        final isSelected = _selectedGoals.contains(goal);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedGoals.remove(goal);
              } else {
                _selectedGoals.add(goal);
              }
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? KalaColors.burntOrange : KalaColors.softBeige,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? KalaColors.burntOrange : KalaColors.charcoal,
                  size: 22,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    goal,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                  ),
                ),
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isSelected ? KalaColors.burntOrange : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected ? KalaColors.burntOrange : KalaColors.lightGrey,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
