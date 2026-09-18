import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Samsung One UI 내 파일 (My Files)
class SamsungMyFilesWindow extends StatelessWidget {
  final VoidCallback onClose;

  const SamsungMyFilesWindow({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      body: SafeArea(
        child: Column(
          children: [
            // One UI 대형 헤더
            Container(
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF161822),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: onClose,
                        child: const Icon(CupertinoIcons.chevron_left, color: Colors.white, size: 20),
                      ),
                      const Icon(CupertinoIcons.search, color: Colors.white70, size: 18),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '내 파일',
                    style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // 파일 카테고리
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text('카테고리', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCategoryItem('이미지', CupertinoIcons.photo_fill, const Color(0xFF3B82F6)),
                      _buildCategoryItem('동영상', CupertinoIcons.play_rectangle_fill, const Color(0xFFEF4444)),
                      _buildCategoryItem('오디오', CupertinoIcons.music_note_2, const Color(0xFF10B981)),
                      _buildCategoryItem('문서', CupertinoIcons.doc_fill, const Color(0xFFF59E0B)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('저장공간 분석', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('내부 저장공간', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            Text('64.2 GB / 256 GB', style: TextStyle(color: Color(0xFF60A5FA), fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: const LinearProgressIndicator(
                            value: 0.25,
                            backgroundColor: Colors.white12,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 11)),
      ],
    );
  }
}
