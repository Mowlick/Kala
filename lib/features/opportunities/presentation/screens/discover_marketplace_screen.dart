import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../../../events/presentation/controllers/event_controller.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../applications/domain/models/application_status.dart';
import '../../../opportunities/domain/models/opportunity_model.dart';

class DiscoverMarketplaceScreen extends StatefulWidget {
  const DiscoverMarketplaceScreen({super.key});

  @override
  State<DiscoverMarketplaceScreen> createState() =>
      _DiscoverMarketplaceScreenState();
}

class _DiscoverMarketplaceScreenState extends State<DiscoverMarketplaceScreen> {
  final String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EventController>();
    final auth = context.watch<AuthController>();
    final allOpportunities = controller.opportunities;
    final filtered = _selectedFilter == 'All'
        ? allOpportunities
        : allOpportunities.where((o) => o.category == _selectedFilter).toList();
    final mySubmissions = auth.currentUserId.isNotEmpty
        ? controller.submissions
              .where((s) => s.studentId == auth.currentUserId)
              .toList()
        : controller.submissions;
    final underReview = mySubmissions
        .where(
          (s) =>
              s.status == ApplicationStatus.underReview ||
              s.status == ApplicationStatus.interview,
        )
        .length;
    final shortlisted = mySubmissions
        .where((s) => s.status == ApplicationStatus.selected)
        .length;

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
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildFilterChipsRow(),
              const SizedBox(height: 24),
              _buildYourApplicationsBox(
                underReview,
                shortlisted,
                mySubmissions.length,
              ),
              const SizedBox(height: 16),
              _buildSavedOpportunitiesBox(),
              const SizedBox(height: 24),

              // ── LIVE OPPORTUNITIES from EventController (Supabase-backed) ──
              if (controller.isLoadingData && filtered.isEmpty) ...[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(
                      color: KalaColors.burntOrange,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ] else if (filtered.isEmpty) ...[
                _buildEmptyState(),
                const SizedBox(height: 24),
              ] else ...[
                _buildSectionTitle(
                  '🔴 Live Opportunities',
                  'Published right now — apply before they close',
                ),
                const SizedBox(height: 16),
                ...filtered.map(
                  (opp) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildLiveOpportunityCard(context, opp),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              const SizedBox(height: 8),
              _buildSectionTitle(
                'Discover Organizations',
                'Production houses, colleges, studios',
              ),
              const SizedBox(height: 16),
              _buildOrganizationsCarousel(),
              const SizedBox(height: 24),
              _buildSectionTitle(
                'Find Creators',
                'Collaborate with verified talent',
              ),
              const SizedBox(height: 16),
              _buildCreatorsCarousel(),
              const SizedBox(height: 24),
              _buildSectionTitle(
                'Projects Looking for Team',
                'Join independent creative projects',
              ),
              const SizedBox(height: 16),
              _buildProjectsCarousel(),
              const SizedBox(height: 24),
              _buildSectionTitle(
                'Competitions & Festivals',
                'Contests, hackathons, showcases',
              ),
              const SizedBox(height: 16),
              _buildCompetitionsCarousel(),
              const SizedBox(height: 24),
              _buildSectionTitle('Learning & Career Resources', ''),
              const SizedBox(height: 16),
              _buildLearningAndGrowthGrid(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ── Live opportunity card from EventController data ────────────────────────
  Widget _buildLiveOpportunityCard(BuildContext context, OpportunityModel opp) {
    final daysLeft = opp.deadline.difference(DateTime.now()).inDays;
    final daysText = daysLeft > 0
        ? 'Closes in $daysLeft day${daysLeft == 1 ? '' : 's'}'
        : 'Closing today!';
    final statusColor = opp.status == 'Open'
        ? KalaColors.accentGreen
        : KalaColors.burntOrange;

    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/opportunity-detail', arguments: opp),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: KalaColors.accentGreen.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: KalaColors.accentGreen.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        opp.status,
                        style: TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: KalaColors.burntOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    opp.category,
                    style: const TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: KalaColors.burntOrange,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(Icons.verified, size: 16, color: KalaColors.burntOrange),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              opp.title,
              style: const TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: KalaColors.charcoal,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.payments_outlined,
                  size: 14,
                  color: KalaColors.mediumGrey,
                ),
                const SizedBox(width: 4),
                Text(
                  opp.stipend,
                  style: const TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 12,
                    color: KalaColors.mediumGrey,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.people_outline,
                  size: 14,
                  color: KalaColors.mediumGrey,
                ),
                const SizedBox(width: 4),
                Text(
                  '${opp.vacancies} spot${opp.vacancies == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 12,
                    color: KalaColors.mediumGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_outlined,
                      size: 13,
                      color: KalaColors.burntOrange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      daysText,
                      style: const TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 12,
                        color: KalaColors.burntOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: KalaColors.charcoal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Apply Now',
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
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
                'Discover',
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
                'Find opportunities, creators, and orgs.',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 14,
                  color: KalaColors.mediumGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: KalaColors.lightGrey),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                  size: 20,
                  color: KalaColors.mediumGrey,
                ),
                const SizedBox(width: 8),
                Text(
                  'Search opportunities, creators...',
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 13,
                    color: KalaColors.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: KalaColors.lightGrey),
          ),
          child: const Icon(Icons.tune, size: 20, color: KalaColors.charcoal),
        ),
      ],
    );
  }

  Widget _buildFilterChipsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('Trending', Icons.trending_up),
          const SizedBox(width: 8),
          _buildFilterChip('Near You', Icons.location_on_outlined),
          const SizedBox(width: 8),
          _buildFilterChip('Paid', Icons.attach_money),
          const SizedBox(width: 8),
          _buildFilterChip('Remote', Icons.laptop_mac),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: KalaColors.softBeige,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: KalaColors.charcoal),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: KalaColors.charcoal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYourApplicationsBox(int inProgress, int selected, int total) {
    return Container(
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
            'YOUR APPLICATIONS',
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: KalaColors.mediumGrey,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAppStatusItem(
                Icons.description_outlined,
                '$inProgress In\nProgress',
                const Color(0xFF6366F1),
              ),
              _buildAppStatusItem(
                Icons.check,
                '$selected\nSelected',
                KalaColors.accentGreen,
              ),
              _buildAppStatusItem(
                Icons.history_edu_outlined,
                '$total\nTotal',
                KalaColors.burntOrange,
              ),
              const Icon(Icons.chevron_right, color: KalaColors.mediumGrey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppStatusItem(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: KalaColors.charcoal,
          ),
        ),
      ],
    );
  }

  Widget _buildSavedOpportunitiesBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6ECE6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
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
                    'Saved Opportunities',
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 10,
                      color: KalaColors.mediumGrey,
                    ),
                  ),
                  Text(
                    '12 saved, 3 deadlines close',
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: KalaColors.charcoal,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Icon(
            Icons.arrow_forward,
            size: 16,
            color: KalaColors.burntOrange,
          ),
        ],
      ),
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
        if (subtitle.isNotEmpty) ...[
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
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: KalaColors.softBeige,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.explore_outlined,
              size: 32,
              color: KalaColors.burntOrange,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No live opportunities right now',
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: KalaColors.charcoal,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Organizers publish new openings here in real time.\nPull down or tap refresh to check again.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 12,
              color: KalaColors.mediumGrey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrganizationsCarousel() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildOrgCard(
            'National School of Drama',
            'New Delhi',
            '12 active\nOpportunities',
            '48 h\nResponse Rate',
          ),
          const SizedBox(width: 16),
          _buildOrgCard(
            'Zee Music Company',
            'Mumbai',
            '8 active\nOpportunities',
            '24 h\nResponse Rate',
          ),
        ],
      ),
    );
  }

  Widget _buildOrgCard(
    String name,
    String location,
    String activeOpts,
    String responseTime,
  ) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: KalaColors.softBeige,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.business,
                  color: KalaColors.charcoal,
                  size: 20,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: KalaColors.accentGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check, size: 10, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      'Verified',
                      style: TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 9,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: KalaColors.charcoal,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 12,
                color: KalaColors.mediumGrey,
              ),
              const SizedBox(width: 4),
              Text(
                location,
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 11,
                  color: KalaColors.mediumGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                activeOpts,
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 10,
                  color: KalaColors.mediumGrey,
                  height: 1.4,
                ),
              ),
              Text(
                responseTime,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 10,
                  color: KalaColors.mediumGrey,
                  height: 1.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: KalaColors.burntOrange,
                side: const BorderSide(color: KalaColors.softBeige),
                backgroundColor: KalaColors.ivory,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: Text(
                'View Organization',
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
    );
  }

  Widget _buildCreatorsCarousel() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCreatorCard(
            'Priya Sharma',
            'Cinematographer',
            'Mumbai',
            'Open to: Music Videos, Commercials',
          ),
          const SizedBox(width: 16),
          _buildCreatorCard(
            'Arjun Mehta',
            'Music Producer',
            'Bangalore',
            'Open to: Albums, Background Scores',
          ),
        ],
      ),
    );
  }

  Widget _buildCreatorCard(
    String name,
    String role,
    String location,
    String openTo,
  ) {
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
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: KalaColors.charcoal,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.white38),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: KalaColors.charcoal,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified,
                        size: 12,
                        color: KalaColors.accentGreen,
                      ),
                    ],
                  ),
                  Text(
                    '★ Available',
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 9,
                      color: KalaColors.accentGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            role,
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: KalaColors.burntOrange,
            ),
          ),
          Text(
            location,
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 10,
              color: KalaColors.mediumGrey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            openTo,
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 10,
              color: KalaColors.charcoal,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: KalaColors.burntOrange,
                side: const BorderSide(color: KalaColors.softBeige),
                backgroundColor: KalaColors.ivory,
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
    );
  }

  Widget _buildProjectsCarousel() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildProjectCard(
            'Monsoon Film Festival — Short Film',
            ['Cinematographer', 'Sound Designer'],
            '2 weeks timeline',
            'Paid',
          ),
          const SizedBox(width: 16),
          _buildProjectCard(
            'Indie Music Video',
            ['Dancer', 'Editor'],
            '3 weeks timeline',
            'Unpaid',
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(
    String title,
    List<String> roles,
    String timeline,
    String payType,
  ) {
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
            height: 100,
            decoration: const BoxDecoration(
              color: KalaColors.charcoal,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.movie_creation,
                color: Colors.white38,
                size: 32,
              ),
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
                const SizedBox(height: 8),
                Row(
                  children: roles
                      .map(
                        (r) => Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: KalaColors.ivory,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: KalaColors.softBeige),
                            ),
                            child: Text(
                              r,
                              style: TextStyle(
                                fontFamily: 'ZT_Nature',
                                fontSize: 9,
                                color: KalaColors.charcoal,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timeline,
                      style: TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 10,
                        color: KalaColors.mediumGrey,
                      ),
                    ),
                    Text(
                      '₹ $payType',
                      style: TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 10,
                        color: payType == 'Paid'
                            ? KalaColors.accentGreen
                            : KalaColors.mediumGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Led by BMM Film Club',
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 10,
                    color: KalaColors.mediumGrey,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: KalaColors.burntOrange,
                      side: const BorderSide(color: KalaColors.softBeige),
                      backgroundColor: KalaColors.ivory,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text(
                      'View Project',
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

  Widget _buildCompetitionsCarousel() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCompetitionCard(
            'National Dance Championship',
            'Ministry of Culture',
            'Jul 31, 2025',
            '₹1,00,000 Pool',
            'Offline',
          ),
          const SizedBox(width: 16),
          _buildCompetitionCard(
            'Photography Hackathon',
            'National Institute of Photography',
            'Aug 15, 2025',
            '₹50,000 Pool',
            'Online',
          ),
        ],
      ),
    );
  }

  Widget _buildCompetitionCard(
    String title,
    String org,
    String deadline,
    String prize,
    String mode,
  ) {
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
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.emoji_events,
                    color: Colors.white38,
                    size: 40,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.confirmation_num,
                          size: 10,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '12 Tickets',
                          style: TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 9,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
                  org,
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 10,
                    color: KalaColors.mediumGrey,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Registration',
                          style: TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 9,
                            color: KalaColors.mediumGrey,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 10,
                              color: KalaColors.burntOrange,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              deadline,
                              style: TextStyle(
                                fontFamily: 'ZT_Nature',
                                fontSize: 10,
                                color: KalaColors.burntOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Prize Pool',
                          style: TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 9,
                            color: KalaColors.mediumGrey,
                          ),
                        ),
                        Text(
                          prize,
                          style: TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 10,
                            color: KalaColors.mutedGold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mode',
                      style: TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 9,
                        color: KalaColors.mediumGrey,
                      ),
                    ),
                    Text(
                      mode,
                      style: TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 10,
                        color: KalaColors.charcoal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: KalaColors.burntOrange,
                      side: const BorderSide(color: KalaColors.softBeige),
                      backgroundColor: KalaColors.ivory,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text(
                      'Register Now',
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
          'Portfolio Guide',
          '5 tips to stand out',
        ),
        _buildLearningCard(Icons.mic_none, 'Audition Prep', 'Common questions'),
        _buildLearningCard(
          Icons.account_balance,
          'Grants & Funding',
          'Financial support options',
        ),
        _buildLearningCard(
          Icons.campaign,
          'Branding Tips',
          'Build your personal brand',
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
}
