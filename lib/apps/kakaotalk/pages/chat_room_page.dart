import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../style/app_colors.dart';
import '../data/kakaotalk_model.dart';

class ChatRoomPage extends StatelessWidget {
  final KakaoRoomConfig config;
  final VoidCallback onBackToChatList;
  final String? selectedElementId;
  final ValueChanged<String>? onSelectElement;

  const ChatRoomPage({
    super.key,
    required this.config,
    required this.onBackToChatList,
    this.selectedElementId,
    this.onSelectElement,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = config.customBgColor ??
        (config.isDarkTheme ? AppColors.kakaoDarkBg : AppColors.kakaoChatBg);
    final textColor = config.isDarkTheme ? Colors.white : Colors.black;

    return Container(
      color: bgColor,
      child: Column(
        children: [
          // 1. 상태바
          _buildStatusBar(textColor),

          // 2. 상단 네비바
          _buildTopBar(textColor),

          // 2.5 상단 공지사항 배너 (활성화 시)
          if (config.showNotice) _buildNoticeBanner(textColor),

          // 3. 날짜
          _buildDateDivider(),

          // 4. 대화 메시지 리스트
          Expanded(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              itemCount: config.messages.length,
              itemBuilder: (context, index) {
                final msg = config.messages[index];
                return _buildMessageRow(msg);
              },
            ),
          ),

          // 5. 하단 입력창
          _buildBottomInputBar(),
        ],
      ),
    );
  }

  Widget _buildStatusBar(Color textColor) {
    final isSelected = selectedElementId == 'statusbar';

    return GestureDetector(
      onTap: () => onSelectElement?.call('statusbar'),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1).withValues(alpha: 0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              config.statusBarTime,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Pretendard',
              ),
            ),
            Row(
              children: [
                Icon(CupertinoIcons.antenna_radiowaves_left_right, size: 13, color: textColor),
                const SizedBox(width: 4),
                Text(
                  config.networkType,
                  style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 6),
                Icon(CupertinoIcons.wifi, size: 14, color: textColor),
                const SizedBox(width: 6),
                Row(
                  children: [
                    Text(
                      '${config.batteryLevel}%',
                      style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 3),
                    Icon(CupertinoIcons.battery_full, size: 15, color: textColor),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(Color textColor) {
    final isSelected = selectedElementId == 'partner_profile' || selectedElementId == 'room_settings';

    return GestureDetector(
      onTap: () => onSelectElement?.call('partner_profile'),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1).withValues(alpha: 0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(CupertinoIcons.back, size: 20, color: textColor),
              onPressed: onBackToChatList,
            ),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      config.roomTitle,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (config.memberCount > 2) ...[
                    const SizedBox(width: 6),
                    Text(
                      '${config.memberCount}',
                      style: const TextStyle(color: Color(0xFF757575), fontSize: 13),
                    ),
                  ],
                ],
              ),
            ),
            Icon(CupertinoIcons.search, size: 18, color: textColor),
            const SizedBox(width: 14),
            Icon(CupertinoIcons.bars, size: 18, color: textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeBanner(Color textColor) {
    final isSelected = selectedElementId == 'notice_banner';

    return GestureDetector(
      onTap: () => onSelectElement?.call('notice_banner'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6366F1).withValues(alpha: 0.22)
              : (config.isDarkTheme ? Colors.white.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.88)),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.2 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(CupertinoIcons.speaker_2_fill, size: 14, color: Color(0xFFF59E0B)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                config.noticeText,
                style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Text(
        '2026년 9월 18일 금요일',
        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _buildMessageRow(KakaoMessage msg) {
    final isSelected = selectedElementId == 'msg_${msg.id}';

    if (msg.isMe) {
      return GestureDetector(
        onTap: () => onSelectElement?.call('msg_${msg.id}'),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6366F1).withValues(alpha: 0.16) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (msg.unreadCount > 0)
                      Text(
                        '${msg.unreadCount}',
                        style: const TextStyle(
                          color: Color(0xFFFEE500),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (msg.showTime)
                      Text(msg.time, style: const TextStyle(color: Color(0xFF555555), fontSize: 10)),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEE500),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(3),
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                  ),
                  child: Text(
                    msg.text,
                    style: const TextStyle(color: Colors.black, fontSize: 14, height: 1.35),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => onSelectElement?.call('msg_${msg.id}'),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6366F1).withValues(alpha: 0.16) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    msg.senderName.isNotEmpty ? msg.senderName[0] : '?',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF555555),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      msg.senderName,
                      style: const TextStyle(
                        color: Color(0xFF4A4A4A),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(3),
                                topRight: Radius.circular(14),
                                bottomLeft: Radius.circular(14),
                                bottomRight: Radius.circular(14),
                              ),
                            ),
                            child: Text(
                              msg.text,
                              style: const TextStyle(color: Colors.black, fontSize: 14, height: 1.35),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            msg.time,
                            style: const TextStyle(color: Color(0xFF555555), fontSize: 10),
                          ),
                        ),
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

  Widget _buildBottomInputBar() {
    final isSelected = selectedElementId == 'input_bar';
    final hasText = config.inputText.isNotEmpty;
    final bgColor = config.isDarkTheme ? const Color(0xFF191A1C) : Colors.white;
    final inputBg = config.isDarkTheme ? const Color(0xFF28292C) : const Color(0xFFF3F3F5);
    final textCol = config.isDarkTheme ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () => onSelectElement?.call('input_bar'),
      child: Container(
        color: bgColor,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Icon(
                CupertinoIcons.plus_circle,
                color: config.isDarkTheme ? Colors.white54 : const Color(0xFF757575),
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF6366F1).withValues(alpha: 0.18) : inputBg,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          hasText ? config.inputText : '메시지를 입력하세요...',
                          style: TextStyle(
                            color: hasText
                                ? textCol
                                : (config.isDarkTheme ? Colors.white38 : const Color(0xFF9E9E9E)),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Icon(
                        CupertinoIcons.smiley,
                        color: config.isDarkTheme ? Colors.white54 : const Color(0xFF757575),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                CupertinoIcons.number,
                color: config.isDarkTheme ? Colors.white54 : const Color(0xFF757575),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
