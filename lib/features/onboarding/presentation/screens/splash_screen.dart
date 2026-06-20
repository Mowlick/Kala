import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../onboarding_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Skip button top right
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: Text(
                    'Skip',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: KalaColors.mediumGrey,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Brand logo
              Center(
                child: Text(
                  'kalā',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: KalaColors.charcoal,
                    letterSpacing: -1,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Heading
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.displayMedium,
                  children: const [
                    TextSpan(text: "Where India's\nemerging artists\nbuild "),
                    TextSpan(
                      text: "careers",
                      style: TextStyle(color: KalaColors.burntOrange),
                    ),
                    TextSpan(text: ",\nnot just followers."),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Subtitle
              Text(
                'A platform to showcase your talent, discover real opportunities, and collaborate with creative minds.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: KalaColors.mediumGrey,
                      height: 1.4,
                    ),
              ),
              const SizedBox(height: 32),
              // Artistic Quad Arch Collage Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildArchPanel(
                      context,
                      title: 'Singer',
                      imageUrl: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
                      topLeft: 50,
                      topRight: 50,
                    ),
                    _buildArchPanel(
                      context,
                      title: 'Filmmaker',
                      imageUrl: 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4',
                      topLeft: 50,
                      topRight: 50,
                    ),
                    _buildArchPanel(
                      context,
                      title: 'Dancer',
                      imageUrl: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
                      bottomLeft: 50,
                      bottomRight: 50,
                    ),
                    _buildArchPanel(
                      context,
                      title: 'Musician',
                      imageUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
                      bottomLeft: 50,
                      bottomRight: 50,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Primary CTA Button
              ElevatedButton(
                onPressed: () {
                  context.read<OnboardingController>().resetSteps();
                  Navigator.pushNamed(context, '/role-select');
                },
                child: const Text("Let's Begin"),
              ),
              const SizedBox(height: 16),
              // Footer link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: KalaColors.mediumGrey,
                        ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: Text(
                      'Log in',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: KalaColors.burntOrange,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArchPanel(
    BuildContext context, {
    required String title,
    required String imageUrl,
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: KalaColors.softBeige,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft),
          topRight: Radius.circular(topRight),
          bottomLeft: Radius.circular(bottomLeft),
          bottomRight: Radius.circular(bottomRight),
        ),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.2),
            BlendMode.darken,
          ),
        ),
      ),
    );
  }
}
