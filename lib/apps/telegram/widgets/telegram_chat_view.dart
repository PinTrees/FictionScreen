import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/telegram_model.dart';

/// 텔레그램 데스크톱 우측 메인 대화방 뷰
class TelegramChatView extends StatefulWidget {
  final TelegramChat chat;
  final VoidCallback onOpenEditDialog;
  final Function(String text, bool isMe) onSendMessage;
  final Function(TelegramMessage msg, String emoji) onToggleReaction;

  const TelegramChatView({
    super.key,
    required this.chat,
    required this.onOpenEditDialog,
    required this.onSendMessage,
    required this.onToggleReaction,
  });

  @override
  State<TelegramChatView> createState() => _TelegramChatViewState();
}

class _TelegramChatViewState extends State<TelegramChatView> {
  final TextEditingController _msgCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    widget.onSendMessage(text, true);
    _msgCtrl.clear();
    // 부드러운 하단 스크롤
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0E1621), // Telegram Canvas Background
      child: Column(
        children: [
          // 1. 상단 채팅방 헤더
          _buildChatHeader(),

          // 2. 메시지 스크롤 캔버스
          Expanded(
            child: Stack(
              children: [
                // 은은한 텔레그램 두들 패턴 배경
                Positioned.fill(
                  child: CustomPaint(
                    painter: _TelegramDoodlePatternPainter(),
                  ),
                ),

                // 메시지 목록
                ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  itemCount: widget.chat.messages.length,
                  itemBuilder: (context, index) {
                    final msg = widget.chat.messages[index];
                    return _buildMessageBubble(msg);
                  },
                ),
              ],
            ),
          ),

          // 3. 하단 메시지 입력바
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildChatHeader() {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF17212B),
        border: Border(bottom: BorderSide(color: Color(0xFF0E1621))),
      ),
      child: Row(
        children: [
          // 아바타
          CircleAvatar(
            radius: 20,
            backgroundColor: widget.chat.avatarColor,
            child: Text(
              widget.chat.title.isNotEmpty ? widget.chat.title.characters.first : 'T',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(width: 12),

          // 제목 및 서브타이틀
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.chat.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.chat.isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(CupertinoIcons.checkmark_seal_fill, size: 14, color: Color(0xFF5288C1)),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  widget.chat.subtitle,
                  style: TextStyle(
                    color: widget.chat.subtitle.toLowerCase().contains('online')
                        ? const Color(0xFF4ADE80)
                        : const Color(0xFF7E8C9A),
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),

          // 우측 액션 버튼들
          // 크리에이터 전용 [스토리 편집 / 페이크 메시지 설정] 버튼
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2B5278),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            icon: const Icon(CupertinoIcons.pencil_circle_fill, size: 15, color: Color(0xFF60A5FA)),
            label: const Text('스토리 편집', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
            onPressed: widget.onOpenEditDialog,
          ),
          const SizedBox(width: 8),

          IconButton(
            icon: const Icon(CupertinoIcons.search, size: 18, color: Color(0xFF7E8C9A)),
            tooltip: 'Search',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.phone, size: 18, color: Color(0xFF7E8C9A)),
            tooltip: 'Call',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.ellipsis_vertical, size: 18, color: Color(0xFF7E8C9A)),
            tooltip: 'More',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(TelegramMessage msg) {
    final isMe = msg.isMe;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 채널/상대방 메시지인 경우 아바타는 상단 표시 또는 텔레그램 데스크톱처럼 버블 내 이름 표시
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF2B5278) : const Color(0xFF182533),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(isMe ? 12 : 2),
                  bottomRight: Radius.circular(isMe ? 2 : 12),
                ),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, offset: Offset(0, 1), blurRadius: 2),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 작성자 이름 (채널 또는 상대방)
                  if (!isMe)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        msg.senderName,
                        style: const TextStyle(
                          color: Color(0xFF64B5F6),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  // 본문 텍스트
                  SelectableText(
                    msg.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // 하단 메타 정보 (조회수, 시간, 읽음 체크)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Spacer(),
                      if (msg.views != null) ...[
                        const Icon(CupertinoIcons.eye, size: 12, color: Colors.white54),
                        const SizedBox(width: 4),
                        Text(
                          msg.views!,
                          style: const TextStyle(color: Colors.white54, fontSize: 10.5),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        msg.time,
                        style: const TextStyle(color: Colors.white54, fontSize: 10.5),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          CupertinoIcons.check_mark,
                          size: 12,
                          color: Color(0xFF64B5F6),
                        ),
                      ],
                    ],
                  ),

                  // 이모지 반응 리액션 알약 바
                  if (msg.reactions.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: msg.reactions.map((reaction) {
                        return InkWell(
                          onTap: () => widget.onToggleReaction(msg, reaction.emoji),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: reaction.isSelected
                                  ? const Color(0xFF5288C1).withValues(alpha: 0.35)
                                  : Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: reaction.isSelected ? const Color(0xFF5288C1) : Colors.transparent,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(reaction.emoji, style: const TextStyle(fontSize: 13)),
                                const SizedBox(width: 4),
                                Text(
                                  '${reaction.count}',
                                  style: TextStyle(
                                    color: reaction.isSelected ? const Color(0xFF64B5F6) : Colors.white70,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF17212B),
        border: Border(top: BorderSide(color: Color(0xFF0E1621))),
      ),
      child: Row(
        children: [
          // 파일 첨부 클립 버튼
          IconButton(
            icon: const Icon(CupertinoIcons.paperclip, size: 20, color: Color(0xFF7E8C9A)),
            tooltip: 'Attach file',
            onPressed: () {},
          ),

          // 메시지 텍스트 입력창
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _msgCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 13.5),
                decoration: const InputDecoration(
                  hintText: 'Write a message...',
                  hintStyle: TextStyle(color: Color(0xFF7E8C9A), fontSize: 13.5),
                  border: InputBorder.none,
                  isDense: true,
                ),
                onSubmitted: (_) => _handleSend(),
              ),
            ),
          ),

          // 스마일 이모티콘 버튼
          IconButton(
            icon: const Icon(CupertinoIcons.smiley, size: 20, color: Color(0xFF7E8C9A)),
            tooltip: 'Emojis & Stickers',
            onPressed: () {},
          ),

          // 전송 비행기 버튼
          IconButton(
            icon: const Icon(CupertinoIcons.paperplane_fill, size: 20, color: Color(0xFF5288C1)),
            tooltip: 'Send message',
            onPressed: _handleSend,
          ),
        ],
      ),
    );
  }
}

/// 텔레그램 특유의 은은한 기하학 캔버스 배경 패턴 페인터
class _TelegramDoodlePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.015)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    // 은은한 기하학 격자 및 별/원형 장식
    const step = 60.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        if ((x + y) % 120 == 0) {
          canvas.drawCircle(Offset(x, y), 3, paint);
        } else if ((x - y) % 180 == 0) {
          canvas.drawRect(Rect.fromCenter(center: Offset(x, y), width: 6, height: 6), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
