import 'package:flutter/material.dart';
import '../../../../core/theme/kala_colors.dart';

class BroadcastPostModal extends StatefulWidget {
  final String? initialEventId;
  final String? initialOpportunityId;

  const BroadcastPostModal({
    super.key,
    this.initialEventId,
    this.initialOpportunityId,
  });

  static void show(
    BuildContext context, {
    String? initialEventId,
    String? initialOpportunityId,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.88,
        child: BroadcastPostModal(
          initialEventId: initialEventId,
          initialOpportunityId: initialOpportunityId,
        ),
      ),
    );
  }

  @override
  State<BroadcastPostModal> createState() => _BroadcastPostModalState();
}

class _BroadcastPostModalState extends State<BroadcastPostModal> {
  final _formKey = GlobalKey<FormState>();
  late String _targetScope; // 'Organization', 'Event', 'Opportunity'
  String _selectedAnnouncementType = 'General Announcement';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isPublishing = false;
  bool _isPublished = false;

  final List<String> _announcementTypes = [
    'General Announcement',
    'Deadline Extension ⏳',
    'Audition Results 🏆',
    'Venue Update 📍',
    'Schedule Reminder ⏰',
    'Guest Artist Celebration 🎉',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialOpportunityId != null) {
      _targetScope = 'Opportunity';
    } else if (widget.initialEventId != null) {
      _targetScope = 'Event';
    } else {
      _targetScope = 'Organization';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handlePublish() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isPublishing = true);

    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      _isPublishing = false;
      _isPublished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: KalaColors.ivory,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isPublished ? _buildDeliveryAnalyticsView() : _buildEditorView(),
      ),
    );
  }

  Widget _buildEditorView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.campaign_outlined, color: KalaColors.burntOrange, size: 28),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Broadcast Post Editor', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 18, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                    Text('Targeted broadcast communication to performers & applicants', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 11, color: KalaColors.mediumGrey)),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Target Audience Scope
                  const Text('1. Broadcast Target Scope', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 13, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _scopeChip('Entire Organization', 'Organization'),
                      const SizedBox(width: 8),
                      _scopeChip('Specific Event', 'Event'),
                      const SizedBox(width: 8),
                      _scopeChip('Opportunity', 'Opportunity'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Announcement Type Dropdown
                  const Text('2. Announcement Type', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 13, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedAnnouncementType,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    items: _announcementTypes.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 13)))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedAnnouncementType = val);
                    },
                  ),
                  const SizedBox(height: 20),

                  // Broadcast Title
                  const Text('3. Broadcast Title', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 13, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'e.g. Audition Deadline Extended by 48 Hours!',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter a title' : null,
                  ),
                  const SizedBox(height: 20),

                  // Broadcast Message Body
                  const Text('4. Message Content', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 13, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _messageController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Type your official announcement or instructions...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter message content' : null,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _isPublishing ? null : _handlePublish,
              icon: _isPublishing
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.send_rounded, size: 18),
              label: Text(
                _isPublishing ? 'Publishing Broadcast...' : 'Publish Broadcast Now',
                style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 15, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: KalaColors.burntOrange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scopeChip(String label, String value) {
    final isSelected = _targetScope == value;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : KalaColors.charcoal)),
      selected: isSelected,
      selectedColor: KalaColors.burntOrange,
      backgroundColor: Colors.white,
      onSelected: (selected) {
        if (selected) setState(() => _targetScope = value);
      },
    );
  }

  Widget _buildDeliveryAnalyticsView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: KalaColors.accentGreen.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: const Icon(Icons.check_circle, color: KalaColors.accentGreen, size: 48),
        ),
        const SizedBox(height: 16),
        const Text('Broadcast Published! 📡', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 22, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
        const SizedBox(height: 6),
        Text('Target: $_targetScope • Type: $_selectedAnnouncementType', style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, color: KalaColors.mediumGrey)),
        const SizedBox(height: 28),

        // Delivery Analytics Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: KalaColors.lightGrey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Live Delivery Analytics', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 14, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _analyticStat('348', 'Reach'),
                  _analyticStat('342', 'Delivered'),
                  _analyticStat('214', 'Opened'),
                  _analyticStat('6', 'Pending'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: KalaColors.burntOrange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Back to Dashboard', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _analyticStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 18, fontWeight: FontWeight.bold, color: KalaColors.burntOrange)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 11, color: KalaColors.mediumGrey)),
      ],
    );
  }
}
