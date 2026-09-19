import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class _FloatingSpec {
  final String id;
  final String name;
  final String assetPath;
  final double size;
  final Alignment alignment;
  final double floatDistance;
  final double horizontalSway;
  final double phase;
  final double speedMultiplier;
  final Color glowColor;
  final String routePath;

  const _FloatingSpec({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.size,
    required this.alignment,
    required this.floatDistance,
    required this.horizontalSway,
    required this.phase,
    required this.speedMultiplier,
    required this.glowColor,
    required this.routePath,
  });
}

class HomeFloatingHeroIcons extends StatefulWidget {
  final bool isMobile;
  final bool isDarkMode;

  const HomeFloatingHeroIcons({
    super.key,
    required this.isMobile,
    required this.isDarkMode,
  });

  @override
  State<HomeFloatingHeroIcons> createState() => _HomeFloatingHeroIconsState();
}

class _HomeFloatingHeroIconsState extends State<HomeFloatingHeroIcons>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  String? _hoveredId;

  static const List<_FloatingSpec> _specs = [
    // 1. 카카오톡 - 대형 메인
    _FloatingSpec(
      id: 'kakao_large',
      name: '카카오톡',
      assetPath: 'assets/images/kakaotalk_icon.webp',
      size: 92,
      alignment: Alignment(0.42, -0.52),
      floatDistance: 18,
      horizontalSway: 8,
      phase: 0.0,
      speedMultiplier: 1.0,
      glowColor: Color(0xFFFEE500),
      routePath: '/console/editor/kakaotalk',
    ),
    // 2. 블라인드 - 대형
    _FloatingSpec(
      id: 'blind_large',
      name: '블라인드',
      assetPath: 'assets/images/blind_icon.webp',
      size: 82,
      alignment: Alignment(0.85, -0.18),
      floatDistance: 22,
      horizontalSway: 10,
      phase: 1.4,
      speedMultiplier: 0.85,
      glowColor: Color(0xFFE53935),
      routePath: '/console/editor/blind',
    ),
    // 3. 디시인사이드 - 중대형
    _FloatingSpec(
      id: 'dc_large',
      name: '디시인사이드',
      assetPath: 'assets/images/dcinside_icon.webp',
      size: 76,
      alignment: Alignment(0.32, 0.22),
      floatDistance: 16,
      horizontalSway: 9,
      phase: 2.8,
      speedMultiplier: 1.15,
      glowColor: Color(0xFF3B5998),
      routePath: '/console/editor/dcinside',
    ),
    // 4. MS-DOS / CMD - 대형 레트로
    _FloatingSpec(
      id: 'dos_large',
      name: 'MS-DOS 프롬프트',
      assetPath: 'assets/images/windows/cmd.png',
      size: 84,
      alignment: Alignment(0.76, 0.46),
      floatDistance: 20,
      horizontalSway: 12,
      phase: 4.2,
      speedMultiplier: 0.9,
      glowColor: Color(0xFF06B6D4),
      routePath: '/console?os=windows_11',
    ),
    // 5. 카카오톡 - 중소형
    _FloatingSpec(
      id: 'kakao_med',
      name: '카카오톡',
      assetPath: 'assets/images/kakaotalk_icon.webp',
      size: 52,
      alignment: Alignment(0.92, -0.68),
      floatDistance: 14,
      horizontalSway: 6,
      phase: 3.1,
      speedMultiplier: 1.25,
      glowColor: Color(0xFFFEE500),
      routePath: '/console/editor/kakaotalk',
    ),
    // 6. 블라인드 - 중소형
    _FloatingSpec(
      id: 'blind_med',
      name: '블라인드',
      assetPath: 'assets/images/blind_icon.webp',
      size: 48,
      alignment: Alignment(0.18, -0.22),
      floatDistance: 15,
      horizontalSway: 7,
      phase: 0.8,
      speedMultiplier: 1.05,
      glowColor: Color(0xFFE53935),
      routePath: '/console/editor/blind',
    ),
    // 7. 디시인사이드 - 중형
    _FloatingSpec(
      id: 'dc_med',
      name: '디시인사이드',
      assetPath: 'assets/images/dcinside_icon.webp',
      size: 56,
      alignment: Alignment(0.68, -0.36),
      floatDistance: 13,
      horizontalSway: 6,
      phase: 5.0,
      speedMultiplier: 0.95,
      glowColor: Color(0xFF3B5998),
      routePath: '/console/editor/dcinside',
    ),
    // 8. MS-DOS / CMD - 중소형
    _FloatingSpec(
      id: 'dos_med',
      name: 'MS-DOS',
      assetPath: 'assets/images/windows/cmd.png',
      size: 50,
      alignment: Alignment(0.48, 0.68),
      floatDistance: 17,
      horizontalSway: 8,
      phase: 2.1,
      speedMultiplier: 1.2,
      glowColor: Color(0xFF06B6D4),
      routePath: '/console?os=windows_11',
    ),
    // 9. 카카오톡 - 미니 귀여운 억센트
    _FloatingSpec(
      id: 'kakao_small',
      name: '카카오톡',
      assetPath: 'assets/images/kakaotalk_icon.webp',
      size: 38,
      alignment: Alignment(0.94, 0.18),
      floatDistance: 11,
      horizontalSway: 5,
      phase: 4.8,
      speedMultiplier: 1.35,
      glowColor: Color(0xFFFEE500),
      routePath: '/console/editor/kakaotalk',
    ),
    // 10. 디시인사이드 - 미니 억센트
    _FloatingSpec(
      id: 'dc_small',
      name: '디시인사이드',
      assetPath: 'assets/images/dcinside_icon.webp',
      size: 36,
      alignment: Alignment(0.24, 0.58),
      floatDistance: 12,
      horizontalSway: 5,
      phase: 1.9,
      speedMultiplier: 1.1,
      glowColor: Color(0xFF3B5998),
      routePath: '/console/editor/dcinside',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = widget.isMobile;
    final scaleFactor = isMobile ? 0.68 : 1.0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final progress = _controller.value;

        return Stack(
          fit: StackFit.expand,
          children: _specs.map((spec) {
            final cycle = (progress * spec.speedMultiplier * 2 * math.pi) + spec.phase;
            final dy = math.sin(cycle) * spec.floatDistance * scaleFactor;
            final dx = math.cos(cycle * 0.7) * spec.horizontalSway * scaleFactor;
            final rotation = math.sin(cycle * 0.8) * 0.05; // natural gentle sway

            final isHovered = _hoveredId == spec.id;
            final targetSize = spec.size * scaleFactor;

            return Align(
              alignment: spec.alignment,
              child: Transform.translate(
                offset: Offset(dx, dy),
                child: Transform.rotate(
                  angle: rotation,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => _hoveredId = spec.id),
                    onExit: (_) => setState(() => _hoveredId = null),
                    child: GestureDetector(
                      onTap: () => context.go(spec.routePath),
                      child: AnimatedScale(
                        scale: isHovered ? 1.15 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutBack,
                        child: Tooltip(
                          message: '${spec.name} 에디터 바로가기',
                          child: Container(
                            width: targetSize,
                            height: targetSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: spec.glowColor.withValues(
                                    alpha: widget.isDarkMode
                                        ? (isHovered ? 0.55 : 0.28)
                                        : (isHovered ? 0.40 : 0.18),
                                  ),
                                  blurRadius: isHovered ? 28 : 16,
                                  spreadRadius: isHovered ? 4 : 1,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(targetSize * 0.24),
                              child: Image.asset(
                                spec.assetPath,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
