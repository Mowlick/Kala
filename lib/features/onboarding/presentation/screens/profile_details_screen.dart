import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../onboarding_controller.dart';
import '../widgets/onboarding_progress_bar.dart';
import '../widgets/onboarding_laptop_layout.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  String _selectedCity = 'Mumbai, India';
  String _selectedExperience = 'Intermediate';
  
  final List<String> _skillsList = [
    'Singing',
    'Songwriting',
    'Guitar',
    'Piano',
    'Beatboxing',
    'Music Production',
    'Other'
  ];
  final List<String> _selectedSkills = ['Singing', 'Songwriting'];

  final List<String> _languagesList = ['Hindi', 'English', 'Marathi', 'Other'];
  final List<String> _selectedLanguages = ['Hindi', 'English'];

  final List<Map<String, dynamic>> _openToOptions = [
    {'title': 'Collaborations', 'icon': Icons.people_outline},
    {'title': 'Gigs', 'icon': Icons.music_note_outlined},
    {'title': 'Full-time Opportunities', 'icon': Icons.business_center_outlined},
    {'title': 'Internships', 'icon': Icons.school_outlined},
  ];
  final List<String> _selectedOpenTo = ['Collaborations', 'Gigs'];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onContinue(OnboardingController controller) {
    if (_formKey.currentState!.validate()) {
      controller.updateDetails(
        name: _nameController.text.trim(),
        city: _selectedCity,
        experienceLevel: _selectedExperience,
        primarySkills: _selectedSkills,
        languages: _selectedLanguages,
        openTo: _selectedOpenTo,
      );
      controller.nextStep(context, '/goals');
    }
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
      title: 'Tell us about\nyourself',
      subtitle: 'Add a few details to get better\nopportunities and connections.',
      stepNumber: 2,
      illustration: Image.asset('assets/images/onboarding/illustration_2.png'),
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
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: _buildFormContent(context),
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const OnboardingProgressBar(currentStep: 2),
                      const SizedBox(height: 32),
                      Text(
                        'Tell us about yourself',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add a few details to get better opportunities and connections.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: KalaColors.mediumGrey,
                            ),
                      ),
                      const SizedBox(height: 24),
                      _buildFormContent(context),
                      const SizedBox(height: 32),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name field
          Text(
            'Name',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Enter your full name',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: KalaColors.softBeige),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: KalaColors.softBeige),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // City Dropdown
          Text(
            'City',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedCity,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: KalaColors.softBeige),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: KalaColors.softBeige),
              ),
            ),
            items: <String>[
              'Mumbai, India',
              'Delhi, India',
              'Bangalore, India',
              'Chennai, India',
              'Kolkata, India',
              'Pune, India',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedCity = newValue;
                });
              }
            },
          ),
          const SizedBox(height: 20),

          // Experience Level
          Text(
            'Experience Level',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: ['Beginner', 'Intermediate', 'Experienced'].map((level) {
              final isSelected = _selectedExperience == level;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedExperience = level;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? KalaColors.burntOrange : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? KalaColors.burntOrange : KalaColors.softBeige,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        level,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isSelected ? Colors.white : KalaColors.charcoal,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Primary Skills
          Text(
            'Primary Skills (Select up to 3)',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _skillsList.map((skill) {
              final isSelected = _selectedSkills.contains(skill);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedSkills.remove(skill);
                    } else {
                      if (_selectedSkills.length < 3) {
                        _selectedSkills.add(skill);
                      }
                    }
                  });
                },
                child: Chip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(skill),
                      if (isSelected) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.check, size: 14, color: Colors.white),
                      ]
                    ],
                  ),
                  backgroundColor: isSelected ? KalaColors.burntOrange : Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : KalaColors.charcoal,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: isSelected ? KalaColors.burntOrange : KalaColors.softBeige,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Languages
          Text(
            'Languages',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _languagesList.map((lang) {
              final isSelected = _selectedLanguages.contains(lang);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedLanguages.remove(lang);
                    } else {
                      _selectedLanguages.add(lang);
                    }
                  });
                },
                child: Chip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(lang),
                      if (isSelected) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.check, size: 14, color: Colors.white),
                      ]
                    ],
                  ),
                  backgroundColor: isSelected ? KalaColors.burntOrange : Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : KalaColors.charcoal,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: isSelected ? KalaColors.burntOrange : KalaColors.softBeige,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // I'm open to
          Text(
            "I'm open to",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 500;
              return GridView.count(
                crossAxisCount: isWide ? 4 : 2,
                shrinkWrap: true,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: isWide ? 1.5 : 2.5,
                children: _openToOptions.map((opt) {
                  final title = opt['title'] as String;
                  final icon = opt['icon'] as IconData;
                  final isSelected = _selectedOpenTo.contains(title);

                  // For short button display on small screens if needed
                  String shortTitle = title;
                  if (!isWide && title.contains('Opportunities')) {
                    shortTitle = 'Jobs';
                  }

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedOpenTo.remove(title);
                        } else {
                          _selectedOpenTo.add(title);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? KalaColors.burntOrange : KalaColors.softBeige,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: isWide
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  icon,
                                  color: isSelected ? KalaColors.burntOrange : KalaColors.charcoal,
                                  size: 24,
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Text(
                                    shortTitle,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          color: isSelected ? KalaColors.burntOrange : KalaColors.charcoal,
                                          fontSize: 11,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  icon,
                                  color: isSelected ? KalaColors.burntOrange : KalaColors.charcoal,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  shortTitle,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: isSelected ? KalaColors.burntOrange : KalaColors.charcoal,
                                        fontSize: 11,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                ),
                              ],
                            ),
                    ),
                  );
                }).toList(),
              );
            }
          ),
        ],
      ),
    );
  }
}
