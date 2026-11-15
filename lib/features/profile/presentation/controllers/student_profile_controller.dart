import 'package:flutter/foundation.dart';
import '../../domain/models/portfolio_item_model.dart';

class StudentProfileController extends ChangeNotifier {
  final List<PortfolioItemModel> _portfolioItems = [];
  final List<String> _skills = [
    'Lead Singing',
    'Bollywood Playback',
    'Contemporary Dance',
  ];
  final List<String> _experiences = [
    'Vocalist at NCPA Music Fest (2025)',
    'Lead Dancer in FrameStories Short Film',
  ];
  String _bio =
      'Passionate vocalist & performer based in Mumbai. 5+ years live stage experience.';
  String _demoReelUrl = 'https://youtube.com/watch?v=mock_demo_reel';
  List<String> _creativeRoles = ['Singer', 'Vocalist', 'Dancer'];

  List<PortfolioItemModel>? _featuredItemsCache;
  List<PortfolioItemModel>? _draftsCache;

  List<PortfolioItemModel> get portfolioItems =>
      List.unmodifiable(_portfolioItems);
  List<PortfolioItemModel> get featuredItems {
    _featuredItemsCache ??= _portfolioItems
        .where((i) => i.isFeatured && !i.isDraft)
        .toList();
    return _featuredItemsCache!;
  }

  List<PortfolioItemModel> get drafts {
    _draftsCache ??= _portfolioItems.where((i) => i.isDraft).toList();
    return _draftsCache!;
  }

  void _invalidateCaches() {
    _featuredItemsCache = null;
    _draftsCache = null;
  }

  List<String> get skills => List.unmodifiable(_skills);
  List<String> get experiences => List.unmodifiable(_experiences);
  String get bio => _bio;
  String get demoReelUrl => _demoReelUrl;
  List<String> get creativeRoles => List.unmodifiable(_creativeRoles);

  StudentProfileController() {
    _seedMockPortfolio();
  }

  void _seedMockPortfolio() {
    _portfolioItems.add(
      PortfolioItemModel(
        id: 'port_1',
        title: 'NCPA Live Solo Performance',
        description: 'Recorded live at National Center for Performing Arts',
        mediaUrl:
            'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
        category: 'performance',
        tags: ['Live', 'Vocal', 'Classical'],
        isFeatured: true,
        visibility: PortfolioVisibility.public,
        relatedEventId: 'evt_101',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    );

    _portfolioItems.add(
      PortfolioItemModel(
        id: 'port_2',
        title: 'Best Vocalist Award 2025',
        description: 'First place trophy at Inter-College Fest',
        mediaUrl:
            'https://images.unsplash.com/photo-1567427017947-545c5f8d16ad',
        category: 'certificate',
        tags: ['Award', 'Trophy'],
        isFeatured: true,
        visibility: PortfolioVisibility.public,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    );
  }

  // Calculate dynamic Profile Completion Percentage (0.0 to 1.0)
  double get profileCompletionScore {
    int totalMilestones = 6;
    int completed = 0;

    if (_portfolioItems.any((i) => !i.isDraft)) completed++;
    if (_demoReelUrl.isNotEmpty) completed++;
    if (_bio.trim().isNotEmpty) completed++;
    if (_skills.isNotEmpty) completed++;
    if (_experiences.isNotEmpty) completed++;
    if (_portfolioItems.any((i) => i.category == 'certificate')) completed++;

    return completed / totalMilestones;
  }

  // Add or update portfolio item
  void savePortfolioItem(PortfolioItemModel item) {
    final idx = _portfolioItems.indexWhere((p) => p.id == item.id);
    if (idx != -1) {
      _portfolioItems[idx] = item;
    } else {
      _portfolioItems.add(item);
    }
    _invalidateCaches();
    notifyListeners();
  }

  void addSkill(String skill) {
    if (!_skills.contains(skill)) {
      _skills.add(skill);
      notifyListeners();
    }
  }

  void addExperience(String exp) {
    _experiences.add(exp);
    notifyListeners();
  }

  void updateBio(String bio) {
    _bio = bio;
    notifyListeners();
  }

  void updateDemoReel(String url) {
    _demoReelUrl = url;
    notifyListeners();
  }

  void updateCreativeRoles(List<String> roles) {
    _creativeRoles = roles;
    notifyListeners();
  }
}
