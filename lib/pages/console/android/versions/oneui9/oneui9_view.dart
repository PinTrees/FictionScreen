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
import 'widgets/oneui9_notification_shade.dart';
import 'widgets/oneui9_now_bar.dart';
import 'widgets/oneui9_quick_settings.dart';
import 'widgets/oneui9_status_bar.dart';

/// Samsung Galaxy One UI 9 플래그십 모바일 홈스크린 뷰
/// - Android 17 기반, Galaxy S26 Ultra 플래그십
/// - 좌우 멀티페이지 슬라이드 (PageView: Now Brief AI 보드 <-> 메인 홈 <-> 앱 그리드 2)
/// - 깃허브 공식 One UI 아이콘 및 오피셜 고화질 배경화면 탑재
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

class _OneUi9ViewState extends State<OneUi9View> {
  late PageController _pageController;
  int _currentPage = 1; // 0: Now Brief AI 보드, 1: 메인 홈, 2: 보조 앱 페이지

  bool _isQuickSettingsOpen = false;
  bool _isNotificationShadeOpen = false;
  bool _isAppDrawerOpen = false;
  String? _activeGalaxyApp;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openGalaxyApp(String appId) => setState(() => _activeGalaxyApp = appId);
  void _closeGalaxyApp() => setState(() => _activeGalaxyApp = null);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. One UI 9 공식 고해상도 배경화면
        Positioned.fill(child: _buildGalaxyWallpaper()),

        // 2. 메인 홈스크린 및 슬라이드 콘텐츠
        Positioned.fill(
          child: Column(
            children: [
              // 상단 상태바 & 펀치홀 카메라
              OneUi9StatusBar(
                timeString: widget.timeString,
                onOpenQuickSettings: () => setState(() => _isQuickSettingsOpen = true),
                onOpenNotificationShade: () => setState(() => _isNotificationShadeOpen = true),
              ),
              const SizedBox(height: 4),

              // One UI 9 라이브 Now Bar 캡슐
              OneUi9NowBar(onTap: () => setState(() => _isNotificationShadeOpen = true)),
              const SizedBox(height: 6),

              // 좌우 슬라이드 PageView 영역 (Now Brief -> 메인 홈 -> 서브 페이지)
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (page) => setState(() => _currentPage = page),
                  children: [
                    // 페이지 0: 좌측 Now Brief & Galaxy AI 데일리 보드
                    OneUi9BriefPage(
                      dateString: widget.dateString,
                      onOpenTemplate: () => widget.onOpenTemplate('kakaotalk'),
                    ),

                    // 페이지 1: 중앙 메인 홈 화면 (위젯 + AI 검색바 + 앱 그리드 1)
                    _buildMainHomePage(),

                    // 페이지 2: 우측 서브 앱 페이지 (Galaxy 생태계 앱 그리드 2)
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

              // 3. One UI 9 하단 고정 도크 (5대 핵심 앱)
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

        // 5. One UI 9 스플릿 빠른 설정 (Quick Settings)
        if (_isQuickSettingsOpen)
          Positioned.fill(
            child: OneUi9QuickSettings(
              timeString: widget.timeString,
              dateString: widget.dateString,
              onClose: () => setState(() => _isQuickSettingsOpen = false),
              onSwitchToNotifications: () => setState(() {
                _isQuickSettingsOpen = false;
                _isNotificationShadeOpen = true;
              }),
              onOpenSettings: widget.onOpenSettings,
            ),
          ),

        // 6. One UI 9 스플릿 알림 셰이드 (Notification Shade)
        if (_isNotificationShadeOpen)
          Positioned.fill(
            child: OneUi9NotificationShade(
              timeString: widget.timeString,
              dateString: widget.dateString,
              onClose: () => setState(() => _isNotificationShadeOpen = false),
              onSwitchToQuickSettings: () => setState(() {
                _isNotificationShadeOpen = false;
                _isQuickSettingsOpen = true;
              }),
              onOpenSettings: widget.onOpenSettings,
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

  Widget _buildMainHomePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // One UI 9 시계 및 날씨 카드
            OneUi9WeatherClockCard(
              timeString: widget.timeString,
              dateString: widget.dateString,
              onTap: () => setState(() => _isQuickSettingsOpen = true),
            ),
            const SizedBox(height: 10),

            // S26 Ultra & Buds3 Pro 배터리 카드
            const OneUi9BatteryWidget(),
            const SizedBox(height: 12),

            // Galaxy AI 검색 캡슐 바
            OneUi9GalaxyAiSearchBar(
              onSearchTap: () => setState(() => _isAppDrawerOpen = true),
              onAiTap: () => setState(() => _isAppDrawerOpen = true),
            ),
            const SizedBox(height: 16),

            // 메인 앱 그리드 1 (깃허브 공식 아이콘 적용)
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
            // 삼성 생태계 전용 위젯/카드
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

            // 서브 앱 그리드 2 (노트, 헬스, 빅스비, 계산기, 내 파일 등)
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
            ? Padding(
                padding: const EdgeInsets.all(4),
                child: Image.asset(image, fit: BoxFit.contain),
              )
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
      case 'sapphire':
        return Image.asset('assets/images/galaxy/wallpapers/oneui_sapphire.webp', fit: BoxFit.cover);
      case 'emerald':
        return Image.asset('assets/images/galaxy/wallpapers/oneui_emerald.webp', fit: BoxFit.cover);
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
