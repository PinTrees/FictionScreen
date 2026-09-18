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
import 'widgets/oneui9_now_bar.dart';
import 'widgets/oneui9_quick_settings.dart';
import 'widgets/oneui9_status_bar.dart';

/// Samsung Galaxy One UI 9 플래그십 모바일 홈스크린 뷰
/// - 실시간 드래그 다운/업 퀵 세팅 패널 연동 (media_1789750829725.png 디자인 적용)
/// - 좌우 멀티페이지 슬라이드 (PageView)
/// - 깃허브 공식 One UI 아이콘 및 고해상도 배경화면 탑재
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
        // 1. One UI 9 공식 고해상도 배경화면
        Positioned.fill(child: _buildGalaxyWallpaper()),

        // 2. 메인 홈스크린 및 슬라이드 콘텐츠
        Positioned.fill(
          child: Column(
            children: [
              // 상단 상태바 & 실시간 드래그 다운 제스처 연동
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
              const SizedBox(height: 4),

              // One UI 9 라이브 Now Bar 캡슐 (탭 시 퀵 패널 오픈)
              OneUi9NowBar(onTap: _openQuickPanel),
              const SizedBox(height: 6),

              // 좌우 슬라이드 PageView 영역 (Now Brief -> 메인 홈 -> 서브 페이지)
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

              // 페이지 인디케이터 (좌우 슬라이드 위치 표시 점)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPageDot(0),
                    const SizedBox(width: 6),
                    _buildPageDot(1),
                    const SizedBox(width: 6),
                    _buildPageDot(2),
                  ],
                ),
              ),

              // 3. 하단 고정 도크 (5대 핵심 앱)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDockIcon('전화', CupertinoIcons.phone_fill, const Color(0xFF10B981), () => _openGalaxyApp('phone')),
                    _buildDockIcon('메시지', null, const Color(0xFF3B82F6), () => _openGalaxyApp('messages'), image: 'assets/images/galaxy/icons/messages.png'),
                    _buildDockIcon('인터넷', null, const Color(0xFF6366F1), () => _openGalaxyApp('internet'), image: 'assets/images/galaxy/icons/internet.png'),
                    _buildDockIcon('갤러리', CupertinoIcons.photo_fill_on_rectangle_fill, const Color(0xFFF59E0B), () => _openGalaxyApp('gallery')),
                    _buildDockIcon('설정', CupertinoIcons.gear_alt_fill, const Color(0xFF475569), () => _openGalaxyApp('settings')),
                  ],
                ),
              ),

              // 하단 제스처 내비게이션 인디케이터 바 (탭/위로 스와이프 시 앱 서랍 열림)
              GestureDetector(
                onTap: () => setState(() => _isAppDrawerOpen = true),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  width: 120,
                  height: 5,
                  decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ],
          ),
        ),

        // 4. 삼성 기본 앱 전체화면 오버레이
        if (_activeGalaxyApp != null)
          Positioned.fill(child: _buildGalaxyAppWidget(_activeGalaxyApp!)),

        // 5. One UI 9 최신 퀵 세팅 패널 (상단에서 실시간 드래그 다운 / 업 제스처 연동)
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

        // 6. One UI 9 전체 앱 서랍 (App Drawer)
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

  Widget _buildMainHomePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            OneUi9WeatherClockCard(timeString: widget.timeString, dateString: widget.dateString, onTap: _openQuickPanel),
            const SizedBox(height: 10),
            const OneUi9BatteryWidget(),
            const SizedBox(height: 12),
            OneUi9GalaxyAiSearchBar(onSearchTap: () => setState(() => _isAppDrawerOpen = true), onAiTap: () => setState(() => _isAppDrawerOpen = true)),
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
                OsAppItem(title: '토스 (Toss)', icon: CupertinoIcons.money_dollar_circle_fill, iconColor: Colors.white, backgroundColor: const Color(0xFF0050FF), isDesktop: false, onTap: () => widget.onOpenTemplate('toss')),
                OsAppItem(title: 'Instagram', imageAsset: 'assets/images/instagram_icon.webp', isDesktop: false, onTap: () => widget.onOpenTemplate('instagram')),
                OsAppItem(title: 'YouTube', icon: CupertinoIcons.play_arrow_solid, iconColor: Colors.white, backgroundColor: const Color(0xFFFF0000), isDesktop: false, onTap: () => widget.onOpenTemplate('youtube')),
                OsAppItem(title: '쿠팡', imageAsset: 'assets/images/coupang_icon.webp', isDesktop: false, onTap: () => widget.onOpenTemplate('coupang')),
                OsAppItem(title: 'Netflix', imageAsset: 'assets/images/netflix_icon.webp', isDesktop: false, onTap: () => widget.onOpenTemplate('netflix')),
                OsAppItem(title: '배달의민족', icon: CupertinoIcons.bag_fill, iconColor: Colors.white, backgroundColor: const Color(0xFF2AC1BC), isDesktop: false, onTap: () => widget.onOpenTemplate('delivery')),
                OsAppItem(title: '카메라', icon: CupertinoIcons.camera_fill, iconColor: Colors.white, backgroundColor: const Color(0xFF1E293B), isDesktop: false, onTap: () => _openGalaxyApp('gallery')),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryAppsPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
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
                        Text('최신 AI 기능과 전용 테마를 확인하세요', style: TextStyle(color: Colors.white60, fontSize: 11)),
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
                OsAppItem(title: 'Samsung Notes', imageAsset: 'assets/images/galaxy/icons/notes.png', backgroundColor: const Color(0xFFEA580C), isDesktop: false, onTap: () => _openGalaxyApp('messages')),
                OsAppItem(title: 'Health', imageAsset: 'assets/images/galaxy/icons/health.png', backgroundColor: const Color(0xFF10B981), isDesktop: false, onTap: () {}),
                OsAppItem(title: 'Bixby', imageAsset: 'assets/images/galaxy/icons/bixby.png', backgroundColor: const Color(0xFF3B82F6), isDesktop: false, onTap: () {}),
                OsAppItem(title: 'Galaxy Store', imageAsset: 'assets/images/galaxy/icons/galaxy_store.png', backgroundColor: const Color(0xFFEC4899), isDesktop: false, onTap: () {}),
                OsAppItem(title: '계산기', icon: CupertinoIcons.number, iconColor: Colors.white, backgroundColor: const Color(0xFF059669), isDesktop: false, onTap: () => _openGalaxyApp('calculator')),
                OsAppItem(title: '내 파일', icon: CupertinoIcons.folder_fill, iconColor: Colors.white, backgroundColor: const Color(0xFFD97706), isDesktop: false, onTap: () => _openGalaxyApp('my_files')),
                OsAppItem(title: 'X (Twitter)', icon: CupertinoIcons.conversation_bubble, iconColor: Colors.white, backgroundColor: const Color(0xFF1D9BF0), isDesktop: false, onTap: () => widget.onOpenTemplate('x_twitter')),
                OsAppItem(title: '동행복권', imageAsset: 'assets/images/lottery_icon.webp', isDesktop: false, onTap: () => widget.onOpenTemplate('lottery')),
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
        width: isSelected ? 18 : 6,
        height: 6,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }

  Widget _buildDockIcon(String title, IconData? icon, Color color, VoidCallback onTap, {String? image}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: image != null ? null : color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: (image != null ? Colors.black : color).withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: image != null
            ? Padding(padding: const EdgeInsets.all(4), child: Image.asset(image, fit: BoxFit.contain))
            : Icon(icon, color: Colors.white, size: 26),
      ),
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
    switch (widget.currentWallpaper) {
      case 'sapphire': return Image.asset('assets/images/galaxy/wallpapers/oneui_sapphire.webp', fit: BoxFit.cover);
      case 'emerald': return Image.asset('assets/images/galaxy/wallpapers/oneui_emerald.webp', fit: BoxFit.cover);
      case 'bloom':
        return Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(center: Alignment(0.0, -0.2), radius: 1.2, colors: [Color(0xFF193256), Color(0xFF0F1E38), Color(0xFF090E1A)]),
          ),
        );
      case 'titanium':
      default:
        return Image.asset('assets/images/galaxy/wallpapers/oneui_titanium.webp', fit: BoxFit.cover);
    }
  }
}
