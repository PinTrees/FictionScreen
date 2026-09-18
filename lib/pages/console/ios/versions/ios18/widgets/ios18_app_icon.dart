import 'package:flutter/material.dart';

/// iOS 18 순정 스쿼클 앱 아이콘 (프레스 스케일 애니메이션 + 그림자 + 알림 배지)
class Ios18AppIcon extends StatefulWidget {
  final String title;
  final String? imageAsset;
  final Widget? customIcon;
  final VoidCallback onTap;
  final int? badgeCount;
  final double size;

  const Ios18AppIcon({
    super.key,
    required this.title,
    this.imageAsset,
    this.customIcon,
    required this.onTap,
    this.badgeCount,
    this.size = 60.0,
  });

  @override
  State<Ios18AppIcon> createState() => _Ios18AppIconState();
}

class _Ios18AppIconState extends State<Ios18AppIcon> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. 아이콘 본체 (스케일 애니메이션 + 그림자 + 배지)
          AnimatedScale(
            scale: _isPressed ? 0.88 : 1.0,
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOutCubic,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.size * 0.225),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.size * 0.225),
                    child: widget.customIcon ??
                        (widget.imageAsset != null
                            ? Image.asset(widget.imageAsset!, fit: BoxFit.cover)
                            : Container(color: const Color(0xFF1E293B))),
                  ),
                ),

                // 빨간색 알림 배지 (메시지, 메일, 카톡 등)
                if (widget.badgeCount != null && widget.badgeCount! > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF3B30),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(
                        widget.badgeCount! > 99 ? '99+' : '${widget.badgeCount}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 5),

          // 2. 앱 타이틀 (순정 텍스트 섀도우)
          Text(
            widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.2,
              shadows: [
                Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
