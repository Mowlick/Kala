import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/kala_theme.dart';
import 'core/navigation/app_router.dart';
import 'features/onboarding/presentation/onboarding_controller.dart';
import 'features/events/presentation/controllers/event_controller.dart';
import 'features/profile/presentation/controllers/student_profile_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize live Supabase client using project credentials
  try {
    await Supabase.initialize(
      url: 'https://vezpmtuugcasoqzkrten.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZlenBtdHV1Z2Nhc29xemtydGVuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODUzODU3MzksImV4cCI6MjEwMDk2MTczOX0.Tdx4kgGfzxdpavAM-KgZC3b-lsj38-1-ZyT53N6HQAU',
    );
  } catch (e) {
    debugPrint('Supabase client initialization fallback to offline mock mode: $e');
  }

  runApp(const KalaApp());
}

class KalaApp extends StatelessWidget {
  const KalaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingController()),
        ChangeNotifierProvider(create: (_) => EventController()),
        ChangeNotifierProvider(create: (_) => StudentProfileController()),
      ],
      child: MaterialApp(
        title: 'KALĀ',
        debugShowCheckedModeBanner: false,
        theme: KalaTheme.lightTheme,
        initialRoute: AppRouter.initialRoute,
        routes: AppRouter.routes,
      ),
    );
  }
}
