import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../onboarding_controller.dart';
import '../widgets/onboarding_progress_bar.dart';

class RoleSelectScreen extends StatefulWidget {
  const RoleSelectScreen({super.key});

  @override
  State<RoleSelectScreen> createState() => _RoleSelectScreenState();
}

class _RoleSelectScreenState extends State<RoleSelectScreen> {
  final List<Map<String, dynamic>> _roles = [
    {'name': 'Singer', 'icon': Icons.mic},
    {'name': 'Dancer', 'icon': Icons.directions_run},
    {'name': 'Actor', 'icon': Icons.theater_comedy},
    {'name': 'Filmmaker', 'icon': Icons.movie},
    {'name': 'Music Producer', 'icon': Icons.headset},
    {'name': 'Photographer', 'icon': Icons.camera_alt},
    {'name': 'Writer / Poet', 'icon': Icons.edit},
    {'name': 'Other', 'icon': Icons.grid_view},
  ];

  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OnboardingController>();
    _selectedRole ??= controller.model.role;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => controller.prevStep(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const OnboardingProgressBar(currentStep: 1),
              const SizedBox(height: 32),
              Text(
                'What best describes you?',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'This helps us personalize your experience.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: KalaColors.mediumGrey,
                    ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: _roles.length,
                  itemBuilder: (context, index) {
                    final role = _roles[index];
                    final isSelected = _selectedRole == role['name'];
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedRole = role['name'];
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? KalaColors.burntOrange
                                : KalaColors.softBeige,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              role['icon'],
                              color: isSelected
                                  ? KalaColors.burntOrange
                                  : KalaColors.charcoal,
                              size: 24,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              role['name'],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                            ),
                            const Spacer(),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? KalaColors.burntOrange
                                      : KalaColors.lightGrey,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? Center(
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: KalaColors.burntOrange,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _selectedRole == null
                    ? null
                    : () {
                        controller.setRole(_selectedRole!);
                        controller.nextStep(context, '/profile-details');
                      },
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
