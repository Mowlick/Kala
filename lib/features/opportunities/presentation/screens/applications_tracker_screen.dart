import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../../../events/presentation/controllers/event_controller.dart';
import '../../../applications/domain/models/application_status.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class ApplicationsTrackerScreen extends StatefulWidget {
  const ApplicationsTrackerScreen({super.key});

  @override
  State<ApplicationsTrackerScreen> createState() =>
      _ApplicationsTrackerScreenState();
}

class _ApplicationsTrackerScreenState extends State<ApplicationsTrackerScreen> {
  String _selectedChip = 'All';
  final Set<String> _expandedCards = {'Short Film – Lead Actor'};

  void _toggleCard(String id) {
    setState(() {
      if (_expandedCards.contains(id)) {
        _expandedCards.remove(id);
      } else {
        _expandedCards.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventController = context.watch<EventController>();
    final auth = context.watch<AuthController>();
    // Filter to only this student's submissions
    final studentId = auth.currentUserId;
    final liveSubmissions = studentId.isNotEmpty
        ? eventController.submissions
              .where((s) => s.studentId == studentId)
              .toList()
        : eventController.submissions; // fallback: show all if not logged in
    final visibleSubmissions = _selectedChip == 'All'
        ? liveSubmissions
        : liveSubmissions
              .where((s) => s.status.label == _selectedChip)
              .toList();

    // Check for special status
    final hasSelected = visibleSubmissions.any(
      (s) => s.status == ApplicationStatus.selected,
    );
    final hasRejected = visibleSubmissions.any(
      (s) => s.status == ApplicationStatus.rejected,
    );

    return Scaffold(
      backgroundColor: KalaColors.ivory,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildFilterChips(liveSubmissions),
              const SizedBox(height: 24),
              _buildStatsSummary(liveSubmissions),
              const SizedBox(height: 32),
              _buildSectionTitleWithSort('Recent Applications', 'Latest First'),
              const SizedBox(height: 16),

              // Status banners
              if (hasSelected) _buildStatusBanner(isSelected: true),
              if (hasRejected && !hasSelected)
                _buildStatusBanner(isSelected: false),

              // Render Live Real-time Submissions (Supabase-backed)
              if (liveSubmissions.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: KalaColors.lightGrey),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.mark_email_unread_outlined,
                        size: 36,
                        color: KalaColors.burntOrange,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'No applications yet',
                        style: TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: KalaColors.charcoal,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Apply to a live opportunity and track its\nstatus here in real time.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 12,
                          color: KalaColors.mediumGrey,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...visibleSubmissions.map(
                  (sub) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildApplicationCard(
                      id: sub.submissionId,
                      imageUrl:
                          'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?auto=format&fit=crop&q=80&w=200',
                      type: sub.studentRole.toUpperCase(),
                      typeColor: KalaColors.burntOrange,
                      typeBgColor: KalaColors.burntOrange.withValues(
                        alpha: 0.1,
                      ),
                      title: sub.opportunityTitle,
                      company: sub.eventTitle,
                      isVerified: true,
                      location: 'Mumbai',
                      appliedDate:
                          'Applied ${sub.submittedAt.day}/${sub.submittedAt.month}/${sub.submittedAt.year}',
                      statusTag: sub.status.label,
                      statusColor: _statusColor(sub.status),
                      statusBgColor: _statusColor(
                        sub.status,
                      ).withValues(alpha: 0.1),
                      statusIcon: _statusIcon(sub.status),
                      totalStages: 5,
                      completedStages: sub.status.stepOrder,
                      stageColor: _statusColor(sub.status),
                    ),
                  ),
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ── Status helpers ────────────────────────────────────────────────────────
  Color _statusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.applied:
        return const Color(0xFF3B82F6); // Blue
      case ApplicationStatus.underReview:
        return const Color(0xFFF59E0B); // Amber
      case ApplicationStatus.interview:
        return const Color(0xFF8B5CF6); // Purple
      case ApplicationStatus.selected:
        return KalaColors.accentGreen; // Green
      case ApplicationStatus.rejected:
        return const Color(0xFFEF4444); // Red
    }
  }

  IconData _statusIcon(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.applied:
        return Icons.send_outlined;
      case ApplicationStatus.underReview:
        return Icons.hourglass_top_outlined;
      case ApplicationStatus.interview:
        return Icons.calendar_today_outlined;
      case ApplicationStatus.selected:
        return Icons.check_circle_outline;
      case ApplicationStatus.rejected:
        return Icons.cancel_outlined;
    }
  }

  Widget _buildStatusBanner({required bool isSelected}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isSelected
              ? [const Color(0xFF10B981), const Color(0xFF059669)]
              : [const Color(0xFFEF4444), const Color(0xFFDC2626)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            isSelected
                ? Icons.emoji_events_rounded
                : Icons.sentiment_dissatisfied_outlined,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSelected
                      ? '🎉 Congratulations! You\'re Selected!'
                      : 'Keep Going — Don\'t Give Up',
                  style: const TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isSelected
                      ? 'The organizer has selected you. Check your inbox for next steps.'
                      : 'This one wasn\'t a match, but more opportunities await you!',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Applications',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.charcoal,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Track every opportunity you\'ve applied for.',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 14,
                  color: KalaColors.mediumGrey,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: KalaColors.lightGrey),
              ),
              child: const Icon(
                Icons.search,
                size: 20,
                color: KalaColors.charcoal,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: KalaColors.lightGrey),
              ),
              child: Stack(
                children: [
                  const Icon(Icons.tune, size: 20, color: KalaColors.charcoal),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: KalaColors.burntOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChips(List liveSubmissions) {
    int countOf(ApplicationStatus status) =>
        liveSubmissions.where((s) => s.status == status).length;
    final chips = [
      {'label': 'All', 'count': "${liveSubmissions.length}"},
      {'label': 'Applied', 'count': '${countOf(ApplicationStatus.applied)}'},
      {
        'label': 'Under Review',
        'count': '${countOf(ApplicationStatus.underReview)}',
      },
      {
        'label': 'Interview',
        'count': '${countOf(ApplicationStatus.interview)}',
      },
      {'label': 'Selected', 'count': '${countOf(ApplicationStatus.selected)}'},
      {'label': 'Rejected', 'count': '${countOf(ApplicationStatus.rejected)}'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips.map((chip) {
          final isSelected = _selectedChip == chip['label'];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedChip = chip['label']!;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? KalaColors.burntOrange
                      : const Color(0xFFF5EBE0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? KalaColors.burntOrange
                        : Colors.transparent,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      chip['label']!,
                      style: TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected ? Colors.white : KalaColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chip['count']!,
                      style: TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 11,
                        color: isSelected
                            ? Colors.white70
                            : KalaColors.mediumGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatsSummary(List liveSubmissions) {
    int countOf(ApplicationStatus status) =>
        liveSubmissions.where((s) => s.status == status).length;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KalaColors.lightGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatBox(
              Icons.description_outlined,
              "${liveSubmissions.length}",
              'Total Applied',
              const Color(0xFFDC2626),
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _buildStatBox(
              Icons.remove_red_eye_outlined,
              '${countOf(ApplicationStatus.underReview)}',
              'Under Review',
              const Color(0xFF92400E),
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _buildStatBox(
              Icons.star_border,
              '${countOf(ApplicationStatus.interview)}',
              'Interviews',
              const Color(0xFFEA580C),
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _buildStatBox(
              Icons.check_circle_outline,
              '${countOf(ApplicationStatus.selected)}',
              'Selected',
              KalaColors.accentGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(width: 1, height: 40, color: KalaColors.lightGrey);
  }

  Widget _buildStatBox(
    IconData icon,
    String count,
    String label,
    Color iconColor,
  ) {
    return Column(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(height: 8),
        Text(
          count,
          style: TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: KalaColors.charcoal,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 10,
            color: KalaColors.mediumGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitleWithSort(String title, String sortLabel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: KalaColors.charcoal,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: KalaColors.lightGrey),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                sortLabel,
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 12,
                  color: KalaColors.charcoal,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: KalaColors.charcoal,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildApplicationCard({
    required String id,
    required String imageUrl,
    required String type,
    required Color typeColor,
    required Color typeBgColor,
    required String title,
    required String company,
    required bool isVerified,
    required String location,
    required String appliedDate,
    required String statusTag,
    required Color statusColor,
    required Color statusBgColor,
    required IconData statusIcon,
    required int totalStages,
    required int completedStages,
    required Color stageColor,
  }) {
    final isExpanded = _expandedCards.contains(id);

    return GestureDetector(
      onTap: () => _toggleCard(id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: KalaColors.lightGrey),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: KalaColors.lightGrey,
                      child: const Icon(
                        Icons.image,
                        color: KalaColors.mediumGrey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: typeBgColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              type,
                              style: TextStyle(
                                fontFamily: 'ZT_Nature',
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: typeColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: statusBgColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(statusIcon, size: 12, color: statusColor),
                                const SizedBox(width: 4),
                                Text(
                                  statusTag,
                                  style: TextStyle(
                                    fontFamily: 'ZT_Nature',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: statusColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: KalaColors.charcoal,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              company,
                              style: TextStyle(
                                fontFamily: 'ZT_Nature',
                                fontSize: 12,
                                color: KalaColors.charcoal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              size: 14,
                              color: KalaColors.accentGreen,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: KalaColors.mediumGrey,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              location,
                              style: TextStyle(
                                fontFamily: 'ZT_Nature',
                                fontSize: 12,
                                color: KalaColors.mediumGrey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '•',
                            style: TextStyle(
                              fontFamily: 'ZT_Nature',
                              fontSize: 12,
                              color: KalaColors.mediumGrey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 12,
                            color: KalaColors.mediumGrey,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              appliedDate,
                              style: TextStyle(
                                fontFamily: 'ZT_Nature',
                                fontSize: 12,
                                color: KalaColors.mediumGrey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.chevron_right,
                  size: 24,
                  color: KalaColors.charcoal,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const SizedBox(width: 76), // 60 (image width) + 16 (spacing)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: List.generate(totalStages, (index) {
                            final isCompleted = index < completedStages;
                            return Expanded(
                              child: Container(
                                height: 4,
                                margin: EdgeInsets.only(
                                  right: index < totalStages - 1 ? 4 : 0,
                                ),
                                decoration: BoxDecoration(
                                  color: isCompleted
                                      ? stageColor
                                      : KalaColors.lightGrey,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$completedStages/$totalStages stages',
                        style: TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 11,
                          color: KalaColors.mediumGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 24),
              const Divider(color: KalaColors.lightGrey, height: 1),
              const SizedBox(height: 24),
              _buildExpandedContent(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Application Timeline',
          style: TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: KalaColors.charcoal,
          ),
        ),
        const SizedBox(height: 20),
        _buildApplicationTimeline(),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildDetailsCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildOrganizerUpdateCard()),
          ],
        ),
        const SizedBox(height: 16),
        _buildSubmissionCard(),
      ],
    );
  }

  Widget _buildApplicationTimeline() {
    final stages = [
      {'label': 'Applied', 'date': '14 May', 'status': 'completed'},
      {'label': 'Profile Viewed', 'date': '15 May', 'status': 'completed'},
      {'label': 'Under Review', 'date': '16 May', 'status': 'completed'},
      {'label': 'Interview', 'date': '20 May', 'status': 'active'},
      {'label': 'Selection', 'date': 'Pending', 'status': 'future'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(stages.length, (index) {
        final status = stages[index]['status'] as String;
        final isCompleted = status == 'completed';
        final isActive = status == 'active';

        Widget icon;
        Color bgColor;
        Color borderColor;
        Color textColor;
        Color dateColor;

        if (isCompleted) {
          icon = const Icon(Icons.check, size: 14, color: Colors.white);
          bgColor = KalaColors.accentGreen;
          borderColor = KalaColors.accentGreen;
          textColor = KalaColors.charcoal;
          dateColor = KalaColors.mediumGrey;
        } else if (isActive) {
          icon = const Icon(
            Icons.calendar_today,
            size: 14,
            color: Color(0xFFEA580C),
          );
          bgColor = Colors.white;
          borderColor = const Color(0xFFEA580C);
          textColor = KalaColors.charcoal;
          dateColor = const Color(0xFFEA580C);
        } else {
          icon = const Icon(
            Icons.star_border,
            size: 14,
            color: KalaColors.mediumGrey,
          );
          bgColor = const Color(0xFFF9FAFB);
          borderColor = KalaColors.lightGrey;
          textColor = KalaColors.mediumGrey;
          dateColor = KalaColors.mediumGrey;
        }

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 2,
                      color: index == 0
                          ? Colors.transparent
                          : (stages[index - 1]['status'] == 'completed'
                                ? KalaColors.accentGreen
                                : KalaColors.lightGrey),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Center(child: icon),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: index == stages.length - 1
                          ? Colors.transparent
                          : (isCompleted
                                ? KalaColors.accentGreen
                                : KalaColors.lightGrey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                stages[index]['label']!,
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                stages[index]['date']!,
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 10,
                  color: dateColor,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF7F3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF9E4D4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: Color(0xFF92400E),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Interview Details',
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: KalaColors.charcoal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.access_time, '20 May 2025, 2:00 PM'),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.location_on_outlined, 'Koramangala, Bengaluru'),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.videocam_outlined, 'In-person audition'),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.calendar_today, size: 14),
              label: Text(
                'Add to Calendar',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFEA580C),
                side: const BorderSide(color: Color(0xFFF9E4D4)),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: KalaColors.mediumGrey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 11,
              color: KalaColors.charcoal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrganizerUpdateCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF7F3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF9E4D4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.campaign_outlined,
                      size: 16,
                      color: Color(0xFF92400E),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Organizer Update',
                        style: TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: KalaColors.charcoal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '16 May',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 10,
                  color: KalaColors.mediumGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Congratulations! You\'ve been shortlisted for the in-person audition. Please carry a valid ID and be prepared with a 2 min monologue.',
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 11,
              color: KalaColors.charcoal,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFEA580C),
                side: const BorderSide(color: Color(0xFFF9E4D4)),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View All Updates',
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF7F3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF9E4D4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: KalaColors.lightGrey),
            ),
            child: const Icon(
              Icons.description_outlined,
              size: 20,
              color: Color(0xFFDC2626),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Submission',
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: KalaColors.charcoal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Resume • Acting Reel • 2 Photos • Cover Letter',
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 10,
                    color: KalaColors.charcoal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFEA580C),
              backgroundColor: const Color(0xFFF9E4D4).withValues(alpha: 0.5),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'View Submission',
              style: TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
