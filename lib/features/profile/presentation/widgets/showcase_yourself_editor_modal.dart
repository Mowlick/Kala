import 'package:flutter/material.dart';
import '../../../../core/theme/kala_colors.dart';

class ShowcaseYourselfEditorModal extends StatefulWidget {
  final String settingTitle; // Bio, Demo Reel, Creative Roles, Availability
  final String initialValue;
  final Function(String newValue, bool isDraft) onSave;

  const ShowcaseYourselfEditorModal({
    super.key,
    required this.settingTitle,
    required this.initialValue,
    required this.onSave,
  });

  static void show(
    BuildContext context, {
    required String settingTitle,
    required String initialValue,
    required Function(String newValue, bool isDraft) onSave,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: ShowcaseYourselfEditorModal(
          settingTitle: settingTitle,
          initialValue: initialValue,
          onSave: onSave,
        ),
      ),
    );
  }

  @override
  State<ShowcaseYourselfEditorModal> createState() =>
      _ShowcaseYourselfEditorModalState();
}

class _ShowcaseYourselfEditorModalState
    extends State<ShowcaseYourselfEditorModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(bool isDraft) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSave(_controller.text.trim(), isDraft);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isDraft
              ? 'Saved Draft 📝'
              : '${widget.settingTitle} Updated on Profile! ✨',
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
                  Icons.star_outline,
                  color: KalaColors.burntOrange,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Edit ${widget.settingTitle}',
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
                    Text(
                      'Update your ${widget.settingTitle.toLowerCase()}:',
                      style: const TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 13,
                        color: KalaColors.mediumGrey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _controller,
                      maxLines: widget.settingTitle == 'Bio / About Me' ? 5 : 2,
                      decoration: InputDecoration(
                        hintText: 'Enter details...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (val) => (val == null || val.trim().isEmpty)
                          ? 'Please enter a value'
                          : null,
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
                      'Update Profile ✨',
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
