import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../onboarding_controller.dart';
import '../widgets/onboarding_progress_bar.dart';
import '../widgets/onboarding_laptop_layout.dart';

class PortfolioLinksScreen extends StatefulWidget {
  const PortfolioLinksScreen({super.key});

  @override
  State<PortfolioLinksScreen> createState() => _PortfolioLinksScreenState();
}

class _PortfolioLinksScreenState extends State<PortfolioLinksScreen> {
  final _instagramController = TextEditingController(text: 'instagram.com/aarav.mehta');
  final _youtubeController = TextEditingController(text: 'youtube.com/@aaravmehta');
  final _spotifyController = TextEditingController(text: 'open.spotify.com/artist/aarav');
  final _websiteController = TextEditingController(text: 'behance.net/aaravmehta');

  @override
  void dispose() {
    _instagramController.dispose();
    _youtubeController.dispose();
    _spotifyController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _onComplete(OnboardingController controller) {
    controller.updatePortfolioLinks(
      instagram: _instagramController.text.trim(),
      youtube: _youtubeController.text.trim(),
      spotify: _spotifyController.text.trim(),
      website: _websiteController.text.trim(),
    );
    Navigator.pushNamed(context, '/success');
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
      title: 'Almost there!',
      subtitle: 'Add your portfolio links to help\npeople discover your work.',
      stepNumber: 4,
      illustration: Image.asset('assets/images/onboarding/illustration_4.png'),
      onBackPressed: () => controller.prevStep(context),
      continueButton: ElevatedButton(
        onPressed: () => _onComplete(controller),
        style: ElevatedButton.styleFrom(
          backgroundColor: KalaColors.burntOrange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 0,
        ),
        child: const Text('Complete Setup', style: TextStyle(fontWeight: FontWeight.bold)),
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
                      const OnboardingProgressBar(currentStep: 4),
                      const SizedBox(height: 32),
                      Text(
                        'Almost there!',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add your portfolio links to help people discover your work.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: KalaColors.mediumGrey,
                            ),
                      ),
                      const SizedBox(height: 28),
                      _buildFormContent(context),
                      const SizedBox(height: 48),
                      ElevatedButton(
                        onPressed: () => _onComplete(controller),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Complete Setup'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Instagram Input
        _buildSocialField(
          context,
          label: 'Instagram (Optional)',
          hintText: 'instagram.com/username',
          controller: _instagramController,
          icon: Icons.camera_alt_outlined,
          iconColor: Colors.pink,
        ),
        const SizedBox(height: 20),

        // YouTube Input
        _buildSocialField(
          context,
          label: 'YouTube (Optional)',
          hintText: 'youtube.com/@channel',
          controller: _youtubeController,
          icon: Icons.play_circle_outline,
          iconColor: Colors.red,
        ),
        const SizedBox(height: 20),

        // Spotify Input
        _buildSocialField(
          context,
          label: 'Spotify / SoundCloud (Optional)',
          hintText: 'open.spotify.com/artist/...',
          controller: _spotifyController,
          icon: Icons.music_note_outlined,
          iconColor: Colors.green,
        ),
        const SizedBox(height: 20),

        // Website Input
        _buildSocialField(
          context,
          label: 'Website / Other Link (Optional)',
          hintText: 'portfolio.com/username',
          controller: _websiteController,
          icon: Icons.link_outlined,
          iconColor: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildSocialField(
    BuildContext context, {
    required String label,
    required String hintText,
    required TextEditingController controller,
    required IconData icon,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: iconColor),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: KalaColors.softBeige),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: KalaColors.softBeige),
            ),
          ),
        ),
      ],
    );
  }
}
