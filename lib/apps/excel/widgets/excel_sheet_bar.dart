import 'package:flutter/material.dart';
import '../data/excel_model.dart';

class ExcelSheetBar extends StatelessWidget {
  final List<ExcelSheet> sheets;
  final int activeSheetIndex;
  final ValueChanged<int> onSelectSheet;
  final String statusMessage;
  final String sumText;
  final String avgText;
  final String countText;

  const ExcelSheetBar({
    super.key,
    required this.sheets,
    required this.activeSheetIndex,
    required this.onSelectSheet,
    required this.statusMessage,
    required this.sumText,
    required this.avgText,
    required this.countText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF3F2F1),
        border: Border(top: BorderSide(color: Color(0xFFD2D0CE))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Sheet Tabs Row
          Container(
            height: 28,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                const Icon(Icons.chevron_left, size: 16, color: Color(0xFF605E5C)),
                const Icon(Icons.chevron_right, size: 16, color: Color(0xFF605E5C)),
                const SizedBox(width: 6),

                // Sheet Tabs
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: sheets.length,
                    itemBuilder: (context, idx) {
                      final sheet = sheets[idx];
                      final isActive = activeSheetIndex == idx;

                      return InkWell(
                        onTap: () => onSelectSheet(idx),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          margin: const EdgeInsets.only(right: 2, top: 2),
                          decoration: BoxDecoration(
                            color: isActive ? Colors.white : Colors.transparent,
                            border: isActive
                                ? const Border(
                                    top: BorderSide(color: Color(0xFFD2D0CE)),
                                    left: BorderSide(color: Color(0xFFD2D0CE)),
                                    right: BorderSide(color: Color(0xFFD2D0CE)),
                                    bottom: BorderSide(color: Color(0xFF107C41), width: 2),
                                  )
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            sheet.name,
                            style: TextStyle(
                              color: isActive ? const Color(0xFF107C41) : const Color(0xFF605E5C),
                              fontSize: 11,
                              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Add Sheet '+' Button
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: const Icon(Icons.add, size: 16, color: Color(0xFF605E5C)),
                  ),
                ),
              ],
            ),
          ),

          // 2. Excel Status Bar (Calculations & Zoom)
          Container(
            height: 22,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: const Color(0xFFEDEBE9),
            child: Row(
              children: [
                Text(statusMessage, style: const TextStyle(color: Color(0xFF605E5C), fontSize: 10)),
                const Spacer(),

                // Statistics
                if (avgText.isNotEmpty) ...[
                  Text('평균: $avgText', style: const TextStyle(color: Color(0xFF323130), fontSize: 10, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 14),
                ],
                if (countText.isNotEmpty) ...[
                  Text('개수: $countText', style: const TextStyle(color: Color(0xFF323130), fontSize: 10, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 14),
                ],
                if (sumText.isNotEmpty) ...[
                  Text('합계: $sumText', style: const TextStyle(color: Color(0xFF107C41), fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                ],

                // View Switchers
                const Icon(Icons.grid_on, size: 12, color: Color(0xFF605E5C)),
                const SizedBox(width: 8),
                const Icon(Icons.menu_book, size: 12, color: Color(0xFF605E5C)),
                const SizedBox(width: 12),

                // Zoom Slider
                const Icon(Icons.remove, size: 12, color: Color(0xFF605E5C)),
                const SizedBox(width: 4),
                Container(
                  width: 50,
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC8C6C4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF107C41), shape: BoxShape.circle)),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.add, size: 12, color: Color(0xFF605E5C)),
                const SizedBox(width: 6),
                const Text('100%', style: TextStyle(color: Color(0xFF605E5C), fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
