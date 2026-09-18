import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Samsung Internet (삼성 인터넷 브라우저)
class SamsungInternetWindow extends StatefulWidget {
  final VoidCallback onClose;

  const SamsungInternetWindow({
    super.key,
    required this.onClose,
  });

  @override
  State<SamsungInternetWindow> createState() => _SamsungInternetWindowState();
}

class _SamsungInternetWindowState extends State<SamsungInternetWindow> {
  final TextEditingController _urlController = TextEditingController(text: 'https://fiction-screen.web.app');

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 URL 주소창
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF181A24),
                border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: widget.onClose,
                    child: const Icon(CupertinoIcons.chevron_left, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.lock_fill, color: Colors.white38, size: 12),
                          const SizedBox(width: 6),
                          Expanded(
                            child: TextField(
                              controller: _urlController,
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(CupertinoIcons.arrow_clockwise, color: Colors.white70, size: 16),
                ],
              ),
            ),

            // 시작 페이지
            Expanded(
              child: Container(
                color: const Color(0xFF12141F),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Samsung Internet 빠른 연결', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildQuickLink('FictionScreen', CupertinoIcons.sparkles, const Color(0xFF6366F1)),
                        _buildQuickLink('Naver', CupertinoIcons.search, const Color(0xFF10B981)),
                        _buildQuickLink('YouTube', CupertinoIcons.play_circle_fill, const Color(0xFFEF4444)),
                        _buildQuickLink('Google', CupertinoIcons.globe, const Color(0xFF3B82F6)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLink(String title, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}
