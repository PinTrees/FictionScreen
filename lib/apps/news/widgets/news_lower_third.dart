import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/news_model.dart';

class NewsLowerThird extends StatefulWidget {
  final NewsConfig config;

  const NewsLowerThird({
    super.key,
    required this.config,
  });

  @override
  State<NewsLowerThird> createState() => _NewsLowerThirdState();
}

class _NewsLowerThirdState extends State<NewsLowerThird> {
  late final ScrollController _scrollController;
  Timer? _tickerTimer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startRollingTicker());
  }

  void _startRollingTicker() {
    _tickerTimer = Timer.periodic(const Duration(milliseconds: 35), (_) {
      if (!_scrollController.hasClients) return;
      final maxExtent = _scrollController.position.maxScrollExtent;
      final current = _scrollController.offset;
      if (current >= maxExtent - 2) {
        _scrollController.jumpTo(0);
      } else {
        _scrollController.jumpTo(current + 1.2);
      }
    });
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  String _getBadgeText() {
    switch (widget.config.badgeType) {
      case NewsBadgeType.breaking:
        return '긴급 속보';
      case NewsBadgeType.exclusive:
        return '단독';
      case NewsBadgeType.special:
        return '뉴스 특보';
      case NewsBadgeType.live:
        return '생중계';
      case NewsBadgeType.urgent:
        return '긴급';
    }
  }

  Color _getBadgeColor() {
    switch (widget.config.badgeType) {
      case NewsBadgeType.breaking:
        return const Color(0xFFD50000);
      case NewsBadgeType.exclusive:
        return const Color(0xFFC62828);
      case NewsBadgeType.special:
        return const Color(0xFFE65100);
      case NewsBadgeType.live:
        return const Color(0xFF00C853);
      case NewsBadgeType.urgent:
        return const Color(0xFFFF6D00);
    }
  }

  Color _getBannerBgColor() {
    switch (widget.config.channelTheme) {
      case NewsChannelTheme.ytn:
        return const Color(0xFF0D254C);
      case NewsChannelTheme.kbs:
        return const Color(0xFF0B172B);
      case NewsChannelTheme.sbs:
        return const Color(0xFF063366);
      case NewsChannelTheme.jtbc:
        return const Color(0xFF140D24);
      case NewsChannelTheme.alert:
        return const Color(0xFF4A0E17);
    }
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = _getBadgeColor();
    final bannerBg = _getBannerBgColor();
    final badgeText = _getBadgeText();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. 메인 속보 자막 바 (The Headline Bar)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: bannerBg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.7),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 속보 뱃지 (예: [단독] / [긴급 속보])
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [badgeColor, badgeColor.withValues(alpha: 0.85)],
                  ),
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      color: badgeColor.withValues(alpha: 0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.config.badgeType == NewsBadgeType.exclusive)
                      const Icon(CupertinoIcons.star_fill, color: Color(0xFFFFD700), size: 16),
                    if (widget.config.badgeType == NewsBadgeType.breaking || widget.config.badgeType == NewsBadgeType.urgent)
                      const Icon(CupertinoIcons.bolt_fill, color: Colors.white, size: 16),
                    if (widget.config.badgeType == NewsBadgeType.live)
                      const Icon(CupertinoIcons.dot_radiowaves_left_right, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      badgeText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),

              // 헤드라인 본문 (메인 타이틀 + 서브 타이틀)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 메인 헤드라인
                      Text(
                        widget.config.mainHeadline,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.3,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      // 서브 헤드라인
                      Text(
                        widget.config.subHeadline,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.82),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // 2. 하단 롤링 티커 테이프 (Ticker Tape) & 증시
        Container(
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF050B14),
            border: Border(
              top: BorderSide(color: Colors.white.withValues(alpha: 0.18), width: 1),
            ),
          ),
          child: Row(
            children: [
              // 뉴스 속보 라벨 박스
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                height: double.infinity,
                alignment: Alignment.center,
                color: const Color(0xFF0D47A1),
                child: const Row(
                  children: [
                    Icon(CupertinoIcons.news, color: Colors.white, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'NEWS 24',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),

              // 롤링 티커 영역
              Expanded(
                child: ClipRect(
                  child: ListView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ..._buildTickerSpans(),
                      // 무한 루프를 위한 복제
                      ..._buildTickerSpans(),
                    ],
                  ),
                ),
              ),

              // 우측 증시/환율 인디케이터
              if (widget.config.stockTicker.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: double.infinity,
                  alignment: Alignment.center,
                  color: const Color(0xFF0A1526),
                  child: Text(
                    widget.config.stockTicker,
                    style: const TextStyle(
                      color: Color(0xFF64B5F6),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTickerSpans() {
    final List<Widget> items = [];
    for (int i = 0; i < widget.config.tickerItems.length; i++) {
      items.add(
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget.config.tickerItems[i],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
      items.add(
        Center(
          child: Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Color(0xFFFFD54F),
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }
    return items;
  }
}
