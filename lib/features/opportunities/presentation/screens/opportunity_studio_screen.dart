import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../../../events/presentation/controllers/event_controller.dart';
import '../../../organizer/presentation/widgets/broadcast_post_modal.dart';
import '../../../organizer/presentation/screens/organizer_flow_screen.dart';
import '../widgets/form_builder_widget.dart';
import '../../domain/models/dynamic_form_model.dart';
import '../widgets/opportunity_share_modal.dart';

class OpportunityStudioScreen extends StatelessWidget {
  final String opportunityId;

  const OpportunityStudioScreen({super.key, required this.opportunityId});

  @override
  Widget build(BuildContext context) {
    final eventController = context.watch<EventController>();
    final opp = eventController.opportunities.firstWhere(
      (o) => o.opportunityId == opportunityId,
      orElse: () => eventController.opportunities.first,
    );
    final form = eventController.getFormById(opp.formId);

    return Scaffold(
      backgroundColor: KalaColors.ivory,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              opp.title,
              style: const TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Opportunity Studio',
              style: TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 11,
                color: KalaColors.burntOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share_outlined,
              color: KalaColors.burntOrange,
            ),
            tooltip: 'Share Opportunity',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => OpportunityShareModal(opportunity: opp),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.campaign_outlined,
              color: KalaColors.burntOrange,
            ),
            tooltip: 'Publish Announcement',
            onPressed: () {
              BroadcastPostModal.show(
                context,
                initialOpportunityId: opp.opportunityId,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & Quick Metrics Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: KalaColors.lightGrey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                          opp.status.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: KalaColors.burntOrange,
                          ),
                        ),
                      ),
                      Text(
                        'Stipend: ${opp.stipend}',
                        style: const TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: KalaColors.charcoal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _metricCol('32', 'Applicants'),
                      _metricCol('14', 'Screened'),
                      _metricCol('6', 'Shortlisted'),
                      _metricCol('3', 'Vacancies'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OrganizerFlowScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.people_alt_rounded, size: 18),
                    label: const Text(
                      'Review Applicants in Flow ATS ➔',
                      style: TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KalaColors.burntOrange,
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Studio Actions & Controls',
              style: TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: KalaColors.charcoal,
              ),
            ),
            const SizedBox(height: 12),

            // Action 1: ATS Kanban Pipeline
            _studioActionCard(
              context: context,
              icon: Icons.view_kanban_outlined,
              title: 'Applicant Flow & Pipeline',
              subtitle:
                  'Review candidates through the 10-stage recruitment pipeline',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OrganizerFlowScreen(),
                  ),
                );
              },
            ),

            // Action 2: Dynamic Form Builder
            _studioActionCard(
              context: context,
              icon: Icons.edit_note_outlined,
              title: 'Edit Dynamic Application Form',
              subtitle: form != null
                  ? 'Currently: ${form.title} (${form.fields.length} fields)'
                  : 'Build custom questions & upload rules',
              onTap: () {
                final formToEdit =
                    form ??
                    DynamicFormModel(
                      formId: opp.formId,
                      title: '${opp.title} Form',
                      fields: [],
                      createdAt: DateTime.now(),
                    );
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (ctx) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: FormBuilderWidget(
                      initialForm: formToEdit,
                      onSave: (updated) {
                        eventController.saveForm(updated);
                      },
                    ),
                  ),
                );
              },
            ),

            // Action 3: Target Broadcast Announcement
            _studioActionCard(
              context: context,
              icon: Icons.campaign_outlined,
              title: 'Broadcast Announcement to Applicants',
              subtitle: 'Send results, deadline updates, or interview details',
              onTap: () {
                BroadcastPostModal.show(
                  context,
                  initialOpportunityId: opp.opportunityId,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricCol(String val, String label) {
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

  Widget _studioActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: KalaColors.burntOrange.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: KalaColors.burntOrange, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: KalaColors.charcoal,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 11,
            color: KalaColors.mediumGrey,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: KalaColors.mediumGrey),
      ),
    );
  }
}
