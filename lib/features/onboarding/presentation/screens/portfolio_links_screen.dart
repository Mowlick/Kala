import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../onboarding_controller.dart';
import '../widgets/onboarding_progress_bar.dart';

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
                const SizedBox(height: 48),

                // Complete Button
                ElevatedButton(
                  onPressed: () {
                    controller.updatePortfolioLinks(
                      instagram: _instagramController.text.trim(),
                      youtube: _youtubeController.text.trim(),
                      spotify: _spotifyController.text.trim(),
                      website: _websiteController.text.trim(),
                    );
                    Navigator.pushNamed(context, '/success');
                  },
                  child: const Text('Complete Setup'),
                ),
              ],
            ),
          ),
        ),
      ),
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
          ),
        ),
      ],
    );
  }
}
