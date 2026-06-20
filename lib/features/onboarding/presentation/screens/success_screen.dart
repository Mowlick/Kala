import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/kala_colors.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Beautiful Circular Collage surrounding Logo
              Center(
                child: SizedBox(
                  width: 280,
                  height: 280,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Top Artist Circle
                      Positioned(
                        top: 0,
                        child: _buildCollageCircle(
                          imageUrl: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
                          size: 90,
                        ),
                      ),
                      // Left Artist Circle
                      Positioned(
                        left: 0,
                        child: _buildCollageCircle(
                          imageUrl: 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4',
                          size: 80,
                        ),
                      ),
                      // Right Artist Circle
                      Positioned(
                        right: 0,
                        child: _buildCollageCircle(
                          imageUrl: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
                          size: 85,
                        ),
                      ),
                      // Bottom Artist Circle
                      Positioned(
                        bottom: 0,
                        child: _buildCollageCircle(
                          imageUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
                          size: 80,
                        ),
                      ),
                      // Center KALĀ Monogram Circle
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: KalaColors.softBeige,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'kā',
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: KalaColors.charcoal,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),
              
              // Celebratory Titles
              Text(
                "You're all set! 🥳",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 12),
              Text(
                'Welcome to your creative home.\nExplore. Connect. Grow.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: KalaColors.mediumGrey,
                      height: 1.4,
                    ),
              ),
              
              const Spacer(),
              
              // CTA Buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: const Text('Explore Now'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: KalaColors.softBeige, width: 1.5),
                ),
                child: Text(
                  'I\'ll do this later',
                  style: TextStyle(color: KalaColors.mediumGrey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollageCircle({required String imageUrl, required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
