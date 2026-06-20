import 'package:flutter/material.dart';
import '../../../../core/theme/kala_colors.dart';

class OpportunityDetailScreen extends StatelessWidget {
  const OpportunityDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments passed from navigation list
    final Map<String, dynamic> opp = (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ?? {
      'title': 'Dancers for Music Video',
      'location': 'Mumbai, Maharashtra',
      'category': 'AUDITION',
      'compensation': 'Paid (₹15,000 - ₹20,000)',
      'age': '18-25 yrs',
      'duration': '3 days left',
      'tags': ['Hip Hop', 'Contemporary', 'Female'],
      'imageUrl': 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
    };

    return Scaffold(
      body: Stack(
        children: [
          // Scrolling Details Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Cover Image Banner
                Stack(
                  children: [
                    Container(
                      height: 280,
                      decoration: BoxDecoration(
                        color: KalaColors.softBeige,
                        image: DecorationImage(
                          image: NetworkImage(opp['imageUrl'] as String),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Container(
                      height: 280,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black.withValues(alpha: 0.4), Colors.transparent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    // Back button & Bookmark
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: const Icon(Icons.arrow_back, color: KalaColors.charcoal),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(Icons.bookmark_border, color: KalaColors.charcoal),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // 2. Info Card
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: KalaColors.softBeige,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          opp['category'] as String,
                          style: const TextStyle(
                            color: KalaColors.burntOrange,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Title
                      Text(
                        opp['title'] as String,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                      ),
                      const SizedBox(height: 8),
                      // Organizer row
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb'),
                            radius: 12,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Kala Studio Productions  ',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const Icon(Icons.verified, color: KalaColors.burntOrange, size: 14),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Divider
                      const Divider(color: KalaColors.softBeige, thickness: 1),
                      const SizedBox(height: 16),

                      // Quick Stats Grid
                      Row(
                        children: [
                          _buildStatItem(context, Icons.payments_outlined, 'Compensation', opp['compensation']),
                          _buildStatItem(context, Icons.location_on_outlined, 'Location', opp['location']),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildStatItem(context, Icons.hourglass_empty_outlined, 'Duration', opp['duration']),
                          _buildStatItem(context, Icons.people_outline, 'Open for', opp['age']),
                        ],
                      ),

                      const SizedBox(height: 24),
                      const Divider(color: KalaColors.softBeige, thickness: 1),
                      const SizedBox(height: 20),

                      // Description Section
                      Text(
                        'About the Opportunity',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We are casting female contemporary and hip hop dancers for an upcoming independent Hindi indie pop music video project shooting in Mumbai. The choreography represents raw, expressive narrative movements blending classical Indian postures with modern dynamic shapes.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: KalaColors.mediumGrey,
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: 20),

                      // Requirements Section
                      Text(
                        'Requirements',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      _buildBulletItem(context, 'Strong background in hip hop or contemporary fusion.'),
                      _buildBulletItem(context, 'Prior screen performance experience preferred.'),
                      _buildBulletItem(context, 'Available for rehearsals in Mumbai during June.'),
                      _buildBulletItem(context, 'A valid performance portfolio and reels on KALĀ.'),
                      
                      // Extra padding for bottom button space
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. Absolute Bottom Apply Button Drawer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: KalaColors.softBeige),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Deadline',
                          style: TextStyle(fontSize: 11, color: KalaColors.mediumGrey),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          '31 May 2026',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: KalaColors.charcoal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        _showApplySuccessDialog(context);
                      },
                      child: const Text('Apply Now'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: KalaColors.softBeige,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: KalaColors.burntOrange),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 10, color: KalaColors.mediumGrey),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: KalaColors.charcoal,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: KalaColors.burntOrange),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: KalaColors.mediumGrey,
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _showApplySuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: KalaColors.softBeige,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: KalaColors.burntOrange,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Application Submitted!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your KALĀ portfolio and contact details have been successfully shared with the organizer.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: KalaColors.mediumGrey,
                      ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Go back to opportunities list
                  },
                  child: const Text('Back to Gigs'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
