import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/kala_colors.dart';
import '../../features/feed/presentation/screens/career_dashboard_screen.dart';
import '../../features/opportunities/presentation/screens/discover_marketplace_screen.dart';
import '../../features/opportunities/presentation/screens/applications_tracker_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/hub/presentation/screens/hub_menu_overlay.dart';

class NavigationHub extends StatefulWidget {
  const NavigationHub({super.key});

  @override
  State<NavigationHub> createState() => _NavigationHubState();
}

class _NavigationHubState extends State<NavigationHub> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const CareerDashboardScreen(),
      const DiscoverMarketplaceScreen(),
      HubMenuOverlay(onClose: () {
        setState(() {
          _currentIndex = 0;
        });
      }),
      const ApplicationsTrackerScreen(),
      const ProfileScreen(),
    ];
  }

  void _onTabTapped(int index) {
    final bool isLaptop = MediaQuery.of(context).size.width >= 1000;
    if (index == 2) {
      if (isLaptop) {
        setState(() {
          _currentIndex = 2;
        });
      } else {
        _showHubOverlay();
      }
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _showHubOverlay() {
    HubMenuOverlay.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isLaptop = width >= 1000;

    if (isLaptop) {
      return Scaffold(
        backgroundColor: KalaColors.ivory,
        body: Row(
          children: [
            // Left Sidebar Navigation drawer
            Container(
              width: 250,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: const BoxDecoration(
                color: KalaColors.ivory,
                border: Border(
                  right: BorderSide(color: Color(0xFFEAE2B7), width: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, bottom: 28.0),
                    child: Text(
                      'kalā',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: KalaColors.charcoal,
                        letterSpacing: -1,
                      ),
                    ),
                  ),

                  // Menu list items
                  _buildSidebarItem(0, Icons.home_outlined, Icons.home, 'Home'),
                  const SizedBox(height: 8),
                  _buildSidebarItem(
                    1,
                    Icons.business_center_outlined,
                    Icons.business_center,
                    'Opportunities',
                  ),
                  const SizedBox(height: 8),
                  _buildSidebarItem(
                    3,
                    Icons.assignment_outlined,
                    Icons.assignment,
                    'Applications',
                  ),
                  const SizedBox(height: 8),
                  _buildSidebarItem(
                    4,
                    Icons.person_outline,
                    Icons.person,
                    'Profile',
                  ),

                  const SizedBox(height: 32),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 2;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF0E9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFED7C3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: KalaColors.burntOrange,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create / Post',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: KalaColors.charcoal,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Share your talent or an\nopportunity',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: KalaColors.charcoal.withValues(
                                      alpha: 0.5,
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

                  const Spacer(),

                  // Bottom Profile Completeness Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: KalaColors.softBeige),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your profile is 80% complete',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: KalaColors.charcoal,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Linear progress indicator
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: const LinearProgressIndicator(
                            value: 0.8,
                            backgroundColor: Color(0xFFF5EBE0),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              KalaColors.burntOrange,
                            ),
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => setState(() => _currentIndex = 4),
                          child: Row(
                            children: [
                              Text(
                                'Complete your profile',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: KalaColors.charcoal,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward,
                                size: 10,
                                color: KalaColors.charcoal,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Vertical divider line
            Container(width: 0.5, color: const Color(0xFFEAE2B7)),

            // Active screen expanded viewport
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
            ),
          ],
        ),
      );
    }

    // Standard Mobile Layout
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: KalaColors.lightGrey, width: 0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBottomNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
              _buildBottomNavItem(1, Icons.explore_outlined, Icons.explore, 'Discover'),
              _buildCenterNavItem(),
              _buildBottomNavItem(3, Icons.description_outlined, Icons.description, 'Applications'),
              _buildBottomNavItem(4, Icons.person_outline, Icons.person, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(int index, IconData outlineIcon, IconData filledIcon, String label) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? KalaColors.burntOrange : KalaColors.charcoal;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTabTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? filledIcon : outlineIcon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 2,
              width: 32,
              color: isSelected ? KalaColors.burntOrange : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterNavItem() {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTabTapped(2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: KalaColors.burntOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem(
    int index,
    IconData outlineIcon,
    IconData filledIcon,
    String label,
  ) {
    final bool isSelected = _currentIndex == index;
    final icon = isSelected ? filledIcon : outlineIcon;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFDF0E9) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? KalaColors.burntOrange
                  : KalaColors.charcoal.withValues(alpha: 0.7),
              size: 20,
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? KalaColors.burntOrange
                    : KalaColors.charcoal.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
