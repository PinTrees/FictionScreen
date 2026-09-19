import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/daangn_model.dart';

/// 당근마켓 채팅방 뷰 (시그니처 오렌지 상단 바 & 미니 상품 카드 & 매너온도)
class DaangnChatPage extends StatefulWidget {
  final DaangnConfig config;
  final VoidCallback? onHeaderTap;
  final VoidCallback? onProductCardTap;

  const DaangnChatPage({
    super.key,
    required this.config,
    this.onHeaderTap,
    this.onProductCardTap,
  });

  @override
  State<DaangnChatPage> createState() => _DaangnChatPageState();
}

class _DaangnChatPageState extends State<DaangnChatPage> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      widget.config.messages.add(
        DaangnMessageItem(
          id: '${DateTime.now().millisecondsSinceEpoch}',
          isMe: true,
          text: text,
          time: '방금 전',
        ),
      );
      _msgController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatPrice(int price) {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(price)}원';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. 당근마켓 상단 헤더 (판매자 이름 & 매너온도)
        GestureDetector(
          onTap: widget.onHeaderTap,
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.left_chevron, size: 20, color: Colors.black87),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.config.sellerName,
                            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6F0F).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${widget.config.mannerTemp}°C',
                              style: const TextStyle(color: Color(0xFFFF6F0F), fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.config.sellerLocation,
                        style: const TextStyle(color: Colors.black45, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const Icon(CupertinoIcons.phone, size: 18, color: Colors.black87),
                const SizedBox(width: 16),
                const Icon(CupertinoIcons.ellipsis_vertical, size: 18, color: Colors.black87),
              ],
            ),
          ),
        ),

        // 2. 상단 고정 미니 상품 정보 카드 (가격 & 거래상태)
        GestureDetector(
          onTap: widget.onProductCardTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFFAFAFA),
              border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: widget.config.productImageAsset != null
                        ? Image.asset(widget.config.productImageAsset!, fit: BoxFit.cover)
                        : const Icon(CupertinoIcons.photo, color: Colors.grey, size: 22),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: widget.config.tradeStatus == '거래완료'
                                  ? Colors.grey.shade700
                                  : (widget.config.tradeStatus == '예약중' ? const Color(0xFF22C55E) : const Color(0xFFFF6F0F)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              widget.config.tradeStatus,
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              widget.config.productTitle,
                              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _formatPrice(widget.config.productPrice),
                        style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 3. 당근마켓 채팅 대화 메시지 영역
        Expanded(
          child: Container(
            color: const Color(0xFFF3F4F6),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: widget.config.messages.length,
              itemBuilder: (context, index) {
                final msg = widget.config.messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!msg.isMe) ...[
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: const Color(0xFFFF6F0F),
                          child: Text(
                            widget.config.sellerName.isNotEmpty ? widget.config.sellerName[0] : '당',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (msg.isMe) ...[
                        Text(msg.time, style: const TextStyle(color: Colors.black38, fontSize: 10)),
                        const SizedBox(width: 6),
                      ],
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: msg.isMe ? const Color(0xFFFF6F0F) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            msg.text,
                            style: TextStyle(
                              color: msg.isMe ? Colors.white : Colors.black87,
                              fontSize: 13,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ),
                      if (!msg.isMe) ...[
                        const SizedBox(width: 6),
                        Text(msg.time, style: const TextStyle(color: Colors.black38, fontSize: 10)),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ),

        // 4. 하단 메시지 입력 바 & 당근 빠른 버튼
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
          ),
          child: Row(
            children: [
              const Icon(CupertinoIcons.add, size: 22, color: Colors.black54),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _msgController,
                          cursorColor: const Color(0xFFFF6F0F),
                          style: const TextStyle(color: Color(0xFF111827), fontSize: 13),
                          decoration: const InputDecoration(
                            hintText: '메시지 보내기...',
                            hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
                            filled: false,
                            fillColor: Colors.transparent,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      InkWell(
                        onTap: _sendMessage,
                        child: const Icon(CupertinoIcons.paperplane_fill, size: 18, color: Color(0xFFFF6F0F)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
