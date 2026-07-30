class OpportunityModel {
  final String opportunityId;
  final String eventId;
  final String title;
  final String category; // Singer, Dancer, Actor, Volunteer, Photographer
  final int vacancies;
  final DateTime deadline;
  final String formId;
  final String stipend; // e.g. "₹15,000 / gig" or "Unpaid / Certificate"
  final String status; // Open, Closing Soon, Closed
  final String visibility; // Public, Invite Only
  final DateTime? publishedAt;
  final DateTime? updatedAt;

  OpportunityModel({
    required this.opportunityId,
    required this.eventId,
    required this.title,
    required this.category,
    required this.vacancies,
    required this.deadline,
    required this.formId,
    required this.stipend,
    this.status = 'Open',
    this.visibility = 'Public',
    this.publishedAt,
    this.updatedAt,
  });

  factory OpportunityModel.fromJson(Map<String, dynamic> json) {
    return OpportunityModel(
      opportunityId: json['opportunity_id'] ?? '',
      eventId: json['event_id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      vacancies: json['vacancies'] ?? 1,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'])
          : DateTime.now().add(const Duration(days: 7)),
      formId: json['form_id'] ?? '',
      stipend: json['stipend'] ?? 'Unpaid',
      status: json['status'] ?? 'Open',
      visibility: json['visibility'] ?? 'Public',
      publishedAt: json['published_at'] != null ? DateTime.parse(json['published_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'opportunity_id': opportunityId,
      'event_id': eventId,
      'title': title,
      'category': category,
      'vacancies': vacancies,
      'deadline': deadline.toIso8601String(),
      'form_id': formId,
      'stipend': stipend,
      'status': status,
      'visibility': visibility,
      'published_at': publishedAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
