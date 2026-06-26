import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/kala_colors.dart';
import '../../../../core/widgets/kala_search_bar.dart';

class OpportunitiesListScreen extends StatefulWidget {
  const OpportunitiesListScreen({super.key});

  @override
  State<OpportunitiesListScreen> createState() =>
      _OpportunitiesListScreenState();
}

class _OpportunitiesListScreenState extends State<OpportunitiesListScreen> {
  final List<String> _categories = [
    'All',
    'Auditions',
    'Gigs',
    'Competitions',
    'Internships',
    'Workshops',
  ];
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _opportunities = [
    {
      'title': 'Dancers for Music Video',
      'location': 'Mumbai, Maharashtra',
      'category': 'AUDITION',
      'compensation': 'Paid',
      'age': '18-25 yrs',
      'duration': '3 days left',
      'tags': ['Hip Hop', 'Contemporary', 'Female'],
      'imageUrl':
          'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
    },
    {
      'title': 'Live Performance at College Fest',
      'location': 'Delhi University, Delhi',
      'category': 'GIG',
      'compensation': 'Paid',
      'age': '20-30 yrs',
      'duration': '5 days left',
      'tags': ['Singer', 'Indie', 'Live Band'],
      'imageUrl':
          'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
    },
    {
      'title': 'Cinematographer for Short Film',
      'location': 'Bangalore, Karnataka',
      'category': 'CREW CALL',
      'compensation': 'Paid',
      'age': 'Experience: 1+ yrs',
      'duration': '7 days left',
      'tags': ['Cinematography', 'Short Film'],
      'imageUrl':
          'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isLaptop = width >= 1000;

    if (isLaptop) {
      return _buildLaptopLayout(context);
    }

    return _buildMobileLayout(context);
  }

  // --- LAPTOP LAYOUT ---
  Widget _buildLaptopLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: KalaColors.ivory,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left main scrolling pane
            Expanded(
              flex: 7,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header title row
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Opportunities',
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: KalaColors.charcoal,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Discover. Apply. Grow.',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(fontSize: 13),
                            ),
                          ],
                        ),
                        const Spacer(),
                        _buildCircularButton(Icons.bookmark_outline),
                        const SizedBox(width: 12),
                        _buildCircularButton(Icons.tune),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Search input
                    const KalaSearchBar(
                      hintText: 'Search for auditions, gigs, events...',
                    ),
                    const SizedBox(height: 20),

                    // Categories chips
                    SizedBox(
                      height: 44,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final cat = _categories[index];
                          final isSelected = _selectedCategory == cat;

                          IconData catIcon;
                          switch (cat) {
                            case 'Auditions':
                              catIcon = Icons.theater_comedy_outlined;
                              break;
                            case 'Gigs':
                              catIcon = Icons.music_note_outlined;
                              break;
                            case 'Competitions':
                              catIcon = Icons.emoji_events_outlined;
                              break;
                            case 'Internships':
                              catIcon = Icons.business_center_outlined;
                              break;
                            case 'Workshops':
                              catIcon = Icons.school_outlined;
                              break;
                            default:
                              catIcon = Icons.grid_view_rounded;
                          }

                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedCategory = cat),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? KalaColors.burntOrange
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? KalaColors.burntOrange
                                      : KalaColors.softBeige,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    catIcon,
                                    size: 15,
                                    color: isSelected
                                        ? Colors.white
                                        : KalaColors.charcoal,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    cat,
                                    style: Theme.of(context).textTheme.bodyMedium
                                        ?.copyWith(
                                          color: isSelected
                                              ? Colors.white
                                              : KalaColors.charcoal,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Recommended Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recommended for you',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'See All',
                            style: TextStyle(color: KalaColors.burntOrange),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Gigs list
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _opportunities.length,
                      itemBuilder: (context, index) {
                        return _buildOpportunityListItem(
                          context,
                          _opportunities[index],
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Create opportunity poster banner
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFF2EC), Color(0xFFFBEADB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: KalaColors.softBeige),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(
                              Icons.insights,
                              color: KalaColors.burntOrange,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create Opportunity',
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Post auditions, gigs or events and find the right talent.',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(fontSize: 11, height: 1.3),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/create-opportunity',
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Post Now',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Divider line
            Container(width: 0.5, color: const Color(0xFFEAE2B7)),

            // Right Sidebar pane
            Container(
              width: 320,
              color: KalaColors.ivory,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Closing Soon Gigs list
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Closing Soon',
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
                    ),
                    const SizedBox(height: 12),
                    _buildClosingSoonItem(
                      context,
                      title: 'National Singing Championship',
                      meta: 'Online • 15–30 yrs',
                      timeLeft: '2 days left',
                      imageUrl:
                          'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
                    ),
                    _buildClosingSoonItem(
                      context,
                      title: 'Lead Actor for Web Series',
                      meta: 'Mumbai',
                      timeLeft: '2 days left',
                      imageUrl:
                          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
                    ),
                    _buildClosingSoonItem(
                      context,
                      title: 'Wedding Performance',
                      meta: 'Pune',
                      timeLeft: '3 days left',
                      imageUrl:
                          'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
                    ),

                    const SizedBox(height: 28),

                    // Trending Categories
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Trending Categories',
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
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: KalaColors.softBeige),
                      ),
                      child: Column(
                        children: [
                          _buildTrendingCategoryTile(
                            Icons.directions_run_outlined,
                            'Dancers',
                            '128 opportunities',
                          ),
                          _buildTrendingCategoryDivider(),
                          _buildTrendingCategoryTile(
                            Icons.mic_none_outlined,
                            'Singers',
                            '96 opportunities',
                          ),
                          _buildTrendingCategoryDivider(),
                          _buildTrendingCategoryTile(
                            Icons.theater_comedy_outlined,
                            'Actors',
                            '78 opportunities',
                          ),
                          _buildTrendingCategoryDivider(),
                          _buildTrendingCategoryTile(
                            Icons.movie_filter_outlined,
                            'Filmmakers',
                            '64 opportunities',
                          ),
                          _buildTrendingCategoryDivider(),
                          _buildTrendingCategoryTile(
                            Icons.music_note_outlined,
                            'Musicians',
                            '52 opportunities',
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
    );
  }

  Widget _buildClosingSoonItem(
    BuildContext context, {
    required String title,
    required String meta,
    required String timeLeft,
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
                const SizedBox(height: 2),
                Text(
                  timeLeft,
                  style: const TextStyle(
                    fontSize: 9,
                    color: KalaColors.burntOrange,
                    fontWeight: FontWeight.bold,
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

  Widget _buildTrendingCategoryTile(IconData icon, String name, String count) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      leading: Icon(icon, color: KalaColors.burntOrange, size: 18),
      title: Text(
        name,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: KalaColors.charcoal,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count,
            style: const TextStyle(fontSize: 10, color: KalaColors.mediumGrey),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right,
            size: 14,
            color: KalaColors.mediumGrey,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingCategoryDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(color: KalaColors.softBeige, height: 1),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Opportunities',
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Discover. Apply. Grow.',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                    const Spacer(),
                    _buildCircularButton(Icons.bookmark_outline),
                    const SizedBox(width: 12),
                    _buildCircularButton(Icons.tune),
                  ],
                ),
              ),

              // Search
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: KalaSearchBar(
                  hintText: 'Search for auditions, gigs, events...',
                ),
              ),

              const SizedBox(height: 20),

              // Categories list
              SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat;

                    IconData catIcon;
                    switch (cat) {
                      case 'Auditions':
                        catIcon = Icons.theater_comedy_outlined;
                        break;
                      case 'Gigs':
                        catIcon = Icons.music_note_outlined;
                        break;
                      case 'Competitions':
                        catIcon = Icons.emoji_events_outlined;
                        break;
                      case 'Internships':
                        catIcon = Icons.business_center_outlined;
                        break;
                      case 'Workshops':
                        catIcon = Icons.school_outlined;
                        break;
                      default:
                        catIcon = Icons.grid_view_rounded;
                    }

                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? KalaColors.burntOrange
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? KalaColors.burntOrange
                                : KalaColors.softBeige,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              catIcon,
                              size: 15,
                              color: isSelected
                                  ? Colors.white
                                  : KalaColors.charcoal,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              cat,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : KalaColors.charcoal,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 12,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Recommended
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recommended for you',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'See All',
                        style: TextStyle(color: KalaColors.burntOrange),
                      ),
                    ),
                  ],
                ),
              ),

              // Listings list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _opportunities.length,
                itemBuilder: (context, index) {
                  final opp = _opportunities[index];
                  return _buildOpportunityListItem(context, opp);
                },
              ),

              const SizedBox(height: 20),

              // Create Opportunity Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF2EC), Color(0xFFFBEADB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: KalaColors.softBeige),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.insights,
                          color: KalaColors.burntOrange,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Create Opportunity',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Post auditions, gigs or events and find the right talent.',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontSize: 11, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/create-opportunity');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Post Now',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Closing Soon Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Closing Soon',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'See All',
                        style: TextStyle(color: KalaColors.burntOrange),
                      ),
                    ),
                  ],
                ),
              ),

              // Closing Soon item
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8,
                ),
                child: _buildOpportunityListItem(context, {
                  'title': 'National Singing Championship',
                  'location': 'Online / Mumbai',
                  'category': 'COMPETITION',
                  'compensation': 'Cash Prizes',
                  'age': '15-30 yrs',
                  'duration': '2 days left',
                  'tags': ['Singing', 'Individual', 'All India'],
                  'imageUrl':
                      'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
                }),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularButton(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: KalaColors.softBeige),
      ),
      child: Center(child: Icon(icon, color: KalaColors.charcoal, size: 20)),
    );
  }

  Widget _buildOpportunityListItem(
    BuildContext context,
    Map<String, dynamic> opp,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/opportunity-detail', arguments: opp);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: KalaColors.softBeige),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: KalaColors.softBeige,
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(opp['imageUrl'] as String),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          opp['category'] as String,
                          style: const TextStyle(
                            color: KalaColors.burntOrange,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        opp['title'] as String,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.2,
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
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              opp['location'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: KalaColors.mediumGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: KalaColors.ivory,
                    border: Border.all(color: KalaColors.softBeige),
                  ),
                  child: const Icon(
                    Icons.bookmark_border,
                    color: KalaColors.charcoal,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${opp['compensation']}  •  ${opp['age']}  •  ${opp['duration']}',
              style: const TextStyle(
                fontSize: 11,
                color: KalaColors.mediumGrey,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    children: (opp['tags'] as List<String>).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: KalaColors.ivory,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: KalaColors.softBeige),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontSize: 10,
                            color: KalaColors.charcoal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: KalaColors.softBeige,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: KalaColors.charcoal,
                    size: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
