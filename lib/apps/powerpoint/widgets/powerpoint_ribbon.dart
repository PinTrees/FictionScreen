import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PowerPointRibbon extends StatefulWidget {
  final String presentationTitle;
  final VoidCallback onOpenEdit;
  final VoidCallback onStartSlideShow;

  const PowerPointRibbon({
    super.key,
    required this.presentationTitle,
    required this.onOpenEdit,
    required this.onStartSlideShow,
  });

  @override
  State<PowerPointRibbon> createState() => _PowerPointRibbonState();
}

class _PowerPointRibbonState extends State<PowerPointRibbon> {
  int _activeTab = 1; // 홈
  final List<String> _tabs = ['파일', '홈', '삽입', '디자인', '전환', '애니메이션', '슬라이드 쇼', '검토', '보기'];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Top Orange Title Bar
        Container(
          height: 38,
          color: const Color(0xFFC43E1C),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Image.asset(
                'assets/images/powerpoint_icon.webp',
                width: 20,
                height: 20,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.slideshow, color: Colors.white, size: 18),
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
                    '${widget.presentationTitle} - PowerPoint',
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

              // F5 Slide Show Button
              InkWell(
                onTap: widget.onStartSlideShow,
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
                      Icon(Icons.play_circle_filled, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text('슬라이드 쇼', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

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
                  color: Color(0xFF8E260F),
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
                            top: BorderSide(color: Color(0xFFC43E1C), width: 2),
                            left: BorderSide(color: Color(0xFFE1DFDD)),
                            right: BorderSide(color: Color(0xFFE1DFDD)),
                          )
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      name,
                      style: TextStyle(
                        color: isSelected ? const Color(0xFFC43E1C) : const Color(0xFF323130),
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
              _buildRibbonBtn(Icons.slideshow, '새 슬라이드'),
              _buildRibbonBtn(Icons.dashboard_customize, '레이아웃'),
              _buildDivider(),

              // Font
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD2D0CE)),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Text('맑은 고딕', style: TextStyle(fontSize: 11, color: Color(0xFF323130))),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD2D0CE)),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Text('24', style: TextStyle(fontSize: 11, color: Color(0xFF323130))),
              ),
              const SizedBox(width: 6),
              _buildToolIcon(Icons.format_bold, isSelected: true),
              _buildToolIcon(Icons.format_italic),
              _buildToolIcon(Icons.format_underlined),
              _buildToolIcon(Icons.format_color_text, color: const Color(0xFFC43E1C)),
              _buildDivider(),

              // Shapes & Design
              _buildToolIcon(Icons.crop_square),
              _buildToolIcon(Icons.arrow_forward),
              _buildToolIcon(Icons.star_border),
              _buildRibbonBtn(Icons.auto_awesome, '디자이너 아이디어'),
              _buildDivider(),

              // Slide Show
              _buildRibbonBtn(Icons.play_arrow, '처음부터 (F5)', onTap: widget.onStartSlideShow),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRibbonBtn(IconData icon, String label, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: const Color(0xFFC43E1C)),
              const SizedBox(height: 2),
              Text(label, style: const TextStyle(fontSize: 9, color: Color(0xFF323130))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolIcon(IconData icon, {bool isSelected = false, Color? color}) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFDCD2) : Colors.transparent,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Center(
        child: Icon(icon, size: 15, color: color ?? const Color(0xFF323130)),
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
