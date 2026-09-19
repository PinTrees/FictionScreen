import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/steam_model.dart';

class SteamToastPopup extends StatelessWidget {
  final SteamToastData toast;
  final VoidCallback onDismiss;

  const SteamToastPopup({
    super.key,
    required this.toast,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final isAchievement = toast.type == 'achievement';

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1.0 - value) * 40),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0E141D),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF66C0F4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF66C0F4).withValues(alpha: 0.35),
              blurRadius: 16,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
            const BoxShadow(
              color: Colors.black87,
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 스팀 배너 및 닫기 버튼
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Image.asset(
                    'assets/images/steam_icon.webp',
                    width: 14,
                    height: 14,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isAchievement ? 'STEAM • 도전 과제 달성!' : 'STEAM • 친구 알림',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    color: Color(0xFF66C0F4),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: onDismiss,
                  child: const Icon(CupertinoIcons.xmark, size: 12, color: Colors.white54),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 내용 (트로피 아이콘 + 타이틀)
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isAchievement
                        ? const Color(0xFFD4AF37).withValues(alpha: 0.2)
                        : const Color(0xFF90BA3C).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isAchievement ? const Color(0xFFD4AF37) : const Color(0xFF90BA3C),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    isAchievement ? CupertinoIcons.rosette : CupertinoIcons.game_controller_solid,
                    color: isAchievement ? const Color(0xFFD4AF37) : const Color(0xFF90BA3C),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        toast.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        toast.subtitle,
                        style: const TextStyle(
                          color: Color(0xFFC7D5E0),
                          fontSize: 11,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
