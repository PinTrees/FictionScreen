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

  // Exactly 6 unique icons (NO duplicates, enlarged sizes):
  // KakaoTalk, Instagram, Naver, Blind, Toss, DC Inside
  static const List<_FloatingSpec> _specs = [
    // 1. 카카오톡 (KakaoTalk) - 대형
    _FloatingSpec(
      id: 'kakaotalk',
      name: '카카오톡',
      assetPath: 'assets/images/kakaotalk_icon.webp',
      size: 124,
      alignment: Alignment(0.46, -0.62),
      floatDistance: 20,
      horizontalSway: 8,
      phase: 0.0,
      speedMultiplier: 1.0,
      glowColor: Color(0xFFFEE500),
      routePath: '/console/editor/kakaotalk',
    ),
    // 2. 인스타그램 (Instagram) - 대형
    _FloatingSpec(
      id: 'instagram',
      name: '인스타그램',
      assetPath: 'assets/images/instagram_icon.webp',
      size: 118,
      alignment: Alignment(0.88, -0.35),
      floatDistance: 22,
      horizontalSway: 10,
      phase: 1.5,
      speedMultiplier: 0.88,
      glowColor: Color(0xFFE1306C),
      routePath: '/console/editor/instagram',
    ),
    // 3. 네이버 (Naver) - 대형
    _FloatingSpec(
      id: 'naver',
      name: '네이버',
      assetPath: 'assets/images/naver_icon.webp',
      size: 112,
      alignment: Alignment(0.24, -0.06),
      floatDistance: 18,
      horizontalSway: 9,
      phase: 3.2,
      speedMultiplier: 1.1,
      glowColor: Color(0xFF03C75A),
      routePath: '/console/editor/naver',
    ),
    // 4. 블라인드 (Blind) - 대형
    _FloatingSpec(
      id: 'blind',
      name: '블라인드',
      assetPath: 'assets/images/blind_icon.webp',
      size: 122,
      alignment: Alignment(0.80, 0.18),
      floatDistance: 24,
      horizontalSway: 11,
      phase: 4.6,
      speedMultiplier: 0.92,
      glowColor: Color(0xFFE53935),
      routePath: '/console/editor/blind',
    ),
    // 5. 토스 (Toss) - 대형
    _FloatingSpec(
      id: 'toss',
      name: '토스',
      assetPath: 'assets/images/toss_icon.webp',
      size: 115,
      alignment: Alignment(0.38, 0.54),
      floatDistance: 19,
      horizontalSway: 8,
      phase: 2.3,
      speedMultiplier: 1.18,
      glowColor: Color(0xFF0064FF),
      routePath: '/console/editor/toss',
    ),
    // 6. 디시인사이드 (DC Inside) - 대형
    _FloatingSpec(
      id: 'dcinside',
      name: '디시인사이드',
      assetPath: 'assets/images/dcinside_icon.webp',
      size: 110,
      alignment: Alignment(0.84, 0.68),
      floatDistance: 21,
      horizontalSway: 10,
      phase: 5.7,
      speedMultiplier: 0.95,
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
    final scaleFactor = isMobile ? 0.65 : 1.0;

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
            final rotation = math.sin(cycle * 0.8) * 0.045;

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
                        scale: isHovered ? 1.14 : 1.0,
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
                                        ? (isHovered ? 0.65 : 0.35)
                                        : (isHovered ? 0.50 : 0.22),
                                  ),
                                  blurRadius: isHovered ? 36 : 22,
                                  spreadRadius: isHovered ? 5 : 2,
                                  offset: const Offset(0, 10),
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
