import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Windows XP 순정 루나(Luna) 창 프레임
/// - 로열 블루 그라데이션 상단 타이틀바 (`Color(0xFF0055EA)` ~ `Color(0xFF0033B3)`)
/// - 8px 둥근 상단 모서리 & 3px 볼록 블루 외곽선
/// - 트레뷰셋 MS(Trebuchet MS) 스타일 볼드 타이틀 + 어두운 블루 그림자
/// - 루나 시그니처 3D 캡션 버튼 (`─`, `▢`, 루비 레드 `✕`)
class WinXpWindowFrame extends StatelessWidget {
  final String title;
  final String? iconAsset;
  final IconData? iconData;
  final Widget child;
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;
  final bool isMaximized;

  const WinXpWindowFrame({
    super.key,
    required this.title,
    this.iconAsset,
    this.iconData,
    required this.child,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 780,
    this.height = 520,
    this.isMaximized = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFECE9D8), // Windows XP 기본 대화상자/창 배경 베이지
        borderRadius: isMaximized
            ? BorderRadius.zero
            : const BorderRadius.vertical(top: Radius.circular(8)),
        border: isMaximized
            ? null
            : Border.all(
                color: const Color(0xFF0055EA),
                width: 3.5,
              ),
        boxShadow: isMaximized
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.55),
                  blurRadius: 18,
                  offset: const Offset(2, 6),
                ),
              ],
      ),
      child: Column(
        children: [
          // 1. Windows XP 루나 블루 상단 타이틀 바
          GestureDetector(
            onPanStart: onTitleDragStart,
            onPanUpdate: onTitleDragUpdate,
            onDoubleTap: onMaximize,
            child: Container(
              height: 29,
              decoration: BoxDecoration(
                borderRadius: isMaximized
                    ? BorderRadius.zero
                    : const BorderRadius.vertical(top: Radius.circular(5)),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0058EE), // 상단 브라이트 블루
                    Color(0xFF3593FF), // 상단 반사광 하이라이트
                    Color(0xFF288EFF),
                    Color(0xFF0055EA),
                    Color(0xFF0040C8), // 하단 딥 로열 블루
                  ],
                  stops: [0.0, 0.15, 0.4, 0.7, 1.0],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF002D88),
                    offset: Offset(0, 1),
                    blurRadius: 0,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  // 앱 아이콘 (16x16)
                  if (iconAsset != null)
                    Image.asset(
                      iconAsset!,
                      width: 16,
                      height: 16,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        CupertinoIcons.app,
                        size: 16,
                        color: Colors.white,
                      ),
                    )
                  else if (iconData != null)
                    Icon(iconData, size: 16, color: Colors.white),

                  const SizedBox(width: 6),

                  // 윈도우 타이틀 (볼드 + 음영 그림자)
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Segoe UI',
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                        shadows: [
                          Shadow(
                            color: Color(0xFF002266),
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // 루나 3D 캡션 버튼 그룹 (─, ▢, ✕)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 최소화 버튼
                      _WinXpCaptionButton(
                        icon: const Icon(CupertinoIcons.minus, size: 11, color: Colors.white),
                        onTap: onMinimize,
                        isClose: false,
                        tooltip: '최소화',
                      ),
                      const SizedBox(width: 2),

                      // 최대화 / 이전 크기 버튼
                      _WinXpCaptionButton(
                        icon: Icon(
                          isMaximized ? CupertinoIcons.square_on_square : CupertinoIcons.square,
                          size: 11,
                          color: Colors.white,
                        ),
                        onTap: onMaximize,
                        isClose: false,
                        tooltip: isMaximized ? '이전 크기로 복원' : '최대화',
                      ),
                      const SizedBox(width: 2),

                      // 닫기 버튼 (빨간색 루나 3D)
                      _WinXpCaptionButton(
                        icon: const Icon(CupertinoIcons.xmark, size: 11, color: Colors.white),
                        onTap: onClose,
                        isClose: true,
                        tooltip: '닫기',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 2. 창 내부 콘텐츠 영역
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// Windows XP 시그니처 3D 볼록 캡션 버튼
class _WinXpCaptionButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback? onTap;
  final bool isClose;
  final String tooltip;

  const _WinXpCaptionButton({
    required this.icon,
    required this.onTap,
    this.isClose = false,
    required this.tooltip,
  });

  @override
  State<_WinXpCaptionButton> createState() => _WinXpCaptionButtonState();
}

class _WinXpCaptionButtonState extends State<_WinXpCaptionButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // 버튼 색상: 닫기는 강렬한 오렌지-레드, 최소화/최대화는 블루-실버
    final List<Color> normalGradient = widget.isClose
        ? const [Color(0xFFE2614E), Color(0xFFC7301B), Color(0xFFA81C08)]
        : const [Color(0xFF3F8CFF), Color(0xFF1E6BE6), Color(0xFF0F50C2)];

    final List<Color> hoverGradient = widget.isClose
        ? const [Color(0xFFFF8270), Color(0xFFEE4932), Color(0xFFC7240E)]
        : const [Color(0xFF68A5FF), Color(0xFF3982F7), Color(0xFF1C60D9)];

    final List<Color> pressedGradient = widget.isClose
        ? const [Color(0xFFB81F0C), Color(0xFFD6341F), Color(0xFFE8503C)]
        : const [Color(0xFF0C46A8), Color(0xFF1659C9), Color(0xFF2870E8)];

    final currentColors = _isPressed
        ? pressedGradient
        : (_isHovered ? hoverGradient : normalGradient);

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() {
          _isHovered = false;
          _isPressed = false;
        }),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: widget.onTap,
          child: Container(
            width: 21,
            height: 21,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: currentColors,
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.9),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  offset: const Offset(1, 1),
                  blurRadius: 1,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: widget.icon,
          ),
        ),
      ),
    );
  }
}
