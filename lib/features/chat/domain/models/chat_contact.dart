import 'package:flutter/material.dart';

class ChatContact {
  final String id;
  final String name;
  final String role;
  final String city;
  final String? avatar;
  final String? textAvatar;
  final Color? textAvatarBg;
  final Color? textAvatarFg;
  final String lastMsg;
  final String time;
  final int unread;
  final bool isPinned;
  final bool isVerified;
  final String statusLabel;
  final bool hasGreenDot;

  const ChatContact({
    required this.id,
    required this.name,
    required this.role,
    required this.city,
    this.avatar,
    this.textAvatar,
    this.textAvatarBg,
    this.textAvatarFg,
    required this.lastMsg,
    required this.time,
    required this.unread,
    this.isPinned = false,
    this.isVerified = false,
    this.statusLabel = '',
    this.hasGreenDot = false,
  });
}
