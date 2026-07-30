import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../controllers/event_controller.dart';
import '../../domain/models/event_model.dart';
import '../../../opportunities/presentation/widgets/form_builder_widget.dart';
import '../../../opportunities/domain/models/dynamic_form_model.dart';
import '../../../organizer/presentation/widgets/broadcast_post_modal.dart';

class EventWorkspaceScreen extends StatefulWidget {
  final String eventId;
  final int initialTabIndex;

  const EventWorkspaceScreen({
    super.key,
    required this.eventId,
    this.initialTabIndex = 1, // Default to Opportunities Tab for newly created events
  });

  @override
  State<EventWorkspaceScreen> createState() => _EventWorkspaceScreenState();
}

class _EventWorkspaceScreenState extends State<EventWorkspaceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 3),
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
    final event = eventController.getEventById(widget.eventId) ??
        (eventController.events.isNotEmpty ? eventController.events.first : null);

    if (event == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Event Workspace')),
        body: const Center(child: Text('Event not found')),
      );
    }

    final opportunities = eventController.getOpportunitiesForEvent(event.eventId);

    return Scaffold(
      backgroundColor: KalaColors.ivory,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.title, style: const TextStyle(fontFamily: 'ZT_Nature', fontWeight: FontWeight.bold, fontSize: 16)),
            Text('${event.category} • Workspace', style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, color: KalaColors.burntOrange, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.campaign_outlined, color: KalaColors.burntOrange),
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
          labelColor: KalaColors.burntOrange,
          unselectedLabelColor: KalaColors.mediumGrey,
          indicatorColor: KalaColors.burntOrange,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Opportunities'),
            Tab(text: 'Schedule'),
            Tab(text: 'Announcements'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(context, event, opportunities.length),
          _buildOpportunitiesTab(context, eventController, event, opportunities),
          _buildScheduleTab(event),
          _buildAnnouncementsTab(event),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, EventModel event, int oppCount) {
    final bool hasOpportunities = oppCount > 0;
    final bool hasSchedule = event.schedule.isNotEmpty;
    final bool hasAnnouncements = event.announcements.isNotEmpty;

    int completedSteps = 1; // Event created
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
              errorBuilder: (_, __, ___) => Container(height: 180, color: KalaColors.softBeige, child: const Icon(Icons.event, size: 48, color: KalaColors.mediumGrey)),
            ),
          ),
          const SizedBox(height: 16),

          // Setup Progress Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: KalaColors.burntOrange.withValues(alpha: 0.3)),
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
                    const Text('Event Setup Completion', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 14, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                    Text('${(setupProgress * 100).toInt()}%', style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 14, fontWeight: FontWeight.bold, color: KalaColors.burntOrange)),
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
                      label: hasOpportunities ? 'Manage Roles' : '+ Add Opportunity',
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
                      onTap: () => BroadcastPostModal.show(context, initialEventId: event.eventId),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text(event.title, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 22, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: KalaColors.burntOrange),
              const SizedBox(width: 4),
              Text(event.venue, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, color: KalaColors.mediumGrey)),
            ],
          ),
          const SizedBox(height: 16),

          Text(event.description, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 14, height: 1.4, color: KalaColors.charcoal)),
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

  Widget _setupQuickBtn({required String label, required bool isDone, required VoidCallback onTap}) {
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
            if (isDone) const Icon(Icons.check, size: 12, color: KalaColors.burntOrange),
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
        Text(val, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 18, fontWeight: FontWeight.bold, color: KalaColors.burntOrange)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, color: KalaColors.mediumGrey)),
      ],
    );
  }

  Widget _buildOpportunitiesTab(BuildContext context, EventController controller, EventModel event, List opportunities) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Opportunities & Form Templates', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 16, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
            ElevatedButton.icon(
              onPressed: () {
                final defaultForm = controller.forms.isNotEmpty
                    ? controller.forms.first
                    : DynamicFormModel(formId: 'form_new', title: 'New Audition Form', fields: [], createdAt: DateTime.now());
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (opportunities.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: KalaColors.lightGrey)),
            child: const Column(
              children: [
                Icon(Icons.work_outline, size: 48, color: KalaColors.mediumGrey),
                SizedBox(height: 12),
                Text('Event Created! 🎉', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 16, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                SizedBox(height: 4),
                Text('Let\'s add your first opportunity for performers or volunteers.', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, color: KalaColors.mediumGrey)),
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
                    child: const Icon(Icons.work_outline, color: KalaColors.burntOrange),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(opp.title, style: const TextStyle(fontFamily: 'ZT_Nature', fontWeight: FontWeight.bold, fontSize: 14, color: KalaColors.charcoal)),
                        const SizedBox(height: 4),
                        Text('Stipend: ${opp.stipend} • Vacancies: ${opp.vacancies}', style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 11, color: KalaColors.mediumGrey)),
                        if (form != null)
                          Text('Form Template: ${form.title} (${form.fields.length} questions)', style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, color: KalaColors.burntOrange, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: KalaColors.mediumGrey),
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
              Text(item.time, style: const TextStyle(fontFamily: 'ZT_Nature', fontWeight: FontWeight.bold, color: KalaColors.burntOrange, fontSize: 13)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: const TextStyle(fontFamily: 'ZT_Nature', fontWeight: FontWeight.bold, fontSize: 14, color: KalaColors.charcoal)),
                    const SizedBox(height: 2),
                    Text('${item.venue} • ${item.speaker}', style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 11, color: KalaColors.mediumGrey)),
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
                  const Icon(Icons.campaign_outlined, color: KalaColors.burntOrange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(anc.title, style: const TextStyle(fontFamily: 'ZT_Nature', fontWeight: FontWeight.bold, fontSize: 14, color: KalaColors.charcoal)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(anc.content, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, height: 1.3, color: KalaColors.charcoal)),
            ],
          ),
        );
      },
    );
  }
}
