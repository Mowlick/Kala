import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/kala_colors.dart';

class OrganizerTalentScreen extends StatelessWidget {
  const OrganizerTalentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KalaColors.ivory,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildQuickFilters(),
              _buildAllFiltersRow(),
              _buildRecommendedTalent(),
              _buildTrendingCreators(),
              _buildRecentlyAvailable(),
              _buildTalentCollections(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // ─── HEADER ───────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Talent',
                  style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
                ),
                Text(
                  'Discover the right creators for your next project.',
                  style: GoogleFonts.inter(fontSize: 12, color: KalaColors.mediumGrey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _iconButton(Icons.search),
          const SizedBox(width: 8),
          _iconButton(Icons.tune),
          const SizedBox(width: 8),
          _iconButton(Icons.auto_awesome),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Icon(icon, size: 18, color: KalaColors.charcoal),
    );
  }

  // ─── SEARCH BAR ───────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: KalaColors.lightGrey),
        ),
        child: Row(
          children: [
            Icon(Icons.auto_awesome, size: 16, color: KalaColors.burntOrange),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Search talent naturally... e.g. "Female singer from Delhi under 24"',
                style: GoogleFonts.inter(fontSize: 13, color: KalaColors.mediumGrey),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.mic_outlined, size: 18, color: KalaColors.mediumGrey),
          ],
        ),
      ),
    );
  }

  // ─── QUICK FILTERS ────────────────────────────────────────────────────────
  Widget _buildQuickFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quick Filters', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
              Text('See All', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.burntOrange)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _filterChip('Music', Icons.music_note_outlined, selected: true),
              _filterChip('Dance', Icons.directions_run_outlined),
              _filterChip('Acting', Icons.theater_comedy_outlined),
              _filterChip('Photography', Icons.camera_alt_outlined),
              _filterChip('Filmmaking', Icons.videocam_outlined),
              _filterChip('More', Icons.grid_view_rounded),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _filterChip(String label, IconData icon, {bool selected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? KalaColors.burntOrange : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: selected ? KalaColors.burntOrange : KalaColors.lightGrey),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: selected ? Colors.white : KalaColors.charcoal),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : KalaColors.charcoal,
            ),
          ),
        ],
      ),
    );
  }

  // ─── ALL FILTERS ROW ─────────────────────────────────────────────────────
  Widget _buildAllFiltersRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: KalaColors.lightGrey),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.tune, size: 14, color: KalaColors.charcoal),
                  const SizedBox(width: 4),
                  Text('All Filters', style: GoogleFonts.inter(fontSize: 11, color: KalaColors.charcoal)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _filterTag('Delhi'),
            _filterTag('18 – 25'),
            _filterTag('Available Now'),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_down, color: KalaColors.mediumGrey, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _filterTag(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 11, color: KalaColors.charcoal)),
          const SizedBox(width: 4),
          const Icon(Icons.close, size: 12, color: KalaColors.mediumGrey),
        ],
      ),
    );
  }

  // ─── RECOMMENDED TALENT ──────────────────────────────────────────────────
  Widget _buildRecommendedTalent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _sectionHeader('Recommended Talent'),
          const SizedBox(height: 12),
          _talentCard(
            'Aanya Sharma',
            'Singer • Live Performer • Playback',
            'Delhi, India',
            true,
            '92%',
            ['Bollywood', 'Sufi', 'Indie Pop', '+2'],
            '4.8 (32)',
            'Avg. response 2h',
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=200',
          ),
          const SizedBox(height: 12),
          _talentCard(
            'Rohan Verma',
            'Photographer • Fashion • Portrait',
            'Mumbai, India',
            false,
            '88%',
            ['Portrait', 'Fashion', 'Event', '+2'],
            '4.7 (28)',
            'Avg. response 3h',
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200',
          ),
          const SizedBox(height: 12),
          _talentCard(
            'Kartik Dixit',
            'Actor • Theatre • Film',
            'Bengaluru, India',
            true,
            '90%',
            ['Theatre', 'Film', 'Voice Acting', '+2'],
            '4.8 (41)',
            'Avg. response 1h',
            'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&q=80&w=200',
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _talentCard(
    String name,
    String roles,
    String location,
    bool available,
    String match,
    List<String> tags,
    String rating,
    String response,
    String imgUrl,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imgUrl,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 90,
                    height: 90,
                    color: KalaColors.softBeige,
                    child: const Icon(Icons.person, color: KalaColors.mediumGrey, size: 36),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, color: KalaColors.burntOrange, size: 14),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(roles, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 11, color: KalaColors.mediumGrey)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 11, color: KalaColors.mediumGrey),
                        const SizedBox(width: 2),
                        Flexible(child: Text(location, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 11, color: KalaColors.mediumGrey))),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: available
                                ? KalaColors.accentGreen.withValues(alpha: 0.1)
                                : Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            available ? '● Available Now' : '● Available Tomorrow',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: available ? KalaColors.accentGreen : Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 11, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(rating, style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey)),
                        const SizedBox(width: 8),
                        const Icon(Icons.bolt, size: 11, color: KalaColors.mediumGrey),
                        const SizedBox(width: 2),
                        Flexible(child: Text(response, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Match %
              Text(
                match,
                style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: KalaColors.burntOrange),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Tags
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: tags.map((t) => Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: KalaColors.softBeige,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(t, style: GoogleFonts.inter(fontSize: 10, color: KalaColors.charcoal)),
              )).toList(),
            ),
          ),
          const SizedBox(height: 12),
          // Action buttons
          Row(
            children: [
              Expanded(child: _outlineBtn('View Portfolio', Icons.visibility_outlined)),
              const SizedBox(width: 8),
              Expanded(child: _outlineBtn('Save', Icons.bookmark_outline)),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: KalaColors.burntOrange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.send, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text('Invite', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _outlineBtn(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 13, color: KalaColors.charcoal),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: KalaColors.charcoal),
            ),
          ),
        ],
      ),
    );
  }

  // ─── TRENDING CREATORS ────────────────────────────────────────────────────
  Widget _buildTrendingCreators() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: _sectionHeader('Trending Creators')),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _trendingCard('Nithya Kapoor', 'Dancer', '94%', '🔥 Trending', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=150'),
              _trendingCard('Arjun Malik', 'Music Producer', '91%', '⭐ Top Rated', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=150'),
              _trendingCard('Meera Iyer', 'Filmmaker', '93%', '🏆 Award Winner', 'https://images.unsplash.com/photo-1547153760-18fc86324498?auto=format&fit=crop&q=80&w=150'),
              _trendingCard('Vivaan S.', 'Content Creator', '89%', '🚀 Rising Star', 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&q=80&w=150'),
            ],
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }

  Widget _trendingCard(String name, String role, String match, String badge, String imgUrl) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [KalaColors.burntOrange, Colors.orange]),
            ),
            child: CircleAvatar(
              radius: 36,
              backgroundImage: NetworkImage(imgUrl),
              onBackgroundImageError: (_, __) {},
              backgroundColor: KalaColors.softBeige,
            ),
          ),
          const SizedBox(height: 8),
          Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
          Text(role, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey)),
          Text('$match Match', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: KalaColors.burntOrange)),
          const SizedBox(height: 4),
          Text(badge, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 9, color: KalaColors.charcoal)),
        ],
      ),
    );
  }

  // ─── RECENTLY AVAILABLE ──────────────────────────────────────────────────
  Widget _buildRecentlyAvailable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: _sectionHeader('Recently Available')),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _availableAvatar('Anjali Singh', 'Vocalist', '● Available', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=100', isNew: true),
              _availableAvatar('Dev Arora', 'Cinematographer', '● Available Now', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=100'),
              _availableAvatar('Ishita Rao', 'Graphic Designer', '● Available', 'https://images.unsplash.com/photo-1547153760-18fc86324498?auto=format&fit=crop&q=80&w=100', isNew: true),
              _availableAvatar('Tanishk Mehta', 'Editor', '● Available', 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&q=80&w=100'),
            ],
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }

  Widget _availableAvatar(String name, String role, String status, String imgUrl, {bool isNew = false}) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(imgUrl),
                onBackgroundImageError: (_, __) {},
                backgroundColor: KalaColors.softBeige,
              ),
              if (isNew)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(color: KalaColors.burntOrange, borderRadius: BorderRadius.circular(6)),
                    child: Text('NEW', style: GoogleFonts.inter(fontSize: 7, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
          Text(role, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 9, color: KalaColors.mediumGrey)),
          Text(status, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 9, color: KalaColors.accentGreen)),
        ],
      ),
    );
  }

  // ─── TALENT COLLECTIONS ──────────────────────────────────────────────────
  Widget _buildTalentCollections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: _sectionHeader('Talent Collections')),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _collectionCard('Future Actors', '28 Creators'),
              _collectionCard('Music Producers', '18 Creators'),
              _collectionCard('Campus Ambassadors', '32 Creators'),
              _collectionCard('Video Editors', '16 Creators'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _collectionCard(String title, String count) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.folder_outlined, color: KalaColors.burntOrange, size: 28),
          const SizedBox(height: 8),
          Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
          const SizedBox(height: 4),
          Text(count, style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey)),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, {bool showViewAll = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(title, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: KalaColors.charcoal))),
        if (showViewAll)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text('View All', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.burntOrange)),
          ),
      ],
    );
  }
}
