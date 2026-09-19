import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/app_theme_service.dart';

/// 앱 전역 고품격 모던 로딩 화면 (별도 파일로 분리된 독립 컴포넌트)
/// - 세련된 펄스(Pulse) 앰비언트 글로우 오라
/// - FictionScreen 시그니처 그라데이션 아이콘 및 스파클 모션
/// - 네온 프로그레스 슬라이더 & 실시간 상태 인디케이터
/// - 다크 / 라이트 모드 전역 테마 100% 자동 적응
class AppLoadingScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String statusText;
  final bool isOverlay;

  const AppLoadingScreen({
    super.key,
    this.title = 'FictionScreen',
    this.subtitle = '크리에이터를 위한 가상 화면 스튜디오',
    this.statusText = '캔버스 그래픽 엔진 초기화 중...',
    this.isOverlay = false,
  });

  @override
  State<AppLoadingScreen> createState() => _AppLoadingScreenState();
}

class _AppLoadingScreenState extends State<AppLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final Animation<double> _pulseScale;
  late final Animation<double> _glowOpacity;
  late final Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _pulseScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.96, end: 1.05)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.05, end: 0.96)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 50,
      ),
    ]).animate(_animCtrl);

    _glowOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.25, end: 0.65)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.65, end: 0.25)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_animCtrl);

    _progressAnim = Tween<double>(begin: -0.3, end: 1.3).animate(
      CurvedAnimation(
        parent: _animCtrl,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppThemeService.instance.isDarkMode(context);

    final bgColor = widget.isOverlay
        ? (isDarkMode ? Colors.black.withValues(alpha: 0.6) : Colors.black.withValues(alpha: 0.25))
        : (isDarkMode ? const Color(0xFF07080D) : const Color(0xFFF8FAFC));

    final cardBgColor = isDarkMode
        ? const Color(0xFF111420).withValues(alpha: 0.9)
        : Colors.white.withValues(alpha: 0.95);

    final textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDarkMode ? Colors.white.withValues(alpha: 0.6) : const Color(0xFF64748B);
    final statusColor = isDarkMode ? const Color(0xFF38BDF8) : const Color(0xFF0284C7);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Ambient Pulsing Aurora Background
          AnimatedBuilder(
            animation: _animCtrl,
            builder: (context, _) {
              return IgnorePointer(
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 520,
                        height: 520,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF00E5FF).withValues(alpha: _glowOpacity.value * 0.35),
                              const Color(0xFF6366F1).withValues(alpha: _glowOpacity.value * 0.18),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // 2. Central Elevated Loading Card
          Center(
            child: Container(
              width: 380,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDarkMode ? 0.55 : 0.08),
                    blurRadius: 32,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Animated Brand Icon
                      AnimatedBuilder(
                        animation: _animCtrl,
                        builder: (context, _) {
                          return Transform.scale(
                            scale: _pulseScale.value,
                            child: Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF00E5FF), Color(0xFF6366F1)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF00E5FF).withValues(
                                      alpha: _glowOpacity.value * 0.6,
                                    ),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  CupertinoIcons.sparkles,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Title
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Subtitle
                      Text(
                        widget.subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textSubColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Futuristic Shimmer Progress Track
                      Container(
                        width: double.infinity,
                        height: 4,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.white.withValues(alpha: 0.08)
                              : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: AnimatedBuilder(
                          animation: _animCtrl,
                          builder: (context, _) {
                            return FractionalTranslation(
                              translation: Offset(_progressAnim.value, 0),
                              child: Container(
                                width: 140,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Color(0xFF00E5FF),
                                      Color(0xFF6366F1),
                                      Colors.transparent,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(99),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Real-time Status Pill (ZERO OUTLINE)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: isDarkMode ? 0.12 : 0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: statusColor.withValues(alpha: 0.8),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.statusText,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
