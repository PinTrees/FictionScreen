import 'package:flutter/material.dart';

/// 텔레그램 이모지 리액션 모델
class TelegramReaction {
  final String emoji;
  int count;
  bool isSelected;

  TelegramReaction({
    required this.emoji,
    required this.count,
    this.isSelected = false,
  });

  TelegramReaction copyWith({
    String? emoji,
    int? count,
    bool? isSelected,
  }) {
    return TelegramReaction(
      emoji: emoji ?? this.emoji,
      count: count ?? this.count,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

/// 텔레그램 단일 메시지 모델
class TelegramMessage {
  final String id;
  final String senderName;
  final bool isMe;
  final String text;
  final String time;
  final bool isRead;
  final String? views;
  final bool isChannelPost;
  final List<TelegramReaction> reactions;
  final String? imageUrl;
  final String? replyTo;
  final bool isPinned;

  TelegramMessage({
    required this.id,
    required this.senderName,
    required this.isMe,
    required this.text,
    required this.time,
    this.isRead = true,
    this.views,
    this.isChannelPost = false,
    List<TelegramReaction>? reactions,
    this.imageUrl,
    this.replyTo,
    this.isPinned = false,
  }) : reactions = reactions ?? [];

  TelegramMessage copyWith({
    String? id,
    String? senderName,
    bool? isMe,
    String? text,
    String? time,
    bool? isRead,
    String? views,
    bool? isChannelPost,
    List<TelegramReaction>? reactions,
    String? imageUrl,
    String? replyTo,
    bool? isPinned,
  }) {
    return TelegramMessage(
      id: id ?? this.id,
      senderName: senderName ?? this.senderName,
      isMe: isMe ?? this.isMe,
      text: text ?? this.text,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      views: views ?? this.views,
      isChannelPost: isChannelPost ?? this.isChannelPost,
      reactions: reactions ?? this.reactions.map((r) => r.copyWith()).toList(),
      imageUrl: imageUrl ?? this.imageUrl,
      replyTo: replyTo ?? this.replyTo,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}

/// 텔레그램 채팅방 / 채널 모델
class TelegramChat {
  final String id;
  String title;
  String subtitle; // 예: "142,500 subscribers" 또는 "online"
  bool isChannel;
  bool isVerified;
  bool isMuted;
  bool isPinned;
  String? avatarAsset;
  Color avatarColor;
  int unreadCount;
  String time;
  String folder; // 'all', 'channels', 'crypto', 'direct', 'bots'
  List<TelegramMessage> messages;

  TelegramChat({
    required this.id,
    required this.title,
    required this.subtitle,
    this.isChannel = false,
    this.isVerified = false,
    this.isMuted = false,
    this.isPinned = false,
    this.avatarAsset,
    this.avatarColor = const Color(0xFF2B5278),
    this.unreadCount = 0,
    required this.time,
    this.folder = 'all',
    required this.messages,
  });

  TelegramChat copyWith({
    String? id,
    String? title,
    String? subtitle,
    bool? isChannel,
    bool? isVerified,
    bool? isMuted,
    bool? isPinned,
    String? avatarAsset,
    Color? avatarColor,
    int? unreadCount,
    String? time,
    String? folder,
    List<TelegramMessage>? messages,
  }) {
    return TelegramChat(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isChannel: isChannel ?? this.isChannel,
      isVerified: isVerified ?? this.isVerified,
      isMuted: isMuted ?? this.isMuted,
      isPinned: isPinned ?? this.isPinned,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      avatarColor: avatarColor ?? this.avatarColor,
      unreadCount: unreadCount ?? this.unreadCount,
      time: time ?? this.time,
      folder: folder ?? this.folder,
      messages: messages ?? this.messages.map((m) => m.copyWith()).toList(),
    );
  }
}

/// 텔레그램 전체 설정 및 프리셋
class TelegramConfig {
  String activeFolder;
  String selectedChatId;
  List<TelegramChat> chats;
  bool isDarkMode;

  TelegramConfig({
    this.activeFolder = 'all',
    this.selectedChatId = 'crypto_whale',
    required this.chats,
    this.isDarkMode = true,
  });

  TelegramChat get selectedChat {
    return chats.firstWhere(
      (c) => c.id == selectedChatId,
      orElse: () => chats.first,
    );
  }

  TelegramConfig copyWith({
    String? activeFolder,
    String? selectedChatId,
    List<TelegramChat>? chats,
    bool? isDarkMode,
  }) {
    return TelegramConfig(
      activeFolder: activeFolder ?? this.activeFolder,
      selectedChatId: selectedChatId ?? this.selectedChatId,
      chats: chats ?? this.chats.map((c) => c.copyWith()).toList(),
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  /// 고퀄리티 텔레그램 시그니처 4종 프리셋
  static TelegramConfig defaultPreset() {
    return TelegramConfig(
      activeFolder: 'all',
      selectedChatId: 'crypto_whale',
      isDarkMode: true,
      chats: [
        // 1. 코인/주식 VIP 시그널 채널
        TelegramChat(
          id: 'crypto_whale',
          title: 'Whale Crypto Signals 🚀',
          subtitle: '184,200 subscribers',
          isChannel: true,
          isVerified: true,
          isPinned: true,
          avatarColor: const Color(0xFF0284C7),
          unreadCount: 42,
          time: '15:42',
          folder: 'crypto',
          messages: [
            TelegramMessage(
              id: 'm1',
              senderName: 'Whale Crypto Signals 🚀',
              isMe: false,
              text: '🚨 [URGENT BREAKING ALERT] 🚨\n\nBitcoin just smashed through the psychological resistance level! 📈\nOn-chain metrics show massive institutional inflows over the last 4 hours.\n\nKey Targets for Next 48h:\n🎯 Target 1: \$108,500\n🎯 Target 2: \$115,000\n🛑 Stop Loss: \$94,200\n\nPrepare your spot & leverage positions. Next 100x Altcoin hidden gem dropping tonight at 21:00 UTC! 🔥💎',
              time: '15:20',
              isChannelPost: true,
              views: '142.5K',
              reactions: [
                TelegramReaction(emoji: '🔥', count: 2840, isSelected: true),
                TelegramReaction(emoji: '🚀', count: 1950),
                TelegramReaction(emoji: '🤑', count: 830),
                TelegramReaction(emoji: '👍', count: 1240),
              ],
            ),
            TelegramMessage(
              id: 'm2',
              senderName: 'Whale Crypto Signals 🚀',
              isMe: false,
              text: '📊 Whale Wallet Alert: Unknown wallet transferred 15,000 BTC (\$1.5B USD) from Coinbase to Cold Storage. Accumulation phase confirmed. Do not get shaken out by minor volatility! 🛡️',
              time: '15:38',
              isChannelPost: true,
              views: '98.3K',
              reactions: [
                TelegramReaction(emoji: '🚀', count: 1540),
                TelegramReaction(emoji: '❤️', count: 720),
              ],
            ),
            TelegramMessage(
              id: 'm3',
              senderName: 'Whale Crypto Signals 🚀',
              isMe: false,
              text: '⚡ [POLL] Where will BTC close this week?\n\n🟢 Above \$110,000 (78%)\n🔴 Below \$100,000 (22%)\n\nVote now and turn on notifications so you do not miss the gem call! 🔔',
              time: '15:42',
              isChannelPost: true,
              views: '65.1K',
              reactions: [
                TelegramReaction(emoji: '🔥', count: 3200),
                TelegramReaction(emoji: '🎉', count: 410),
              ],
            ),
          ],
        ),

        // 2. 첩보 & 다크웹 비밀 채널
        TelegramChat(
          id: 'shadow_protocol',
          title: 'Shadow Protocol 🕵️',
          subtitle: '42,100 subscribers',
          isChannel: true,
          isVerified: false,
          isPinned: true,
          avatarColor: const Color(0xFF1E293B),
          unreadCount: 7,
          time: '14:15',
          folder: 'channels',
          messages: [
            TelegramMessage(
              id: 'sp1',
              senderName: 'Operator 00',
              isMe: false,
              text: '🔒 [ENCRYPTED TRANSMISSION]\n\nTarget database dump complete. Decryption key: 0x8F9aC204B... Seed phrase verified.\n\nAll logs will be permanently wiped in 24 hours. Mirror link available on Tor hidden service.',
              time: '14:10',
              isChannelPost: true,
              views: '38.4K',
              reactions: [
                TelegramReaction(emoji: '⚡', count: 890),
                TelegramReaction(emoji: '👀', count: 640),
              ],
            ),
            TelegramMessage(
              id: 'sp2',
              senderName: 'Operator 00',
              isMe: false,
              text: 'System heartbeat: Normal. Zero-day vulnerability patched. Standby for next dispatch.',
              time: '14:15',
              isChannelPost: true,
              views: '22.1K',
              reactions: [
                TelegramReaction(emoji: '🤝', count: 410),
              ],
            ),
          ],
        ),

        // 3. 글로벌 속보 채널
        TelegramChat(
          id: 'breaking_news',
          title: 'Breaking Global News ⚡',
          subtitle: '310,000 subscribers',
          isChannel: true,
          isVerified: true,
          isPinned: false,
          avatarColor: const Color(0xFFDC2626),
          unreadCount: 0,
          time: '12:30',
          folder: 'channels',
          messages: [
            TelegramMessage(
              id: 'bn1',
              senderName: 'Breaking Global News ⚡',
              isMe: false,
              text: '⚡ [JUST IN] Global tech consortium announces commercial deployment of room-temperature quantum computing chip. Stock futures surge across Asia and Europe markets.',
              time: '12:30',
              isChannelPost: true,
              views: '210.4K',
              reactions: [
                TelegramReaction(emoji: '👏', count: 4200),
                TelegramReaction(emoji: '😱', count: 1890),
              ],
            ),
          ],
        ),

        // 4. 1:1 비밀 대화방
        TelegramChat(
          id: 'secret_chat',
          title: 'Elena Rostova 🔒',
          subtitle: 'online',
          isChannel: false,
          isVerified: false,
          isPinned: false,
          avatarColor: const Color(0xFF9333EA),
          unreadCount: 0,
          time: '11:05',
          folder: 'direct',
          messages: [
            TelegramMessage(
              id: 'sc1',
              senderName: 'Elena Rostova',
              isMe: false,
              text: 'Hey! Did you review the contract draft I sent earlier?',
              time: '10:58',
              isRead: true,
            ),
            TelegramMessage(
              id: 'sc2',
              senderName: '나',
              isMe: true,
              text: 'Yes, just reviewed clause 5. Everything looks solid, I will sign the PDF copy right away.',
              time: '11:02',
              isRead: true,
            ),
            TelegramMessage(
              id: 'sc3',
              senderName: 'Elena Rostova',
              isMe: false,
              text: 'Perfect! Looking forward to closing this deal today. 🎉',
              time: '11:05',
              isRead: true,
              reactions: [
                TelegramReaction(emoji: '❤️', count: 1, isSelected: true),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
