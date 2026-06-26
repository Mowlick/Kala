import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/kala_colors.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

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
    return Row(
      children: [
        // Left side with Collage
        Expanded(
          flex: 1,
          child: Container(
            color: KalaColors.softBeige.withValues(alpha: 0.3),
            child: Center(
              child: _buildCollage(size: 600, centerTextSize: 72),
            ),
          ),
        ),
        // Right side with Text & Buttons
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You're all set! 🥳",
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: KalaColors.charcoal,
                      ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome to your creative home.\nExplore. Connect. Grow.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: KalaColors.mediumGrey,
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: 64),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KalaColors.burntOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Explore Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: KalaColors.softBeige, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'I\'ll do this later',
                      style: TextStyle(color: KalaColors.mediumGrey, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Beautiful Circular Collage surrounding Logo
              Center(
                child: _buildCollage(size: 360, centerTextSize: 48),
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
                child: const Text(
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

  Widget _buildCollage({required double size, required double centerTextSize}) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
        // Top Artist Circle
        Positioned(
          top: 0,
          child: _buildCollageCircle(
            imageUrl: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
            size: size * 0.70,
          ),
        ),
        // Bottom Artist Circle
        Positioned(
          bottom: 0,
          child: _buildCollageCircle(
            imageUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
            size: size * 0.70,
          ),
        ),
        // Left Artist Circle
        Positioned(
          left: 0,
          child: _buildCollageCircle(
            imageUrl: 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4',
            size: size * 0.60,
          ),
        ),
        // Right Artist Circle
        Positioned(
          right: 0,
          child: _buildCollageCircle(
            imageUrl: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
            size: size * 0.60,
          ),
        ),
          // Center KALĀ Monogram Rounded Square
          Container(
            width: size * 0.35,
            height: size * 0.35,
            decoration: BoxDecoration(
              color: KalaColors.ivory,
              borderRadius: BorderRadius.circular(size * 0.08), // Rounded square
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                'kā',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: centerTextSize,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.charcoal,
                  letterSpacing: -1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollageCircle({required String imageUrl, required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
