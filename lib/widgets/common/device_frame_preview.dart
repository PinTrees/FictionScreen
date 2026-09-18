import 'package:flutter/material.dart';

class DeviceFramePreview extends StatelessWidget {
  final Widget child;
  final bool showFrame;
  final bool isDesktop;
  final double scale;

  const DeviceFramePreview({
    super.key,
    required this.child,
    this.showFrame = true,
    this.isDesktop = false,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return _buildDesktopFrame();
    }
    return _buildPhoneFrame();
  }

  Widget _buildPhoneFrame() {
    const double screenWidth = 380;
    const double screenHeight = 800;

    if (!showFrame) {
      return Container(
        width: screenWidth * scale,
        height: screenHeight * scale,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Transform.scale(
          scale: scale,
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: child,
          ),
        ),
      );
    }

    // 아이폰 스타일 외형 프레임
    return Container(
      padding: EdgeInsets.all(12 * scale),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E24),
        borderRadius: BorderRadius.circular(52 * scale),
        border: Border.all(
          color: const Color(0xFF3F3F4E),
          width: 3.5 * scale,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 36,
            spreadRadius: 4,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: screenWidth * scale,
            height: screenHeight * scale,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40 * scale),
            ),
            clipBehavior: Clip.antiAlias,
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: screenWidth,
                height: screenHeight,
                child: child,
              ),
            ),
          ),

          // 다이내믹 아일랜드 노치
          Positioned(
            top: 10 * scale,
            child: Container(
              width: 105 * scale,
              height: 28 * scale,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18 * scale),
              ),
            ),
          ),

          // 하단 홈 바
          Positioned(
            bottom: 8 * scale,
            child: Container(
              width: 130 * scale,
              height: 4.5 * scale,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(3 * scale),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFrame() {
    const double screenWidth = 760;
    const double screenHeight = 480;

    if (!showFrame) {
      return Container(
        width: screenWidth * scale,
        height: screenHeight * scale,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 30,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Transform.scale(
          scale: scale,
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: child,
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(10 * scale),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E22),
        borderRadius: BorderRadius.circular(14 * scale),
        border: Border.all(color: const Color(0xFF33333E), width: 2 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: screenWidth * scale,
            height: screenHeight * scale,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6 * scale),
            ),
            clipBehavior: Clip.antiAlias,
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: screenWidth,
                height: screenHeight,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
