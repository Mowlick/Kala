import 'package:flutter/material.dart';
import '../../../../core/theme/kala_colors.dart';
import '../../domain/models/form_field_schema.dart';
import '../../domain/models/dynamic_form_model.dart';

class FormBuilderWidget extends StatefulWidget {
  final DynamicFormModel initialForm;
  final Function(DynamicFormModel updatedForm) onSave;

  const FormBuilderWidget({
    super.key,
    required this.initialForm,
    required this.onSave,
  });

  @override
  State<FormBuilderWidget> createState() => _FormBuilderWidgetState();
}

class _FormBuilderWidgetState extends State<FormBuilderWidget> {
  late TextEditingController _titleController;
  late List<FormFieldSchema> _fields;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialForm.title);
    _fields = List.from(widget.initialForm.fields);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _addNewField(FormFieldType type) {
    setState(() {
      final fieldId = 'field_${DateTime.now().millisecondsSinceEpoch}';
      String defaultLabel = 'New Question';
      switch (type) {
        case FormFieldType.text:
          defaultLabel = 'Short Answer Question';
          break;
        case FormFieldType.longText:
          defaultLabel = 'Detailed Description / Bio';
          break;
        case FormFieldType.dropdown:
          defaultLabel = 'Select Category / Genre';
          break;
        case FormFieldType.checkbox:
          defaultLabel = 'Select Options';
          break;
        case FormFieldType.fileUpload:
          defaultLabel = 'Upload Audition Video / Document';
          break;
        case FormFieldType.mediaUrl:
          defaultLabel = 'Performance Demo Reel Link';
          break;
      }

      _fields.add(
        FormFieldSchema(
          id: fieldId,
          type: type,
          label: defaultLabel,
          isRequired: true,
          options: type == FormFieldType.dropdown || type == FormFieldType.checkbox
              ? ['Option 1', 'Option 2']
              : [],
        ),
      );
    });
  }

  void _removeField(int index) {
    setState(() {
      _fields.removeAt(index);
    });
  }

  void _saveForm() {
    if (_fields.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Please add at least 1 question field before publishing!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final updated = DynamicFormModel(
      formId: widget.initialForm.formId,
      title: _titleController.text.trim().isEmpty ? 'Untitled Form' : _titleController.text.trim(),
      isTemplate: widget.initialForm.isTemplate,
      fields: _fields,
      version: widget.initialForm.version + 1,
      createdAt: widget.initialForm.createdAt,
    );
    widget.onSave(updated);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: KalaColors.ivory,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.dynamic_form_outlined, color: KalaColors.burntOrange, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Form Builder & Template Editor',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Form Title Field
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Form Title / Template Name',
              hintText: 'e.g. Vocalist Audition Form',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Questions (${_fields.length})',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: KalaColors.charcoal),
              ),
              PopupMenuButton<FormFieldType>(
                onSelected: _addNewField,
                itemBuilder: (context) => [
                  const PopupMenuItem(value: FormFieldType.text, child: Text('+ Short Text Question')),
                  const PopupMenuItem(value: FormFieldType.longText, child: Text('+ Paragraph / Long Text')),
                  const PopupMenuItem(value: FormFieldType.dropdown, child: Text('+ Dropdown Options')),
                  const PopupMenuItem(value: FormFieldType.mediaUrl, child: Text('+ Demo Reel Link Input')),
                  const PopupMenuItem(value: FormFieldType.fileUpload, child: Text('+ File / Media Upload')),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: KalaColors.burntOrange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text('Add Field', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Fields List
          Expanded(
            child: _fields.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_add, size: 48, color: KalaColors.mediumGrey.withValues(alpha: 0.5)),
                        const SizedBox(height: 12),
                        const Text('No questions added yet.', style: TextStyle(color: KalaColors.mediumGrey)),
                        const SizedBox(height: 8),
                        const Text('Tap "+ Add Field" to build your custom form.', style: TextStyle(fontSize: 12, color: KalaColors.mediumGrey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _fields.length,
                    itemBuilder: (context, index) {
                      final field = _fields[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: KalaColors.lightGrey),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Chip(
                                  label: Text(field.type.name.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                                  backgroundColor: KalaColors.softBeige,
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    const Text('Required', style: TextStyle(fontSize: 11, color: KalaColors.mediumGrey)),
                                    Switch(
                                      value: field.isRequired,
                                      activeTrackColor: KalaColors.burntOrange,
                                      onChanged: (val) {
                                        setState(() {
                                          _fields[index] = FormFieldSchema(
                                            id: field.id,
                                            type: field.type,
                                            label: field.label,
                                            placeholder: field.placeholder,
                                            isRequired: val,
                                            options: field.options,
                                            acceptedFileTypes: field.acceptedFileTypes,
                                          );
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                      onPressed: () => _removeField(index),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              initialValue: field.label,
                              decoration: const InputDecoration(
                                labelText: 'Question Label',
                                isDense: true,
                              ),
                              onChanged: (val) {
                                _fields[index] = FormFieldSchema(
                                  id: field.id,
                                  type: field.type,
                                  label: val,
                                  placeholder: field.placeholder,
                                  isRequired: field.isRequired,
                                  options: field.options,
                                  acceptedFileTypes: field.acceptedFileTypes,
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),

          // Save Form CTA
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                _saveForm();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: KalaColors.burntOrange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Form & Update Template', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
