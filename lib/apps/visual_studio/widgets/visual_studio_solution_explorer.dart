import 'package:flutter/material.dart';
import '../data/visual_studio_model.dart';

class VisualStudioSolutionExplorer extends StatelessWidget {
  final List<SolutionItem> items;
  final String activeFileName;
  final ValueChanged<String>? onSelectFile;

  const VisualStudioSolutionExplorer({
    super.key,
    required this.items,
    required this.activeFileName,
    this.onSelectFile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: const Color(0xFF252526),
      child: Column(
        children: [
          // Header Tab
          Container(
            height: 28,
            color: const Color(0xFF2D2D30),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Row(
              children: [
                Text(
                  '솔루션 탐색기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                Icon(Icons.unfold_less, size: 14, color: Color(0xFF9E9E9E)),
                SizedBox(width: 6),
                Icon(Icons.sync, size: 14, color: Color(0xFF9E9E9E)),
                SizedBox(width: 6),
                Icon(Icons.more_vert, size: 14, color: Color(0xFF9E9E9E)),
              ],
            ),
          ),

          // Search Box in Solution Explorer
          Container(
            height: 26,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            color: const Color(0xFF252526),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                border: Border.all(color: const Color(0xFF3F3F46)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, size: 12, color: Color(0xFF888888)),
                  SizedBox(width: 4),
                  Text(
                    '솔루션 탐색기 검색 (Ctrl+;)',
                    style: TextStyle(color: Color(0xFF6E6E6E), fontSize: 10.5),
                  ),
                ],
              ),
            ),
          ),

          // Solution Items Tree
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 4),
              children: items.map((it) => _buildTreeItem(it, 0)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreeItem(SolutionItem item, int depth) {
    final isSelected = item.name.contains(activeFileName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (item.type == 'csharp' || item.type == 'json') {
              onSelectFile?.call(item.name);
            }
          },
          child: Container(
            height: 22,
            padding: EdgeInsets.only(left: 8.0 + (depth * 14.0), right: 6),
            color: isSelected ? const Color(0xFF37373D) : Colors.transparent,
            child: Row(
              children: [
                if (item.children.isNotEmpty)
                  const Icon(Icons.arrow_drop_down, size: 14, color: Color(0xFF9E9E9E))
                else
                  const SizedBox(width: 14),
                const SizedBox(width: 2),
                _buildIconForType(item.type),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFFCCCCCC),
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (item.children.isNotEmpty && item.isExpanded)
          ...item.children.map((c) => _buildTreeItem(c, depth + 1)),
      ],
    );
  }

  Widget _buildIconForType(String type) {
    switch (type) {
      case 'solution':
        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: const Color(0xFF68217A),
            borderRadius: BorderRadius.circular(2),
          ),
          child: const Center(
            child: Text('S', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
          ),
        );
      case 'project':
        return const Icon(Icons.auto_stories, size: 13, color: Color(0xFF007ACC));
      case 'folder':
        return const Icon(Icons.folder, size: 14, color: Color(0xFFDCB67A));
      case 'csharp':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF239120),
            borderRadius: BorderRadius.circular(2),
          ),
          child: const Text('C#', style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.w900)),
        );
      case 'json':
        return const Icon(Icons.data_object, size: 13, color: Color(0xFFF1C40F));
      default:
        return const Icon(Icons.description, size: 13, color: Color(0xFF888888));
    }
  }
}
