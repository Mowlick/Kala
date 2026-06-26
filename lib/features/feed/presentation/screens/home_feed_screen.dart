import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/kala_colors.dart';
import '../../../../core/widgets/kala_search_bar.dart';

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isLaptop = width >= 1000;

    if (isLaptop) {
      return _buildLaptopLayout(context);
    }

    return _buildMobileLayout(context);
  }

  // --- LAPTOP / WEB LAYOUT ---
  Widget _buildLaptopLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: KalaColors.ivory,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Search Utility Bar
            _buildLaptopTopBar(context),
            Container(height: 0.5, color: const Color(0xFFEAE2B7)),

            // 2. Main Content Split Pane
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Center main scrolling feed
                  Expanded(
                    flex: 7,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good morning,',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(fontSize: 13),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                'Aarav',
                                style: GoogleFonts.cormorantGaramond(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: KalaColors.charcoal,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('👏', style: TextStyle(fontSize: 28)),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Stories tray
                          _buildLaptopStoriesRow(context),
                          const SizedBox(height: 32),

                          // Featured Opportunities Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Featured Opportunities',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'See All',
                                  style: TextStyle(
                                    color: KalaColors.burntOrange,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Featured slider
                          _buildLaptopFeaturedSlider(context),
                          const SizedBox(height: 32),

                          // For You Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'For You',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Personalize 🎙️',
                                  style: TextStyle(
                                    color: KalaColors.burntOrange,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Creator Posts
                          _buildFeedPost(
                            context,
                            creatorName: 'Kabir Malhotra',
                            creatorRole: 'Singer',
                            creatorCity: 'Delhi',
                            timeAgo: '2h ago',
                            creatorAvatar:
                                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
                            description:
                                'New cover out now! Let me know what you think 💛\n#indie #music #cover',
                            postImageUrl:
                                'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
                            likes: '128',
                            comments: '24',
                            shares: '12',
                            badge: 'New Cover',
                          ),
                          _buildFeedPost(
                            context,
                            creatorName: 'Nritya Collective',
                            creatorRole: 'Dance Group',
                            creatorCity: 'Bangalore',
                            timeAgo: '5h ago',
                            creatorAvatar:
                                'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
                            description:
                                'Behind the scenes from our rehearsal this morning! Upcoming choreography drop soon. ✨',
                            postImageUrl:
                                'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
                            likes: '245',
                            comments: '58',
                            shares: '41',
                            badge: 'Rehearsal',
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Divider line
                  Container(width: 0.5, color: const Color(0xFFEAE2B7)),

                  // Right Sidebar panel
                  Container(
                    width: 320,
                    color: KalaColors.ivory,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Trending Opportunities
                          _buildLaptopRightHeader(
                            context,
                            'Trending Opportunities',
                          ),
                          const SizedBox(height: 12),
                          _buildTrendingOppItem(
                            context,
                            title: 'Background Actors Required',
                            meta: 'Short Film • Mumbai',
                            sub: 'Paid • 2 days left',
                            imageUrl:
                                'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4',
                          ),
                          _buildTrendingOppItem(
                            context,
                            title: 'Need Female Playback Singer',
                            meta: 'Independent Music • Remote',
                            sub: 'Paid • 4 days left',
                            imageUrl:
                                'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
                          ),
                          _buildTrendingOppItem(
                            context,
                            title: 'Visual Artist for Album Cover',
                            meta: 'Music Artist • Delhi',
                            sub: 'Paid • 5 days left',
                            imageUrl:
                                'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
                          ),

                          const SizedBox(height: 28),

                          // People You May Know
                          _buildLaptopRightHeader(
                            context,
                            'People You May Know',
                          ),
                          const SizedBox(height: 12),
                          _buildPeopleYouMayKnowItem(
                            context,
                            name: 'Rhea Sharma',
                            desc: 'Dancer • Mumbai',
                            avatarUrl:
                                'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
                          ),
                          _buildPeopleYouMayKnowItem(
                            context,
                            name: 'Arjun Verma',
                            desc: 'Filmmaker • Pune',
                            avatarUrl:
                                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
                          ),
                          _buildPeopleYouMayKnowItem(
                            context,
                            name: 'Meera Iyer',
                            desc: 'Singer • Chennai',
                            avatarUrl:
                                'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
                          ),

                          const SizedBox(height: 28),

                          // Stand out promo card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDF0E9),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFFED7C3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Make your profile stand out',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: KalaColors.charcoal,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.assignment_outlined,
                                      color: KalaColors.burntOrange,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Add more details to attract the right opportunities.',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: KalaColors.charcoal.withValues(alpha: 0.6),
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: KalaColors.burntOrange,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                  ),
                                  child: Text(
                                    'Complete Now',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: KalaColors.burntOrange,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLaptopTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 14.0),
      child: Row(
        children: [
          // Search input box
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: KalaSearchBar(
                  hintText: 'Search opportunities, people, skills...',
                  height: 40,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5EBE0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '⌘K',
                        style: TextStyle(
                          fontSize: 9,
                          color: KalaColors.mediumGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          // Action icons
          IconButton(
            icon: const Icon(
              Icons.chat_bubble_outline,
              color: KalaColors.charcoal,
              size: 20,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: KalaColors.charcoal,
                  size: 22,
                ),
                onPressed: () {},
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: KalaColors.burntOrange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // User dropdown pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: KalaColors.softBeige),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
                  ),
                  radius: 12,
                ),
                const SizedBox(width: 8),
                Text(
                  'Aarav',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: KalaColors.charcoal,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: KalaColors.charcoal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLaptopStoriesRow(BuildContext context) {
    final List<Map<String, dynamic>> stories = [
      {
        'name': 'Your Story',
        'url': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
        'isUser': true,
      },
      {
        'name': 'Following',
        'url': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
        'update': true,
      },
      {
        'name': 'Singers',
        'url': 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
        'update': true,
      },
      {
        'name': 'Dancers',
        'url': 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
        'update': true,
      },
      {
        'name': 'Filmmakers',
        'url': 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4',
        'update': true,
      },
      {
        'name': 'Artists',
        'url': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
        'update': false,
      },
      {
        'name': 'Editors',
        'url': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
        'update': false,
      },
    ];

    return SizedBox(
      height: 96,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final s = stories[index];
          final hasUpdate = s['update'] as bool? ?? false;
          final isUser = s['isUser'] as bool? ?? false;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: hasUpdate
                              ? KalaColors.burntOrange
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(s['url'] as String),
                      radius: 26,
                    ),
                    if (isUser)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: KalaColors.burntOrange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  s['name'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: KalaColors.charcoal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLaptopFeaturedSlider(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KalaColors.softBeige),
      ),
      child: Row(
        children: [
          // Banner image left
          Container(
            width: 180,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Info right
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF0E9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'AUDITION',
                      style: TextStyle(
                        color: KalaColors.burntOrange,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dancers for Music Video',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: KalaColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: KalaColors.mediumGrey,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Mumbai',
                        style: TextStyle(
                          color: KalaColors.mediumGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Paid  •  18-25 yrs  •  3 days left',
                    style: TextStyle(
                      color: KalaColors.mediumGrey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Navigation arrow right
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFDF0E9),
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: KalaColors.burntOrange,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLaptopRightHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
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
    );
  }

  Widget _buildTrendingOppItem(
    BuildContext context, {
    required String title,
    required String meta,
    required String sub,
    required String imageUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KalaColors.softBeige),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
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
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: KalaColors.charcoal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  meta,
                  style: const TextStyle(
                    fontSize: 9,
                    color: KalaColors.mediumGrey,
                  ),
                ),
                Text(
                  sub,
                  style: const TextStyle(
                    fontSize: 9,
                    color: KalaColors.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.bookmark_border,
              size: 18,
              color: KalaColors.mediumGrey,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPeopleYouMayKnowItem(
    BuildContext context, {
    required String name,
    required String desc,
    required String avatarUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KalaColors.softBeige),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(avatarUrl), radius: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: KalaColors.charcoal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 9,
                    color: KalaColors.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: KalaColors.softBeige),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            ),
            child: Text(
              'Follow',
              style: GoogleFonts.inter(
                fontSize: 10,
                color: KalaColors.charcoal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- MOBILE LAYOUT ---
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good morning,',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Aarav 👋',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Spacer(),
                    _buildCircularHeaderButton(
                      context,
                      icon: Icons.search,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 12),
                    Stack(
                      children: [
                        _buildCircularHeaderButton(
                          context,
                          icon: Icons.notifications_none,
                          onPressed: () {},
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: KalaColors.burntOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Stories
              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildStoryItem(
                      context,
                      name: 'Your Story',
                      imageUrl:
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
                      isUser: true,
                    ),
                    _buildStoryItem(
                      context,
                      name: 'Following',
                      imageUrl:
                          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
                      hasUpdate: true,
                    ),
                    _buildStoryItem(
                      context,
                      name: 'Singers',
                      imageUrl:
                          'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
                      hasUpdate: true,
                    ),
                    _buildStoryItem(
                      context,
                      name: 'Dancers',
                      imageUrl:
                          'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
                      hasUpdate: true,
                    ),
                    _buildStoryItem(
                      context,
                      name: 'Filmmakers',
                      imageUrl:
                          'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4',
                      hasUpdate: true,
                    ),
                    _buildStoryItem(
                      context,
                      name: 'Artists',
                      imageUrl:
                          'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
                      hasUpdate: false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Featured Opportunities Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Featured Opportunities',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          color: KalaColors.burntOrange,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Featured Slider list
              SizedBox(
                height: 195,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildFeaturedOpportunityCard(
                      context,
                      title: 'Dancers for Music Video',
                      location: 'Mumbai',
                      type: 'AUDITION',
                      compensation: 'Paid',
                      ageGroup: '18-25 yrs',
                      timeLeft: '3 days left',
                      imageUrl:
                          'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
                    ),
                    _buildFeaturedOpportunityCard(
                      context,
                      title: 'Indie Singer for Short Film',
                      location: 'Delhi',
                      type: 'GIG',
                      compensation: 'Paid',
                      ageGroup: '20-30 yrs',
                      timeLeft: '5 days left',
                      imageUrl:
                          'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // For You
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'For You',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.tune,
                        size: 14,
                        color: KalaColors.burntOrange,
                      ),
                      label: const Text(
                        'Personalize',
                        style: TextStyle(
                          color: KalaColors.burntOrange,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Posts
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildFeedPost(
                    context,
                    creatorName: 'Kabir Malhotra',
                    creatorRole: 'Singer',
                    creatorCity: 'Delhi',
                    timeAgo: '2h ago',
                    creatorAvatar:
                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
                    description:
                        'New cover out now! Let me know what you think 💛\n#indie #music #cover',
                    postImageUrl:
                        'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
                    likes: '128',
                    comments: '24',
                    shares: '12',
                    badge: 'New Cover',
                  ),
                  _buildFeedPost(
                    context,
                    creatorName: 'Nritya Collective',
                    creatorRole: 'Dance Group',
                    creatorCity: 'Bangalore',
                    timeAgo: '5h ago',
                    creatorAvatar:
                        'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
                    description:
                        'Behind the scenes from our rehearsal this morning! Upcoming choreography drop soon. ✨',
                    postImageUrl:
                        'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
                    likes: '245',
                    comments: '58',
                    shares: '41',
                    badge: 'Rehearsal',
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularHeaderButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: KalaColors.softBeige),
      ),
      child: IconButton(
        icon: Icon(icon, color: KalaColors.charcoal, size: 20),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildStoryItem(
    BuildContext context, {
    required String name,
    required String imageUrl,
    bool isUser = false,
    bool hasUpdate = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: hasUpdate
                        ? KalaColors.burntOrange
                        : Colors.transparent,
                    width: 2.2,
                  ),
                ),
              ),
              Container(
                width: 66,
                height: 66,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (isUser)
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: KalaColors.burntOrange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 14),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11,
              color: KalaColors.charcoal,
              fontWeight: hasUpdate ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedOpportunityCard(
    BuildContext context, {
    required String title,
    required String location,
    required String type,
    required String compensation,
    required String ageGroup,
    required String timeLeft,
    required String imageUrl,
  }) {
    return Container(
      width: 320,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: KalaColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: KalaColors.softBeige),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 140,
            decoration: BoxDecoration(
              color: KalaColors.softBeige,
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: KalaColors.softBeige,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    type,
                    style: const TextStyle(
                      color: KalaColors.burntOrange,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: KalaColors.mediumGrey,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 12,
                        color: KalaColors.mediumGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '$compensation  •  $ageGroup  •  $timeLeft',
                  style: const TextStyle(
                    fontSize: 10,
                    color: KalaColors.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: KalaColors.softBeige,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: KalaColors.burntOrange,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedPost(
    BuildContext context, {
    required String creatorName,
    required String creatorRole,
    required String creatorCity,
    required String timeAgo,
    required String creatorAvatar,
    required String description,
    required String postImageUrl,
    required String likes,
    required String comments,
    required String shares,
    required String badge,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: KalaColors.softBeige),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(creatorAvatar),
                  radius: 20,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          creatorName,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.verified,
                          color: KalaColors.burntOrange,
                          size: 14,
                        ),
                      ],
                    ),
                    Text(
                      '$creatorRole • $creatorCity',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(fontSize: 11),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  timeAgo,
                  style: const TextStyle(
                    fontSize: 11,
                    color: KalaColors.mediumGrey,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.more_vert,
                    size: 20,
                    color: KalaColors.mediumGrey,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: Text(
              description,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 220,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(postImageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          badge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
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
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                _buildPostAction(Icons.favorite_border, likes),
                const SizedBox(width: 16),
                _buildPostAction(Icons.chat_bubble_outline, comments),
                const SizedBox(width: 16),
                _buildPostAction(Icons.near_me_outlined, shares),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.bookmark_border,
                    color: KalaColors.charcoal,
                    size: 22,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostAction(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: KalaColors.charcoal, size: 22),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: KalaColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
