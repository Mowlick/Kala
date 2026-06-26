import 'package:flutter/material.dart';
import '../../../../core/theme/kala_colors.dart';
import '../../../../core/widgets/kala_search_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/chat_contact.dart';
import '../widgets/chat_message_bubble.dart';

// Minimal stub – full chat UI is embedded directly inside InboxScreen.
// This route is only triggered on mobile when tapping a conversation.
class ChatRoomScreen extends StatefulWidget {
  final ChatContact? contact;
  final List<ChatMessage>? messages;
  const ChatRoomScreen({super.key, this.contact, this.messages});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _msgCtrl = TextEditingController();
  late List<ChatMessage> _msgs;

  @override
  void initState() {
    super.initState();
    _msgs = List.from(widget.messages ?? []);
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final t = _msgCtrl.text.trim();
    if (t.isEmpty) return;
    setState(() => _msgs.add(ChatMessage(isMe: true, text: t, time: 'Just now')));
    _msgCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    // If pushed via named route with a map (fallback), extract info.
    // Otherwise use the strongly-typed widget.contact.
    final argMap = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    final name = widget.contact?.name ?? argMap?['name'] as String? ?? 'Rhea Sharma';
    final role = widget.contact?.role ?? argMap?['role'] as String? ?? 'Director';
    final city = widget.contact?.city ?? argMap?['city'] as String? ?? 'Mumbai';
    final avatar = widget.contact?.avatar ?? argMap?['avatar'] as String? ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200';
    final isVerified = widget.contact?.isVerified ?? (name == 'Rhea Sharma');

    return Scaffold(
      backgroundColor: KalaColors.ivory,
      appBar: AppBar(
        backgroundColor: KalaColors.ivory,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KalaColors.charcoal, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(avatar),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: KalaColors.charcoal),
                    ),
                    if (isVerified) ...[
                      const SizedBox(width: 3),
                      const Icon(Icons.verified, size: 13, color: KalaColors.burntOrange),
                    ],
                  ],
                ),
                Text(
                  '$role • $city',
                  style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call_outlined, color: KalaColors.charcoal, size: 20), onPressed: () {}),
          IconButton(icon: const Icon(Icons.videocam_outlined, color: KalaColors.charcoal, size: 20), onPressed: () {}),
          IconButton(icon: const Icon(Icons.info_outline, color: KalaColors.charcoal, size: 20), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFEFE7D6)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _msgs.length + 1,
              itemBuilder: (ctx, i) {
                if (i == 0) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE8E0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('Today',
                            style: GoogleFonts.inter(fontSize: 11, color: KalaColors.mediumGrey, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  );
                }
                final msg = _msgs[i - 1];
                final nextMsg = i < _msgs.length ? _msgs[i] : null;
                final prevMsg = i > 1 ? _msgs[i - 2] : null;
                final isLastInGroup = nextMsg == null || nextMsg.isMe != msg.isMe;
                final isFirstInGroup = prevMsg == null || prevMsg.isMe != msg.isMe;
                return ChatMessageBubble(
                  message: msg,
                  isLastInGroup: isLastInGroup,
                  isFirstInGroup: isFirstInGroup,
                );
              },
            ),
          ),
          // Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: KalaColors.ivory,
              border: Border(top: BorderSide(color: Color(0xFFEFE7D6))),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.mic_none_outlined, color: KalaColors.mediumGrey, size: 24),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: KalaSearchBar(
                    controller: _msgCtrl,
                    onSubmitted: (_) => _send(),
                    hintText: 'Type a message...',
                    prefixIcon: null, // No search icon
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.emoji_emotions_outlined, color: KalaColors.mediumGrey, size: 22),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: KalaColors.burntOrange,
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
