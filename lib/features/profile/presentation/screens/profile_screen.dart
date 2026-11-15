import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KalaColors.ivory,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(
                      context.read<AuthController>().displayName,
                    ),
                    const SizedBox(height: 16),
                    _buildRoleTags(),
                    const SizedBox(height: 16),
                    _buildAvailableForTags(),
                    const SizedBox(height: 16),
                    Text(
                      'Passionate musician blending soulful vocals with meaningful lyrics. Performing across genres and creating music that connects.',
                      style: TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 12,
                        color: KalaColors.charcoal,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSocialLinks(),
                    const SizedBox(height: 24),
                    _buildStatsRow(),
                    const SizedBox(height: 24),
                    const SizedBox(height: 24),
                    _buildProfileCompletionBox(),
                    const SizedBox(height: 24),
                    _buildTabBar(),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () => _showLogoutConfirmationDialog(context),
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: Colors.redAccent,
                          size: 18,
                        ),
                        label: const Text(
                          'Log Out',
                          style: TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.redAccent),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPortfolioTab(),
                    const Center(child: Text('Applications Tab Content')),
                    const Center(child: Text('Timeline Tab Content')),
                    const Center(child: Text('Skills Tab Content')),
                    const Center(child: Text('About Tab Content')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: KalaColors.ivory,
      elevation: 0,
      pinned: true,
      leading: IconButton(
        icon: const Icon(
          Icons.chevron_left,
          color: KalaColors.charcoal,
          size: 28,
        ),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.edit_outlined,
            color: KalaColors.charcoal,
            size: 20,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            Icons.logout_rounded,
            color: Colors.redAccent,
            size: 22,
          ),
          tooltip: 'Log Out',
          onPressed: () => _showLogoutConfirmationDialog(context),
        ),
      ],
    );
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.redAccent, size: 22),
            SizedBox(width: 8),
            Text(
              'Log Out',
              style: TextStyle(
                fontFamily: 'ZT_Nature',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: KalaColors.charcoal,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to log out of your Kalā account?',
          style: TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 14,
            color: KalaColors.charcoal,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: KalaColors.mediumGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Log Out',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final navigator = Navigator.of(context);
      await context.read<AuthController>().signOut();
      navigator.pushNamedAndRemoveUntil('/', (_) => false);
    }
  }

  Widget _buildProfileHeader(String displayName) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFDE6D8), width: 3),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=200',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 18,
                color: KalaColors.accentGreen,
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: KalaColors.charcoal,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.verified,
                    size: 18,
                    color: Color(0xFFEA580C),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Singer • Songwriter • Guitarist',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 12,
                  color: KalaColors.charcoal,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: KalaColors.mediumGrey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Delhi, India',
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 12,
                      color: KalaColors.mediumGrey,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: KalaColors.accentGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Available',
                      style: TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: KalaColors.accentGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleTags() {
    final roles = ['Singer', 'Guitarist', 'Songwriter', '+2'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: roles.map((role) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF6F3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF5EBE0)),
          ),
          child: Text(
            role,
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: KalaColors.charcoal,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAvailableForTags() {
    final tags = ['Auditions', 'Paid Gigs', 'Collaborations', '+2'];
    return Row(
      children: [
        Text(
          'Available For',
          style: TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: KalaColors.charcoal,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: tags.map((tag) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: KalaColors.accentGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: KalaColors.accentGreen,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLinks() {
    return Row(
      children: [
        const Icon(Icons.link, size: 18, color: KalaColors.charcoal),
        const SizedBox(width: 16),
        const Icon(
          Icons.camera_alt_outlined,
          size: 18,
          color: KalaColors.charcoal,
        ),
        const SizedBox(width: 16),
        const Icon(Icons.play_circle_outline, size: 18, color: Colors.red),
        const SizedBox(width: 16),
        const Icon(Icons.headphones_outlined, size: 18, color: Colors.green),
        const SizedBox(width: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: KalaColors.lightGrey),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.mail_outline,
                size: 14,
                color: KalaColors.charcoal,
              ),
              const SizedBox(width: 6),
              Text(
                'Show Contact',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: KalaColors.charcoal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem(
          '32',
          'Applications',
          Icons.description_outlined,
          const Color(0xFFEA580C),
        ),
        _buildStatItem(
          '14',
          'Shortlisted',
          Icons.visibility_outlined,
          const Color(0xFFEA580C),
        ),
        _buildStatItem(
          '8',
          'Projects',
          Icons.star_border,
          const Color(0xFFEA580C),
        ),
        _buildStatItem(
          '3.2K',
          'Views',
          Icons.trending_up,
          const Color(0xFFEA580C),
        ),
        _buildProfileStrengthStat(),
      ],
    );
  }

  Widget _buildStatItem(
    String count,
    String label,
    IconData icon,
    Color iconColor,
  ) {
    return Column(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(height: 8),
        Text(
          count,
          style: TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: KalaColors.charcoal,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 10,
            color: KalaColors.mediumGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileStrengthStat() {
    return Column(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            value: 0.92,
            strokeWidth: 3,
            backgroundColor: KalaColors.accentGreen.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(
              KalaColors.accentGreen,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '92%',
          style: TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: KalaColors.charcoal,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Profile Strength',
          style: TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 10,
            color: KalaColors.mediumGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCompletionBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFEDD5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Complete your profile',
                      style: TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: KalaColors.charcoal,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(82%)',
                      style: TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFEA580C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.82,
                    backgroundColor: Color(0xFFFFEDD5),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFEA580C),
                    ),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildCheckItem('Add Resume', true),
                          const SizedBox(height: 8),
                          _buildCheckItem('Upload Showreel', true),
                          const SizedBox(height: 8),
                          _buildCheckItem('Verify College', true),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          _buildCheckItem('Add Languages', true),
                          const SizedBox(height: 8),
                          _buildCheckItem('Upload Certificates', false),
                          const SizedBox(height: 24), // alignment spacer
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Illustration Placeholder
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 60,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFFEDD5), width: 2),
                ),
                child: Column(
                  children: [
                    Container(height: 8, color: const Color(0xFFFDBA74)),
                    const SizedBox(height: 8),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFFFEDD5)),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 16,
                        color: Color(0xFFFDBA74),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 4,
                      width: 40,
                      color: const Color(0xFFFFEDD5),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 4,
                      width: 30,
                      color: const Color(0xFFFFEDD5),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: -4,
                bottom: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFDBA74),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.star, size: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String label, bool isChecked) {
    return Row(
      children: [
        Icon(
          isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 14,
          color: isChecked ? KalaColors.accentGreen : KalaColors.lightGrey,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 10,
            color: KalaColors.charcoal,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: KalaColors.lightGrey)),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: const Color(0xFFEA580C),
        unselectedLabelColor: KalaColors.mediumGrey,
        indicatorColor: const Color(0xFFEA580C),
        indicatorWeight: 2,
        labelStyle: TextStyle(
          fontFamily: 'ZT_Nature',
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'ZT_Nature',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Portfolio'),
          Tab(text: 'Applications'),
          Tab(text: 'Timeline'),
          Tab(text: 'Skills'),
          Tab(text: 'About'),
        ],
      ),
    );
  }

  Widget _buildPortfolioTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Work',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.charcoal,
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFEA580C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: [
                _buildFeaturedWorkCard(
                  'Original Song – Dil Se',
                  '3.2K views • Music',
                  '3:45',
                  'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&q=80&w=300',
                ),
                const SizedBox(width: 12),
                _buildFeaturedWorkCard(
                  'Short Film – Raaste',
                  '1.8K views • Film',
                  '12:30',
                  'https://images.unsplash.com/photo-1485846234645-a62644f84728?auto=format&fit=crop&q=80&w=300',
                ),
                const SizedBox(width: 12),
                _buildFeaturedWorkCard(
                  'Dance Performance – Nritya 2025',
                  '2.6K views • Dance',
                  '2:18',
                  'https://images.unsplash.com/photo-1547153760-18fc86324498?auto=format&fit=crop&q=80&w=300',
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Applications',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.charcoal,
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFEA580C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildAppStatBox(
                    '3',
                    'Under\nReview',
                    const Color(0xFFEA580C),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildAppStatBox(
                    '2',
                    'Short-\nlisted',
                    KalaColors.accentGreen,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildAppStatBox(
                    '1',
                    'Inter-\nview',
                    const Color(0xFFEA580C),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildAppStatBox(
                    '0',
                    'Selected',
                    KalaColors.accentGreen,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(child: _buildAppStatBox('1', 'Rejected', Colors.red)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Career Timeline',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.charcoal,
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFEA580C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCareerTimelineItem(
            '2025',
            'Won Inter College Singing Competition',
            'March 2025',
            isLast: false,
          ),
          _buildCareerTimelineItem(
            '2025',
            'Accepted into Delhi Music Fest',
            'April 2025',
            isLast: false,
          ),
          _buildCareerTimelineItem(
            '2025',
            'Performed at IIT Cultural Fest',
            'May 2025',
            isLast: true,
          ),
          const SizedBox(height: 32),
          _buildBottomProfileActions(),
          const SizedBox(height: 40), // Extra padding at bottom
        ],
      ),
    );
  }

  Widget _buildFeaturedWorkCard(
    String title,
    String subtitle,
    String duration,
    String imageUrl,
  ) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                height: 90,
                width: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  duration,
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: KalaColors.charcoal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 9,
              color: KalaColors.mediumGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppStatBox(String count, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: color,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCareerTimelineItem(
    String year,
    String title,
    String date, {
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFEA580C), width: 2),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: const Color(0xFFEA580C)),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                year,
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.charcoal,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: KalaColors.charcoal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 9,
                    color: KalaColors.mediumGrey,
                  ),
                ),
                if (!isLast) const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomProfileActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionIcon(Icons.edit_outlined, 'Edit Portfolio'),
        _buildActionIcon(Icons.cloud_upload_outlined, 'Upload Work'),
        _buildActionIcon(Icons.share_outlined, 'Share Profile'),
        _buildActionIcon(Icons.bar_chart_outlined, 'Analytics'),
      ],
    );
  }

  Widget _buildActionIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 24, color: KalaColors.charcoal),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 10,
            color: KalaColors.charcoal,
          ),
        ),
      ],
    );
  }
}
