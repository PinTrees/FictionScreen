import 'package:flutter/material.dart';

class DavinciTopMenu extends StatelessWidget {
  final String projectName;
  final String resolution;
  final VoidCallback onEditStory;

  const DavinciTopMenu({
    super.key,
    required this.projectName,
    required this.resolution,
    required this.onEditStory,
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = ['DaVinci Resolve', 'File', 'Edit', 'Trim', 'Timeline', 'Clip', 'Mark', 'View', 'Playback', 'Color', 'Nodes', 'Help'];

    return Container(
      color: const Color(0xFF141416),
      child: Column(
        children: [
          // 1. Title bar (30px)
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: const Color(0xFF121214),
            child: Row(
              children: [
                // DaVinci 3-Color Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: const Color(0xFFE53935).withValues(alpha: 0.5)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.palette, color: Color(0xFFE53935), size: 12),
                      SizedBox(width: 4),
                      Text(
                        'RESOLVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Project & Resolution
                Expanded(
                  child: Text(
                    'DaVinci Resolve Studio - $projectName  [$resolution]',
                    style: const TextStyle(
                      color: Color(0xFFB0B0B5),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Scenario edit button
                InkWell(
                  onTap: onEditStory,
                  borderRadius: BorderRadius.circular(3),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935).withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: const Color(0xFFE53935)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.tune, color: Color(0xFFFF8A80), size: 12),
                        SizedBox(width: 4),
                        Text(
                          '색보정/타임라인 편집',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Window action dots
                const Row(
                  children: [
                    Icon(Icons.remove, size: 13, color: Colors.white38),
                    SizedBox(width: 8),
                    Icon(Icons.crop_square, size: 12, color: Colors.white38),
                    SizedBox(width: 8),
                    Icon(Icons.close, size: 13, color: Colors.white38),
                  ],
                ),
              ],
            ),
          ),

          // 2. Menu bar (24px)
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            color: const Color(0xFF1B1B1E),
            child: Row(
              children: menuItems.map((menu) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    menu,
                    style: const TextStyle(
                      color: Color(0xFFCCCCCC),
                      fontSize: 11,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
