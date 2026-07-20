import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/kala_colors.dart';

/// The Create sheet is shown as a modal bottom sheet from the nav hub.
/// This widget is the content of that bottom sheet.
class OrganizerCreateScreen extends StatelessWidget {
  final VoidCallback? onClose;

  const OrganizerCreateScreen({super.key, this.onClose});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const OrganizerCreateScreen(),
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
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 28),
                      _buildWhatToCreate(),
                      const SizedBox(height: 28),
                      _buildDraftsAndTemplates(),
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
              child: GestureDetector(
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
                    color: KalaColors.burntOrange,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: KalaColors.burntOrange.withValues(alpha: 0.3),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create',
                style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
              ),
              const SizedBox(height: 4),
              Text(
                'Start your next creative opportunity.',
                style: GoogleFonts.inter(fontSize: 13, color: KalaColors.mediumGrey),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: KalaColors.lightGrey),
          ),
          child: const Icon(Icons.assignment_outlined, color: KalaColors.charcoal, size: 20),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: KalaColors.lightGrey),
          ),
          child: const Icon(Icons.help_outline, color: KalaColors.charcoal, size: 20),
        ),
      ],
    );
  }

  Widget _buildWhatToCreate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'What would you like to create?',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text('View all', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.burntOrange)),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _createItem(Icons.work_outline, 'Opportunity', 'Hire talent for your event or project'),
        _createItem(Icons.mic_outlined, 'Audition', 'Conduct auditions & selections'),
        _createItem(Icons.emoji_events_outlined, 'Competition', 'Organize contests & challenges'),
        _createItem(Icons.brush_outlined, 'Workshop', 'Host learning or training sessions'),
        _createItem(Icons.school_outlined, 'Internship', 'Offer internship opportunities'),
        _createItem(Icons.people_outline, 'Collaboration', 'Find partners for creative projects'),
        _createItem(Icons.movie_outlined, 'Creative Project', 'Build a project with a creative team'),
        _createItem(Icons.record_voice_over_outlined, 'Open Casting', 'Open calls for any role'),
      ],
    );
  }

  Widget _createItem(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: KalaColors.burntOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: KalaColors.burntOrange, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: KalaColors.mediumGrey)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: KalaColors.mediumGrey, size: 20),
        ],
      ),
    );
  }

  Widget _buildDraftsAndTemplates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Drafts & Recent Templates', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
            Text('View all', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.burntOrange)),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _templateCard(
                'Music Fest 2026',
                'Opportunity • Updated 2d ago',
                'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&q=80&w=300',
              ),
              _templateCard(
                'Short Film Casting',
                'Casting Call • Updated 1w ago',
                'https://images.unsplash.com/photo-1485846234645-a62644f84728?auto=format&fit=crop&q=80&w=300',
              ),
              _templateCard(
                'Dance Competition',
                'Competition • Updated 5d ago',
                'https://images.unsplash.com/photo-1429962714451-bb934ecdc4ec?auto=format&fit=crop&q=80&w=300',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _templateCard(String title, String subtitle, String imgUrl) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.network(
              imgUrl,
              height: 90,
              width: 160,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 90,
                width: 160,
                color: KalaColors.softBeige,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                const SizedBox(height: 2),
                Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey)),
                const SizedBox(height: 8),
                Center(
                  child: Text('Duplicate', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: KalaColors.burntOrange)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
