import 'package:flutter_test/flutter_test.dart';
import 'package:kala/features/applications/domain/models/application_status.dart';
import 'package:kala/features/applications/domain/models/application_submission_model.dart';
import 'package:kala/features/events/presentation/controllers/event_controller.dart';
import 'package:kala/features/opportunities/domain/models/dynamic_form_model.dart';
import 'package:kala/features/opportunities/domain/models/form_field_schema.dart';
import 'package:kala/features/opportunities/domain/models/opportunity_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OpportunityModel full-detail round-trip', () {
    test('eligibility and requirements survive JSON serialization', () {
      final opp = OpportunityModel(
        opportunityId: 'opp_rt',
        eventId: '',
        organizerId: 'org-1',
        title: 'Lead Vocalist Audition',
        description: 'Open call\nPrepare two songs',
        category: 'Singer',
        vacancies: 2,
        deadline: DateTime(2026, 9, 1),
        formId: 'form_rt',
        stipend: '₹25,000 / gig',
        eligibility: '18-25 yrs, college students only',
        requirements: const ['Prepare two songs', 'Bring valid ID'],
        status: 'Open',
      );

      final restored = OpportunityModel.fromJson(opp.toJson());

      expect(restored.eligibility, opp.eligibility);
      expect(restored.requirements, opp.requirements);
      expect(restored.title, opp.title);
      expect(restored.organizerId, opp.organizerId);
    });
  });

  group('DynamicFormModel round-trip', () {
    test('every organizer question survives serialization', () {
      final form = DynamicFormModel(
        formId: 'form_rt2',
        title: 'Audition Form',
        fields: [
          FormFieldSchema(
            id: 'q1',
            type: FormFieldType.text,
            label: 'Stage Name',
            placeholder: 'e.g. Aarav',
            isRequired: true,
          ),
          FormFieldSchema(
            id: 'q2',
            type: FormFieldType.dropdown,
            label: 'Genre',
            options: const ['Classical', 'Pop'],
            isRequired: true,
          ),
          FormFieldSchema(
            id: 'q3',
            type: FormFieldType.fileUpload,
            label: 'Reel',
            acceptedFileTypes: const ['mp4', 'mp3'],
          ),
        ],
        createdAt: DateTime(2026, 8, 1),
      );

      final restored = DynamicFormModel.fromJson(form.toJson());

      expect(restored.fields.length, 3);
      expect(restored.fields[0].label, 'Stage Name');
      expect(restored.fields[0].placeholder, 'e.g. Aarav');
      expect(restored.fields[1].options, ['Classical', 'Pop']);
      expect(restored.fields[2].acceptedFileTypes, ['mp4', 'mp3']);
    });
  });

  group('organizer → student application workflow', () {
    late EventController controller;

    setUp(() {
      controller = EventController();
    });

    test('student can submit and duplicate is prevented', () async {
      const oppId = 'opp_workflow_test';
      const studentId = 'student_workflow_test';

      // Organizer publishes the opportunity (persists to Supabase when
      // available; always lands in local state for the student feed).
      await controller.addOpportunity(
        OpportunityModel(
          opportunityId: oppId,
          eventId: '',
          organizerId: 'organizer_workflow_test',
          title: 'Workflow Test Role',
          category: 'Singer',
          vacancies: 1,
          deadline: DateTime.now().add(const Duration(days: 3)),
          formId: '',
          stipend: 'Unpaid',
        ),
      );
      expect(
        controller.opportunities.any((o) => o.opportunityId == oppId),
        isTrue,
      );

      // First submission succeeds.
      final first = await controller.submitApplication(
        _submission(oppId, studentId, 'sub_1'),
      );
      expect(first.ok, isTrue);
      expect(controller.hasApplied(studentId, oppId), isTrue);

      // Second submission for the same opportunity is rejected.
      final second = await controller.submitApplication(
        _submission(oppId, studentId, 'sub_2'),
      );
      expect(second.ok, isFalse);
      expect(second.message, contains('already applied'));
    });

    test('different students can apply to the same opportunity', () async {
      const oppId = 'opp_workflow_test_2';
      final a = await controller.submitApplication(
        _submission(oppId, 'student_a', 'sub_a'),
      );
      final b = await controller.submitApplication(
        _submission(oppId, 'student_b', 'sub_b'),
      );
      expect(a.ok, isTrue);
      expect(b.ok, isTrue);
    });

    test('applications are scoped per organizer', () async {
      const oppId = 'opp_workflow_test_3';
      await controller.submitApplication(
        _submission(oppId, 'student_c', 'sub_c', organizerId: 'org_A'),
      );

      final orgAView = controller.submissionsForOrganizer('org_A');
      final orgBView = controller.submissionsForOrganizer('org_B');

      expect(orgAView.any((s) => s.submissionId == 'sub_c'), isTrue);
      expect(orgBView.any((s) => s.submissionId == 'sub_c'), isFalse);
    });
  });
}

ApplicationSubmissionModel _submission(
  String oppId,
  String studentId,
  String submissionId, {
  String organizerId = 'organizer_workflow_test',
}) {
  return ApplicationSubmissionModel(
    submissionId: submissionId,
    opportunityId: oppId,
    opportunityTitle: 'Workflow Test Role',
    eventId: '',
    eventTitle: 'Workflow Test Event',
    organizerId: organizerId,
    studentId: studentId,
    studentName: 'Test Student $studentId',
    studentEmail: '$studentId@test.dev',
    studentAvatar: '',
    studentRole: 'Performer',
    answers: const [],
    status: ApplicationStatus.applied,
    submittedAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}
