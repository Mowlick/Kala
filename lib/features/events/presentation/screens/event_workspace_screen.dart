import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../controllers/event_controller.dart';
import '../../domain/models/event_model.dart';
import '../../../opportunities/presentation/widgets/form_builder_widget.dart';
import '../../../opportunities/domain/models/dynamic_form_model.dart';
import '../../../organizer/presentation/widgets/broadcast_post_modal.dart';
import '../../../applications/domain/models/application_status.dart';
import '../../../applications/domain/models/application_submission_model.dart';
import '../../../organizer/presentation/screens/organizer_flow_screen.dart';

class EventWorkspaceScreen extends StatefulWidget {
  final String eventId;
  final int initialTabIndex;

  const EventWorkspaceScreen({
    super.key,
    required this.eventId,
    this.initialTabIndex =
        1, // Default to Opportunities Tab for newly created events
  });

  @override
  State<EventWorkspaceScreen> createState() => _EventWorkspaceScreenState();
}

class _EventWorkspaceScreenState extends State<EventWorkspaceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 4),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventController = context.watch<EventController>();
    final event =
        eventController.getEventById(widget.eventId) ??
        (eventController.events.isNotEmpty
            ? eventController.events.first
            : null);

    if (event == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Event Workspace')),
        body: const Center(child: Text('Event not found')),
      );
    }

    final opportunities = eventController.getOpportunitiesForEvent(
      event.eventId,
    );

    // Only applications targeting THIS event. Both sides use the same id:
    // the DB uuid once the event is persisted, the local id for legacy/mock.
    final eventSubmissions = eventController.submissions
        .where((s) => s.eventId == event.eventId)
        .toList();

    return Scaffold(
      backgroundColor: KalaColors.ivory,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: const TextStyle(
                fontFamily: 'ZT_Nature',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              '${event.category} • Workspace',
              style: const TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 10,
                color: KalaColors.burntOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.campaign_outlined,
              color: KalaColors.burntOrange,
            ),
            tooltip: 'Publish Broadcast',
            onPressed: () {
              BroadcastPostModal.show(context, initialEventId: event.eventId);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: KalaColors.burntOrange,
          unselectedLabelColor: KalaColors.mediumGrey,
          indicatorColor: KalaColors.burntOrange,
          tabs: [
            const Tab(text: 'Overview'),
            const Tab(text: 'Opportunities'),
            Tab(text: 'Applicants (${eventSubmissions.length})'),
            const Tab(text: 'Schedule'),
            const Tab(text: 'Announcements'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(
            context,
            event,
            opportunities.length,
            eventSubmissions.length,
          ),
          _buildOpportunitiesTab(
            context,
            eventController,
            event,
            opportunities,
          ),
          _buildApplicantsTab(context, eventController, eventSubmissions),
          _buildScheduleTab(event),
          _buildAnnouncementsTab(event),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(
    BuildContext context,
    EventModel event,
    int oppCount,
    int applicantCount,
  ) {
    final bool hasOpportunities = oppCount > 0;
    final bool hasSchedule = event.schedule.isNotEmpty;
    final bool hasAnnouncements = event.announcements.isNotEmpty;

    int completedSteps = 1;
    if (hasOpportunities) completedSteps++;
    if (hasSchedule) completedSteps++;
    if (hasAnnouncements) completedSteps++;
    final double setupProgress = completedSteps / 4.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              event.bannerUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: KalaColors.softBeige,
                child: const Icon(
                  Icons.event,
                  size: 48,
                  color: KalaColors.mediumGrey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // View Applicants Action Banner
          GestureDetector(
            onTap: () => _tabController.animateTo(2),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [KalaColors.charcoal, Color(0xFF2C2C2C)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: KalaColors.burntOrange.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.people_alt_rounded,
                      color: KalaColors.burntOrange,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '👥 $applicantCount Candidate Application${applicantCount == 1 ? '' : 's'}',
                          style: const TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Tap to review candidate form responses & portfolios',
                          style: TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Setup Progress Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: KalaColors.burntOrange.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: KalaColors.burntOrange.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Event Setup Completion',
                      style: TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: KalaColors.charcoal,
                      ),
                    ),
                    Text(
                      '${(setupProgress * 100).toInt()}%',
                      style: const TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: KalaColors.burntOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: setupProgress,
                    minHeight: 6,
                    backgroundColor: KalaColors.lightGrey,
                    color: KalaColors.burntOrange,
                  ),
                ),
                const SizedBox(height: 16),

                // Quick Setup Action Buttons
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _setupQuickBtn(
                      label: hasOpportunities
                          ? 'Manage Roles'
                          : '+ Add Opportunity',
                      isDone: hasOpportunities,
                      onTap: () => _tabController.animateTo(1),
                    ),
                    _setupQuickBtn(
                      label: hasSchedule ? 'Edit Schedule' : '+ Build Schedule',
                      isDone: hasSchedule,
                      onTap: () => _tabController.animateTo(2),
                    ),
                    _setupQuickBtn(
                      label: '📢 Broadcast',
                      isDone: hasAnnouncements,
                      onTap: () => BroadcastPostModal.show(
                        context,
                        initialEventId: event.eventId,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text(
            event.title,
            style: const TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: KalaColors.charcoal,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: KalaColors.burntOrange,
              ),
              const SizedBox(width: 4),
              Text(
                event.venue,
                style: const TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 12,
                  color: KalaColors.mediumGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            event.description,
            style: const TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 14,
              height: 1.4,
              color: KalaColors.charcoal,
            ),
          ),
          const SizedBox(height: 24),

          // Analytics Quick Stats
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: KalaColors.lightGrey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem('142', 'Applications'),
                _statItem('68%', 'Conversion'),
                _statItem('18.5%', 'Acceptance'),
                _statItem('1.4d', 'Avg Review'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _setupQuickBtn({
    required String label,
    required bool isDone,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDone ? KalaColors.softBeige : KalaColors.burntOrange,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isDone)
              const Icon(Icons.check, size: 12, color: KalaColors.burntOrange),
            if (isDone) const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isDone ? KalaColors.burntOrange : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String val, String label) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: KalaColors.burntOrange,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 10,
            color: KalaColors.mediumGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildOpportunitiesTab(
    BuildContext context,
    EventController controller,
    EventModel event,
    List opportunities,
  ) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Opportunities & Form Templates',
              style: TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: KalaColors.charcoal,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                final defaultForm = controller.forms.isNotEmpty
                    ? controller.forms.first
                    : DynamicFormModel(
                        formId: 'form_new',
                        title: 'New Audition Form',
                        fields: [],
                        createdAt: DateTime.now(),
                      );
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (ctx) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: FormBuilderWidget(
                      initialForm: defaultForm,
                      onSave: (updatedForm) {
                        controller.saveForm(updatedForm);
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 16),
              label: const Text('New Form'),
              style: ElevatedButton.styleFrom(
                backgroundColor: KalaColors.burntOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (opportunities.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: KalaColors.lightGrey),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.work_outline,
                  size: 48,
                  color: KalaColors.mediumGrey,
                ),
                SizedBox(height: 12),
                Text(
                  'Event Created! 🎉',
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: KalaColors.charcoal,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Let\'s add your first opportunity for performers or volunteers.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 12,
                    color: KalaColors.mediumGrey,
                  ),
                ),
              ],
            ),
          )
        else
          ...opportunities.map((opp) {
            final form = controller.getFormById(opp.formId);
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: KalaColors.lightGrey),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: KalaColors.burntOrange.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.work_outline,
                      color: KalaColors.burntOrange,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opp.title,
                          style: const TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: KalaColors.charcoal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Stipend: ${opp.stipend} • Vacancies: ${opp.vacancies}',
                          style: const TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 11,
                            color: KalaColors.mediumGrey,
                          ),
                        ),
                        if (form != null)
                          Text(
                            'Form Template: ${form.title} (${form.fields.length} questions)',
                            style: const TextStyle(
                              fontFamily: 'ZT_Nature',
                              fontSize: 10,
                              color: KalaColors.burntOrange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: KalaColors.mediumGrey,
                    ),
                    onPressed: () {
                      if (form != null) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (ctx) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.85,
                            child: FormBuilderWidget(
                              initialForm: form,
                              onSave: (updatedForm) {
                                controller.saveForm(updatedForm);
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildApplicantsTab(
    BuildContext context,
    EventController controller,
    List<ApplicationSubmissionModel> submissions,
  ) {
    if (submissions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.people_outline_rounded,
                size: 56,
                color: KalaColors.mediumGrey,
              ),
              const SizedBox(height: 16),
              const Text(
                'No Applications Received Yet',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.charcoal,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Share your event & opportunities on WhatsApp or social media to start receiving applications.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 12,
                  color: KalaColors.mediumGrey,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  BroadcastPostModal.show(context);
                },
                icon: const Icon(Icons.campaign, size: 18),
                label: const Text('Broadcast Event Announcement'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: KalaColors.burntOrange,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: submissions.length,
      itemBuilder: (context, index) {
        final sub = submissions[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: KalaColors.lightGrey),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      sub.studentAvatar.isNotEmpty
                          ? sub.studentAvatar
                          : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sub.studentName,
                          style: const TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: KalaColors.charcoal,
                          ),
                        ),
                        if (sub.studentEmail.isNotEmpty)
                          Text(
                            sub.studentEmail,
                            style: const TextStyle(
                              fontFamily: 'ZT_Nature',
                              fontSize: 11,
                              color: KalaColors.mediumGrey,
                            ),
                          ),
                        Text(
                          '${sub.studentRole} • ${sub.opportunityTitle}',
                          style: const TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 12,
                            color: KalaColors.burntOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: KalaColors.burntOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      sub.status.label,
                      style: const TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: KalaColors.burntOrange,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Form Answers Summary
              if (sub.answers.isNotEmpty) ...[
                const Text(
                  'Form Submissions:',
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: KalaColors.mediumGrey,
                  ),
                ),
                const SizedBox(height: 4),
                ...sub.answers.map(
                  (ans) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      '• ${ans.answer ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: KalaColors.charcoal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Attached Portfolio Badge
              if (sub.attachedPortfolioItemIds.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: KalaColors.burntOrange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${sub.attachedPortfolioItemIds.length} Verified Portfolio Items Attached',
                      style: const TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 11,
                        color: KalaColors.burntOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OrganizerFlowScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.view_kanban_outlined, size: 14),
                    label: const Text(
                      'Open in Flow ATS',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showStatusChangeModal(context, controller, sub);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KalaColors.burntOrange,
                    ),
                    child: const Text(
                      'Update Status',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStatusChangeModal(
    BuildContext context,
    EventController controller,
    ApplicationSubmissionModel sub,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update Applicant Status',
              style: const TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              sub.studentName,
              style: const TextStyle(
                fontSize: 13,
                color: KalaColors.burntOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...ApplicationStatus.values.map(
              (st) => ListTile(
                title: Text(st.label),
                trailing: sub.status == st
                    ? const Icon(
                        Icons.check_circle,
                        color: KalaColors.accentGreen,
                      )
                    : null,
                onTap: () {
                  controller.updateApplicationStatus(sub.submissionId, st);
                  Navigator.pop(ctx);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleTab(EventModel event) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: event.schedule.length,
      itemBuilder: (context, index) {
        final item = event.schedule[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: KalaColors.lightGrey),
          ),
          child: Row(
            children: [
              Text(
                item.time,
                style: const TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontWeight: FontWeight.bold,
                  color: KalaColors.burntOrange,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: KalaColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.venue} • ${item.speaker}',
                      style: const TextStyle(
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
        );
      },
    );
  }

  Widget _buildAnnouncementsTab(EventModel event) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: event.announcements.length,
      itemBuilder: (context, index) {
        final anc = event.announcements[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: KalaColors.lightGrey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.campaign_outlined,
                    color: KalaColors.burntOrange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      anc.title,
                      style: const TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: KalaColors.charcoal,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                anc.content,
                style: const TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 12,
                  height: 1.3,
                  color: KalaColors.charcoal,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
