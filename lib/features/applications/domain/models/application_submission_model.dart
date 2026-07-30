import 'application_status.dart';
import 'submission_answer.dart';

class ApplicationSubmissionModel {
  final String submissionId;
  final String opportunityId;
  final String opportunityTitle;
  final String eventId;
  final String eventTitle;
  final String studentId;
  final String studentName;
  final String studentAvatar;
  final String studentRole;
  final List<SubmissionAnswer> answers;
  final List<String> attachedPortfolioItemIds;
  final ApplicationStatus status;
  final int formVersion;
  final DateTime submittedAt;
  final DateTime updatedAt;

  ApplicationSubmissionModel({
    required this.submissionId,
    required this.opportunityId,
    required this.opportunityTitle,
    required this.eventId,
    required this.eventTitle,
    required this.studentId,
    required this.studentName,
    required this.studentAvatar,
    required this.studentRole,
    required this.answers,
    this.attachedPortfolioItemIds = const [],
    this.status = ApplicationStatus.applied,
    this.formVersion = 1,
    required this.submittedAt,
    required this.updatedAt,
  });

  ApplicationSubmissionModel copyWith({
    ApplicationStatus? status,
    DateTime? updatedAt,
  }) {
    return ApplicationSubmissionModel(
      submissionId: submissionId,
      opportunityId: opportunityId,
      opportunityTitle: opportunityTitle,
      eventId: eventId,
      eventTitle: eventTitle,
      studentId: studentId,
      studentName: studentName,
      studentAvatar: studentAvatar,
      studentRole: studentRole,
      answers: answers,
      attachedPortfolioItemIds: attachedPortfolioItemIds,
      status: status ?? this.status,
      formVersion: formVersion,
      submittedAt: submittedAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  factory ApplicationSubmissionModel.fromJson(Map<String, dynamic> json) {
    return ApplicationSubmissionModel(
      submissionId: json['submission_id'] ?? '',
      opportunityId: json['opportunity_id'] ?? '',
      opportunityTitle: json['opportunity_title'] ?? '',
      eventId: json['event_id'] ?? '',
      eventTitle: json['event_title'] ?? '',
      studentId: json['student_id'] ?? '',
      studentName: json['student_name'] ?? '',
      studentAvatar: json['student_avatar'] ?? '',
      studentRole: json['student_role'] ?? 'Performer',
      answers: (json['answers'] as List<dynamic>?)
              ?.map((item) => SubmissionAnswer.fromJson(item))
              .toList() ??
          [],
      attachedPortfolioItemIds: List<String>.from(json['attached_portfolio_item_ids'] ?? []),
      status: ApplicationStatusExtension.fromString(json['status'] ?? 'applied'),
      formVersion: json['form_version'] ?? 1,
      submittedAt: json['submitted_at'] != null
          ? DateTime.parse(json['submitted_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'submission_id': submissionId,
      'opportunity_id': opportunityId,
      'opportunity_title': opportunityTitle,
      'event_id': eventId,
      'event_title': eventTitle,
      'student_id': studentId,
      'student_name': studentName,
      'student_avatar': studentAvatar,
      'student_role': studentRole,
      'answers': answers.map((a) => a.toJson()).toList(),
      'attached_portfolio_item_ids': attachedPortfolioItemIds,
      'status': status.name,
      'form_version': formVersion,
      'submitted_at': submittedAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
