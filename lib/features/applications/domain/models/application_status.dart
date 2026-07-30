enum ApplicationStatus {
  applied,
  underReview,
  interview,
  selected,
  rejected,
}

extension ApplicationStatusExtension on ApplicationStatus {
  String get label {
    switch (this) {
      case ApplicationStatus.applied:
        return 'Applied';
      case ApplicationStatus.underReview:
        return 'Under Review';
      case ApplicationStatus.interview:
        return 'Interview';
      case ApplicationStatus.selected:
        return 'Selected';
      case ApplicationStatus.rejected:
        return 'Rejected';
    }
  }

  int get stepOrder {
    switch (this) {
      case ApplicationStatus.applied:
        return 1;
      case ApplicationStatus.underReview:
        return 2;
      case ApplicationStatus.interview:
        return 3;
      case ApplicationStatus.selected:
        return 4;
      case ApplicationStatus.rejected:
        return -1;
    }
  }

  static ApplicationStatus fromString(String status) {
    final lower = status.toLowerCase().replaceAll(' ', '');
    if (lower.contains('review') || lower.contains('portfolio') || lower.contains('doc')) {
      return ApplicationStatus.underReview;
    } else if (lower.contains('interview')) {
      return ApplicationStatus.interview;
    } else if (lower.contains('select') || lower.contains('confirm') || lower.contains('complete')) {
      return ApplicationStatus.selected;
    } else if (lower.contains('reject') || lower.contains('withdraw')) {
      return ApplicationStatus.rejected;
    }
    return ApplicationStatus.applied;
  }
}
