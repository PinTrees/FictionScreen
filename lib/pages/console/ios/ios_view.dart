import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common/os_app_item.dart';
import 'apps/calculator/calculator_window.dart';
import 'apps/messages/messages_window.dart';
import 'apps/notes/notes_window.dart';
import 'apps/phone/phone_window.dart';
import 'apps/photos/photos_window.dart';
import 'apps/safari/safari_window.dart';
import 'apps/settings/settings_window.dart';
import 'ios_dock.dart';
import 'ios_statusbar.dart';
import 'widgets/ios_control_center.dart';

/// iPhone iOS 18 최신 스타일 모바일 홈스크린 뷰
class IosView extends StatefulWidget {
  final String timeString;
  final String dateString;
  final String currentWallpaper;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;

  const IosView({
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
  State<IosView> createState() => _IosViewState();
}

class _IosViewState extends State<IosView> {
  bool _isControlCenterOpen = false;
  String? _activeIosApp;

  void _openIosApp(String appId) {
    setState(() {
      _activeIosApp = appId;
    });
  }

  void _closeIosApp() {
    setState(() {
      _activeIosApp = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. iOS 18 공식 고해상도 그래디언트 배경화면
        Positioned.fill(
          child: _buildIosWallpaper(),
        ),

        // 2. 상단 상태바 & 다이내믹 아일랜드 (우측 드래그 시 제어센터)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta != null && details.primaryDelta! > 6) {
                setState(() => _isControlCenterOpen = true);
              }
            },
            onTap: () => setState(() => _isControlCenterOpen = true),
            child: IosStatusBar(timeString: widget.timeString),
          ),
        ),

        // 3. 홈 화면 콘텐츠 (시계 위젯 + iOS 18 앱 그리드)
        Positioned.fill(
          top: 70,
          bottom: 110,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // iOS 18 대표 모듈식 시계 위젯
                GestureDetector(
                  onTap: () => setState(() => _isControlCenterOpen = true),
                  child: Column(
                    children: [
                      Text(
                        widget.dateString,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.timeString,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 64,
                          fontWeight: FontWeight.w200,
                          letterSpacing: -2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // iOS 18 앱 아이콘 그리드 (기본 앱 + 템플릿 모조 스크린 앱)
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // iOS 기본 앱들
                      OsAppItem(
                        title: '전화',
                        icon: CupertinoIcons.phone_fill,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF34C759),
                        isDesktop: false,
                        onTap: () => _openIosApp('phone'),
                      ),
                      OsAppItem(
                        title: '메시지',
                        icon: CupertinoIcons.chat_bubble_fill,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF34C759),
                        isDesktop: false,
                        onTap: () => _openIosApp('messages'),
                      ),
                      OsAppItem(
                        title: '사진',
                        icon: CupertinoIcons.photo_fill_on_rectangle_fill,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFFFF9500),
                        isDesktop: false,
                        onTap: () => _openIosApp('photos'),
                      ),
                      OsAppItem(
                        title: 'Safari',
                        icon: CupertinoIcons.compass,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF007AFF),
                        isDesktop: false,
                        onTap: () => _openIosApp('safari'),
                      ),

                      // SNS & 메신저 모조 스크린 앱들
                      OsAppItem(
                        title: '카카오톡',
                        imageAsset: 'assets/images/kakaotalk_icon.webp',
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
                        title: '핀터레스트',
                        icon: CupertinoIcons.sparkles,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFFE60023),
                        isDesktop: false,
                        onTap: () => widget.onOpenTemplate('pinterest'),
                      ),
                      OsAppItem(
                        title: '배달의민족',
                        icon: CupertinoIcons.bag_fill,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF2AC1BC),
                        isDesktop: false,
                        onTap: () => widget.onOpenTemplate('delivery'),
                      ),

                      // 유틸리티 & 설정
                      OsAppItem(
                        title: '계산기',
                        icon: CupertinoIcons.number,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFFFF9500),
                        isDesktop: false,
                        onTap: () => _openIosApp('calculator'),
                      ),
                      OsAppItem(
                        title: '메모',
                        icon: CupertinoIcons.doc_plaintext,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFFEAB308),
                        isDesktop: false,
                        onTap: () => _openIosApp('notes'),
                      ),
                      OsAppItem(
                        title: '설정',
                        icon: CupertinoIcons.gear_alt_fill,
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF636366),
                        isDesktop: false,
                        onTap: () => _openIosApp('settings'),
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
              ],
            ),
          ),
        ),

        // 4. 하단 iOS 독 & 홈 바
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: IosDock(
            onOpenTemplate: widget.onOpenTemplate,
            onOpenApp: _openIosApp,
            onOpenSettings: widget.onOpenSettings,
          ),
        ),

        // 5. iOS 기본 앱 전체화면 오버레이
        if (_activeIosApp != null)
          Positioned.fill(
            child: _buildIosAppWidget(_activeIosApp!),
          ),

        // 6. iOS 18 Control Center (제어 센터) 오버레이
        if (_isControlCenterOpen)
          Positioned.fill(
            child: IosControlCenter(
              timeString: widget.timeString,
              onClose: () => setState(() => _isControlCenterOpen = false),
              onOpenSettings: widget.onOpenSettings,
            ),
          ),
      ],
    );
  }

  Widget _buildIosAppWidget(String appId) {
    switch (appId) {
      case 'phone':
        return IosPhoneWindow(onClose: _closeIosApp);
      case 'messages':
        return IosMessagesWindow(onClose: _closeIosApp);
      case 'photos':
        return IosPhotosWindow(onClose: _closeIosApp);
      case 'settings':
        return IosSettingsWindow(
          onClose: _closeIosApp,
          onOpenSystemSettings: widget.onOpenSettings,
        );
      case 'safari':
        return IosSafariWindow(onClose: _closeIosApp);
      case 'calculator':
        return IosCalculatorWindow(onClose: _closeIosApp);
      case 'notes':
        return IosNotesWindow(onClose: _closeIosApp);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildIosWallpaper() {
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
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0F172A), Color(0xFF311042), Color(0xFF1E1B4B)],
            ),
          ),
        );
    }
  }
}
