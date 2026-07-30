class ScheduleModel {
  final String scheduleId;
  final String eventId;
  final String time;
  final String title;
  final String description;
  final String venue;
  final String speaker;
  final String type; // workshop, audition, keynote, performance

  ScheduleModel({
    required this.scheduleId,
    required this.eventId,
    required this.time,
    required this.title,
    required this.description,
    required this.venue,
    required this.speaker,
    required this.type,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      scheduleId: json['schedule_id'] ?? '',
      eventId: json['event_id'] ?? '',
      time: json['time'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      venue: json['venue'] ?? '',
      speaker: json['speaker'] ?? '',
      type: json['type'] ?? 'event',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schedule_id': scheduleId,
      'event_id': eventId,
      'time': time,
      'title': title,
      'description': description,
      'venue': venue,
      'speaker': speaker,
      'type': type,
    };
  }
}
