class CertificateModel {
  final String certificateId;
  final String eventId;
  final String eventTitle;
  final String studentId;
  final String studentName;
  final String roleName;
  final DateTime issuedDate;
  final String downloadUrl;

  CertificateModel({
    required this.certificateId,
    required this.eventId,
    required this.eventTitle,
    required this.studentId,
    required this.studentName,
    required this.roleName,
    required this.issuedDate,
    required this.downloadUrl,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      certificateId: json['certificate_id'] ?? '',
      eventId: json['event_id'] ?? '',
      eventTitle: json['event_title'] ?? '',
      studentId: json['student_id'] ?? '',
      studentName: json['student_name'] ?? '',
      roleName: json['role_name'] ?? '',
      issuedDate: json['issued_date'] != null
          ? DateTime.parse(json['issued_date'])
          : DateTime.now(),
      downloadUrl: json['download_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'certificate_id': certificateId,
      'event_id': eventId,
      'event_title': eventTitle,
      'student_id': studentId,
      'student_name': studentName,
      'role_name': roleName,
      'issued_date': issuedDate.toIso8601String(),
      'download_url': downloadUrl,
    };
  }
}
