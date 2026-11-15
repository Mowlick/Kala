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

/// Centralized route name constants.
/// Use these instead of raw string literals when navigating.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String roleSelect = '/role-select';
  static const String studentOnboarding = '/student-onboarding';
  static const String organizerOnboarding = '/organizer-onboarding';
  static const String organizerHome = '/organizer-home';
  static const String profileDetails = '/profile-details';
  static const String goals = '/goals';
  static const String portfolioLinks = '/portfolio-links';
  static const String success = '/success';
  static const String home = '/home';
  static const String careerDashboard = '/career-dashboard';
  static const String discoverMarketplace = '/discover-marketplace';
  static const String applicationsTracker = '/applications-tracker';
  static const String opportunityDetail = '/opportunity-detail';
  static const String createOpportunity = '/create-opportunity';
  static const String chatRoom = '/chat-room';
  static const String auth = '/auth';
  static const String authLogin = '/auth-login';
}

class AppRouter {
  static const String initialRoute = AppRoutes.splash;

  static Map<String, WidgetBuilder> get routes {
    return {
      AppRoutes.splash: (context) => const SplashScreen(),
      AppRoutes.roleSelect: (context) => const RoleSelectScreen(),
      AppRoutes.studentOnboarding: (context) => const StudentOnboardingScreen(),
      AppRoutes.organizerOnboarding: (context) =>
          const OrganizerOnboardingScreen(),
      AppRoutes.organizerHome: (context) => const OrganizerNavigationHub(),
      AppRoutes.profileDetails: (context) => const ProfileDetailsScreen(),
      AppRoutes.goals: (context) => const GoalsScreen(),
      AppRoutes.portfolioLinks: (context) => const PortfolioLinksScreen(),
      AppRoutes.success: (context) => const SuccessScreen(),
      AppRoutes.home: (context) => const NavigationHub(),
      AppRoutes.careerDashboard: (context) => const CareerDashboardScreen(),
      AppRoutes.discoverMarketplace: (context) =>
          const DiscoverMarketplaceScreen(),
      AppRoutes.applicationsTracker: (context) =>
          const ApplicationsTrackerScreen(),
      AppRoutes.opportunityDetail: (context) => const OpportunityDetailScreen(),
      AppRoutes.createOpportunity: (context) => const CreateOpportunityScreen(),
      AppRoutes.chatRoom: (context) => const ChatRoomScreen(),
      AppRoutes.auth: (context) => const AuthScreen(isLogin: false),
      AppRoutes.authLogin: (context) => const AuthScreen(isLogin: true),
    };
  }
}
