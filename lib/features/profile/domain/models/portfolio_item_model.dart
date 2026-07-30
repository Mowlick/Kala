enum PortfolioVisibility {
  public,
  private,
  unlisted,
}

extension PortfolioVisibilityExtension on PortfolioVisibility {
  String get label {
    switch (this) {
      case PortfolioVisibility.public:
        return 'Public';
      case PortfolioVisibility.private:
        return 'Private';
      case PortfolioVisibility.unlisted:
        return 'Unlisted';
    }
  }
}

class PortfolioItemModel {
  final String id;
  final String title;
  final String description;
  final String mediaUrl;
  final String category; // project, performance, photo, video, audio, certificate
  final List<String> tags;
  final bool isFeatured;
  final PortfolioVisibility visibility;
  final String? relatedEventId;
  final String? relatedOpportunityId;
  final bool isDraft;
  final DateTime createdAt;

  PortfolioItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.mediaUrl,
    required this.category,
    this.tags = const [],
    this.isFeatured = false,
    this.visibility = PortfolioVisibility.public,
    this.relatedEventId,
    this.relatedOpportunityId,
    this.isDraft = false,
    required this.createdAt,
  });

  factory PortfolioItemModel.fromJson(Map<String, dynamic> json) {
    return PortfolioItemModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      mediaUrl: json['media_url'] ?? '',
      category: json['category'] ?? 'project',
      tags: List<String>.from(json['tags'] ?? []),
      isFeatured: json['is_featured'] ?? false,
      visibility: PortfolioVisibility.values.firstWhere(
        (v) => v.name == json['visibility'],
        orElse: () => PortfolioVisibility.public,
      ),
      relatedEventId: json['related_event_id'],
      relatedOpportunityId: json['related_opportunity_id'],
      isDraft: json['is_draft'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'media_url': mediaUrl,
      'category': category,
      'tags': tags,
      'is_featured': isFeatured,
      'visibility': visibility.name,
      'related_event_id': relatedEventId,
      'related_opportunity_id': relatedOpportunityId,
      'is_draft': isDraft,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
