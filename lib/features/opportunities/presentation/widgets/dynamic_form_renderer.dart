import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
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
  final String organizerId;
  final String studentId; // real user UUID from AuthController
  final Function(ApplicationSubmissionModel submission) onSubmit;

  const DynamicFormRenderer({
    super.key,
    required this.form,
    required this.opportunityId,
    required this.opportunityTitle,
    required this.eventId,
    required this.eventTitle,
    this.organizerId = '',
    this.studentId = 'usr_demo',
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

  /// Default application questions shown when the organizer's custom
  /// questions haven't synced to this device yet — Apply is never a dead end.
  static final List<FormFieldSchema> _defaultFields = [
    FormFieldSchema(
      id: 'f_name',
      type: FormFieldType.text,
      label: 'Full Name',
      placeholder: 'Your full name',
      isRequired: true,
    ),
    FormFieldSchema(
      id: 'f_email',
      type: FormFieldType.text,
      label: 'Email',
      placeholder: 'you@example.com',
      isRequired: true,
    ),
    FormFieldSchema(
      id: 'f_phone',
      type: FormFieldType.text,
      label: 'Phone Number',
      placeholder: '+91 ...',
    ),
    FormFieldSchema(
      id: 'f_reel',
      type: FormFieldType.mediaUrl,
      label: 'Portfolio / Performance Reel Link',
      placeholder: 'YouTube / Drive / Instagram URL',
    ),
    FormFieldSchema(
      id: 'f_note',
      type: FormFieldType.longText,
      label: 'Why are you a great fit?',
      placeholder: 'Tell the organizer about your experience...',
    ),
  ];

  List<FormFieldSchema> get _effectiveFields =>
      widget.form.fields.isNotEmpty ? widget.form.fields : _defaultFields;

  @override
  void initState() {
    super.initState();
    // Prefill the default fields from the signed-in student's profile.
    if (widget.form.fields.isEmpty) {
      final auth = context.read<AuthController>();
      _responses['f_name'] = auth.displayName;
      _responses['f_email'] = auth.emailText;
    }
  }

  void _showPortfolioPicker(
    String fieldId,
    StudentProfileController profileController,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
                  Icon(
                    Icons.folder_special_outlined,
                    color: KalaColors.burntOrange,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Attach from Portfolio',
                    style: TextStyle(
                      fontFamily: 'ZT_Nature',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: KalaColors.charcoal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Select an existing project or reel to attach to this application answer:',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 12,
                  color: KalaColors.mediumGrey,
                ),
              ),
              const SizedBox(height: 14),

              if (items.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No portfolio items found. Upload work in your profile first!',
                  ),
                )
              else
                ...items.map(
                  (item) => ListTile(
                    leading: Icon(
                      item.isFeatured
                          ? Icons.star
                          : Icons.insert_drive_file_outlined,
                      color: KalaColors.burntOrange,
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${item.category.toUpperCase()} • ${item.mediaUrl}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10),
                    ),
                    trailing: const Icon(
                      Icons.add_circle_outline,
                      color: KalaColors.burntOrange,
                    ),
                    onTap: () {
                      setState(() {
                        _responses[fieldId] =
                            '${item.title} (${item.mediaUrl})';
                        if (!_attachedPortfolioItemIds.contains(item.id)) {
                          _attachedPortfolioItemIds.add(item.id);
                        }
                      });
                      Navigator.pop(ctx);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// Lets the student provide a real link to their file (Drive, YouTube,
  /// storage URL, etc.) — no fabricated filenames.
  void _promptForFileUrl(String fieldId) {
    final controller = TextEditingController(
      text: _responses[fieldId]?.toString() ?? '',
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Add File Link',
          style: TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'https://drive.google.com/...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: KalaColors.burntOrange,
            ),
            onPressed: () {
              setState(() {
                _responses[fieldId] = controller.text.trim();
              });
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState?.save();

    // Capture auth synchronously before the settle delay (avoids using
    // BuildContext across an async gap). The renderer is under the app-level
    // MultiProvider so AuthController is always available.
    final auth = context.read<AuthController>();

    setState(() => _isSubmitting = true);

    final answers = _effectiveFields.map((field) {
      final val = _responses[field.id];
      return SubmissionAnswer(
        fieldId: field.id,
        fieldType: field.type.name,
        answer: val,
        uploadedFileUrl: field.type == FormFieldType.fileUpload
            ? val?.toString()
            : null,
      );
    }).toList();

    final student = auth.currentUser;
    final profileName = auth.displayName;

    final submission = ApplicationSubmissionModel(
      submissionId: 'sub_${DateTime.now().millisecondsSinceEpoch}',
      opportunityId: widget.opportunityId,
      opportunityTitle: widget.opportunityTitle,
      eventId: widget.eventId,
      eventTitle: widget.eventTitle,
      organizerId: widget.organizerId,
      studentId: student != null ? student.id : widget.studentId,
      studentName: profileName,
      studentEmail: auth.emailText,
      studentAvatar: student?.userMetadata?['avatar']?.toString() ?? '',
      studentRole: student?.userMetadata?['role']?.toString() == 'organizer'
          ? 'Organizer'
          : 'Performer',
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
                      Text(
                        widget.opportunityTitle,
                        style: const TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: KalaColors.charcoal,
                        ),
                      ),
                      Text(
                        widget.eventTitle,
                        style: const TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 12,
                          color: KalaColors.burntOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            Expanded(
              child: widget.form.fields.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: KalaColors.softBeige.withValues(
                                alpha: 0.4,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'The organizer\'s custom questions are loading — you can fill the standard application below.',
                              style: TextStyle(
                                fontFamily: 'ZT_Nature',
                                fontSize: 11,
                                color: KalaColors.mediumGrey,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _effectiveFields.length,
                              itemBuilder: (context, index) {
                                final field = _effectiveFields[index];
                                return _buildQuestionTile(
                                  field,
                                  profileController,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _effectiveFields.length,
                      itemBuilder: (context, index) {
                        final field = _effectiveFields[index];
                        return _buildQuestionTile(field, profileController);
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Submit Application',
                        style: TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionTile(
    FormFieldSchema field,
    StudentProfileController profileController,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: field.label,
              style: const TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: KalaColors.charcoal,
              ),
              children: [
                if (field.isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildFieldInput(field, profileController),
        ],
      ),
    );
  }

  Widget _buildFieldInput(
    FormFieldSchema field,
    StudentProfileController profileController,
  ) {
    switch (field.type) {
      case FormFieldType.text:
      case FormFieldType.mediaUrl:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: TextEditingController(
                text: _responses[field.id]?.toString() ?? '',
              ),
              decoration: InputDecoration(
                hintText: field.placeholder.isNotEmpty
                    ? field.placeholder
                    : 'Enter response or paste URL...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
                onPressed: () =>
                    _showPortfolioPicker(field.id, profileController),
                icon: const Icon(
                  Icons.attach_file,
                  size: 14,
                  color: KalaColors.burntOrange,
                ),
                label: const Text(
                  'Attach from Portfolio ⭐',
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: KalaColors.burntOrange,
                  ),
                ),
              ),
            ),
          ],
        );

      case FormFieldType.longText:
        return TextFormField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: field.placeholder.isNotEmpty
                ? field.placeholder
                : 'Enter detailed response...',
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
                  const Icon(
                    Icons.cloud_upload_outlined,
                    color: KalaColors.burntOrange,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      currentFile != null
                          ? 'Selected: $currentFile'
                          : 'Attach video/audio reel or document',
                      style: TextStyle(
                        fontSize: 12,
                        color: currentFile != null
                            ? KalaColors.charcoal
                            : KalaColors.mediumGrey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _promptForFileUrl(field.id),
                      icon: const Icon(Icons.upload_file, size: 14),
                      label: Text(
                        currentFile != null ? 'Change' : 'Add File Link',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          _showPortfolioPicker(field.id, profileController),
                      icon: const Icon(Icons.folder_special, size: 14),
                      label: const Text(
                        'From Portfolio ⭐',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: KalaColors.burntOrange,
                      ),
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
            final List<String> currentSelected = List<String>.from(
              _responses[field.id] ?? [],
            );
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
