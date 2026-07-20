import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/kala_colors.dart';

class OrganizerOnboardingScreen extends StatefulWidget {
  const OrganizerOnboardingScreen({super.key});

  @override
  State<OrganizerOnboardingScreen> createState() => _OrganizerOnboardingScreenState();
}

class _OrganizerOnboardingScreenState extends State<OrganizerOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/organizer-home');
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
      backgroundColor: Colors.white,
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
                  _buildPage5(),
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
              'Create Organizer Account',
              style: GoogleFonts.inter(
                fontSize: 16,
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
    final stepTitles = ['Basic Info', 'Organization', 'Contact', 'Verification', 'Review'];
    
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
                          color: (_currentPage >= index) ? const Color(0xFFEA580C) : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: (_currentPage >= index) ? const Color(0xFFEA580C) : KalaColors.lightGrey,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: (_currentPage >= index) ? Colors.white : KalaColors.mediumGrey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        stepTitles[index],
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: _currentPage == index ? FontWeight.bold : FontWeight.w500,
                          color: _currentPage == index ? KalaColors.charcoal : KalaColors.mediumGrey,
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
                    color: _currentPage > index ? const Color(0xFFEA580C) : KalaColors.lightGrey,
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
          _buildTextField('Full Name *', 'Aarav Sharma'),
          _buildTextField('Designation / Your Role *', 'Creative Producer'),
          _buildDropdownField('Date of Birth *', '22 May 1992'),
          _buildDropdownField('Location *', 'Delhi, India'),
          _buildTextField('Phone Number *', '+91 98765 43210'),
          const SizedBox(height: 24),
          _buildImageUploader('Profile Photo / Logo *', isRound: true),
          const SizedBox(height: 32),
          _buildPrimaryButton('Continue', Icons.arrow_forward),
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
          _buildSectionHeader('Organization Details', 'Tell us about your organization'),
          _buildTextField('Organization / Company Name *', 'Kala Studios'),
          _buildDropdownField('Organization Type *', 'Production House'),
          _buildDropdownField('Category / Industry *', 'Film & Television'),
          _buildTextField('Established Year (Optional)', '2020'),
          _buildTextField('Website / Social Link (Optional)', 'www.kalastudios.com'),
          _buildTextField('City *', 'Mumbai'),
          _buildTextAreaField('Short Description *', 'Kala Studios is a creative production house focused on meaningful storytelling across film, digital and branded content.', '112/250'),
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
          _buildSectionHeader('Contact & Team Info', 'How can artists and talent reach you?'),
          _buildTextField('Official Email *', 'contact@kalastudios.com'),
          _buildTextField('Alternate Email (Optional)', 'info@kalastudios.com'),
          _buildTextAreaField('Office Address *', '201, Creative Hub, Andheri West, Mumbai, Maharashtra 400053', ''),
          _buildDropdownField('Team Size', '11 - 50'),
          const SizedBox(height: 16),
          Text(
            'Primary Contact Person (If different)',
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
          ),
          const SizedBox(height: 12),
          _buildTextField('Name', 'Megha Verma'),
          _buildTextField('Phone Number', '+91 91234 56789'),
          const SizedBox(height: 32),
          _buildPrimaryButton('Continue', Icons.arrow_forward),
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
          _buildSectionHeader('Verification & Documents', 'Help us verify your organization'),
          _buildImageUploader('Organization Logo *', isRound: true, isEdit: true),
          const SizedBox(height: 24),
          _buildFileUploaded('Business Registration Certificate *', 'Kala_Studios_Registration.pdf', 'PDF • 1.2MB'),
          const SizedBox(height: 16),
          _buildFileUploaded('Tax / GST Certificate (Optional)', 'GST_Certificate.pdf', 'PDF • 1.1MB'),
          const SizedBox(height: 24),
          Text(
            'Portfolio / Previous Work (Optional)',
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildPortfolioThumbnail('https://images.unsplash.com/photo-1485846234645-a62644f84728?auto=format&fit=crop&q=80&w=150', hasPlay: true),
              const SizedBox(width: 8),
              _buildPortfolioThumbnail('https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&q=80&w=150'),
              const SizedBox(width: 8),
              _buildPortfolioThumbnail('https://images.unsplash.com/photo-1547153760-18fc86324498?auto=format&fit=crop&q=80&w=150'),
              const SizedBox(width: 8),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: KalaColors.lightGrey, style: BorderStyle.solid),
                ),
                child: const Icon(Icons.file_upload_outlined, color: KalaColors.mediumGrey),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTextAreaField('Anything else you\'d like to share? (Optional)', 'Awards, recognitions, notable clients, or additional information.', '0/200', isHint: true),
          const SizedBox(height: 32),
          _buildPrimaryButton('Continue', Icons.arrow_forward),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPage5() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Review & Submit', 'Please review your details before creating your organizer account.'),
          _buildReviewSection('Basic Information', [
            'Aarav Sharma',
            'Creative Producer',
            'Delhi, India'
          ]),
          _buildReviewSection('Organization Details', [
            'Kala Studios',
            'Production House • Film & Television',
            'Established in 2020 • Mumbai'
          ]),
          _buildReviewSection('Contact Details', [
            'contact@kalastudios.com',
            '+91 98765 43210'
          ]),
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: KalaColors.lightGrey)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Verification Documents', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                    const SizedBox(height: 4),
                    Text('2 Documents Uploaded', style: GoogleFonts.inter(fontSize: 11, color: KalaColors.mediumGrey)),
                  ],
                ),
                const Icon(Icons.check_circle_outline, color: KalaColors.accentGreen),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFEDD5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.shield_outlined, color: Color(0xFFEA580C), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your information is secure', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                      const SizedBox(height: 4),
                      Text('Your documents and data are encrypted and used only for verification purposes.', style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey, height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildPrimaryButton('Create Organizer Account', Icons.check_circle_outline),
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
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.inter(fontSize: 13, color: KalaColors.mediumGrey),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTextField(String label, String value) {
    return _buildFieldContainer(
      label,
      Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: KalaColors.charcoal)),
    );
  }

  Widget _buildDropdownField(String label, String value) {
    return _buildFieldContainer(
      label,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: KalaColors.charcoal)),
          const Icon(Icons.keyboard_arrow_down, color: KalaColors.mediumGrey, size: 20),
        ],
      ),
    );
  }

  Widget _buildTextAreaField(String label, String value, String charCount, {bool isHint = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: KalaColors.lightGrey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.inter(fontSize: 13, fontWeight: isHint ? FontWeight.normal : FontWeight.w600, color: isHint ? KalaColors.mediumGrey : KalaColors.charcoal, height: 1.5),
              ),
              if (charCount.isNotEmpty) ...[
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(charCount, style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey)),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFieldContainer(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: KalaColors.lightGrey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: child,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLabel(String label) {
    // Make asterisks red if they exist
    final parts = label.split('*');
    if (parts.length > 1) {
      return RichText(
        text: TextSpan(
          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
          children: [
            TextSpan(text: parts[0]),
            const TextSpan(text: '*', style: TextStyle(color: Colors.red)),
          ],
        ),
      );
    }
    return Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: KalaColors.charcoal));
  }

  Widget _buildImageUploader(String label, {bool isRound = false, bool isEdit = false}) {
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
                    child: Center(
                      child: Text(
                        'KALĀ\nSTUDIOS',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cormorantGaramond(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFEA580C), width: 1.5),
                    ),
                    child: Icon(isEdit ? Icons.edit : Icons.camera_alt, size: 14, color: const Color(0xFFEA580C)),
                  ),
                ],
              ),
              if (!isEdit) ...[
                const SizedBox(height: 12),
                Text('JPG, PNG up to 5MB', style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey)),
              ]
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
              const Icon(Icons.insert_drive_file_outlined, color: KalaColors.mediumGrey),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fileName, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey)),
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

  Widget _buildPortfolioThumbnail(String url, {bool hasPlay = false}) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
      child: hasPlay
          ? Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5), shape: BoxShape.circle),
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 16),
              ),
            )
          : null,
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
              Text(title, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
              Text('Edit', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFFEA580C))),
            ],
          ),
          const SizedBox(height: 12),
          ...details.map((detail) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(detail, style: GoogleFonts.inter(fontSize: 11, color: KalaColors.charcoal, height: 1.5)),
          )),
        ],
      ),
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
              style: GoogleFonts.inter(
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
