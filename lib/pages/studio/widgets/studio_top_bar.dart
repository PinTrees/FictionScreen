import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../apps/screen_template.dart';

/// 스튜디오 최상단 컨트롤 오버레이 바
class StudioTopBar extends StatelessWidget {
  final ScreenTemplate template;
  final bool showFrame;
  final bool isExporting;
  final bool isDarkMode;
  final VoidCallback onToggleFrame;
  final VoidCallback onExport;
  final VoidCallback onToggleTheme;

  const StudioTopBar({
    super.key,
    required this.template,
    required this.showFrame,
    required this.isExporting,
    required this.isDarkMode,
    required this.onToggleFrame,
    required this.onExport,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkMode ? const Color(0xFF12141D) : Colors.white;
    final borderColor = isDarkMode ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0);
    final textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(CupertinoIcons.arrow_left, color: textColor, size: 20),
            onPressed: () => context.canPop() ? context.pop() : context.go('/console'),
          ),
          const SizedBox(width: 8),
          Icon(template.icon, color: template.themeColor, size: 18),
          const SizedBox(width: 8),
          Text(
            template.title,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(width: 12),

          // 안내 뱃지
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.hand_point_right_fill, color: Color(0xFFA5B4FC), size: 13),
                    SizedBox(width: 6),
                    Text(
                      '화면의 텍스트나 항목을 터치하면 바로 수정할 수 있습니다',
                      style: TextStyle(color: Color(0xFFA5B4FC), fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // 다크/라이트 모드 토글
          IconButton(
            tooltip: isDarkMode ? '라이트 모드로 전환' : '다크 모드로 전환',
            icon: Icon(
              isDarkMode ? CupertinoIcons.sun_max_fill : CupertinoIcons.moon_fill,
              color: isDarkMode ? const Color(0xFFFACC15) : const Color(0xFF64748B),
              size: 19,
            ),
            onPressed: onToggleTheme,
          ),

          const SizedBox(width: 4),

          // 디바이스 프레임 토글 버튼
          IconButton(
            tooltip: showFrame ? '프레임 숨기기' : '프레임 씌우기',
            icon: Icon(
              showFrame ? CupertinoIcons.device_phone_portrait : CupertinoIcons.square,
              color: isDarkMode ? Colors.white70 : const Color(0xFF475569),
              size: 20,
            ),
            onPressed: onToggleFrame,
          ),

          const SizedBox(width: 8),

          // 캡처 저장 버튼
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: isExporting
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(CupertinoIcons.arrow_down_doc_fill, size: 16),
            label: Text(isExporting ? '저장 중...' : '이미지 저장', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            onPressed: isExporting ? null : onExport,
          ),
        ],
      ),
    );
  }
}
