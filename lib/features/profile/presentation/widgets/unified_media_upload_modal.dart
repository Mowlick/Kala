import 'package:flutter/material.dart';
import '../../../../core/theme/kala_colors.dart';
import '../../domain/models/portfolio_item_model.dart';
import '../../../media/services/media_upload_service.dart';

class CategoryConfig {
  final String title;
  final String step1Title;
  final String pickLabel;
  final String fileFormatInfo;
  final IconData icon;
  final String titleLabel;
  final String titleHint;
  final String descLabel;
  final String descHint;
  final String extraFieldLabel;
  final String extraFieldHint;
  final String previewCategoryLabel;

  CategoryConfig({
    required this.title,
    required this.step1Title,
    required this.pickLabel,
    required this.fileFormatInfo,
    required this.icon,
    required this.titleLabel,
    required this.titleHint,
    required this.descLabel,
    required this.descHint,
    required this.extraFieldLabel,
    required this.extraFieldHint,
    required this.previewCategoryLabel,
  });

  static CategoryConfig getConfig(String category) {
    switch (category.toLowerCase()) {
      case 'project':
        return CategoryConfig(
          title: 'Upload Project',
          step1Title: '1. Select Project Brief or Deck',
          pickLabel: 'Tap to Choose Project Deck / Document',
          fileFormatInfo: 'Supports PDF, ZIP, FIG, DOCX up to 100MB',
          icon: Icons.cloud_upload_outlined,
          titleLabel: 'Project Name',
          titleHint: 'e.g. FrameStories Short Film or Synthesizer VST Plugin',
          descLabel: 'Project Pitch & Key Highlights',
          descHint:
              'Describe the objective, your creative role, technologies or tools used...',
          extraFieldLabel: 'Repository / Project / Behance Link (Optional)',
          extraFieldHint: 'https://behance.net/gallery/...',
          previewCategoryLabel: 'PROJECT DECK',
        );

      case 'performance':
        return CategoryConfig(
          title: 'Add Performance',
          step1Title: '1. Upload Performance Media',
          pickLabel: 'Tap to Choose Stage Performance Video / Recording',
          fileFormatInfo: 'Supports MP4, MOV, MP3, WAV up to 100MB',
          icon: Icons.curtains_outlined,
          titleLabel: 'Performance Title',
          titleHint: 'e.g. Live Acoustic Solo at Mood Indigo 2025',
          descLabel: 'Setlist, Stage Venue & Act Description',
          descHint:
              'Mention venue name, setlist, stage lighting or ensemble partners...',
          extraFieldLabel: 'Event / Festival Reference (Optional)',
          extraFieldHint: 'e.g. Mood Indigo 2025 Cultural Fest',
          previewCategoryLabel: 'LIVE PERFORMANCE',
        );

      case 'photo':
        return CategoryConfig(
          title: 'Upload Photos',
          step1Title: '1. Select Photo Gallery / Stills',
          pickLabel: 'Tap to Choose High-Res Photos',
          fileFormatInfo: 'Supports JPG, PNG, WEBP, HEIC up to 25MB',
          icon: Icons.image_outlined,
          titleLabel: 'Photo Shoot Title',
          titleHint:
              'e.g. Editorial Fashion Shoot or Live Stage Concert Stills',
          descLabel: 'Photo Story & Creative Concept',
          descHint:
              'Describe the shoot concept, moodboard, lighting setup or theme...',
          extraFieldLabel: 'Photographer / Studio Credits (Optional)',
          extraFieldHint: 'e.g. Captured by @lenscraft_studios',
          previewCategoryLabel: 'PHOTO GALLERY',
        );

      case 'video':
        return CategoryConfig(
          title: 'Upload Video',
          step1Title: '1. Select Video Reel / Clip',
          pickLabel: 'Tap to Choose Video Showreel or Reel Clip',
          fileFormatInfo: 'Supports MP4, MOV, WEBM up to 100MB',
          icon: Icons.videocam_outlined,
          titleLabel: 'Video Title / Reel Name',
          titleHint: 'e.g. 2026 Acting Showreel or Classical Dance Cover',
          descLabel: 'Video Description & Timestamp Highlights',
          descHint:
              'Highlight key scenes, monologues or solo choreography timestamps...',
          extraFieldLabel: 'Video Type / Category',
          extraFieldHint: 'e.g. Showreel, Monologue, Dance Cover, Music Video',
          previewCategoryLabel: 'VIDEO SHOWREEL',
        );

      case 'audio':
        return CategoryConfig(
          title: 'Upload Audio Track',
          step1Title: '1. Select Audio Recording / Demo',
          pickLabel: 'Tap to Choose Audio Track or Voice Demo',
          fileFormatInfo: 'Supports MP3, WAV, AAC, FLAC up to 50MB',
          icon: Icons.music_note_outlined,
          titleLabel: 'Song / Audio Track Title',
          titleHint:
              'e.g. Amber Skies (Acoustic Original) or Classical Raga Demo',
          descLabel: 'Lyrics, Genre & Composition Details',
          descHint:
              'Add genre (e.g., Jazz, Hindustani Vocal), key signature, lyrics...',
          extraFieldLabel: 'Producer / Mixing & Mastering Credits (Optional)',
          extraFieldHint: 'e.g. Mixed by SoundLab Studios',
          previewCategoryLabel: 'AUDIO TRACK',
        );

      case 'certificate':
        return CategoryConfig(
          title: 'Certificates & Awards',
          step1Title: '1. Select Certificate PDF or Trophy Photo',
          pickLabel: 'Tap to Choose Certificate PDF or Trophy Image',
          fileFormatInfo: 'Supports PDF, PNG, JPG up to 15MB',
          icon: Icons.emoji_events_outlined,
          titleLabel: 'Award / Certificate Title',
          titleHint: 'e.g. Winner - Best Vocalist Trophy, Mood Indigo 2025',
          descLabel: 'Issuing Organization & Citation Summary',
          descHint:
              'Mention issuing academy, competition rank, or honorable mentions...',
          extraFieldLabel: 'Credential Verification ID / URL (Optional)',
          extraFieldHint: 'e.g. CERT-2025-Vocal-8891',
          previewCategoryLabel: 'OFFICIAL CERTIFICATE',
        );

      default:
        return CategoryConfig(
          title: 'Upload Media',
          step1Title: '1. Select Media File',
          pickLabel: 'Tap to Choose Media File',
          fileFormatInfo: 'Supports MP4, MP3, JPG, PNG, PDF up to 50MB',
          icon: Icons.cloud_upload_outlined,
          titleLabel: 'Title',
          titleHint: 'Enter item title',
          descLabel: 'Description',
          descHint: 'Enter description...',
          extraFieldLabel: 'Additional Reference (Optional)',
          extraFieldHint: 'Enter optional reference...',
          previewCategoryLabel: 'PORTFOLIO ITEM',
        );
    }
  }
}

class UnifiedMediaUploadModal extends StatefulWidget {
  final String
  category; // project, performance, photo, video, audio, certificate
  final Function(PortfolioItemModel item) onSave;

  const UnifiedMediaUploadModal({
    super.key,
    required this.category,
    required this.onSave,
  });

  static void show(
    BuildContext context, {
    required String category,
    required Function(PortfolioItemModel item) onSave,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.88,
        child: UnifiedMediaUploadModal(category: category, onSave: onSave),
      ),
    );
  }

  @override
  State<UnifiedMediaUploadModal> createState() =>
      _UnifiedMediaUploadModalState();
}

class _UnifiedMediaUploadModalState extends State<UnifiedMediaUploadModal> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0; // 0: Select Media, 1: Add Details, 2: Preview

  String _title = '';
  String _description = '';
  String _extraField = '';
  String _mediaUrl = '';
  String _fileName = '';
  bool _isFeatured = false;
  PortfolioVisibility _visibility = PortfolioVisibility.public;
  String? _relatedEventId;
  bool _isUploading = false;

  late CategoryConfig _config;

  @override
  void initState() {
    super.initState();
    _config = CategoryConfig.getConfig(widget.category);
  }

  void _handlePickMedia() async {
    setState(() => _isUploading = true);
    final result = await MediaUploadService().uploadFile(
      filePath: '/mock/path/file.mp4',
      fileName: '${widget.category}_${DateTime.now().millisecondsSinceEpoch}',
      category: widget.category,
    );
    setState(() {
      _isUploading = false;
      if (result.isSuccess) {
        _mediaUrl = result.fileUrl ?? '';
        _fileName = result.fileName ?? '';
        _currentStep = 1; // Advance to details
      }
    });
  }

  void _submitForm(bool isDraft) {
    if (_currentStep == 1) {
      if (!(_formKey.currentState?.validate() ?? false)) return;
      _formKey.currentState?.save();
      setState(() => _currentStep = 2); // Move to Preview
      return;
    }

    final fullDescription = _extraField.isNotEmpty
        ? '$_description\n\n[${_config.extraFieldLabel}]: $_extraField'
        : _description;

    final item = PortfolioItemModel(
      id: 'port_${DateTime.now().millisecondsSinceEpoch}',
      title: _title,
      description: fullDescription,
      mediaUrl: _mediaUrl.isNotEmpty
          ? _mediaUrl
          : 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
      category: widget.category,
      isFeatured: _isFeatured,
      visibility: _visibility,
      relatedEventId: _relatedEventId,
      isDraft: isDraft,
      createdAt: DateTime.now(),
    );

    widget.onSave(item);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isDraft ? 'Saved to Drafts 📝' : 'Published to Public Portfolio! ⭐',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: KalaColors.charcoal),
                onPressed: () {
                  if (_currentStep > 0) {
                    setState(() => _currentStep--);
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _config.title,
                      style: const TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: KalaColors.charcoal,
                      ),
                    ),
                    Text(
                      'Step ${_currentStep + 1} of 3 • ${_config.previewCategoryLabel}',
                      style: const TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 11,
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
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 16),

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buildStepContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep0SelectMedia();
      case 1:
        return _buildStep1AddDetails();
      case 2:
        return _buildStep2Preview();
      default:
        return _buildStep0SelectMedia();
    }
  }

  Widget _buildStep0SelectMedia() {
    return Column(
      key: const ValueKey(0),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _isUploading ? null : _handlePickMedia,
          child: Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: KalaColors.burntOrange.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isUploading
                    ? const CircularProgressIndicator(
                        color: KalaColors.burntOrange,
                      )
                    : Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: KalaColors.burntOrange.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _config.icon,
                          size: 38,
                          color: KalaColors.burntOrange,
                        ),
                      ),
                const SizedBox(height: 14),
                Text(
                  _isUploading
                      ? 'Uploading & Processing Media...'
                      : _config.pickLabel,
                  style: const TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: KalaColors.charcoal,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _config.fileFormatInfo,
                  style: const TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 11,
                    color: KalaColors.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep1AddDetails() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        key: const ValueKey(1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_fileName.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: KalaColors.softBeige,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(_config.icon, color: KalaColors.burntOrange, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'File Selected: $_fileName',
                        style: const TextStyle(
                          fontFamily: 'ZT_Nature',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.check_circle,
                      color: KalaColors.accentGreen,
                      size: 18,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Tailored Title Field
            Text(
              _config.titleLabel,
              style: const TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: KalaColors.charcoal,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              decoration: InputDecoration(
                hintText: _config.titleHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (val) => (val == null || val.trim().isEmpty)
                  ? 'Please enter a title'
                  : null,
              onSaved: (val) => _title = val?.trim() ?? '',
            ),
            const SizedBox(height: 16),

            // Tailored Description Field
            Text(
              _config.descLabel,
              style: const TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: KalaColors.charcoal,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: _config.descHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSaved: (val) => _description = val?.trim() ?? '',
            ),
            const SizedBox(height: 16),

            // Tailored Extra Field (Credits / Links / References)
            Text(
              _config.extraFieldLabel,
              style: const TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: KalaColors.charcoal,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              decoration: InputDecoration(
                hintText: _config.extraFieldHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSaved: (val) => _extraField = val?.trim() ?? '',
            ),
            const SizedBox(height: 16),

            // ⭐ Featured Toggle
            SwitchListTile(
              title: const Text(
                '⭐ Feature on Public Profile',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Featured items appear first on your creative profile',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 11,
                  color: KalaColors.mediumGrey,
                ),
              ),
              value: _isFeatured,
              activeTrackColor: KalaColors.burntOrange,
              onChanged: (val) => setState(() => _isFeatured = val),
            ),

            // 🔒 Visibility Dropdown
            const Text(
              'Visibility Setting',
              style: TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: KalaColors.charcoal,
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<PortfolioVisibility>(
              initialValue: _visibility,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: PortfolioVisibility.values
                  .map((v) => DropdownMenuItem(value: v, child: Text(v.label)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _visibility = val);
              },
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => _submitForm(false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: KalaColors.burntOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue to Preview',
                  style: TextStyle(
                    fontFamily: 'ZT_Nature',
                    fontSize: 15,
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

  Widget _buildStep2Preview() {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_config.previewCategoryLabel} Card Preview:',
          style: const TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: KalaColors.charcoal,
          ),
        ),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: KalaColors.lightGrey),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 70,
                  height: 70,
                  color: KalaColors.softBeige,
                  child: Icon(
                    _config.icon,
                    color: KalaColors.burntOrange,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (_isFeatured)
                          const Text('⭐ ', style: TextStyle(fontSize: 12)),
                        Expanded(
                          child: Text(
                            _title,
                            style: const TextStyle(
                              fontFamily: 'ZT_Nature',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: KalaColors.charcoal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'ZT_Nature',
                        fontSize: 11,
                        color: KalaColors.mediumGrey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            _config.previewCategoryLabel,
                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: KalaColors.burntOrange,
                            ),
                          ),
                          backgroundColor: KalaColors.burntOrange.withValues(
                            alpha: 0.1,
                          ),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        const SizedBox(width: 6),
                        Chip(
                          label: Text(
                            _visibility.label,
                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: KalaColors.softBeige,
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Spacer(),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _submitForm(true), // Save Draft
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save as Draft 📝',
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
                onPressed: () => _submitForm(false), // Publish
                style: ElevatedButton.styleFrom(
                  backgroundColor: KalaColors.burntOrange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Publish Now ⭐',
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
    );
  }
}
