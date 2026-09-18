import 'dart:ui';
import 'package:flutter/material.dart';

/// Apple WWDC 2025 / iOS 26 공식 리퀴드 글래스 (Liquid Glass) 광학 렌더러
/// - 고굴절 가우시안 백드롭 블러 (sigma 38)
/// - 유체 표면장력 메니스커스 곡률 그라데이션
/// - 애플 순정 코너 글로우(Corner Glow) & 상단 스펙큘러 하이라이트
/// - 다층 앰비언트 심도 그림자
class Ios26LiquidGlass extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final bool hasCornerGlow;
  final bool hasChromaticAberration;
  final double blurSigma;
  final Color? tintColor;

  const Ios26LiquidGlass({
    super.key,
    required this.child,
    this.borderRadius = 36.0,
    this.padding = EdgeInsets.zero,
    this.margin,
    this.width,
    this.height,
    this.hasCornerGlow = true,
    this.hasChromaticAberration = true,
    this.blurSigma = 38.0,
    this.tintColor,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: radius,
        // 다층 유체 앰비언트 심도 그림자
        boxShadow: [
          // 1. 깊은 소프트 드롭 섀도우 (바닥으로부터 띄워진 입체 부유감)
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.32),
            blurRadius: 32,
            spreadRadius: 1,
            offset: const Offset(0, 14),
          ),
          // 2. 근접 컨택 섀도우 (형체 윤곽 안정화)
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          // 3. 외곽 코스틱 빛 번짐 림
          BoxShadow(
            color: const Color(0xFF80D8FF).withValues(alpha: 0.16),
            blurRadius: 2,
            spreadRadius: 0.5,
          ),
        ],
        // 굴절 테두리 (상단 림 하이라이트)
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.38),
          width: 1.1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - 1.1),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurSigma,
            sigmaY: blurSigma,
          ),
          child: Container(
            decoration: BoxDecoration(
              // 리퀴드 글래스 메니스커스 투과 그라데이션
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  (tintColor ?? Colors.white).withValues(alpha: 0.36), // 상단 표면장력 림
                  (tintColor ?? Colors.white).withValues(alpha: 0.14), // 유리 본체 상부
                  (tintColor ?? Colors.white).withValues(alpha: 0.05), // 중앙 고투과 렌즈
                  (tintColor ?? Colors.white).withValues(alpha: 0.22), // 하단 굴절 바운스광
                ],
                stops: const [0.0, 0.22, 0.68, 1.0],
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 1. Apple iOS 26 코너 글로우 (Corner Glow) - 좌측 상단 모서리
                if (hasCornerGlow)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: IgnorePointer(
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.topLeft,
                            radius: 1.0,
                            colors: [
                              Colors.white.withValues(alpha: 0.42),
                              Colors.white.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // 2. Apple iOS 26 코너 글로우 (Corner Glow) - 우측 상단 모서리
                if (hasCornerGlow)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IgnorePointer(
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.topRight,
                            radius: 1.0,
                            colors: [
                              Colors.white.withValues(alpha: 0.32),
                              Colors.white.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // 3. 상단 1.2px 정밀 스펙큘러 유체 반사선 (Top Specular Sheen)
                Positioned(
                  top: 0,
                  left: 18,
                  right: 18,
                  child: IgnorePointer(
                    child: Container(
                      height: 1.2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.0),
                            Colors.white.withValues(alpha: 0.95),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),

                // 4. 자식 콘텐츠 (자연스러운 레이아웃 사이징 제공)
                Padding(
                  padding: padding,
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
