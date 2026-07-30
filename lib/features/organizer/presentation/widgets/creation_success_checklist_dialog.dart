import 'package:flutter/material.dart';
import '../../../../core/theme/kala_colors.dart';

class ChecklistItem {
  final String title;
  final String description;
  final bool isCompleted;
  final VoidCallback? onTap;

  ChecklistItem({
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.onTap,
  });
}

class CreationSuccessChecklistDialog extends StatelessWidget {
  final String entityTitle;
  final bool isEvent;
  final List<ChecklistItem> items;
  final VoidCallback onContinue;

  const CreationSuccessChecklistDialog({
    super.key,
    required this.entityTitle,
    required this.isEvent,
    required this.items,
    required this.onContinue,
  });

  static void show(
    BuildContext context, {
    required String entityTitle,
    required bool isEvent,
    required List<ChecklistItem> items,
    required VoidCallback onContinue,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CreationSuccessChecklistDialog(
        entityTitle: entityTitle,
        isEvent: isEvent,
        items: items,
        onContinue: onContinue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = items.where((i) => i.isCompleted).length;
    final progress = items.isNotEmpty ? completedCount / items.length : 1.0;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: KalaColors.accentGreen.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, color: KalaColors.accentGreen, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEvent ? 'Event Published! 🎉' : 'Opportunity Published! 🚀',
                        style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 18, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
                      ),
                      Text(
                        entityTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, color: KalaColors.burntOrange, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Setup Progress Bar
            Text(
              'Setup Progress (${(progress * 100).toInt()}%)',
              style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, fontWeight: FontWeight.bold, color: KalaColors.mediumGrey),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: KalaColors.lightGrey,
                color: KalaColors.burntOrange,
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Recommended Next Actions:',
              style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 14, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
            ),
            const SizedBox(height: 12),

            ...items.map((item) => GestureDetector(
                  onTap: item.onTap,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: KalaColors.lightGrey),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: item.isCompleted ? KalaColors.accentGreen : KalaColors.mediumGrey,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontFamily: 'ZT_Nature',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: item.isCompleted ? KalaColors.mediumGrey : KalaColors.charcoal,
                                  decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              Text(
                                item.description,
                                style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 11, color: KalaColors.mediumGrey),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, size: 18, color: KalaColors.mediumGrey),
                      ],
                    ),
                  ),
                )),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog safely
                  onContinue(); // Execute navigation action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: KalaColors.burntOrange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  isEvent ? 'Open Event Workspace' : 'Open Opportunity Studio',
                  style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
