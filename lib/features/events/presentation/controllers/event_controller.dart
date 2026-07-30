import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/event_model.dart';
import '../../domain/models/event_status.dart';
import '../../domain/models/schedule_model.dart';
import '../../domain/models/announcement_model.dart';
import '../../../opportunities/domain/models/opportunity_model.dart';
import '../../../opportunities/domain/models/dynamic_form_model.dart';
import '../../../opportunities/domain/models/form_field_schema.dart';
import '../../../applications/domain/models/application_submission_model.dart';
import '../../../applications/domain/models/application_status.dart';
import '../../../applications/domain/models/submission_answer.dart';

class EventController extends ChangeNotifier {
  final List<EventModel> _events = [];
  final List<OpportunityModel> _opportunities = [];
  final List<DynamicFormModel> _forms = [];
  final List<ApplicationSubmissionModel> _submissions = [];
  RealtimeChannel? _realtimeChannel;

  List<EventModel> get events => List.unmodifiable(_events);
  List<OpportunityModel> get opportunities => List.unmodifiable(_opportunities);
  List<DynamicFormModel> get forms => List.unmodifiable(_forms);
  List<ApplicationSubmissionModel> get submissions => List.unmodifiable(_submissions);

  EventController() {
    _seedInitialMockData();
    _initSupabaseRealtime();
  }

  void _seedInitialMockData() {
    final mockEvent = EventModel(
      eventId: 'evt_101',
      organizationId: 'org_01',
      organizationName: 'Kalā Cultural Society',
      organizationLogo: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
      isVerified: true,
      title: 'National Creative Fest 2026',
      description: 'India\'s premier creative audition fest bringing singers, dancers, filmmakers, and volunteers together.',
      bannerUrl: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
      category: 'Music & Dance',
      venue: 'NCPA Auditorium, Nariman Point',
      location: 'Mumbai, Maharashtra',
      startDate: DateTime.now().add(const Duration(days: 10)),
      endDate: DateTime.now().add(const Duration(days: 12)),
      registrationDeadline: DateTime.now().add(const Duration(days: 5)),
      status: EventStatus.registrationOpen,
      opportunitiesCount: 2,
      schedule: [
        ScheduleModel(
          scheduleId: 'sch_1',
          eventId: 'evt_101',
          time: '10:00 AM',
          title: 'Opening Ceremony & Keynote',
          description: 'Keynote by industry leaders',
          venue: 'Main Stage',
          speaker: 'A.R. Rahman',
          type: 'keynote',
        ),
        ScheduleModel(
          scheduleId: 'sch_2',
          eventId: 'evt_101',
          time: '02:00 PM',
          title: 'Lead Vocalist Auditions',
          description: 'Live screening round for shortlisted singers',
          venue: 'Studio A',
          speaker: 'Jury Panel',
          type: 'audition',
        ),
      ],
      announcements: [
        AnnouncementModel(
          announcementId: 'anc_1',
          eventId: 'evt_101',
          title: 'Audition Deadline Extended!',
          content: 'Registration deadline has been extended by 48 hours for Lead Vocalist applications.',
          type: 'deadlineExtended',
          publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ],
    );

    _events.add(mockEvent);

    final mockForm = DynamicFormModel(
      formId: 'form_201',
      title: 'Vocalist Application Form',
      isTemplate: true,
      fields: [
        FormFieldSchema(
          id: 'q1',
          type: FormFieldType.text,
          label: 'Stage / Artist Name',
          placeholder: 'e.g. Aarav Sharma',
          isRequired: true,
        ),
        FormFieldSchema(
          id: 'q2',
          type: FormFieldType.dropdown,
          label: 'Primary Music Genre',
          options: ['Classical', 'Bollywood Playback', 'Sufi & Folk', 'Pop & Rock', 'Indie'],
          isRequired: true,
        ),
        FormFieldSchema(
          id: 'q3',
          type: FormFieldType.mediaUrl,
          label: 'Audio / Performance Reel Link',
          placeholder: 'YouTube / Soundcloud / Drive URL',
          isRequired: true,
        ),
      ],
      createdAt: DateTime.now(),
    );

    _forms.add(mockForm);

    final mockOpportunity = OpportunityModel(
      opportunityId: 'opp_301',
      eventId: 'evt_101',
      title: 'Lead Vocalist (Band Auditions)',
      category: 'Singer',
      vacancies: 3,
      deadline: DateTime.now().add(const Duration(days: 5)),
      formId: 'form_201',
      stipend: '₹25,000 / Gig + Certificate',
      status: 'Open',
    );

    _opportunities.add(mockOpportunity);

    final mockSubmission = ApplicationSubmissionModel(
      submissionId: 'sub_401',
      opportunityId: 'opp_301',
      opportunityTitle: 'Lead Vocalist (Band Auditions)',
      eventId: 'evt_101',
      eventTitle: 'National Creative Fest 2026',
      studentId: 'usr_007',
      studentName: 'Aarav Sharma',
      studentAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
      studentRole: 'Singer / Vocalist',
      status: ApplicationStatus.underReview,
      submittedAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now(),
      answers: [
        SubmissionAnswer(fieldId: 'q1', fieldType: 'text', answer: 'Aarav Sharma'),
        SubmissionAnswer(fieldId: 'q2', fieldType: 'dropdown', answer: 'Bollywood Playback'),
        SubmissionAnswer(fieldId: 'q3', fieldType: 'mediaUrl', answer: 'https://youtube.com/watch?v=mock_reel'),
      ],
    );

    _submissions.add(mockSubmission);
  }

  // ─── SUPABASE REALTIME SYNC ────────────────────────────────────────────────
  void _initSupabaseRealtime() {
    try {
      final client = Supabase.instance.client;
      _realtimeChannel = client
          .channel('public:application_submissions')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'application_submissions',
            callback: (payload) {
              _handleSubmissionRealtimePayload(payload);
            },
          )
          .subscribe();
    } catch (e) {
      debugPrint('Realtime channel init skipped/offline: $e');
    }
  }

  void _handleSubmissionRealtimePayload(PostgresChangePayload payload) {
    try {
      final record = payload.newRecord;
      if (record.isNotEmpty) {
        final submissionId = record['id']?.toString() ?? '';
        final newStatusStr = record['status']?.toString() ?? 'applied';
        final newStatus = ApplicationStatusExtension.fromString(newStatusStr);

        final idx = _submissions.indexWhere((s) => s.submissionId == submissionId);
        if (idx != -1) {
          _submissions[idx] = _submissions[idx].copyWith(
            status: newStatus,
            updatedAt: DateTime.now(),
          );
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error processing Supabase realtime payload: $e');
    }
  }

  @override
  void dispose() {
    _realtimeChannel?.unsubscribe();
    super.dispose();
  }

  // ─── EVENT OPERATIONS ───────────────────────────────────────────────────────
  void addEvent(EventModel event) async {
    _events.add(event);
    notifyListeners();

    try {
      final client = Supabase.instance.client;
      await client.from('events').insert({
        'title': event.title,
        'description': event.description,
        'banner_url': event.bannerUrl,
        'category': event.category,
        'venue': event.venue,
        'location': event.location,
        'status': event.status.name,
      });
    } catch (e) {
      debugPrint('Supabase event insert skipped/offline: $e');
    }
  }

  EventModel? getEventById(String eventId) {
    try {
      return _events.firstWhere((e) => e.eventId == eventId);
    } catch (_) {
      return null;
    }
  }

  // ─── OPPORTUNITY & FORM OPERATIONS ─────────────────────────────────────────
  void addOpportunity(OpportunityModel opp) async {
    _opportunities.add(opp);
    notifyListeners();

    try {
      final client = Supabase.instance.client;
      await client.from('opportunities').insert({
        'title': opp.title,
        'type': opp.category,
        'vacancies': opp.vacancies,
        'stipend': opp.stipend,
        'status': opp.status,
      });
    } catch (e) {
      debugPrint('Supabase opportunity insert skipped/offline: $e');
    }
  }

  List<OpportunityModel> getOpportunitiesForEvent(String eventId) {
    return _opportunities.where((o) => o.eventId == eventId).toList();
  }

  void saveForm(DynamicFormModel form) async {
    final idx = _forms.indexWhere((f) => f.formId == form.formId);
    if (idx != -1) {
      _forms[idx] = form;
    } else {
      _forms.add(form);
    }
    notifyListeners();

    try {
      final client = Supabase.instance.client;
      await client.from('dynamic_forms').upsert({
        'title': form.title,
        'version': form.version,
        'is_template': form.isTemplate,
      });
    } catch (e) {
      debugPrint('Supabase form save skipped/offline: $e');
    }
  }

  DynamicFormModel? getFormById(String formId) {
    try {
      return _forms.firstWhere((f) => f.formId == formId);
    } catch (_) {
      return null;
    }
  }

  // ─── SUBMISSION & STATUS PIPELINE ─────────────────────────────────────────
  void submitApplication(ApplicationSubmissionModel submission) async {
    _submissions.add(submission);
    notifyListeners();

    try {
      final client = Supabase.instance.client;
      await client.from('application_submissions').insert({
        'student_name': submission.studentName,
        'student_role': submission.studentRole,
        'status': submission.status.name,
        'attached_portfolio_item_ids': submission.attachedPortfolioItemIds,
      });
    } catch (e) {
      debugPrint('Supabase submission insert skipped/offline: $e');
    }
  }

  void updateApplicationStatus(String submissionId, ApplicationStatus newStatus) async {
    final idx = _submissions.indexWhere((s) => s.submissionId == submissionId);
    if (idx != -1) {
      _submissions[idx] = _submissions[idx].copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
      );
      notifyListeners();

      try {
        final client = Supabase.instance.client;
        await client.from('application_submissions').update({
          'status': newStatus.name,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', submissionId);
      } catch (e) {
        debugPrint('Supabase status update skipped/offline: $e');
      }
    }
  }
}
