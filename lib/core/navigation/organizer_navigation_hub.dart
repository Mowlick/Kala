import 'package:flutter/material.dart';

import '../theme/kala_colors.dart';
import '../../features/organizer/presentation/screens/organizer_hub_screen.dart';
import '../../features/organizer/presentation/screens/organizer_talent_screen.dart';
import '../../features/organizer/presentation/screens/organizer_create_screen.dart';
import '../../features/organizer/presentation/screens/organizer_flow_screen.dart';
import '../../features/organizer/presentation/screens/organizer_admin_screen.dart';

class OrganizerNavigationHub extends StatefulWidget {
  const OrganizerNavigationHub({super.key});

  @override
  State<OrganizerNavigationHub> createState() => _OrganizerNavigationHubState();
}

class _OrganizerNavigationHubState extends State<OrganizerNavigationHub>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  // 4 real screens — Create is a bottom sheet
  static const List<Widget> _screens = [
    OrganizerHubScreen(),
    OrganizerTalentScreen(),
    OrganizerFlowScreen(),
    OrganizerAdminScreen(),
  ];

  late final AnimationController _pageAnimController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _pageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _fadeAnim = CurvedAnimation(parent: _pageAnimController, curve: Curves.easeInOut);
    _pageAnimController.forward();
  }

  @override
  void dispose() {
    _pageAnimController.dispose();
    super.dispose();
  }

  /// navIndex: 0=Hub, 1=Talent, 2=Create(sheet), 3=Flow, 4=Admin
  void _onNavTapped(int navIndex) {
    if (navIndex == 2) {
      OrganizerCreateScreen.show(context);
      return;
    }
    final screenIndex = navIndex > 2 ? navIndex - 1 : navIndex;
    if (screenIndex == _currentIndex) return;
    _pageAnimController.reset();
    setState(() => _currentIndex = screenIndex);
    _pageAnimController.forward();
  }

  /// Maps screen index (0-3) back to nav bar position (0,1,3,4)
  int get _navIndex => _currentIndex >= 2 ? _currentIndex + 1 : _currentIndex;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isLaptop = width >= 1000;

    if (isLaptop) {
      return _buildLaptopLayout();
    }
    return _buildMobileLayout();
  }

  // ─── MOBILE ───────────────────────────────────────────────────────────────
  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: KalaColors.ivory,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: IndexedStack(index: _currentIndex, children: _screens),
      ),
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
              _buildNavItem(navIndex: 0, outlineIcon: Icons.home_outlined, filledIcon: Icons.home, label: 'Hub'),
              _buildNavItem(navIndex: 1, outlineIcon: Icons.people_outline, filledIcon: Icons.people, label: 'Talent'),
              _buildCenterNavItem(),
              _buildNavItem(navIndex: 3, outlineIcon: Icons.timeline_outlined, filledIcon: Icons.timeline, label: 'Flow'),
              _buildNavItem(navIndex: 4, outlineIcon: Icons.settings_outlined, filledIcon: Icons.settings, label: 'Admin'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int navIndex,
    required IconData outlineIcon,
    required IconData filledIcon,
    required String label,
  }) {
    final bool isSelected = _navIndex == navIndex;
    final Color color = isSelected ? KalaColors.burntOrange : KalaColors.charcoal;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onNavTapped(navIndex),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: Tween<double>(begin: 0.75, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.elasticOut),
                ),
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: Icon(
                isSelected ? filledIcon : outlineIcon,
                key: ValueKey<bool>(isSelected),
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(fontFamily: 'ZT_Nature', 
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
              child: Text(label),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              height: 2,
              width: isSelected ? 32 : 0,
              decoration: BoxDecoration(
                color: isSelected ? KalaColors.burntOrange : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
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
        onTap: () => _onNavTapped(2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: KalaColors.burntOrange,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: KalaColors.burntOrange.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 26),
            ),
            // Spacer to keep same height as text items
            const SizedBox(height: 22),
          ],
        ),
      ),
    );
  }

  // ─── LAPTOP ───────────────────────────────────────────────────────────────
  Widget _buildLaptopLayout() {
    return Scaffold(
      backgroundColor: KalaColors.ivory,
      body: Row(
        children: [
          Container(
            width: 250,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: const BoxDecoration(
              color: KalaColors.ivory,
              border: Border(right: BorderSide(color: Color(0xFFEAE2B7), width: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, bottom: 28.0),
                  child: Text(
                    'kalā',
                    style: TextStyle(fontFamily: 'ZT_Nature', 
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: KalaColors.charcoal,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                _buildSidebarItem(0, Icons.home_outlined, Icons.home, 'Hub'),
                const SizedBox(height: 8),
                _buildSidebarItem(1, Icons.people_outline, Icons.people, 'Talent'),
                const SizedBox(height: 8),
                _buildSidebarItem(2, Icons.timeline_outlined, Icons.timeline, 'Flow'),
                const SizedBox(height: 8),
                _buildSidebarItem(3, Icons.settings_outlined, Icons.settings, 'Admin'),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () => OrganizerCreateScreen.show(context),
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
                          child: const Icon(Icons.add, color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Create / Post',
                                  style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                              const SizedBox(height: 2),
                              Text(
                                'Post a new opportunity',
                                style: TextStyle(fontSize: 9, color: KalaColors.charcoal.withValues(alpha: 0.5)),
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
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: IndexedStack(index: _currentIndex, children: _screens),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(int screenIndex, IconData icon, IconData activeIcon, String label) {
    final bool isSelected = _currentIndex == screenIndex;
    return GestureDetector(
      onTap: () {
        if (screenIndex == _currentIndex) return;
        _pageAnimController.reset();
        setState(() => _currentIndex = screenIndex);
        _pageAnimController.forward();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? KalaColors.burntOrange.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? activeIcon : icon,
                key: ValueKey<bool>(isSelected),
                size: 22,
                color: isSelected ? KalaColors.burntOrange : KalaColors.charcoal.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(fontFamily: 'ZT_Nature', 
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? KalaColors.charcoal : KalaColors.charcoal.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
