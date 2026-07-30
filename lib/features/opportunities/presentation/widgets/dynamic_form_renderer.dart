import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../../domain/models/form_field_schema.dart';
import '../../domain/models/dynamic_form_model.dart';
import '../../../applications/domain/models/submission_answer.dart';
import '../../../applications/domain/models/application_submission_model.dart';
import '../../../applications/domain/models/application_status.dart';
import '../../../profile/presentation/controllers/student_profile_controller.dart';

class DynamicFormRenderer extends StatefulWidget {
  final DynamicFormModel form;
  final String opportunityId;
  final String opportunityTitle;
  final String eventId;
  final String eventTitle;
  final Function(ApplicationSubmissionModel submission) onSubmit;

  const DynamicFormRenderer({
    super.key,
    required this.form,
    required this.opportunityId,
    required this.opportunityTitle,
    required this.eventId,
    required this.eventTitle,
    required this.onSubmit,
  });

  @override
  State<DynamicFormRenderer> createState() => _DynamicFormRendererState();
}

class _DynamicFormRendererState extends State<DynamicFormRenderer> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _responses = {};
  final List<String> _attachedPortfolioItemIds = [];
  bool _isSubmitting = false;

  void _showPortfolioPicker(String fieldId, StudentProfileController profileController) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        final items = profileController.portfolioItems;
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.folder_special_outlined, color: KalaColors.burntOrange),
                  SizedBox(width: 10),
                  Text('Attach from Portfolio', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 16, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                ],
              ),
              const SizedBox(height: 6),
              const Text('Select an existing project or reel to attach to this application answer:', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, color: KalaColors.mediumGrey)),
              const SizedBox(height: 14),

              if (items.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No portfolio items found. Upload work in your profile first!'),
                )
              else
                ...items.map((item) => ListTile(
                      leading: Icon(
                        item.isFeatured ? Icons.star : Icons.insert_drive_file_outlined,
                        color: KalaColors.burntOrange,
                      ),
                      title: Text(item.title, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 13, fontWeight: FontWeight.bold)),
                      subtitle: Text('${item.category.toUpperCase()} • ${item.mediaUrl}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10)),
                      trailing: const Icon(Icons.add_circle_outline, color: KalaColors.burntOrange),
                      onTap: () {
                        setState(() {
                          _responses[fieldId] = '${item.title} (${item.mediaUrl})';
                          if (!_attachedPortfolioItemIds.contains(item.id)) {
                            _attachedPortfolioItemIds.add(item.id);
                          }
                        });
                        Navigator.pop(ctx);
                      },
                    )),
            ],
          ),
        );
      },
    );
  }

  void _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState?.save();

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 800));

    final answers = widget.form.fields.map((field) {
      final val = _responses[field.id];
      return SubmissionAnswer(
        fieldId: field.id,
        fieldType: field.type.name,
        answer: val,
        uploadedFileUrl: field.type == FormFieldType.fileUpload ? val?.toString() : null,
      );
    }).toList();

    final submission = ApplicationSubmissionModel(
      submissionId: 'sub_${DateTime.now().millisecondsSinceEpoch}',
      opportunityId: widget.opportunityId,
      opportunityTitle: widget.opportunityTitle,
      eventId: widget.eventId,
      eventTitle: widget.eventTitle,
      studentId: 'usr_current',
      studentName: 'Aarav Sharma',
      studentAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
      studentRole: 'Singer / Performer',
      answers: answers,
      attachedPortfolioItemIds: _attachedPortfolioItemIds,
      status: ApplicationStatus.applied,
      formVersion: widget.form.version,
      submittedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    setState(() => _isSubmitting = false);
    widget.onSubmit(submission);
  }

  @override
  Widget build(BuildContext context) {
    final profileController = context.watch<StudentProfileController>();

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.opportunityTitle, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 18, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                      Text(widget.eventTitle, style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, color: KalaColors.burntOrange, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: widget.form.fields.length,
                itemBuilder: (context, index) {
                  final field = widget.form.fields[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: field.label,
                            style: const TextStyle(fontFamily: 'ZT_Nature', fontSize: 14, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
                            children: [
                              if (field.isRequired)
                                const TextSpan(text: ' *', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildFieldInput(field, profileController),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: KalaColors.burntOrange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _isSubmitting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Submit Application', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldInput(FormFieldSchema field, StudentProfileController profileController) {
    switch (field.type) {
      case FormFieldType.text:
      case FormFieldType.mediaUrl:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: TextEditingController(text: _responses[field.id]?.toString() ?? ''),
              decoration: InputDecoration(
                hintText: field.placeholder.isNotEmpty ? field.placeholder : 'Enter response or paste URL...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (val) {
                if (field.isRequired && (val == null || val.trim().isEmpty)) {
                  return 'This question is required';
                }
                return null;
              },
              onChanged: (val) => _responses[field.id] = val.trim(),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _showPortfolioPicker(field.id, profileController),
                icon: const Icon(Icons.attach_file, size: 14, color: KalaColors.burntOrange),
                label: const Text('Attach from Portfolio ⭐', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 11, fontWeight: FontWeight.bold, color: KalaColors.burntOrange)),
              ),
            ),
          ],
        );

      case FormFieldType.longText:
        return TextFormField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: field.placeholder.isNotEmpty ? field.placeholder : 'Enter detailed response...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (val) {
            if (field.isRequired && (val == null || val.trim().isEmpty)) {
              return 'This question is required';
            }
            return null;
          },
          onSaved: (val) => _responses[field.id] = val?.trim(),
        );

      case FormFieldType.dropdown:
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          hint: const Text('Select an option'),
          items: field.options
              .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
              .toList(),
          validator: (val) {
            if (field.isRequired && val == null) {
              return 'Please select an option';
            }
            return null;
          },
          onChanged: (val) => _responses[field.id] = val,
        );

      case FormFieldType.fileUpload:
        final currentFile = _responses[field.id];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: KalaColors.lightGrey),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.cloud_upload_outlined, color: KalaColors.burntOrange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      currentFile != null ? 'Selected: $currentFile' : 'Attach video/audio reel or document',
                      style: TextStyle(fontSize: 12, color: currentFile != null ? KalaColors.charcoal : KalaColors.mediumGrey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _responses[field.id] = 'my_audition_reel.mp4';
                        });
                      },
                      icon: const Icon(Icons.upload_file, size: 14),
                      label: Text(currentFile != null ? 'Change' : 'Upload File', style: const TextStyle(fontSize: 11)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showPortfolioPicker(field.id, profileController),
                      icon: const Icon(Icons.folder_special, size: 14),
                      label: const Text('From Portfolio ⭐', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(backgroundColor: KalaColors.burntOrange),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      case FormFieldType.checkbox:
        return Column(
          children: field.options.map((opt) {
            final List<String> currentSelected = List<String>.from(_responses[field.id] ?? []);
            final isChecked = currentSelected.contains(opt);
            return CheckboxListTile(
              title: Text(opt, style: const TextStyle(fontSize: 13)),
              value: isChecked,
              activeColor: KalaColors.burntOrange,
              onChanged: (val) {
                setState(() {
                  if (val == true) {
                    currentSelected.add(opt);
                  } else {
                    currentSelected.remove(opt);
                  }
                  _responses[field.id] = currentSelected;
                });
              },
            );
          }).toList(),
        );
    }
  }
}
