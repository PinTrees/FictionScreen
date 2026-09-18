import 'dart:ui';
import 'package:flutter/material.dart';

/// Apple WWDC 2025 / iOS 26 공식 리퀴드 글래스 (Liquid Glass) 광학 렌더러
/// 
/// [핵심 광학 공식 (Optical Formula)]
/// 1. Saturation Boosting (채도 증폭 매트릭스): 흐려진 배경색이 탁해지지 않도록 채도를 1.45배 증폭
/// 2. High-Dispersion Backdrop Blur (고분산 굴절 블러): sigma 40 고해상도 가우시안 굴절
/// 3. Meniscus Liquid Gradient (메니스커스 유체 볼록 표면장력): 상단 림 36% -> 중앙 4% 투과 -> 하단 24% 내부 바운스광
/// 4. Chromatic Aberration Rim (프리즘 색수차 분산 베벨): 엣지 곡률에서 빛이 청록(Cyan)과 마젠타(Magenta)로 미세 분산
/// 5. Apple Corner Glow & Top Specular (코너 글로우 & 상단 스펙큘러 하이라이트): 유리 모서리에 맺히는 광택
/// 6. Multi-stage Fluid Ambient Occlusion (다층 앰비언트 심도 그림자): 바닥 부유감 연출
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
  final double saturation;
  final Color? tintColor;

  const Ios26LiquidGlass({
    super.key,
    required this.child,
    this.borderRadius = 38.0,
    this.padding = EdgeInsets.zero,
    this.margin,
    this.width,
    this.height,
    this.hasCornerGlow = true,
    this.hasChromaticAberration = true,
    this.blurSigma = 40.0,
    this.saturation = 1.45,
    this.tintColor,
  });

  // 채도 증폭 컬러 매트릭스 계산 공식
  static List<double> _getSaturationMatrix(double sat) {
    final double invSat = 1.0 - sat;
    final double r = 0.213 * invSat;
    final double g = 0.715 * invSat;
    final double b = 0.072 * invSat;

    return [
      r + sat, g, b, 0, 0,
      r, g + sat, b, 0, 0,
      r, g, b + sat, 0, 0,
      0, 0, 0, 1, 0,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: radius,
        // 다층 유체 앰비언트 심도 및 외곽 프리즘 림 그림자
        boxShadow: [
          // 1. 깊은 소프트 드롭 섀도우 (바닥으로부터 띄워진 입체 부유감)
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.36),
            blurRadius: 36,
            spreadRadius: 1,
            offset: const Offset(0, 16),
          ),
          // 2. 근접 컨택 섀도우 (형체 윤곽 안정화)
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          // 3. 외곽 코스틱 빛 번짐 림
          BoxShadow(
            color: const Color(0xFF80D8FF).withValues(alpha: 0.16),
            blurRadius: 3,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // 1. 유리 베벨 프리즘 테두리 (Chromatic Dispersion Border)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: radius,
                gradient: hasChromaticAberration
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0x9980D8FF), // 좌상단 청록(Cyan) 프리즘
                          Color(0xEEFFFFFF), // 상단 순백 스펙큘러
                          Color(0x88EA80FC), // 우하단 마젠타(Magenta) 분산
                          Color(0x44FFFFFF), // 하단 바운스 반사
                        ],
                        stops: [0.0, 0.35, 0.75, 1.0],
                      )
                    : LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.45),
                          Colors.white.withValues(alpha: 0.15),
                        ],
                      ),
              ),
            ),
          ),

          // 2. 굴절 본체 (채도 증폭 + 백드롭 블러 + 메니스커스 유체 바디)
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(1.2), // 베벨 두께
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius - 1.2),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: blurSigma,
                    sigmaY: blurSigma,
                  ),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.matrix(
                      _getSaturationMatrix(saturation),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        // 리퀴드 글래스 메니스커스 투과 그라데이션
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            (tintColor ?? Colors.white).withValues(alpha: 0.38), // 상단 표면장력 림
                            (tintColor ?? Colors.white).withValues(alpha: 0.14), // 유리 본체 상부
                            (tintColor ?? Colors.white).withValues(alpha: 0.05), // 중앙 고투과 렌즈
                            (tintColor ?? Colors.white).withValues(alpha: 0.25), // 하단 굴절 바운스광
                          ],
                          stops: const [0.0, 0.22, 0.68, 1.0],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // 3. Apple iOS 26 코너 글로우 (Corner Glow) - 좌측 상단 모서리
                          if (hasCornerGlow)
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    center: Alignment.topLeft,
                                    radius: 1.0,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.45),
                                      Colors.white.withValues(alpha: 0.0),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          // 4. Apple iOS 26 코너 글로우 (Corner Glow) - 우측 상단 모서리
                          if (hasCornerGlow)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    center: Alignment.topRight,
                                    radius: 1.0,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.35),
                                      Colors.white.withValues(alpha: 0.0),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          // 5. 상단 1.2px 정밀 스펙큘러 유체 반사선 (Top Specular Sheen)
                          Positioned(
                            top: 0,
                            left: 18,
                            right: 18,
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

                          // 6. 실제 자식 콘텐츠
                          Padding(
                            padding: padding,
                            child: child,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
