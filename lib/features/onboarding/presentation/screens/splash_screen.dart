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
      backgroundColor: KalaColors.ivory,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 1000) {
              return _buildLaptopLayout(context);
            }
            return _buildMobileLayout(context);
          },
        ),
      ),
    );
  }

  Widget _buildLaptopLayout(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              // Left half
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 64.0, top: 40.0, right: 40.0, bottom: 40.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'kalā',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 36, // Reduced from 48
                            fontWeight: FontWeight.bold,
                            color: KalaColors.charcoal,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 32), // Reduced from 64
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: 40, // Reduced from 64
                                  height: 1.2,
                                  color: KalaColors.charcoal,
                                ),
                            children: const [
                              TextSpan(text: "Where India's\n"),
                              TextSpan(text: "emerging artists\n"),
                              TextSpan(text: "build "),
                              TextSpan(
                                text: "careers",
                                style: TextStyle(color: KalaColors.burntOrange),
                              ),
                              TextSpan(text: ",\n"),
                              TextSpan(text: "not just followers."),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: 40,
                          height: 2,
                          color: KalaColors.burntOrange,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: 400,
                          child: Text(
                            'A platform to showcase your talent,\ndiscover real opportunities, and\ncollaborate with creative minds.',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: KalaColors.mediumGrey,
                                  height: 1.5,
                                  fontSize: 16, // Reduced from 18
                                ),
                          ),
                        ),
                        const SizedBox(height: 32), // Reduced from 48
                        SizedBox(
                          width: 240, // Reduced from 300
                          height: 48, // Reduced from 56
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<OnboardingController>().resetSteps();
                              Navigator.pushNamed(context, '/role-select');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: KalaColors.burntOrange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Let's Begin",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16), // Reduced from 24
                        Row(
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
                                'Log In',
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
              ),
              // Right half
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0, right: 64.0, bottom: 40.0, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: KalaColors.charcoal,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/home');
                            },
                            child: Text(
                              'Log In',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: KalaColors.burntOrange,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: KalaColors.softBeige, width: 1.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/home');
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                foregroundColor: KalaColors.charcoal,
                              ),
                              child: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildArchPanel(
                                      context,
                                      title: 'Singer',
                                      imageUrl: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
                                      topLeft: 24,
                                      topRight: 24,
                                      bottomLeft: 12,
                                      bottomRight: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildArchPanel(
                                      context,
                                      title: 'Photographer',
                                      imageUrl: 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4',
                                      topLeft: 24,
                                      topRight: 24,
                                      bottomLeft: 12,
                                      bottomRight: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildNeonPanel(
                                      context,
                                      title: 'Music Producer',
                                      imageUrl: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
                                      topLeft: 12,
                                      topRight: 12,
                                      bottomLeft: 24,
                                      bottomRight: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildArchPanel(
                                      context,
                                      title: 'Actor',
                                      imageUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
                                      topLeft: 12,
                                      topRight: 12,
                                      bottomLeft: 24,
                                      bottomRight: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Bottom Details Banner
        Container(
          color: KalaColors.softBeige.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFeatureItem(
                context,
                icon: Icons.people_outline,
                title: 'Showcase Your Talent',
                description: 'Build a stunning portfolio to\nshow the world what you do best.',
              ),
              _buildFeatureItem(
                context,
                icon: Icons.business_center_outlined,
                title: 'Discover Opportunities',
                description: 'Find auditions, gigs, internships\nand projects that match your skills.',
              ),
              _buildFeatureItem(
                context,
                icon: Icons.handshake_outlined,
                title: 'Collaborate & Connect',
                description: 'Connect with artists, creators\nand professionals across India.',
              ),
              _buildFeatureItem(
                context,
                icon: Icons.trending_up,
                title: 'Grow Your Career',
                description: 'Learn, collaborate and grow\nyour journey in the creative world.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        // Top Bar with Logo and Skip
        Padding(
          padding: const EdgeInsets.only(left: 32.0, top: 16.0, right: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'kalā',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.charcoal,
                  letterSpacing: -1,
                ),
              ),
              TextButton(
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
            ],
          ),
        ),
        
        // Scrollable Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 32,
                          height: 1,
                          color: KalaColors.charcoal,
                        ),
                    children: const [
                      TextSpan(text: "Where India's\n"),
                      TextSpan(text: "emerging artists\n"),
                      TextSpan(text: "build "),
                      TextSpan(
                        text: "careers",
                        style: TextStyle(color: KalaColors.burntOrange),
                      ),
                      TextSpan(text: ",\n"),
                      TextSpan(text: "not just followers."),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 40,
                  height: 2,
                  color: KalaColors.burntOrange,
                ),
                const SizedBox(height: 16),
                Text(
                  'A platform to showcase your talent, discover real opportunities, and collaborate with creative minds.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: KalaColors.mediumGrey,
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: 32),
                
                // Image Collage (4 photos)
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                  children: [
                    _buildArchPanel(
                      context,
                      title: 'Singer',
                      imageUrl: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
                      topLeft: 24,
                      topRight: 24,
                      bottomLeft: 12,
                      bottomRight: 12,
                    ),
                    _buildArchPanel(
                      context,
                      title: 'Photographer',
                      imageUrl: 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4',
                      topLeft: 24,
                      topRight: 24,
                      bottomLeft: 12,
                      bottomRight: 12,
                    ),
                    _buildNeonPanel(
                      context,
                      title: 'Music Producer',
                      imageUrl: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
                      topLeft: 12,
                      topRight: 12,
                      bottomLeft: 24,
                      bottomRight: 24,
                    ),
                    _buildArchPanel(
                      context,
                      title: 'Actor',
                      imageUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
                      topLeft: 12,
                      topRight: 12,
                      bottomLeft: 24,
                      bottomRight: 24,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // Let's Begin Button
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<OnboardingController>().resetSteps();
                    Navigator.pushNamed(context, '/role-select');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KalaColors.burntOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Let's Begin",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: KalaColors.mediumGrey,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: Text(
                      'Log In',
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
      ],
    );
  }

  Widget _buildArchPanel(
    BuildContext context, {
    required String title,
    required String imageUrl,
    required double topLeft,
    required double topRight,
    required double bottomLeft,
    required double bottomRight,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft),
          topRight: Radius.circular(topRight),
          bottomLeft: Radius.circular(bottomLeft),  
          bottomRight: Radius.circular(bottomRight),
        ),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildNeonPanel(
    BuildContext context, {
    required String title,
    required String imageUrl,
    required double topLeft,
    required double topRight,
    required double bottomLeft,
    required double bottomRight,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft),
          topRight: Radius.circular(topRight),
          bottomLeft: Radius.circular(bottomLeft),
          bottomRight: Radius.circular(bottomRight),
        ),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topLeft),
            topRight: Radius.circular(topRight),
            bottomLeft: Radius.circular(bottomLeft),
            bottomRight: Radius.circular(bottomRight),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.7),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, {required IconData icon, required String title, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: KalaColors.burntOrange.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: KalaColors.burntOrange, size: 24),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: KalaColors.mediumGrey,
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
