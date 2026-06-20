import 'package:flutter/material.dart';
import '../../../../core/theme/kala_colors.dart';

class ChatRoomScreen extends StatefulWidget {
  final Map<String, dynamic>? chat;
  const ChatRoomScreen({super.key, this.chat});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'isMe': false,
      'text': 'Hi Aarav! Hope you are doing well.',
      'time': '9:15 AM',
    },
    {
      'isMe': false,
      'text':
          'I saw your latest performance reel on KALĀ and absolutely loved the cinematography and singing! 🌟',
      'time': '9:16 AM',
    },
    {
      'isMe': true,
      'text':
          'Thank you so much, Rhea! That means a lot coming from you. I spent a lot of time arranging that track.',
      'time': '9:20 AM',
    },
    {
      'isMe': false,
      'text':
          'Loved your latest reel! Let\'s talk about collaborating on my next short indie film project. We are looking for a lead vocalist.',
      'time': '9:22 AM',
    },
    {
      'isMe': true,
      'text':
          'That sounds like an amazing opportunity! I would love to read the script and hear more details about the musical theme.',
      'time': '9:25 AM',
    },
    {
      'isMe': false,
      'text':
          'Perfect! Let me send over a brief draft of the script treatment tonight.',
      'time': '9:32 AM',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({'isMe': true, 'text': text, 'time': 'Just now'});
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve passed user chat arguments
    final Map<String, dynamic> chat = widget.chat ??
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ??
        {
          'name': 'Rhea Sharma',
          'role': 'Director',
          'avatar':
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
        };

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(chat['avatar'] as String),
              radius: 18,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat['name'] as String,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${chat['role']} • Active now',
                  style: const TextStyle(
                    fontSize: 9,
                    color: KalaColors.accentGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.videocam_outlined,
              color: KalaColors.charcoal,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call_outlined, color: KalaColors.charcoal),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: KalaColors.charcoal),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Messages Stream Grid
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isMe = msg['isMe'] as bool;
                  final text = msg['text'] as String;
                  final time = msg['time'] as String;

                  return Align(
                    alignment: isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isMe ? KalaColors.burntOrange : Colors.white,
                        border: isMe
                            ? null
                            : Border.all(color: KalaColors.softBeige),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isMe ? 16 : 4),
                          bottomRight: Radius.circular(isMe ? 4 : 16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            text,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: isMe
                                      ? Colors.white
                                      : KalaColors.charcoal,
                                  height: 1.3,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              time,
                              style: TextStyle(
                                fontSize: 8,
                                color: isMe
                                    ? Colors.white.withValues(alpha: 0.7)
                                    : KalaColors.mediumGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // 2. Message Inputs Tray Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: KalaColors.softBeige),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  // Attachment Icon
                  IconButton(
                    icon: const Icon(Icons.add, color: KalaColors.burntOrange),
                    onPressed: () {},
                  ),
                  // Text input
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        fillColor: KalaColors.ivory,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Send or Microphone Action
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: KalaColors.burntOrange,
                    ),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
