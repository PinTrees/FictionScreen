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
import 'widgets/oneui7_app_drawer.dart';
import 'widgets/oneui7_home_widgets.dart';
import 'widgets/oneui7_notification_shade.dart';
import 'widgets/oneui7_now_bar.dart';
import 'widgets/oneui7_quick_settings.dart';
import 'widgets/oneui7_status_bar.dart';

/// Samsung Galaxy One UI 7 플래그십 모바일 홈스크린 뷰
class OneUi7View extends StatefulWidget {
  final String timeString;
  final String dateString;
  final String currentWallpaper;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;

  const OneUi7View({
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
  State<OneUi7View> createState() => _OneUi7ViewState();
}

class _OneUi7ViewState extends State<OneUi7View> {
  bool _isQuickSettingsOpen = false;
  bool _isNotificationShadeOpen = false;
  bool _isAppDrawerOpen = false;
  String? _activeGalaxyApp;

  void _openGalaxyApp(String appId) {
    setState(() => _activeGalaxyApp = appId);
  }

  void _closeGalaxyApp() {
    setState(() => _activeGalaxyApp = null);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. One UI 7 티타늄 글래스 그라디언트 배경화면
        Positioned.fill(child: _buildGalaxyWallpaper()),

        // 2. 홈 화면 제스처 영역 (위로 스와이프: 앱 서랍, 아래로 스와이프: 퀵 패널)
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta != null) {
                if (details.primaryDelta! < -8) {
                  setState(() => _isAppDrawerOpen = true);
                } else if (details.primaryDelta! > 10) {
                  if (details.globalPosition.dx > MediaQuery.of(context).size.width / 2) {
                    setState(() => _isQuickSettingsOpen = true);
                  } else {
                    setState(() => _isNotificationShadeOpen = true);
                  }
                }
              }
            },
            child: Column(
              children: [
                // One UI 7 상단 상태바 & 펀치홀 카메라
                OneUi7StatusBar(
                  timeString: widget.timeString,
                  onOpenQuickSettings: () => setState(() => _isQuickSettingsOpen = true),
                  onOpenNotificationShade: () => setState(() => _isNotificationShadeOpen = true),
                ),
                const SizedBox(height: 4),

                // One UI 7 실시간 Now Bar 캡슐
                OneUi7NowBar(onTap: () => setState(() => _isNotificationShadeOpen = true)),
                const SizedBox(height: 12),

                // 메인 위젯 & 앱 그리드 스크롤
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // 1. One UI 7 날씨 & 듀얼 시계 카드 (28px 곡률)
                          OneUi7WeatherClockCard(
                            timeString: widget.timeString,
                            dateString: widget.dateString,
                            onTap: () => setState(() => _isQuickSettingsOpen = true),
                          ),
                          const SizedBox(height: 10),

                          // 2. One UI 7 배터리 캡슐
                          const OneUi7BatteryWidget(),
                          const SizedBox(height: 12),

                          // 3. One UI 7 Galaxy AI 검색 캡슐 바
                          OneUi7GalaxyAiSearchBar(
                            onSearchTap: () => setState(() => _isAppDrawerOpen = true),
                            onAiTap: () => setState(() => _isAppDrawerOpen = true),
                          ),
                          const SizedBox(height: 16),

                          // 4. One UI 7 앱 그리드
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
                              OsAppItem(title: 'X (Twitter)', icon: CupertinoIcons.conversation_bubble, iconColor: Colors.white, backgroundColor: const Color(0xFF1D9BF0), isDesktop: false, onTap: () => widget.onOpenTemplate('x_twitter')),
                              OsAppItem(title: 'YouTube', icon: CupertinoIcons.play_arrow_solid, iconColor: Colors.white, backgroundColor: const Color(0xFFFF0000), isDesktop: false, onTap: () => widget.onOpenTemplate('youtube')),
                              OsAppItem(title: '쿠팡', imageAsset: 'assets/images/coupang_icon.webp', isDesktop: false, onTap: () => widget.onOpenTemplate('coupang')),
                              OsAppItem(title: 'Netflix', imageAsset: 'assets/images/netflix_icon.webp', isDesktop: false, onTap: () => widget.onOpenTemplate('netflix')),
                              OsAppItem(title: '배달의민족', icon: CupertinoIcons.bag_fill, iconColor: Colors.white, backgroundColor: const Color(0xFF2AC1BC), isDesktop: false, onTap: () => widget.onOpenTemplate('delivery')),
                              OsAppItem(title: '계산기', icon: CupertinoIcons.number, iconColor: Colors.white, backgroundColor: const Color(0xFF059669), isDesktop: false, onTap: () => _openGalaxyApp('calculator')),
                              OsAppItem(title: '내 파일', icon: CupertinoIcons.folder_fill, iconColor: Colors.white, backgroundColor: const Color(0xFFD97706), isDesktop: false, onTap: () => _openGalaxyApp('my_files')),
                              OsAppItem(title: '랜딩 홈', icon: CupertinoIcons.house_fill, iconColor: Colors.white, backgroundColor: const Color(0xFF334155), isDesktop: false, onTap: widget.onGoHome),
                              OsAppItem(title: '로그아웃', icon: CupertinoIcons.square_arrow_right, iconColor: Colors.white, backgroundColor: const Color(0xFFEF4444), isDesktop: false, onTap: widget.onSignOut),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),

                // 5. One UI 7 하단 고정 도크 (Dock)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDockIcon('전화', CupertinoIcons.phone_fill, const Color(0xFF10B981), () => _openGalaxyApp('phone')),
                      _buildDockIcon('메시지', CupertinoIcons.chat_bubble_text_fill, const Color(0xFF3B82F6), () => _openGalaxyApp('messages')),
                      _buildDockIcon('갤러리', CupertinoIcons.photo_fill_on_rectangle_fill, const Color(0xFFF59E0B), () => _openGalaxyApp('gallery')),
                      _buildDockIcon('인터넷', CupertinoIcons.globe, const Color(0xFF6366F1), () => _openGalaxyApp('internet')),
                      _buildDockIcon('설정', CupertinoIcons.gear_alt_fill, const Color(0xFF475569), () => _openGalaxyApp('settings')),
                    ],
                  ),
                ),

                // 하단 원UI 제스처 네비게이션 인디케이터 (탭/드래그 시 앱서랍 오픈)
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
        ),

        // 3. 삼성 기본 앱 전체화면 오버레이
        if (_activeGalaxyApp != null)
          Positioned.fill(child: _buildGalaxyAppWidget(_activeGalaxyApp!)),

        // 4. One UI 7 스플릿 퀵 세팅 패널 (상단 우측 제스처)
        if (_isQuickSettingsOpen)
          Positioned.fill(
            child: OneUi7QuickSettings(
              timeString: widget.timeString,
              dateString: widget.dateString,
              onClose: () => setState(() => _isQuickSettingsOpen = false),
              onOpenSettings: widget.onOpenSettings,
            ),
          ),

        // 5. One UI 7 스플릿 알림 셰이드 (상단 좌측 제스처)
        if (_isNotificationShadeOpen)
          Positioned.fill(
            child: OneUi7NotificationShade(
              timeString: widget.timeString,
              dateString: widget.dateString,
              onClose: () => setState(() => _isNotificationShadeOpen = false),
              onOpenSettings: widget.onOpenSettings,
            ),
          ),

        // 6. One UI 7 전체 앱 서랍 (하단 스와이프 업)
        if (_isAppDrawerOpen)
          Positioned.fill(
            child: OneUi7AppDrawer(
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

  Widget _buildDockIcon(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Icon(icon, color: Colors.white, size: 26),
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
      case 'bloom':
        return Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(center: Alignment(0.0, -0.2), radius: 1.2, colors: [Color(0xFF193256), Color(0xFF0F1E38), Color(0xFF090E1A)]),
          ),
        );
      case 'minimal_dark':
        return Container(color: const Color(0xFF0A0B10));
      case 'cyberpunk':
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF020617), Color(0xFF4C1D95), Color(0xFFBE185D)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
        );
      case 'aurora':
      default:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF0D1B2A), Color(0xFF1B263B), Color(0xFF0B131F)]),
          ),
        );
    }
  }
}
