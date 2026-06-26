import 'package:flutter/material.dart';
import '../../../../core/theme/kala_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/kala_search_bar.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/chat_contact.dart';
import '../widgets/chat_message_bubble.dart';
import 'chat_room_screen.dart';


// ─── Static data ─────────────────────────────────────────────────────────────

const List<ChatContact> _storyContacts = [
  ChatContact(
    id: 'rhea',
    name: 'Rhea Sharma',
    role: 'Director',
    city: 'Mumbai',
    avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
    lastMsg: "Loved your latest reel! Let's talk about...",
    time: '9:32 AM',
    unread: 2,
    isPinned: true,
    isVerified: true,
    statusLabel: 'Online',
    hasGreenDot: true,
  ),
  ChatContact(
    id: 'kabir',
    name: 'Kabir Malhotra',
    role: 'Singer',
    city: 'Delhi',
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    lastMsg: '🎤 Voice note (00:28)',
    time: '10:15 AM',
    unread: 1,
    statusLabel: 'Typing...',
    hasGreenDot: true,
  ),
  ChatContact(
    id: 'nritya',
    name: 'Nritya Collective',
    role: 'Dance Group',
    city: 'Bangalore',
    avatar: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=200',
    lastMsg: 'Practice schedule for this weekend ✨',
    time: 'Yesterday',
    unread: 4,
    isPinned: true,
    statusLabel: 'Active now',
    hasGreenDot: true,
  ),
  ChatContact(
    id: 'arjun',
    name: 'Arjun Verma',
    role: 'Cinematographer',
    city: 'Pune',
    avatar: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=200',
    lastMsg: 'Sent you a portfolio link',
    time: 'Yesterday',
    unread: 0,
    statusLabel: 'Last seen 5m ago',
  ),
  ChatContact(
    id: 'meera',
    name: 'Meera Iyer',
    role: 'Writer',
    city: 'Chennai',
    avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
    lastMsg: "Thanks! I'll send the script tonight.",
    time: 'Mon',
    unread: 0,
    statusLabel: 'Last seen 1h ago',
  ),
    ChatContact(
    id: 'joe',
    name: 'Joe Francis',
    role: 'Writer',
    city: 'Delhi',
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    lastMsg: '🎤 Voice note (01:28)',
    time: '10:15 PM',
    unread: 1,
    statusLabel: 'Typing...',
    hasGreenDot: true,
  ),
  ChatContact(
    id: 'mitra',
    name: 'Mitra Collective',
    role: 'Dance Group',
    city: 'Bangalore',
    avatar: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=200',
    lastMsg: 'Practice schedule for this weekend ✨',
    time: 'Today',
    unread: 4,
    isPinned: true,
    statusLabel: 'Active now',
    hasGreenDot: true,
  ),
    ChatContact(
    id: 'arjun',
    name: 'Arjun Verma',
    role: 'Cinematographer',
    city: 'Pune',
    avatar: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=200',
    lastMsg: 'Sent you a portfolio link',
    time: 'Yesterday',
    unread: 0,
    statusLabel: 'Last seen 5m ago',
  ),
    ChatContact(
    id: 'meera',
    name: 'Meera Iyer',
    role: 'Writer',
    city: 'Chennai',
    avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
    lastMsg: "Thanks! I'll send the script tonight.",
    time: 'Mon',
    unread: 0,
    statusLabel: 'Last seen 1h ago',
  ),
];

const Map<String, List<ChatMessage>> _messagesMap = {
  'rhea': [
    ChatMessage(isMe: false, text: 'Hi Aarav! 👋', time: '9:36 AM'),
    ChatMessage(isMe: false, text: 'Loved your latest singing reel.', time: '9:31 AM'),
    ChatMessage(isMe: false, text: 'Would love to collaborate on an upcoming music video.', time: '9:31 AM'),
    ChatMessage(isMe: true, text: 'Hey Rhea! Thank you so much! 🙌', time: '9:32 AM'),
    ChatMessage(isMe: true, text: 'That would be amazing!', time: '9:32 AM'),
    ChatMessage(isMe: false, text: "Great! Let's connect on a call tomorrow?", time: '9:33 AM'),
    ChatMessage(isMe: true, text: 'Sure, 11 AM works for me.', time: '9:32 AM'),
    ChatMessage(isMe: false, text: 'Perfect. Talk tomorrow!', time: '9:33 AM', hasHeart: true),
  ],
  'kabir': [
    ChatMessage(isMe: false, text: 'Hey! Check out this voice note 🎤', time: '10:14 AM'),
    ChatMessage(isMe: true, text: 'Sure, sending it over!', time: '10:15 AM'),
  ],
  'nritya': [
    ChatMessage(isMe: false, text: 'Practice schedule for this weekend ✨', time: 'Yesterday'),
    ChatMessage(isMe: true, text: "Noted! I'll be there 💃", time: 'Yesterday'),
  ],
  'arjun': [
    ChatMessage(isMe: false, text: 'Sent you a portfolio link', time: 'Yesterday'),
    ChatMessage(isMe: true, text: 'Thanks, checking it out now!', time: 'Yesterday'),
  ],
  'meera': [
    ChatMessage(isMe: false, text: "Thanks! I'll send the script tonight.", time: 'Mon'),
    ChatMessage(isMe: true, text: 'Perfect, looking forward to it!', time: 'Mon'),
  ],
};

const List<ChatContact> _recentChats = [
  ChatContact(
    id: 'kabir',
    name: 'Kabir Malhotra',
    role: 'Singer',
    city: 'Delhi',
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    lastMsg: '🎤 Voice note (00:28)',
    time: '10:15 AM',
    unread: 1,
    statusLabel: 'Typing...',
    hasGreenDot: true,
  ),
  ChatContact(
    id: 'aaradhya',
    name: 'Aaradhya Films',
    role: 'Production House',
    city: 'Mumbai',
    textAvatar: 'AF',
    textAvatarBg: Color(0xFF1C1C1C),
    textAvatarFg: Colors.white,
    lastMsg: "We'd like to invite you for a short film audition.",
    time: 'Yesterday',
    unread: 2,
  ),
  ChatContact(
    id: 'arjun',
    name: 'Arjun Verma',
    role: 'Cinematographer',
    city: 'Pune',
    avatar: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=200',
    lastMsg: 'Sent you a portfolio link',
    time: 'Yesterday',
    unread: 0,
  ),
  ChatContact(
    id: 'meera',
    name: 'Meera Iyer',
    role: 'Writer',
    city: 'Chennai',
    avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
    lastMsg: "Thanks! I'll send the script tonight.",
    time: 'Mon',
    unread: 0,
  ),
  ChatContact(
    id: 'indie',
    name: "Indie Music Fest '25",
    role: 'Event',
    city: 'Delhi',
    textAvatar: "INDIE\nMUSIC\nFEST",
    textAvatarBg: Color(0xFF1C1C1C),
    textAvatarFg: Colors.redAccent,
    lastMsg: 'Reminder: Submissions close in 2 days!',
    time: 'Mon',
    unread: 1,
  ),
];

// ─── Main Widget ──────────────────────────────────────────────────────────────

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  String _selectedTab = 'All';
  String _selectedContactId = 'rhea';

  final List<String> _tabs = ['All', 'Unread', 'Groups', 'Requests'];

  List<ChatContact> get _pinnedChats => _storyContacts.where((c) => c.isPinned).toList();

  void _selectContact(String id) {
    setState(() {
      _selectedContactId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final bool isDesktop = w >= 1000;

    if (isDesktop) {
      return _DesktopInbox(
        selectedTab: _selectedTab,
        selectedContactId: _selectedContactId,
        tabs: _tabs,
        onTabChange: (t) => setState(() => _selectedTab = t),
        onContactSelect: _selectContact,
        pinnedChats: _pinnedChats,
        recentChats: _recentChats,
        storyContacts: _storyContacts,
      );
    }
    return _MobileInbox(
      selectedTab: _selectedTab,
      tabs: _tabs,
      onTabChange: (t) => setState(() => _selectedTab = t),
      pinnedChats: _pinnedChats,
      recentChats: _recentChats,
      storyContacts: _storyContacts,
    );
  }
}

// ─── Desktop Layout ───────────────────────────────────────────────────────────

class _DesktopInbox extends StatelessWidget {
  final String selectedTab;
  final String selectedContactId;
  final List<String> tabs;
  final ValueChanged<String> onTabChange;
  final ValueChanged<String> onContactSelect;
  final List<ChatContact> pinnedChats;
  final List<ChatContact> recentChats;
  final List<ChatContact> storyContacts;

  const _DesktopInbox({
    required this.selectedTab,
    required this.selectedContactId,
    required this.tabs,
    required this.onTabChange,
    required this.onContactSelect,
    required this.pinnedChats,
    required this.recentChats,
    required this.storyContacts,
  });

  @override
  Widget build(BuildContext context) {
    final selectedContact =
        [...storyContacts, ...recentChats].firstWhere((c) => c.id == selectedContactId, orElse: () => storyContacts.first);
    final messages = _messagesMap[selectedContactId] ?? [];

    return Scaffold(
      backgroundColor: KalaColors.ivory,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // MAIN AREA (Left + Middle)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Section spans Left and Middle
                  _DesktopTopSection(
                    storyContacts: storyContacts,
                    onContactSelect: onContactSelect,
                  ),
                  // Bottom Split (Left List and Middle Chat)
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── LEFT: Tabs + Chat List ──
                        SizedBox(
                          width: 380,
                          child: _InboxList(
                            selectedTab: selectedTab,
                            selectedContactId: selectedContactId,
                            tabs: tabs,
                            onTabChange: onTabChange,
                            onContactSelect: onContactSelect,
                            pinnedChats: pinnedChats,
                            recentChats: recentChats,
                            storyContacts: storyContacts,
                            isDesktop: true,
                          ),
                        ),
                        // Divider
                        Container(width: 1, color: const Color(0xFFEFE7D6)),
                        // ── MIDDLE: Chat pane ──
                        Expanded(
                          child: _AnimatedChatPane(
                            key: ValueKey(selectedContactId),
                            contact: selectedContact,
                            messages: messages,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Divider
            Container(width: 1, color: const Color(0xFFEFE7D6)),
            // ── RIGHT: Sidebar (280px, full height) ──
            const SizedBox(
              width: 280,
              child: _RightSidebar(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Mobile Layout ────────────────────────────────────────────────────────────

class _MobileInbox extends StatelessWidget {
  final String selectedTab;
  final List<String> tabs;
  final ValueChanged<String> onTabChange;
  final List<ChatContact> pinnedChats;
  final List<ChatContact> recentChats;
  final List<ChatContact> storyContacts;

  const _MobileInbox({
    required this.selectedTab,
    required this.tabs,
    required this.onTabChange,
    required this.pinnedChats,
    required this.recentChats,
    required this.storyContacts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KalaColors.ivory,
      body: SafeArea(
        child: _InboxList(
          selectedTab: selectedTab,
          selectedContactId: '',
          tabs: tabs,
          onTabChange: onTabChange,
          onContactSelect: (id) {
            final contact = [...storyContacts, ...recentChats].firstWhere(
              (c) => c.id == id,
              orElse: () => storyContacts.first,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatRoomScreen(
                  contact: contact,
                  messages: _messagesMap[id] ?? [],
                ),
              ),
            );
          },
          pinnedChats: pinnedChats,
          recentChats: recentChats,
          storyContacts: storyContacts,
          isDesktop: false,
        ),
      ),
    );
  }
}

// ─── Animated Chat Pane (slide-in from right + fade) ─────────────────────────

class _AnimatedChatPane extends StatefulWidget {
  final ChatContact contact;
  final List<ChatMessage> messages;

  const _AnimatedChatPane({super.key, required this.contact, required this.messages});

  @override
  State<_AnimatedChatPane> createState() => _AnimatedChatPaneState();
}

class _AnimatedChatPaneState extends State<_AnimatedChatPane> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0.06, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: _ChatPane(contact: widget.contact, messages: widget.messages),
      ),
    );
  }
}

// ─── Chat Pane ────────────────────────────────────────────────────────────────

class _ChatPane extends StatefulWidget {
  final ChatContact contact;
  final List<ChatMessage> messages;

  const _ChatPane({super.key, required this.contact, required this.messages});

  @override
  State<_ChatPane> createState() => _ChatPaneState();
}

class _ChatPaneState extends State<_ChatPane> {
  final TextEditingController _msgCtrl = TextEditingController();
  late List<ChatMessage> _msgs;
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _msgs = List.from(widget.messages);
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final t = _msgCtrl.text.trim();
    if (t.isEmpty) return;
    setState(() {
      _msgs.add(ChatMessage(isMe: true, text: t, time: 'Just now'));
    });
    _msgCtrl.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.contact;
    return Column(
      children: [
        // ── Chat Header ──
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFEFE7D6))),
          ),
          child: Row(
            children: [
              _ContactAvatar(contact: c, radius: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          c.name,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: KalaColors.charcoal,
                          ),
                        ),
                        if (c.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, size: 14, color: KalaColors.burntOrange),
                        ],
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '${c.role} • ${c.city}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: KalaColors.mediumGrey,
                      ),
                    ),
                  ],
                ),
              ),
              // Actions — plain icon buttons, no circle containers
              IconButton(
                icon: const Icon(Icons.call_outlined, size: 20, color: KalaColors.charcoal),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
              IconButton(
                icon: const Icon(Icons.videocam_outlined, size: 20, color: KalaColors.charcoal),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline, size: 20, color: KalaColors.charcoal),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
            ],
          ),
        ),

        // ── Messages ──
        Expanded(
          child: ListView.builder(
            controller: _scroll,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: _msgs.length + 1,
            itemBuilder: (ctx, i) {
              if (i == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE8E0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Today',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: KalaColors.mediumGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

        // ── Input Bar ──
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              const SizedBox(width: 10),
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
    );
  }
}

// ─── Message Bubble with Directional Tail ─────────────────────────────────────



class _MobileInboxHeaderSection extends StatelessWidget {
  final List<String> tabs;
  final String selectedTab;
  final ValueChanged<String> onTabChange;
  final ValueChanged<String> onContactSelect;
  final List<ChatContact> storyContacts;

  const _MobileInboxHeaderSection({
    required this.tabs,
    required this.selectedTab,
    required this.onTabChange,
    required this.onContactSelect,
    required this.storyContacts,
  });

  IconData _tabIcon(String tab) {
    switch (tab) {
      case 'Unread':
        return Icons.mark_chat_unread_outlined;
      case 'Groups':
        return Icons.group_outlined;
      case 'Requests':
        return Icons.person_add_outlined;
      default:
        return Icons.check_box_outline_blank; // 'All' tab
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Header ──
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 20, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Messages',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: KalaColors.charcoal,
                      ),
                    ),
                    Text(
                      'Connect. Collaborate. Create.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: KalaColors.mediumGrey,
                      ),
                    ),
                  ],
                ),
              ),
              _SquareIconBtn(icon: Icons.tune, color: KalaColors.charcoal),
              const SizedBox(width: 8),
              _SquareIconBtn(icon: Icons.edit_outlined, color: KalaColors.burntOrange),
            ],
          ),
        ),

        // ── Search Bar ──
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: KalaSearchBar(
            hintText: 'Search messages, people, groups...',
          ),
        ),
        const SizedBox(height: 16),

        // ── Story Row ──
        SizedBox(
          height: 105,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              _StoryNewGroup(),
              ...storyContacts.map((c) => _StoryAvatar(contact: c, onTap: () => onContactSelect(c.id))),
              _StoryMoreBtn(),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // ── Tab Filters ──
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: tabs.map((tab) {
              final isSelected = tab == selectedTab;
              final badge = tab == 'Unread' ? '6' : null;
              return GestureDetector(
                onTap: () => onTabChange(tab),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFDE8DC) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _tabIcon(tab),
                        size: 13,
                        color: isSelected ? KalaColors.burntOrange : KalaColors.charcoal,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        tab,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? KalaColors.burntOrange : KalaColors.charcoal,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: KalaColors.burntOrange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _DesktopTopSection extends StatelessWidget {
  final List<ChatContact> storyContacts;
  final ValueChanged<String> onContactSelect;

  const _DesktopTopSection({
    required this.storyContacts,
    required this.onContactSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Header ──
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Messages',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: KalaColors.charcoal,
                    ),
                  ),
                  Text(
                    'Connect. Collaborate. Create.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: KalaColors.mediumGrey,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _SquareIconBtn(icon: Icons.tune, color: KalaColors.charcoal),
              const SizedBox(width: 8),
              _SquareIconBtn(icon: Icons.edit_outlined, color: KalaColors.burntOrange),
            ],
          ),
        ),

        // ── Search Bar ──
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: KalaSearchBar(
            hintText: 'Search messages, people, groups...',
          ),
        ),
        const SizedBox(height: 16),

        // ── Story Row ──
        SizedBox(
          height: 105,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              _StoryNewGroup(),
              ...storyContacts.map((c) => _StoryAvatar(contact: c, onTap: () => onContactSelect(c.id))),
              _StoryMoreBtn(),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _DesktopTabsSection extends StatelessWidget {
  final List<String> tabs;
  final String selectedTab;
  final ValueChanged<String> onTabChange;

  const _DesktopTabsSection({
    required this.tabs,
    required this.selectedTab,
    required this.onTabChange,
  });

  IconData _tabIcon(String tab) {
    switch (tab) {
      case 'Unread':
        return Icons.mark_chat_unread_outlined;
      case 'Groups':
        return Icons.group_outlined;
      case 'Requests':
        return Icons.person_add_outlined;
      default:
        return Icons.check_box_outline_blank; // 'All' tab
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = tab == selectedTab;
          final badge = tab == 'Unread' ? '6' : null;
          return GestureDetector(
            onTap: () => onTabChange(tab),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFDE8DC) : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _tabIcon(tab),
                    size: 13,
                    color: isSelected ? KalaColors.burntOrange : KalaColors.charcoal,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    tab,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? KalaColors.burntOrange : KalaColors.charcoal,
                    ),
                  ),
                  if (badge != null) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: KalaColors.burntOrange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Inbox List Panel ─────────────────────────────────────────────────────────

class _InboxList extends StatelessWidget {
  final String selectedTab;
  final String selectedContactId;
  final List<String> tabs;
  final ValueChanged<String> onTabChange;
  final ValueChanged<String> onContactSelect;
  final List<ChatContact> pinnedChats;
  final List<ChatContact> recentChats;
  final List<ChatContact> storyContacts;
  final bool isDesktop;

  const _InboxList({
    required this.selectedTab,
    required this.selectedContactId,
    required this.tabs,
    required this.onTabChange,
    required this.onContactSelect,
    required this.pinnedChats,
    required this.recentChats,
    required this.storyContacts,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: KalaColors.ivory,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!isDesktop)
            _MobileInboxHeaderSection(
              tabs: tabs,
              selectedTab: selectedTab,
              onTabChange: onTabChange,
              onContactSelect: onContactSelect,
              storyContacts: storyContacts,
            )
          else ...[
            _DesktopTabsSection(
              tabs: tabs,
              selectedTab: selectedTab,
              onTabChange: onTabChange,
            ),
            const SizedBox(height: 12),
          ],

          // ── Chat List ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                if (pinnedChats.isNotEmpty) ...[
                  _SectionHeader(title: 'Pinned'),
                  ...pinnedChats.map((c) => _ChatListTile(
                        contact: c,
                        isSelected: isDesktop && selectedContactId == c.id,
                        isPinned: true,
                        onTap: () => onContactSelect(c.id),
                      )),
                  const SizedBox(height: 8),
                ],
                _SectionHeader(title: 'Recent', actionLabel: 'See All', onAction: () {}),
                ...recentChats.map((c) => _ChatListTile(
                      contact: c,
                      isSelected: isDesktop && selectedContactId == c.id,
                      isPinned: false,
                      onTap: () => onContactSelect(c.id),
                    )),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }


}

// ─── Chat List Tile ───────────────────────────────────────────────────────────

class _ChatListTile extends StatelessWidget {
  final ChatContact contact;
  final bool isSelected;
  final bool isPinned;
  final VoidCallback onTap;

  const _ChatListTile({
    required this.contact,
    required this.isSelected,
    required this.isPinned,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = contact;
    final hasUnread = c.unread > 0;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFDE8DC) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            _ContactAvatar(contact: c, radius: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                c.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: KalaColors.charcoal,
                                ),
                              ),
                            ),
                            if (c.isVerified) ...[
                              const SizedBox(width: 3),
                              const Icon(Icons.verified, size: 12, color: KalaColors.burntOrange),
                            ],
                          ],
                        ),
                      ),
                      Text(
                        c.time,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: hasUnread ? KalaColors.burntOrange : KalaColors.mediumGrey,
                          fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${c.role} • ${c.city}',
                    style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          c.lastMsg,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: hasUnread ? KalaColors.charcoal : KalaColors.mediumGrey,
                            fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (hasUnread)
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: KalaColors.burntOrange,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${c.unread}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      if (isPinned) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.push_pin_outlined, size: 14, color: KalaColors.mediumGrey),
                      ],
                    ],
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

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 4, 8),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: KalaColors.charcoal,
            ),
          ),
          const Spacer(),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: KalaColors.burntOrange,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Story Widgets ────────────────────────────────────────────────────────────

class _StoryNewGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFDE8DC),
                  border: Border.all(color: const Color(0xFFFAC5A8), width: 1.5),
                ),
                child: const Icon(Icons.groups_outlined, color: KalaColors.burntOrange, size: 28),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: KalaColors.burntOrange,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.add, color: Colors.white, size: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text('New Group', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: KalaColors.charcoal)),
        ],
      ),
    );
  }
}

class _StoryAvatar extends StatelessWidget {
  final ChatContact contact;
  final VoidCallback onTap;

  const _StoryAvatar({required this.contact, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isOnline = contact.statusLabel == 'Online' || contact.statusLabel == 'Active now';
    final isTyping = contact.statusLabel == 'Typing...';
    final Color statusColor = isTyping ? Colors.orange : (isOnline ? KalaColors.accentGreen : Colors.transparent);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Stack(
              children: [
                _ContactAvatar(contact: contact, radius: 30),
                if (isOnline || isTyping)
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              contact.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: KalaColors.charcoal),
            ),
            Text(
              contact.statusLabel,
              style: GoogleFonts.inter(
                fontSize: 9,
                color: isTyping ? Colors.orange : (isOnline ? KalaColors.accentGreen : KalaColors.mediumGrey),
                fontWeight: (isOnline || isTyping) ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryMoreBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: const Color(0xFFEFE7D6)),
            ),
            child: const Icon(Icons.chevron_right, color: KalaColors.charcoal, size: 22),
          ),
          const SizedBox(height: 5),
          const SizedBox(height: 19), // spacer to align
        ],
      ),
    );
  }
}

// ─── Contact Avatar ───────────────────────────────────────────────────────────

class _ContactAvatar extends StatelessWidget {
  final ChatContact contact;
  final double radius;

  const _ContactAvatar({required this.contact, required this.radius});

  @override
  Widget build(BuildContext context) {
    if (contact.avatar != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(contact.avatar!),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: contact.textAvatarBg ?? KalaColors.charcoal,
      child: Text(
        (contact.textAvatar ?? contact.name[0]).split('\n').first,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: contact.textAvatarFg ?? Colors.white,
          fontSize: radius * 0.6,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ─── Right Sidebar ────────────────────────────────────────────────────────────

class _RightSidebar extends StatelessWidget {
  const _RightSidebar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: KalaColors.ivory,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Groups
            _SidebarSectionHeader(title: 'Groups', actionLabel: 'See All'),
            const SizedBox(height: 12),
            _buildGroupItem(
              avatar: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=100',
              name: 'Nritya Collective',
              subtitle: 'Active now',
              isActive: true,
            ),
            _buildGroupItem(
              avatar: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=100',
              name: 'Indie Creators Hub',
              subtitle: '12 members',
              badge: '8',
            ),
            _buildGroupItem(
              avatar: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=100',
              name: 'Mumbai Artists',
              subtitle: '20 members',
            ),
            _buildGroupItem(
              avatar: 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4?w=100',
              name: 'Filmmakers United',
              subtitle: '15 members',
              badge: '2',
            ),
            _buildGroupItem(
              avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
              name: 'Dance Choreographers',
              subtitle: '18 members',
            ),
            const SizedBox(height: 20),

            // Requests
            _SidebarSectionHeader(title: 'Requests', actionLabel: 'See All'),
            const SizedBox(height: 12),
            _buildRequestItem(
              avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
              name: 'Vihaan Kapoor',
              subtitle: 'Actor • Mumbai',
            ),
            _buildRequestItem(
              avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
              name: 'The Stage Co.',
              subtitle: 'Event Organizer',
            ),
            _buildRequestItem(
              avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
              name: 'Avantika Das',
              subtitle: 'Singer • Kolkata',
            ),
            const SizedBox(height: 20),

            // Find collaborators card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFDE8DC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Find collaborators',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: KalaColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Discover artists and creators who match your vibe.',
                    style: GoogleFonts.inter(fontSize: 11, color: KalaColors.mediumGrey, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: KalaColors.burntOrange),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: Text(
                        'Explore People',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: KalaColors.burntOrange,
                        ),
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

  Widget _buildGroupItem({
    required String avatar,
    required String name,
    required String subtitle,
    bool isActive = false,
    String? badge,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(radius: 18, backgroundImage: NetworkImage(avatar)),
              if (isActive)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: KalaColors.accentGreen,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: KalaColors.charcoal)),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: isActive ? KalaColors.accentGreen : KalaColors.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: KalaColors.burntOrange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _buildRequestItem({
    required String avatar,
    required String name,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(radius: 18, backgroundImage: NetworkImage(avatar)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: KalaColors.charcoal)),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 10, color: KalaColors.mediumGrey)),
              ],
            ),
          ),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: KalaColors.accentGreen, width: 1.5),
            ),
            child: const Icon(Icons.check, size: 14, color: KalaColors.accentGreen),
          ),
          const SizedBox(width: 6),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: KalaColors.mediumGrey, width: 1.5),
            ),
            child: const Icon(Icons.close, size: 14, color: KalaColors.mediumGrey),
          ),
        ],
      ),
    );
  }
}

class _SidebarSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;

  const _SidebarSectionHeader({required this.title, this.actionLabel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: KalaColors.charcoal),
        ),
        const Spacer(),
        if (actionLabel != null)
          Text(
            actionLabel!,
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: KalaColors.burntOrange),
          ),
      ],
    );
  }
}

// ─── Small Helpers ────────────────────────────────────────────────────────────

class _SquareIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _SquareIconBtn({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEFE7D6)),
      ),
      child: Icon(icon, size: 18, color: color),
    );
  }
}
