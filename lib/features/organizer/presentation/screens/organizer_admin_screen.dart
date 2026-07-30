import 'package:flutter/material.dart';

import '../../../../core/theme/kala_colors.dart';

class OrganizerAdminScreen extends StatelessWidget {
  const OrganizerAdminScreen({super.key});

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
              _buildOrgProfile(),
              _buildTrustMetrics(),
              _buildQuickActions(),
              _buildActiveOpportunities(),
              _buildTeamWorkspace(),
              _buildHiringAnalytics(),
              _buildRecentActivity(),
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
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin',
                  style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 28, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
                ),
                Text(
                  'Manage your organization, team & hiring.',
                  style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, color: KalaColors.mediumGrey),
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
                  decoration: const BoxDecoration(color: KalaColors.burntOrange, shape: BoxShape.circle),
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

  // ─── ORG PROFILE CARD ─────────────────────────────────────────────────────
  Widget _buildOrgProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Cover image
              Image.network(
                'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&q=80&w=800',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(height: 200, color: KalaColors.charcoal),
              ),
              // Dark overlay
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withValues(alpha: 0.3), Colors.black.withValues(alpha: 0.75)],
                  ),
                ),
              ),
              // Content overlay
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo circle
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: KalaColors.charcoal,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              'R',
                              style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Rhythm Productions',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.verified, color: KalaColors.accentGreen, size: 16),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  _profileTag('Production House'),
                                  const SizedBox(width: 6),
                                  _profileTag('Mumbai, India'),
                                  const SizedBox(width: 6),
                                  _profileTag('Est. 2016'),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: KalaColors.accentGreen.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: KalaColors.accentGreen.withValues(alpha: 0.5)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.verified_user, size: 10, color: KalaColors.accentGreen),
                                    const SizedBox(width: 4),
                                    Text('Verified Organization', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, fontWeight: FontWeight.bold, color: KalaColors.accentGreen)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'We create unforgettable stories through music, film and live experiences.',
                      style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, color: Colors.white.withValues(alpha: 0.85), height: 1.4),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.edit_outlined, size: 14, color: KalaColors.charcoal),
                            const SizedBox(width: 6),
                            Text('Edit Profile', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileTag(String label) {
    return Text(
      label,
      style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, color: Colors.white.withValues(alpha: 0.75)),
    );
  }

  // ─── TRUST METRICS ────────────────────────────────────────────────────────
  Widget _buildTrustMetrics() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _metricCard(Icons.work_outline, '23', 'Active\nOpportunities'),
            _metricCard(Icons.people_outline, '1,248', 'Successful\nHires'),
            _metricCard(Icons.assignment_outlined, '18.4K', 'Applications\nProcessed'),
            _metricCard(Icons.check_circle_outline, '72%', 'Hiring Success\nRate'),
            _metricCard(Icons.access_time_outlined, '2.3 hrs', 'Avg. Response\nTime'),
          ],
        ),
      ),
    );
  }

  Widget _metricCard(IconData icon, String value, String label) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: KalaColors.burntOrange, size: 20),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 18, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, color: KalaColors.mediumGrey, height: 1.3)),
        ],
      ),
    );
  }

  // ─── QUICK ACTIONS ────────────────────────────────────────────────────────
  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Quick Actions', showViewAll: false),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _quickActionBtn(Icons.add_circle_outline, 'Create\nOpportunity')),
              const SizedBox(width: 10),
              Expanded(child: _quickActionBtn(Icons.person_add_alt_1_outlined, 'Invite\nTeam')),
              const SizedBox(width: 10),
              Expanded(child: _quickActionBtn(Icons.bar_chart_outlined, 'View\nAnalytics')),
              const SizedBox(width: 10),
              Expanded(child: _quickActionBtn(Icons.manage_accounts_outlined, 'Manage\nTeam')),
              const SizedBox(width: 10),
              Expanded(child: _quickActionBtn(Icons.edit_outlined, 'Edit\nProfile')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickActionBtn(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Column(
        children: [
          Icon(icon, color: KalaColors.burntOrange, size: 22),
          const SizedBox(height: 6),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, color: KalaColors.charcoal, height: 1.3)),
        ],
      ),
    );
  }

  // ─── ACTIVE OPPORTUNITIES ─────────────────────────────────────────────────
  Widget _buildActiveOpportunities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: _sectionHeader('Active Opportunities')),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _opportunityCard(
                'Music Fest 2026',
                '128 Applicants',
                '10 Positions',
                'Closes in 12 days',
                'https://images.unsplash.com/photo-1429962714451-bb934ecdc4ec?auto=format&fit=crop&q=80&w=300',
              ),
              _opportunityCard(
                'Short Film Casting',
                '245 Applicants',
                '8 Positions',
                'Closes in 6 days',
                'https://images.unsplash.com/photo-1485846234645-a62644f84728?auto=format&fit=crop&q=80&w=300',
              ),
              _opportunityCard(
                'Dance Competition',
                '98 Applicants',
                '12 Positions',
                'Closes in 15 days',
                'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&q=80&w=300',
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }

  Widget _opportunityCard(String title, String applicants, String positions, String closes, String imgUrl) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imgUrl,
              height: 100,
              width: 180,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(height: 100, width: 180, color: KalaColors.softBeige),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 13, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                const SizedBox(height: 6),
                _oppStat(Icons.people_outline, applicants),
                const SizedBox(height: 2),
                _oppStat(Icons.calendar_today_outlined, positions),
                const SizedBox(height: 6),
                Text(closes, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 11, fontWeight: FontWeight.bold, color: KalaColors.burntOrange)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _oppStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 11, color: KalaColors.mediumGrey),
        const SizedBox(width: 4),
        Flexible(child: Text(text, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 11, color: KalaColors.mediumGrey))),
      ],
    );
  }

  // ─── TEAM WORKSPACE ──────────────────────────────────────────────────────
  Widget _buildTeamWorkspace() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: _sectionHeader('Team Workspace')),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _teamMemberCard('Rohan Mehta', 'Admin', 'Full Access', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=100'),
              _teamMemberCard('Ananya Singh', 'Recruitment Lead', 'Full Access', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=100'),
              _teamMemberCard('Karan Malhotra', 'Coordinator', 'Limited Access', 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&q=80&w=100', isLimited: true),
              // Invite card
              Container(
                width: 110,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: KalaColors.lightGrey),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: KalaColors.burntOrange.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: KalaColors.burntOrange, size: 20),
                    ),
                    const SizedBox(height: 10),
                    Text('Invite\nMember', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 11, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }

  Widget _teamMemberCard(String name, String role, String access, String imgUrl, {bool isLimited = false}) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(imgUrl),
            onBackgroundImageError: (_, __) {},
            backgroundColor: KalaColors.softBeige,
          ),
          const SizedBox(height: 10),
          Text(name, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
          const SizedBox(height: 2),
          Text(role, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, color: KalaColors.mediumGrey)),
          const SizedBox(height: 6),
          Text(
            access,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontFamily: 'ZT_Nature', 
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: isLimited ? Colors.orange : KalaColors.accentGreen,
            ),
          ),
        ],
      ),
    );
  }

  // ─── HIRING ANALYTICS ─────────────────────────────────────────────────────
  Widget _buildHiringAnalytics() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Hiring Analytics'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: KalaColors.lightGrey),
            ),
            child: Row(
              children: [
                Expanded(child: _analyticStat('Applications', '2.4K', '+22%')),
                Expanded(child: _analyticStat('Shortlisted', '312', '+18%')),
                Expanded(child: _analyticStat('Interviews', '126', '+14%')),
                Expanded(child: _analyticStat('Hires', '42', '+20%')),
              ],
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _analyticStat(String label, String value, String trend) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, color: KalaColors.mediumGrey)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 18, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
        const SizedBox(height: 4),
        Text(trend, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, fontWeight: FontWeight.bold, color: KalaColors.accentGreen)),
      ],
    );
  }

  // ─── RECENT ACTIVITY ──────────────────────────────────────────────────────
  Widget _buildRecentActivity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Recent Activity'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: KalaColors.lightGrey),
            ),
            child: Column(
              children: [
                _activityRow(Icons.people_outline, '5 new applications received for Music Fest 2026', 'Just now'),
                Divider(height: 1, color: KalaColors.lightGrey),
                _activityRow(Icons.calendar_today_outlined, 'Ritvik Joshi accepted interview invitation', '10m ago'),
                Divider(height: 1, color: KalaColors.lightGrey),
                _activityRow(Icons.person_outline, 'Meera Singh updated her portfolio', '25m ago'),
              ],
            ),
          ),
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
            decoration: BoxDecoration(color: KalaColors.burntOrange.withValues(alpha: 0.08), shape: BoxShape.circle),
            child: Icon(icon, size: 14, color: KalaColors.burntOrange),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, color: KalaColors.charcoal, height: 1.4))),
          const SizedBox(width: 8),
          Text(time, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, color: KalaColors.mediumGrey)),
        ],
      ),
    );
  }

  // ─── HELPERS ──────────────────────────────────────────────────────────────
  Widget _sectionHeader(String title, {bool showViewAll = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(title, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 16, fontWeight: FontWeight.bold, color: KalaColors.charcoal))),
        if (showViewAll)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text('View all', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.burntOrange)),
          ),
      ],
    );
  }
}
