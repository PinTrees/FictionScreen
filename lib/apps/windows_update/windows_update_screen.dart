import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data/windows_update_model.dart';

/// 현실적인 Windows 10/11 가짜 업데이트 전체화면 스크린
class WindowsUpdateScreen extends StatefulWidget {
  final WindowsUpdateConfig config;
  final VoidCallback? onClose;

  const WindowsUpdateScreen({
    super.key,
    required this.config,
    this.onClose,
  });

  @override
  State<WindowsUpdateScreen> createState() => _WindowsUpdateScreenState();
}

class _WindowsUpdateScreenState extends State<WindowsUpdateScreen> {
  late int _currentProgress;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    _currentProgress = widget.config.progress;

    if (widget.config.isAnimated) {
      _startProgressTimer();
    }
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  void _startProgressTimer() {
    _progressTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          if (_currentProgress < 99) {
            _currentProgress += 1;
          } else {
            _currentProgress = 1; // 99% 후 1%로 루프
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isWin11 = widget.config.version == 'win11';

    return Scaffold(
      backgroundColor: isWin11 ? const Color(0xFF000000) : const Color(0xFF005A9E),
      body: Stack(
        children: [
          // 업데이트 진행 화면 중앙 콘텐츠
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Windows 10/11 전용 서클 로더 애니메이션
                SizedBox(
                  width: 54,
                  height: 54,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.5,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                const SizedBox(height: 36),

                // 진행 퍼센트 텍스트
                Text(
                  '${widget.config.primaryMessage} $_currentProgress%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // 보조 가이드 문구
                Text(
                  widget.config.secondaryMessage,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 14,
                    height: 1.6,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // 상단 플로팅 전체화면 종료 가이드 바
          Positioned(
            top: 20,
            right: 20,
            child: InkWell(
              onTap: widget.onClose,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.xmark, size: 14, color: Colors.white),
                    SizedBox(width: 6),
                    Text('전체화면 종료', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
