import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../events/presentation/controllers/event_controller.dart';
import '../../../applications/domain/models/application_status.dart';
import '../../../applications/domain/models/application_submission_model.dart';
import '../../../applications/domain/models/submission_answer.dart';

class OrganizerFlowScreen extends StatefulWidget {
  const OrganizerFlowScreen({super.key});

  @override
  State<OrganizerFlowScreen> createState() => _OrganizerFlowScreenState();
}

class _OrganizerFlowScreenState extends State<OrganizerFlowScreen> {
  @override
  void initState() {
    super.initState();
    // Pull the latest applications when Flow opens so applicants who applied
    // moments ago (or on another device) show up without an app restart.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<EventController>().refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventController = context.watch<EventController>();
    final auth = context.read<AuthController>();
    final submissions = eventController.submissionsForOrganizer(
      auth.currentUserId,
    );

    return Scaffold(
      backgroundColor: KalaColors.ivory,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildProjectDropdown(context, eventController),
              _buildKanbanBoard(context, eventController, submissions),
              _buildUpcomingInterviews(),
              _buildQuickActions(),
              _buildRecentActivity(submissions),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // ─── HEADER ───────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          if (canPop) ...[
            IconButton(
              icon: const Icon(Icons.arrow_back, color: KalaColors.charcoal),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 4),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flow',
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: KalaColors.charcoal,
                  ),
                ),
                Text(
                  'Manage applicants from discovery to selection.',
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 12,
                    color: KalaColors.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
          _iconButton(Icons.search),
          const SizedBox(width: 8),
          _iconButton(Icons.tune),
          const SizedBox(width: 8),
          _iconButton(Icons.calendar_today_outlined),
          const SizedBox(width: 8),
          _iconButton(Icons.bar_chart_outlined),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Icon(icon, size: 18, color: KalaColors.charcoal),
    );
  }

  // ─── PROJECT DROPDOWN ─────────────────────────────────────────────────────
  Widget _buildProjectDropdown(
    BuildContext context,
    EventController eventController,
  ) {
    final myEvents = eventController.eventsForOrganizer(
      context.read<AuthController>().currentUserId,
    );
    final activeEvent = myEvents.isNotEmpty ? myEvents.first : null;
    final title = activeEvent?.title ?? 'No active event';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: KalaColors.lightGrey),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: KalaColors.burntOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.event_outlined,
                size: 16,
                color: KalaColors.burntOrange,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.charcoal,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: KalaColors.accentGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: KalaColors.accentGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Active',
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: KalaColors.accentGreen,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.keyboard_arrow_down,
              color: KalaColors.mediumGrey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ─── KANBAN BOARD ─────────────────────────────────────────────────────────
  Widget _buildKanbanBoard(
    BuildContext context,
    EventController controller,
    List submissions,
  ) {
    int countOf(ApplicationStatus status) =>
        submissions.where((s) => s.status == status).length;

    return Column(
      children: [
        // Stage headers
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _stageHeader(
                'Applied',
                '${countOf(ApplicationStatus.applied)}',
                const Color(0xFFEF4444),
              ),
              _stageHeader(
                'Reviewed',
                '${countOf(ApplicationStatus.underReview)}',
                Colors.orange,
              ),
              _stageHeader(
                'Shortlisted',
                '${countOf(ApplicationStatus.selected)}',
                Colors.blue,
              ),
              _stageHeader(
                'Interview',
                '${countOf(ApplicationStatus.interview)}',
                Colors.purple,
              ),
              _stageHeader(
                'Selected',
                '${countOf(ApplicationStatus.selected)}',
                KalaColors.accentGreen,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Kanban cards
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Applied Column
              _kanbanColumn(
                _liveCards(
                  context,
                  controller,
                  submissions,
                  ApplicationStatus.applied,
                ),
              ),

              // 2. Reviewed Column
              _kanbanColumn(
                _liveCards(
                  context,
                  controller,
                  submissions,
                  ApplicationStatus.underReview,
                ),
              ),

              // 3. Shortlisted Column
              _kanbanColumn(
                _liveCards(
                  context,
                  controller,
                  submissions,
                  ApplicationStatus.selected,
                ),
              ),

              // 4. Interview Column
              _kanbanColumn(
                _liveCards(
                  context,
                  controller,
                  submissions,
                  ApplicationStatus.interview,
                ),
              ),

              // 5. Selected / Offer Column
              _kanbanColumn([
                ...submissions
                    .where((s) => s.status == ApplicationStatus.selected)
                    .map(
                      (sub) => _kanbanCard(
                        sub.studentName,
                        sub.studentRole,
                        'Offer Sent',
                        sub.studentAvatar.isNotEmpty
                            ? sub.studentAvatar
                            : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
                        onTap: () =>
                            _showStatusChangeModal(context, controller, sub),
                      ),
                    ),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }

  /// Live application cards for one pipeline stage — real student data only.
  List<Widget> _liveCards(
    BuildContext context,
    EventController controller,
    List submissions,
    ApplicationStatus status,
  ) {
    final cards = submissions
        .where((s) => s.status == status)
        .map(
          (sub) => _kanbanCard(
            sub.studentName,
            sub.studentRole,
            'Applied',
            sub.studentAvatar.isNotEmpty
                ? sub.studentAvatar
                : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
            onTap: () => _showStatusChangeModal(context, controller, sub),
          ),
        )
        .toList();
    if (cards.isEmpty) {
      cards.add(
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: KalaColors.ivory,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: KalaColors.lightGrey),
          ),
          child: const Text(
            'No applicants yet.\nNew applications appear here in real time.',
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 10,
              color: KalaColors.mediumGrey,
              height: 1.5,
            ),
          ),
        ),
      );
    }
    return cards;
  }

  Widget _stageHeader(String title, String count, Color color) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 8),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: KalaColors.charcoal,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            count,
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 11,
              color: KalaColors.mediumGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _kanbanColumn(List<Widget> cards) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        children: [
          ...cards,
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: KalaColors.lightGrey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, size: 14, color: KalaColors.mediumGrey),
                const SizedBox(width: 4),
                Text(
                  'Add',
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 12,
                    color: KalaColors.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kanbanCard(
    String name,
    String role,
    String match,
    String imgUrl, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: KalaColors.lightGrey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(imgUrl),
              onBackgroundImageError: (_, __) {},
              backgroundColor: KalaColors.softBeige,
            ),
            const SizedBox(height: 8),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: KalaColors.charcoal,
              ),
            ),
            Text(
              role,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 10,
                color: KalaColors.mediumGrey,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: KalaColors.burntOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$match Match',
                style: const TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.burntOrange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── UPCOMING INTERVIEWS ─────────────────────────────────────────────────
  Widget _buildUpcomingInterviews() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Upcoming Interviews'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: KalaColors.lightGrey),
            ),
            child: Column(
              children: [
                _interviewRow(
                  'Ishita Rao',
                  'Tomorrow, 11:00 AM',
                  'Google Meet',
                  'Confirmed',
                  KalaColors.accentGreen,
                  'Reschedule',
                  'https://images.unsplash.com/photo-1547153760-18fc86324498?auto=format&fit=crop&q=80&w=100',
                ),
                Divider(height: 1, color: KalaColors.lightGrey),
                _interviewRow(
                  'Ritvik Joshi',
                  'May 18, 03:00 PM',
                  'Google Meet',
                  'Pending',
                  Colors.orange,
                  'Send Reminder',
                  'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=100',
                ),
                Divider(height: 1, color: KalaColors.lightGrey),
                _interviewRow(
                  'Tanya B.',
                  'May 19, 04:00 PM',
                  'Google Meet',
                  'Pending',
                  Colors.orange,
                  'Reschedule',
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=100',
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _interviewRow(
    String name,
    String time,
    String platform,
    String status,
    Color statusColor,
    String action,
    String imgUrl,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(imgUrl),
            onBackgroundImageError: (_, __) {},
            backgroundColor: KalaColors.softBeige,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: KalaColors.charcoal,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 10,
                      color: KalaColors.mediumGrey,
                    ),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        time,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 10,
                          color: KalaColors.mediumGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            status,
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: KalaColors.lightGrey),
            ),
            child: Text(
              action,
              style: TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: KalaColors.charcoal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── QUICK ACTIONS ────────────────────────────────────────────────────────
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _sectionHeader('Quick Actions', showViewAll: false),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _quickActionBtn(Icons.swap_horiz, 'Move Stage'),
              _quickActionBtn(
                Icons.calendar_month_outlined,
                'Schedule Interview',
              ),
              _quickActionBtn(Icons.file_copy_outlined, 'Request Documents'),
              _quickActionBtn(Icons.mail_outline, 'Send Message'),
              _quickActionBtn(Icons.more_horiz, 'More'),
            ],
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }

  Widget _quickActionBtn(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Column(
        children: [
          Icon(icon, color: KalaColors.burntOrange, size: 22),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 10,
              color: KalaColors.charcoal,
            ),
          ),
        ],
      ),
    );
  }

  // ─── RECENT ACTIVITY ──────────────────────────────────────────────────────
  Widget _buildRecentActivity(List submissions) {
    final recent = List.from(submissions)
      ..sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
    final latest = recent.take(3).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Recent Activity'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: KalaColors.lightGrey),
            ),
            child: latest.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'No applications yet. When students apply, their activity shows up here instantly.',
                      style: TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 12,
                        color: KalaColors.mediumGrey,
                      ),
                    ),
                  )
                : Column(
                    children: [
                      for (var i = 0; i < latest.length; i++) ...[
                        if (i > 0)
                          Divider(height: 1, color: KalaColors.lightGrey),
                        _activityRow(
                          Icons.person_add_alt_1_outlined,
                          '${latest[i].studentName} applied for ${latest[i].opportunityTitle}',
                          _timeAgo(latest[i].submittedAt),
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  Widget _activityRow(IconData icon, String text, String time) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: KalaColors.softBeige,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: KalaColors.burntOrange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 12,
                color: KalaColors.charcoal,
              ),
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 10,
              color: KalaColors.mediumGrey,
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusChangeModal(
    BuildContext context,
    EventController controller,
    ApplicationSubmissionModel submission,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update Status: ${submission.studentName}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: KalaColors.charcoal,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${submission.opportunityTitle} • Current Stage: ${submission.status.label}',
              style: const TextStyle(
                fontSize: 12,
                color: KalaColors.burntOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.fact_check_outlined,
                color: KalaColors.burntOrange,
              ),
              title: const Text(
                'View Application Responses',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ZT_Nature',
                ),
              ),
              subtitle: Text(
                submission.answers.isEmpty
                    ? 'No custom answers stored'
                    : '${submission.answers.length} question(s) answered',
                style: const TextStyle(fontSize: 11),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(ctx);
                _showResponsesSheet(context, controller, submission);
              },
            ),
            const Divider(),
            ...ApplicationStatus.values.map(
              (status) => ListTile(
                title: Text(
                  status.label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: submission.status == status
                    ? const Icon(
                        Icons.check_circle,
                        color: KalaColors.burntOrange,
                      )
                    : null,
                onTap: () {
                  controller.updateApplicationStatus(
                    submission.submissionId,
                    status,
                  );
                  Navigator.pop(ctx);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows an applicant's submitted details and their answers to every
  /// organizer-created question, exactly as stored in Supabase.
  void _showResponsesSheet(
    BuildContext context,
    EventController controller,
    ApplicationSubmissionModel submission,
  ) {
    final matchingOpps = controller.opportunities
        .where(
          (o) =>
              o.opportunityId == submission.opportunityId ||
              (submission.opportunityTitle.isNotEmpty &&
                  o.title == submission.opportunityTitle),
        )
        .toList();
    final form = matchingOpps.isNotEmpty
        ? controller.getFormById(matchingOpps.first.formId)
        : null;

    String labelFor(SubmissionAnswer a) {
      if (form != null) {
        for (final field in form.fields) {
          if (field.id == a.fieldId) return field.label;
        }
      }
      return a.fieldId;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        builder: (ctx, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: KalaColors.softBeige,
                    child: Icon(Icons.person_outline),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          submission.studentName,
                          style: const TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: KalaColors.charcoal,
                          ),
                        ),
                        Text(
                          '${submission.studentEmail} • ${submission.studentRole}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: KalaColors.mediumGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Divider(height: 24),
              Text(
                'Applied for: ${submission.opportunityTitle}',
                style: const TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.burntOrange,
                ),
              ),
              Text(
                'Submitted ${submission.submittedAt.day}/${submission.submittedAt.month}/${submission.submittedAt.year}',
                style: const TextStyle(
                  fontSize: 11,
                  color: KalaColors.mediumGrey,
                ),
              ),
              const SizedBox(height: 16),
              if (submission.answers.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'No questionnaire responses were recorded for this application.',
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 12,
                      color: KalaColors.mediumGrey,
                    ),
                  ),
                )
              else
                ...submission.answers.map(
                  (a) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: KalaColors.lightGrey),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          labelFor(a),
                          style: const TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: KalaColors.mediumGrey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          a.answer?.toString() ?? '-',
                          style: const TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 14,
                            color: KalaColors.charcoal,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ─── HELPERS ──────────────────────────────────────────────────────────────
  Widget _sectionHeader(String title, {bool showViewAll = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: KalaColors.charcoal,
            ),
          ),
        ),
        if (showViewAll)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              'View all',
              style: TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: KalaColors.burntOrange,
              ),
            ),
          ),
      ],
    );
  }
}
