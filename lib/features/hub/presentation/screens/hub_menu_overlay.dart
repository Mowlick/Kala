import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/kala_colors.dart';

class HubMenuOverlay extends StatelessWidget {
  final VoidCallback? onClose;
  const HubMenuOverlay({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    final bool isLaptop = MediaQuery.of(context).size.width >= 1000;

    if (isLaptop) {
      return Scaffold(
        backgroundColor: KalaColors.ivory,
        body: SafeArea(
          child: _buildLaptopLayout(context),
        ),
      );
    }

    return Scaffold(
      backgroundColor: KalaColors.ivory,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Header (Title + Close Button)
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What would you like to do?',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: KalaColors.charcoal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Share your talent, find talent, or create opportunities.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 11,
                                color: KalaColors.mediumGrey,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Close button inside a white circular border
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: KalaColors.softBeige),
                    ),
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.close, color: KalaColors.charcoal, size: 18),
                        onPressed: () {
                          if (onClose != null) {
                            onClose!();
                          } else if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Scrollable Actions Menu
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- SECTION 1: CREATE ---
                    _buildSectionHeader(context, 'Create'),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.72,
                      children: [
                        _buildMenuIconItem(
                          context,
                          icon: Icons.video_call_outlined,
                          title: 'Post',
                          subtitle: 'Share a post, reel or update',
                        ),
                        _buildMenuIconItem(
                          context,
                          icon: Icons.video_library_outlined,
                          title: 'Upload Project',
                          subtitle: 'Showcase your work and get discovered',
                        ),
                        _buildMenuIconItem(
                          context,
                          icon: Icons.music_note_outlined,
                          title: 'Upload Audio',
                          subtitle: 'Share your music, cover or track',
                        ),
                        _buildMenuIconItem(
                          context,
                          icon: Icons.photo_outlined,
                          title: 'Upload Photo',
                          subtitle: 'Share moments, posters or art',
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // --- SECTION 2: FIND ---
                    _buildSectionHeader(context, 'Find'),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: KalaColors.softBeige),
                      ),
                      child: Column(
                        children: [
                          _buildListTileItem(
                            context,
                            icon: Icons.search,
                            title: 'Find Opportunities',
                            subtitle: 'Auditions, gigs, competitions, internships and more',
                            onTap: () {
                              if (onClose != null) {
                                onClose!();
                              } else if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                          ),
                          _buildDivider(),
                          _buildListTileItem(
                            context,
                            icon: Icons.people_outline,
                            title: 'Find Collaborators',
                            subtitle: 'Connect with artists, creators and professionals',
                            onTap: () {
                              if (onClose != null) {
                                onClose!();
                              } else if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                          ),
                          _buildDivider(),
                          _buildListTileItem(
                            context,
                            icon: Icons.business_center_outlined,
                            title: 'Find Work',
                            subtitle: 'Explore freelance and job opportunities',
                            onTap: () {
                              if (onClose != null) {
                                onClose!();
                              } else if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                          ),
                          _buildDivider(),
                          _buildListTileItem(
                            context,
                            icon: Icons.event_note_outlined,
                            title: 'Find Events',
                            subtitle: 'Workshops, masterclasses, fests and showcases',
                            onTap: () {
                              if (onClose != null) {
                                onClose!();
                              } else if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- SECTION 3: CREATE OPPORTUNITY ---
                    _buildSectionHeader(context, 'Create Opportunity'),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF0E9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFED7C3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: const Icon(
                                  Icons.campaign_outlined,
                                  color: KalaColors.burntOrange,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Post an Opportunity',
                                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFED7C3),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'For Organizers',
                                            style: TextStyle(
                                              fontSize: 8,
                                              color: KalaColors.burntOrange,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Reach the right talent from across India. Post auditions, gigs, events or internship openings.',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: KalaColors.charcoal.withValues(alpha: 0.6),
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                              Navigator.pushNamed(context, '/create-opportunity');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: KalaColors.burntOrange,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Create Opportunity',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, size: 14),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- SECTION 4: TOOLS & EXTRAS ---
                    _buildSectionHeader(context, 'Tools & Extras'),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.72,
                      children: [
                        _buildMenuIconItem(
                          context,
                          icon: Icons.insert_drive_file_outlined,
                          title: 'Create Portfolio',
                          subtitle: 'Build your professional profile',
                        ),
                        _buildMenuIconItem(
                          context,
                          icon: Icons.badge_outlined,
                          title: 'Add Resume',
                          subtitle: 'Create or upload your resume',
                        ),
                        _buildMenuIconItem(
                          context,
                          icon: Icons.videocam_outlined,
                          title: 'Live Session',
                          subtitle: 'Go live and connect with your audience',
                        ),
                        _buildMenuIconItem(
                          context,
                          icon: Icons.bar_chart_outlined,
                          title: 'Analytics',
                          subtitle: 'Track your growth and performance',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLaptopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Middle scrollable viewport
        Expanded(
          flex: 7,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Title + subtext + Close X Button)
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What would you like to do?',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: KalaColors.charcoal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Share your talent, find talent, or create opportunities.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: KalaColors.softBeige),
                      ),
                      child: Center(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.close, color: KalaColors.charcoal, size: 18),
                          onPressed: () {
                            if (onClose != null) {
                              onClose!();
                            } else if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // SECTION 1: CREATE (5 horizontal White Cards)
                _buildSectionHeader(context, 'Create'),
                const SizedBox(height: 12),
                SizedBox(
                  height: 125,
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildMenuIconItem(
                          context,
                          icon: Icons.video_call_outlined,
                          title: 'Post',
                          subtitle: 'Share a post, reel or update',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMenuIconItem(
                          context,
                          icon: Icons.video_library_outlined,
                          title: 'Upload Project',
                          subtitle: 'Showcase your work and get discovered',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMenuIconItem(
                          context,
                          icon: Icons.music_note_outlined,
                          title: 'Upload Audio',
                          subtitle: 'Share your music, cover or track',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMenuIconItem(
                          context,
                          icon: Icons.photo_outlined,
                          title: 'Upload Photo',
                          subtitle: 'Share moments, posters or art',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMenuIconItem(
                          context,
                          icon: Icons.podcasts,
                          title: 'Go Live',
                          subtitle: 'Go live and connect with your audience',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // SECTION 2: FIND (List inside rounded white box with divider lines)
                _buildSectionHeader(context, 'Find'),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: KalaColors.softBeige),
                  ),
                  child: Column(
                    children: [
                      _buildListTileItem(
                        context,
                        icon: Icons.search,
                        title: 'Find Opportunities',
                        subtitle: 'Auditions, gigs, competitions, internships and more',
                        onTap: () {
                          if (onClose != null) onClose!();
                        },
                      ),
                      _buildDivider(),
                      _buildListTileItem(
                        context,
                        icon: Icons.people_outline,
                        title: 'Find Collaborators',
                        subtitle: 'Connect with artists, creators and professionals',
                        onTap: () {
                          if (onClose != null) onClose!();
                        },
                      ),
                      _buildDivider(),
                      _buildListTileItem(
                        context,
                        icon: Icons.business_center_outlined,
                        title: 'Find Work',
                        subtitle: 'Explore freelance and job opportunities',
                        onTap: () {
                          if (onClose != null) onClose!();
                        },
                      ),
                      _buildDivider(),
                      _buildListTileItem(
                        context,
                        icon: Icons.event_note_outlined,
                        title: 'Find Events',
                        subtitle: 'Workshops, masterclasses, fests and showcases',
                        onTap: () {
                          if (onClose != null) onClose!();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // SECTION 3: CREATE OPPORTUNITY Banner
                _buildSectionHeader(context, 'Create Opportunity'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF2EC),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: KalaColors.softBeige),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.campaign_outlined,
                          color: KalaColors.burntOrange,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Post an Opportunity',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFED7C3),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'For Organizers',
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: KalaColors.burntOrange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Reach the right talent from across India. Post auditions, gigs, events or internship openings.',
                              style: TextStyle(
                                fontSize: 11,
                                color: KalaColors.charcoal.withValues(alpha: 0.6),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/create-opportunity');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Create Opportunity'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // SECTION 4: TOOLS & EXTRAS
                _buildSectionHeader(context, 'Tools & Extras'),
                const SizedBox(height: 12),
                SizedBox(
                  height: 125,
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildMenuIconItem(
                          context,
                          icon: Icons.insert_drive_file_outlined,
                          title: 'Create Portfolio',
                          subtitle: 'Build your professional profile',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMenuIconItem(
                          context,
                          icon: Icons.badge_outlined,
                          title: 'Add Resume',
                          subtitle: 'Create or upload your resume',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMenuIconItem(
                          context,
                          icon: Icons.videocam_outlined,
                          title: 'Live Session',
                          subtitle: 'Go live and connect with your audience',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMenuIconItem(
                          context,
                          icon: Icons.bar_chart_outlined,
                          title: 'Analytics',
                          subtitle: 'Track your growth and performance',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),

        // Divider
        Container(width: 0.5, color: const Color(0xFFEAE2B7)),

        // Right Sidebar View
        _buildHubRightSidebar(context),
      ],
    );
  }

  Widget _buildHubRightSidebar(BuildContext context) {
    return Container(
      width: 320,
      color: KalaColors.ivory,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Share your talent card banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF0E9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFED7C3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Share your talent ✨',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: KalaColors.charcoal,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Keep your profile and content updated to get better opportunities.',
                              style: TextStyle(
                                fontSize: 10,
                                color: KalaColors.charcoal.withValues(alpha: 0.6),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1516450360452-9312f5e86fc7'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // 2. Recent Drafts Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Drafts',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: KalaColors.charcoal,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: KalaColors.burntOrange,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDraftItem(
              title: 'New Cover Release',
              subtitle: 'Updated 2h ago',
              badge: 'Audio',
              imageUrl: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
            ),
            _buildDraftItem(
              title: 'Dance Workshop Promo',
              subtitle: 'Updated yesterday',
              badge: 'Post',
              imageUrl: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
            ),
            _buildDraftItem(
              title: 'Short Film Project',
              subtitle: 'Updated 2 days ago',
              badge: 'Project',
              imageUrl: 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4',
            ),
            _buildDraftItem(
              title: 'Photography Series',
              subtitle: 'Updated 3 days ago',
              badge: 'Photo',
              imageUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
            ),

            const SizedBox(height: 28),

            // 3. Tips for better reach
            Text(
              'Tips for better reach',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: KalaColors.charcoal,
              ),
            ),
            const SizedBox(height: 16),
            _buildTipRow(Icons.image_outlined, 'Add a clear cover or thumbnail'),
            const SizedBox(height: 12),
            _buildTipRow(Icons.edit_outlined, 'Write a strong caption'),
            const SizedBox(height: 12),
            _buildTipRow(Icons.local_offer_outlined, 'Use relevant tags'),
            const SizedBox(height: 12),
            _buildTipRow(Icons.access_time_outlined, 'Post consistently'),
          ],
        ),
      ),
    );
  }

  Widget _buildDraftItem({
    required String title,
    required String subtitle,
    required String badge,
    required String imageUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: KalaColors.charcoal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 9,
                    color: KalaColors.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          // Category badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: KalaColors.softBeige,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                fontSize: 8,
                color: KalaColors.charcoal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.more_horiz, size: 16, color: KalaColors.mediumGrey),
        ],
      ),
    );
  }

  Widget _buildTipRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: KalaColors.burntOrange),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              color: KalaColors.charcoal,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: KalaColors.charcoal,
      ),
    );
  }

  Widget _buildMenuIconItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KalaColors.softBeige),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF0E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: KalaColors.burntOrange,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: KalaColors.charcoal,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 8,
                color: KalaColors.charcoal.withValues(alpha: 0.5),
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTileItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFFDF0E9),
        ),
        child: Icon(icon, color: KalaColors.burntOrange, size: 18),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: KalaColors.charcoal,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 10,
          color: KalaColors.charcoal.withValues(alpha: 0.5),
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: KalaColors.burntOrange, size: 18),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(color: KalaColors.softBeige, height: 1),
    );
  }
}
