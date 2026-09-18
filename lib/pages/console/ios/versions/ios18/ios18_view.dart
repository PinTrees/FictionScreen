import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'apps/settings/ios18_settings_view.dart';
import 'widgets/ios18_app_icon.dart';
import 'widgets/ios18_dock.dart';
import 'widgets/ios18_home_indicator.dart';
import 'widgets/ios18_status_bar.dart';
import 'widgets/ios18_widget_card.dart';

/// iPhone 16 Pro iOS 18 모바일 홈스크린 및 티타늄 프레임 뷰
/// - 좌우 슬라이드(PageView) 탐색 지원 (Page 0: 위젯+앱, Page 1: 앱 그리드, Page 2: 앱 보관함)
/// - 실제 iOS 18 홈스크린 순정 레이아웃 (상단 날씨/캘린더 2x2 위젯, 잠금화면 거대 시계 배제)
/// - 하단 독(Dock): Apple 순정 리퀴드 글래스모피즘 (Liquid Glassmorphism) 적용
class Ios18View extends StatefulWidget {
  final User? user;
  final String timeString;
  final String dateString;
  final String currentWallpaper;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;

  const Ios18View({
    super.key,
    required this.user,
    required this.timeString,
    required this.dateString,
    required this.currentWallpaper,
    required this.onOpenTemplate,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
  });

  @override
  State<Ios18View> createState() => _Ios18ViewState();
}

class _Ios18ViewState extends State<Ios18View> {
  late String _activeWallpaper;
  String? _activeApp;
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _activeWallpaper = widget.currentWallpaper.startsWith('ios18')
        ? widget.currentWallpaper
        : 'ios18_dark';
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openApp(String appId) {
    // Fiction 템플릿 앱인 경우 기존 전역 템플릿 창으로 전환
    const creatorTemplates = {
      'kakaotalk',
      'instagram',
      'netflix',
      'youtube',
      'coupang',
      'delivery',
      'lottery',
      'windows_bsod'
    };

    if (creatorTemplates.contains(appId)) {
      widget.onOpenTemplate(appId);
      return;
    }

    setState(() {
      _activeApp = appId;
    });
  }

  void _closeApp() {
    setState(() {
      _activeApp = null;
    });
  }

  String _getWallpaperAsset() {
    switch (_activeWallpaper) {
      case 'ios18_light':
        return 'assets/images/ios/wallpapers/ios18_light.png';
      case 'ios18_blue':
        return 'assets/images/ios/wallpapers/ios18_blue.jpg';
      case 'ios18_purple':
        return 'assets/images/ios/wallpapers/ios18_purple.jpg';
      case 'ios18_yellow':
        return 'assets/images/ios/wallpapers/ios18_yellow.jpg';
      case 'ios18_dark':
      default:
        return 'assets/images/ios/wallpapers/ios18_dark.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isDesktop = media.size.width > 550;

    // 데스크톱에서는 iPhone 16 Pro 티타늄 외곽 베젤 프레임으로 렌더링
    if (isDesktop) {
      return Container(
        color: const Color(0xFF0F1117), // 스튜디오 배경
        child: Center(
          child: _buildIphone16ProDeviceFrame(media.size.height),
        ),
      );
    }

    // 모바일 기기 접속 시 전체 화면 엣지 투 엣지 모드
    return _buildPhoneScreen(isFrame: false);
  }

  // iPhone 16 Pro 물리 티타늄 프레임 (외곽 볼륨 버튼, 전원 버튼, 정밀 베젤)
  Widget _buildIphone16ProDeviceFrame(double screenHeight) {
    // 기기 비율 맞춤 계산 (약 393 x 852 표준)
    final double targetHeight = (screenHeight * 0.94).clamp(680.0, 920.0);
    final double targetWidth = targetHeight * (393.0 / 852.0);

    return Container(
      width: targetWidth,
      height: targetHeight,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(54),
        border: Border.all(
          color: const Color(0xFF474B53), // 내추럴 티타늄 베젤
          width: 4.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.7),
            blurRadius: 50,
            spreadRadius: 8,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.1),
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(49.5),
        child: _buildPhoneScreen(isFrame: true),
      ),
    );
  }

  // iPhone 화면 본체
  Widget _buildPhoneScreen({required bool isFrame}) {
    return Stack(
      children: [
        // 1. 공식 고화질 iOS 18 배경화면
        Positioned.fill(
          child: Image.asset(
            _getWallpaperAsset(),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ),

        // 2. 홈 스크린 콘텐츠 (상태바 + 좌우 슬라이드 PageView + 페이지 인디케이터 + 리퀴드 독)
        Positioned.fill(
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // 최상단 상태바 & 다이내믹 아일랜드
                Ios18StatusBar(timeString: widget.timeString),
                const SizedBox(height: 10),

                // 좌우 슬라이드 가능한 홈스크린 멀티 페이지 (PageView)
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      _buildPage1(), // Page 1: 상단 2x2 위젯(날씨, 캘린더) + 3행 앱 그리드
                      _buildPage2(), // Page 2: 4행 앱 그리드 (유틸리티 & 크리에이터 앱)
                      _buildPage3AppLibrary(), // Page 3: 순정 앱 보관함
                    ],
                  ),
                ),

                // iOS 18 순정 페이지 인디케이터 도트 & 검색 캡슐
                _buildPageIndicator(),
                const SizedBox(height: 10),

                // 3. 순정 리퀴드 글래스모피즘 플로팅 독
                Ios18Dock(onOpenApp: _openApp),
                const SizedBox(height: 10),

                // 4. 하단 홈 인디케이터 바
                Ios18HomeIndicator(onHome: () {
                  if (_currentPage != 0) {
                    _pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                    );
                  }
                }),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ),

        // 3. 앱 실행 오버레이 (부드러운 모달 전환)
        if (_activeApp != null)
          Positioned.fill(
            child: _buildAppOverlay(),
          ),
      ],
    );
  }

  // Page 1: 순정 iOS 18 레이아웃 (날씨 2x2 위젯 + 캘린더 2x2 위젯 + 3행 앱 그리드)
  Widget _buildPage1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // 상단: iOS 18 모듈형 2x2 위젯 2개 나란히 배치
          Row(
            children: [
              Expanded(
                child: Ios18WeatherWidget(
                  onTap: () => _openApp('weather'),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Ios18CalendarWidget(
                  onTap: () => _openApp('calendar'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 3행 x 4열 순정 앱 그리드 (12개 앱)
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.74,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Ios18AppIcon(title: 'FaceTime', imageAsset: 'assets/images/ios/icons/facetime.png', onTap: () => _openApp('facetime')),
                Ios18AppIcon(title: '사진', imageAsset: 'assets/images/ios/icons/photos.png', onTap: () => _openApp('photos')),
                Ios18AppIcon(title: '카메라', imageAsset: 'assets/images/ios/icons/camera.png', onTap: () => _openApp('camera')),
                Ios18AppIcon(title: '메일', imageAsset: 'assets/images/ios/icons/mail.png', badgeCount: 14, onTap: () => _openApp('mail')),

                Ios18AppIcon(title: '시계', imageAsset: 'assets/images/ios/icons/clock.png', onTap: () => _openApp('clock')),
                Ios18AppIcon(title: '지도', imageAsset: 'assets/images/ios/icons/maps.png', onTap: () => _openApp('maps')),
                Ios18AppIcon(title: '메모', imageAsset: 'assets/images/ios/icons/notes.png', onTap: () => _openApp('notes')),
                Ios18AppIcon(title: '계산기', imageAsset: 'assets/images/ios/icons/calculator.png', onTap: () => _openApp('calculator')),

                Ios18AppIcon(title: '파일', imageAsset: 'assets/images/ios/icons/files.png', onTap: () => _openApp('files')),
                Ios18AppIcon(title: '건강', imageAsset: 'assets/images/ios/icons/health.png', onTap: () => _openApp('health')),
                Ios18AppIcon(title: '지갑', imageAsset: 'assets/images/ios/icons/wallet.png', onTap: () => _openApp('wallet')),
                Ios18AppIcon(title: '설정', imageAsset: 'assets/images/ios/icons/settings.png', onTap: () => _openApp('settings')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Page 2: 4행 x 4열 앱 그리드 (유틸리티 & 크리에이터 템플릿 앱)
  Widget _buildPage2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.74,
        physics: const BouncingScrollPhysics(),
        children: [
          // Row 1
          Ios18AppIcon(title: 'App Store', imageAsset: 'assets/images/ios/icons/appstore.png', onTap: () => _openApp('appstore')),
          Ios18AppIcon(
            title: '도서',
            customIcon: Container(
              color: const Color(0xFFFF9500),
              child: const Icon(CupertinoIcons.book_fill, color: Colors.white, size: 28),
            ),
            onTap: () => _openApp('books'),
          ),
          Ios18AppIcon(
            title: '팟캐스트',
            customIcon: Container(
              color: const Color(0xFFAF52DE),
              child: const Icon(CupertinoIcons.mic_fill, color: Colors.white, size: 28),
            ),
            onTap: () => _openApp('podcasts'),
          ),
          Ios18AppIcon(
            title: '주식',
            customIcon: Container(
              color: const Color(0xFF1C1C1E),
              child: const Icon(CupertinoIcons.chart_bar_alt_fill, color: Color(0xFF30D158), size: 28),
            ),
            onTap: () => _openApp('stocks'),
          ),

          // Row 2
          Ios18AppIcon(
            title: '미리알림',
            customIcon: Container(
              color: Colors.white,
              child: const Icon(CupertinoIcons.list_bullet, color: Color(0xFF007AFF), size: 28),
            ),
            onTap: () => _openApp('reminders'),
          ),
          Ios18AppIcon(
            title: '피트니스',
            customIcon: Container(
              color: Colors.black,
              child: const Icon(CupertinoIcons.flame_fill, color: Color(0xFFFF2D55), size: 28),
            ),
            onTap: () => _openApp('fitness'),
          ),
          Ios18AppIcon(
            title: '번역',
            customIcon: Container(
              color: const Color(0xFF007AFF),
              child: const Icon(CupertinoIcons.globe, color: Colors.white, size: 28),
            ),
            onTap: () => _openApp('translate'),
          ),
          Ios18AppIcon(
            title: '단축어',
            customIcon: Container(
              color: const Color(0xFF5856D6),
              child: const Icon(CupertinoIcons.bolt_horizontal_fill, color: Colors.white, size: 28),
            ),
            onTap: () => _openApp('shortcuts'),
          ),

          // Row 3 (크리에이터 앱)
          Ios18AppIcon(title: '카카오톡', imageAsset: 'assets/images/kakaotalk_icon.webp', badgeCount: 99, onTap: () => _openApp('kakaotalk')),
          Ios18AppIcon(title: 'Instagram', imageAsset: 'assets/images/instagram_icon.webp', badgeCount: 5, onTap: () => _openApp('instagram')),
          Ios18AppIcon(title: 'YouTube', customIcon: Container(color: Colors.red, child: const Icon(CupertinoIcons.play_arrow_solid, color: Colors.white, size: 28)), onTap: () => _openApp('youtube')),
          Ios18AppIcon(title: 'Netflix', imageAsset: 'assets/images/netflix_icon.webp', onTap: () => _openApp('netflix')),

          // Row 4
          Ios18AppIcon(title: '쿠팡', imageAsset: 'assets/images/coupang_icon.webp', onTap: () => _openApp('coupang')),
          Ios18AppIcon(title: '배달의민족', customIcon: Container(color: const Color(0xFF2AC1BC), child: const Icon(CupertinoIcons.bag_fill, color: Colors.white, size: 28)), onTap: () => _openApp('delivery')),
          Ios18AppIcon(title: '동행복권', imageAsset: 'assets/images/lottery_icon.webp', onTap: () => _openApp('lottery')),
          Ios18AppIcon(title: '블루스크린', customIcon: Container(color: const Color(0xFF0078D7), child: const Icon(CupertinoIcons.device_desktop, color: Colors.white, size: 28)), onTap: () => _openApp('windows_bsod')),
        ],
      ),
    );
  }

  // Page 3: iOS 18 순정 앱 보관함 (App Library)
  Widget _buildPage3AppLibrary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // 앱 보관함 글래스 검색바
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.22),
                width: 0.6,
              ),
            ),
            child: const Row(
              children: [
                Icon(CupertinoIcons.search, color: Colors.white70, size: 16),
                SizedBox(width: 8),
                Text(
                  '앱 보관함',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Spacer(),
                Icon(CupertinoIcons.mic_fill, color: Colors.white70, size: 16),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2x2 대형 카테고리 폴더 그리드
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.88,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildCategoryFolder('추천', [
                  {'id': 'phone', 'image': 'assets/images/ios/icons/phone.png'},
                  {'id': 'safari', 'image': 'assets/images/ios/icons/safari.png'},
                  {'id': 'messages', 'image': 'assets/images/ios/icons/messages.png', 'badge': 3},
                  {'id': 'kakaotalk', 'image': 'assets/images/kakaotalk_icon.webp', 'badge': 99},
                ]),
                _buildCategoryFolder('소셜', [
                  {'id': 'instagram', 'image': 'assets/images/instagram_icon.webp', 'badge': 5},
                  {'id': 'facetime', 'image': 'assets/images/ios/icons/facetime.png'},
                  {'id': 'mail', 'image': 'assets/images/ios/icons/mail.png', 'badge': 14},
                  {'id': 'messages', 'image': 'assets/images/ios/icons/messages.png'},
                ]),
                _buildCategoryFolder('엔터테인먼트', [
                  {'id': 'youtube', 'custom': Container(color: Colors.red, child: const Icon(CupertinoIcons.play_arrow_solid, color: Colors.white, size: 20))},
                  {'id': 'netflix', 'image': 'assets/images/netflix_icon.webp'},
                  {'id': 'music', 'image': 'assets/images/ios/icons/music.png'},
                  {'id': 'photos', 'image': 'assets/images/ios/icons/photos.png'},
                ]),
                _buildCategoryFolder('유틸리티', [
                  {'id': 'settings', 'image': 'assets/images/ios/icons/settings.png'},
                  {'id': 'calculator', 'image': 'assets/images/ios/icons/calculator.png'},
                  {'id': 'clock', 'image': 'assets/images/ios/icons/clock.png'},
                  {'id': 'files', 'image': 'assets/images/ios/icons/files.png'},
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 앱 보관함 카테고리 폴더 카드
  Widget _buildCategoryFolder(String title, List<Map<String, dynamic>> apps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.22),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                physics: const NeverScrollableScrollPhysics(),
                children: apps.take(4).map((app) {
                  return Ios18AppIcon(
                    title: '',
                    size: 42,
                    imageAsset: app['image'] as String?,
                    customIcon: app['custom'] as Widget?,
                    badgeCount: app['badge'] as int?,
                    onTap: () => _openApp(app['id'] as String),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            shadows: [
              Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 1)),
            ],
          ),
        ),
      ],
    );
  }

  // iOS 18 페이지 인디케이터 도트 & 검색 캡슐
  Widget _buildPageIndicator() {
    return GestureDetector(
      onTap: () {
        final nextPage = (_currentPage + 1) % 3;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
        );
      },
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.24),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.16),
            width: 0.6,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 6,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  CupertinoIcons.search,
                  size: 11,
                  color: Colors.white70,
                ),
                const SizedBox(width: 4),
                const Text(
                  '검색',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(width: 8),
                // 3개의 페이지 인디케이터 점
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    final isActive = _currentPage == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: isActive ? 6.0 : 4.5,
                      height: isActive ? 6.0 : 4.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.35),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  blurRadius: 4,
                                ),
                              ]
                            : null,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 실행된 가상 앱 오버레이
  Widget _buildAppOverlay() {
    Widget appContent;

    switch (_activeApp) {
      case 'settings':
        appContent = Ios18SettingsView(
          user: widget.user,
          currentWallpaper: _activeWallpaper,
          onSelectWallpaper: (key) => setState(() => _activeWallpaper = key),
          onSignOut: widget.onSignOut,
          onGoHome: widget.onGoHome,
          onClose: _closeApp,
        );
        break;

      default:
        appContent = Container(
          color: const Color(0xFF121212),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_activeApp?.toUpperCase()}',
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  '하단 홈 바를 위로 올리거나 탭하면\n홈 화면으로 돌아갑니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),
        );
        break;
    }

    return Stack(
      children: [
        // 앱 본체
        Positioned.fill(child: appContent),

        // 앱 내부 상단 상태바
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Ios18StatusBar(timeString: widget.timeString),
          ),
        ),

        // 하단 홈 인디케이터 (탭/스와이프 시 앱 닫기)
        Positioned(
          bottom: 6,
          left: 0,
          right: 0,
          child: Ios18HomeIndicator(onHome: _closeApp),
        ),
      ],
    );
  }
}
