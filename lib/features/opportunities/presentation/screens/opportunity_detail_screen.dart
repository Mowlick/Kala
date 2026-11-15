import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../../../events/presentation/controllers/event_controller.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../applications/domain/models/application_submission_model.dart';
import '../../domain/models/opportunity_model.dart';
import '../../domain/models/dynamic_form_model.dart';
import '../widgets/dynamic_form_renderer.dart';

class OpportunityDetailScreen extends StatefulWidget {
  const OpportunityDetailScreen({super.key});

  @override
  State<OpportunityDetailScreen> createState() =>
      _OpportunityDetailScreenState();
}

class _OpportunityDetailScreenState extends State<OpportunityDetailScreen> {
  bool _formLoadRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formLoadRequested) return;
    _formLoadRequested = true;

    // Make sure the organizer's application form is on this device before
    // the student taps Apply — pulls it straight from Supabase if the
    // realtime/initial sync hasn't delivered it yet.
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is OpportunityModel && args.formId.isNotEmpty) {
      final controller = context.read<EventController>();
      final existing = controller.getFormById(args.formId);
      if (existing == null || existing.fields.isEmpty) {
        controller.loadForm(args.formId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    // Accept either a real OpportunityModel or a legacy Map
    final OpportunityModel? liveOpp = args is OpportunityModel ? args : null;

    final controller = context.watch<EventController>();
    final auth = context.read<AuthController>();
    final applied =
        liveOpp != null &&
        controller.hasApplied(auth.currentUserId, liveOpp.opportunityId);
    final event = liveOpp != null
        ? controller.getEventById(liveOpp.eventId)
        : null;

    // Fallback Map for when navigated without a real model (e.g. from mock cards)
    final Map<String, dynamic> opp = args is Map<String, dynamic>
        ? args
        : {
            'title': liveOpp?.title ?? 'Dancers for Music Video',
            'location': liveOpp != null
                ? (event?.location.isNotEmpty == true
                      ? event!.location
                      : 'Mumbai, Maharashtra')
                : 'Mumbai, Maharashtra',
            'category': liveOpp?.category ?? 'AUDITION',
            'compensation': liveOpp?.stipend ?? 'Paid (₹15,000 - ₹20,000)',
            'age': liveOpp?.eligibility ?? '',
            'duration': liveOpp != null
                ? 'Closes in ${liveOpp.deadline.difference(DateTime.now()).inDays} days'
                : '3 days left',
            'tags': [liveOpp?.category ?? 'Performance'],
            'description': liveOpp?.description ?? '',
            'imageUrl':
                'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
          };

    return Scaffold(
      body: Stack(
        children: [
          // Scrolling Details Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Cover Image Banner
                Stack(
                  children: [
                    Container(
                      height: 280,
                      decoration: BoxDecoration(
                        color: KalaColors.softBeige,
                        image: DecorationImage(
                          image: NetworkImage(opp['imageUrl'] as String),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Container(
                      height: 280,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.4),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    // Back button & Bookmark
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: KalaColors.charcoal,
                                ),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.bookmark_border,
                                color: KalaColors.charcoal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // 2. Info Card
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: KalaColors.softBeige,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          opp['category'] as String,
                          style: const TextStyle(
                            color: KalaColors.burntOrange,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Title
                      Text(
                        opp['title'] as String,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                      ),
                      const SizedBox(height: 8),
                      // Organizer row
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              event?.organizationLogo.isNotEmpty == true
                                  ? event!.organizationLogo
                                  : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
                            ),
                            radius: 12,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            event?.organizationName ??
                                'Kala Studio Productions',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (event?.isVerified ?? true) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              color: KalaColors.burntOrange,
                              size: 14,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Divider
                      const Divider(color: KalaColors.softBeige, thickness: 1),
                      const SizedBox(height: 16),

                      // Quick Stats Grid
                      Row(
                        children: [
                          _buildStatItem(
                            context,
                            Icons.payments_outlined,
                            'Compensation',
                            opp['compensation'],
                          ),
                          _buildStatItem(
                            context,
                            Icons.location_on_outlined,
                            'Location',
                            opp['location'],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildStatItem(
                            context,
                            Icons.hourglass_empty_outlined,
                            'Duration',
                            opp['duration'],
                          ),
                          // Eligibility is shown exactly as the organizer
                          // wrote it; hidden when they left it blank.
                          if ((opp['age'] as String).isNotEmpty)
                            _buildStatItem(
                              context,
                              Icons.people_outline,
                              'Open for',
                              opp['age'],
                            ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      const Divider(color: KalaColors.softBeige, thickness: 1),
                      const SizedBox(height: 20),

                      // Description Section
                      Text(
                        'About the Opportunity',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        (opp['description'] as String?)?.isNotEmpty == true
                            ? opp['description'] as String
                            : 'The organizer will publish full details for this opportunity. Apply to get your profile in front of them.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: KalaColors.mediumGrey,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Requirements Section — the organizer's own published
                      // requirements, exactly as stored in Supabase.
                      if (liveOpp != null &&
                          liveOpp.requirements.isNotEmpty) ...[
                        Text(
                          'Requirements',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...liveOpp.requirements.map(
                          (r) => _buildBulletItem(context, r),
                        ),
                      ],

                      // Extra padding for bottom button space
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. Absolute Bottom Apply Button Drawer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: KalaColors.softBeige),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Deadline',
                          style: TextStyle(
                            fontSize: 11,
                            color: KalaColors.mediumGrey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          liveOpp != null
                              ? '${liveOpp.deadline.day} '
                                    '${const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][liveOpp.deadline.month - 1]} '
                                    '${liveOpp.deadline.year}'
                              : '31 May 2026',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: KalaColors.charcoal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: applied
                          ? null
                          : () async {
                              final controller = context
                                  .read<EventController>();
                              final auth = context.read<AuthController>();

                              final opportunityId =
                                  liveOpp?.opportunityId ?? '';
                              final opportunityTitle =
                                  liveOpp?.title ??
                                  opp['title'] as String? ??
                                  'Opportunity';
                              final eventId = liveOpp?.eventId ?? '';
                              final eventTitle = event?.title ?? 'KALĀ Event';

                              // Use only THIS opportunity's real form. If it
                              // hasn't synced yet, still show the application
                              // sheet — the renderer falls back to default
                              // personal-detail questions so Apply always
                              // works.
                              final linkedForm = liveOpp != null
                                  ? controller.getFormById(liveOpp.formId)
                                  : null;
                              final form =
                                  linkedForm ??
                                  DynamicFormModel(
                                    formId: liveOpp?.formId ?? '',
                                    title: 'Application Form',
                                    fields: const [],
                                    createdAt: DateTime.now(),
                                  );

                              // Kick off a background fetch in case the form
                              // simply hasn't arrived on this device yet.
                              if (linkedForm == null &&
                                  (liveOpp?.formId.isNotEmpty ?? false)) {
                                controller.loadForm(liveOpp!.formId);
                              }

                              final submission =
                                  await showModalBottomSheet<
                                    ApplicationSubmissionModel
                                  >(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (ctx) => SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.85,
                                      child: DynamicFormRenderer(
                                        form: form,
                                        opportunityId: opportunityId,
                                        opportunityTitle: opportunityTitle,
                                        eventId: eventId,
                                        eventTitle: eventTitle,
                                        organizerId: liveOpp?.organizerId ?? '',
                                        studentId: auth.currentUserId.isNotEmpty
                                            ? auth.currentUserId
                                            : 'usr_demo',
                                        onSubmit: (sub) {
                                          Navigator.pop(ctx, sub);
                                        },
                                      ),
                                    ),
                                  );

                              if (submission == null || !context.mounted) {
                                return;
                              }
                              final outcome = await controller
                                  .submitApplication(submission);
                              if (!context.mounted) return;
                              if (outcome.ok) {
                                _showApplySuccessDialog(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                      outcome.message ??
                                          'Could not submit the application. Please try again.',
                                    ),
                                  ),
                                );
                              }
                            },
                      child: Text(applied ? 'Applied ✓' : 'Apply Now'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: KalaColors.softBeige,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: KalaColors.burntOrange),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 10, color: KalaColors.mediumGrey),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: KalaColors.charcoal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: KalaColors.burntOrange),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: KalaColors.mediumGrey,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showApplySuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: KalaColors.softBeige,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: KalaColors.burntOrange,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Application Submitted!',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your KALĀ portfolio and contact details have been successfully shared with the organizer.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: KalaColors.mediumGrey,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Go back to opportunities list
                  },
                  child: const Text('Back to Gigs'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
