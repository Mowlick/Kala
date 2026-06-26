import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/kala_colors.dart';
import '../../domain/models/chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isLastInGroup;
  final bool isFirstInGroup;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isLastInGroup,
    required this.isFirstInGroup,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    const myBubbleColor = Color(0xFFFDE8DC);
    const theirBubbleColor = Colors.white;

    final radius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: Radius.circular(isMe ? 18 : (isLastInGroup ? 4 : 18)),
      bottomRight: Radius.circular(isMe ? (isLastInGroup ? 4 : 18) : 18),
    );

    // Build the inner bubble content differently for me vs them
    final Widget bubbleBody = Container(
      constraints: const BoxConstraints(maxWidth: 340, minWidth: 60),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: isMe ? myBubbleColor : theirBubbleColor,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isMe
          // Outgoing: time + ticks INSIDE bubble
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message.text,
                  style: GoogleFonts.inter(fontSize: 13, height: 1.4, color: KalaColors.charcoal),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.time,
                      style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey),
                    ),
                    const SizedBox(width: 3),
                    Icon(
                      Icons.done_all,
                      size: 13,
                      color: message.isRead ? KalaColors.burntOrange : KalaColors.mediumGrey,
                    ),
                  ],
                ),
              ],
            )
          // Incoming: only text inside bubble, time goes below
          : Text(
              message.text,
              style: GoogleFonts.inter(fontSize: 13, height: 1.4, color: KalaColors.charcoal),
            ),
    );

    // For incoming, stack time below the bubble
    Widget content = isMe
        ? bubbleBody
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              bubbleBody,
              if (isLastInGroup) ...[
                const SizedBox(height: 3),
                Padding(
                  padding: EdgeInsets.zero,
                  child: Text(
                    message.time,
                    style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey),
                  ),
                ),
              ],
            ],
          );

    // Heart reaction: standalone row below the bubble
    if (message.hasHeart) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          content,
          const SizedBox(height: 4),
          const Text('❤', style: TextStyle(fontSize: 14)),
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: isLastInGroup ? 14 : 3,
        top: isFirstInGroup ? 2 : 0,
      ),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(width: 4),
          content,
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
