import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/kala_colors.dart';

class CareerDashboardScreen extends StatelessWidget {
  const CareerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KalaColors.ivory,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildQuickActions(),
              const SizedBox(height: 24),
              _buildProfileStrengthCard(),
              const SizedBox(height: 24),
              _buildSectionTitle('Recommended For You', 'Based on your profile & skills'),
              const SizedBox(height: 16),
              _buildRecommendedOpportunityCard(
                title: 'National ... Lead Actor — Street Play',
                isVerified: true,
                matchPercentage: '92% Match',
                tags: ['Acting', 'Stage Direction', 'Hindi'],
                location: 'New Delhi',
                pay: '₹ 8K-10K / mo',
                applicants: '47 applied',
                daysLeft: 'Closes in 5 days',
              ),
              const SizedBox(height: 16),
              _buildRecommendedOpportunityCard(
                title: 'Zee Music Company ... Playback Singer (Hindi)',
                isVerified: true,
                matchPercentage: '87% Match',
                tags: ['Playback Singing', 'Hindi', 'Classical'],
                location: 'Mumbai, Remote',
                pay: '₹ 15K-20K / mo',
                applicants: '112 applied',
                daysLeft: 'Closes in 7 days',
              ),
              const SizedBox(height: 24),
              _buildSectionTitleWithAction('My Applications', 'View All'),
              const SizedBox(height: 16),
              _buildMyApplicationsCarousel(),
              const SizedBox(height: 24),
              _buildSectionTitleWithAction('Upcoming Deadlines', 'View All'),
              const SizedBox(height: 16),
              _buildUpcomingDeadlinesCard(),
              const SizedBox(height: 24),
              _buildSectionTitleWithAction('Featured Creators', 'Discover'),
              const SizedBox(height: 16),
              _buildFeaturedCreatorsCarousel(),
              const SizedBox(height: 24),
              _buildSectionTitleWithAction('Campus & Community', 'Explore'),
              const SizedBox(height: 16),
              _buildCampusCommunityCarousel(),
              const SizedBox(height: 24),
              _buildSectionTitle('Trending Skills', 'Add these to your profile to stand out'),
              const SizedBox(height: 16),
              _buildTrendingSkillsList(),
              const SizedBox(height: 24),
              _buildSectionTitleWithAction('Learning & Growth', 'View All'),
              const SizedBox(height: 16),
              _buildLearningAndGrowthGrid(),
              const SizedBox(height: 24),
              _buildSectionTitleWithAction('Recently Saved', 'View All'),
              const SizedBox(height: 16),
              _buildRecentlySavedList(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Dashboard',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.charcoal,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Good morning, Arjun Mehta 👋',
                style: GoogleFonts.inter(fontSize: 14, color: KalaColors.mediumGrey),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: KalaColors.lightGrey),
              ),
              child: const Icon(Icons.search, size: 20, color: KalaColors.charcoal),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: KalaColors.lightGrey),
              ),
              child: const Icon(Icons.notifications_none, size: 20, color: KalaColors.charcoal),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QUICK ACTIONS',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: KalaColors.mediumGrey,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildQuickActionBtn('Find Auditions', Icons.mic_none, true),
              const SizedBox(width: 12),
              _buildQuickActionBtn('Continue Applications', Icons.assignment_outlined, false),
              const SizedBox(width: 12),
              _buildQuickActionBtn('Build Portfolio', Icons.add_photo_alternate_outlined, false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionBtn(String label, IconData icon, bool isPrimary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isPrimary ? KalaColors.burntOrange : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isPrimary ? null : Border.all(color: KalaColors.lightGrey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isPrimary ? Colors.white : KalaColors.charcoal,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isPrimary ? Colors.white : KalaColors.charcoal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStrengthCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complete your profile',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: KalaColors.mediumGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Profile Strength',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: KalaColors.charcoal,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '82%',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: KalaColors.burntOrange,
                    ),
                  ),
                  Text(
                    'Complete',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: KalaColors.mediumGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.82,
              backgroundColor: KalaColors.softBeige,
              valueColor: AlwaysStoppedAnimation<Color>(KalaColors.burntOrange),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('7', 'Applications', '12 this week'),
              _buildStatItem('2', 'Shortlisted', 'In progress'),
              _buildStatItem('143', 'Profile Views', '+18 this week'),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KalaColors.burntOrange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Complete Profile',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: KalaColors.charcoal,
                    side: const BorderSide(color: KalaColors.lightGrey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Improve Portfolio',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String count, String label, String subtext) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          count,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: KalaColors.charcoal,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: KalaColors.charcoal,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtext,
          style: GoogleFonts.inter(
            fontSize: 9,
            color: KalaColors.accentGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: KalaColors.charcoal,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: KalaColors.mediumGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitleWithAction(String title, String actionLabel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: KalaColors.charcoal,
          ),
        ),
        Text(
          actionLabel,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: KalaColors.burntOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedOpportunityCard({
    required String title,
    required bool isVerified,
    required String matchPercentage,
    required List<String> tags,
    required String location,
    required String pay,
    required String applicants,
    required String daysLeft,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0EBE1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: KalaColors.softBeige,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.business, color: KalaColors.charcoal),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: KalaColors.charcoal,
                              height: 1.3,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3ED),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            matchPercentage,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: KalaColors.burntOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: tags.map((tag) => _buildTag(tag)).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconText(Icons.location_on_outlined, location),
              _buildIconText(Icons.account_balance_wallet_outlined, pay),
              _buildIconText(Icons.people_outline, applicants),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, color: KalaColors.lightGrey),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: KalaColors.burntOrange),
                  const SizedBox(width: 6),
                  Text(
                    daysLeft,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: KalaColors.burntOrange,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: KalaColors.burntOrange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                ),
                child: Text(
                  'Apply Now',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: KalaColors.ivory,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEAE2B7)),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: KalaColors.charcoal,
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: KalaColors.mediumGrey),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: KalaColors.mediumGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildMyApplicationsCarousel() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildApplicationMiniCard(
            title: 'Lead Actor',
            company: 'National School of Drama',
            status: 'Under Review',
            daysAgo: '12 days ago',
            statusColor: KalaColors.mutedGold,
          ),
          const SizedBox(width: 12),
          _buildApplicationMiniCard(
            title: 'Playback Singer',
            company: 'Zee Music Company',
            status: 'Interview Scheduled',
            daysAgo: '2 days ago',
            statusColor: KalaColors.burntOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationMiniCard({
    required String title,
    required String company,
    required String status,
    required String daysAgo,
    required Color statusColor,
  }) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            company,
            style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: KalaColors.charcoal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              Text(
                daysAgo,
                style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingDeadlinesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Column(
        children: [
          _buildDeadlineItem(
            color: KalaColors.burntOrange,
            title: 'Audition closes in 2 days',
            subtitle: 'National School of Drama — Street Play',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: KalaColors.lightGrey),
          ),
          _buildDeadlineItem(
            color: KalaColors.charcoal,
            title: 'Interview scheduled',
            subtitle: 'Zee Music Company — Playback Singer • 18 May',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: KalaColors.lightGrey),
          ),
          _buildDeadlineItem(
            color: KalaColors.mutedGold,
            title: 'Workshop begins',
            subtitle: 'Cinematography Masterclass — Tomorrow',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: KalaColors.lightGrey),
          ),
          _buildDeadlineItem(
            color: KalaColors.accentGreen,
            title: 'Document required',
            subtitle: 'Upload identity proof for Dance Audition',
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlineItem({
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.charcoal,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: KalaColors.mediumGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCreatorsCarousel() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCreatorCard(
            name: 'Priya Sharma',
            role: 'Cinematographer',
            featuredProject: 'Monsoon Rhapsody',
            views: '3.2K views',
          ),
          const SizedBox(width: 16),
          _buildCreatorCard(
            name: 'Kabir Singh',
            role: 'Music Producer',
            featuredProject: 'Neon Dreams EP',
            views: '1.8K views',
          ),
        ],
      ),
    );
  }

  Widget _buildCreatorCard({
    required String name,
    required String role,
    required String featuredProject,
    required String views,
  }) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: const BoxDecoration(
              color: KalaColors.charcoal,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: const Center(
              child: Icon(Icons.image, color: Colors.white38, size: 40),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: KalaColors.softBeige,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, size: 14, color: KalaColors.charcoal),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: KalaColors.charcoal,
                          ),
                        ),
                        Text(
                          role,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: KalaColors.mediumGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  featuredProject,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: KalaColors.charcoal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  views,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: KalaColors.mutedGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: KalaColors.burntOrange,
                      side: const BorderSide(color: KalaColors.burntOrange),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text(
                      'View Portfolio',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampusCommunityCarousel() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCommunityCard('Open Mic Night', 'The Q Cafe', 'Today, 8 PM'),
          const SizedBox(width: 16),
          _buildCommunityCard('Photography Walk', 'Old Town Heritage', 'Sat, 7 AM'),
        ],
      ),
    );
  }

  Widget _buildCommunityCard(String title, String location, String time) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: const BoxDecoration(
              color: KalaColors.charcoal,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: const Center(
              child: Icon(Icons.event, color: Colors.white38, size: 32),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: KalaColors.charcoal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: GoogleFonts.inter(fontSize: 11, color: KalaColors.mediumGrey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 12, color: KalaColors.charcoal),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: GoogleFonts.inter(fontSize: 10, color: KalaColors.charcoal, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingSkillsList() {
    return Column(
      children: [
        _buildSkillItem('Playback Singing', '28 ops'),
        const SizedBox(height: 8),
        _buildSkillItem('Video Editing', '45 ops'),
        const SizedBox(height: 8),
        _buildSkillItem('Street Photography', '12 ops'),
        const SizedBox(height: 8),
        _buildSkillItem('Content Writing', '89 ops'),
      ],
    );
  }

  Widget _buildSkillItem(String skill, String opsCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: KalaColors.softBeige,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.trending_up, size: 16, color: KalaColors.charcoal),
              ),
              const SizedBox(width: 12),
              Text(
                skill,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: KalaColors.charcoal,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                opsCount,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: KalaColors.accentGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.chevron_right, size: 16, color: KalaColors.mediumGrey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLearningAndGrowthGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        _buildLearningCard(Icons.play_circle_outline, 'Portfolio Tips', 'Stand out to recruiters'),
        _buildLearningCard(Icons.article_outlined, 'Resume Templates', 'Industry standard formats'),
        _buildLearningCard(Icons.mic_none, 'Audition Prep', 'Nail your next casting'),
        _buildLearningCard(Icons.copyright, 'Copyright Basics', 'Protect your creative work'),
      ],
    );
  }

  Widget _buildLearningCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6ECE6), // Light warm tint
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: KalaColors.burntOrange),
          const SizedBox(height: 8),
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
              fontSize: 9,
              color: KalaColors.mediumGrey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentlySavedList() {
    return Column(
      children: [
        _buildSavedItem('Lead Actor — Indie Short', 'Cinemagic Studios', 'Closes in 2d'),
        const SizedBox(height: 8),
        _buildSavedItem('Visual Artist Intern', 'ArtHaus Gallery', 'Closes in 5d'),
        const SizedBox(height: 8),
        _buildSavedItem('Session Guitarist', 'Neon Records', 'Closes in 1w'),
      ],
    );
  }

  Widget _buildSavedItem(String title, String company, String closesIn) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: KalaColors.softBeige,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.bookmark_border, size: 16, color: KalaColors.burntOrange),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: KalaColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    company,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: KalaColors.mediumGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            closesIn,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: KalaColors.burntOrange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
