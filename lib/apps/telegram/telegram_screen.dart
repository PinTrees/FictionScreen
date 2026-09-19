import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data/telegram_model.dart';
import 'widgets/telegram_chat_list_sidebar.dart';
import 'widgets/telegram_chat_view.dart';
import 'widgets/telegram_edit_dialog.dart';

/// 텔레그램 스크린 (반응형: 데스크톱 2단 UI vs 모바일 단일 UI)
class TelegramScreen extends StatefulWidget {
  final TelegramConfig config;
  final ValueChanged<TelegramConfig>? onConfigChanged;

  const TelegramScreen({
    super.key,
    required this.config,
    this.onConfigChanged,
  });

  @override
  State<TelegramScreen> createState() => _TelegramScreenState();
}

class _TelegramScreenState extends State<TelegramScreen> {
  late TelegramConfig _config;
  bool _mobileShowChat = true;

  @override
  void initState() {
    super.initState();
    _config = widget.config.copyWith();
  }

  @override
  void didUpdateWidget(covariant TelegramScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      _config = widget.config.copyWith();
    }
  }

  void _notifyChange() {
    widget.onConfigChanged?.call(_config);
  }

  void _openEditDialog() {
    showDialog(
      context: context,
      builder: (ctx) => TelegramEditDialog(
        config: _config,
        onSave: (updated) {
          setState(() => _config = updated);
          _notifyChange();
        },
      ),
    );
  }

  void _handleSendMessage(String text, bool isMe) {
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final activeChat = _config.selectedChat;

    final newMsg = TelegramMessage(
      id: 'm_${DateTime.now().millisecondsSinceEpoch}',
      senderName: isMe ? '나' : activeChat.title,
      isMe: isMe,
      text: text,
      time: timeStr,
      isChannelPost: activeChat.isChannel,
      views: activeChat.isChannel ? '1.2K' : null,
      reactions: activeChat.isChannel
          ? [TelegramReaction(emoji: '🔥', count: 1)]
          : [],
    );

    setState(() {
      activeChat.messages.add(newMsg);
      activeChat.time = timeStr;
    });
    _notifyChange();
  }

  void _handleToggleReaction(TelegramMessage msg, String emoji) {
    setState(() {
      final existing = msg.reactions.firstWhere(
        (r) => r.emoji == emoji,
        orElse: () => TelegramReaction(emoji: emoji, count: 0),
      );

      if (!msg.reactions.contains(existing)) {
        msg.reactions.add(TelegramReaction(emoji: emoji, count: 1, isSelected: true));
      } else {
        if (existing.isSelected) {
          existing.count--;
          existing.isSelected = false;
        } else {
          existing.count++;
          existing.isSelected = true;
        }
      }
    });
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 680;

        if (isDesktop) {
          // 데스크톱 2단 분할 뷰
          return Scaffold(
            backgroundColor: const Color(0xFF0E1621),
            body: Row(
              children: [
                TelegramChatListSidebar(
                  config: _config,
                  onChatSelected: (chatId) {
                    setState(() => _config.selectedChatId = chatId);
                    _notifyChange();
                  },
                  onFolderChanged: (folder) {
                    setState(() => _config.activeFolder = folder);
                    _notifyChange();
                  },
                  onOpenMenu: _openEditDialog,
                ),
                Expanded(
                  child: TelegramChatView(
                    chat: _config.selectedChat,
                    onOpenEditDialog: _openEditDialog,
                    onSendMessage: _handleSendMessage,
                    onToggleReaction: _handleToggleReaction,
                  ),
                ),
              ],
            ),
          );
        }

        // 모바일 단일 컬럼 뷰
        return Scaffold(
          backgroundColor: const Color(0xFF0E1621),
          body: _mobileShowChat
              ? Stack(
                  children: [
                    TelegramChatView(
                      chat: _config.selectedChat,
                      onOpenEditDialog: _openEditDialog,
                      onSendMessage: _handleSendMessage,
                      onToggleReaction: _handleToggleReaction,
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: IconButton(
                        icon: const Icon(CupertinoIcons.back, color: Colors.white),
                        onPressed: () => setState(() => _mobileShowChat = false),
                      ),
                    ),
                  ],
                )
              : TelegramChatListSidebar(
                  config: _config,
                  onChatSelected: (chatId) {
                    setState(() {
                      _config.selectedChatId = chatId;
                      _mobileShowChat = true;
                    });
                    _notifyChange();
                  },
                  onFolderChanged: (folder) {
                    setState(() => _config.activeFolder = folder);
                    _notifyChange();
                  },
                  onOpenMenu: _openEditDialog,
                ),
        );
      },
    );
  }
}
