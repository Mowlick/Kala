import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../../../../core/navigation/app_router.dart';
import '../onboarding_controller.dart';

class StudentOnboardingScreen extends StatefulWidget {
  const StudentOnboardingScreen({super.key});

  @override
  State<StudentOnboardingScreen> createState() =>
      _StudentOnboardingScreenState();
}

class _StudentOnboardingScreenState extends State<StudentOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  String _experienceLevel = 'Intermediate';
  String _yearsOfExperience = '2-4 Years';

  // Selected Skills state for Page 2
  final List<String> _selectedSkills = ['Singing', 'Dance'];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _nextPage() async {
    if (_currentPage == 0) {
      if (!_formKey.currentState!.validate()) return;
    }

    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Final submission
      final controller = context.read<OnboardingController>();
      controller.updateDetails(
        name: _nameController.text.trim(),
        city: _locationController.text.trim(),
        experienceLevel: _experienceLevel,
        primarySkills: _selectedSkills,
        languages: [],
        openTo: [],
      );
      controller.model.goals = [_bioController.text.trim()];

      final success = await controller.submitStudentOnboarding();
      if (!mounted) return;
      if (success) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.errorMessage ?? 'Submission failed'),
          ),
        );
      }
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OnboardingController>();
    return Scaffold(
      backgroundColor: KalaColors.ivory,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildStepper(),
              const SizedBox(height: 24),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    _buildPage1(),
                    _buildPage2(),
                    _buildPage3(controller.isLoading),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: KalaColors.charcoal),
            onPressed: _previousPage,
          ),
          const Expanded(
            child: Text(
              'Create Student Account',
              style: TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: KalaColors.charcoal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepItem(0, 'Basic Info'),
          Expanded(child: _buildStepLine(0)),
          _buildStepItem(1, 'Profile'),
          Expanded(child: _buildStepLine(1)),
          _buildStepItem(2, 'Verification'),
        ],
      ),
    );
  }

  Widget _buildStepItem(int stepIndex, String title) {
    final isCompleted = _currentPage > stepIndex;
    final isActive = _currentPage == stepIndex;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: (isActive || isCompleted)
                ? const Color(0xFFEA580C)
                : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: (isActive || isCompleted)
                  ? const Color(0xFFEA580C)
                  : KalaColors.lightGrey,
              width: 1.5,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : Text(
                    '${stepIndex + 1}',
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.white : KalaColors.mediumGrey,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? KalaColors.charcoal : KalaColors.mediumGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int stepIndex) {
    final isCompleted = _currentPage > stepIndex;
    return Container(
      margin: const EdgeInsets.only(top: 15),
      height: 2,
      color: isCompleted ? const Color(0xFFEA580C) : KalaColors.lightGrey,
    );
  }

  Widget _buildPage1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Basic Information',
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: KalaColors.charcoal,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tell us more about yourself',
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 14,
              color: KalaColors.mediumGrey,
            ),
          ),
          const SizedBox(height: 32),
          _buildTextField(
            controller: _nameController,
            icon: Icons.person_outline,
            label: 'Full Name *',
            hint: 'Aarav Sharma',
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _dobController,
            icon: Icons.calendar_today_outlined,
            label: 'Date of Birth *',
            hint: 'DD MMM YYYY',
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _locationController,
            icon: Icons.location_on_outlined,
            label: 'Location *',
            hint: 'Delhi, India',
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _phoneController,
            icon: Icons.phone_outlined,
            label: 'Phone Number',
            hint: '+91 98765 43210',
          ),
          const SizedBox(height: 48),
          _buildPrimaryButton('Continue', Icons.arrow_forward, false),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    final allSkills = [
      'Singing',
      'Dance',
      'Acting',
      'Instrumentalist',
      'Beatboxer',
      'Other',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profile Details',
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: KalaColors.charcoal,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This helps organizers know you better',
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 14,
              color: KalaColors.mediumGrey,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text(
                'Profile Photo',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.charcoal,
                ),
              ),
              const Spacer(),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEA580C),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 24),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: KalaColors.charcoal,
              ),
              children: [
                TextSpan(text: 'Category / Skills '),
                TextSpan(
                  text: '(Select up to 3)',
                  style: TextStyle(
                    color: KalaColors.mediumGrey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 12,
            children: allSkills.map((skill) {
              final isSelected = _selectedSkills.contains(skill);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedSkills.remove(skill);
                    } else if (_selectedSkills.length < 3) {
                      _selectedSkills.add(skill);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFFF7ED) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFEA580C)
                          : KalaColors.lightGrey,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        skill,
                        style: TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFFEA580C)
                              : KalaColors.charcoal,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: Color(0xFFEA580C),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            'Experience Level',
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: KalaColors.charcoal,
            ),
          ),
          DropdownButtonFormField<String>(
            initialValue: _experienceLevel,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            items: [
              'Beginner',
              'Intermediate',
              'Expert',
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => setState(() => _experienceLevel = v!),
          ),
          const SizedBox(height: 16),
          const Text(
            'Years of Experience',
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: KalaColors.charcoal,
            ),
          ),
          DropdownButtonFormField<String>(
            initialValue: _yearsOfExperience,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            items: [
              '0-1 Years',
              '2-4 Years',
              '5+ Years',
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => setState(() => _yearsOfExperience = v!),
          ),
          const SizedBox(height: 24),
          const Text(
            'Bio',
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: KalaColors.charcoal,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _bioController,
            maxLines: 3,
            maxLength: 200,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Passionate singer and songwriter...',
            ),
          ),
          const SizedBox(height: 32),
          _buildPrimaryButton('Continue', Icons.arrow_forward, false),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPage3(bool isLoading) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Verification',
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: KalaColors.charcoal,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Help us verify your identity',
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 14,
              color: KalaColors.mediumGrey,
            ),
          ),
          const SizedBox(height: 24),
          _buildUploadBox(
            title: 'Government ID Proof',
            label: 'Upload ID Proof',
            subtitle: 'Aadhaar Card, PAN Card,\nPassport or Driving License',
            icon: Icons.badge_outlined,
          ),
          const SizedBox(height: 24),
          _buildUploadBox(
            title: 'Portfolio / Work Sample',
            isOptional: true,
            label: 'Upload Portfolio',
            subtitle: 'Add links or files (Images,\nVideos, Audio)',
            icon: Icons.photo_library_outlined,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              const Icon(Icons.check_box, color: Color(0xFFEA580C)),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 12,
                      color: KalaColors.charcoal,
                    ),
                    children: [
                      TextSpan(text: 'I agree to the '),
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(
                          color: Color(0xFFEA580C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ' and\n'),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: Color(0xFFEA580C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildPrimaryButton(
            'Create Account',
            Icons.check_circle_outline,
            isLoading,
          ),
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 14, color: KalaColors.mediumGrey),
              SizedBox(width: 8),
              Text(
                'Your data is secure with us',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 12,
                  color: KalaColors.mediumGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 10,
            color: KalaColors.mediumGrey,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: KalaColors.mediumGrey, size: 22),
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: KalaColors.mediumGrey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: KalaColors.lightGrey),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadBox({
    required String title,
    required String label,
    required String subtitle,
    required IconData icon,
    bool isOptional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: KalaColors.charcoal,
            ),
            children: [
              TextSpan(text: title),
              if (isOptional)
                const TextSpan(
                  text: ' (Optional)',
                  style: TextStyle(
                    color: KalaColors.mediumGrey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: KalaColors.lightGrey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: KalaColors.mediumGrey),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: KalaColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 11,
                        color: KalaColors.mediumGrey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.file_upload_outlined,
                color: KalaColors.charcoal,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton(String text, IconData icon, bool isLoading) {
    return GestureDetector(
      onTap: isLoading ? null : _nextPage,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isLoading ? KalaColors.mediumGrey : const Color(0xFFEA580C),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
            if (!isLoading) ...[
              const SizedBox(width: 8),
              Icon(icon, color: Colors.white, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
