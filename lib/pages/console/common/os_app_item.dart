import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 데스크톱 및 모바일 가상 OS 공통 앱 아이콘 위젯
class OsAppItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? imageAsset;
  final Color iconColor;
  final Color? backgroundColor;
  final LinearGradient? backgroundGradient;
  final VoidCallback onTap;
  final VoidCallback? onDoubleTap;
  final bool isDesktop;
  final String? badge;

  const OsAppItem({
    super.key,
    required this.title,
    this.icon,
    this.imageAsset,
    this.iconColor = Colors.white,
    this.backgroundColor,
    this.backgroundGradient,
    required this.onTap,
    this.onDoubleTap,
    this.isDesktop = true,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final double iconBoxSize = isDesktop ? 48 : 58;
    final double iconSize = isDesktop ? 26 : 30;
    final double fontSize = isDesktop ? 11 : 12;

    return InkWell(
      onTap: onTap,
      onDoubleTap: onDoubleTap ?? onTap,
      borderRadius: BorderRadius.circular(12),
      hoverColor: Colors.white.withValues(alpha: 0.12),
      child: Container(
        width: isDesktop ? 78 : 70,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: iconBoxSize,
                  height: iconBoxSize,
                  decoration: BoxDecoration(
                    color: backgroundGradient == null
                        ? (backgroundColor ?? iconColor.withValues(alpha: 0.2))
                        : null,
                    gradient: backgroundGradient,
                    borderRadius: BorderRadius.circular(isDesktop ? 12 : 15),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: imageAsset != null
                        ? Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              imageAsset!,
                              width: iconSize,
                              height: iconSize,
                              fit: BoxFit.contain,
                            ),
                          )
                        : Icon(icon ?? CupertinoIcons.circle_fill, color: iconColor, size: iconSize),
                  ),
                ),
                if (badge != null)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                shadows: const [
                  Shadow(color: Colors.black, blurRadius: 4, offset: Offset(0, 1)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}