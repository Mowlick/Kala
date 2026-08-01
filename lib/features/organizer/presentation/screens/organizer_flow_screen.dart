import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../../../events/presentation/controllers/event_controller.dart';
import '../../../applications/domain/models/application_status.dart';

class OrganizerFlowScreen extends StatelessWidget {
  const OrganizerFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventController = context.watch<EventController>();
    final submissions = eventController.submissions;

    return Scaffold(
      backgroundColor: KalaColors.ivory,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildProjectDropdown(eventController),
              _buildKanbanBoard(context, eventController, submissions),
              _buildUpcomingInterviews(),
              _buildQuickActions(),
              _buildRecentActivity(),
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
                  style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 28, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
                ),
                Text(
                  'Manage applicants from discovery to selection.',
                  style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, color: KalaColors.mediumGrey),
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
  Widget _buildProjectDropdown(EventController eventController) {
    final activeEvent = eventController.events.isNotEmpty
        ? eventController.events.first
        : null;
    final title = activeEvent?.title ?? 'National Creative Fest 2026';

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
              child: const Icon(Icons.event_outlined, size: 16, color: KalaColors.burntOrange),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 14, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
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
                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: KalaColors.accentGreen, shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  const Text('Active', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 11, fontWeight: FontWeight.bold, color: KalaColors.accentGreen)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_down, color: KalaColors.mediumGrey, size: 20),
          ],
        ),
      ),
    );
  }

  // ─── KANBAN BOARD ─────────────────────────────────────────────────────────
  Widget _buildKanbanBoard(BuildContext context, EventController controller, List submissions) {
    return Column(
      children: [
        // Stage headers
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _stageHeader('Applied', '32', const Color(0xFFEF4444)),
              _stageHeader('Reviewed', '18', Colors.orange),
              _stageHeader('Shortlisted', '10', Colors.blue),
              _stageHeader('Interview', '6', Colors.purple),
              _stageHeader('Selected', '4', KalaColors.accentGreen),
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
              _kanbanColumn([
                ...submissions.where((s) => s.status == ApplicationStatus.applied).map((sub) => _kanbanCard(
                      sub.studentName,
                      sub.studentRole,
                      '95%',
                      sub.studentAvatar.isNotEmpty ? sub.studentAvatar : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
                      onTap: () => _showStatusChangeModal(context, controller, sub),
                    )),
                _kanbanCard('Aarav Mehta', 'Vocalist', '78%', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=100'),
                _kanbanCard('Diya Sharma', 'Dancer', '72%', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=100'),
              ]),

              // 2. Reviewed Column
              _kanbanColumn([
                ...submissions.where((s) => s.status == ApplicationStatus.underReview).map((sub) => _kanbanCard(
                      sub.studentName,
                      sub.studentRole,
                      '92%',
                      sub.studentAvatar.isNotEmpty ? sub.studentAvatar : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
                      onTap: () => _showStatusChangeModal(context, controller, sub),
                    )),
                _kanbanCard('Kabir Malhotra', 'Cinematographer', '82%', 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&q=80&w=100'),
                _kanbanVideoCard(),
              ]),

              // 3. Shortlisted Column
              _kanbanColumn([
                ...submissions.where((s) => s.status == ApplicationStatus.selected).map((sub) => _kanbanCard(
                      sub.studentName,
                      sub.studentRole,
                      '98%',
                      sub.studentAvatar.isNotEmpty ? sub.studentAvatar : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
                      onTap: () => _showStatusChangeModal(context, controller, sub),
                    )),
                _kanbanCard('Nitika Rao', 'Dancer', '88%', 'https://images.unsplash.com/photo-1547153760-18fc86324498?auto=format&fit=crop&q=80&w=100'),
                _kanbanPhotoGrid(),
              ]),

              // 4. Interview Column
              _kanbanColumn([
                ...submissions.where((s) => s.status == ApplicationStatus.interview).map((sub) => _kanbanCard(
                      sub.studentName,
                      sub.studentRole,
                      '94%',
                      sub.studentAvatar.isNotEmpty ? sub.studentAvatar : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
                      onTap: () => _showStatusChangeModal(context, controller, sub),
                    )),
                _kanbanScheduledCard('Ishita Rao', 'Actor', '90%', 'Tomorrow\n11:00 AM'),
              ]),

              // 5. Selected / Offer Column
              _kanbanColumn([
                _kanbanOfferCard('Aarav Iyer', 'Vocalist', '92%'),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }

  Widget _stageHeader(String title, String count, Color color) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 8),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Flexible(child: Text(title, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 13, fontWeight: FontWeight.bold, color: KalaColors.charcoal))),
          const SizedBox(width: 4),
          Text(count, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 11, color: KalaColors.mediumGrey)),
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
                Text('Add', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, color: KalaColors.mediumGrey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kanbanCard(String name, String role, String match, String imgUrl, {VoidCallback? onTap}) {
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
            Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
            Text(role, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, color: KalaColors.mediumGrey)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(color: KalaColors.burntOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
              child: Text('$match Match', style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, fontWeight: FontWeight.bold, color: KalaColors.burntOrange)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kanbanVideoCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KalaColors.lightGrey),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&q=80&w=200'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black.withValues(alpha: 0.3),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.play_arrow, size: 16, color: KalaColors.charcoal),
          ),
        ),
      ),
    );
  }

  Widget _kanbanPhotoGrid() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KalaColors.lightGrey),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1485846234645-a62644f84728?auto=format&fit=crop&q=80&w=200'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _kanbanScheduledCard(String name, String role, String match, String schedule) {
    return Container(
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
          Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
          Text(role, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, color: KalaColors.mediumGrey)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: KalaColors.softBeige, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 12, color: KalaColors.burntOrange),
                const SizedBox(width: 4),
                Flexible(child: Text(schedule, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, color: KalaColors.charcoal))),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(color: KalaColors.burntOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
            child: Text('$match Match', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, fontWeight: FontWeight.bold, color: KalaColors.burntOrange)),
          ),
        ],
      ),
    );
  }

  Widget _kanbanOfferCard(String name, String role, String match) {
    return Container(
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
          Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
          Text(role, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, color: KalaColors.mediumGrey)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.check_circle, size: 12, color: KalaColors.accentGreen),
              const SizedBox(width: 4),
              Flexible(child: Text('Offer Sent', overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, fontWeight: FontWeight.bold, color: KalaColors.accentGreen))),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(color: KalaColors.burntOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
            child: Text('$match Match', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, fontWeight: FontWeight.bold, color: KalaColors.burntOrange)),
          ),
        ],
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
                _interviewRow('Ishita Rao', 'Tomorrow, 11:00 AM', 'Google Meet', 'Confirmed', KalaColors.accentGreen, 'Reschedule',
                    'https://images.unsplash.com/photo-1547153760-18fc86324498?auto=format&fit=crop&q=80&w=100'),
                Divider(height: 1, color: KalaColors.lightGrey),
                _interviewRow('Ritvik Joshi', 'May 18, 03:00 PM', 'Google Meet', 'Pending', Colors.orange, 'Send Reminder',
                    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=100'),
                Divider(height: 1, color: KalaColors.lightGrey),
                _interviewRow('Tanya B.', 'May 19, 04:00 PM', 'Google Meet', 'Pending', Colors.orange, 'Reschedule',
                    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=100'),
              ],
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _interviewRow(String name, String time, String platform, String status, Color statusColor, String action, String imgUrl) {
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
                Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 13, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 10, color: KalaColors.mediumGrey),
                    const SizedBox(width: 3),
                    Flexible(child: Text(time, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, color: KalaColors.mediumGrey))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(status, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 11, fontWeight: FontWeight.bold, color: statusColor)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: KalaColors.lightGrey),
            ),
            child: Text(action, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
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
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: _sectionHeader('Quick Actions', showViewAll: false)),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _quickActionBtn(Icons.swap_horiz, 'Move Stage'),
              _quickActionBtn(Icons.calendar_month_outlined, 'Schedule Interview'),
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
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, color: KalaColors.charcoal)),
        ],
      ),
    );
  }

  // ─── RECENT ACTIVITY ──────────────────────────────────────────────────────
  Widget _buildRecentActivity() {
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
            child: Column(
              children: [
                _activityRow(Icons.people_outline, '5 new applications received for Music Fest 2026', 'Just now'),
                Divider(height: 1, color: KalaColors.lightGrey),
                _activityRow(Icons.calendar_today_outlined, 'Ritvik Joshi accepted interview invitation', '10m ago'),
                Divider(height: 1, color: KalaColors.lightGrey),
                _activityRow(Icons.person_outline, 'Meera Singh updated her portfolio', '25m ago'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _activityRow(IconData icon, String text, String time) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: KalaColors.softBeige, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 16, color: KalaColors.burntOrange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, color: KalaColors.charcoal)),
          ),
          Text(time, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 10, color: KalaColors.mediumGrey)),
        ],
      ),
    );
  }

  void _showStatusChangeModal(BuildContext context, EventController controller, dynamic submission) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Update Status: ${submission.studentName}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
            const SizedBox(height: 4),
            Text('Current Stage: ${submission.status.label}', style: const TextStyle(fontSize: 12, color: KalaColors.burntOrange, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            ...ApplicationStatus.values.map((status) => ListTile(
                  title: Text(status.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  trailing: submission.status == status ? const Icon(Icons.check_circle, color: KalaColors.burntOrange) : null,
                  onTap: () {
                    controller.updateApplicationStatus(submission.submissionId, status);
                    Navigator.pop(ctx);
                  },
                )),
          ],
        ),
      ),
    );
  }

  // ─── HELPERS ──────────────────────────────────────────────────────────────
  Widget _sectionHeader(String title, {bool showViewAll = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(title, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 16, fontWeight: FontWeight.bold, color: KalaColors.charcoal))),
        if (showViewAll)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text('View all', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.burntOrange)),
          ),
      ],
    );
  }
}
