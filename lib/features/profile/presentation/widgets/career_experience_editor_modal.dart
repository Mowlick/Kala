import 'package:flutter/material.dart';
import '../../../../core/theme/kala_colors.dart';

class CareerExperienceEditorModal extends StatefulWidget {
  final String
  sectionTitle; // Work Experience, Event Participation, Skills, etc.
  final Function(String title, String details, bool isDraft) onSave;

  const CareerExperienceEditorModal({
    super.key,
    required this.sectionTitle,
    required this.onSave,
  });

  static void show(
    BuildContext context, {
    required String sectionTitle,
    required Function(String title, String details, bool isDraft) onSave,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: CareerExperienceEditorModal(
          sectionTitle: sectionTitle,
          onSave: onSave,
        ),
      ),
    );
  }

  @override
  State<CareerExperienceEditorModal> createState() =>
      _CareerExperienceEditorModalState();
}

class _CareerExperienceEditorModalState
    extends State<CareerExperienceEditorModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _submit(bool isDraft) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSave(
      _titleController.text.trim(),
      _detailsController.text.trim(),
      isDraft,
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isDraft ? 'Saved to Drafts 📝' : '${widget.sectionTitle} Updated! ✨',
        ),
        backgroundColor: isDraft ? KalaColors.charcoal : KalaColors.burntOrange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: KalaColors.ivory,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.work_history_outlined,
                  color: KalaColors.burntOrange,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Add ${widget.sectionTitle}',
                    style: const TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: KalaColors.charcoal,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Title / Role / Entry Name',
                      style: TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: KalaColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'e.g. Lead Vocalist at NCPA Fest',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (val) => (val == null || val.trim().isEmpty)
                          ? 'Please enter a title'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Details / Organization / Duration',
                      style: TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: KalaColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _detailsController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText:
                            'Add achievements, role responsibilities or links...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _submit(true),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save Draft 📝',
                      style: TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontWeight: FontWeight.bold,
                        color: KalaColors.charcoal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _submit(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KalaColors.burntOrange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Publish Entry ✨',
                      style: TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
