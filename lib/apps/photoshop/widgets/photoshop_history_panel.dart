import 'package:flutter/material.dart';
import '../data/photoshop_model.dart';

class PhotoshopHistoryPanel extends StatelessWidget {
  final List<PhotoshopHistoryItem> history;

  const PhotoshopHistoryPanel({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 140,
      decoration: const BoxDecoration(
        color: Color(0xFF282828),
        border: Border(
          left: BorderSide(color: Color(0xFF1E1E1E), width: 1),
          bottom: BorderSide(color: Color(0xFF1E1E1E), width: 1),
        ),
      ),
      child: Column(
        children: [
          // Header Tabs: 작업 내역 / 속성
          Container(
            height: 26,
            color: const Color(0xFF232323),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: const Row(
              children: [
                Text(
                  '작업 내역',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  '속성',
                  style: TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // History items list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: history.length,
              itemBuilder: (context, idx) {
                final item = history[idx];
                final isCurrent = idx == history.length - 1;

                return Container(
                  height: 22,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  color: isCurrent ? const Color(0xFF383838) : Colors.transparent,
                  child: Row(
                    children: [
                      Icon(item.icon, size: 12, color: isCurrent ? const Color(0xFF31A8FF) : const Color(0xFF9E9E9E)),
                      const SizedBox(width: 8),
                      Text(
                        item.name,
                        style: TextStyle(
                          color: isCurrent ? Colors.white : const Color(0xFFB5B5B5),
                          fontSize: 11,
                          fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
