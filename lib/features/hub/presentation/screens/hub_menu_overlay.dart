import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/kala_colors.dart';

class HubMenuOverlay extends StatelessWidget {
  final VoidCallback? onClose;

  const HubMenuOverlay({super.key, this.onClose});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const HubMenuOverlay(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    
    return Container(
      height: screenHeight * 0.94,
      decoration: const BoxDecoration(
        color: KalaColors.ivory,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 12),
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: KalaColors.lightGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      
                      _buildSectionHeader('Add to Portfolio', const Color(0xFFEA580C)),
                      const SizedBox(height: 16),
                      _buildPortfolioGrid(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Floating Close Button
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: InkWell(
                onTap: () {
                  if (onClose != null) {
                    onClose!();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEA580C),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEA580C).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What would you like\nto do today?',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.charcoal,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Build your portfolio or take the next step in your creative journey.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: KalaColors.mediumGrey,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Abstract illustration representation
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFFEDD5), width: 2),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.folder_shared_outlined, size: 40, color: Color(0xFFFDBA74)),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEA580C),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, Color actionColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: KalaColors.charcoal,
          ),
        ),
        Row(
          children: [
            Text(
              'View all',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: actionColor,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward, size: 14, color: actionColor),
          ],
        ),
      ],
    );
  }

  Widget _buildPortfolioGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _buildGridCard(Icons.cloud_upload_outlined, 'Upload Project', 'Films, songs, designs\nand more', const Color(0xFFEA580C)),
        _buildGridCard(Icons.curtains_outlined, 'Add Performance', 'Live shows, dance,\ntheatre & more', const Color(0xFFEA580C)),
        _buildGridCard(Icons.image_outlined, 'Upload Photos', 'Photoshoots, events,\nportraits & more', const Color(0xFFEA580C)),
        _buildGridCard(Icons.videocam_outlined, 'Upload Videos', 'Reels, performances,\nshowreels & more', const Color(0xFFEA580C)),
        _buildGridCard(Icons.music_note_outlined, 'Upload Audio', 'Songs, covers,\npodcasts & more', const Color(0xFFEA580C)),
        _buildGridCard(Icons.emoji_events_outlined, 'Certificates & Awards', 'Achievements,\nrecognition & certificates', const Color(0xFFEA580C)),
      ],
    );
  }

  Widget _buildGridCard(IconData icon, String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: KalaColors.charcoal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: KalaColors.mediumGrey,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
