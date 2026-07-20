import 'package:flutter/material.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/role_select_screen.dart';
import '../../features/onboarding/presentation/screens/profile_details_screen.dart';
import '../../features/onboarding/presentation/screens/student_onboarding_screen.dart';
import '../../features/onboarding/presentation/screens/organizer_onboarding_screen.dart';
import 'organizer_navigation_hub.dart';
import '../../features/onboarding/presentation/screens/goals_screen.dart';
import '../../features/onboarding/presentation/screens/portfolio_links_screen.dart';
import '../../features/onboarding/presentation/screens/success_screen.dart';
import '../../features/feed/presentation/screens/career_dashboard_screen.dart';
import '../../features/opportunities/presentation/screens/discover_marketplace_screen.dart';
import '../../features/opportunities/presentation/screens/applications_tracker_screen.dart';

import '../../features/opportunities/presentation/screens/opportunity_detail_screen.dart';
import '../../features/opportunities/presentation/screens/create_opportunity_screen.dart';
import '../../features/chat/presentation/screens/chat_room_screen.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import 'navigation_hub.dart';

class AppRouter {
  static const String initialRoute = '/';

  static Map<String, WidgetBuilder> get routes {
    return {
      '/': (context) => const SplashScreen(),
      '/role-select': (context) => const RoleSelectScreen(),
      '/student-onboarding': (context) => const StudentOnboardingScreen(),
      '/organizer-onboarding': (context) => const OrganizerOnboardingScreen(),
      '/organizer-home': (context) => const OrganizerNavigationHub(),
      '/profile-details': (context) => const ProfileDetailsScreen(),
      '/goals': (context) => const GoalsScreen(),
      '/portfolio-links': (context) => const PortfolioLinksScreen(),
      '/success': (context) => const SuccessScreen(),
      '/home': (context) => const NavigationHub(),
      '/career-dashboard': (context) => const CareerDashboardScreen(),
      '/discover-marketplace': (context) => const DiscoverMarketplaceScreen(),
      '/applications-tracker': (context) => const ApplicationsTrackerScreen(),
      '/opportunity-detail': (context) => const OpportunityDetailScreen(),
      '/create-opportunity': (context) => const CreateOpportunityScreen(),
      '/chat-room': (context) => const ChatRoomScreen(),
      '/auth': (context) => const AuthScreen(isLogin: false),
      '/auth-login': (context) => const AuthScreen(isLogin: true),
    };
  }
}
