import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// iPhone iOS 하단 4칸 글래스 독 & 홈 인디케이터
class IosDock extends StatelessWidget {
  final Function(String templateId) onOpenTemplate;
  final Function(String appId) onOpenApp;
  final VoidCallback onOpenSettings;

  const IosDock({
    super.key,
    required this.onOpenTemplate,
    required this.onOpenApp,
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
                    icon: CupertinoIcons.phone_fill,
                    bg: const Color(0xFF34C759),
                    onTap: () => onOpenApp('phone'),
                  ),
                  _buildDockIconButton(
                    icon: CupertinoIcons.compass,
                    bg: const Color(0xFF007AFF),
                    onTap: () => onOpenApp('safari'),
                  ),
                  _buildDockIconButton(
                    icon: null,
                    imageAsset: 'assets/images/kakaotalk_icon.webp',
                    bg: const Color(0xFFFEE500),
                    onTap: () => onOpenTemplate('kakaotalk'),
                    iconColor: Colors.black,
                  ),
                  _buildDockIconButton(
                    icon: CupertinoIcons.gear_alt_fill,
                    bg: const Color(0xFF636366),
                    onTap: () => onOpenApp('settings'),
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

  Widget _buildDockIconButton({
    IconData? icon,
    String? imageAsset,
    required Color bg,
    required VoidCallback onTap,
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: imageAsset != null
              ? Image.asset(imageAsset, fit: BoxFit.cover)
              : (icon != null ? Icon(icon, color: iconColor, size: 28) : const SizedBox()),
        ),
      ),
    );
  }
}
