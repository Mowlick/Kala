import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/kala_colors.dart';
import 'chat_room_screen.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final List<String> _tabs = ['All', 'Unread', 'Groups', 'Requests'];
  String _selectedTab = 'All';
  Map<String, dynamic>? _selectedChat;

  final List<Map<String, dynamic>> _activeCreators = [
    {
      'name': 'Rhea Sharma',
      'status': 'Online',
      'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
    },
    {
      'name': 'Kabir Malhotra',
      'status': 'Typing...',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
    },
    {
      'name': 'Nritya Collective',
      'status': 'Active now',
      'avatar': 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
    },
    {
      'name': 'Arjun Verma',
      'status': 'Last seen 5m ago',
      'avatar': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
    },
  ];

  final List<Map<String, dynamic>> _pinnedChats = [
    {
      'name': 'Rhea Sharma',
      'role': 'Director',
      'city': 'Mumbai',
      'lastMsg': 'Loved your latest reel! Let\'s talk about...',
      'time': '9:32 AM',
      'unread': 2,
      'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
    },
    {
      'name': 'Nritya Collective',
      'role': 'Dance Group',
      'city': 'Bangalore',
      'lastMsg': 'Practice schedule for this weekend ✨',
      'time': 'Yesterday',
      'unread': 4,
      'avatar': 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
    },
  ];

  final List<Map<String, dynamic>> _recentChats = [
    {
      'name': 'Kabir Malhotra',
      'role': 'Singer',
      'city': 'Delhi',
      'lastMsg': '🎤 Voice note (00:28)',
      'time': '10:15 AM',
      'unread': 1,
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
    },
    {
      'name': 'Aaradhya Films',
      'role': 'Production House',
      'city': 'Mumbai',
      'lastMsg': 'We\'d like to invite you for a short film audition.',
      'time': 'Yesterday',
      'unread': 2,
      'avatar': 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4',
    },
    {
      'name': 'Arjun Verma',
      'role': 'Cinematographer',
      'city': 'Pune',
      'lastMsg': 'Sent you a portfolio link',
      'time': 'Yesterday',
      'unread': 0,
      'avatar': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
    },
    {
      'name': 'Meera Iyer',
      'role': 'Writer',
      'city': 'Chennai',
      'lastMsg': 'Thanks! I\'ll send the script tonight.',
      'time': 'Mon',
      'unread': 0,
      'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
    },
    {
      'name': 'Indie Music Fest \'25',
      'role': 'Event',
      'city': 'Delhi',
      'lastMsg': 'Reminder: Submissions close in 2 days!',
      'time': 'Mon',
      'unread': 1,
      'avatar': 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isLaptop = MediaQuery.of(context).size.width >= 1000;

    if (isLaptop) {
      if (_selectedChat == null && _pinnedChats.isNotEmpty) {
        _selectedChat = _pinnedChats[0];
      }
      return Scaffold(
        backgroundColor: KalaColors.ivory,
        body: SafeArea(
          child: Row(
            children: [
              Container(
                width: 380,
                color: KalaColors.ivory,
                child: _buildInboxList(context, isLaptop: true),
              ),
              Container(width: 0.5, color: const Color(0xFFEAE2B7)),
              Expanded(
                child: _selectedChat != null
                    ? ChatRoomScreen(chat: _selectedChat)
                    : const Center(child: Text('Select a chat to start messaging')),
              ),
              Container(width: 0.5, color: const Color(0xFFEAE2B7)),
              _buildRightSidebar(context),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: KalaColors.ivory,
      body: SafeArea(
        child: _buildInboxList(context, isLaptop: false),
      ),
    );
  }

  Widget _buildRightSidebar(BuildContext context) {
    return Container(
      width: 320,
      color: KalaColors.ivory,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Groups Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Groups',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: KalaColors.charcoal,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: KalaColors.burntOrange,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildGroupItem(
              name: 'Nritya Collective',
              subtitle: 'Active now',
              avatar: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad',
              isActive: true,
            ),
            _buildGroupItem(
              name: 'Indie Creators Hub',
              subtitle: '12 members',
              avatar: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
              unreadCount: 3,
            ),
            _buildGroupItem(
              name: 'Mumbai Artists',
              subtitle: '20 members',
              avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
            ),
            _buildGroupItem(
              name: 'Filmmakers United',
              subtitle: '15 members',
              avatar: 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4',
              unreadCount: 2,
            ),
            _buildGroupItem(
              name: 'Dance Choreographers',
              subtitle: '18 members',
              avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
            ),

            const SizedBox(height: 28),

            // 2. Requests Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Requests',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: KalaColors.charcoal,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: KalaColors.burntOrange,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildRequestItem(
              name: 'Vihaan Kapoor',
              role: 'Actor • Mumbai',
              avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
            ),
            _buildRequestItem(
              name: 'The Stage Co.',
              role: 'Event Organizer',
              avatar: 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
            ),
            _buildRequestItem(
              name: 'Avantika Das',
              role: 'Singer • Kolkata',
              avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
            ),

            const SizedBox(height: 28),

            // 3. Find Collaborators Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFBEADB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: KalaColors.softBeige),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find collaborators',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Discover artists and creators who match your vibe.',
                          style: TextStyle(
                            fontSize: 9,
                            color: KalaColors.charcoal.withValues(alpha: 0.6),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: KalaColors.burntOrange,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Explore People',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 60,
                    height: 50,
                    child: Stack(
                      children: [
                        Positioned(
                          right: 0,
                          top: 10,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb'),
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Positioned(
                          right: 15,
                          top: 0,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d'),
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Positioned(
                          right: 30,
                          top: 15,
                          child: const Icon(Icons.search, size: 14, color: KalaColors.burntOrange),
                        ),
                      ],
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
    required String name,
    required String subtitle,
    required String avatar,
    bool isActive = false,
    int? unreadCount,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(avatar),
            radius: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: KalaColors.charcoal,
                      ),
                    ),
                    if (isActive) ...[
                      const SizedBox(width: 6),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: KalaColors.accentGreen,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 9,
                    color: isActive ? KalaColors.accentGreen : KalaColors.mediumGrey,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          if (unreadCount != null)
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: KalaColors.burntOrange,
              ),
              child: Text(
                '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRequestItem({
    required String name,
    required String role,
    required String avatar,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(avatar),
            radius: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: KalaColors.charcoal,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: const TextStyle(
                    fontSize: 9,
                    color: KalaColors.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFF2EC),
                  border: Border.all(color: const Color(0xFFFED7C3)),
                ),
                child: const Center(
                  child: Icon(Icons.check, size: 12, color: KalaColors.burntOrange),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: KalaColors.softBeige),
                ),
                child: const Center(
                  child: Icon(Icons.close, size: 12, color: KalaColors.charcoal),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInboxList(BuildContext context, {required bool isLaptop}) {
    return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Header (Title + Filters + Edit)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Messages',
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Connect. Collaborate. Create.',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                    const Spacer(),
                    _buildCircularButton(Icons.tune),
                    const SizedBox(width: 12),
                    _buildCircularButton(Icons.edit_note_outlined),
                  ],
                ),
              ),

              // 2. Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search messages, people, groups...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: KalaColors.mediumGrey,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: KalaColors.softBeige),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: KalaColors.softBeige),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 3. Active Creators Horizontal Row
              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // New Group Option
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: KalaColors.softBeige,
                                  border: Border.all(
                                    color: KalaColors.softBeige,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.group_add_outlined,
                                  color: KalaColors.burntOrange,
                                  size: 28,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: KalaColors.burntOrange,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Text(
                                    '3',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'New Group',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Active Users List
                    ..._activeCreators.map((creator) {
                      final name = creator['name'] as String;
                      final status = creator['status'] as String;
                      final avatar = creator['avatar'] as String;
                      final isTyping = status == 'Typing...';
                      final isOnline =
                          status == 'Online' || status == 'Active now';

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(avatar),
                                  radius: 34,
                                ),
                                if (isOnline || isTyping)
                                  Positioned(
                                    bottom: 2,
                                    right: 2,
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: isTyping
                                            ? Colors.orange
                                            : KalaColors.accentGreen,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              name.split(' ')[0],
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              status,
                              style: TextStyle(
                                fontSize: 8,
                                color: isTyping
                                    ? Colors.orange
                                    : (isOnline
                                          ? KalaColors.accentGreen
                                          : KalaColors.mediumGrey),
                                fontWeight: (isOnline || isTyping)
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // 4. Tab filters
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _tabs.map((tab) {
                      final isSelected = _selectedTab == tab;

                      IconData tabIcon;
                      switch (tab) {
                        case 'Unread':
                          tabIcon = Icons.mark_chat_unread_outlined;
                          break;
                        case 'Groups':
                          tabIcon = Icons.group_outlined;
                          break;
                        case 'Requests':
                          tabIcon = Icons.person_add_outlined;
                          break;
                        default:
                          tabIcon = Icons.chat_bubble_outline;
                      }

                      Widget labelWidget;
                      if (tab == 'Unread') {
                        labelWidget = Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              tabIcon,
                              size: 14,
                              color: isSelected ? KalaColors.burntOrange : KalaColors.charcoal,
                            ),
                            const SizedBox(width: 6),
                            Text(tab),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: KalaColors.burntOrange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                '5',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        labelWidget = Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              tabIcon,
                              size: 14,
                              color: isSelected ? KalaColors.burntOrange : KalaColors.charcoal,
                            ),
                            const SizedBox(width: 6),
                            Text(tab),
                          ],
                        );
                      }

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTab = tab;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? KalaColors.softBeige
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: DefaultTextStyle(
                            style: TextStyle(
                              color: isSelected
                                  ? KalaColors.burntOrange
                                  : KalaColors.charcoal,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: 12,
                            ),
                            child: labelWidget,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 5. Pinned Chats Section
              if (_selectedTab == 'All' || _selectedTab == 'Unread' || _selectedTab == 'Groups') ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Text(
                    'Pinned',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: KalaColors.charcoal,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: _pinnedChats
                        .where((chat) {
                          if (_selectedTab == 'Unread') return (chat['unread'] as int) > 0;
                          if (_selectedTab == 'Groups') return chat['role'].toString().contains('Group');
                          return true;
                        })
                        .map((chat) => _buildChatItem(context, chat, isPinned: true, isLaptop: isLaptop))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // 6. Recent Chats Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: KalaColors.charcoal,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          color: KalaColors.burntOrange,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: _recentChats
                      .where((chat) {
                        if (_selectedTab == 'Unread') return (chat['unread'] as int) > 0;
                        if (_selectedTab == 'Groups') return chat['role'].toString().contains('Group') || chat['role'].toString().contains('Event');
                        if (_selectedTab == 'Requests') return false;
                        return true;
                      })
                      .map((chat) => _buildChatItem(context, chat, isPinned: false, isLaptop: isLaptop))
                      .toList(),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
  }

  Widget _buildCircularButton(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: KalaColors.softBeige),
      ),
      child: Center(child: Icon(icon, color: KalaColors.charcoal, size: 20)),
    );
  }

  Widget _buildChatItem(
    BuildContext context,
    Map<String, dynamic> chat, {
    required bool isPinned,
    required bool isLaptop,
  }) {
    final bool isSelected = isLaptop && _selectedChat != null && _selectedChat!['name'] == chat['name'];

    final unread = chat['unread'] as int;
    final hasUnread = unread > 0;

    return GestureDetector(
      onTap: () {
        if (isLaptop) {
          setState(() {
            _selectedChat = chat;
          });
        } else {
          Navigator.pushNamed(context, '/chat-room', arguments: chat);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFDF0E9) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFFFED7C3) : KalaColors.softBeige),
        ),
        child: Row(
          children: [
            // User Avatar
            CircleAvatar(
              backgroundImage: NetworkImage(chat['avatar'] as String),
              radius: 26,
            ),
            const SizedBox(width: 14),
            // Message Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          chat['name'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${chat['role']} • ${chat['city']}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: KalaColors.mediumGrey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    chat['lastMsg'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: hasUnread
                          ? KalaColors.charcoal
                          : KalaColors.mediumGrey,
                      fontWeight: hasUnread
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Status and Badges
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat['time'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    color: hasUnread
                        ? KalaColors.burntOrange
                        : KalaColors.mediumGrey,
                    fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (isPinned)
                      const Icon(
                        Icons.push_pin,
                        color: KalaColors.burntOrange,
                        size: 14,
                      ),
                    if (isPinned && hasUnread) const SizedBox(width: 6),
                    if (hasUnread)
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: KalaColors.burntOrange,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$unread',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
