import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ios26_jiggle.dart';

/// iOS 26 순정 멀티 레이어 리퀴드 스쿼클 앱 아이콘
/// - 프레스 스케일 애니메이션 + 프리즘 림 하이라이트 + 알림 배지
/// - 롱프레스 홈 화면 편집 모드 (Jiggle 흔들림 + 삭제 '-' 배지)
class Ios26AppIcon extends StatefulWidget {
  final String title;
  final String? imageAsset;
  final Widget? customIcon;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDelete;
  final int? badgeCount;
  final double size;
  final bool isEditMode;
  final int index;

  const Ios26AppIcon({
    super.key,
    required this.title,
    this.imageAsset,
    this.customIcon,
    required this.onTap,
    this.onLongPress,
    this.onDelete,
    this.badgeCount,
    this.size = 60.0,
    this.isEditMode = false,
    this.index = 0,
  });

  @override
  State<Ios26AppIcon> createState() => _Ios26AppIconState();
}

class _Ios26AppIconState extends State<Ios26AppIcon> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    Widget iconContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. 아이콘 본체
        AnimatedScale(
          scale: _isPressed && !widget.isEditMode ? 0.88 : 1.0,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              widget.imageAsset != null && widget.imageAsset!.contains('icons26')
                  ? SizedBox(
                      width: widget.size,
                      height: widget.size,
                      child: Image.asset(
                        widget.imageAsset!,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
                    )
                  : Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(widget.size * 0.23),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.28),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.12),
                            blurRadius: 1,
                            spreadRadius: 0.5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(widget.size * 0.23),
                        child: Stack(
                          children: [
                            // 아이콘 본체 이미지
                            Positioned.fill(
                              child: widget.customIcon ??
                                  (widget.imageAsset != null
                                      ? Image.asset(widget.imageAsset!, fit: BoxFit.cover)
                                      : Container(color: const Color(0xFF1E293B))),
                            ),

                            // iOS 26 리퀴드 글래스 표면 광택 오버레이
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.22),
                                      Colors.white.withValues(alpha: 0.0),
                                      Colors.white.withValues(alpha: 0.08),
                                    ],
                                    stops: const [0.0, 0.45, 1.0],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

              // 빨간색 알림 배지 (일반 모드일 때만 노출)
              if (!widget.isEditMode &&
                  widget.badgeCount != null &&
                  widget.badgeCount! > 0)
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

              // 홈 화면 편집 모드 시 순정 '-' 삭제/숨김 배지
              if (widget.isEditMode)
                Positioned(
                  top: -6,
                  left: -6,
                  child: GestureDetector(
                    onTap: widget.onDelete,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF48484A),
                        border: Border.all(color: Colors.white, width: 1.5),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.minus,
                          color: Colors.white,
                          size: 13,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // 2. 앱 타이틀 (순정 텍스트 섀도우)
        if (widget.title.isNotEmpty) ...[
          const SizedBox(height: 5),
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
      ],
    );

    // 편집 모드일 때 iOS 순정 지글(Jiggle) 흔들림 적용
    if (widget.isEditMode) {
      iconContent = Ios26Jiggle(
        isJiggling: true,
        index: widget.index,
        child: iconContent,
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.isEditMode ? null : (_) => setState(() => _isPressed = true),
      onTapUp: widget.isEditMode
          ? null
          : (_) {
              setState(() => _isPressed = false);
              widget.onTap();
            },
      onTapCancel: () => setState(() => _isPressed = false),
      onLongPress: widget.onLongPress,
      child: iconContent,
    );
  }
}
