import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/kala_colors.dart';

class DiscoverMarketplaceScreen extends StatelessWidget {
  const DiscoverMarketplaceScreen({super.key});

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
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildFilterChipsRow(),
              const SizedBox(height: 24),
              _buildYourApplicationsBox(),
              const SizedBox(height: 16),
              _buildSavedOpportunitiesBox(),
              const SizedBox(height: 24),
              _buildSectionTitle('Recommended For You', 'Based on your profile & skills'),
              const SizedBox(height: 16),
              _buildOpportunityCard(
                title: 'National ... Lead Actor — Street Play',
                isVerified: true,
                matchPercentage: '92% Match',
                tags: ['Acting', 'Stage Direction', 'Hindi'],
                location: 'New Delhi',
                pay: '₹ 8K-10K / mo',
                applicants: '47 applied',
                daysLeft: 'Closes in 5 days',
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Trending Now', 'Highest engagement this week'),
              const SizedBox(height: 16),
              _buildOpportunityCard(
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
              _buildSectionTitle('Discover Organizations', 'Production houses, colleges, studios'),
              const SizedBox(height: 16),
              _buildOrganizationsCarousel(),
              const SizedBox(height: 24),
              _buildSectionTitle('Find Creators', 'Collaborate with verified talent'),
              const SizedBox(height: 16),
              _buildCreatorsCarousel(),
              const SizedBox(height: 24),
              _buildSectionTitle('Projects Looking for Team', 'Join independent creative projects'),
              const SizedBox(height: 16),
              _buildProjectsCarousel(),
              const SizedBox(height: 24),
              _buildSectionTitle('Competitions & Festivals', 'Contests, hackathons, showcases'),
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
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.charcoal,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Find opportunities, creators, and orgs.',
                style: GoogleFonts.inter(fontSize: 14, color: KalaColors.mediumGrey),
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
                const Icon(Icons.search, size: 20, color: KalaColors.mediumGrey),
                const SizedBox(width: 8),
                Text(
                  'Search opportunities, creators...',
                  style: GoogleFonts.inter(fontSize: 13, color: KalaColors.mediumGrey),
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
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: KalaColors.charcoal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYourApplicationsBox() {
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
            style: GoogleFonts.inter(
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
              _buildAppStatusItem(Icons.remove_red_eye_outlined, '2 Under\nReview', const Color(0xFF6366F1)),
              _buildAppStatusItem(Icons.check, '1\nShortlisted', KalaColors.accentGreen),
              _buildAppStatusItem(Icons.error_outline, '1\nAction', KalaColors.burntOrange),
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
          style: GoogleFonts.inter(
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
                child: const Icon(Icons.bookmark_border, size: 16, color: KalaColors.burntOrange),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saved Opportunities',
                    style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey),
                  ),
                  Text(
                    '12 saved, 3 deadlines close',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: KalaColors.charcoal,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Icon(Icons.arrow_forward, size: 16, color: KalaColors.burntOrange),
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
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: KalaColors.charcoal,
          ),
        ),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: KalaColors.mediumGrey,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOpportunityCard({
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

  Widget _buildOrganizationsCarousel() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildOrgCard('National School of Drama', 'New Delhi', '12 active\nOpportunities', '48 h\nResponse Rate'),
          const SizedBox(width: 16),
          _buildOrgCard('Zee Music Company', 'Mumbai', '8 active\nOpportunities', '24 h\nResponse Rate'),
        ],
      ),
    );
  }

  Widget _buildOrgCard(String name, String location, String activeOpts, String responseTime) {
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
                child: const Icon(Icons.business, color: KalaColors.charcoal, size: 20),
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
                      style: GoogleFonts.inter(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 12, color: KalaColors.mediumGrey),
              const SizedBox(width: 4),
              Text(
                location,
                style: GoogleFonts.inter(fontSize: 11, color: KalaColors.mediumGrey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                activeOpts,
                style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey, height: 1.4),
              ),
              Text(
                responseTime,
                textAlign: TextAlign.right,
                style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey, height: 1.4),
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
                style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 11),
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
          _buildCreatorCard('Priya Sharma', 'Cinematographer', 'Mumbai', 'Open to: Music Videos, Commercials'),
          const SizedBox(width: 16),
          _buildCreatorCard('Arjun Mehta', 'Music Producer', 'Bangalore', 'Open to: Albums, Background Scores'),
        ],
      ),
    );
  }

  Widget _buildCreatorCard(String name, String role, String location, String openTo) {
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
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, size: 12, color: KalaColors.accentGreen),
                    ],
                  ),
                  Text(
                    '★ Available',
                    style: GoogleFonts.inter(fontSize: 9, color: KalaColors.accentGreen, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(role, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: KalaColors.burntOrange)),
          Text(location, style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey)),
          const SizedBox(height: 12),
          Text(
            openTo,
            style: GoogleFonts.inter(fontSize: 10, color: KalaColors.charcoal, height: 1.4),
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
                style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 11),
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
          _buildProjectCard('Monsoon Film Festival — Short Film', ['Cinematographer', 'Sound Designer'], '2 weeks timeline', 'Paid'),
          const SizedBox(width: 16),
          _buildProjectCard('Indie Music Video', ['Dancer', 'Editor'], '3 weeks timeline', 'Unpaid'),
        ],
      ),
    );
  }

  Widget _buildProjectCard(String title, List<String> roles, String timeline, String payType) {
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
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: const Center(child: Icon(Icons.movie_creation, color: Colors.white38, size: 32)),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: roles.map((r) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: KalaColors.ivory,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: KalaColors.softBeige),
                      ),
                      child: Text(r, style: GoogleFonts.inter(fontSize: 9, color: KalaColors.charcoal)),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(timeline, style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey)),
                    Text(
                      '₹ $payType',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: payType == 'Paid' ? KalaColors.accentGreen : KalaColors.mediumGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Led by BMM Film Club', style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey)),
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

  Widget _buildCompetitionsCarousel() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCompetitionCard('National Dance Championship', 'Ministry of Culture', 'Jul 31, 2025', '₹1,00,000 Pool', 'Offline'),
          const SizedBox(width: 16),
          _buildCompetitionCard('Photography Hackathon', 'National Institute of Photography', 'Aug 15, 2025', '₹50,000 Pool', 'Online'),
        ],
      ),
    );
  }

  Widget _buildCompetitionCard(String title, String org, String deadline, String prize, String mode) {
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
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Stack(
              children: [
                const Center(child: Icon(Icons.emoji_events, color: Colors.white38, size: 40)),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const Icon(Icons.confirmation_num, size: 10, color: Colors.white),
                        const SizedBox(width: 4),
                        Text('12 Tickets', style: GoogleFonts.inter(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
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
                Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: KalaColors.charcoal), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(org, style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Registration', style: GoogleFonts.inter(fontSize: 9, color: KalaColors.mediumGrey)),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 10, color: KalaColors.burntOrange),
                            const SizedBox(width: 2),
                            Text(deadline, style: GoogleFonts.inter(fontSize: 10, color: KalaColors.burntOrange, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Prize Pool', style: GoogleFonts.inter(fontSize: 9, color: KalaColors.mediumGrey)),
                        Text(prize, style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mutedGold, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Mode', style: GoogleFonts.inter(fontSize: 9, color: KalaColors.mediumGrey)),
                    Text(mode, style: GoogleFonts.inter(fontSize: 10, color: KalaColors.charcoal, fontWeight: FontWeight.bold)),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text('Register Now', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 11)),
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
        _buildLearningCard(Icons.play_circle_outline, 'Portfolio Guide', '5 tips to stand out'),
        _buildLearningCard(Icons.mic_none, 'Audition Prep', 'Common questions'),
        _buildLearningCard(Icons.account_balance, 'Grants & Funding', 'Financial support options'),
        _buildLearningCard(Icons.campaign, 'Branding Tips', 'Build your personal brand'),
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
}
