import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'apps/settings/ios18_settings_view.dart';
import 'widgets/ios18_app_icon.dart';
import 'widgets/ios18_dock.dart';
import 'widgets/ios18_home_indicator.dart';
import 'widgets/ios18_status_bar.dart';

/// iPhone 16 Pro iOS 18 모바일 홈스크린 및 티타늄 프레임 뷰
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

  @override
  void initState() {
    super.initState();
    _activeWallpaper = widget.currentWallpaper.startsWith('ios18')
        ? widget.currentWallpaper
        : 'ios18_dark';
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

        // 2. 홈 스크린 콘텐츠 (시계 위젯 + 4열 앱 그리드 + 플로팅 독)
        Positioned.fill(
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // 최상단 상태바 & 다이내믹 아일랜드
                Ios18StatusBar(timeString: widget.timeString),
                const SizedBox(height: 12),

                // iOS 18 잠금/홈 헤더 시계 위젯
                _buildClockWidget(),
                const SizedBox(height: 24),

                // 4열 앱 그리드 (기본 앱 + 크리에이터 템플릿 앱)
                Expanded(
                  child: RawScrollbar(
                    thumbColor: Colors.white24,
                    thickness: 3,
                    radius: const Radius.circular(2),
                    child: GridView.count(
                      crossAxisCount: 4,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      mainAxisSpacing: 18,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.76,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        // Row 1
                        Ios18AppIcon(title: 'FaceTime', imageAsset: 'assets/images/ios/icons/facetime.png', onTap: () => _openApp('facetime')),
                        Ios18AppIcon(title: '캘린더', imageAsset: 'assets/images/ios/icons/calendar.png', onTap: () => _openApp('calendar')),
                        Ios18AppIcon(title: '사진', imageAsset: 'assets/images/ios/icons/photos.png', onTap: () => _openApp('photos')),
                        Ios18AppIcon(title: '카메라', imageAsset: 'assets/images/ios/icons/camera.png', onTap: () => _openApp('camera')),

                        // Row 2
                        Ios18AppIcon(title: '메일', imageAsset: 'assets/images/ios/icons/mail.png', badgeCount: 14, onTap: () => _openApp('mail')),
                        Ios18AppIcon(title: '시계', imageAsset: 'assets/images/ios/icons/clock.png', onTap: () => _openApp('clock')),
                        Ios18AppIcon(title: '지도', imageAsset: 'assets/images/ios/icons/maps.png', onTap: () => _openApp('maps')),
                        Ios18AppIcon(title: '날씨', imageAsset: 'assets/images/ios/icons/weather.png', onTap: () => _openApp('weather')),

                        // Row 3
                        Ios18AppIcon(title: '메모', imageAsset: 'assets/images/ios/icons/notes.png', onTap: () => _openApp('notes')),
                        Ios18AppIcon(title: '계산기', imageAsset: 'assets/images/ios/icons/calculator.png', onTap: () => _openApp('calculator')),
                        Ios18AppIcon(title: '파일', imageAsset: 'assets/images/ios/icons/files.png', onTap: () => _openApp('files')),
                        Ios18AppIcon(title: '설정', imageAsset: 'assets/images/ios/icons/settings.png', onTap: () => _openApp('settings')),

                        // Row 4
                        Ios18AppIcon(title: 'App Store', imageAsset: 'assets/images/ios/icons/appstore.png', onTap: () => _openApp('appstore')),
                        Ios18AppIcon(title: '건강', imageAsset: 'assets/images/ios/icons/health.png', onTap: () => _openApp('health')),
                        Ios18AppIcon(title: '지갑', imageAsset: 'assets/images/ios/icons/wallet.png', onTap: () => _openApp('wallet')),
                        Ios18AppIcon(title: '동행복권', imageAsset: 'assets/images/lottery_icon.webp', onTap: () => _openApp('lottery')),

                        // Row 5 (크리에이터 템플릿)
                        Ios18AppIcon(title: '카카오톡', imageAsset: 'assets/images/kakaotalk_icon.webp', badgeCount: 99, onTap: () => _openApp('kakaotalk')),
                        Ios18AppIcon(title: 'Instagram', imageAsset: 'assets/images/instagram_icon.webp', badgeCount: 5, onTap: () => _openApp('instagram')),
                        Ios18AppIcon(title: 'Netflix', imageAsset: 'assets/images/netflix_icon.webp', onTap: () => _openApp('netflix')),
                        Ios18AppIcon(title: 'YouTube', customIcon: Container(color: Colors.red, child: const Icon(CupertinoIcons.play_arrow_solid, color: Colors.white, size: 28)), onTap: () => _openApp('youtube')),

                        // Row 6
                        Ios18AppIcon(title: '쿠팡', imageAsset: 'assets/images/coupang_icon.webp', onTap: () => _openApp('coupang')),
                        Ios18AppIcon(title: '배달의민족', customIcon: Container(color: const Color(0xFF2AC1BC), child: const Icon(CupertinoIcons.bag_fill, color: Colors.white, size: 28)), onTap: () => _openApp('delivery')),
                        Ios18AppIcon(title: '블루스크린', customIcon: Container(color: const Color(0xFF0078D7), child: const Icon(CupertinoIcons.device_desktop, color: Colors.white, size: 28)), onTap: () => _openApp('windows_bsod')),
                      ],
                    ),
                  ),
                ),

                // 3. 플로팅 프로스티드 독 (전화, Safari, 메시지, 음악)
                Ios18Dock(onOpenApp: _openApp),
                const SizedBox(height: 10),

                // 4. 하단 홈 인디케이터 바
                Ios18HomeIndicator(onHome: () {}),
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

  // iOS 18 상단 시계 위젯
  Widget _buildClockWidget() {
    final timeFormatted = widget.timeString.length >= 5
        ? widget.timeString.substring(0, 5)
        : widget.timeString;

    return Column(
      children: [
        Text(
          widget.dateString,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
            shadows: const [Shadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 1))],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          timeFormatted,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 68,
            fontWeight: FontWeight.w200,
            letterSpacing: -2.5,
            fontFamily: '.SF Pro Display',
            shadows: [Shadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 2))],
          ),
        ),
      ],
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
