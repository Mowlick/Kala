class AnnouncementModel {
  final String announcementId;
  final String eventId;
  final String title;
  final String content;
  final String type; // update, deadlineExtended, venueChange, results
  final DateTime publishedAt;

  AnnouncementModel({
    required this.announcementId,
    required this.eventId,
    required this.title,
    required this.content,
    required this.type,
    required this.publishedAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      announcementId: json['announcement_id'] ?? '',
      eventId: json['event_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      type: json['type'] ?? 'update',
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'announcement_id': announcementId,
      'event_id': eventId,
      'title': title,
      'content': content,
      'type': type,
      'published_at': publishedAt.toIso8601String(),
    };
  }
}
