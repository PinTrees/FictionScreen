import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fiction_screen/pages/console/common/os_app_item.dart';
import '../../apps/calculator/calculator_window.dart';
import '../../apps/gallery/gallery_window.dart';
import '../../apps/internet/internet_window.dart';
import '../../apps/messages/messages_window.dart';
import '../../apps/my_files/my_files_window.dart';
import '../../apps/phone/phone_window.dart';
import '../../apps/settings/settings_window.dart';
import 'widgets/oneui9_app_drawer.dart';
import 'widgets/oneui9_brief_page.dart';
import 'widgets/oneui9_home_widgets.dart';
import 'widgets/oneui9_quick_settings.dart';
import 'widgets/oneui9_status_bar.dart';

/// Samsung Galaxy One UI 9 플래그십 모바일 홈스크린 뷰 (media_1789750911144.png 1:1 레퍼런스 싱크)
class OneUi9View extends StatefulWidget {
  final String timeString;
  final String dateString;
  final String currentWallpaper;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;

  const OneUi9View({
    super.key,
    required this.timeString,
    required this.dateString,
    required this.currentWallpaper,
    required this.onOpenTemplate,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
  });

  @override
  State<OneUi9View> createState() => _OneUi9ViewState();
}

class _OneUi9ViewState extends State<OneUi9View> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 1; // 0: Now Brief AI 보드, 1: 메인 홈, 2: 보조 앱 페이지

  late AnimationController _panelController;
  late Animation<double> _panelAnimation;

  bool _isAppDrawerOpen = false;
  String? _activeGalaxyApp;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
    _panelController = AnimationController(vsync: this, duration: const Duration(milliseconds: 320));
    _panelAnimation = CurvedAnimation(parent: _panelController, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _panelController.dispose();
    super.dispose();
  }

  void _openGalaxyApp(String appId) => setState(() => _activeGalaxyApp = appId);
  void _closeGalaxyApp() => setState(() => _activeGalaxyApp = null);

  void _openQuickPanel() => _panelController.forward();
  void _closeQuickPanel() => _panelController.reverse();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // 1. One UI 9 바이올렛 커브드 시그니처 배경화면
        Positioned.fill(child: _buildGalaxyWallpaper()),

        // 2. 메인 홈스크린 UI (상태바, 위젯, 앱, 도크, 3버튼 내비게이션)
        Positioned.fill(
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // 상단 상태바 (실시간 드래그 다운 제스처 연동)
                OneUi9StatusBar(
                  timeString: widget.timeString,
                  onVerticalDragStart: (_) {},
                  onVerticalDragUpdate: (details) {
                    if (screenHeight > 0) {
                      _panelController.value = (_panelController.value + (details.primaryDelta! / screenHeight) * 1.6).clamp(0.0, 1.0);
                    }
                  },
                  onVerticalDragEnd: (details) {
                    if (details.primaryVelocity != null && details.primaryVelocity! > 250) {
                      _panelController.forward();
                    } else if (details.primaryVelocity != null && details.primaryVelocity! < -250) {
                      _panelController.reverse();
                    } else if (_panelController.value > 0.25) {
                      _panelController.forward();
                    } else {
                      _panelController.reverse();
                    }
                  },
                  onTap: _openQuickPanel,
                ),

                // 좌우 슬라이드 PageView 영역 (Now Brief -> 메인 1:1 홈 -> 서브 페이지)
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (page) => setState(() => _currentPage = page),
                    children: [
                      OneUi9BriefPage(dateString: widget.dateString, onOpenTemplate: () => widget.onOpenTemplate('kakaotalk')),
                      _buildMainHomePage(),
                      _buildSecondaryAppsPage(),
                    ],
                  ),
                ),

                // 페이지 인디케이터 (3개 점: 가운데 활성화)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPageDot(0),
                      const SizedBox(width: 7),
                      _buildPageDot(1),
                      const SizedBox(width: 7),
                      _buildPageDot(2),
                    ],
                  ),
                ),

                // 3. 하단 도크 (4대 핵심 앱: 전화, 메시지, 인터넷, 카메라)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDockButton(_buildPhoneDockIcon(), () => _openGalaxyApp('phone')),
                      _buildDockButton(_buildMessagesDockIcon(), () => _openGalaxyApp('messages')),
                      _buildDockButton(const OneUi9InternetIcon(), () => _openGalaxyApp('internet')),
                      _buildDockButton(const OneUi9CameraIcon(), () => _openGalaxyApp('gallery')),
                    ],
                  ),
                ),

                // 4. 하단 3버튼 내비게이션 바 (||| , O , <)
                Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => setState(() => _isAppDrawerOpen = true),
                        icon: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _NavLine(), SizedBox(width: 3.5),
                            _NavLine(), SizedBox(width: 3.5),
                            _NavLine(),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_currentPage != 1) {
                            _pageController.animateToPage(1, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
                          }
                        },
                        icon: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(border: Border.all(color: Colors.white70, width: 2), borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_currentPage > 0) {
                            _pageController.animateToPage(_currentPage - 1, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
                          }
                        },
                        icon: const Icon(CupertinoIcons.chevron_left, color: Colors.white70, size: 19),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),

        // 5. 삼성 기본 앱 전체화면 오버레이
        if (_activeGalaxyApp != null)
          Positioned.fill(child: _buildGalaxyAppWidget(_activeGalaxyApp!)),

        // 6. One UI 9 최신 퀵 세팅 패널 (실시간 드래그 다운 연동)
        AnimatedBuilder(
          animation: _panelAnimation,
          builder: (context, child) {
            final progress = _panelAnimation.value;
            if (progress <= 0.0) return const SizedBox.shrink();

            return Positioned.fill(
              child: Transform.translate(
                offset: Offset(0, -screenHeight * (1.0 - progress)),
                child: child,
              ),
            );
          },
          child: OneUi9QuickSettings(
            timeString: widget.timeString,
            dateString: widget.dateString,
            onClose: _closeQuickPanel,
            onOpenSettings: widget.onOpenSettings,
            onDragUpdate: (details) {
              if (screenHeight > 0) {
                _panelController.value = (_panelController.value + (details.primaryDelta! / screenHeight) * 1.6).clamp(0.0, 1.0);
              }
            },
            onDragEnd: (details) {
              if (details.primaryVelocity != null && details.primaryVelocity! < -250) {
                _panelController.reverse();
              } else if (details.primaryVelocity != null && details.primaryVelocity! > 250) {
                _panelController.forward();
              } else if (_panelController.value < 0.75) {
                _panelController.reverse();
              } else {
                _panelController.forward();
              }
            },
          ),
        ),

        // 7. One UI 9 전체 앱 서랍 (App Drawer)
        if (_isAppDrawerOpen)
          Positioned.fill(
            child: OneUi9AppDrawer(
              onClose: () => setState(() => _isAppDrawerOpen = false),
              onOpenGalaxyApp: _openGalaxyApp,
              onOpenTemplate: widget.onOpenTemplate,
              onGoHome: widget.onGoHome,
              onSignOut: widget.onSignOut,
            ),
          ),
      ],
    );
  }

  /// media_1789750911144.png 1:1 완벽 홈 화면 구현
  Widget _buildMainHomePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // 1. 상단 2열 위젯 섹션 (좌: 날씨 2x2 카드, 우: Now brief + Start 헬스 필)
          SizedBox(
            height: 148,
            child: Row(
              children: [
                Expanded(child: OneUi9WeatherCard(onTap: _openQuickPanel)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OneUi9NowBriefCapsule(onTap: () => widget.onOpenTemplate('kakaotalk')),
                      OneUi9HealthStartCapsule(onTap: () => widget.onOpenTemplate('toss')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. Google 검색 캡슐 바
          OneUi9GoogleSearchCapsule(onTap: () => setState(() => _isAppDrawerOpen = true)),
          const SizedBox(height: 28),

          // 3. 홈 화면 1열 메인 앱 (Store, Gallery, Play Store, Google 폴더)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OneUi9AppItem(label: 'Store', iconWidget: const OneUi9StoreIcon(), onTap: () => setState(() => _isAppDrawerOpen = true)),
              OneUi9AppItem(label: 'Gallery', iconWidget: const OneUi9GalleryIcon(), onTap: () => _openGalaxyApp('gallery')),
              OneUi9AppItem(label: 'Play Store', iconWidget: const OneUi9PlayStoreIcon(), badgeCount: 2, onTap: () => widget.onOpenTemplate('kakaotalk')),
              OneUi9GoogleFolderWidget(badgeCount: 1, onTap: () => setState(() => _isAppDrawerOpen = true)),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildSecondaryAppsPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Image.asset('assets/images/galaxy/icons/galaxy_store.png', width: 42, height: 42),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Galaxy AI & 삼성 스토어', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        Text('One UI 9 맞춤 테마와 앱을 다운로드하세요', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 10,
              childAspectRatio: 0.8,
              children: [
                OsAppItem(title: '카카오톡', imageAsset: 'assets/images/kakaotalk_icon.webp', backgroundColor: const Color(0xFFFEE500), isDesktop: false, onTap: () => widget.onOpenTemplate('kakaotalk')),
                OsAppItem(title: '토스', icon: CupertinoIcons.money_dollar_circle_fill, iconColor: Colors.white, backgroundColor: const Color(0xFF0050FF), isDesktop: false, onTap: () => widget.onOpenTemplate('toss')),
                OsAppItem(title: 'Instagram', imageAsset: 'assets/images/instagram_icon.webp', isDesktop: false, onTap: () => widget.onOpenTemplate('instagram')),
                OsAppItem(title: 'YouTube', icon: CupertinoIcons.play_arrow_solid, iconColor: Colors.white, backgroundColor: const Color(0xFFFF0000), isDesktop: false, onTap: () => widget.onOpenTemplate('youtube')),
                OsAppItem(title: '쿠팡', imageAsset: 'assets/images/coupang_icon.webp', isDesktop: false, onTap: () => widget.onOpenTemplate('coupang')),
                OsAppItem(title: 'Netflix', imageAsset: 'assets/images/netflix_icon.webp', isDesktop: false, onTap: () => widget.onOpenTemplate('netflix')),
                OsAppItem(title: 'Samsung Notes', imageAsset: 'assets/images/galaxy/icons/notes.png', backgroundColor: const Color(0xFFEA580C), isDesktop: false, onTap: () => _openGalaxyApp('messages')),
                OsAppItem(title: '계산기', icon: CupertinoIcons.number, iconColor: Colors.white, backgroundColor: const Color(0xFF059669), isDesktop: false, onTap: () => _openGalaxyApp('calculator')),
                OsAppItem(title: '내 파일', icon: CupertinoIcons.folder_fill, iconColor: Colors.white, backgroundColor: const Color(0xFFD97706), isDesktop: false, onTap: () => _openGalaxyApp('my_files')),
                OsAppItem(title: '설정', icon: CupertinoIcons.gear_alt_fill, iconColor: Colors.white, backgroundColor: const Color(0xFF475569), isDesktop: false, onTap: () => _openGalaxyApp('settings')),
                OsAppItem(title: '랜딩 홈', icon: CupertinoIcons.house_fill, iconColor: Colors.white, backgroundColor: const Color(0xFF334155), isDesktop: false, onTap: widget.onGoHome),
                OsAppItem(title: '로그아웃', icon: CupertinoIcons.square_arrow_right, iconColor: Colors.white, backgroundColor: const Color(0xFFEF4444), isDesktop: false, onTap: widget.onSignOut),
              ],
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildPageDot(int pageIndex) {
    final bool isSelected = _currentPage == pageIndex;
    return GestureDetector(
      onTap: () => _pageController.animateToPage(pageIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeOutCubic),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSelected ? 7 : 5,
        height: isSelected ? 7 : 5,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.35),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildDockButton(Widget child, VoidCallback onTap) {
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(18), child: child);
  }

  Widget _buildPhoneDockIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF22C55E),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: const Color(0xFF22C55E).withValues(alpha: 0.35), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: const Center(child: Icon(CupertinoIcons.phone_fill, color: Colors.white, size: 28)),
    );
  }

  Widget _buildMessagesDockIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: const Center(child: Icon(CupertinoIcons.chat_bubble_fill, color: Color(0xFF2563EB), size: 28)),
    );
  }

  Widget _buildGalaxyAppWidget(String appId) {
    switch (appId) {
      case 'phone': return SamsungPhoneWindow(onClose: _closeGalaxyApp);
      case 'messages': return SamsungMessagesWindow(onClose: _closeGalaxyApp);
      case 'gallery': return SamsungGalleryWindow(onClose: _closeGalaxyApp);
      case 'settings': return SamsungSettingsWindow(onClose: _closeGalaxyApp, onOpenSystemSettings: widget.onOpenSettings);
      case 'internet': return SamsungInternetWindow(onClose: _closeGalaxyApp);
      case 'calculator': return SamsungCalculatorWindow(onClose: _closeGalaxyApp);
      case 'my_files': return SamsungMyFilesWindow(onClose: _closeGalaxyApp);
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildGalaxyWallpaper() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF6342E8), Color(0xFF5331D8), Color(0xFF4320C2)],
        ),
      ),
      child: CustomPaint(painter: _OneUi9SignatureCurvesPainter()),
    );
  }
}

/// One UI 9 시그니처 바이올렛 커브드 곡선 페인터 (media_1789750911144.png 1:1 싱크)
class _OneUi9SignatureCurvesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 상단 라벤더 발광 구체
    final topCirclePaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFF8B6DF8).withValues(alpha: 0.45), const Color(0xFF6342E8).withValues(alpha: 0.0)],
      ).createShader(Rect.fromCircle(center: Offset(w * 0.5, h * 0.35), radius: w * 0.48));
    canvas.drawCircle(Offset(w * 0.5, h * 0.35), w * 0.48, topCirclePaint);

    // 하단 라벤더 발광 구체
    final bottomCirclePaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFF9070FA).withValues(alpha: 0.4), const Color(0xFF4320C2).withValues(alpha: 0.0)],
      ).createShader(Rect.fromCircle(center: Offset(w * 0.5, h * 0.65), radius: w * 0.52));
    canvas.drawCircle(Offset(w * 0.5, h * 0.65), w * 0.52, bottomCirclePaint);

    // 부드러운 우측 백라이트 하이라이트
    final edgeGlow = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFA78BFA).withValues(alpha: 0.25), Colors.transparent],
      ).createShader(Rect.fromCircle(center: Offset(w, h * 0.4), radius: w * 0.6));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), edgeGlow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NavLine extends StatelessWidget {
  const _NavLine();
  @override
  Widget build(BuildContext context) {
    return Container(width: 2.2, height: 14, decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(1.5)));
  }
}
