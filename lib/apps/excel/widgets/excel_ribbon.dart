import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExcelRibbon extends StatefulWidget {
  final String fileName;
  final VoidCallback onOpenEdit;

  const ExcelRibbon({
    super.key,
    required this.fileName,
    required this.onOpenEdit,
  });

  @override
  State<ExcelRibbon> createState() => _ExcelRibbonState();
}

class _ExcelRibbonState extends State<ExcelRibbon> {
  int _activeTab = 1; // 0: 파일, 1: 홈, 2: 삽입, 3: 수식, 4: 데이터
  final List<String> _tabs = ['파일', '홈', '삽입', '페이지 레이아웃', '수식', '데이터', '검토', '보기'];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Top Green Title Bar
        Container(
          height: 38,
          color: const Color(0xFF107C41),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              // Excel Icon
              Image.asset(
                'assets/images/excel_icon.webp',
                width: 20,
                height: 20,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.table_chart, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              // AutoSave pill
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
              const SizedBox(width: 8),
              const Icon(Icons.redo, color: Colors.white38, size: 16),
              const SizedBox(width: 16),

              // File Name (Centered / Bold)
              Expanded(
                child: Center(
                  child: Text(
                    '${widget.fileName} - Excel',
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

              // ✏️ 시나리오 편집 버튼
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
                      Text(
                        '시나리오 편집',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // User Avatar
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFF0C5A2F),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('F', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),

        // 2. Ribbon Tab Headers
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
                            top: BorderSide(color: Color(0xFF107C41), width: 2),
                            left: BorderSide(color: Color(0xFFE1DFDD)),
                            right: BorderSide(color: Color(0xFFE1DFDD)),
                          )
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      name,
                      style: TextStyle(
                        color: isSelected ? const Color(0xFF107C41) : const Color(0xFF323130),
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

        // 3. Ribbon Controls Bar (Compact Office 365 Toolbar)
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE1DFDD))),
          ),
          child: Row(
            children: [
              // Clipboard Group
              _buildRibbonBtn(Icons.content_paste, '붙여넣기'),
              _buildDivider(),

              // Font Group
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
                child: const Text('11', style: TextStyle(fontSize: 11, color: Color(0xFF323130))),
              ),
              const SizedBox(width: 6),
              _buildToolIcon(Icons.format_bold, isSelected: true),
              _buildToolIcon(Icons.format_italic),
              _buildToolIcon(Icons.format_underlined),
              _buildToolIcon(Icons.format_color_fill, color: const Color(0xFFFFEB3B)),
              _buildToolIcon(Icons.border_all),
              _buildDivider(),

              // Alignment Group
              _buildToolIcon(Icons.format_align_left),
              _buildToolIcon(Icons.format_align_center, isSelected: true),
              _buildToolIcon(Icons.format_align_right),
              _buildRibbonBtn(Icons.call_merge, '병합하고 가운데 맞춤'),
              _buildDivider(),

              // Number Group
              _buildToolIcon(Icons.attach_money, isSelected: true),
              _buildToolIcon(Icons.percent),
              _buildToolIcon(Icons.numbers),
              _buildDivider(),

              // AutoSum
              _buildRibbonBtn(Icons.functions, '자동 합계 (Σ)'),
            ],
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
              Icon(icon, size: 18, color: const Color(0xFF107C41)),
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
        color: isSelected ? const Color(0xFFC7E0F4) : Colors.transparent,
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
