import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../onboarding_controller.dart';
import '../widgets/onboarding_progress_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OnboardingController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => controller.prevStep(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Form(
              key: _formKey,
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
                  
                  // Name field
                  Text(
                    'Name',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your full name',
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
                    decoration: const InputDecoration(),
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
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? KalaColors.burntOrange
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? KalaColors.burntOrange
                                    : KalaColors.softBeige,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                level,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: isSelected
                                          ? Colors.white
                                          : KalaColors.charcoal,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
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
                          backgroundColor: isSelected
                              ? KalaColors.burntOrange
                              : Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : KalaColors.charcoal,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? KalaColors.burntOrange
                                : KalaColors.softBeige,
                          ),
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
                          backgroundColor: isSelected
                              ? KalaColors.burntOrange
                              : Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : KalaColors.charcoal,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? KalaColors.burntOrange
                                : KalaColors.softBeige,
                          ),
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
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 0.85,
                    children: _openToOptions.map((opt) {
                      final title = opt['title'] as String;
                      final icon = opt['icon'] as IconData;
                      final isSelected = _selectedOpenTo.contains(title);
                      
                      // For short button display
                      String shortTitle = title;
                      if (title.contains('Opportunities')) {
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
                              color: isSelected
                                  ? KalaColors.burntOrange
                                  : KalaColors.softBeige,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                icon,
                                color: isSelected
                                    ? KalaColors.burntOrange
                                    : KalaColors.charcoal,
                                size: 24,
                              ),
                              const SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  shortTitle,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: isSelected
                                            ? KalaColors.burntOrange
                                            : KalaColors.charcoal,
                                        fontSize: 9,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  // Continue
                  ElevatedButton(
                    onPressed: () {
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
                    },
                    child: const Text('Continue'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
