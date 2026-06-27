import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../onboarding_controller.dart';
import '../widgets/onboarding_progress_bar.dart';
import '../widgets/onboarding_laptop_layout.dart';

class RoleSelectScreen extends StatefulWidget {
  const RoleSelectScreen({super.key});

  @override
  State<RoleSelectScreen> createState() => _RoleSelectScreenState();
}

class _RoleSelectScreenState extends State<RoleSelectScreen> {
  final List<Map<String, dynamic>> _roles = [
    {'name': 'Singer', 'icon': Icons.mic_none_outlined, 'description': 'Share your voice and create magic.'},
    {'name': 'Dancer', 'icon': Icons.directions_run, 'description': 'Express yourself through movement and rhythm.'},
    {'name': 'Actor', 'icon': Icons.theater_comedy_outlined, 'description': 'Bring stories to life on stage and screen.'},
    {'name': 'Filmmaker', 'icon': Icons.movie_creation_outlined, 'description': 'Tell visual stories behind the camera.'},
    {'name': 'Music Producer', 'icon': Icons.headphones_outlined, 'description': 'Create, produce and shape sound.'},
    {'name': 'Photographer', 'icon': Icons.camera_alt_outlined, 'description': 'Capture moments, create art.'},
    {'name': 'Writer / Poet', 'icon': Icons.edit_outlined, 'description': 'Write words that inspire and connect.'},
    {'name': 'Other', 'icon': Icons.grid_view, 'description': 'Something else? Tell us more.'},
  ];

  List<String>? _selectedRoles;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OnboardingController>();
    _selectedRoles ??= List.from(controller.model.roles);

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
      title: 'What best\ndescribes you?',
      subtitle: 'This helps us personalize your\nexperience and show you the most\nrelevant opportunities.',
      stepNumber: 1,
      illustration: Image.asset('assets/images/onboarding/illustration_1.png'),
      onBackPressed: () => controller.prevStep(context),
      continueButton: ElevatedButton(
        onPressed: _selectedRoles!.isEmpty
            ? null
            : () {
                controller.setRoles(_selectedRoles!);
                controller.nextStep(context, '/profile-details');
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedRoles!.isEmpty ? KalaColors.lightGrey : KalaColors.burntOrange,
          foregroundColor: _selectedRoles!.isEmpty ? KalaColors.mediumGrey : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 0,
        ),
        child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: _roles.length,
        itemBuilder: (context, index) {
          final role = _roles[index];
          final isSelected = _selectedRoles!.contains(role['name']);

          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedRoles!.remove(role['name']);
                } else {
                  _selectedRoles!.add(role['name']);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? KalaColors.burntOrange : KalaColors.softBeige,
                  width: isSelected ? 1.5 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: KalaColors.burntOrange.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        role['icon'],
                        color: isSelected ? KalaColors.burntOrange : KalaColors.charcoal,
                        size: 40,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        role['name'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: KalaColors.charcoal,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        role['description'],
                        style: const TextStyle(
                          fontSize: 11,
                          color: KalaColors.mediumGrey,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isSelected ? KalaColors.burntOrange : KalaColors.lightGrey,
                          width: 1.5,
                        ),
                        color: isSelected ? KalaColors.burntOrange : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Center(
                              child: Icon(Icons.check, color: Colors.white, size: 14),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
                    const OnboardingProgressBar(currentStep: 1),
                    const SizedBox(height: 32),
                    Text(
                      'What best describes you?',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select all that apply to personalize your experience.',
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
                          final isSelected = _selectedRoles!.contains(role['name']);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedRoles!.remove(role['name']);
                                } else {
                                  _selectedRoles!.add(role['name']);
                                }
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
                                  color: isSelected ? KalaColors.burntOrange : KalaColors.softBeige,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    role['icon'],
                                    color: isSelected ? KalaColors.burntOrange : KalaColors.charcoal,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    role['name'],
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: isSelected ? KalaColors.burntOrange : KalaColors.lightGrey,
                                        width: 1.5,
                                      ),
                                      color: isSelected ? KalaColors.burntOrange : Colors.transparent,
                                    ),
                                    child: isSelected
                                        ? const Center(
                                            child: Icon(Icons.check, color: Colors.white, size: 16),
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
                      onPressed: _selectedRoles!.isEmpty
                          ? null
                          : () {
                              controller.setRoles(_selectedRoles!);
                              controller.nextStep(context, '/profile-details');
                            },
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
}
