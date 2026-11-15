import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kala/features/auth/presentation/controllers/auth_controller.dart';
import 'package:kala/features/events/presentation/controllers/event_controller.dart';
import 'package:kala/features/events/domain/models/event_model.dart';
import 'package:kala/features/events/domain/models/event_status.dart';
import 'package:kala/features/feed/presentation/screens/career_dashboard_screen.dart';
import 'package:kala/features/opportunities/domain/models/opportunity_model.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('organizer-published event + opportunity appear in Live From Organizers', (
    tester,
  ) async {
    // The ZT_Nature font is unavailable in tests, so the fallback font
    // overflows some fixed-size cards. Those layout warnings are irrelevant
    // to what this test verifies.
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (!details.toString().contains('RenderFlex overflowed')) {
        originalOnError?.call(details);
      }
    };
    addTearDown(() => FlutterError.onError = originalOnError);

    final controller = EventController();

    // Mimic OrganizerCreateScreen publish flow.
    await controller.addEvent(
      EventModel(
        eventId: 'evt_repro',
        organizationId: 'org_repro',
        organizationName: 'Repro Org',
        organizationLogo: '',
        title: 'REPRO EVENT TITLE',
        description: 'desc',
        category: 'College Festival',
        venue: 'V',
        location: 'Mumbai',
        status: EventStatus.registrationOpen,
        startDate: DateTime.now().add(const Duration(days: 14)),
        endDate: DateTime.now().add(const Duration(days: 16)),
        registrationDeadline: DateTime.now().add(const Duration(days: 7)),
        bannerUrl: '',
      ),
    );
    await controller.addOpportunity(
      OpportunityModel(
        opportunityId: 'opp_repro',
        eventId: '',
        title: 'REPRO OPP TITLE',
        category: 'Singer',
        vacancies: 3,
        deadline: DateTime.now().add(const Duration(days: 7)),
        formId: '',
        stipend: 'Paid',
        status: 'Open',
      ),
    );

    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthController>(create: (_) => AuthController()),
          ChangeNotifierProvider<EventController>.value(value: controller),
        ],
        child: const MaterialApp(home: CareerDashboardScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('REPRO EVENT TITLE'), findsWidgets,
        reason: 'published event must appear in Live From Organizers');
    expect(find.text('REPRO OPP TITLE'), findsWidgets,
        reason: 'published opportunity must appear in Live From Organizers');

    // Refresh control on the section header must be present and wired up.
    await tester.tap(find.byTooltip('Refresh live events'));
    await tester.pumpAndSettle();
  });
}
