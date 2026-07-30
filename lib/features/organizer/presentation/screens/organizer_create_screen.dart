import 'package:flutter/material.dart';
import '../../../../core/theme/kala_colors.dart';
import '../../../events/presentation/screens/event_workspace_screen.dart';
import '../../../opportunities/presentation/screens/opportunity_studio_screen.dart';
import '../../../opportunities/presentation/widgets/form_builder_widget.dart';
import '../../../opportunities/domain/models/dynamic_form_model.dart';
import '../widgets/broadcast_post_modal.dart';
import '../widgets/creation_success_checklist_dialog.dart';

class OrganizerCreateScreen extends StatefulWidget {
  final VoidCallback? onClose;

  const OrganizerCreateScreen({super.key, this.onClose});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const OrganizerCreateScreen(),
    );
  }

  @override
  State<OrganizerCreateScreen> createState() => _OrganizerCreateScreenState();
}

class _OrganizerCreateScreenState extends State<OrganizerCreateScreen> {
  // Step 0: Main Options (Event, Opportunity, Post)
  // Step 1: Sub-flow (Event Setup or Opportunity Setup)
  // Step 2: Specific Details / Templates
  int _currentStep = 0;
  String _selectedEntityType = 'Event'; // 'Event', 'Opportunity', 'Post'

  // Event Flow State
  String _eventCreationMode = 'Blank Event'; // 'Blank Event' or 'Use Template'

  // Opportunity Flow State
  String _selectedSetupMode = 'Quick Create'; // 'Quick Create' or 'Advanced Create'
  String _selectedTab = 'Drafts';

  void _goBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      if (widget.onClose != null) {
        widget.onClose!();
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.92,
      decoration: const BoxDecoration(
        color: KalaColors.ivory,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 12),
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: KalaColors.lightGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),

              // Navigation Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: KalaColors.charcoal),
                        onPressed: _goBack,
                      ),
                    Expanded(
                      child: Text(
                        _getStepHeaderTitle(),
                        style: const TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: KalaColors.charcoal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: KalaColors.lightGrey),

              // Step Content Body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _buildCurrentStepContent(context),
                  ),
                ),
              ),
            ],
          ),

          // Floating Back / Close Button
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _goBack,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: KalaColors.burntOrange,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: KalaColors.burntOrange.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    _currentStep > 0 ? Icons.arrow_back : Icons.close,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStepHeaderTitle() {
    if (_currentStep == 0) return 'What would you like to create?';
    if (_selectedEntityType == 'Event') {
      return _currentStep == 1 ? 'Choose Event Creation Method' : 'Select Event Category';
    } else if (_selectedEntityType == 'Opportunity') {
      return _currentStep == 1 ? 'How would you like to create it?' : 'Choose Opportunity Type';
    }
    return 'Create';
  }

  Widget _buildCurrentStepContent(BuildContext context) {
    if (_currentStep == 0) {
      return _buildStep0MainContent(context);
    }

    if (_selectedEntityType == 'Event') {
      return _currentStep == 1
          ? _buildEventStep1MethodContent(context)
          : _buildEventStep2CategoryContent(context);
    } else if (_selectedEntityType == 'Opportunity') {
      return _currentStep == 1
          ? _buildOpportunityStep1SetupModeContent(context)
          : _buildOpportunityStep2TypeContent(context);
    }

    return _buildStep0MainContent(context);
  }

  // ─── STEP 0: MAIN OPTIONS ──────────────────────────────────────────────────
  Widget _buildStep0MainContent(BuildContext context) {
    return Column(
      key: const ValueKey(0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 📅 Event
        _buildMainOptionCard(
          context: context,
          iconText: '📅',
          title: 'Event',
          subtitle: 'Host a festival, conference, or multi-role experience.',
          color: const Color(0xFFD97706),
          bgColor: const Color(0xFFFEF3C7),
          onTap: () {
            setState(() {
              _selectedEntityType = 'Event';
              _currentStep = 1;
            });
          },
        ),

        // 🎯 Opportunity
        _buildMainOptionCard(
          context: context,
          iconText: '🎯',
          title: 'Opportunity',
          subtitle: 'Recruit talent, volunteers, interns, or participants.',
          color: const Color(0xFF059669),
          bgColor: const Color(0xFFD1FAE5),
          onTap: () {
            setState(() {
              _selectedEntityType = 'Opportunity';
              _currentStep = 1;
            });
          },
        ),

        // 📢 Post Broadcast
        _buildMainOptionCard(
          context: context,
          iconText: '📢',
          title: 'Post',
          subtitle: 'Share announcements, results, updates, or news.',
          color: const Color(0xFF2563EB),
          bgColor: const Color(0xFFDBEAFE),
          onTap: () {
            Navigator.pop(context);
            BroadcastPostModal.show(context);
          },
        ),

        const SizedBox(height: 24),
        const Divider(color: KalaColors.lightGrey, thickness: 1),
        const SizedBox(height: 20),

        // 📝 Drafts | ⭐ Templates | 🕘 Recently Created Section
        _buildDraftsTemplatesTabs(),
      ],
    );
  }

  // ─── EVENT FLOW: STEP 1 (Blank vs Template) ───────────────────────────────
  Widget _buildEventStep1MethodContent(BuildContext context) {
    return Column(
      key: const ValueKey('event_1'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose how you want to start building your event:',
          style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 13, color: KalaColors.mediumGrey),
        ),
        const SizedBox(height: 16),

        _buildSetupModeCard(
          context: context,
          badge: '✨ Blank Event',
          subtitle: 'Start from scratch with custom details.',
          badgeColor: KalaColors.burntOrange,
          badgeBgColor: KalaColors.burntOrange.withValues(alpha: 0.1),
          description: 'Define your custom banner, description, venue, and multi-role opportunities.',
          onTap: () {
            setState(() {
              _eventCreationMode = 'Blank Event';
              _currentStep = 2;
            });
          },
        ),

        const SizedBox(height: 14),

        _buildSetupModeCard(
          context: context,
          badge: '⭐ Use Template',
          subtitle: 'Pre-filled for College Fests, Concerts & Masterclasses.',
          badgeColor: const Color(0xFFD97706),
          badgeBgColor: const Color(0xFFFEF3C7),
          description: 'Includes pre-built schedules, announcements, and audition role templates.',
          onTap: () {
            setState(() {
              _eventCreationMode = 'Use Template';
              _currentStep = 2;
            });
          },
        ),
      ],
    );
  }

  // ─── EVENT FLOW: STEP 2 (Category Selection & Launch Workspace) ───────────
  Widget _buildEventStep2CategoryContent(BuildContext context) {
    final List<Map<String, String>> categories = [
      {'title': 'College Festival', 'desc': 'Multi-tier cultural & technical university fests', 'emoji': '🎓'},
      {'title': 'Concert & Live Gig', 'desc': 'Musical performances & band showcases', 'emoji': '🎤'},
      {'title': 'Workshop Series', 'desc': 'Training sessions & masterclasses', 'emoji': '🎨'},
      {'title': 'Conference & Summit', 'desc': 'Keynotes, panels & networking summits', 'emoji': '💼'},
      {'title': 'Community Event', 'desc': 'Local jams, open mics & meetups', 'emoji': '🤝'},
      {'title': 'Other', 'desc': 'Custom event experiences', 'emoji': '✨'},
    ];

    return Column(
      key: const ValueKey('event_2'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: KalaColors.burntOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
              child: Text('Method: $_eventCreationMode', style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 11, fontWeight: FontWeight.bold, color: KalaColors.burntOrange)),
            ),
          ],
        ),
        const SizedBox(height: 16),

        ...categories.map((cat) => _buildTypeGridItem(
              cat['emoji']!,
              cat['title']!,
              cat['desc']!,
              onTap: () {
                Navigator.pop(context);

                // Show Guided Success Checklist
                CreationSuccessChecklistDialog.show(
                  context,
                  entityTitle: '${cat['title']} ($_eventCreationMode)',
                  isEvent: true,
                  items: [
                    ChecklistItem(title: 'Event Created', description: 'Basic info & workspace initialized', isCompleted: true),
                    ChecklistItem(title: 'Add First Opportunity', description: 'Recruit singers, dancers, or volunteers', isCompleted: false),
                    ChecklistItem(title: 'Build Event Schedule', description: 'Add keynotes, audition & workshop slots', isCompleted: false),
                    ChecklistItem(title: 'Publish Announcement', description: 'Broadcast event launch to students', isCompleted: false),
                  ],
                  onContinue: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EventWorkspaceScreen(
                          eventId: 'evt_101',
                          initialTabIndex: 1, // Automatically land on Opportunities tab
                        ),
                      ),
                    );
                  },
                );
              },
            )),
      ],
    );
  }

  // ─── OPPORTUNITY FLOW: STEP 1 (Quick vs Advanced) ───────────────────────
  Widget _buildOpportunityStep1SetupModeContent(BuildContext context) {
    return Column(
      key: const ValueKey('opp_1'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select your preferred creation experience:',
          style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 13, color: KalaColors.mediumGrey),
        ),
        const SizedBox(height: 16),

        _buildSetupModeCard(
          context: context,
          badge: '⚡ Quick Create',
          subtitle: '2-minute setup, essential fields only.',
          badgeColor: Colors.amber.shade800,
          badgeBgColor: Colors.amber.shade50,
          description: 'Best for urgent gigs, fast open calls, and basic application requirements.',
          onTap: () {
            setState(() {
              _selectedSetupMode = 'Quick Create';
              _currentStep = 2;
            });
          },
        ),

        const SizedBox(height: 14),

        _buildSetupModeCard(
          context: context,
          badge: '🛠️ Advanced Create',
          subtitle: 'Full customization with dynamic forms, schedules, etc.',
          badgeColor: KalaColors.burntOrange,
          badgeBgColor: KalaColors.burntOrange.withValues(alpha: 0.1),
          description: 'Includes multi-question dynamic form builder, custom screening stages, and schedule timeline.',
          onTap: () {
            setState(() {
              _selectedSetupMode = 'Advanced Create';
              _currentStep = 2;
            });
          },
        ),
      ],
    );
  }

  // ─── OPPORTUNITY FLOW: STEP 2 (Choose Type & Launch Opportunity Studio) ─
  Widget _buildOpportunityStep2TypeContent(BuildContext context) {
    final List<Map<String, String>> oppTypes = [
      {'title': 'Audition', 'desc': 'Singers, musicians & stage performers', 'emoji': '🎤'},
      {'title': 'Open Casting', 'desc': 'Actors, models & screen talent', 'emoji': '🎬'},
      {'title': 'Competition', 'desc': 'Contests, hackathons & battles', 'emoji': '🏆'},
      {'title': 'Internship', 'desc': 'Mentorship & industry internships', 'emoji': '🎓'},
      {'title': 'Workshop', 'desc': 'Training sessions & masterclasses', 'emoji': '🎨'},
      {'title': 'Collaboration', 'desc': 'Joint projects & band partnerships', 'emoji': '🤝'},
      {'title': 'Volunteer', 'desc': 'Event crew & management volunteers', 'emoji': '🙋'},
      {'title': 'Other', 'desc': 'Custom creative opportunities', 'emoji': '✨'},
    ];

    return Column(
      key: const ValueKey('opp_2'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: KalaColors.burntOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
              child: Text('Mode: $_selectedSetupMode', style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 11, fontWeight: FontWeight.bold, color: KalaColors.burntOrange)),
            ),
          ],
        ),
        const SizedBox(height: 16),

        ...oppTypes.map((type) => _buildTypeGridItem(
              type['emoji']!,
              type['title']!,
              type['desc']!,
              onTap: () {
                Navigator.pop(context);

                if (_selectedSetupMode == 'Advanced Create') {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (ctx) => SizedBox(
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: FormBuilderWidget(
                        initialForm: DynamicFormModel(
                          formId: 'form_${DateTime.now().millisecondsSinceEpoch}',
                          title: '${type['title']} Form Template',
                          fields: [],
                          createdAt: DateTime.now(),
                        ),
                        onSave: (form) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OpportunityStudioScreen(opportunityId: 'opp_301'),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  // Quick Create -> Guided Checklist Dialog -> Open Opportunity Studio
                  CreationSuccessChecklistDialog.show(
                    context,
                    entityTitle: '${type['title']} Opportunity',
                    isEvent: false,
                    items: [
                      ChecklistItem(title: 'Opportunity Published', description: 'Listing active on marketplace', isCompleted: true),
                      ChecklistItem(title: 'Review Applications', description: 'Inspect candidate portfolios in Flow', isCompleted: false),
                      ChecklistItem(title: 'Send Applicant Announcement', description: 'Notify candidates about interview schedules', isCompleted: false),
                    ],
                    onContinue: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OpportunityStudioScreen(opportunityId: 'opp_301'),
                        ),
                      );
                    },
                  );
                }
              },
            )),
      ],
    );
  }

  // ─── UI HELPER COMPONENTS ────────────────────────────────────────────────

  Widget _buildMainOptionCard({
    required BuildContext context,
    required String iconText,
    required String title,
    required String subtitle,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
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
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(14)),
              child: Center(child: Text(iconText, style: const TextStyle(fontSize: 24))),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 16, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, color: KalaColors.mediumGrey, height: 1.3)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: KalaColors.mediumGrey, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildSetupModeCard({
    required BuildContext context,
    required String badge,
    required String subtitle,
    required Color badgeColor,
    required Color badgeBgColor,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: badgeColor.withValues(alpha: 0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: badgeColor.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: badgeBgColor, borderRadius: BorderRadius.circular(20)),
                  child: Text(badge, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 13, fontWeight: FontWeight.bold, color: badgeColor)),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, size: 14, color: KalaColors.mediumGrey),
              ],
            ),
            const SizedBox(height: 12),
            Text(subtitle, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 14, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
            const SizedBox(height: 6),
            Text(description, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 11, color: KalaColors.mediumGrey, height: 1.3)),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeGridItem(String emoji, String title, String description, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: KalaColors.lightGrey),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 14, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                  const SizedBox(height: 2),
                  Text(description, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 11, color: KalaColors.mediumGrey)),
                ],
              ),
            ),
            const Icon(Icons.add_circle_outline, color: KalaColors.burntOrange, size: 20),
          ],
        ),
      ),
    );
  }

  // ─── DRAFTS, TEMPLATES & RECENTLY CREATED SECTION ────────────────────────
  Widget _buildDraftsTemplatesTabs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _tabPill('Drafts', '📝'),
            const SizedBox(width: 8),
            _tabPill('Templates', '⭐'),
            const SizedBox(width: 8),
            _tabPill('Recently Created', '🕘'),
          ],
        ),
        const SizedBox(height: 16),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _recentCard(
                'Music Fest 2026',
                'Event • Draft saved 2h ago',
                'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&q=80&w=300',
              ),
              _recentCard(
                'Short Film Audition',
                'Opportunity • Saved template',
                'https://images.unsplash.com/photo-1485846234645-a62644f84728?auto=format&fit=crop&q=80&w=300',
              ),
              _recentCard(
                'Dance Workshop Call',
                'Workshop • Published 3d ago',
                'https://images.unsplash.com/photo-1429962714451-bb934ecdc4ec?auto=format&fit=crop&q=80&w=300',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tabPill(String label, String emoji) {
    final isSelected = _selectedTab == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? KalaColors.burntOrange : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? KalaColors.burntOrange : KalaColors.lightGrey),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : KalaColors.charcoal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recentCard(String title, String subtitle, String imgUrl) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.network(
              imgUrl,
              height: 90,
              width: 170,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(height: 90, width: 170, color: KalaColors.softBeige, child: const Icon(Icons.image, color: KalaColors.mediumGrey)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                const SizedBox(height: 2),
                Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, color: KalaColors.mediumGrey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
