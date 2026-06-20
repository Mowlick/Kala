import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/kala_theme.dart';
import 'core/navigation/app_router.dart';
import 'features/onboarding/presentation/onboarding_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase within a try-catch block.
  // This ensures that the application still boots up and runs in offline mockup demo mode
  // even if valid Supabase URL / Keys are not yet configured in local environment variables.
  try {
    await Supabase.initialize(
      url: 'https://your-supabase-url.supabase.co',
      anonKey: 'your-supabase-anon-key',
    );
  } catch (e) {
    debugPrint('Supabase client initialization skipped/fallback to mock mode: $e');
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
