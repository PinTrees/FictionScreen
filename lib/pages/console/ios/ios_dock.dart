import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// iPhone iOS 하단 4칸 글래스 독 & 홈 인디케이터
class IosDock extends StatelessWidget {
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;

  const IosDock({
    super.key,
    required this.onOpenTemplate,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 글래스 독
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDockIconButton(
                    CupertinoIcons.phone_fill,
                    const Color(0xFF10B981),
                    () {},
                  ),
                  _buildDockIconButton(
                    CupertinoIcons.compass,
                    const Color(0xFF3B82F6),
                    () {},
                  ),
                  _buildDockIconButton(
                    CupertinoIcons.chat_bubble_2_fill,
                    const Color(0xFFFEE500),
                    () => onOpenTemplate('kakaotalk'),
                    iconColor: Colors.black,
                  ),
                  _buildDockIconButton(
                    CupertinoIcons.gear_alt_fill,
                    const Color(0xFF64748B),
                    onOpenSettings,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // 홈 제스처 인디케이터 바
        Center(
          child: Container(
            width: 140,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDockIconButton(
    IconData icon,
    Color bg,
    VoidCallback onTap, {
    Color iconColor = Colors.white,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: 28),
      ),
    );
  }
}