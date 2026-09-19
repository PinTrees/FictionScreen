import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/news_model.dart';

class NewsHeaderBar extends StatefulWidget {
  final NewsConfig config;

  const NewsHeaderBar({
    super.key,
    required this.config,
  });

  @override
  State<NewsHeaderBar> createState() => _NewsHeaderBarState();
}

class _NewsHeaderBarState extends State<NewsHeaderBar> {
  bool _liveDotVisible = true;
  Timer? _blinkTimer;

  @override
  void initState() {
    super.initState();
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 700), (_) {
      if (mounted) {
        setState(() {
          _liveDotVisible = !_liveDotVisible;
        });
      }
    });
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    super.dispose();
  }

  Color _getPrimaryColor() {
    switch (widget.config.channelTheme) {
      case NewsChannelTheme.ytn:
        return const Color(0xFF003876);
      case NewsChannelTheme.kbs:
        return const Color(0xFF0A192F);
      case NewsChannelTheme.sbs:
        return const Color(0xFF004EA2);
      case NewsChannelTheme.jtbc:
        return const Color(0xFF1E1135);
      case NewsChannelTheme.alert:
        return const Color(0xFFB71C1C);
    }
  }

  Color _getAccentColor() {
    switch (widget.config.channelTheme) {
      case NewsChannelTheme.ytn:
        return const Color(0xFFD32F2F);
      case NewsChannelTheme.kbs:
        return const Color(0xFFFFB300);
      case NewsChannelTheme.sbs:
        return const Color(0xFFFF6F00);
      case NewsChannelTheme.jtbc:
        return const Color(0xFF00E5FF);
      case NewsChannelTheme.alert:
        return const Color(0xFFFF1744);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = _getPrimaryColor();
    final accentColor = _getAccentColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.8),
            Colors.black.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. 방송국 로고 및 LIVE 뱃지
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: accentColor.withValues(alpha: 0.8), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.tv_fill, color: accentColor, size: 16),
                const SizedBox(width: 6),
                Text(
                  widget.config.channelName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // LIVE 깜빡임 인디케이터
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFD32F2F),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedOpacity(
                  opacity: _liveDotVisible ? 1.0 : 0.2,
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // 2. 우측 상단 제보 배너 & 실시간 시계
          if (widget.config.hotlineText.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white24, width: 0.8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(CupertinoIcons.phone_fill, color: Color(0xFFFFD54F), size: 12),
                  const SizedBox(width: 5),
                  Text(
                    widget.config.hotlineText,
                    style: const TextStyle(
                      color: Color(0xFFFFD54F),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

          // 디지털 시계
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white30, width: 0.8),
            ),
            child: Text(
              widget.config.timeString,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
