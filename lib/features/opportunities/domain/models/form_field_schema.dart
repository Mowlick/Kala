enum FormFieldType {
  text,
  longText,
  dropdown,
  checkbox,
  fileUpload,
  mediaUrl,
}

class FormFieldSchema {
  final String id;
  final FormFieldType type;
  final String label;
  final String placeholder;
  final bool isRequired;
  final List<String> options; // For dropdown/checkbox
  final List<String> acceptedFileTypes; // e.g. ["pdf", "mp4", "mp3"]

  FormFieldSchema({
    required this.id,
    required this.type,
    required this.label,
    this.placeholder = '',
    this.isRequired = false,
    this.options = const [],
    this.acceptedFileTypes = const [],
  });

  factory FormFieldSchema.fromJson(Map<String, dynamic> json) {
    return FormFieldSchema(
      id: json['id'] ?? '',
      type: FormFieldType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => FormFieldType.text,
      ),
      label: json['label'] ?? '',
      placeholder: json['placeholder'] ?? '',
      isRequired: json['is_required'] ?? false,
      options: List<String>.from(json['options'] ?? []),
      acceptedFileTypes: List<String>.from(json['accepted_file_types'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'label': label,
      'placeholder': placeholder,
      'is_required': isRequired,
      'options': options,
      'accepted_file_types': acceptedFileTypes,
    };
  }
}
