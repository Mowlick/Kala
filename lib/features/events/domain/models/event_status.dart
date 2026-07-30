enum EventStatus {
  draft,
  upcoming,
  registrationOpen,
  applicationsClosed,
  screening,
  interviews,
  live,
  completed,
  archived,
}

extension EventStatusExtension on EventStatus {
  String get displayName {
    switch (this) {
      case EventStatus.draft:
        return 'Draft';
      case EventStatus.upcoming:
        return 'Upcoming';
      case EventStatus.registrationOpen:
        return 'Registration Open';
      case EventStatus.applicationsClosed:
        return 'Applications Closed';
      case EventStatus.screening:
        return 'Screening';
      case EventStatus.interviews:
        return 'Interviews';
      case EventStatus.live:
        return 'Live';
      case EventStatus.completed:
        return 'Completed';
      case EventStatus.archived:
        return 'Archived';
    }
  }
}
