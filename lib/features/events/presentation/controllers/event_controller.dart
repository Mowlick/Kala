import 'dart:async';

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
  bool _initialFetchDone = false;
  bool _isLoadingData = false;
  String? _lastError;

  String? get lastError => _lastError;
  bool get isLoadingData => _isLoadingData;

  static final RegExp _uuidRegExp = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );

  List<EventModel> get events => List.unmodifiable(_events);
  List<OpportunityModel> get opportunities => List.unmodifiable(_opportunities);
  List<DynamicFormModel> get forms => List.unmodifiable(_forms);
  List<ApplicationSubmissionModel> get submissions =>
      List.unmodifiable(_submissions);

  EventController() {
    _seedInitialMockData();
    initRealtimeIfNeeded();
    fetchInitialData();
    _listenToAuthChanges();
  }

  /// The controller is created at app startup — often BEFORE the user signs
  /// in. With Row Level Security enabled, the unauthenticated first fetch
  /// legitimately returns nothing, so we must reload once a session exists.
  String? _loadedForUserId;

  void _listenToAuthChanges() {
    try {
      Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
        final event = data.event;
        if (event != AuthChangeEvent.signedIn &&
            event != AuthChangeEvent.initialSession &&
            event != AuthChangeEvent.tokenRefreshed) {
          return;
        }
        final uid = Supabase.instance.client.auth.currentUser?.id;
        if (uid == null || uid == _loadedForUserId) return;
        _loadedForUserId = uid;
        debugPrint('Auth session detected — reloading Kala workflow data.');

        // Re-subscribe realtime: the pre-auth channel can't receive rows.
        try {
          _realtimeChannel?.unsubscribe();
        } catch (_) {}
        _isRealtimeInitialized = false;
        initRealtimeIfNeeded();

        await refresh();
      });
    } catch (e) {
      debugPrint('Auth state listener skipped/offline: $e');
    }
  }

  void _seedInitialMockData() {
    final mockEvent = EventModel(
      eventId: 'evt_101',
      organizationId: 'org_01',
      organizationName: 'Kalā Cultural Society',
      organizationLogo:
          'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
      isVerified: true,
      title: 'National Creative Fest 2026',
      description:
          'India\'s premier creative audition fest bringing singers, dancers, filmmakers, and volunteers together.',
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
          content:
              'Registration deadline has been extended by 48 hours for Lead Vocalist applications.',
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
          options: [
            'Classical',
            'Bollywood Playback',
            'Sufi & Folk',
            'Pop & Rock',
            'Indie',
          ],
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
      studentAvatar:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
      studentRole: 'Singer / Vocalist',
      status: ApplicationStatus.underReview,
      submittedAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now(),
      answers: [
        SubmissionAnswer(
          fieldId: 'q1',
          fieldType: 'text',
          answer: 'Aarav Sharma',
        ),
        SubmissionAnswer(
          fieldId: 'q2',
          fieldType: 'dropdown',
          answer: 'Bollywood Playback',
        ),
        SubmissionAnswer(
          fieldId: 'q3',
          fieldType: 'mediaUrl',
          answer: 'https://youtube.com/watch?v=mock_reel',
        ),
      ],
    );

    _submissions.add(mockSubmission);
  }

  // ─── SUPABASE REALTIME SYNC ────────────────────────────────────────────────
  bool _isRealtimeInitialized = false;
  final Set<String> _localEventIds = {};
  final Set<String> _localOpportunityIds = {};
  final Set<String> _localSubmissionIds = {};

  void initRealtimeIfNeeded() {
    if (_isRealtimeInitialized) return;
    try {
      final client = Supabase.instance.client;
      _realtimeChannel = client
          .channel('public:kala_sync')
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'events',
            callback: (payload) =>
                _handleEventRealtimeInsert(payload.newRecord),
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'events',
            callback: (payload) =>
                _handleEventRealtimeUpdate(payload.newRecord),
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'opportunities',
            callback: (payload) =>
                _handleOpportunityRealtimeInsert(payload.newRecord),
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'opportunities',
            callback: (payload) =>
                _handleOpportunityRealtimeInsert(payload.newRecord),
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'dynamic_forms',
            callback: (payload) => _handleFormRealtimeInsert(payload.newRecord),
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'application_submissions',
            callback: (payload) {
              _handleSubmissionRealtimePayload(payload);
            },
          )
          .subscribe();
      _isRealtimeInitialized = true;
      debugPrint(
        'Kala realtime sync initialized '
        '(events / opportunities / submissions)',
      );
    } catch (e) {
      debugPrint('Realtime channel init skipped/offline: $e');
    }
  }

  /// Pull events, opportunities, forms, and submissions from Supabase on
  /// startup so a fresh session sees data created earlier. Merges with the
  /// seeded mock data and falls back silently to offline mode on error.
  Future<void> fetchInitialData() async {
    if (_initialFetchDone) return;
    _initialFetchDone = true;
    _isLoadingData = true;
    notifyListeners();

    try {
      final client = Supabase.instance.client;

      try {
        final eventRows = await client.from('events').select();
        for (final row in eventRows) {
          final id = row['id']?.toString() ?? '';
          if (id.isEmpty || _localEventIds.contains(id)) continue;
          if (_events.any(
            (e) => e.eventId == id || _ensureUuid(e.eventId) == id,
          )) {
            continue;
          }
          _events.add(_eventFromDbRecord(row));
        }
      } catch (_) {}

      try {
        final oppRows = await client.from('opportunities').select();
        for (final row in oppRows) {
          final id = row['id']?.toString() ?? '';
          if (id.isEmpty || _localOpportunityIds.contains(id)) continue;
          if (_opportunities.any(
            (o) => o.opportunityId == id || _ensureUuid(o.opportunityId) == id,
          )) {
            continue;
          }
          _opportunities.add(_opportunityFromDbRecord(row));
        }
      } catch (_) {}

      try {
        final formRows = await client.from('dynamic_forms').select();
        for (final row in formRows) {
          final id = row['id']?.toString() ?? '';
          if (id.isEmpty) continue;
          if (_forms.any(
            (f) => f.formId == id || _ensureUuid(f.formId) == id,
          )) {
            continue;
          }
          List<FormFieldSchema> fields = [];
          try {
            final fieldRows = await client
                .from('form_fields')
                .select()
                .eq('form_id', id);
            final fieldEntries =
                fieldRows
                    .map(
                      (f) => (
                        order: (f['field_order'] as num?)?.toInt() ?? 0,
                        field: FormFieldSchema(
                          id: f['id']?.toString() ?? '',
                          type: FormFieldType.values.firstWhere(
                            (e) => e.name == f['type'],
                            orElse: () => FormFieldType.text,
                          ),
                          label: f['label']?.toString() ?? '',
                          placeholder: f['placeholder']?.toString() ?? '',
                          isRequired: f['is_required'] ?? false,
                          options: List<String>.from(f['options'] ?? []),
                          acceptedFileTypes:
                              (f['accepted_file_types'] as List<dynamic>?)
                                  ?.map((e) => e.toString())
                                  .toList() ??
                              const [],
                        ),
                      ),
                    )
                    .toList()
                  ..sort((a, b) => a.order.compareTo(b.order));
            fields = fieldEntries.map((e) => e.field).toList();
          } catch (_) {}
          _forms.add(
            DynamicFormModel(
              formId: id,
              title: row['title']?.toString() ?? 'Application Form',
              isTemplate: row['is_template'] ?? false,
              version: (row['version'] as num?)?.toInt() ?? 1,
              createdAt: row['created_at'] != null
                  ? DateTime.parse(row['created_at'].toString())
                  : DateTime.now(),
              fields: fields,
            ),
          );
        }
      } catch (_) {}

      try {
        final subRows = await client
            .from('application_submissions')
            .select()
            .order('submitted_at', ascending: false);
        final answersBySubmission = await _loadAnswersGrouped(client);
        for (final row in subRows) {
          final id = row['id']?.toString() ?? '';
          if (id.isEmpty || _localSubmissionIds.contains(id)) continue;
          if (_submissions.any(
            (s) => s.submissionId == id || _ensureUuid(s.submissionId) == id,
          )) {
            continue;
          }
          _submissions.add(_submissionFromDbRow(row, answersBySubmission[id]));
        }
      } catch (_) {}

      _isLoadingData = false;
      notifyListeners();
      debugPrint('Kala initial data fetch complete.');
    } catch (_) {
      _isLoadingData = false;
      notifyListeners();
      debugPrint('Kala initial data fetch failed (offline).');
    }
  }

  /// Loads every submission answer once and groups them by submission id so
  /// organizers see the exact student responses next to each application.
  Future<Map<String, List<SubmissionAnswer>>> _loadAnswersGrouped(
    dynamic client,
  ) async {
    final Map<String, List<SubmissionAnswer>> grouped = {};
    try {
      final rows = await client.from('submission_answers').select();
      for (final row in rows) {
        final sid = row['submission_id']?.toString() ?? '';
        if (sid.isEmpty) continue;
        grouped
            .putIfAbsent(sid, () => [])
            .add(
              SubmissionAnswer.fromJson({
                'field_id': row['field_id'],
                'field_type': row['field_type'],
                'answer': row['answer'],
                'uploaded_file_url': row['uploaded_file_url'],
              }),
            );
      }
    } catch (_) {}
    return grouped;
  }

  ApplicationSubmissionModel _submissionFromDbRow(
    Map<String, dynamic> row,
    List<SubmissionAnswer>? answers,
  ) {
    return ApplicationSubmissionModel(
      submissionId: row['id']?.toString() ?? '',
      opportunityId: row['opportunity_id']?.toString() ?? '',
      opportunityTitle: row['opportunity_title']?.toString() ?? '',
      eventId: row['event_id']?.toString() ?? '',
      eventTitle: row['event_title']?.toString() ?? '',
      organizerId: row['organizer_id']?.toString() ?? '',
      studentId: row['student_id']?.toString() ?? '',
      studentName: row['student_name']?.toString() ?? 'Student',
      studentEmail: row['student_email']?.toString() ?? '',
      studentAvatar: row['student_avatar']?.toString() ?? '',
      studentRole: row['student_role']?.toString() ?? '',
      status: ApplicationStatusExtension.fromString(
        row['status']?.toString() ?? 'applied',
      ),
      submittedAt: row['submitted_at'] != null
          ? DateTime.parse(row['submitted_at'].toString())
          : DateTime.now(),
      updatedAt: row['updated_at'] != null
          ? DateTime.parse(row['updated_at'].toString())
          : DateTime.now(),
      answers: answers ?? const [],
      attachedPortfolioItemIds:
          (row['attached_portfolio_item_ids'] as List<dynamic>?)
              ?.cast<String>() ??
          const [],
    );
  }

  EventModel _eventFromDbRecord(Map<String, dynamic> r) {
    final statusStr = r['status']?.toString() ?? 'registrationOpen';
    return EventModel(
      eventId: r['id']?.toString() ?? '',
      organizationId: r['organization_id']?.toString() ?? '',
      organizationName: r['organization_name']?.toString() ?? 'Organization',
      organizationLogo: r['organization_logo']?.toString() ?? '',
      organizerId: r['organizer_id']?.toString() ?? '',
      isVerified: r['is_verified'] ?? true,
      title: r['title']?.toString() ?? 'Untitled Event',
      description: r['description']?.toString() ?? '',
      bannerUrl: r['banner_url']?.toString() ?? '',
      category: r['category']?.toString() ?? 'Event',
      venue: r['venue']?.toString() ?? '',
      location: r['location']?.toString() ?? '',
      startDate: r['start_date'] != null
          ? DateTime.parse(r['start_date'].toString())
          : DateTime.now(),
      endDate: r['end_date'] != null
          ? DateTime.parse(r['end_date'].toString())
          : DateTime.now().add(const Duration(days: 2)),
      registrationDeadline: r['registration_deadline'] != null
          ? DateTime.parse(r['registration_deadline'].toString())
          : DateTime.now().add(const Duration(days: 1)),
      status: EventStatus.values.firstWhere(
        (e) => e.name == statusStr,
        orElse: () => EventStatus.registrationOpen,
      ),
      publishedAt: r['published_at'] != null
          ? DateTime.parse(r['published_at'].toString())
          : null,
      updatedAt: r['updated_at'] != null
          ? DateTime.parse(r['updated_at'].toString())
          : null,
    );
  }

  OpportunityModel _opportunityFromDbRecord(Map<String, dynamic> r) {
    return OpportunityModel(
      opportunityId: r['id']?.toString() ?? '',
      eventId: r['event_id']?.toString() ?? '',
      organizerId: r['organizer_id']?.toString() ?? '',
      title: r['title']?.toString() ?? 'Untitled Opportunity',
      description: r['description']?.toString() ?? '',
      category: r['category']?.toString() ?? '',
      vacancies: (r['vacancies'] as num?)?.toInt() ?? 1,
      deadline: r['deadline'] != null
          ? DateTime.parse(r['deadline'].toString())
          : DateTime.now().add(const Duration(days: 7)),
      formId: r['form_id']?.toString() ?? '',
      stipend: r['stipend']?.toString() ?? 'Unpaid',
      eligibility: r['eligibility']?.toString() ?? '',
      requirements:
          (r['requirements'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      status: r['status']?.toString() ?? 'Open',
      visibility: r['visibility']?.toString() ?? 'Public',
      publishedAt: r['published_at'] != null
          ? DateTime.parse(r['published_at'].toString())
          : null,
      updatedAt: r['updated_at'] != null
          ? DateTime.parse(r['updated_at'].toString())
          : null,
    );
  }

  void _handleEventRealtimeInsert(Map<String, dynamic> record) {
    try {
      final eventId = record['id']?.toString() ?? '';
      if (eventId.isEmpty || _localEventIds.contains(eventId)) return;

      final existingIdx = _events.indexWhere(
        (e) => e.eventId == eventId || _ensureUuid(e.eventId) == eventId,
      );
      if (existingIdx != -1) return; // Local optimistic copy already shown

      _events.add(_eventFromDbRecord(record));
      notifyListeners();
    } catch (e) {
      debugPrint('Error processing event realtime insert: $e');
    }
  }

  void _handleEventRealtimeUpdate(Map<String, dynamic> record) {
    try {
      final eventId = record['id']?.toString() ?? '';
      if (eventId.isEmpty) return;
      final idx = _events.indexWhere(
        (e) => e.eventId == eventId || _ensureUuid(e.eventId) == eventId,
      );
      if (idx == -1) {
        _handleEventRealtimeInsert(record);
        return;
      }
      final incoming = _eventFromDbRecord(record);
      final existing = _events[idx];
      // Keep any local-only child data (schedule/announcements).
      _events[idx] = EventModel(
        eventId: incoming.eventId,
        organizationId: incoming.organizationId,
        organizationName: incoming.organizationName,
        organizationLogo: incoming.organizationLogo,
        organizerId: incoming.organizerId,
        isVerified: incoming.isVerified,
        title: incoming.title,
        description: incoming.description,
        bannerUrl: incoming.bannerUrl,
        category: incoming.category,
        venue: incoming.venue,
        location: incoming.location,
        startDate: incoming.startDate,
        endDate: incoming.endDate,
        registrationDeadline: incoming.registrationDeadline,
        status: incoming.status,
        gallery: existing.gallery,
        schedule: existing.schedule,
        announcements: existing.announcements,
        opportunitiesCount: existing.opportunitiesCount,
        publishedAt: incoming.publishedAt,
        updatedAt: incoming.updatedAt,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error processing event realtime update: $e');
    }
  }

  void _handleOpportunityRealtimeInsert(Map<String, dynamic> record) {
    try {
      final oppId = record['id']?.toString() ?? '';
      if (oppId.isEmpty || _localOpportunityIds.contains(oppId)) return;
      final existingIdx = _opportunities.indexWhere(
        (o) =>
            o.opportunityId == oppId || _ensureUuid(o.opportunityId) == oppId,
      );
      if (existingIdx != -1) return;

      _opportunities.add(_opportunityFromDbRecord(record));
      notifyListeners();
    } catch (e) {
      debugPrint('Error processing opportunity realtime insert: $e');
    }
  }

  /// A form published by an organizer (possibly on another device) arrives
  /// here; pull its questions so students can fill it immediately.
  Future<void> _handleFormRealtimeInsert(Map<String, dynamic> record) async {
    try {
      final formId = record['id']?.toString() ?? '';
      if (formId.isEmpty) return;
      if (_forms.any((f) => f.formId == formId)) return;

      List<FormFieldSchema> fields = [];
      try {
        final client = Supabase.instance.client;
        final fieldRows = await client
            .from('form_fields')
            .select()
            .eq('form_id', formId);
        final entries =
            fieldRows
                .map(
                  (f) => (
                    order: (f['field_order'] as num?)?.toInt() ?? 0,
                    field: FormFieldSchema(
                      id: f['id']?.toString() ?? '',
                      type: FormFieldType.values.firstWhere(
                        (e) => e.name == f['type'],
                        orElse: () => FormFieldType.text,
                      ),
                      label: f['label']?.toString() ?? '',
                      placeholder: f['placeholder']?.toString() ?? '',
                      isRequired: f['is_required'] ?? false,
                      options: List<String>.from(f['options'] ?? []),
                      acceptedFileTypes:
                          (f['accepted_file_types'] as List<dynamic>?)
                              ?.map((e) => e.toString())
                              .toList() ??
                          const [],
                    ),
                  ),
                )
                .toList()
              ..sort((a, b) => a.order.compareTo(b.order));
        fields = entries.map((e) => e.field).toList();
      } catch (_) {}

      _forms.add(
        DynamicFormModel(
          formId: formId,
          title: record['title']?.toString() ?? 'Application Form',
          isTemplate: record['is_template'] ?? false,
          version: (record['version'] as num?)?.toInt() ?? 1,
          createdAt: record['created_at'] != null
              ? DateTime.parse(record['created_at'].toString())
              : DateTime.now(),
          fields: fields,
        ),
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error processing form realtime insert: $e');
    }
  }

  void _handleSubmissionRealtimePayload(PostgresChangePayload payload) {
    try {
      // Deletes arrive with the removed row in oldRecord and empty newRecord.
      if (payload.eventType == PostgresChangeEvent.delete) {
        final deletedId = payload.oldRecord['id']?.toString() ?? '';
        if (deletedId.isNotEmpty) {
          final delIdx = _submissions.indexWhere(
            (s) =>
                s.submissionId == deletedId ||
                _ensureUuid(s.submissionId) == deletedId,
          );
          if (delIdx != -1) {
            _submissions.removeAt(delIdx);
            notifyListeners();
          }
        }
        return;
      }

      final record = payload.newRecord;
      if (record.isEmpty) return;
      final submissionId = record['id']?.toString() ?? '';
      final newStatusStr = record['status']?.toString() ?? 'applied';
      final newStatus = ApplicationStatusExtension.fromString(newStatusStr);

      final idx = _submissions.indexWhere(
        (s) =>
            s.submissionId == submissionId ||
            _ensureUuid(s.submissionId) == submissionId,
      );
      if (idx != -1) {
        final existing = _submissions[idx];
        _submissions[idx] = ApplicationSubmissionModel(
          submissionId: existing.submissionId,
          opportunityId: existing.opportunityId,
          opportunityTitle: existing.opportunityTitle,
          eventId: existing.eventId,
          eventTitle: existing.eventTitle,
          organizerId: existing.organizerId,
          studentId: existing.studentId,
          studentName: existing.studentName,
          studentEmail: existing.studentEmail,
          studentAvatar: existing.studentAvatar,
          studentRole: existing.studentRole,
          status: newStatus,
          submittedAt: existing.submittedAt,
          updatedAt: DateTime.now(),
          answers: existing.answers,
          attachedPortfolioItemIds: existing.attachedPortfolioItemIds,
        );
        notifyListeners();
        return;
      }

      // New submission arriving from another device/user.
      if (_localSubmissionIds.contains(submissionId)) return;

      final oppId = record['opportunity_id']?.toString() ?? '';
      final eventId = record['event_id']?.toString() ?? '';
      String oppTitle = record['opportunity_title']?.toString() ?? '';
      String eventTitle = record['event_title']?.toString() ?? '';
      if (oppTitle.isEmpty) {
        try {
          oppTitle = _opportunities
              .firstWhere(
                (o) =>
                    o.opportunityId == oppId ||
                    _ensureUuid(o.opportunityId) == oppId,
              )
              .title;
        } catch (_) {
          oppTitle = 'Opportunity';
        }
      }
      if (eventTitle.isEmpty) {
        eventTitle = getEventById(eventId)?.title ?? 'Event';
      }

      _submissions.add(
        ApplicationSubmissionModel(
          submissionId: submissionId,
          opportunityId: oppId,
          opportunityTitle: oppTitle,
          eventId: eventId,
          eventTitle: eventTitle,
          organizerId: record['organizer_id']?.toString() ?? '',
          studentId: record['student_id']?.toString() ?? '',
          studentName: record['student_name']?.toString() ?? 'Student',
          studentEmail: record['student_email']?.toString() ?? '',
          studentAvatar: record['student_avatar']?.toString() ?? '',
          studentRole: record['student_role']?.toString() ?? 'Performer',
          status: newStatus,
          answers: const [],
          submittedAt: record['submitted_at'] != null
              ? DateTime.parse(record['submitted_at'].toString())
              : DateTime.now(),
          updatedAt: record['updated_at'] != null
              ? DateTime.parse(record['updated_at'].toString())
              : DateTime.now(),
          attachedPortfolioItemIds:
              (record['attached_portfolio_item_ids'] as List<dynamic>?)
                  ?.cast<String>() ??
              const [],
        ),
      );
      notifyListeners();

      // Pull the student's responses for applications that arrived live.
      unawaited(_attachAnswers(submissionId));
    } catch (e) {
      debugPrint('Error processing Supabase realtime payload: $e');
    }
  }

  /// Fetches stored answers for a submission and merges them into local state.
  Future<void> _attachAnswers(String submissionId) async {
    try {
      final client = Supabase.instance.client;
      final rows = await client
          .from('submission_answers')
          .select()
          .eq('submission_id', submissionId);
      final answers = rows
          .map(
            (a) => SubmissionAnswer.fromJson({
              'field_id': a['field_id'],
              'field_type': a['field_type'],
              'answer': a['answer'],
              'uploaded_file_url': a['uploaded_file_url'],
            }),
          )
          .toList();
      if (answers.isEmpty) return;
      final idx = _submissions.indexWhere(
        (s) =>
            s.submissionId == submissionId ||
            _ensureUuid(s.submissionId) == submissionId,
      );
      if (idx != -1 && _submissions[idx].answers.isEmpty) {
        final existing = _submissions[idx];
        _submissions[idx] = ApplicationSubmissionModel(
          submissionId: existing.submissionId,
          opportunityId: existing.opportunityId,
          opportunityTitle: existing.opportunityTitle,
          eventId: existing.eventId,
          eventTitle: existing.eventTitle,
          organizerId: existing.organizerId,
          studentId: existing.studentId,
          studentName: existing.studentName,
          studentEmail: existing.studentEmail,
          studentAvatar: existing.studentAvatar,
          studentRole: existing.studentRole,
          status: existing.status,
          submittedAt: existing.submittedAt,
          updatedAt: existing.updatedAt,
          answers: answers,
          attachedPortfolioItemIds: existing.attachedPortfolioItemIds,
        );
        notifyListeners();
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _realtimeChannel?.unsubscribe();
    super.dispose();
  }

  // ─── EVENT OPERATIONS ───────────────────────────────────────────────────────
  /// Persists the event to Supabase and attaches real organizer ownership.
  /// Returns whether the insert succeeded in the backend.
  Future<bool> addEvent(EventModel event) async {
    _lastError = null;
    _localEventIds.add(event.eventId);
    _events.add(event); // Optimistic UI
    notifyListeners();

    try {
      final client = Supabase.instance.client;
      final response = await client
          .from('events')
          .insert({
            'organization_id': event.organizationId.isNotEmpty
                ? _ensureUuid(event.organizationId)
                : null,
            'organizer_id': event.organizerId.isNotEmpty
                ? _ensureUuid(event.organizerId)
                : null,
            'organization_name': event.organizationName,
            'organization_logo': event.organizationLogo,
            'is_verified': event.isVerified,
            'title': event.title,
            'description': event.description,
            'banner_url': event.bannerUrl,
            'category': event.category,
            'venue': event.venue,
            'location': event.location,
            'start_date': event.startDate.toIso8601String(),
            'end_date': event.endDate.toIso8601String(),
            'registration_deadline': event.registrationDeadline
                .toIso8601String(),
            'status': event.status.name,
            'published_at':
                event.publishedAt?.toIso8601String() ??
                DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      // Update with DB ID
      final dbId = response['id'].toString();
      if (event.eventId != dbId) {
        _localEventIds.remove(event.eventId);
        _localEventIds.add(dbId);
      }
      final idx = _events.indexWhere((e) => e.eventId == event.eventId);
      if (idx != -1) {
        final existing = _events[idx];
        _events[idx] = EventModel(
          eventId: response['id'].toString(),
          organizationId: existing.organizationId,
          organizationName: existing.organizationName,
          organizationLogo: existing.organizationLogo,
          organizerId: existing.organizerId,
          isVerified: existing.isVerified,
          title: existing.title,
          description: existing.description,
          bannerUrl: existing.bannerUrl,
          category: existing.category,
          venue: existing.venue,
          location: existing.location,
          startDate: existing.startDate,
          endDate: existing.endDate,
          registrationDeadline: existing.registrationDeadline,
          status: existing.status,
          opportunitiesCount: existing.opportunitiesCount,
          schedule: existing.schedule,
          announcements: existing.announcements,
        );
      }
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Event persistence failed: $e');
      _lastError = 'Could not publish the event. Please try again.';
      notifyListeners();
      return false;
    }
  }

  EventModel? getEventById(String eventId) {
    try {
      return _events.firstWhere(
        (e) => e.eventId == eventId || _ensureUuid(e.eventId) == eventId,
      );
    } catch (_) {
      return null;
    }
  }

  // ─── OPPORTUNITY & FORM OPERATIONS ─────────────────────────────────────────
  /// Persists the opportunity with real organizer ownership. Returns whether
  /// the insert succeeded in the backend.
  Future<bool> addOpportunity(OpportunityModel opp) async {
    _lastError = null;
    _localOpportunityIds.add(opp.opportunityId);
    _opportunities.add(opp);
    notifyListeners();

    try {
      final client = Supabase.instance.client;
      final response = await client
          .from('opportunities')
          .insert({
            // events get server-generated UUIDs; legacy/demo ids would break
            // the FK, so only link when we have a real reference.
            'event_id': _uuidRegExp.hasMatch(opp.eventId) ? opp.eventId : null,
            'organizer_id': opp.organizerId.isNotEmpty
                ? _ensureUuid(opp.organizerId)
                : null,
            'title': opp.title,
            'description': opp.description,
            'category': opp.category,
            'type': opp.category,
            'vacancies': opp.vacancies,
            'stipend': opp.stipend,
            'eligibility': opp.eligibility,
            'requirements': opp.requirements,
            'status': opp.status,
            'visibility': opp.visibility,
            'form_id': _ensureUuid(opp.formId),
            'deadline': opp.deadline.toIso8601String(),
            'published_at':
                opp.publishedAt?.toIso8601String() ??
                DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      final dbId = response['id'].toString();
      if (opp.opportunityId != dbId) {
        _localOpportunityIds.remove(opp.opportunityId);
        _localOpportunityIds.add(dbId);
      }
      final idx = _opportunities.indexWhere(
        (o) => o.opportunityId == opp.opportunityId,
      );
      if (idx != -1) {
        final existing = _opportunities[idx];
        _opportunities[idx] = OpportunityModel(
          opportunityId: response['id'].toString(),
          eventId: existing.eventId,
          organizerId: existing.organizerId,
          title: existing.title,
          description: existing.description,
          category: existing.category,
          vacancies: existing.vacancies,
          deadline: existing.deadline,
          formId: existing.formId,
          stipend: existing.stipend,
          eligibility: existing.eligibility,
          requirements: existing.requirements,
          status: existing.status,
          visibility: existing.visibility,
          publishedAt: existing.publishedAt,
          updatedAt: existing.updatedAt,
        );
      }
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Opportunity persistence failed: $e');
      _lastError = 'Could not publish the opportunity. Please try again.';
      notifyListeners();
      return false;
    }
  }

  List<OpportunityModel> getOpportunitiesForEvent(String eventId) {
    return _opportunities
        .where((o) => o.eventId == eventId || _ensureUuid(o.eventId) == eventId)
        .toList();
  }

  /// Events owned by the given organizer.
  List<EventModel> eventsForOrganizer(String organizerId) {
    if (organizerId.isEmpty) return _events;
    return _events
        .where(
          (e) =>
              e.organizerId == organizerId ||
              _ensureUuid(e.organizerId) == organizerId,
        )
        .toList();
  }

  /// Opportunities owned by the given organizer.
  List<OpportunityModel> opportunitiesForOrganizer(String organizerId) {
    if (organizerId.isEmpty) return _opportunities;
    return _opportunities
        .where(
          (o) =>
              o.organizerId == organizerId ||
              _ensureUuid(o.organizerId) == organizerId,
        )
        .toList();
  }

  /// Applications submitted to the given organizer's opportunities.
  List<ApplicationSubmissionModel> submissionsForOrganizer(String organizerId) {
    if (organizerId.isEmpty) return _submissions;
    return _submissions
        .where(
          (s) =>
              s.organizerId == organizerId ||
              _ensureUuid(s.organizerId) == organizerId,
        )
        .toList();
  }

  /// Whether the student has already applied to the given opportunity.
  bool hasApplied(String studentId, String opportunityId) {
    return _submissions.any(
      (s) =>
          s.studentId == studentId &&
          (s.opportunityId == opportunityId ||
              _ensureUuid(s.opportunityId) == _ensureUuid(opportunityId)),
    );
  }

  Future<bool> saveForm(DynamicFormModel form) async {
    final idx = _forms.indexWhere((f) => f.formId == form.formId);
    if (idx != -1) {
      _forms[idx] = form;
    } else {
      _forms.add(form);
    }
    notifyListeners();

    try {
      final client = Supabase.instance.client;
      final response = await client
          .from('dynamic_forms')
          .upsert({
            'id': _ensureUuid(form.formId),
            'title': form.title,
            'version': form.version,
            'is_template': form.isTemplate,
          })
          .select()
          .single();

      final dbId = response['id'].toString();

      // Persist every question so students see the exact organizer-built
      // form. Replace-all keeps edits/deletions in sync.
      try {
        await client.from('form_fields').delete().eq('form_id', dbId);
        if (form.fields.isNotEmpty) {
          try {
            await client.from('form_fields').insert(_fieldRows(dbId, form));
          } catch (e) {
            // Older deployments may not have the placeholder /
            // accepted_file_types columns yet — retry with core columns so
            // the questions still reach students.
            debugPrint(
              'Form field full persistence failed, retrying minimal: $e',
            );
            await client
                .from('form_fields')
                .insert(_fieldRows(dbId, form, minimal: true));
          }
        }
      } catch (e) {
        debugPrint('Form field persistence failed: $e');
      }

      final formIdx = _forms.indexWhere((f) => f.formId == form.formId);
      if (formIdx != -1 && form.formId != dbId) {
        final existing = _forms[formIdx];
        _forms[formIdx] = DynamicFormModel(
          formId: dbId,
          title: existing.title,
          isTemplate: existing.isTemplate,
          fields: existing.fields,
          createdAt: existing.createdAt,
          version: existing.version,
        );
      }
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Form persistence failed: $e');
      return false;
    }
  }

  List<Map<String, dynamic>> _fieldRows(
    String dbId,
    DynamicFormModel form, {
    bool minimal = false,
  }) {
    return form.fields.asMap().entries.map((entry) {
      final row = {
        'form_id': dbId,
        'id': entry.value.id,
        'field_order': entry.key,
        'type': entry.value.type.name,
        'label': entry.value.label,
        'is_required': entry.value.isRequired,
        'options': entry.value.options,
      };
      if (!minimal) {
        row['placeholder'] = entry.value.placeholder;
        row['accepted_file_types'] = entry.value.acceptedFileTypes;
      }
      return row;
    }).toList();
  }

  DynamicFormModel? getFormById(String formId) {
    try {
      return _forms.firstWhere(
        (f) => f.formId == formId || _ensureUuid(f.formId) == formId,
      );
    } catch (_) {
      return null;
    }
  }

  /// Fetches a single form (+ its questions) straight from Supabase and
  /// caches it locally. Used when a student opens an opportunity whose form
  /// hasn't arrived through realtime/initial sync yet.
  Future<DynamicFormModel?> loadForm(String formId) async {
    if (formId.isEmpty) return getFormById(formId);
    final existing = getFormById(formId);
    if (existing != null && existing.fields.isNotEmpty) return existing;

    try {
      final client = Supabase.instance.client;
      final dbId = _ensureUuid(formId);
      final rows = await client
          .from('dynamic_forms')
          .select()
          .eq('id', dbId)
          .limit(1);
      if (rows.isEmpty) return existing;

      final row = rows.first;
      List<FormFieldSchema> fields = [];
      try {
        final fieldRows = await client
            .from('form_fields')
            .select()
            .eq('form_id', dbId);
        final entries =
            fieldRows
                .map(
                  (f) => (
                    order: (f['field_order'] as num?)?.toInt() ?? 0,
                    field: FormFieldSchema(
                      id: f['id']?.toString() ?? '',
                      type: FormFieldType.values.firstWhere(
                        (e) => e.name == f['type'],
                        orElse: () => FormFieldType.text,
                      ),
                      label: f['label']?.toString() ?? '',
                      placeholder: f['placeholder']?.toString() ?? '',
                      isRequired: f['is_required'] ?? false,
                      options: List<String>.from(f['options'] ?? []),
                      acceptedFileTypes:
                          (f['accepted_file_types'] as List<dynamic>?)
                              ?.map((e) => e.toString())
                              .toList() ??
                          const [],
                    ),
                  ),
                )
                .toList()
              ..sort((a, b) => a.order.compareTo(b.order));
        fields = entries.map((e) => e.field).toList();
      } catch (_) {}

      final form = DynamicFormModel(
        formId: row['id']?.toString() ?? dbId,
        title: row['title']?.toString() ?? 'Application Form',
        isTemplate: row['is_template'] ?? false,
        version: (row['version'] as num?)?.toInt() ?? 1,
        createdAt: row['created_at'] != null
            ? DateTime.parse(row['created_at'].toString())
            : DateTime.now(),
        fields: fields,
      );

      final idx = _forms.indexWhere((f) => f.formId == form.formId);
      if (idx != -1) {
        _forms[idx] = form;
      } else {
        _forms.add(form);
      }
      notifyListeners();
      return form;
    } catch (e) {
      debugPrint('loadForm failed for $formId: $e');
      return existing;
    }
  }

  String _ensureUuid(String id) {
    if (id.isEmpty) return '00000000-0000-0000-0000-000000000000';
    if (RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(id)) {
      return id;
    }
    final hex = id.codeUnits
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
    final padded = hex.padRight(32, '0').substring(0, 32);
    return '${padded.substring(0, 8)}-${padded.substring(8, 12)}-${padded.substring(12, 16)}-${padded.substring(16, 20)}-${padded.substring(20, 32)}';
  }

  // ─── SUBMISSION & STATUS PIPELINE ─────────────────────────────────────────
  /// Submits an application to Supabase with student + opportunity + organizer
  /// relationships. Prevents duplicates. Returns the outcome for the UI.
  Future<({bool ok, String? message})> submitApplication(
    ApplicationSubmissionModel submission,
  ) async {
    _lastError = null;

    // Duplicate prevention: one application per student per opportunity.
    final duplicate = _submissions.any(
      (s) =>
          s.studentId == submission.studentId &&
          s.submissionId != submission.submissionId &&
          (s.opportunityId == submission.opportunityId ||
              _ensureUuid(s.opportunityId) ==
                  _ensureUuid(submission.opportunityId)),
    );
    if (duplicate) {
      return (
        ok: false,
        message: 'You have already applied to this opportunity.',
      );
    }

    _localSubmissionIds.add(submission.submissionId);
    _submissions.add(submission);
    notifyListeners();

    // Real references are UUIDs from the backend; demo/legacy ids are not.
    final isRealReference =
        _uuidRegExp.hasMatch(submission.opportunityId) &&
        _uuidRegExp.hasMatch(submission.eventId) &&
        _uuidRegExp.hasMatch(submission.studentId);

    try {
      final client = Supabase.instance.client;

      // application_submissions.student_id has an FK to users.id. Students
      // who signed up before the RLS policies (or whose profile upsert
      // failed) have no users row, which made every application silently
      // fail — and organizers never saw the applicant. Idempotent upsert.
      try {
        await client.from('users').upsert({
          'id': _ensureUuid(submission.studentId),
          'name': submission.studentName,
          'email': submission.studentEmail,
          'role': 'student',
        }, onConflict: 'id');
      } catch (e) {
        debugPrint('Student profile upsert skipped: $e');
      }

      // Ownership chain: the organizer of the application is the organizer of
      // the opportunity it belongs to (never a client-invented value).
      String organizerId = submission.organizerId;
      if (organizerId.isEmpty) {
        try {
          organizerId = _opportunities
              .firstWhere(
                (o) =>
                    o.opportunityId == submission.opportunityId ||
                    _ensureUuid(o.opportunityId) ==
                        _ensureUuid(submission.opportunityId),
              )
              .organizerId;
        } catch (_) {}
      }

      final response = await client
          .from('application_submissions')
          .insert({
            'opportunity_id': _ensureUuid(submission.opportunityId),
            'event_id': _uuidRegExp.hasMatch(submission.eventId)
                ? submission.eventId
                : null,
            'organizer_id': organizerId.isNotEmpty
                ? _ensureUuid(organizerId)
                : null,
            'student_id': _ensureUuid(submission.studentId),
            'student_name': submission.studentName,
            'student_email': submission.studentEmail,
            'student_role': submission.studentRole,
            'status': submission.status.name,
            'attached_portfolio_item_ids': submission.attachedPortfolioItemIds,
            'submitted_at': submission.submittedAt.toIso8601String(),
            'updated_at': submission.updatedAt.toIso8601String(),
          })
          .select()
          .single();

      final dbId = response['id'].toString();
      if (submission.submissionId != dbId) {
        _localSubmissionIds.remove(submission.submissionId);
        _localSubmissionIds.add(dbId);
      }

      final idx = _submissions.indexWhere(
        (s) => s.submissionId == submission.submissionId,
      );
      if (idx != -1) {
        final existing = _submissions[idx];
        _submissions[idx] = ApplicationSubmissionModel(
          submissionId: dbId,
          opportunityId: existing.opportunityId,
          opportunityTitle: existing.opportunityTitle,
          eventId: existing.eventId,
          eventTitle: existing.eventTitle,
          organizerId: existing.organizerId,
          studentId: existing.studentId,
          studentName: existing.studentName,
          studentEmail: existing.studentEmail,
          studentAvatar: existing.studentAvatar,
          studentRole: existing.studentRole,
          status: existing.status,
          submittedAt: existing.submittedAt,
          updatedAt: existing.updatedAt,
          answers: existing.answers,
          attachedPortfolioItemIds: existing.attachedPortfolioItemIds,
        );
      }

      if (submission.answers.isNotEmpty) {
        final answerRows = submission.answers
            .map(
              (a) => {
                'submission_id': dbId,
                'field_id': a.fieldId,
                'field_type': a.fieldType,
                'answer': a.answer?.toString() ?? '',
              },
            )
            .toList();
        await client.from('submission_answers').insert(answerRows);
      }

      notifyListeners();
      return (ok: true, message: null);
    } catch (e) {
      debugPrint('Application persistence failed: $e');
      if (isRealReference) {
        _submissions.removeWhere(
          (s) => s.submissionId == submission.submissionId,
        );
        _localSubmissionIds.remove(submission.submissionId);
        notifyListeners();
        _lastError = 'Failed to submit your application. Please try again.';
        return (ok: false, message: _lastError);
      }
      // Legacy/demo content without a backend row — keep the local copy so the
      // rest of the demo UI stays coherent.
      _lastError =
          'Demo content: your application was stored locally only. '
          'Publish a real opportunity to apply for real.';
      notifyListeners();
      return (ok: true, message: _lastError);
    }
  }

  void updateApplicationStatus(
    String submissionId,
    ApplicationStatus newStatus,
  ) async {
    final idx = _submissions.indexWhere(
      (s) =>
          s.submissionId == submissionId ||
          _ensureUuid(s.submissionId) == submissionId,
    );
    if (idx != -1) {
      final existing = _submissions[idx];
      _submissions[idx] = ApplicationSubmissionModel(
        submissionId: existing.submissionId,
        opportunityId: existing.opportunityId,
        opportunityTitle: existing.opportunityTitle,
        eventId: existing.eventId,
        eventTitle: existing.eventTitle,
        organizerId: existing.organizerId,
        studentId: existing.studentId,
        studentName: existing.studentName,
        studentEmail: existing.studentEmail,
        studentAvatar: existing.studentAvatar,
        studentRole: existing.studentRole,
        status: newStatus,
        submittedAt: existing.submittedAt,
        updatedAt: DateTime.now(),
        answers: existing.answers,
        attachedPortfolioItemIds: existing.attachedPortfolioItemIds,
      );
      notifyListeners();

      try {
        final client = Supabase.instance.client;
        await client
            .from('application_submissions')
            .update({
              'status': newStatus.name,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', _ensureUuid(submissionId));
      } catch (e) {
        // Offline fallback
      }
    }
  }

  // ─── MANUAL REFRESH ───────────────────────────────────────────────────────
  /// Re-tries the realtime subscription (in case it failed at startup) and
  /// re-pulls all workflow tables from Supabase, upserting into local state so
  /// the UI reflects the latest backend data (e.g. an event published on
  /// another device). Falls back silently to offline mode on error.
  Future<void> refresh() async {
    initRealtimeIfNeeded();
    _isLoadingData = true;
    notifyListeners();

    try {
      final client = Supabase.instance.client;

      try {
        final eventRows = await client.from('events').select();
        for (final row in eventRows) {
          final id = row['id']?.toString() ?? '';
          if (id.isEmpty) continue;
          final incoming = _eventFromDbRecord(row);
          final idx = _events.indexWhere(
            (e) => e.eventId == id || _ensureUuid(e.eventId) == id,
          );
          if (idx == -1) {
            _events.add(incoming);
          } else {
            // Merge, preserving any local-only child data.
            final existing = _events[idx];
            _events[idx] = EventModel(
              eventId: incoming.eventId,
              organizationId: incoming.organizationId,
              organizationName: incoming.organizationName,
              organizationLogo: incoming.organizationLogo,
              organizerId: incoming.organizerId,
              isVerified: incoming.isVerified,
              title: incoming.title,
              description: incoming.description,
              bannerUrl: incoming.bannerUrl,
              category: incoming.category,
              venue: incoming.venue,
              location: incoming.location,
              startDate: incoming.startDate,
              endDate: incoming.endDate,
              registrationDeadline: incoming.registrationDeadline,
              status: incoming.status,
              gallery: existing.gallery,
              schedule: existing.schedule,
              announcements: existing.announcements,
              opportunitiesCount: existing.opportunitiesCount,
              publishedAt: incoming.publishedAt,
              updatedAt: incoming.updatedAt,
            );
          }
        }
      } catch (_) {}

      try {
        final oppRows = await client.from('opportunities').select();
        for (final row in oppRows) {
          final id = row['id']?.toString() ?? '';
          if (id.isEmpty) continue;
          final incoming = _opportunityFromDbRecord(row);
          final idx = _opportunities.indexWhere(
            (o) => o.opportunityId == id || _ensureUuid(o.opportunityId) == id,
          );
          if (idx == -1) {
            _opportunities.add(incoming);
          } else {
            _opportunities[idx] = incoming;
          }
        }
      } catch (_) {}

      try {
        final formRows = await client.from('dynamic_forms').select();
        for (final row in formRows) {
          final id = row['id']?.toString() ?? '';
          if (id.isEmpty) continue;
          List<FormFieldSchema> fields = [];
          try {
            final fieldRows = await client
                .from('form_fields')
                .select()
                .eq('form_id', id);
            final fieldEntries =
                fieldRows
                    .map(
                      (f) => (
                        order: (f['field_order'] as num?)?.toInt() ?? 0,
                        field: FormFieldSchema(
                          id: f['id']?.toString() ?? '',
                          type: FormFieldType.values.firstWhere(
                            (e) => e.name == f['type'],
                            orElse: () => FormFieldType.text,
                          ),
                          label: f['label']?.toString() ?? '',
                          placeholder: f['placeholder']?.toString() ?? '',
                          isRequired: f['is_required'] ?? false,
                          options: List<String>.from(f['options'] ?? []),
                          acceptedFileTypes:
                              (f['accepted_file_types'] as List<dynamic>?)
                                  ?.map((e) => e.toString())
                                  .toList() ??
                              const [],
                        ),
                      ),
                    )
                    .toList()
                  ..sort((a, b) => a.order.compareTo(b.order));
            fields = fieldEntries.map((e) => e.field).toList();
          } catch (_) {}
          final incoming = DynamicFormModel(
            formId: id,
            title: row['title']?.toString() ?? 'Application Form',
            isTemplate: row['is_template'] ?? false,
            version: (row['version'] as num?)?.toInt() ?? 1,
            createdAt: row['created_at'] != null
                ? DateTime.parse(row['created_at'].toString())
                : DateTime.now(),
            fields: fields,
          );
          final idx = _forms.indexWhere(
            (f) => f.formId == id || _ensureUuid(f.formId) == id,
          );
          // Only replace when the backend copy actually has questions; never
          // clobber a locally-built form with an empty shell.
          if (idx == -1) {
            _forms.add(incoming);
          } else if (incoming.fields.isNotEmpty || _forms[idx].fields.isEmpty) {
            _forms[idx] = incoming;
          }
        }
      } catch (_) {}

      try {
        final subRows = await client
            .from('application_submissions')
            .select()
            .order('submitted_at', ascending: false);
        final answersBySubmission = await _loadAnswersGrouped(client);
        for (final row in subRows) {
          final id = row['id']?.toString() ?? '';
          if (id.isEmpty) continue;
          final incoming = _submissionFromDbRow(row, answersBySubmission[id]);
          final idx = _submissions.indexWhere(
            (s) => s.submissionId == id || _ensureUuid(s.submissionId) == id,
          );
          if (idx == -1) {
            _submissions.add(incoming);
          } else {
            _submissions[idx] = incoming;
          }
        }
      } catch (_) {}

      _isLoadingData = false;
      notifyListeners();
      debugPrint('Kala data refreshed from backend.');
    } catch (e) {
      _isLoadingData = false;
      notifyListeners();
      debugPrint('Kala refresh failed (offline): $e');
    }
  }
}
