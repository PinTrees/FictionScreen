import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../widgets/pop_entrance.dart';
import '../widgets/scale_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final cred = await AuthService.signInWithGoogle();
      if (cred != null && mounted) {
        context.go('/console');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인 중 문제가 발생했습니다: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07080D),
      body: Stack(
        children: [
          // 1. Subtle Ambient Aurora Background
          Positioned.fill(
            child: IgnorePointer(
              child: Stack(
                children: [
                  Positioned(
                    top: -120,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 800,
                        height: 440,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF00B0FF).withValues(alpha: 0.18),
                              const Color(0xFF00E5FF).withValues(alpha: 0.06),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Top-left Back Button (Pop entrance & Scale down feedback)
          Positioned(
            top: 24,
            left: 24,
            child: PopEntrance(
              delay: const Duration(milliseconds: 60),
              child: ScaleButton(
                onTap: _handleBack,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(CupertinoIcons.arrow_left, size: 16, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        '메인 화면으로 돌아가기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 3. Main Login Card (ZERO OUTLINE, Generous Padding, Trendy Pop Entrance)
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: PopEntrance(
                delay: const Duration(milliseconds: 120),
                startScale: 0.92,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 440),
                  padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 42),
                  decoration: BoxDecoration(
                    color: const Color(0xFF11131C).withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.6),
                        blurRadius: 36,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Brand Icon (Pops in first with bouncy scale)
                          PopEntrance(
                            delay: const Duration(milliseconds: 220),
                            startScale: 0.65,
                            child: Container(
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF00E5FF), Color(0xFF00B0FF)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF00E5FF).withValues(alpha: 0.35),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(CupertinoIcons.sparkles, color: Colors.white, size: 26),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),

                          // Title
                          PopEntrance(
                            delay: const Duration(milliseconds: 280),
                            child: const Text(
                              'FictionScreen',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          PopEntrance(
                            delay: const Duration(milliseconds: 320),
                            child: Text(
                              '크리에이터를 위한 픽셀 정밀 가상 화면 스튜디오',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 36),

                          // Official Google Sign-In Button (Trendy Pop Entrance: smoothly grows in)
                          PopEntrance(
                            delay: const Duration(milliseconds: 400),
                            startScale: 0.84,
                            child: ScaleButton(
                              onTap: _isLoading ? null : _handleGoogleSignIn,
                              child: Container(
                                width: double.infinity,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: _isLoading
                                    ? const Center(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                                        ),
                                      )
                                    : const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          GoogleLogoIcon(size: 20),
                                          SizedBox(width: 12),
                                          Text(
                                            'Google 계정으로 시작하기',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 14.5,
                                              letterSpacing: -0.2,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          PopEntrance(
                            delay: const Duration(milliseconds: 460),
                            child: Text(
                              '로그인 시 유저별 프로젝트 및 스튜디오 데이터가 Firestore에 안전하게 동기화됩니다.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.38),
                                fontSize: 11.5,
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => context.push('/terms'),
                              child: Text(
                                '이용약관',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.55),
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '•',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => context.push('/privacy'),
                              child: Text(
                                '개인정보 처리방침',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.55),
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
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

/// Authentic 4-color Google G Logo Vector Icon
class GoogleLogoIcon extends StatelessWidget {
  final double size;
  const GoogleLogoIcon({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w / 2;

    final bluePaint = Paint()..color = const Color(0xFF4285F4)..style = PaintingStyle.fill;

    final strokeW = w * 0.22;
    final arcRadius = radius - strokeW / 2;
    final arcRect = Rect.fromCircle(center: center, radius: arcRadius);

    final strokeBlue = Paint()..color = const Color(0xFF4285F4)..style = PaintingStyle.stroke..strokeWidth = strokeW..strokeCap = StrokeCap.butt;
    final strokeRed = Paint()..color = const Color(0xFFEA4335)..style = PaintingStyle.stroke..strokeWidth = strokeW..strokeCap = StrokeCap.butt;
    final strokeYellow = Paint()..color = const Color(0xFFFBBC05)..style = PaintingStyle.stroke..strokeWidth = strokeW..strokeCap = StrokeCap.butt;
    final strokeGreen = Paint()..color = const Color(0xFF34A853)..style = PaintingStyle.stroke..strokeWidth = strokeW..strokeCap = StrokeCap.butt;

    // Center blue crossbar
    canvas.drawRect(Rect.fromLTWH(center.dx - strokeW * 0.1, center.dy - strokeW / 2, radius + strokeW * 0.1, strokeW), bluePaint);

    // Multi-color Google arcs
    canvas.drawArc(arcRect, -0.75, 1.45, false, strokeBlue);
    canvas.drawArc(arcRect, 0.7, 1.75, false, strokeGreen);
    canvas.drawArc(arcRect, 2.45, 1.35, false, strokeYellow);
    canvas.drawArc(arcRect, 3.8, 1.73, false, strokeRed);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
