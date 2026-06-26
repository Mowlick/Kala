class ChatMessage {
  final bool isMe;
  final String text;
  final String time;
  final bool hasHeart;
  final bool isRead;

  const ChatMessage({
    required this.isMe,
    required this.text,
    required this.time,
    this.hasHeart = false,
    this.isRead = true,
  });
}
