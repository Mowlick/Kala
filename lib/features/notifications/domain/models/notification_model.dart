class KalaNotification {
  final String id;
  final String title;
  final String body;
  final String type; // status_update, event_announcement, interview_reminder
  final String? relatedEventId;
  final String? relatedSubmissionId;
  final DateTime timestamp;
  final bool isRead;

  KalaNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.relatedEventId,
    this.relatedSubmissionId,
    required this.timestamp,
    this.isRead = false,
  });

  factory KalaNotification.fromJson(Map<String, dynamic> json) {
    return KalaNotification(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? 'info',
      relatedEventId: json['related_event_id'],
      relatedSubmissionId: json['related_submission_id'],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'related_event_id': relatedEventId,
      'related_submission_id': relatedSubmissionId,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
    };
  }
}
