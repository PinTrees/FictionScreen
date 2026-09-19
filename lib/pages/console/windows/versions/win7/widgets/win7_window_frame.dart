import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Windows 7 순정 에어로 글래스(Aero Glass) 창 프레임
/// - 실시간 유리 블러 (ImageFilter.blur)
/// - 하늘색 반투명 그라디언트 + 상단 수평 광택 줄(Specular Gloss Stripe)
/// - 8px 라운드 모서리 + 1px 에어로 글래스 림(Rim) 보더
/// - Segoe UI 흰색 텍스트 글로우 (White Text Glow)
/// - 보석 같은 루비 레드 닫기 버튼을 포함한 3연속 에어로 캡슐 버튼
class Win7WindowFrame extends StatefulWidget {
  final String title;
  final String? iconAsset;
  final IconData? iconData;
  final Widget child;
  final double width;
  final double height;
  final bool isMaximized;
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(int layoutType, int zoneIndex)? onSnapLayout;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final Color aeroColor;

  const Win7WindowFrame({
    super.key,
    required this.title,
    this.iconAsset,
    this.iconData,
    required this.child,
    this.width = 820,
    this.height = 540,
    this.isMaximized = false,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onSnapLayout,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.aeroColor = const Color(0xFF6BA4D8), // 순정 Windows 7 Sky Blue Aero Tint
  });

  @override
  State<Win7WindowFrame> createState() => _Win7WindowFrameState();
}

class _Win7WindowFrameState extends State<Win7WindowFrame> {
  bool _isHoveredClose = false;
  bool _isHoveredMax = false;
  bool _isHoveredMin = false;

  @override
  Widget build(BuildContext context) {
    final isMaximized = widget.isMaximized;
    final borderRadius = isMaximized ? BorderRadius.zero : BorderRadius.circular(8);

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: isMaximized
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.55),
                  blurRadius: 22,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.25),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              // 에어로 글래스 다층 그라디언트 (유리빛 반투명)
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.aeroColor.withValues(alpha: 0.85),
                  widget.aeroColor.withValues(alpha: 0.65),
                  const Color(0xFF2C5680).withValues(alpha: 0.75),
                ],
                stops: const [0.0, 0.35, 1.0],
              ),
              borderRadius: borderRadius,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.45),
                width: 1.0,
              ),
            ),
            child: Stack(
              children: [
                // 상단 에어로 글래스 광택 반사광 줄 (Specular Stripe)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 14,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.55),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                  ),
                ),

                // 창 전체 레이아웃 (타이틀바 + 내부 본문)
                Column(
                  children: [
                    // 1. Windows 7 에어로 타이틀바 (높이 30px)
                    _buildWin7TitleBar(),

                    // 2. 내부 클라이언트 뷰 영역
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: isMaximized ? BorderRadius.zero : BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.35),
                            width: 1.0,
                          ),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1)),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: widget.child,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWin7TitleBar() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onDoubleTap: widget.onMaximize,
      onPanStart: widget.onTitleDragStart,
      onPanUpdate: widget.onTitleDragUpdate,
      child: Container(
        height: 30,
        padding: const EdgeInsets.only(left: 8, right: 4),
        child: Row(
          children: [
            // 앱 아이콘 (16x16)
            if (widget.iconAsset != null)
              Image.asset(
                widget.iconAsset!,
                width: 16,
                height: 16,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  CupertinoIcons.app,
                  size: 16,
                  color: Colors.white,
                ),
              )
            else if (widget.iconData != null)
              Icon(widget.iconData, size: 16, color: Colors.white),

            const SizedBox(width: 8),

            // Windows 7 시그니처 텍스트 (흰색 후광 번짐 효과)
            Expanded(
              child: Text(
                widget.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Segoe UI',
                  shadows: [
                    Shadow(color: Colors.white, blurRadius: 10),
                    Shadow(color: Colors.white, blurRadius: 6),
                    Shadow(color: Colors.white, blurRadius: 3),
                  ],
                ),
              ),
            ),

            // 우측 에어로 캡슐 캡션 버튼 3종 (최소화, 최대화, 닫기)
            _buildAeroCaptionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildAeroCaptionButtons() {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 0.8),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. 최소화 버튼
          MouseRegion(
            onEnter: (_) => setState(() => _isHoveredMin = true),
            onExit: (_) => setState(() => _isHoveredMin = false),
            child: GestureDetector(
              onTap: widget.onMinimize,
              child: Container(
                width: 28,
                height: 20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: _isHoveredMin
                        ? [const Color(0xFFBFE0FF), const Color(0xFF6EB7F5)]
                        : [Colors.white.withValues(alpha: 0.45), Colors.white.withValues(alpha: 0.15)],
                  ),
                  border: const Border(right: BorderSide(color: Colors.black12, width: 0.8)),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 8,
                  height: 2,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          // 2. 최대화 / 복원 버튼
          MouseRegion(
            onEnter: (_) => setState(() => _isHoveredMax = true),
            onExit: (_) => setState(() => _isHoveredMax = false),
            child: GestureDetector(
              onTap: widget.onMaximize,
              child: Container(
                width: 28,
                height: 20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: _isHoveredMax
                        ? [const Color(0xFFBFE0FF), const Color(0xFF6EB7F5)]
                        : [Colors.white.withValues(alpha: 0.45), Colors.white.withValues(alpha: 0.15)],
                  ),
                  border: const Border(right: BorderSide(color: Colors.black12, width: 0.8)),
                ),
                alignment: Alignment.center,
                child: widget.isMaximized
                    ? SizedBox(
                        width: 9,
                        height: 9,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black87, width: 1.0),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black87, width: 1.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87, width: 1.0),
                        ),
                      ),
              ),
            ),
          ),

          // 3. 루비 레드 에어로 닫기 버튼
          MouseRegion(
            onEnter: (_) => setState(() => _isHoveredClose = true),
            onExit: (_) => setState(() => _isHoveredClose = false),
            child: GestureDetector(
              onTap: widget.onClose,
              child: Container(
                width: 44,
                height: 20,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: _isHoveredClose
                        ? [const Color(0xFFFF5C5C), const Color(0xFFD61818)]
                        : [const Color(0xFFE27474).withValues(alpha: 0.85), const Color(0xFFA82E2E).withValues(alpha: 0.9)],
                  ),
                  boxShadow: _isHoveredClose
                      ? [
                          BoxShadow(
                            color: const Color(0xFFFF3B30).withValues(alpha: 0.6),
                            blurRadius: 6,
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  CupertinoIcons.xmark,
                  size: 11,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
