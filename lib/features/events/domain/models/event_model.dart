import 'event_status.dart';
import 'schedule_model.dart';
import 'announcement_model.dart';

class EventModel {
  final String eventId;
  final String organizationId;
  final String organizationName;
  final String organizationLogo;
  final String organizerId;
  final bool isVerified;
  final String title;
  final String description;
  final String bannerUrl;
  final String category;
  final String venue;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime registrationDeadline;
  final EventStatus status;
  final List<String> gallery;
  final List<ScheduleModel> schedule;
  final List<AnnouncementModel> announcements;
  final int opportunitiesCount;
  final DateTime? publishedAt;
  final DateTime? updatedAt;

  EventModel({
    required this.eventId,
    required this.organizationId,
    required this.organizationName,
    required this.organizationLogo,
    this.organizerId = '',
    this.isVerified = true,
    required this.title,
    required this.description,
    required this.bannerUrl,
    required this.category,
    required this.venue,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.registrationDeadline,
    this.status = EventStatus.registrationOpen,
    this.gallery = const [],
    this.schedule = const [],
    this.announcements = const [],
    this.opportunitiesCount = 0,
    this.publishedAt,
    this.updatedAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventId: json['event_id'] ?? '',
      organizationId: json['organization_id'] ?? '',
      organizationName: json['organization_name'] ?? '',
      organizationLogo: json['organization_logo'] ?? '',
      organizerId: json['organizer_id']?.toString() ?? '',
      isVerified: json['is_verified'] ?? true,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      bannerUrl: json['banner_url'] ?? '',
      category: json['category'] ?? '',
      venue: json['venue'] ?? '',
      location: json['location'] ?? '',
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : DateTime.now(),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : DateTime.now().add(const Duration(days: 2)),
      registrationDeadline: json['registration_deadline'] != null
          ? DateTime.parse(json['registration_deadline'])
          : DateTime.now().add(const Duration(days: 1)),
      status: EventStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => EventStatus.registrationOpen,
      ),
      gallery: List<String>.from(json['gallery'] ?? []),
      schedule:
          (json['schedule'] as List<dynamic>?)
              ?.map((item) => ScheduleModel.fromJson(item))
              .toList() ??
          [],
      announcements:
          (json['announcements'] as List<dynamic>?)
              ?.map((item) => AnnouncementModel.fromJson(item))
              .toList() ??
          [],
      opportunitiesCount: json['opportunities_count'] ?? 0,
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'organization_id': organizationId,
      'organization_name': organizationName,
      'organization_logo': organizationLogo,
      'organizer_id': organizerId,
      'is_verified': isVerified,
      'title': title,
      'description': description,
      'banner_url': bannerUrl,
      'category': category,
      'venue': venue,
      'location': location,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'registration_deadline': registrationDeadline.toIso8601String(),
      'status': status.name,
      'gallery': gallery,
      'schedule': schedule.map((s) => s.toJson()).toList(),
      'announcements': announcements.map((a) => a.toJson()).toList(),
      'opportunities_count': opportunitiesCount,
      'published_at': publishedAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
