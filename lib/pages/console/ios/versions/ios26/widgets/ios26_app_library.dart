import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ios26_app_icon.dart';
import 'ios26_liquid_glass.dart';

/// Apple iOS 26 공식 리퀴드 글래스 앱 보관함 (App Library)
/// - 레퍼런스(media_1789747282110.png) 1:1 픽셀 퍼펙트 구현
/// - 상단 스티키 리퀴드 글래스 검색 캡슐 (Search Bar)
/// - 스크롤 시 상단 바 뒤로 아이템들이 블러(BackdropFilter) 처리되며 부드럽게 사라지는 효과
/// - 1:1 완벽한 정사각형 리퀴드 글래스 카테고리 폴더 (3대형 아이콘 + 4인1 미니 클러스터 슬롯)
/// - 하단 독 및 하단 검색 바 제거
class Ios26AppLibrary extends StatelessWidget {
  final Function(String appId) onOpenApp;

  const Ios26AppLibrary({super.key, required this.onOpenApp});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. 카테고리 2열 스크롤 뷰 (상단 마스크 페이드로 자연스럽게 상단 바 뒤로 사라짐)
        Positioned.fill(
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: const [Colors.transparent, Colors.white],
                stops: const [0.0, 0.07],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 60, bottom: 24, left: 16, right: 16),
              child: Column(
                children: [
                  _buildCategoryRow(
                    left: _buildCategoryCard(
                      title: '제안',
                      largeApps: const [
                        _AppItem('kakaotalk', 'assets/images/kakaotalk_icon.webp', badge: 99),
                        _AppItem('photos', 'assets/images/ios/icons26/photos.png'),
                        _AppItem('appstore', 'assets/images/ios/icons26/appstore.png'),
                        _AppItem('messages', 'assets/images/ios/icons26/messages.png', badge: 3),
                      ],
                    ),
                    right: _buildCategoryCard(
                      title: '최근 추가된 항목',
                      largeApps: const [
                        _AppItem('stocks', 'assets/images/ios/icons26/stocks.png'),
                        _AppItem('lottery', 'assets/images/lottery_icon.webp'),
                        _AppItem('coupang', 'assets/images/coupang_icon.webp'),
                      ],
                      miniApps: const [
                        _AppItem('music', 'assets/images/ios/icons26/music.png'),
                        _AppItem('fitness', 'assets/images/ios/icons26/fitness.png'),
                        _AppItem('books', 'assets/images/ios/icons26/books.png'),
                        _AppItem('podcasts', 'assets/images/ios/icons26/podcasts.png'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildCategoryRow(
                    left: _buildCategoryCard(
                      title: '소셜 미디어',
                      largeApps: const [
                        _AppItem('instagram', 'assets/images/instagram_icon.webp', badge: 5),
                        _AppItem('facetime', 'assets/images/ios/icons26/facetime.png'),
                        _AppItem('phone', 'assets/images/ios/icons26/phone.png'),
                      ],
                      miniApps: const [
                        _AppItem('mail', 'assets/images/ios/icons26/mail.png', badge: 14),
                        _AppItem('contacts', 'assets/images/ios/icons26/contacts.png'),
                        _AppItem('safari', 'assets/images/ios/icons26/safari.png'),
                        _AppItem('messages', 'assets/images/ios/icons26/messages.png'),
                      ],
                    ),
                    right: _buildCategoryCard(
                      title: '유틸리티',
                      largeApps: const [
                        _AppItem('safari', 'assets/images/ios/icons26/safari.png'),
                        _AppItem('passwords', 'assets/images/ios/icons26/passwords.png'),
                        _AppItem('settings', 'assets/images/ios/icons26/settings.png'),
                      ],
                      miniApps: const [
                        _AppItem('clock', 'assets/images/ios/icons26/clock.png'),
                        _AppItem('calculator', 'assets/images/ios/icons26/calculator.png'),
                        _AppItem('maps', 'assets/images/ios/icons26/maps.png'),
                        _AppItem('shortcuts', 'assets/images/ios/icons26/shortcuts.png'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildCategoryRow(
                    left: _buildCategoryCard(
                      title: '창의력',
                      largeApps: const [
                        _AppItem('camera', 'assets/images/ios/icons26/camera.png'),
                        _AppItem('freeform', 'assets/images/ios/icons26/freeform.png'),
                        _AppItem('voicememos', 'assets/images/ios/icons26/voicememos.png'),
                      ],
                      miniApps: const [
                        _AppItem('notes', 'assets/images/ios/icons26/notes.png'),
                        _AppItem('translate', 'assets/images/ios/icons26/translate.png'),
                        _AppItem('photos', 'assets/images/ios/icons26/photos.png'),
                        _AppItem('files', 'assets/images/ios/icons26/files.png'),
                      ],
                    ),
                    right: _buildCategoryCard(
                      title: '금융',
                      largeApps: const [
                        _AppItem('wallet', 'assets/images/ios/icons26/wallet.png'),
                        _AppItem('stocks', 'assets/images/ios/icons26/stocks.png'),
                        _AppItem('reminders', 'assets/images/ios/icons26/reminders.png'),
                      ],
                      miniApps: const [
                        _AppItem('health', 'assets/images/ios/icons26/health.png'),
                        _AppItem('findmy', 'assets/images/ios/icons26/findmy.png'),
                        _AppItem('weather', 'assets/images/ios/icons26/weather.png'),
                        _AppItem('calendar', 'assets/images/ios/icons26/calendar.png'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildCategoryRow(
                    left: _buildCategoryCard(
                      title: '엔터테인먼트',
                      largeApps: const [
                        _AppItem('netflix', 'assets/images/netflix_icon.webp'),
                        _AppItem('music', 'assets/images/ios/icons26/music.png'),
                        _AppItem('podcasts', 'assets/images/ios/icons26/podcasts.png'),
                      ],
                      miniApps: const [
                        _AppItem('books', 'assets/images/ios/icons26/books.png'),
                        _AppItem('news', 'assets/images/ios/icons26/news.png'),
                        _AppItem('photos', 'assets/images/ios/icons26/photos.png'),
                        _AppItem('freeform', 'assets/images/ios/icons26/freeform.png'),
                      ],
                    ),
                    right: _buildCategoryCard(
                      title: '생산성',
                      largeApps: const [
                        _AppItem('mail', 'assets/images/ios/icons26/mail.png'),
                        _AppItem('files', 'assets/images/ios/icons26/files.png'),
                        _AppItem('notes', 'assets/images/ios/icons26/notes.png'),
                      ],
                      miniApps: const [
                        _AppItem('calendar', 'assets/images/ios/icons26/calendar.png'),
                        _AppItem('reminders', 'assets/images/ios/icons26/reminders.png'),
                        _AppItem('translate', 'assets/images/ios/icons26/translate.png'),
                        _AppItem('shortcuts', 'assets/images/ios/icons26/shortcuts.png'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 2. 상단 스티키 리퀴드 글래스 검색 캡슐 바 (스크롤되는 앱들이 이 바 뒤로 블러 처리되며 지나감)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
                color: Colors.white.withValues(alpha: 0.02),
                child: _buildSearchCapsule(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 카테고리 2열 행 배치
  Widget _buildCategoryRow({required Widget left, required Widget right}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 14),
        Expanded(child: right),
      ],
    );
  }

  // 1:1 완벽한 정사각형 Apple 공식 리퀴드 글래스 카테고리 폴더 카드
  Widget _buildCategoryCard({
    required String title,
    required List<_AppItem> largeApps,
    List<_AppItem>? miniApps,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: 1.0,
          child: Ios26LiquidGlass(
            borderRadius: 34,
            blurSigma: 30,
            hasCornerGlow: true,
            hasChromaticAberration: false,
            padding: const EdgeInsets.all(12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final innerSize = constraints.maxWidth;
                final gap = 11.0;
                final itemSize = (innerSize - gap) / 2;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLargeIcon(largeApps[0], itemSize),
                        if (largeApps.length > 1) _buildLargeIcon(largeApps[1], itemSize),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (largeApps.length > 2) _buildLargeIcon(largeApps[2], itemSize),
                        if (miniApps != null && miniApps.isNotEmpty)
                          _buildMiniCluster(miniApps, itemSize)
                        else if (largeApps.length > 3)
                          _buildLargeIcon(largeApps[3], itemSize),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
            shadows: [Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 1))],
          ),
        ),
      ],
    );
  }

  // 상단 '🔍 앱 보관함' 리퀴드 글래스 검색 캡슐
  Widget _buildSearchCapsule() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.22),
          width: 0.8,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.24),
                  Colors.white.withValues(alpha: 0.10),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.search, color: Colors.white.withValues(alpha: 0.70), size: 17),
                const SizedBox(width: 7),
                Text(
                  '앱 보관함',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.70),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 개별 대형 앱 아이콘 (76x76 규격 연동)
  Widget _buildLargeIcon(_AppItem app, double size) {
    return Ios26AppIcon(
      title: '',
      size: size,
      imageAsset: app.image,
      badgeCount: app.badge,
      onTap: () => onOpenApp(app.id),
    );
  }

  // 4인1 미니 클러스터 슬롯 (대형 아이콘 1개 자리에 4개 미니 아이콘 2x2 배치, 별도 배경판 없이 글래스 표면에 직배치)
  Widget _buildMiniCluster(List<_AppItem> apps, double size) {
    final miniGap = 5.0;
    final miniSize = (size - miniGap) / 2;

    return SizedBox(
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (apps.isNotEmpty) _buildMiniIcon(apps[0], miniSize),
              if (apps.length > 1) _buildMiniIcon(apps[1], miniSize),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (apps.length > 2) _buildMiniIcon(apps[2], miniSize),
              if (apps.length > 3) _buildMiniIcon(apps[3], miniSize),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniIcon(_AppItem app, double size) {
    return GestureDetector(
      onTap: () => onOpenApp(app.id),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.225),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size * 0.225),
          child: Image.asset(
            app.image,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}

class _AppItem {
  final String id;
  final String image;
  final int? badge;
  const _AppItem(this.id, this.image, {this.badge});
}
