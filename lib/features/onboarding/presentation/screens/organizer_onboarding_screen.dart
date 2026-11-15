import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../../../../core/navigation/app_router.dart';
import '../onboarding_controller.dart';

class OrganizerOnboardingScreen extends StatefulWidget {
  const OrganizerOnboardingScreen({super.key});

  @override
  State<OrganizerOnboardingScreen> createState() =>
      _OrganizerOnboardingScreenState();
}

class _OrganizerOnboardingScreenState extends State<OrganizerOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final _formKey = GlobalKey<FormState>();

  // Page 1
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Page 2
  final TextEditingController _orgNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Page 3
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _designationController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _orgNameController.dispose();
    _cityController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _nextPage() async {
    if (_currentPage == 0 || _currentPage == 1 || _currentPage == 2) {
      if (!_formKey.currentState!.validate()) return;
    }

    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      final controller = context.read<OnboardingController>();
      final success = await controller.submitOrganizerOnboarding({
        'name': _nameController.text.trim(),
        'city': _cityController.text.trim(),
        'organization_name': _orgNameController.text.trim(),
        'designation': _designationController.text.trim(),
        'description': _descriptionController.text.trim(),
        'email': _emailController.text.trim(),
        'address': _addressController.text.trim(),
      });

      if (!mounted) return;
      if (success) {
        Navigator.pushReplacementNamed(context, AppRoutes.organizerHome);
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
                    _buildPage3(),
                    _buildPage4(),
                    _buildPage5(controller.isLoading),
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
              'Create Organizer Account',
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
    final stepTitles = [
      'Basic Info',
      'Organization',
      'Contact',
      'Verification',
      'Review',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(5, (index) {
          return Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: (_currentPage >= index)
                              ? const Color(0xFFEA580C)
                              : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: (_currentPage >= index)
                                ? const Color(0xFFEA580C)
                                : KalaColors.lightGrey,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontFamily: 'ZT_Nature',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: (_currentPage >= index)
                                  ? Colors.white
                                  : KalaColors.mediumGrey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        stepTitles[index],
                        style: TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 9,
                          fontWeight: _currentPage == index
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: _currentPage == index
                              ? KalaColors.charcoal
                              : KalaColors.mediumGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < 4)
                  Container(
                    margin: const EdgeInsets.only(top: 14),
                    height: 1,
                    width: 24,
                    color: _currentPage > index
                        ? const Color(0xFFEA580C)
                        : KalaColors.lightGrey,
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPage1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Basic Information', 'Tell us about yourself'),
          _buildTextField('Full Name *', 'Aarav Sharma', _nameController, true),
          _buildTextField(
            'Designation / Your Role *',
            'Creative Producer',
            _designationController,
            true,
          ),
          _buildTextField(
            'Location *',
            'Delhi, India',
            _locationController,
            true,
          ),
          _buildTextField(
            'Phone Number *',
            '+91 98765 43210',
            _phoneController,
            true,
          ),
          const SizedBox(height: 24),
          _buildImageUploader('Profile Photo / Logo *', isRound: true),
          const SizedBox(height: 32),
          _buildPrimaryButton('Continue', Icons.arrow_forward, false),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Organization Details',
            'Tell us about your organization',
          ),
          _buildTextField(
            'Organization / Company Name *',
            'Kala Studios',
            _orgNameController,
            true,
          ),
          _buildTextField('City *', 'Mumbai', _cityController, true),
          _buildTextAreaField(
            'Short Description *',
            'Kala Studios is a creative production house...',
            _descriptionController,
            true,
          ),
          const SizedBox(height: 32),
          _buildPrimaryButton('Continue', Icons.arrow_forward, false),
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
          _buildSectionHeader(
            'Contact & Team Info',
            'How can artists and talent reach you?',
          ),
          _buildTextField(
            'Official Email *',
            'contact@kalastudios.com',
            _emailController,
            true,
          ),
          _buildTextAreaField(
            'Office Address *',
            '201, Creative Hub...',
            _addressController,
            true,
          ),
          const SizedBox(height: 32),
          _buildPrimaryButton('Continue', Icons.arrow_forward, false),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPage4() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Verification & Documents',
            'Help us verify your organization',
          ),
          _buildImageUploader(
            'Organization Logo *',
            isRound: true,
            isEdit: true,
          ),
          const SizedBox(height: 24),
          _buildFileUploaded(
            'Business Registration Certificate *',
            'Kala_Studios_Registration.pdf',
            'PDF • 1.2MB',
          ),
          const SizedBox(height: 32),
          _buildPrimaryButton('Continue', Icons.arrow_forward, false),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPage5(bool isLoading) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Review & Submit',
            'Please review your details before creating your organizer account.',
          ),
          _buildReviewSection('Basic Information', [
            _nameController.text.isNotEmpty
                ? _nameController.text
                : 'Aarav Sharma',
            _designationController.text.isNotEmpty
                ? _designationController.text
                : 'Creative Producer',
            _locationController.text.isNotEmpty
                ? _locationController.text
                : 'Delhi, India',
          ]),
          _buildReviewSection('Organization Details', [
            _orgNameController.text.isNotEmpty
                ? _orgNameController.text
                : 'Kala Studios',
            _cityController.text.isNotEmpty ? _cityController.text : 'Mumbai',
          ]),
          _buildReviewSection('Contact Details', [
            _emailController.text.isNotEmpty
                ? _emailController.text
                : 'contact@kalastudios.com',
            _phoneController.text.isNotEmpty
                ? _phoneController.text
                : '+91 98765 43210',
          ]),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFEDD5)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.shield_outlined, color: Color(0xFFEA580C), size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your information is secure',
                        style: TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: KalaColors.charcoal,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Your documents and data are encrypted and used only for verification purposes.',
                        style: TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 10,
                          color: KalaColors.mediumGrey,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildPrimaryButton(
            'Create Organizer Account',
            Icons.check_circle_outline,
            isLoading,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: KalaColors.charcoal,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 13,
            color: KalaColors.mediumGrey,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller,
    bool required,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: required
              ? (v) => v == null || v.isEmpty ? 'Required' : null
              : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: KalaColors.mediumGrey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: KalaColors.lightGrey),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTextAreaField(
    String label,
    String hint,
    TextEditingController controller,
    bool required,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: 3,
          validator: required
              ? (v) => v == null || v.isEmpty ? 'Required' : null
              : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 13,
              color: KalaColors.mediumGrey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: KalaColors.lightGrey),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLabel(String label) {
    final parts = label.split('*');
    if (parts.length > 1) {
      return RichText(
        text: TextSpan(
          style: const TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: KalaColors.charcoal,
          ),
          children: [
            TextSpan(text: parts[0]),
            const TextSpan(
              text: '*',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      );
    }
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'ZT_Nature',
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: KalaColors.charcoal,
      ),
    );
  }

  Widget _buildImageUploader(
    String label, {
    bool isRound = false,
    bool isEdit = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 16),
        Center(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: KalaColors.charcoal,
                      shape: isRound ? BoxShape.circle : BoxShape.rectangle,
                      borderRadius: isRound ? null : BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'KALĀ\nSTUDIOS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFEA580C),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      isEdit ? Icons.edit : Icons.camera_alt,
                      size: 14,
                      color: const Color(0xFFEA580C),
                    ),
                  ),
                ],
              ),
              if (!isEdit) ...[
                const SizedBox(height: 12),
                const Text(
                  'JPG, PNG up to 5MB',
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 10,
                    color: KalaColors.mediumGrey,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFileUploaded(String label, String fileName, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            border: Border.all(color: KalaColors.lightGrey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.insert_drive_file_outlined,
                color: KalaColors.mediumGrey,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: const TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: KalaColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 10,
                        color: KalaColors.mediumGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.close, color: KalaColors.mediumGrey, size: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewSection(String title, List<String> details) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: KalaColors.lightGrey)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.charcoal,
                ),
              ),
              Text(
                'Edit',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEA580C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...details.map(
            (detail) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                detail,
                style: const TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 11,
                  color: KalaColors.charcoal,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
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
