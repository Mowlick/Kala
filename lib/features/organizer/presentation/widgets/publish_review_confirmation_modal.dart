import 'package:flutter/material.dart';
import '../../../../core/theme/kala_colors.dart';

class PublishReviewConfirmationModal extends StatefulWidget {
  final String title;
  final String category;
  final String entityType; // 'Event', 'Opportunity', 'Form'
  final String detailSubtitle; // venue, stipend, etc.
  final String description;
  final Function(bool broadcastNow) onConfirmPublish;

  const PublishReviewConfirmationModal({
    super.key,
    required this.title,
    required this.category,
    required this.entityType,
    required this.detailSubtitle,
    required this.description,
    required this.onConfirmPublish,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String category,
    required String entityType,
    required String detailSubtitle,
    required String description,
    required Function(bool broadcastNow) onConfirmPublish,
  }) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PublishReviewConfirmationModal(
        title: title,
        category: category,
        entityType: entityType,
        detailSubtitle: detailSubtitle,
        description: description,
        onConfirmPublish: onConfirmPublish,
      ),
    );
  }

  @override
  State<PublishReviewConfirmationModal> createState() =>
      _PublishReviewConfirmationModalState();
}

class _PublishReviewConfirmationModalState
    extends State<PublishReviewConfirmationModal> {
  bool _broadcastNow = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: KalaColors.lightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: KalaColors.burntOrange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.rocket_launch_rounded,
                  color: KalaColors.burntOrange,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Review & Confirm ${widget.entityType}',
                      style: const TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: KalaColors.charcoal,
                      ),
                    ),
                    const Text(
                      'Confirm details before publishing to marketplace',
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
          const SizedBox(height: 20),

          // Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: KalaColors.ivory,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: KalaColors.lightGrey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: KalaColors.burntOrange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.category,
                        style: const TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: KalaColors.burntOrange,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF059669).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Ready to Publish',
                        style: TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF059669),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: KalaColors.charcoal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.detailSubtitle,
                  style: const TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 12,
                    color: KalaColors.mediumGrey,
                  ),
                ),
                if (widget.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 11,
                      color: KalaColors.charcoal,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Broadcast Switch Tile
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: KalaColors.lightGrey),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.campaign_outlined,
                  color: KalaColors.burntOrange,
                  size: 22,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Broadcast Post Announcement',
                        style: TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: KalaColors.charcoal,
                        ),
                      ),
                      Text(
                        'Notify students on discovery feed immediately',
                        style: TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 10,
                          color: KalaColors.mediumGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _broadcastNow,
                  activeThumbColor: KalaColors.burntOrange,
                  onChanged: (val) => setState(() => _broadcastNow = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Cancel / Edit',
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 13,
                      color: KalaColors.charcoal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onConfirmPublish(_broadcastNow);
                  },
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: Text(
                    'Publish ${widget.entityType}',
                    style: const TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KalaColors.burntOrange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
