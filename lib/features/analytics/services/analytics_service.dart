class EventAnalyticsMetrics {
  final int totalApplications;
  final double conversionRate;
  final double dropOffRate;
  final List<String> topSkillsRequested;
  final double acceptanceRate;
  final String averageReviewTime;

  EventAnalyticsMetrics({
    required this.totalApplications,
    required this.conversionRate,
    required this.dropOffRate,
    required this.topSkillsRequested,
    required this.acceptanceRate,
    required this.averageReviewTime,
  });
}

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  EventAnalyticsMetrics getMockEventMetrics(String eventId) {
    return EventAnalyticsMetrics(
      totalApplications: 142,
      conversionRate: 68.4,
      dropOffRate: 12.1,
      topSkillsRequested: ['Lead Singing', 'Cinematography', 'Contemporary Dance'],
      acceptanceRate: 18.5,
      averageReviewTime: '1.4 days',
    );
  }
}
