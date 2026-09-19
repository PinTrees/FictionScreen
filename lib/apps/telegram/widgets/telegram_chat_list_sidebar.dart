import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/telegram_model.dart';

/// 텔레그램 데스크톱 좌측 채팅방 목록 및 폴더 사이드바
class TelegramChatListSidebar extends StatefulWidget {
  final TelegramConfig config;
  final Function(String chatId) onChatSelected;
  final Function(String folder) onFolderChanged;
  final VoidCallback onOpenMenu;

  const TelegramChatListSidebar({
    super.key,
    required this.config,
    required this.onChatSelected,
    required this.onFolderChanged,
    required this.onOpenMenu,
  });

  @override
  State<TelegramChatListSidebar> createState() => _TelegramChatListSidebarState();
}

class _TelegramChatListSidebarState extends State<TelegramChatListSidebar> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _folders = [
    {'id': 'all', 'title': 'All Chats'},
    {'id': 'crypto', 'title': 'Crypto 🚀'},
    {'id': 'channels', 'title': 'Channels 📢'},
    {'id': 'direct', 'title': 'Direct 💬'},
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 폴더 필터링 및 검색 필터링
    final filteredChats = widget.config.chats.where((chat) {
      if (widget.config.activeFolder != 'all' && chat.folder != widget.config.activeFolder) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        return chat.title.toLowerCase().contains(_searchQuery.toLowerCase());
      }
      return true;
    }).toList();

    return Container(
      width: 310,
      decoration: const BoxDecoration(
        color: Color(0xFF17212B), // Telegram Desktop Dark Sidebar
        border: Border(
          right: BorderSide(color: Color(0xFF0E1621), width: 1),
        ),
      ),
      child: Column(
        children: [
          // 1. 상단 햄버거 메뉴 및 검색바
          _buildTopSearchBar(),

          // 2. 폴더 탭 (All / Crypto / Channels / Direct)
          _buildFolderTabs(),

          // 3. 채팅방 목록 리스트뷰
          Expanded(
            child: filteredChats.isEmpty
                ? const Center(
                    child: Text(
                      'No chats found',
                      style: TextStyle(color: Colors.white38, fontSize: 13),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredChats.length,
                    itemBuilder: (context, idx) {
                      final chat = filteredChats[idx];
                      final isSelected = chat.id == widget.config.selectedChatId;

                      return _buildChatTile(chat, isSelected);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(CupertinoIcons.bars, size: 20, color: Color(0xFF7E8C9A)),
            onPressed: widget.onOpenMenu,
            tooltip: 'Menu',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF242F3D),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _searchCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Color(0xFF7E8C9A), fontSize: 13),
                  prefixIcon: Icon(CupertinoIcons.search, size: 16, color: Color(0xFF7E8C9A)),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderTabs() {
    return Container(
      height: 36,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF0E1621))),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _folders.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, idx) {
          final folder = _folders[idx];
          final isActive = widget.config.activeFolder == folder['id'];

          return InkWell(
            onTap: () => widget.onFolderChanged(folder['id']!),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive ? const Color(0xFF5288C1) : Colors.transparent,
                    width: 2.5,
                  ),
                ),
              ),
              child: Text(
                folder['title']!,
                style: TextStyle(
                  color: isActive ? const Color(0xFF5288C1) : const Color(0xFF7E8C9A),
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChatTile(TelegramChat chat, bool isSelected) {
    final lastMsg = chat.messages.isNotEmpty ? chat.messages.last : null;
    final isOnline = chat.subtitle.toLowerCase().contains('online');

    return InkWell(
      onTap: () => widget.onChatSelected(chat.id),
      child: Container(
        color: isSelected ? const Color(0xFF2B5278) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Row(
          children: [
            // 아바타 원형
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: chat.avatarColor,
                  child: Text(
                    chat.title.isNotEmpty ? chat.title.characters.first : 'T',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4ADE80),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? const Color(0xFF2B5278) : const Color(0xFF17212B),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // 채팅방 정보 (제목, 마지막 메시지, 시간, 배지)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // 제목
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                chat.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.5,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // 텔레그램 공식 블루 체크 배지
                            if (chat.isVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                CupertinoIcons.checkmark_seal_fill,
                                size: 14,
                                color: Color(0xFF5288C1),
                              ),
                            ],
                          ],
                        ),
                      ),
                      // 시간
                      Text(
                        chat.time,
                        style: TextStyle(
                          color: isSelected ? Colors.white70 : const Color(0xFF7E8C9A),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  Row(
                    children: [
                      // 마지막 메시지 요약
                      Expanded(
                        child: Text(
                          lastMsg != null ? lastMsg.text.replaceAll('\n', ' ') : 'No messages',
                          style: TextStyle(
                            color: isSelected ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF7E8C9A),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // 핀 아이콘
                      if (chat.isPinned) ...[
                        const SizedBox(width: 6),
                        Icon(
                          CupertinoIcons.pin_fill,
                          size: 13,
                          color: isSelected ? Colors.white70 : const Color(0xFF7E8C9A),
                        ),
                      ],
                      // 안 읽은 메시지 캡슐 배지
                      if (chat.unreadCount > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : const Color(0xFF5288C1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            chat.unreadCount > 999 ? '999+' : '${chat.unreadCount}',
                            style: TextStyle(
                              color: isSelected ? const Color(0xFF2B5278) : Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
