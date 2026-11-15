import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/kala_colors.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../events/presentation/controllers/event_controller.dart';
import '../../../events/domain/models/event_model.dart';
import '../../../opportunities/domain/models/opportunity_model.dart';

class CareerDashboardScreen extends StatefulWidget {
  const CareerDashboardScreen({super.key});

  @override
  State<CareerDashboardScreen> createState() => _CareerDashboardScreenState();
}

class _CareerDashboardScreenState extends State<CareerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Pull the latest backend data when the dashboard first shows so events
    // published on other devices appear even if a realtime event was missed.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<EventController>().refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventController = context.watch<EventController>();

    return Scaffold(
      backgroundColor: KalaColors.ivory,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildQuickActions(),
              const SizedBox(height: 24),
              _buildProfileStrengthCard(),
              const SizedBox(height: 24),
              _buildLiveFromOrganizersSection(context, eventController),
              const SizedBox(height: 24),
              _buildSectionTitle(
                'Recommended For You',
                'Based on your profile & skills',
              ),
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
              _buildSectionTitle(
                'Trending Skills',
                'Add these to your profile to stand out',
              ),
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

  Widget _buildHeader(BuildContext context) {
    final auth = context.read<AuthController>();
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
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.charcoal,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Good morning, ${auth.displayName} 👋',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 14,
                  color: KalaColors.mediumGrey,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              tooltip: 'Refresh',
              onPressed: () => context.read<EventController>().refresh(),
              icon: const Icon(
                Icons.refresh,
                size: 22,
                color: KalaColors.burntOrange,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: KalaColors.lightGrey),
              ),
              child: const Icon(
                Icons.search,
                size: 20,
                color: KalaColors.charcoal,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: KalaColors.lightGrey),
              ),
              child: const Icon(
                Icons.notifications_none,
                size: 20,
                color: KalaColors.charcoal,
              ),
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
          style: TextStyle(
            fontFamily: 'ZT_Nature',
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
              _buildQuickActionBtn(
                'Continue Applications',
                Icons.assignment_outlined,
                false,
              ),
              const SizedBox(width: 12),
              _buildQuickActionBtn(
                'Build Portfolio',
                Icons.add_photo_alternate_outlined,
                false,
              ),
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
            style: TextStyle(
              fontFamily: 'ZT_Nature',
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
            color: Colors.black.withValues(alpha: 0.03),
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
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 12,
                      color: KalaColors.mediumGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Profile Strength',
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
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
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: KalaColors.burntOrange,
                    ),
                  ),
                  Text(
                    'Complete',
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
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
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
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
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
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
          style: TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: KalaColors.charcoal,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 11,
            color: KalaColors.charcoal,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtext,
          style: TextStyle(
            fontFamily: 'ZT_Nature',
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
          style: TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: KalaColors.charcoal,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'ZT_Nature',
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
          style: TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: KalaColors.charcoal,
          ),
        ),
        Text(
          actionLabel,
          style: TextStyle(
            fontFamily: 'ZT_Nature',
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
            color: Colors.black.withValues(alpha: 0.02),
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
                            style: TextStyle(
                              fontFamily: 'ZT_Nature',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: KalaColors.charcoal,
                              height: 1.3,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3ED),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            matchPercentage,
                            style: TextStyle(
                              fontFamily: 'ZT_Nature',
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
                  const Icon(
                    Icons.access_time,
                    size: 14,
                    color: KalaColors.burntOrange,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    daysLeft,
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                ),
                child: Text(
                  'Apply Now',
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
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
        style: TextStyle(
          fontFamily: 'ZT_Nature',
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
          style: TextStyle(
            fontFamily: 'ZT_Nature',
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
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 10,
              color: KalaColors.mediumGrey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'ZT_Nature',
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
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              Text(
                daysAgo,
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 10,
                  color: KalaColors.mediumGrey,
                ),
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
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.charcoal,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
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
                      child: const Icon(
                        Icons.person,
                        size: 14,
                        color: KalaColors.charcoal,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: KalaColors.charcoal,
                          ),
                        ),
                        Text(
                          role,
                          style: TextStyle(
                            fontFamily: 'ZT_Nature',
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
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: KalaColors.charcoal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  views,
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
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
                      style: TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
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
          _buildCommunityCard(
            'Photography Walk',
            'Old Town Heritage',
            'Sat, 7 AM',
          ),
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
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
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
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 11,
                    color: KalaColors.mediumGrey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 12,
                      color: KalaColors.charcoal,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 10,
                        color: KalaColors.charcoal,
                        fontWeight: FontWeight.w500,
                      ),
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
                child: const Icon(
                  Icons.trending_up,
                  size: 16,
                  color: KalaColors.charcoal,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                skill,
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
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
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 11,
                  color: KalaColors.accentGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.chevron_right,
                size: 16,
                color: KalaColors.mediumGrey,
              ),
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
        _buildLearningCard(
          Icons.play_circle_outline,
          'Portfolio Tips',
          'Stand out to recruiters',
        ),
        _buildLearningCard(
          Icons.article_outlined,
          'Resume Templates',
          'Industry standard formats',
        ),
        _buildLearningCard(
          Icons.mic_none,
          'Audition Prep',
          'Nail your next casting',
        ),
        _buildLearningCard(
          Icons.copyright,
          'Copyright Basics',
          'Protect your creative work',
        ),
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
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: KalaColors.charcoal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'ZT_Nature',
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
        _buildSavedItem(
          'Lead Actor — Indie Short',
          'Cinemagic Studios',
          'Closes in 2d',
        ),
        const SizedBox(height: 8),
        _buildSavedItem(
          'Visual Artist Intern',
          'ArtHaus Gallery',
          'Closes in 5d',
        ),
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
                child: const Icon(
                  Icons.bookmark_border,
                  size: 16,
                  color: KalaColors.burntOrange,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: KalaColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    company,
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
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
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 11,
              color: KalaColors.burntOrange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ─── LIVE ORGANIZER DATA (real-time synced) ──────────────────────────────
  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String _formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]}';

  Widget _buildLiveFromOrganizersSection(
    BuildContext context,
    EventController controller,
  ) {
    final events = controller.events;
    final opportunities = controller.opportunities;

    if (events.isEmpty && opportunities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                '🎪 Live From Organizers',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.charcoal,
                ),
              ),
            ),
            Text(
              'Live · RT',
              style: TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: KalaColors.burntOrange,
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              width: 32,
              height: 32,
              child: IconButton(
                padding: EdgeInsets.zero,
                tooltip: 'Refresh live events',
                onPressed:
                    controller.isLoadingData ? null : () => controller.refresh(),
                icon: controller.isLoadingData
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh, size: 20),
                color: KalaColors.burntOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        const Text(
          'Events & auditions published right now by organizers — updates instantly',
          style: TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 11,
            color: KalaColors.mediumGrey,
          ),
        ),
        if (events.isNotEmpty) ...[
          const SizedBox(height: 14),
          SizedBox(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: events.length,
              itemBuilder: (context, index) =>
                  _buildLiveEventCard(context, controller, events[index]),
            ),
          ),
        ],
        if (opportunities.isNotEmpty) ...[
          const SizedBox(height: 14),
          ...opportunities
              .take(3)
              .map(
                (opp) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildLiveOpportunityRow(context, opp),
                ),
              ),
        ],
      ],
    );
  }

  Widget _buildLiveEventCard(
    BuildContext context,
    EventController controller,
    EventModel event,
  ) {
    final opps = controller.getOpportunitiesForEvent(event.eventId);
    final daysLeft = event.registrationDeadline
        .difference(DateTime.now())
        .inDays;

    return GestureDetector(
      onTap: () => _showEventOpportunitiesSheet(context, controller, event),
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 12),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF0EBE1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  event.bannerUrl,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 100,
                    width: double.infinity,
                    color: KalaColors.softBeige,
                    child: const Icon(
                      Icons.event,
                      size: 32,
                      color: KalaColors.mediumGrey,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: KalaColors.burntOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      event.category,
                      style: const TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (daysLeft >= 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        daysLeft == 0
                            ? 'Closing today'
                            : 'Closes in $daysLeft days',
                        style: const TextStyle(
                          fontFamily: 'ZT_Nature',
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
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: KalaColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          event.organizationName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 10,
                            color: KalaColors.mediumGrey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (event.isVerified)
                        const Icon(
                          Icons.verified,
                          size: 12,
                          color: KalaColors.burntOrange,
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: KalaColors.mediumGrey,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${event.venue} • ${event.location}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 10,
                            color: KalaColors.mediumGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: KalaColors.burntOrange,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${_formatDate(event.startDate)} – ${_formatDate(event.endDate)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 10,
                            color: KalaColors.charcoal,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        opps.isEmpty
                            ? 'Auditions coming soon'
                            : '${opps.length} Audition${opps.length == 1 ? '' : 's'}',
                        style: const TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: KalaColors.burntOrange,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: KalaColors.burntOrange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'View Auditions',
                          style: TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveOpportunityRow(BuildContext context, OpportunityModel opp) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/opportunity-detail', arguments: opp),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF0EBE1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF059669).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.mic_none,
                size: 16,
                color: Color(0xFF059669),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    opp.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: KalaColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${opp.stipend} • ${opp.vacancies} vacancy${opp.vacancies == 1 ? '' : 'ies'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 10,
                      color: KalaColors.mediumGrey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: KalaColors.burntOrange,
            ),
          ],
        ),
      ),
    );
  }

  void _showEventOpportunitiesSheet(
    BuildContext context,
    EventController controller,
    EventModel event,
  ) {
    final opps = controller.getOpportunitiesForEvent(event.eventId);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (ctx, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: const TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.charcoal,
                ),
              ),
              const SizedBox(height: 2),
              if (opps.isEmpty)
                const Text(
                  'This event is live on the organizers side. '
                  'No auditions are open yet — stay tuned.',
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 11,
                    color: KalaColors.mediumGrey,
                  ),
                )
              else
                Text(
                  '${opps.length} open audition${opps.length == 1 ? '' : 's'} • tap to apply',
                  style: const TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 11,
                    color: KalaColors.mediumGrey,
                  ),
                ),
              const SizedBox(height: 16),
              Expanded(
                child: opps.isEmpty
                    ? _buildNoOpportunitiesState(ctx, event)
                    : ListView.separated(
                        controller: scrollController,
                        itemCount: opps.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (ctx, i) {
                          final opp = opps[i];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(ctx);
                              Navigator.pushNamed(
                                context,
                                '/opportunity-detail',
                                arguments: opp,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: KalaColors.lightGrey),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          opp.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: 'ZT_Nature',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: KalaColors.charcoal,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          '${opp.category} • ${opp.stipend}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: 'ZT_Nature',
                                            fontSize: 11,
                                            color: KalaColors.mediumGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.chevron_right,
                                    size: 18,
                                    color: KalaColors.burntOrange,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoOpportunitiesState(BuildContext ctx, EventModel event) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: KalaColors.softBeige,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.campaign_outlined,
              size: 30,
              color: KalaColors.burntOrange,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Auditions are being prepared',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: KalaColors.charcoal,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'There are no open roles for "${event.title}" yet.\n'
            'Follow the organizer to get notified when they open.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 12,
              color: KalaColors.mediumGrey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: KalaColors.charcoal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Got it',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
