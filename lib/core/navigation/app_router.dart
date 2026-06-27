import 'package:flutter/material.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/role_select_screen.dart';
import '../../features/onboarding/presentation/screens/profile_details_screen.dart';
import '../../features/onboarding/presentation/screens/goals_screen.dart';
import '../../features/onboarding/presentation/screens/portfolio_links_screen.dart';
import '../../features/onboarding/presentation/screens/success_screen.dart';
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
      '/profile-details': (context) => const ProfileDetailsScreen(),
      '/goals': (context) => const GoalsScreen(),
      '/portfolio-links': (context) => const PortfolioLinksScreen(),
      '/success': (context) => const SuccessScreen(),
      '/home': (context) => const NavigationHub(),
      '/opportunity-detail': (context) => const OpportunityDetailScreen(),
      '/create-opportunity': (context) => const CreateOpportunityScreen(),
      '/chat-room': (context) => const ChatRoomScreen(),
      '/auth': (context) => const AuthScreen(isLogin: false),
      '/auth-login': (context) => const AuthScreen(isLogin: true),
    };
  }
}
