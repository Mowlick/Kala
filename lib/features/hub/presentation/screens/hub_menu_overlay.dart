import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/kala_colors.dart';
import '../../../profile/presentation/controllers/student_profile_controller.dart';
import '../../../profile/presentation/widgets/unified_media_upload_modal.dart';
import '../../../profile/presentation/widgets/career_experience_editor_modal.dart';
import '../../../profile/presentation/widgets/showcase_yourself_editor_modal.dart';

class HubMenuOverlay extends StatelessWidget {
  final VoidCallback? onClose;

  const HubMenuOverlay({super.key, this.onClose});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const HubMenuOverlay(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final profileController = context.watch<StudentProfileController>();
    final double completionScore = profileController.profileCompletionScore;

    return Container(
      height: screenHeight * 0.94,
      decoration: const BoxDecoration(
        color: KalaColors.ivory,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 12),
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: KalaColors.lightGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),

                      // Dynamic Profile Progress Card
                      _buildProfileProgressCard(
                        context,
                        profileController,
                        completionScore,
                      ),
                      const SizedBox(height: 28),

                      // Section 1: 🎨 Add to Portfolio
                      _buildSectionHeader(
                        '🎨 Add to Portfolio',
                        const Color(0xFFEA580C),
                      ),
                      const SizedBox(height: 12),
                      _buildPortfolioGrid(context, profileController),
                      const SizedBox(height: 28),

                      // Section 2: 💼 Career & Experience
                      _buildSectionHeader(
                        '💼 Career & Experience',
                        KalaColors.burntOrange,
                      ),
                      const SizedBox(height: 12),
                      _buildCareerSectionList(context, profileController),
                      const SizedBox(height: 28),

                      // Section 3: ✨ Showcase Yourself
                      _buildSectionHeader(
                        '✨ Showcase Yourself',
                        const Color(0xFF2563EB),
                      ),
                      const SizedBox(height: 12),
                      _buildShowcaseSectionList(context, profileController),
                      const SizedBox(height: 28),

                      // Bottom Section: Drafts & Recently Added
                      _buildDraftsSection(profileController),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Floating Close Button
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: InkWell(
                onTap: () {
                  if (onClose != null) {
                    onClose!();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEA580C),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEA580C).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Creative Profile Builder',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.charcoal,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Build your portfolio & make yourself recruitment-ready.',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 13,
                  color: KalaColors.mediumGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── DYNAMIC PROFILE PROGRESS CARD ─────────────────────────────────────────
  Widget _buildProfileProgressCard(
    BuildContext context,
    StudentProfileController controller,
    double score,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: KalaColors.burntOrange.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: KalaColors.burntOrange.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recruitment Readiness',
                style: TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.charcoal,
                ),
              ),
              Text(
                '${(score * 100).toInt()}% Complete',
                style: const TextStyle(
                  fontFamily: 'ZT_Nature',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: KalaColors.burntOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score,
              minHeight: 6,
              backgroundColor: KalaColors.lightGrey,
              color: KalaColors.burntOrange,
            ),
          ),
          const SizedBox(height: 14),

          // Milestone Chips
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _milestoneChip(
                '🎨 Portfolio Uploaded',
                controller.portfolioItems.isNotEmpty,
              ),
              _milestoneChip(
                '🎬 Demo Reel Added',
                controller.demoReelUrl.isNotEmpty,
              ),
              _milestoneChip('✍️ Bio Completed', controller.bio.isNotEmpty),
              _milestoneChip('🛠️ Skills Added', controller.skills.isNotEmpty),
              _milestoneChip(
                '💼 Experience Added',
                controller.experiences.isNotEmpty,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _milestoneChip(String label, bool isDone) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDone ? KalaColors.softBeige : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDone ? KalaColors.burntOrange : KalaColors.lightGrey,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 12,
            color: isDone ? KalaColors.burntOrange : KalaColors.mediumGrey,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'ZT_Nature',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isDone ? KalaColors.burntOrange : KalaColors.mediumGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color actionColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: KalaColors.charcoal,
          ),
        ),
      ],
    );
  }

  // ─── SECTION 1: 🎨 ADD TO PORTFOLIO GRID ──────────────────────────────────
  Widget _buildPortfolioGrid(
    BuildContext context,
    StudentProfileController controller,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.4,
      children: [
        _buildGridCard(
          context,
          Icons.cloud_upload_outlined,
          'Upload Project',
          'Films, songs, designs\n& projects',
          const Color(0xFFEA580C),
          'project',
          controller,
        ),
        _buildGridCard(
          context,
          Icons.curtains_outlined,
          'Add Performance',
          'Live shows, dance,\ntheatre & acts',
          const Color(0xFFEA580C),
          'performance',
          controller,
        ),
        _buildGridCard(
          context,
          Icons.image_outlined,
          'Upload Photos',
          'Photoshoots, events\n& portraits',
          const Color(0xFFEA580C),
          'photo',
          controller,
        ),
        _buildGridCard(
          context,
          Icons.videocam_outlined,
          'Upload Videos',
          'Reels, performances\n& showreels',
          const Color(0xFFEA580C),
          'video',
          controller,
        ),
        _buildGridCard(
          context,
          Icons.music_note_outlined,
          'Upload Audio',
          'Songs, covers\n& podcasts',
          const Color(0xFFEA580C),
          'audio',
          controller,
        ),
        _buildGridCard(
          context,
          Icons.emoji_events_outlined,
          'Certificates & Awards',
          'Achievements\n& certificates',
          const Color(0xFFEA580C),
          'certificate',
          controller,
        ),
      ],
    );
  }

  Widget _buildGridCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    String category,
    StudentProfileController controller,
  ) {
    return GestureDetector(
      onTap: () {
        UnifiedMediaUploadModal.show(
          context,
          category: category,
          onSave: (item) {
            controller.savePortfolioItem(item);
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: KalaColors.lightGrey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: KalaColors.charcoal,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'ZT_Nature',
                fontSize: 9,
                color: KalaColors.mediumGrey,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── SECTION 2: 💼 CAREER & EXPERIENCE ───────────────────────────────────
  Widget _buildCareerSectionList(
    BuildContext context,
    StudentProfileController controller,
  ) {
    return Column(
      children: [
        _buildListItem(
          context,
          Icons.work_history_outlined,
          'Add Work Experience',
          'Companies, projects or bands worked with',
          () {
            CareerExperienceEditorModal.show(
              context,
              sectionTitle: 'Work Experience',
              onSave: (t, d, isDraft) => controller.addExperience('$t • $d'),
            );
          },
        ),
        _buildListItem(
          context,
          Icons.event_available_outlined,
          'Add Event Participation',
          'Auditions, college fests or competitions attended',
          () {
            CareerExperienceEditorModal.show(
              context,
              sectionTitle: 'Event Participation',
              onSave: (t, d, isDraft) => controller.addExperience('Event: $t'),
            );
          },
        ),
        _buildListItem(
          context,
          Icons.badge_outlined,
          'Add Internship Experience',
          'Practical training or studio internships',
          () {
            CareerExperienceEditorModal.show(
              context,
              sectionTitle: 'Internship',
              onSave: (t, d, isDraft) =>
                  controller.addExperience('Internship: $t'),
            );
          },
        ),
        _buildListItem(
          context,
          Icons.psychology_outlined,
          'Add Skills',
          'Vocal range, instruments, dance styles or software',
          () {
            CareerExperienceEditorModal.show(
              context,
              sectionTitle: 'Skill',
              onSave: (t, d, isDraft) => controller.addSkill(t),
            );
          },
        ),
      ],
    );
  }

  // ─── SECTION 3: ✨ SHOWCASE YOURSELF ──────────────────────────────────────
  Widget _buildShowcaseSectionList(
    BuildContext context,
    StudentProfileController controller,
  ) {
    return Column(
      children: [
        _buildListItem(
          context,
          Icons.edit_note_outlined,
          'Add Bio / About Me',
          'Summarize your artist identity & passion',
          () {
            ShowcaseYourselfEditorModal.show(
              context,
              settingTitle: 'Bio / About Me',
              initialValue: controller.bio,
              onSave: (val, isDraft) => controller.updateBio(val),
            );
          },
        ),
        _buildListItem(
          context,
          Icons.movie_filter_outlined,
          'Add Demo Reel',
          'Link your main video / audio showcase reel',
          () {
            ShowcaseYourselfEditorModal.show(
              context,
              settingTitle: 'Demo Reel Link',
              initialValue: controller.demoReelUrl,
              onSave: (val, isDraft) => controller.updateDemoReel(val),
            );
          },
        ),
        _buildListItem(
          context,
          Icons.category_outlined,
          'Update Creative Roles',
          'Singer, Vocalist, Actor, Dancer, etc.',
          () {
            ShowcaseYourselfEditorModal.show(
              context,
              settingTitle: 'Creative Roles',
              initialValue: controller.creativeRoles.join(', '),
              onSave: (val, isDraft) {
                controller.updateCreativeRoles(
                  val.split(',').map((e) => e.trim()).toList(),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildListItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KalaColors.lightGrey),
      ),
      child: ListTile(
        onTap: onTap,
        dense: true,
        leading: Icon(icon, color: KalaColors.burntOrange, size: 20),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: KalaColors.charcoal,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 10,
            color: KalaColors.mediumGrey,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          size: 18,
          color: KalaColors.mediumGrey,
        ),
      ),
    );
  }

  // ─── BOTTOM SECTION: DRAFTS & RECENTLY ADDED ──────────────────────────────
  Widget _buildDraftsSection(StudentProfileController controller) {
    final drafts = controller.drafts;
    if (drafts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📝 Draft Uploads',
          style: TextStyle(
            fontFamily: 'ZT_Nature',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: KalaColors.charcoal,
          ),
        ),
        const SizedBox(height: 10),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: drafts
                .map(
                  (draft) => Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: KalaColors.lightGrey),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.drafts_outlined,
                          color: KalaColors.burntOrange,
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          draft.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${draft.category.toUpperCase()} • Draft',
                          style: const TextStyle(
                            fontFamily: 'ZT_Nature',
                            fontSize: 9,
                            color: KalaColors.mediumGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
