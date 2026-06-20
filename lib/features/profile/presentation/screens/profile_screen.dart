import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/kala_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedSection = 'Portfolio';
  final List<String> _sections = ['Portfolio', 'Projects', 'Achievements', 'Skills', 'Reviews'];

  final List<Map<String, String>> _videos = [
    {
      'title': 'Dil Ke Sheher',
      'category': 'Original Song',
      'duration': '0:58',
      'imageUrl': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
    },
    {
      'title': 'Live Session',
      'category': 'Acoustic Cover',
      'duration': '1:12',
      'imageUrl': 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
    },
    {
      'title': 'Behind The Song',
      'category': 'Studio Diaries',
      'duration': '0:45',
      'imageUrl': 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
    },
    {
      'title': 'Woh Baarish',
      'category': 'Unplugged',
      'duration': '1:03',
      'imageUrl': 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isLaptop = MediaQuery.of(context).size.width >= 1000;
    return Scaffold(
      backgroundColor: KalaColors.ivory,
      body: SafeArea(
        child: isLaptop ? _buildLaptopLayout() : _buildMobileLayout(),
      ),
    );
  }

  Widget _buildLaptopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTopBar(),
                _buildProfileDetails(),
                _buildBiography(),
                _buildCategoryPills(),
                const SizedBox(height: 16),
                _buildStatistics(),
                const SizedBox(height: 20),
                _buildActionButtons(),
                const SizedBox(height: 20),
                _buildAvailableForWork(),
                const SizedBox(height: 24),
                _buildTabs(),
                const SizedBox(height: 16),
                _buildPortfolioSection(),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
        Container(
          width: 340,
          color: KalaColors.ivory,
          padding: const EdgeInsets.only(top: 12, right: 24, bottom: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAboutSection(),
                const SizedBox(height: 24),
                _buildLowerBlocksGrid(),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopBar(),
          _buildProfileDetails(),
          _buildBiography(),
          _buildCategoryPills(),
          const SizedBox(height: 16),
          _buildStatistics(),
          const SizedBox(height: 20),
          _buildActionButtons(),
          const SizedBox(height: 20),
          _buildAvailableForWork(),
          const SizedBox(height: 24),
          _buildTabs(),
          const SizedBox(height: 16),
          _buildPortfolioSection(),
          const SizedBox(height: 24),
          _buildAboutSection(),
          const SizedBox(height: 24),
          _buildLowerBlocksGrid(),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Row(
        children: [
          _buildCircularBarButton(Icons.settings_outlined),
          const Spacer(),
          _buildCircularBarButton(Icons.ios_share_outlined),
          const SizedBox(width: 12),
          _buildCircularBarButton(Icons.menu),
        ],
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: KalaColors.burntOrange,
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Aarav Mehta',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: KalaColors.charcoal,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified,
                      color: KalaColors.burntOrange,
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Singer • Songwriter • Performer',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: KalaColors.mediumGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: KalaColors.mediumGrey,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Mumbai, India',
                      style: TextStyle(
                        fontSize: 11,
                        color: KalaColors.mediumGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.link_outlined,
                      color: KalaColors.mediumGrey,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'linktr.ee/aaravmehta',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: KalaColors.mediumGrey,
                          fontWeight: FontWeight.w500,
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
    );
  }

  Widget _buildBiography() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Text(
        'I create, write and perform songs that come from real stories and emotions. Let\'s create magic together.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: KalaColors.charcoal.withValues(alpha: 0.8),
              height: 1.4,
            ),
      ),
    );
  }

  Widget _buildCategoryPills() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: ['Hindi', 'English', 'Indie', 'Pop', 'Acoustic'].map((tag) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF5EBE0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tag,
              style: TextStyle(
                color: KalaColors.charcoal.withValues(alpha: 0.7),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatistics() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFEAE2B7), width: 0.5),
            bottom: BorderSide(color: Color(0xFFEAE2B7), width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatColumn('128', 'Posts'),
            _buildStatColumn('12.4K', 'Followers'),
            _buildStatColumn('782', 'Following'),
            _buildStatColumn('56', 'Projects'),
            _buildStatColumn('98%', 'Response Rate', isOrange: true),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFF5EBE0),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.edit_outlined, size: 16, color: KalaColors.charcoal),
                  const SizedBox(width: 6),
                  Text(
                    'Edit Profile',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: KalaColors.charcoal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
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
                'View Analytics',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableForWork() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF2ECE4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF38B000),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Available for Work',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: const Color(0xFF38B000),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Open to projects, collaborations and live shows',
                    style: TextStyle(
                      fontSize: 11,
                      color: KalaColors.charcoal.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Edit Availability',
              style: GoogleFonts.inter(
                color: const Color(0xFF38B000),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 44,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFEAE2B7), width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _sections.length,
        itemBuilder: (context, index) {
          final sec = _sections[index];
          final isSelected = _selectedSection == sec;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedSection = sec;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? KalaColors.burntOrange : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  sec,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: isSelected ? KalaColors.burntOrange : KalaColors.mediumGrey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPortfolioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _videos.length,
            itemBuilder: (context, index) {
              final item = _videos[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: KalaColors.softBeige),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(item['imageUrl']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    item['duration']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['category']!,
                            style: TextStyle(
                              fontSize: 8,
                              color: KalaColors.charcoal.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: () {},
            child: Text(
              'View all videos',
              style: GoogleFonts.inter(
                color: KalaColors.burntOrange,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: KalaColors.softBeige),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'About',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'See more',
                  style: GoogleFonts.inter(
                    color: KalaColors.burntOrange,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Independent artist and songwriter based in Mumbai. I believe in authentic music and meaningful connections.',
              style: TextStyle(
                fontSize: 11,
                color: KalaColors.charcoal.withValues(alpha: 0.7),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Container(height: 0.5, color: KalaColors.softBeige),
            const SizedBox(height: 16),
            _buildAboutMetaRow(Icons.cake_outlined, '22 Years'),
            const SizedBox(height: 8),
            _buildAboutMetaRow(Icons.location_on_outlined, 'Mumbai, India'),
            const SizedBox(height: 8),
            _buildAboutMetaRow(Icons.email_outlined, 'aaravmehta.music@gmail.com'),
            const SizedBox(height: 8),
            _buildAboutMetaRow(Icons.phone_outlined, '+91 98765 43210'),
          ],
        ),
      ),
    );
  }

  Widget _buildLowerBlocksGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2, 
        children: [
          _buildGridCard(
            context,
            icon: Icons.star_outline,
            title: 'Open to',
            content: 'Collaborations, Live Shows, Music Projects',
          ),
          _buildGridCard(
            context,
            icon: Icons.work_outline,
            title: 'Rates',
            content: 'Live Show: ₹15K+\nProject: ₹10K+\n(Open to discuss)',
          ),
          _buildGridCard(
            context,
            icon: Icons.access_time,
            title: 'Response Time',
            content: 'Usually replies within a few hours',
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: KalaColors.softBeige),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Supporters',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 52,
                      height: 24,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: 0,
                            child: _buildCollageAvatar('https://images.unsplash.com/photo-1534528741775-53994a69daeb'),
                          ),
                          Positioned(
                            left: 14,
                            child: _buildCollageAvatar('https://images.unsplash.com/photo-1516450360452-9312f5e86fc7'),
                          ),
                          Positioned(
                            left: 28,
                            child: _buildCollageAvatar('https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: KalaColors.softBeige,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        '+32',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: KalaColors.burntOrange,
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
    );
  }

  Widget _buildCircularBarButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: KalaColors.softBeige),
      ),
      child: Center(
        child: Icon(icon, color: KalaColors.charcoal, size: 20),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, {bool isOrange = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isOrange ? KalaColors.burntOrange : KalaColors.charcoal,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: KalaColors.mediumGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutMetaRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: KalaColors.mediumGrey),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: KalaColors.mediumGrey, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildGridCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KalaColors.softBeige),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF5EBE0),
                ),
                child: Icon(icon, size: 14, color: KalaColors.burntOrange),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                color: KalaColors.charcoal.withValues(alpha: 0.7),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollageAvatar(String imageUrl) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
