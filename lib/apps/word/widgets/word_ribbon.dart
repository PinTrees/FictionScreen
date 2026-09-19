import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WordRibbon extends StatefulWidget {
  final String documentTitle;
  final VoidCallback onOpenEdit;

  const WordRibbon({
    super.key,
    required this.documentTitle,
    required this.onOpenEdit,
  });

  @override
  State<WordRibbon> createState() => _WordRibbonState();
}

class _WordRibbonState extends State<WordRibbon> {
  int _activeTab = 1; // 홈
  final List<String> _tabs = ['파일', '홈', '삽입', '그리기', '디자인', '레이아웃', '참조', '검토', '보기'];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Top Blue Title Bar
        Container(
          height: 38,
          color: const Color(0xFF185ABD),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Image.asset(
                'assets/images/word_icon.webp',
                width: 20,
                height: 20,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.description, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.cloud_done, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text('자동 저장 켬', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.save_outlined, color: Colors.white70, size: 16),
              const SizedBox(width: 8),
              const Icon(Icons.undo, color: Colors.white70, size: 16),
              const SizedBox(width: 16),

              // Title
              Expanded(
                child: Center(
                  child: Text(
                    '${widget.documentTitle} - Word',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Edit Button
              InkWell(
                onTap: widget.onOpenEdit,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white70, width: 0.8),
                  ),
                  child: const Row(
                    children: [
                      Icon(CupertinoIcons.pencil_ellipsis_rectangle, color: Colors.white, size: 13),
                      SizedBox(width: 4),
                      Text('시나리오 편집', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFF0F3E85),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('F', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),

        // 2. Tab Headers
        Container(
          height: 30,
          color: const Color(0xFFF3F2F1),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: _tabs.asMap().entries.map((entry) {
              final idx = entry.key;
              final name = entry.value;
              final isSelected = _activeTab == idx;
              return InkWell(
                onTap: () => setState(() => _activeTab = idx),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    border: isSelected
                        ? const Border(
                            top: BorderSide(color: Color(0xFF185ABD), width: 2),
                            left: BorderSide(color: Color(0xFFE1DFDD)),
                            right: BorderSide(color: Color(0xFFE1DFDD)),
                          )
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      name,
                      style: TextStyle(
                        color: isSelected ? const Color(0xFF185ABD) : const Color(0xFF323130),
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // 3. Ribbon Controls Bar
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE1DFDD))),
          ),
          child: Row(
            children: [
              _buildRibbonBtn(Icons.content_paste, '붙여넣기'),
              _buildDivider(),

              // Font
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD2D0CE)),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Text('바탕체', style: TextStyle(fontSize: 11, color: Color(0xFF323130))),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD2D0CE)),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Text('11', style: TextStyle(fontSize: 11, color: Color(0xFF323130))),
              ),
              const SizedBox(width: 6),
              _buildToolIcon(Icons.format_bold, isSelected: true),
              _buildToolIcon(Icons.format_italic),
              _buildToolIcon(Icons.format_underlined),
              _buildToolIcon(Icons.format_strikethrough),
              _buildDivider(),

              // Alignment
              _buildToolIcon(Icons.format_align_left),
              _buildToolIcon(Icons.format_align_center, isSelected: true),
              _buildToolIcon(Icons.format_align_right),
              _buildToolIcon(Icons.format_align_justify),
              _buildDivider(),

              // Redacted / Stamp Quick Toggle
              _buildRibbonBtn(Icons.visibility_off, '기밀 마스킹 (REDACTED)'),
              _buildDivider(),
              _buildRibbonBtn(Icons.verified, '인감 도장 날인'),
            ],
          ),
        ),

        // 4. Horizontal Document Ruler
        Container(
          height: 18,
          color: const Color(0xFFF3F2F1),
          padding: const EdgeInsets.symmetric(horizontal: 40),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFD2D0CE))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(16, (i) => Text('$i', style: const TextStyle(fontSize: 8, color: Color(0xFF8A8886)))),
          ),
        ),
      ],
    );
  }

  Widget _buildRibbonBtn(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: const Color(0xFF185ABD)),
              const SizedBox(height: 2),
              Text(label, style: const TextStyle(fontSize: 9, color: Color(0xFF323130))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolIcon(IconData icon, {bool isSelected = false}) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFCCE4F7) : Colors.transparent,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Center(
        child: Icon(icon, size: 15, color: const Color(0xFF323130)),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: const Color(0xFFE1DFDD),
    );
  }
}
