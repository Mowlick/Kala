import 'form_field_schema.dart';

class DynamicFormModel {
  final String formId;
  final String title;
  final bool isTemplate;
  final List<FormFieldSchema> fields;
  final int version;
  final DateTime createdAt;

  DynamicFormModel({
    required this.formId,
    required this.title,
    this.isTemplate = false,
    required this.fields,
    this.version = 1,
    required this.createdAt,
  });

  /// Clones/Duplicates this form to create a new reusable template or edit.
  DynamicFormModel duplicate({required String newFormId, String? newTitle}) {
    return DynamicFormModel(
      formId: newFormId,
      title: newTitle ?? '$title (Copy)',
      isTemplate: true,
      fields: fields.map((f) => FormFieldSchema.fromJson(f.toJson())).toList(),
      version: 1,
      createdAt: DateTime.now(),
    );
  }

  factory DynamicFormModel.fromJson(Map<String, dynamic> json) {
    return DynamicFormModel(
      formId: json['form_id'] ?? '',
      title: json['title'] ?? 'Application Form',
      isTemplate: json['is_template'] ?? false,
      fields: (json['fields'] as List<dynamic>?)
              ?.map((item) => FormFieldSchema.fromJson(item))
              .toList() ??
          [],
      version: json['version'] ?? 1,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'form_id': formId,
      'title': title,
      'is_template': isTemplate,
      'fields': fields.map((f) => f.toJson()).toList(),
      'version': version,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
