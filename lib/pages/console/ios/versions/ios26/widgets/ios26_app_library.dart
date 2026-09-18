import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ios26_app_icon.dart';

/// Apple iOS 26 공식 리퀴드 글래스 앱 보관함 (App Library)
/// - 레퍼런스(media_1789747282110.png) 1:1 픽셀 퍼펙트 구현
/// - 🔍 앱 보관함 검색 캡슐
/// - 2x2 리퀴드 글래스 카테고리 폴더 (3대형 아이콘 + 4인1 미니 클러스터 슬롯)
class Ios26AppLibrary extends StatelessWidget {
  final Function(String appId) onOpenApp;

  const Ios26AppLibrary({super.key, required this.onOpenApp});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // 1. 상단 '🔍 앱 보관함' 리퀴드 글래스 검색 캡슐 (레퍼런스 100% 일치)
          _buildSearchCapsule(),
          const SizedBox(height: 14),

          // 2. 카테고리 2열 그리드 스크롤 뷰
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 18,
              crossAxisSpacing: 16,
              childAspectRatio: 0.86,
              physics: const BouncingScrollPhysics(),
              children: [
                // 1) 제안 (4대형 아이콘)
                _buildCategoryCard(
                  title: '제안',
                  largeApps: [
                    _AppItem('kakaotalk', 'assets/images/kakaotalk_icon.webp', badge: 99),
                    _AppItem('photos', 'assets/images/ios/icons26/photos.png'),
                    _AppItem('appstore', 'assets/images/ios/icons26/appstore.png'),
                    _AppItem('messages', 'assets/images/ios/icons26/messages.png', badge: 3),
                  ],
                ),

                // 2) 최근 추가된 항목 (3대형 + 4인1 미니)
                _buildCategoryCard(
                  title: '최근 추가된 항목',
                  largeApps: [
                    _AppItem('stocks', 'assets/images/ios/icons26/stocks.png'),
                    _AppItem('lottery', 'assets/images/lottery_icon.webp'),
                    _AppItem('coupang', 'assets/images/coupang_icon.webp'),
                  ],
                  miniApps: [
                    _AppItem('music', 'assets/images/ios/icons26/music.png'),
                    _AppItem('fitness', 'assets/images/ios/icons26/fitness.png'),
                    _AppItem('books', 'assets/images/ios/icons26/books.png'),
                    _AppItem('podcasts', 'assets/images/ios/icons26/podcasts.png'),
                  ],
                ),

                // 3) 소셜 미디어 (3대형 + 4인1 미니)
                _buildCategoryCard(
                  title: '소셜 미디어',
                  largeApps: [
                    _AppItem('instagram', 'assets/images/instagram_icon.webp', badge: 5),
                    _AppItem('facetime', 'assets/images/ios/icons26/facetime.png'),
                    _AppItem('phone', 'assets/images/ios/icons26/phone.png'),
                  ],
                  miniApps: [
                    _AppItem('mail', 'assets/images/ios/icons26/mail.png', badge: 14),
                    _AppItem('contacts', 'assets/images/ios/icons26/contacts.png'),
                    _AppItem('safari', 'assets/images/ios/icons26/safari.png'),
                    _AppItem('messages', 'assets/images/ios/icons26/messages.png'),
                  ],
                ),

                // 4) 유틸리티 (3대형 + 4인1 미니)
                _buildCategoryCard(
                  title: '유틸리티',
                  largeApps: [
                    _AppItem('safari', 'assets/images/ios/icons26/safari.png'),
                    _AppItem('passwords', 'assets/images/ios/icons26/passwords.png'),
                    _AppItem('settings', 'assets/images/ios/icons26/settings.png'),
                  ],
                  miniApps: [
                    _AppItem('clock', 'assets/images/ios/icons26/clock.png'),
                    _AppItem('calculator', 'assets/images/ios/icons26/calculator.png'),
                    _AppItem('maps', 'assets/images/ios/icons26/maps.png'),
                    _AppItem('shortcuts', 'assets/images/ios/icons26/shortcuts.png'),
                  ],
                ),

                // 5) 창의력 (3대형 + 4인1 미니)
                _buildCategoryCard(
                  title: '창의력',
                  largeApps: [
                    _AppItem('camera', 'assets/images/ios/icons26/camera.png'),
                    _AppItem('freeform', 'assets/images/ios/icons26/freeform.png'),
                    _AppItem('voicememos', 'assets/images/ios/icons26/voicememos.png'),
                  ],
                  miniApps: [
                    _AppItem('notes', 'assets/images/ios/icons26/notes.png'),
                    _AppItem('translate', 'assets/images/ios/icons26/translate.png'),
                    _AppItem('photos', 'assets/images/ios/icons26/photos.png'),
                    _AppItem('files', 'assets/images/ios/icons26/files.png'),
                  ],
                ),

                // 6) 금융 (3대형 + 4인1 미니)
                _buildCategoryCard(
                  title: '금융',
                  largeApps: [
                    _AppItem('wallet', 'assets/images/ios/icons26/wallet.png'),
                    _AppItem('stocks', 'assets/images/ios/icons26/stocks.png'),
                    _AppItem('reminders', 'assets/images/ios/icons26/reminders.png'),
                  ],
                  miniApps: [
                    _AppItem('health', 'assets/images/ios/icons26/health.png'),
                    _AppItem('findmy', 'assets/images/ios/icons26/findmy.png'),
                    _AppItem('weather', 'assets/images/ios/icons26/weather.png'),
                    _AppItem('calendar', 'assets/images/ios/icons26/calendar.png'),
                  ],
                ),

                // 7) 엔터테인먼트 (3대형 + 4인1 미니)
                _buildCategoryCard(
                  title: '엔터테인먼트',
                  largeApps: [
                    _AppItem('netflix', 'assets/images/netflix_icon.webp'),
                    _AppItem('music', 'assets/images/ios/icons26/music.png'),
                    _AppItem('podcasts', 'assets/images/ios/icons26/podcasts.png'),
                  ],
                  miniApps: [
                    _AppItem('books', 'assets/images/ios/icons26/books.png'),
                    _AppItem('news', 'assets/images/ios/icons26/news.png'),
                    _AppItem('photos', 'assets/images/ios/icons26/photos.png'),
                    _AppItem('freeform', 'assets/images/ios/icons26/freeform.png'),
                  ],
                ),

                // 8) 생산성 (3대형 + 4인1 미니)
                _buildCategoryCard(
                  title: '생산성',
                  largeApps: [
                    _AppItem('mail', 'assets/images/ios/icons26/mail.png'),
                    _AppItem('files', 'assets/images/ios/icons26/files.png'),
                    _AppItem('notes', 'assets/images/ios/icons26/notes.png'),
                  ],
                  miniApps: [
                    _AppItem('calendar', 'assets/images/ios/icons26/calendar.png'),
                    _AppItem('reminders', 'assets/images/ios/icons26/reminders.png'),
                    _AppItem('translate', 'assets/images/ios/icons26/translate.png'),
                    _AppItem('shortcuts', 'assets/images/ios/icons26/shortcuts.png'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 상단 '🔍 앱 보관함' 리퀴드 글래스 검색 캡슐
  Widget _buildSearchCapsule() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(21),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
          width: 0.7,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(21),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.22),
                  Colors.white.withValues(alpha: 0.10),
                ],
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.search, color: Colors.white70, size: 17),
                SizedBox(width: 7),
                Text(
                  '앱 보관함',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
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

  // 리퀴드 글래스 카테고리 폴더 카드
  Widget _buildCategoryCard({
    required String title,
    required List<_AppItem> largeApps,
    List<_AppItem>? miniApps,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.20),
                width: 0.8,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.22),
                        Colors.white.withValues(alpha: 0.08),
                        Colors.white.withValues(alpha: 0.15),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final itemSize = (constraints.maxWidth - 10) / 2;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 상단 2개 대형 아이콘
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildLargeIcon(largeApps[0], itemSize),
                              if (largeApps.length > 1) _buildLargeIcon(largeApps[1], itemSize),
                            ],
                          ),
                          // 하단 2개 아이콘 (대형 1개 + [대형 또는 4인1 미니 클러스터])
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
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
            shadows: [
              Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 1)),
            ],
          ),
        ),
      ],
    );
  }

  // 개별 대형 앱 아이콘
  Widget _buildLargeIcon(_AppItem app, double size) {
    return Ios26AppIcon(
      title: '',
      size: size,
      imageAsset: app.image,
      badgeCount: app.badge,
      onTap: () => onOpenApp(app.id),
    );
  }

  // 4인1 미니 클러스터 슬롯 (대형 아이콘 1개 자리에 4개 미니 아이콘 2x2 배치)
  Widget _buildMiniCluster(List<_AppItem> apps, double size) {
    final miniSize = (size - 6) / 2;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.23),
        color: Colors.white.withValues(alpha: 0.12),
      ),
      padding: const EdgeInsets.all(2),
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
          borderRadius: BorderRadius.circular(size * 0.23),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.20),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size * 0.23),
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
