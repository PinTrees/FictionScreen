import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../ios18/apps/settings/ios18_settings_view.dart';
import 'models/ios26_app_item.dart';
import 'widgets/ios26_app_icon.dart';
import 'widgets/ios26_control_center.dart';
import 'widgets/ios26_dock.dart';
import 'widgets/ios26_home_indicator.dart';
import 'widgets/ios26_jiggle.dart';
import 'widgets/ios26_liquid_glass.dart';
import 'widgets/ios26_reorderable_grid.dart';
import 'widgets/ios26_status_bar.dart';
import 'widgets/ios26_widget_card.dart';

/// iPhone 17/18 Pro iOS 26 공식 리퀴드 글래스 (Liquid Glass) 모바일 홈스크린 뷰
/// - WWDC 2025 공식 광학 공식 (채도 증폭 + 프리즘 색수차 분산 + 코너 글로우 + 메니스커스 렌즈 굴절)
/// - 상태바 우측 드래그 다운 제어 센터 (Control Center) 연동
/// - 좌우 슬라이드 멀티 페이지 (PageView)
/// - 롱프레스 홈 화면 편집 모드 (드래그 앤 드롭 실시간 위치 스왑, 지글 물리 흔들림, '-' 삭제 배지, 완료 버튼)
class Ios26View extends StatefulWidget {
  final User? user;
  final String timeString;
  final String dateString;
  final String currentWallpaper;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;

  const Ios26View({
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
  State<Ios26View> createState() => _Ios26ViewState();
}

class _Ios26ViewState extends State<Ios26View> {
  late String _activeWallpaper;
  String? _activeApp;
  late final PageController _pageController;
  int _currentPage = 0;
  bool _isEditMode = false;
  bool _isControlCenterOpen = false;

  late List<Ios26AppItem> _page1Apps;
  late List<Ios26AppItem> _page2Apps;

  @override
  void initState() {
    super.initState();
    _activeWallpaper = widget.currentWallpaper.startsWith('ios26')
        ? widget.currentWallpaper
        : 'ios26_dark';
    _pageController = PageController();

    _page1Apps = [
      const Ios26AppItem(id: 'facetime', title: 'FaceTime', imageAsset: 'assets/images/ios/icons26/facetime.png'),
      const Ios26AppItem(id: 'photos', title: '사진', imageAsset: 'assets/images/ios/icons26/photos.png'),
      const Ios26AppItem(id: 'camera', title: '카메라', imageAsset: 'assets/images/ios/icons26/camera.png'),
      const Ios26AppItem(id: 'mail', title: '메일', imageAsset: 'assets/images/ios/icons26/mail.png', badgeCount: 14),
      const Ios26AppItem(id: 'clock', title: '시계', imageAsset: 'assets/images/ios/icons26/clock.png'),
      const Ios26AppItem(id: 'maps', title: '지도', imageAsset: 'assets/images/ios/icons26/maps.png'),
      const Ios26AppItem(id: 'notes', title: '메모', imageAsset: 'assets/images/ios/icons26/notes.png'),
      const Ios26AppItem(id: 'calculator', title: '계산기', imageAsset: 'assets/images/ios/icons26/calculator.png'),
      const Ios26AppItem(id: 'files', title: '파일', imageAsset: 'assets/images/ios/icons26/files.png'),
      const Ios26AppItem(id: 'health', title: '건강', imageAsset: 'assets/images/ios/icons26/health.png'),
      const Ios26AppItem(id: 'wallet', title: '지갑', imageAsset: 'assets/images/ios/icons26/wallet.png'),
      const Ios26AppItem(id: 'settings', title: '설정', imageAsset: 'assets/images/ios/icons26/settings.png'),
    ];

    _page2Apps = [
      const Ios26AppItem(id: 'appstore', title: 'App Store', imageAsset: 'assets/images/ios/icons26/appstore.png'),
      const Ios26AppItem(id: 'books', title: '도서', imageAsset: 'assets/images/ios/icons26/books.png'),
      const Ios26AppItem(id: 'podcasts', title: '팟캐스트', imageAsset: 'assets/images/ios/icons26/podcasts.png'),
      const Ios26AppItem(id: 'stocks', title: '주식', imageAsset: 'assets/images/ios/icons26/stocks.png'),
      const Ios26AppItem(id: 'reminders', title: '미리알림', imageAsset: 'assets/images/ios/icons26/reminders.png'),
      const Ios26AppItem(id: 'fitness', title: '피트니스', imageAsset: 'assets/images/ios/icons26/fitness.png'),
      const Ios26AppItem(id: 'translate', title: '번역', imageAsset: 'assets/images/ios/icons26/translate.png'),
      const Ios26AppItem(id: 'shortcuts', title: '단축어', imageAsset: 'assets/images/ios/icons26/shortcuts.png'),
      const Ios26AppItem(id: 'kakaotalk', title: '카카오톡', imageAsset: 'assets/images/kakaotalk_icon.webp', badgeCount: 99),
      const Ios26AppItem(id: 'instagram', title: 'Instagram', imageAsset: 'assets/images/instagram_icon.webp', badgeCount: 5),
      Ios26AppItem(
        id: 'youtube',
        title: 'YouTube',
        customIcon: Container(
          color: Colors.red,
          child: const Icon(CupertinoIcons.play_arrow_solid, color: Colors.white, size: 28),
        ),
      ),
      const Ios26AppItem(id: 'netflix', title: 'Netflix', imageAsset: 'assets/images/netflix_icon.webp'),
      const Ios26AppItem(id: 'coupang', title: '쿠팡', imageAsset: 'assets/images/coupang_icon.webp'),
      Ios26AppItem(
        id: 'delivery',
        title: '배달의민족',
        customIcon: Container(
          color: const Color(0xFF2AC1BC),
          child: const Icon(CupertinoIcons.bag_fill, color: Colors.white, size: 28),
        ),
      ),
      const Ios26AppItem(id: 'lottery', title: '동행복권', imageAsset: 'assets/images/lottery_icon.webp'),
      Ios26AppItem(
        id: 'windows_bsod',
        title: '블루스크린',
        customIcon: Container(
          color: const Color(0xFF0078D7),
          child: const Icon(CupertinoIcons.device_desktop, color: Colors.white, size: 28),
        ),
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _enterEditMode() {
    if (!_isEditMode) {
      setState(() {
        _isEditMode = true;
      });
    }
  }

  void _exitEditMode() {
    if (_isEditMode) {
      setState(() {
        _isEditMode = false;
      });
    }
  }

  void _toggleControlCenter(bool open) {
    setState(() {
      _isControlCenterOpen = open;
    });
  }

  void _onReorderPage1(int oldIndex, int newIndex) {
    setState(() {
      final item = _page1Apps.removeAt(oldIndex);
      _page1Apps.insert(newIndex, item);
    });
  }

  void _onReorderPage2(int oldIndex, int newIndex) {
    setState(() {
      final item = _page2Apps.removeAt(oldIndex);
      _page2Apps.insert(newIndex, item);
    });
  }

  void _openApp(String appId) {
    if (_isEditMode || _isControlCenterOpen) return;

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
      case 'ios26_light':
        return 'assets/images/ios/wallpapers/ios26_light.jpg';
      case 'ios18_light':
        return 'assets/images/ios/wallpapers/ios18_light.png';
      case 'ios18_blue':
        return 'assets/images/ios/wallpapers/ios18_blue.jpg';
      case 'ios18_purple':
        return 'assets/images/ios/wallpapers/ios18_purple.jpg';
      case 'ios18_yellow':
        return 'assets/images/ios/wallpapers/ios18_yellow.jpg';
      case 'ios26_dark':
      default:
        return 'assets/images/ios/wallpapers/ios26_dark.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isDesktop = media.size.width > 550;

    if (isDesktop) {
      return Container(
        color: const Color(0xFF0F1117),
        child: Center(
          child: _buildIphoneDeviceFrame(media.size.height),
        ),
      );
    }

    return _buildPhoneScreen(isFrame: false);
  }

  Widget _buildIphoneDeviceFrame(double screenHeight) {
    final double targetHeight = (screenHeight * 0.94).clamp(720.0, 920.0);
    final double targetWidth = (targetHeight * (393.0 / 852.0)).clamp(385.0, 440.0);

    return Container(
      width: targetWidth,
      height: targetHeight,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(54),
        border: Border.all(
          color: const Color(0xFF4B4F58),
          width: 4.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.75),
            blurRadius: 50,
            spreadRadius: 8,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.12),
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

  Widget _buildPhoneScreen({required bool isFrame}) {
    return Stack(
      children: [
        // 1. 공식 고화질 iOS 배경화면 (좌우 스와이프 제스처 지원)
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              if (_isControlCenterOpen) {
                _toggleControlCenter(false);
                return;
              }
              _exitEditMode();
            },
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! < -80 && _currentPage < 2) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeOutCubic,
                  );
                } else if (details.primaryVelocity! > 80 && _currentPage > 0) {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeOutCubic,
                  );
                }
              }
            },
            behavior: HitTestBehavior.translucent,
            child: Image.asset(
              _getWallpaperAsset(),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),

        // 2. 홈 스크린 본체 콘텐츠 (웹뷰 & 모바일 동일 패딩 규격 적용)
        Positioned.fill(
          child: AnimatedScale(
            scale: _isControlCenterOpen ? 0.93 : 1.0,
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            child: SafeArea(
              top: !isFrame,
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(
                  top: isFrame ? 12.0 : 0.0,
                  bottom: isFrame ? 8.0 : (MediaQuery.of(context).padding.bottom > 0 ? 0.0 : 8.0),
                ),
                child: Column(
                  children: [
                    // 최상단 상태바 & 다이내믹 아일랜드 (드래그 다운 / 우측 탭 시 제어 센터 열림)
                    Ios26StatusBar(
                      timeString: widget.timeString,
                      onOpenControlCenter: () => _toggleControlCenter(true),
                    ),

                    // 편집 모드 헤더
                    AnimatedCrossFade(
                      firstChild: const SizedBox(height: 8),
                      secondChild: _buildEditModeHeader(),
                      crossFadeState: _isEditMode
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 200),
                    ),

                    // 좌우 슬라이드 PageView (웹/모바일/마우스/터치 전방위 드래그 지원)
                    Expanded(
                      child: ScrollConfiguration(
                        behavior: const Ios26ScrollBehavior(),
                        child: PageView(
                          controller: _pageController,
                          physics: const BouncingScrollPhysics(),
                          onPageChanged: (page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          children: [
                            _buildPage1(),
                            _buildPage2(),
                            _buildPage3AppLibrary(),
                          ],
                        ),
                      ),
                    ),

                    // iOS 26 리퀴드 글래스 검색 캡슐 (Search Capsule)
                    _buildSearchCapsule(),
                    const SizedBox(height: 10),

                  // 3. Apple 공식 리퀴드 글래스 독 (Dock)
                  Ios26Dock(
                    onOpenApp: _openApp,
                    isEditMode: _isEditMode,
                    onEnterEditMode: _enterEditMode,
                  ),
                  const SizedBox(height: 10),

                  // 4. 하단 홈 인디케이터 바
                  Ios26HomeIndicator(onHome: () {
                    if (_isControlCenterOpen) {
                      _toggleControlCenter(false);
                      return;
                    }
                    if (_isEditMode) {
                      _exitEditMode();
                      return;
                    }
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
        ),
      ),

        // 3. 앱 실행 오버레이
        if (_activeApp != null)
          Positioned.fill(
            child: _buildAppOverlay(),
          ),

        // 4. iOS 26 공식 리퀴드 글래스 제어 센터 (슬라이드 다운 오버레이)
        if (_isControlCenterOpen)
          Positioned.fill(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: -1.0, end: 0.0),
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              builder: (context, offset, child) {
                return FractionalTranslation(
                  translation: Offset(0, offset),
                  child: child,
                );
              },
              child: Ios26ControlCenter(
                onClose: () => _toggleControlCenter(false),
                onOpenApp: (appId) {
                  _toggleControlCenter(false);
                  _openApp(appId);
                },
              ),
            ),
          ),
      ],
    );
  }

  // 홈 화면 편집 모드 상단 헤더
  Widget _buildEditModeHeader() {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 좌측 '+' 위젯 추가 버튼
          Ios26LiquidGlass(
            width: 34,
            height: 34,
            borderRadius: 17,
            blurSigma: 24,
            hasCornerGlow: false,
            child: const Center(
              child: Icon(CupertinoIcons.plus, color: Colors.white, size: 18),
            ),
          ),

          // 우측 '완료' 리퀴드 글래스 캡슐 버튼
          GestureDetector(
            onTap: _exitEditMode,
            child: Ios26LiquidGlass(
              borderRadius: 16,
              blurSigma: 24,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: const Text(
                '완료',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Page 1: 상단 리퀴드 위젯 + 드래그 앤 드롭 앱 그리드
  Widget _buildPage1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Ios26Jiggle(
                  isJiggling: _isEditMode,
                  index: 90,
                  child: Ios26WeatherWidget(
                    onTap: () => _openApp('weather'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Ios26Jiggle(
                  isJiggling: _isEditMode,
                  index: 91,
                  child: Ios26CalendarWidget(
                    onTap: () => _openApp('calendar'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Expanded(
            child: Ios26ReorderableGrid(
              items: _page1Apps,
              isEditMode: _isEditMode,
              iconSize: 64.0,
              onReorder: _onReorderPage1,
              onOpenApp: _openApp,
              onEnterEditMode: _enterEditMode,
              onDeleteItem: (item) {
                setState(() {
                  _page1Apps.remove(item);
                });
              },
              physics: const NeverScrollableScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }

  // Page 2: 4행 x 4열 드래그 앤 드롭 앱 그리드
  Widget _buildPage2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Ios26ReorderableGrid(
        items: _page2Apps,
        isEditMode: _isEditMode,
        iconSize: 64.0,
        onReorder: _onReorderPage2,
        onOpenApp: _openApp,
        onEnterEditMode: _enterEditMode,
        onDeleteItem: (item) {
          setState(() {
            _page2Apps.remove(item);
          });
        },
        physics: const BouncingScrollPhysics(),
      ),
    );
  }

  // Page 3: iOS 26 앱 보관함 (App Library)
  Widget _buildPage3AppLibrary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Ios26LiquidGlass(
            height: 40,
            borderRadius: 14,
            blurSigma: 24,
            padding: const EdgeInsets.symmetric(horizontal: 14),
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

          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.88,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildCategoryFolder('추천', [
                  {'id': 'phone', 'image': 'assets/images/ios/icons26/phone.png'},
                  {'id': 'safari', 'image': 'assets/images/ios/icons26/safari.png'},
                  {'id': 'messages', 'image': 'assets/images/ios/icons26/messages.png', 'badge': 3},
                  {'id': 'kakaotalk', 'image': 'assets/images/kakaotalk_icon.webp', 'badge': 99},
                ]),
                _buildCategoryFolder('소셜', [
                  {'id': 'instagram', 'image': 'assets/images/instagram_icon.webp', 'badge': 5},
                  {'id': 'facetime', 'image': 'assets/images/ios/icons26/facetime.png'},
                  {'id': 'mail', 'image': 'assets/images/ios/icons26/mail.png', 'badge': 14},
                  {'id': 'messages', 'image': 'assets/images/ios/icons26/messages.png'},
                ]),
                _buildCategoryFolder('엔터테인먼트', [
                  {'id': 'youtube', 'custom': Container(color: Colors.red, child: const Icon(CupertinoIcons.play_arrow_solid, color: Colors.white, size: 20))},
                  {'id': 'netflix', 'image': 'assets/images/netflix_icon.webp'},
                  {'id': 'music', 'image': 'assets/images/ios/icons26/music.png'},
                  {'id': 'photos', 'image': 'assets/images/ios/icons26/photos.png'},
                ]),
                _buildCategoryFolder('유틸리티', [
                  {'id': 'settings', 'image': 'assets/images/ios/icons26/settings.png'},
                  {'id': 'calculator', 'image': 'assets/images/ios/icons26/calculator.png'},
                  {'id': 'clock', 'image': 'assets/images/ios/icons26/clock.png'},
                  {'id': 'files', 'image': 'assets/images/ios/icons26/files.png'},
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFolder(String title, List<Map<String, dynamic>> apps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Ios26LiquidGlass(
          borderRadius: 26,
          blurSigma: 30,
          padding: const EdgeInsets.all(12),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            physics: const NeverScrollableScrollPhysics(),
            children: apps.take(4).map((app) {
              return Ios26AppIcon(
                title: '',
                size: 46,
                imageAsset: app['image'] as String?,
                customIcon: app['custom'] as Widget?,
                badgeCount: app['badge'] as int?,
                onTap: () => _openApp(app['id'] as String),
              );
            }).toList(),
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

  /// Apple iOS 26 공식 리퀴드 글래스 검색 (Search) 캡슐
  /// - media_1789742479750.png 1:1 일치
  Widget _buildSearchCapsule() {
    return GestureDetector(
      onTap: () {
        final nextPage = (_currentPage + 1) % 3;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
        );
      },
      child: Ios26LiquidGlass(
        height: 30,
        borderRadius: 15,
        blurSigma: 24,
        hasCornerGlow: false,
        hasChromaticAberration: false,
        tintColor: const Color(0xFF0F3A6E),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.search,
              size: 13,
              color: Colors.white,
            ),
            SizedBox(width: 5),
            Text(
              'Search',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        Positioned.fill(child: appContent),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Ios26StatusBar(
              timeString: widget.timeString,
              onOpenControlCenter: () => _toggleControlCenter(true),
            ),
          ),
        ),
        Positioned(
          bottom: 6,
          left: 0,
          right: 0,
          child: Ios26HomeIndicator(onHome: _closeApp),
        ),
      ],
    );
  }
}

/// 웹(Chrome, Edge 등) 및 모바일 환경에서 마우스 드래그, 터치, 트랙패드 스와이프를 모두 지원하는 스크롤 비헤이비어
class Ios26ScrollBehavior extends MaterialScrollBehavior {
  const Ios26ScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}

