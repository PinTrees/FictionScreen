import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data/news_model.dart';
import 'widgets/news_edit_dialog.dart';
import 'widgets/news_header_bar.dart';
import 'widgets/news_lower_third.dart';
import 'widgets/news_studio_canvas.dart';

class NewsScreen extends StatefulWidget {
  final NewsConfig config;
  final ValueChanged<NewsConfig>? onConfigChanged;

  const NewsScreen({
    super.key,
    required this.config,
    this.onConfigChanged,
  });

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  void _openEditDialog() {
    showDialog(
      context: context,
      builder: (ctx) => NewsEditDialog(
        config: widget.config,
        onApply: (updated) {
          widget.onConfigChanged?.call(updated);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. 스튜디오 & 현장 메인 캔버스
          NewsStudioCanvas(config: widget.config),

          // 2. 상단 헤더 바 (방송사 로고, LIVE, 제보, 시계)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: NewsHeaderBar(config: widget.config),
            ),
          ),

          // 3. 하단 속보 자막 오버레이 (헤드라인 + 롤링 티커)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: NewsLowerThird(config: widget.config),
            ),
          ),

          // 4. 플로팅 뉴스 설정 버튼 (호버/클릭으로 시나리오 수정)
          Positioned(
            top: 54,
            right: 16,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: _openEditDialog,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white38, width: 0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.gear_alt_fill, color: Colors.white70, size: 14),
                      SizedBox(width: 5),
                      Text(
                        '시나리오 설정',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
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
