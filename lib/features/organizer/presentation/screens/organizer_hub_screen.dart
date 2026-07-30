import 'package:flutter/material.dart';

import '../../../../core/theme/kala_colors.dart';

class OrganizerHubScreen extends StatelessWidget {
  const OrganizerHubScreen({super.key});

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
              _buildTodaysPriorities(),
              _buildRecruitmentSnapshot(),
              _buildRecommendedTalent(),
              _buildRecentActivity(),
              _buildUpcomingSchedule(),
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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Row(
        children: [
          // Org logo circle
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: KalaColors.charcoal,
              shape: BoxShape.circle,
              border: Border.all(color: KalaColors.burntOrange, width: 2),
            ),
            child: Center(
              child: Text(
                'R',
                style: TextStyle(fontFamily: 'ZT_Nature', 
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning,',
                  style: TextStyle(fontFamily: 'ZT_Nature', 
                    fontSize: 12,
                    color: KalaColors.mediumGrey,
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Rhythm Productions',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontFamily: 'ZT_Nature', 
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: KalaColors.charcoal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, color: KalaColors.burntOrange, size: 16),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _iconButton(Icons.search),
          const SizedBox(width: 8),
          Stack(
            children: [
              _iconButton(Icons.notifications_outlined),
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: KalaColors.burntOrange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          _iconButton(Icons.settings_outlined),
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

  // ─── TODAY'S PRIORITIES ──────────────────────────────────────────────────
  Widget _buildTodaysPriorities() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Today\'s Priorities'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: KalaColors.lightGrey),
            ),
            child: Column(
              children: [
                _priorityRow(
                  Icons.people_outline,
                  '24 new artists match your casting',
                  'Tap to review',
                  subtitleColor: KalaColors.mediumGrey,
                ),
                Divider(height: 1, color: KalaColors.lightGrey),
                _priorityRow(
                  Icons.assignment_outlined,
                  '8 applications require review today',
                  'Tap to review',
                  subtitleColor: KalaColors.mediumGrey,
                ),
                Divider(height: 1, color: KalaColors.lightGrey),
                _priorityRow(
                  Icons.event_outlined,
                  'Your Music Fest audition closes',
                  'Tap to view details',
                  highlight: 'tomorrow',
                  subtitleColor: KalaColors.mediumGrey,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _priorityRow(IconData icon, String title, String subtitle,
      {String? highlight, Color subtitleColor = KalaColors.mediumGrey}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: KalaColors.burntOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: KalaColors.burntOrange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                highlight != null
                    ? RichText(
                        text: TextSpan(
                          style: TextStyle(fontFamily: 'ZT_Nature', 
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: KalaColors.charcoal,
                          ),
                          children: [
                            TextSpan(text: '$title '),
                            TextSpan(
                              text: highlight,
                              style: const TextStyle(color: KalaColors.burntOrange),
                            ),
                          ],
                        ),
                      )
                    : Text(
                        title,
                        style: TextStyle(fontFamily: 'ZT_Nature', 
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: KalaColors.charcoal,
                        ),
                      ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 11, color: subtitleColor),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: KalaColors.mediumGrey, size: 20),
        ],
      ),
    );
  }

  // ─── RECRUITMENT SNAPSHOT ─────────────────────────────────────────────────
  Widget _buildRecruitmentSnapshot() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _sectionHeader('Recruitment Snapshot'),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _snapshotCard('12', 'Active\nOpportunities', Icons.work_outline, '+2'),
              _snapshotCard('86', 'Under\nReview', Icons.people_outline, '+14'),
              _snapshotCard('18', 'Interviews\nScheduled', Icons.calendar_today_outlined, '+3'),
              _snapshotCard('9', 'Positions\nFilled', Icons.check_circle_outline, '+2'),
              _snapshotCard('5', 'Projects\nSoon', Icons.rocket_launch_outlined, '—'),
            ],
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }

  Widget _snapshotCard(String value, String label, IconData icon, String trend) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: KalaColors.burntOrange, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontFamily: 'ZT_Nature', 
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: KalaColors.charcoal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, color: KalaColors.mediumGrey, height: 1.3),
          ),
          const SizedBox(height: 8),
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: KalaColors.burntOrange,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            trend == '—' ? '—' : '↑ $trend',
            style: TextStyle(fontFamily: 'ZT_Nature', 
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: trend == '—' ? KalaColors.mediumGrey : KalaColors.accentGreen,
            ),
          ),
        ],
      ),
    );
  }

  // ─── RECOMMENDED TALENT ──────────────────────────────────────────────────
  Widget _buildRecommendedTalent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _sectionHeader('Recommended Talent', showViewAll: true),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _talentCard('Aarav Mehta', 'Vocalist', 'Mumbai, MH', '95%', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200'),
              _talentCard('Nritika Rao', 'Bharatanatyam Dancer', 'Bengaluru, KA', '92%', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=200'),
              _talentCard('Kabir Malhotra', 'Cinematographer', 'Delhi, DL', '90%', 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&q=80&w=200'),
            ],
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }

  Widget _talentCard(String name, String role, String location, String match, String imgUrl) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  imgUrl,
                  height: 120,
                  width: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 120,
                    width: 160,
                    color: KalaColors.softBeige,
                    child: const Icon(Icons.person, color: KalaColors.mediumGrey, size: 40),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: KalaColors.burntOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$match\nMatch',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'ZT_Nature', 
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 13, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
                ),
                Text(
                  role,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 11, color: KalaColors.mediumGrey),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 11, color: KalaColors.mediumGrey),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, color: KalaColors.mediumGrey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _iconBtn(Icons.visibility_outlined),
                    _iconBtn(Icons.bookmark_outline),
                    _iconBtn(Icons.person_add_alt_1_outlined),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: KalaColors.ivory,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Icon(icon, size: 16, color: KalaColors.charcoal),
    );
  }

  // ─── RECENT ACTIVITY ──────────────────────────────────────────────────────
  Widget _buildRecentActivity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Recent Activity', showViewAll: true),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: KalaColors.lightGrey),
            ),
            child: Column(
              children: [
                _activityRow(Icons.person_outline, 'Aarav Mehta applied for Music Fest Performer', '10:30 AM'),
                Divider(height: 1, color: KalaColors.lightGrey),
                _activityRow(Icons.people_outline, '3 candidates shortlisted for Dance Competition', '09:15 AM'),
                Divider(height: 1, color: KalaColors.lightGrey),
                _activityRow(Icons.calendar_today_outlined, 'Interview scheduled with Nritiya Collective', 'Yesterday'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            child: Text(
              'See Full Timeline >',
              style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 13, fontWeight: FontWeight.bold, color: KalaColors.burntOrange),
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _activityRow(IconData icon, String text, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: KalaColors.burntOrange.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 14, color: KalaColors.burntOrange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, color: KalaColors.charcoal, height: 1.4),
            ),
          ),
          const SizedBox(width: 8),
          Text(time, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, color: KalaColors.mediumGrey)),
        ],
      ),
    );
  }

  // ─── UPCOMING SCHEDULE ────────────────────────────────────────────────────
  Widget _buildUpcomingSchedule() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Upcoming Schedule', showViewAll: true),
          const SizedBox(height: 12),
          _scheduleItem('MAY', '16', 'Music Fest – Auditions', '10:00 AM – 02:00 PM', 'Andheri, Mumbai'),
          const SizedBox(height: 10),
          _scheduleItem('MAY', '18', 'Short Film – Interviews', '11:00 AM – 01:00 PM', 'Google Meet'),
          const SizedBox(height: 10),
          _scheduleItem('MAY', '20', 'Dance Comp – Auditions', '09:00 AM – 04:00 PM', 'Bengaluru, KA'),
        ],
      ),
    );
  }

  Widget _scheduleItem(String month, String day, String title, String time, String location) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: KalaColors.burntOrange.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(month, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 9, fontWeight: FontWeight.bold, color: KalaColors.burntOrange)),
                Text(day, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 18, fontWeight: FontWeight.bold, color: KalaColors.burntOrange)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 13, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time_outlined, size: 11, color: KalaColors.mediumGrey),
                    const SizedBox(width: 3),
                    Flexible(child: Text(time, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 11, color: KalaColors.mediumGrey))),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 11, color: KalaColors.mediumGrey),
                    const SizedBox(width: 3),
                    Flexible(child: Text(location, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 11, color: KalaColors.mediumGrey))),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: KalaColors.burntOrange, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }

  // ─── HELPERS ──────────────────────────────────────────────────────────────
  Widget _sectionHeader(String title, {bool showViewAll = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 16, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
          ),
        ),
        if (showViewAll)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text('View All', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.burntOrange)),
          ),
      ],
    );
  }
}
