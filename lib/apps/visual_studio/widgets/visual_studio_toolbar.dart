import 'package:flutter/material.dart';

class VisualStudioToolbar extends StatelessWidget {
  final String configuration;
  final String platform;
  final bool isDebugging;
  final VoidCallback onToggleDebug;
  final ValueChanged<String>? onConfigurationChanged;
  final ValueChanged<String>? onPlatformChanged;

  const VisualStudioToolbar({
    super.key,
    required this.configuration,
    required this.platform,
    required this.isDebugging,
    required this.onToggleDebug,
    this.onConfigurationChanged,
    this.onPlatformChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      color: const Color(0xFF2D2D30),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          // File / Save icons
          _buildToolIcon(Icons.save, '저장 (Ctrl+S)'),
          _buildToolIcon(Icons.save_as, '모두 저장 (Ctrl+Shift+S)'),
          const SizedBox(width: 6),
          _buildDivider(),
          const SizedBox(width: 6),
          _buildToolIcon(Icons.undo, '실행 취소 (Ctrl+Z)'),
          _buildToolIcon(Icons.redo, '다시 실행 (Ctrl+Y)'),
          const SizedBox(width: 6),
          _buildDivider(),
          const SizedBox(width: 6),

          // Configuration Dropdown (Debug / Release)
          _buildDropdown(
            value: configuration,
            items: ['Debug', 'Release'],
            onChanged: (v) => onConfigurationChanged?.call(v!),
          ),
          const SizedBox(width: 6),

          // Platform Dropdown (Any CPU / x64)
          _buildDropdown(
            value: platform,
            items: ['Any CPU', 'x64', 'ARM64'],
            onChanged: (v) => onPlatformChanged?.call(v!),
          ),
          const SizedBox(width: 8),

          // Start / Debugging Button (Green Play Triangle)
          InkWell(
            onTap: onToggleDebug,
            borderRadius: BorderRadius.circular(3),
            child: Container(
              height: 24,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: isDebugging ? const Color(0xFFB71C1C) : const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Row(
                children: [
                  Icon(
                    isDebugging ? Icons.stop : Icons.play_arrow,
                    size: 15,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isDebugging ? '디버깅 중지 (Shift+F5)' : '시작 (F5)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Step Controls
          _buildToolIcon(Icons.arrow_downward, '한 단계씩 코드 실행 (F11)'),
          _buildToolIcon(Icons.arrow_forward, '프로시저 단위 실행 (F10)'),
          _buildToolIcon(Icons.arrow_upward, '프로시저 나가기 (Shift+F11)'),
          _buildToolIcon(Icons.refresh, '다시 시작 (Ctrl+Shift+F5)'),

          const Spacer(),

          // Live Share / Diagnostic tools
          const Row(
            children: [
              Icon(Icons.group_add, size: 14, color: Color(0xFF007ACC)),
              SizedBox(width: 4),
              Text('Live Share', style: TextStyle(color: Color(0xFFCCCCCC), fontSize: 11)),
              SizedBox(width: 12),
              Icon(Icons.speed, size: 14, color: Color(0xFF854C9E)),
              SizedBox(width: 4),
              Text('성능 프로파일러', style: TextStyle(color: Color(0xFFCCCCCC), fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolIcon(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Icon(icon, size: 15, color: const Color(0xFFB5B5B5)),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 16, color: const Color(0xFF3F3F46));
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF333337),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: const Color(0xFF3F3F46)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: const Color(0xFF2D2D30),
          style: const TextStyle(color: Colors.white, fontSize: 11),
          items: items.map((it) => DropdownMenuItem(value: it, child: Text(it))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
