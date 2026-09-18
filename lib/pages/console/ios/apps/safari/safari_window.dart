import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// iOS 18 Safari 웹 브라우저
class IosSafariWindow extends StatefulWidget {
  final VoidCallback onClose;

  const IosSafariWindow({
    super.key,
    required this.onClose,
  });

  @override
  State<IosSafariWindow> createState() => _IosSafariWindowState();
}

class _IosSafariWindowState extends State<IosSafariWindow> {
  final TextEditingController _urlController = TextEditingController(text: 'https://fiction-screen.web.app');

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // 브라우저 화면
            Expanded(
              child: Container(
                color: const Color(0xFF141720),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: widget.onClose,
                          child: const Icon(CupertinoIcons.chevron_left, color: Color(0xFF007AFF), size: 22),
                        ),
                        const Text('Safari 시작 페이지', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 22),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('즐겨찾기', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBookmark('Apple', 'assets/images/apple_logo.webp'),
                        _buildBookmark('카카오톡', 'assets/images/kakaotalk_icon.webp'),
                        _buildBookmark('인스타그램', 'assets/images/instagram_icon.webp'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // iOS 18 하단 플로팅 주소 바
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(color: Color(0xFF1C1C1E)),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.book, color: Color(0xFF007AFF), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.lock_fill, color: Colors.white38, size: 12),
                          const SizedBox(width: 6),
                          Expanded(
                            child: TextField(
                              controller: _urlController,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                              decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.zero, border: InputBorder.none),
                            ),
                          ),
                          const Icon(CupertinoIcons.arrow_clockwise, color: Colors.white70, size: 14),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(CupertinoIcons.square_on_square, color: Color(0xFF007AFF), size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmark(String title, String asset) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(12)),
          child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(asset, fit: BoxFit.cover)),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}
