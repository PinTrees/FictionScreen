import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common/os_app_item.dart';
import 'android_statusbar.dart';
import 'apps/calculator/calculator_window.dart';
import 'apps/gallery/gallery_window.dart';
import 'apps/internet/internet_window.dart';
import 'apps/messages/messages_window.dart';
import 'apps/my_files/my_files_window.dart';
import 'apps/phone/phone_window.dart';
import 'apps/settings/settings_window.dart';
import 'widgets/galaxy_quick_panel.dart';

/// Samsung Galaxy One UI 6.1 최신 스타일 모바일 홈스크린 뷰
class GalaxyView extends StatefulWidget {
  final String timeString;
  final String dateString;
  final String currentWallpaper;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;

  const GalaxyView({
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
  State<GalaxyView> createState() => _GalaxyViewState();
}

class _GalaxyViewState extends State<GalaxyView> {
  bool _isQuickPanelOpen = false;
  String? _activeGalaxyApp;

  void _openGalaxyApp(String appId) {
    setState(() {
      _activeGalaxyApp = appId;
    });
  }

  void _closeGalaxyApp() {
    setState(() {
      _activeGalaxyApp = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. One UI 배경화면
        Positioned.fill(
          child: _buildGalaxyWallpaper(),
        ),

        // 2. 상단 상태바 (아래로 드래그 시 Quick Panel 열기)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta != null && details.primaryDelta! > 6) {
                setState(() => _isQuickPanelOpen = true);
              }
            },
            onTap: () => setState(() => _isQuickPanelOpen = true),
            child: AndroidStatusBar(timeString: widget.timeString),
          ),
        ),

        // 3. 홈 화면 콘텐츠 (원UI 위젯 + 검색창 + 삼성 기본앱 및 템플릿 그리드)
        Positioned.fill(
          top: 48,
          bottom: 24,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                // One UI 6.1 날씨 & 시계 위젯 카드
                GestureDetector(
                  onTap: () => setState(() => _isQuickPanelOpen = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.timeString,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.dateString,
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            Icon(CupertinoIcons.sun_max_fill, color: Colors.amber, size: 28),
                            SizedBox(width: 8),
                            Text('25°', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Google 검색 위젯 바
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                  ),
                  child: const Row(
                    children: [
                      Text('G', style: TextStyle(color: Color(0xFF60A5FA), fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text('Google 검색 또는 URL 입력', style: TextStyle(color: Colors.white60, fontSize: 12)),
                      ),
                      Icon(CupertinoIcons.mic_fill, color: Colors.white70, size: 16),
                      SizedBox(width: 10),
                      Icon(CupertinoIcons.camera_fill, color: Colors.white70, size: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 원UI 앱 아이콘 그리드
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.8,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // 삼성 기본 앱들
                      OsAppItem(
                        title: '전화',
                        icon: CupertinoIcons.phone_fill,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF10B981),
                        isDesktop: false,
                        onTap: () => _openGalaxyApp('phone'),
                      ),
                      OsAppItem(
                        title: '메시지',
                        icon: CupertinoIcons.chat_bubble_text_fill,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF3B82F6),
                        isDesktop: false,
                        onTap: () => _openGalaxyApp('messages'),
                      ),
                      OsAppItem(
                        title: '갤러리',
                        icon: CupertinoIcons.photo_fill_on_rectangle_fill,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFFF59E0B),
                        isDesktop: false,
                        onTap: () => _openGalaxyApp('gallery'),
                      ),
                      OsAppItem(
                        title: '인터넷',
                        icon: CupertinoIcons.globe,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF6366F1),
                        isDesktop: false,
                        onTap: () => _openGalaxyApp('internet'),
                      ),

                      // SNS & 메신저 모조 스크린 앱들
                      OsAppItem(
                        title: '카카오톡',
                        imageAsset: 'assets/images/kakaotalk_icon.webp',
                        backgroundColor: const Color(0xFFFEE500),
                        isDesktop: false,
                        onTap: () => widget.onOpenTemplate('kakaotalk'),
                      ),
                      OsAppItem(
                        title: '토스 (Toss)',
                        icon: CupertinoIcons.money_dollar_circle_fill,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF0050FF),
                        isDesktop: false,
                        onTap: () => widget.onOpenTemplate('toss'),
                      ),
                      OsAppItem(
                        title: 'Instagram',
                        imageAsset: 'assets/images/instagram_icon.webp',
                        isDesktop: false,
                        onTap: () => widget.onOpenTemplate('instagram'),
                      ),
                      OsAppItem(
                        title: 'X (Twitter)',
                        icon: CupertinoIcons.conversation_bubble,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF1D9BF0),
                        isDesktop: false,
                        onTap: () => widget.onOpenTemplate('x_twitter'),
                      ),
                      OsAppItem(
                        title: 'YouTube',
                        icon: CupertinoIcons.play_arrow_solid,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFFFF0000),
                        isDesktop: false,
                        onTap: () => widget.onOpenTemplate('youtube'),
                      ),
                      OsAppItem(
                        title: '배달의민족',
                        icon: CupertinoIcons.bag_fill,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF2AC1BC),
                        isDesktop: false,
                        onTap: () => widget.onOpenTemplate('delivery'),
                      ),

                      // 유틸리티 & 시스템
                      OsAppItem(
                        title: '계산기',
                        icon: CupertinoIcons.number,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF059669),
                        isDesktop: false,
                        onTap: () => _openGalaxyApp('calculator'),
                      ),
                      OsAppItem(
                        title: '내 파일',
                        icon: CupertinoIcons.folder_fill,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFFD97706),
                        isDesktop: false,
                        onTap: () => _openGalaxyApp('my_files'),
                      ),
                      OsAppItem(
                        title: '설정',
                        icon: CupertinoIcons.gear_alt_fill,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF475569),
                        isDesktop: false,
                        onTap: () => _openGalaxyApp('settings'),
                      ),
                      OsAppItem(
                        title: '랜딩 홈',
                        icon: CupertinoIcons.house_fill,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF334155),
                        isDesktop: false,
                        onTap: widget.onGoHome,
                      ),
                      OsAppItem(
                        title: '로그아웃',
                        icon: CupertinoIcons.square_arrow_right,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFFEF4444),
                        isDesktop: false,
                        onTap: widget.onSignOut,
                      ),
                    ],
                  ),
                ),

                // 하단 원UI 제스처 네비게이션 인디케이터
                Container(
                  width: 120,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 4. 삼성 기본 앱 전체화면 오버레이
        if (_activeGalaxyApp != null)
          Positioned.fill(
            child: _buildGalaxyAppWidget(_activeGalaxyApp!),
          ),

        // 5. 상단 드래그 다운 Quick Panel (빠른 설정 & 알림 창)
        if (_isQuickPanelOpen)
          Positioned.fill(
            child: GalaxyQuickPanel(
              timeString: widget.timeString,
              dateString: widget.dateString,
              onClose: () => setState(() => _isQuickPanelOpen = false),
              onOpenSettings: widget.onOpenSettings,
            ),
          ),
      ],
    );
  }

  Widget _buildGalaxyAppWidget(String appId) {
    switch (appId) {
      case 'phone':
        return SamsungPhoneWindow(onClose: _closeGalaxyApp);
      case 'messages':
        return SamsungMessagesWindow(onClose: _closeGalaxyApp);
      case 'gallery':
        return SamsungGalleryWindow(onClose: _closeGalaxyApp);
      case 'settings':
        return SamsungSettingsWindow(
          onClose: _closeGalaxyApp,
          onOpenSystemSettings: widget.onOpenSettings,
        );
      case 'internet':
        return SamsungInternetWindow(onClose: _closeGalaxyApp);
      case 'calculator':
        return SamsungCalculatorWindow(onClose: _closeGalaxyApp);
      case 'my_files':
        return SamsungMyFilesWindow(onClose: _closeGalaxyApp);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildGalaxyWallpaper() {
    switch (widget.currentWallpaper) {
      case 'bloom':
        return Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.0, -0.2),
              radius: 1.2,
              colors: [Color(0xFF193256), Color(0xFF0F1E38), Color(0xFF090E1A)],
            ),
          ),
        );
      case 'minimal_dark':
        return Container(color: const Color(0xFF0A0B10));
      case 'cyberpunk':
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF020617), Color(0xFF4C1D95), Color(0xFFBE185D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      case 'aurora':
      default:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0A2540), Color(0xFF0D3B66), Color(0xFF101820)],
            ),
          ),
        );
    }
  }
}
