import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/kala_colors.dart';
import '../../domain/models/opportunity_model.dart';

class OpportunityShareModal extends StatelessWidget {
  final OpportunityModel opportunity;

  const OpportunityShareModal({super.key, required this.opportunity});

  String get _deepLink => 'https://kala.app/apply/${opportunity.opportunityId}';

  String get _whatsappText =>
      '🎨 *${opportunity.title}*\n\n'
      '🏷️ Category: ${opportunity.category}\n'
      '💰 Stipend: ${opportunity.stipend}\n'
      '👥 Vacancies: ${opportunity.vacancies}\n'
      '⏰ Deadline: ${_formatDate(opportunity.deadline)}\n\n'
      '🔗 Apply Now on KALĀ:\n$_deepLink';

  String _formatDate(DateTime dt) {
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    final encoded = Uri.encodeComponent(_whatsappText);
    final uri = Uri.parse('https://wa.me/?text=$encoded');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp')),
        );
      }
    }
  }

  Future<void> _copyLink(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _deepLink));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link copied to clipboard!'),
          backgroundColor: KalaColors.accentGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: KalaColors.ivory,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Share Opportunity', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 20, fontWeight: FontWeight.bold, color: KalaColors.charcoal)),
                    const SizedBox(height: 2),
                    Text(opportunity.title, style: const TextStyle(fontSize: 12, color: KalaColors.mediumGrey)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // QR Code
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  QrImageView(
                    data: _deepLink,
                    version: QrVersions.auto,
                    size: 180,
                    eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: KalaColors.charcoal),
                    dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: KalaColors.charcoal),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Scan to Apply',
                    style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 12, color: KalaColors.charcoal.withValues(alpha: 0.6)),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Link Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: KalaColors.softBeige,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _deepLink,
                    style: const TextStyle(fontSize: 12, color: KalaColors.charcoal),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () => _copyLink(context),
                  child: const Icon(Icons.copy_outlined, size: 18, color: KalaColors.burntOrange),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Buttons
          Row(
            children: [
              // WhatsApp
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _openWhatsApp(context),
                  icon: const Icon(Icons.message_outlined, size: 18),
                  label: const Text('Share on WhatsApp', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 13, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Copy
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _copyLink(context),
                  icon: const Icon(Icons.link_outlined, size: 18),
                  label: const Text('Copy Link', style: TextStyle(fontFamily: 'ZT_Nature', fontSize: 13, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: KalaColors.charcoal,
                    side: BorderSide(color: KalaColors.charcoal.withValues(alpha: 0.2)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
