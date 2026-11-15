class OpportunityModel {
  final String opportunityId;
  final String eventId;
  final String organizerId;
  final String title;
  final String description;
  final String category; // Singer, Dancer, Actor, Volunteer, Photographer
  final int vacancies;
  final DateTime deadline;
  final String formId;
  final String stipend; // e.g. "₹15,000 / gig" or "Unpaid / Certificate"
  final String eligibility; // e.g. "18-25 yrs", "College students only"
  final List<String> requirements; // bullet points shown to students
  final String status; // Open, Closing Soon, Closed
  final String visibility; // Public, Invite Only
  final DateTime? publishedAt;
  final DateTime? updatedAt;

  OpportunityModel({
    required this.opportunityId,
    required this.eventId,
    this.organizerId = '',
    required this.title,
    this.description = '',
    required this.category,
    required this.vacancies,
    required this.deadline,
    required this.formId,
    required this.stipend,
    this.eligibility = '',
    this.requirements = const [],
    this.status = 'Open',
    this.visibility = 'Public',
    this.publishedAt,
    this.updatedAt,
  });

  factory OpportunityModel.fromJson(Map<String, dynamic> json) {
    return OpportunityModel(
      opportunityId: json['opportunity_id'] ?? '',
      eventId: json['event_id'] ?? '',
      organizerId: json['organizer_id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      vacancies: json['vacancies'] ?? 1,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'])
          : DateTime.now().add(const Duration(days: 7)),
      formId: json['form_id'] ?? '',
      stipend: json['stipend'] ?? 'Unpaid',
      eligibility: json['eligibility'] ?? '',
      requirements:
          (json['requirements'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      status: json['status'] ?? 'Open',
      visibility: json['visibility'] ?? 'Public',
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
      'opportunity_id': opportunityId,
      'event_id': eventId,
      'organizer_id': organizerId,
      'title': title,
      'description': description,
      'category': category,
      'vacancies': vacancies,
      'deadline': deadline.toIso8601String(),
      'form_id': formId,
      'stipend': stipend,
      'eligibility': eligibility,
      'requirements': requirements,
      'status': status,
      'visibility': visibility,
      'published_at': publishedAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
