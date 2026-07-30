class SubmissionAnswer {
  final String fieldId;
  final String fieldType;
  final dynamic answer;
  final String? uploadedFileUrl;

  SubmissionAnswer({
    required this.fieldId,
    required this.fieldType,
    required this.answer,
    this.uploadedFileUrl,
  });

  factory SubmissionAnswer.fromJson(Map<String, dynamic> json) {
    return SubmissionAnswer(
      fieldId: json['field_id'] ?? '',
      fieldType: json['field_type'] ?? 'text',
      answer: json['answer'],
      uploadedFileUrl: json['uploaded_file_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field_id': fieldId,
      'field_type': fieldType,
      'answer': answer,
      'uploaded_file_url': uploadedFileUrl,
    };
  }
}
