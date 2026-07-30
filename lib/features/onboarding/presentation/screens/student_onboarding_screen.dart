import 'package:flutter/material.dart';

import '../../../../core/theme/kala_colors.dart';

class StudentOnboardingScreen extends StatefulWidget {
  const StudentOnboardingScreen({super.key});

  @override
  State<StudentOnboardingScreen> createState() => _StudentOnboardingScreenState();
}

class _StudentOnboardingScreenState extends State<StudentOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Selected Skills state for Page 2
  final List<String> _selectedSkills = ['Singing', 'Dance'];

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/home');
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
    return Scaffold(
      backgroundColor: KalaColors.ivory, // Standard white background for forms
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildStepper(),
            const SizedBox(height: 24),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Disable swipe
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildPage1(),
                  _buildPage2(),
                  _buildPage3(),
                ],
              ),
            ),
          ],
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
          Expanded(
            child: Text(
              'Create Account',
              style: TextStyle(fontFamily: 'ZT_Nature', 
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: KalaColors.charcoal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // To balance the back button
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
            color: (isActive || isCompleted) ? const Color(0xFFEA580C) : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: (isActive || isCompleted) ? const Color(0xFFEA580C) : KalaColors.lightGrey,
              width: 1.5,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : Text(
                    '${stepIndex + 1}',
                    style: TextStyle(fontFamily: 'ZT_Nature', 
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
          style: TextStyle(fontFamily: 'ZT_Nature', 
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
          Text(
            'Basic Information',
            style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 20, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
          ),
          const SizedBox(height: 8),
          Text(
            'Tell us more about yourself',
            style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 14, color: KalaColors.mediumGrey),
          ),
          const SizedBox(height: 32),
          _buildInputField(
            icon: Icons.person_outline,
            label: 'Full Name',
            value: 'Aarav Sharma',
          ),
          const SizedBox(height: 16),
          _buildInputField(
            icon: Icons.calendar_today_outlined,
            label: 'Date of Birth',
            value: '22 May 2003',
            isDropdown: true,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: 'Delhi, India',
            isDropdown: true,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            icon: Icons.phone_outlined,
            label: 'Phone Number',
            value: '+91 98765 43210',
          ),
          const SizedBox(height: 48),
          _buildPrimaryButton('Continue', Icons.arrow_forward),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    final allSkills = ['Singing', 'Dance', 'Acting', 'Instrumentalist', 'Beatboxer', 'Other'];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Details',
            style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 20, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
          ),
          const SizedBox(height: 8),
          Text(
            'This helps organizers know you better',
            style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 14, color: KalaColors.mediumGrey),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                'Profile Photo',
                style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
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
                        image: NetworkImage('https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200'),
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
                    child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 24),
          RichText(
            text: TextSpan(
              style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
              children: [
                const TextSpan(text: 'Category / Skills '),
                TextSpan(
                  text: '(Select up to 3)',
                  style: TextStyle(color: KalaColors.mediumGrey, fontWeight: FontWeight.normal),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFFF7ED) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFEA580C) : KalaColors.lightGrey,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        skill,
                        style: TextStyle(fontFamily: 'ZT_Nature', 
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? const Color(0xFFEA580C) : KalaColors.charcoal,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.check_circle, size: 16, color: Color(0xFFEA580C)),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text('Experience Level', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: KalaColors.lightGrey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Intermediate', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, color: KalaColors.charcoal)),
                      const Icon(Icons.keyboard_arrow_down, color: KalaColors.mediumGrey, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text('Years of Experience', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: KalaColors.lightGrey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('2-4 Years', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, color: KalaColors.charcoal)),
                      const Icon(Icons.keyboard_arrow_down, color: KalaColors.mediumGrey, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Bio',
            style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: KalaColors.lightGrey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Text(
                  'Passionate singer and songwriter.\nPerformed at various college events\nand music festivals.',
                  style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, color: KalaColors.charcoal, height: 1.5),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Text(
                    '92/200',
                    style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, color: KalaColors.mediumGrey),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildPrimaryButton('Continue', Icons.arrow_forward),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPage3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verification',
            style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 20, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
          ),
          const SizedBox(height: 8),
          Text(
            'Help us verify your identity',
            style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 14, color: KalaColors.mediumGrey),
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
                  text: TextSpan(
                    style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, color: KalaColors.charcoal),
                    children: [
                      const TextSpan(text: 'I agree to the '),
                      const TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(color: Color(0xFFEA580C), fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ' and\n'),
                      const TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(color: Color(0xFFEA580C), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildPrimaryButton('Create Account', Icons.check_circle_outline),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 14, color: KalaColors.mediumGrey),
              const SizedBox(width: 8),
              Text(
                'Your data is secure with us',
                style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, color: KalaColors.mediumGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({required IconData icon, required String label, required String value, bool isDropdown = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: KalaColors.lightGrey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: KalaColors.mediumGrey, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, color: KalaColors.mediumGrey),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 14, fontWeight: FontWeight.w600, color: KalaColors.charcoal),
                ),
              ],
            ),
          ),
          if (isDropdown)
            const Icon(Icons.keyboard_arrow_down, color: KalaColors.mediumGrey),
        ],
      ),
    );
  }

  Widget _buildUploadBox({required String title, required String label, required String subtitle, required IconData icon, bool isOptional = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
            children: [
              TextSpan(text: title),
              if (isOptional)
                TextSpan(
                  text: ' (Optional)',
                  style: TextStyle(color: KalaColors.mediumGrey, fontWeight: FontWeight.normal),
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
                      style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 13, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 11, color: KalaColors.mediumGrey, height: 1.4),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.file_upload_outlined, color: KalaColors.charcoal),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton(String text, IconData icon) {
    return GestureDetector(
      onTap: _nextPage,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFEA580C),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(fontFamily: 'ZT_Nature', 
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
