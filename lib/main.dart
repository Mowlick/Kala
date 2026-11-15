import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/kala_theme.dart';
import 'core/navigation/app_router.dart';
import 'features/onboarding/presentation/onboarding_controller.dart';
import 'features/events/presentation/controllers/event_controller.dart';
import 'features/profile/presentation/controllers/student_profile_controller.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase credentials default to the project's values and can be
  // overridden with build-time --dart-define variables:
  //   flutter run --dart-define=SUPABASE_URL=<your-url> \
  //               --dart-define=SUPABASE_ANON_KEY=<your-anon-key>
  // See README.md for full setup instructions.
  const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://vezpmtuugcasoqzkrten.supabase.co',
  );
  const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZlenBtdHV1Z2Nhc29xemtydGVuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODUzODU3MzksImV4cCI6MjEwMDk2MTczOX0.Tdx4kgGfzxdpavAM-KgZC3b-lsj38-1-ZyT53N6HQAU',
  );

  if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
    try {
      await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
    } catch (e) {
      // Log a safe, non-sensitive message. Do not log credentials.
      debugPrint('Supabase initialization error. Running in offline mode.');
    }
  } else {
    // No credentials provided — app runs in offline/mock mode.
    debugPrint(
      'SUPABASE_URL / SUPABASE_ANON_KEY not set. Running in offline mode.',
    );
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
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => EventController()),
        ChangeNotifierProvider(create: (_) => StudentProfileController()),
      ],
      child: MaterialApp(
        title: 'KALĀ',
        debugShowCheckedModeBanner: false,
        theme: KalaTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        routes: AppRouter.routes,
      ),
    );
  }
}
