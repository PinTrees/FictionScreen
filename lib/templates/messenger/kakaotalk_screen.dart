import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/kakaotalk_model.dart';
import '../../style/app_colors.dart';

class KakaoTalkScreen extends StatelessWidget {
  final KakaoRoomConfig config;
  final bool isAnimated;

  const KakaoTalkScreen({
    super.key,
    required this.config,
    this.isAnimated = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = config.isDarkTheme ? AppColors.kakaoDarkBg : AppColors.kakaoChatBg;
    final textColor = config.isDarkTheme ? Colors.white : Colors.black;

    return Container(
      color: bgColor,
      child: Column(
        children: [
          // 1. 최상단 상태바 (iOS 스타일)
          _buildStatusBar(textColor),

          // 2. 카카오톡 상단 내비게이션 바
          _buildTopBar(textColor),

          // 3. 날짜 구분선
          _buildDateDivider(),

          // 4. 채팅 대화 목록
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              itemCount: config.messages.length,
              itemBuilder: (context, index) {
                final msg = config.messages[index];
                final item = _buildMessageRow(msg);

                if (isAnimated) {
                  return item
                      .animate(delay: (200 * index).ms)
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: 0.2, end: 0, duration: 300.ms);
                }
                return item;
              },
            ),
          ),

          // 5. 하단 메시지 입력창
          _buildBottomInputBar(),
        ],
      ),
    );
  }

  Widget _buildStatusBar(Color textColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
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
              Icon(Icons.signal_cellular_alt, size: 15, color: textColor),
              const SizedBox(width: 4),
              Text(
                config.networkType,
                style: TextStyle(
                  color: textColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.wifi, size: 15, color: textColor),
              const SizedBox(width: 6),
              Row(
                children: [
                  Text(
                    '${config.batteryLevel}%',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(Icons.battery_full_rounded, size: 16, color: textColor),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(Color textColor) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: textColor),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    config.roomTitle,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (config.memberCount > 2) ...[
                  const SizedBox(width: 6),
                  Text(
                    '${config.memberCount}',
                    style: const TextStyle(
                      color: Color(0xFF757575),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.search_rounded, size: 22, color: textColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.menu_rounded, size: 22, color: textColor),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDateDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        '2026년 9월 18일 금요일',
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildMessageRow(KakaoMessage msg) {
    if (msg.isMe) {
      return _buildMyMessage(msg);
    } else {
      return _buildPartnerMessage(msg);
    }
  }

  Widget _buildMyMessage(KakaoMessage msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 시간 및 안읽음 1 표시
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
                  Text(
                    msg.time,
                    style: const TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ),

          // 노란 말풍선
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
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  height: 1.35,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerMessage(KakaoMessage msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상대방 프로필
          if (msg.showProfile) ...[
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  msg.senderName.isNotEmpty ? msg.senderName[0] : '?',
                  style: const TextStyle(
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ] else ...[
            const SizedBox(width: 46),
          ],

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (msg.showProfile)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      msg.senderName,
                      style: const TextStyle(
                        color: Color(0xFF4A4A4A),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // 상대방 흰색 말풍선
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
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            height: 1.35,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    // 시간 및 안읽음
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            Text(
                              msg.time,
                              style: const TextStyle(
                                color: Color(0xFF555555),
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInputBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF757575), size: 24),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        '메시지를 입력하세요...',
                        style: TextStyle(
                          color: Color(0xFF9E9E9E),
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Icon(Icons.sentiment_satisfied_alt_rounded, color: Color(0xFF757575), size: 20),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.tag_rounded, color: Color(0xFF757575), size: 24),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
