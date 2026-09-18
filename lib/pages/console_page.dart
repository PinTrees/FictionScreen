import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../apps/delivery/data/delivery_model.dart';
import '../apps/delivery/delivery_screen.dart';
import '../apps/instagram/data/instagram_model.dart';
import '../apps/instagram/instagram_screen.dart';
import '../apps/kakaotalk/data/kakaotalk_model.dart';
import '../apps/kakaotalk/kakaotalk_screen.dart';
import '../apps/pinterest/data/pinterest_model.dart';
import '../apps/pinterest/pinterest_screen.dart';
import '../apps/screen_template.dart';
import '../apps/toss/data/toss_model.dart';
import '../apps/toss/toss_screen.dart';
import '../apps/windows_bsod/data/windows_bsod_model.dart';
import '../apps/windows_bsod/windows_bsod_screen.dart';
import '../apps/windows_update/data/windows_update_model.dart';
import '../apps/windows_update/windows_update_screen.dart';
import '../apps/x_twitter/data/x_twitter_model.dart';
import '../apps/x_twitter/x_twitter_screen.dart';
import '../apps/youtube/data/youtube_model.dart';
import '../apps/youtube/youtube_screen.dart';
import '../services/auth_service.dart';
import '../services/user_settings_service.dart';
import '../widgets/common/device_frame_preview.dart';
import 'console/android/galaxy_view.dart';
import 'console/common/floating_app_window.dart';
import 'console/ios/ios_view.dart';
import 'console/macos/macos_view.dart';
import 'console/settings/os_settings_window.dart';
import 'console/windows/windows_view.dart';

class FloatingWindowData {
  final String id;
  final ScreenTemplate template;
  final ValueNotifier<Offset> positionNotifier;
  Size size;
  bool isMinimized;
  int zIndex;

  FloatingWindowData({
    required this.id,
    required this.template,
    required Offset position,
    required this.size,
    this.isMinimized = false,
    this.zIndex = 0,
  }) : positionNotifier = ValueNotifier<Offset>(position);

  Offset get position => positionNotifier.value;
  set position(Offset newPos) => positionNotifier.value = newPos;
}

/// 가상 OS 콘솔 메인 페이지 (오케스트레이터 & MDI 창 관리자 & Firestore 연동)
class ConsolePage extends StatefulWidget {
  const ConsolePage({super.key});

  @override
  State<ConsolePage> createState() => _ConsolePageState();
}

class _ConsolePageState extends State<ConsolePage> {
  // 데스크톱 OS: 'windows' vs 'macos' (기본: windows)
  String _pcTheme = 'windows';
  // Windows 버전: '7', '10', '11' (기본: '11')
  String _windowsVersion = '11';
  // 모바일 OS: 'ios' vs 'galaxy'
  String _mobileTheme = 'ios';
  // Galaxy 버전: '6', '7', '9' (기본: '9')
  String _galaxyVersion = '9';
  // 전역 바탕화면 테마
  String _wallpaper = 'win10_hero';

  // 사용자가 명시적으로 선택한 활성 OS ('windows', 'macos', 'ios', 'galaxy')
  String? _activeOs;
  bool _isDesktopMobileFullScreen = false;

  String get _currentActiveOs {
    if (_activeOs != null) return _activeOs!;
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 768 ? _pcTheme : _mobileTheme;
  }

  void _handleSelectOs(String osKey) {
    setState(() {
      _activeOs = osKey;
      if (osKey == 'galaxy' || osKey == 'ios') {
        _mobileTheme = osKey;
      } else if (osKey == 'windows' || osKey == 'macos') {
        _pcTheme = osKey;
      }
    });
    _saveCurrentOsSettings();
  }

  bool _isStartMenuOpen = false;
  bool _isSettingsOpen = false;
  bool _isLoadingSettings = false;
  String? _activeMobileTemplateId;
  String? _activeFullScreenTemplateId;
  Offset _settingsPos = const Offset(120, 60);
  Offset _settingsDragStart = Offset.zero;

  // MDI 열린 가상 창 관리
  final List<FloatingWindowData> _activeFloatingWindows = [];
  int _highestZIndex = 1;

  late Timer _clockTimer;
  StreamSubscription<User?>? _authSubscription;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });

    // 유저 인증 상태 및 Firestore 설정 로드
    _authSubscription = AuthService.authStateChanges.listen((user) {
      if (user != null) {
        _loadUserOsSettings();
      }
    });

    _loadUserOsSettings();
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }

  /// 파이어스토어에서 유저별 이전 OS 선택값 불러오기
  Future<void> _loadUserOsSettings() async {
    if (_isLoadingSettings) return;
    _isLoadingSettings = true;

    final settings = await UserSettingsService.loadOsSettings();
    if (settings != null && mounted) {
      setState(() {
        _pcTheme = settings.pcTheme;
        _windowsVersion = settings.windowsVersion;
        _mobileTheme = settings.mobileTheme;
        _galaxyVersion = settings.galaxyVersion;
        _wallpaper = settings.wallpaper;
      });
    }
    _isLoadingSettings = false;
  }

  /// 파이어스토어에 유저 OS 선택값 동기화 저장
  void _saveCurrentOsSettings() {
    UserSettingsService.saveOsSettings(
      UserOsSettings(
        pcTheme: _pcTheme,
        windowsVersion: _windowsVersion,
        mobileTheme: _mobileTheme,
        galaxyVersion: _galaxyVersion,
        wallpaper: _wallpaper,
      ),
    );
  }

  void _bringToFront(String windowId) {
    setState(() {
      _highestZIndex++;
      final win = _activeFloatingWindows.firstWhere((w) => w.id == windowId);
      win.zIndex = _highestZIndex;
      win.isMinimized = false;
      _activeFloatingWindows.sort((a, b) => a.zIndex.compareTo(b.zIndex));
    });
  }

  void _openTemplate(String templateId) {
    setState(() {
      _isStartMenuOpen = false;
      _isSettingsOpen = false;
    });

    if (templateId == 'windows_update' || templateId == 'windows_bsod') {
      setState(() {
        _activeFullScreenTemplateId = templateId;
      });
      return;
    }

    final isDesktopOs = _currentActiveOs == 'windows' || _currentActiveOs == 'macos';
    if (isDesktopOs) {
      final existingIndex = _activeFloatingWindows.indexWhere((w) => w.template.id == templateId);

      if (existingIndex != -1) {
        _bringToFront(_activeFloatingWindows[existingIndex].id);
      } else {
        final template = ScreenTemplate.allTemplates.firstWhere(
          (t) => t.id == templateId,
          orElse: () => ScreenTemplate.allTemplates.first,
        );

        final count = _activeFloatingWindows.length;
        final initialPos = Offset(100.0 + (count * 30), 50.0 + (count * 25));
        final initialSize = (template.id == 'coupang' || template.id == 'netflix' || template.id == 'lottery')
            ? const Size(980, 620)
            : (template.isDesktop ? const Size(760, 500) : const Size(380, 680));

        _highestZIndex++;
        final newWin = FloatingWindowData(
          id: '${templateId}_${DateTime.now().millisecondsSinceEpoch}',
          template: template,
          position: initialPos,
          size: initialSize,
          zIndex: _highestZIndex,
        );

        setState(() {
          _activeFloatingWindows.add(newWin);
          _activeFloatingWindows.sort((a, b) => a.zIndex.compareTo(b.zIndex));
        });
      }
    } else {
      setState(() {
        _activeMobileTemplateId = templateId;
      });
    }
  }

  Future<void> _handleSignOut() async {
    await AuthService.signOut();
    if (mounted) {
      context.go('/');
    }
  }

  String _formatDate(String pattern, [String? locale]) {
    try {
      return DateFormat(pattern, locale).format(_now);
    } catch (_) {
      try {
        return DateFormat(pattern).format(_now);
      } catch (_) {
        return '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 768;

    final activeOs = _currentActiveOs;

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: AuthService.authStateChanges,
        builder: (context, snapshot) {
          final user = snapshot.data ?? AuthService.currentUser;

          return Stack(
            children: [
              // 1. 선택된 가상 OS 메인 뷰 (Windows / macOS / Galaxy / iOS)
              if (activeOs == 'macos') ...[
                MacosView(
                  user: user,
                  timeString: _formatDate('E a h:mm', 'ko_KR'),
                  currentWallpaper: _wallpaper,
                  onOpenTemplate: _openTemplate,
                  onOpenSettings: () => setState(() => _isSettingsOpen = true),
                  onSignOut: _handleSignOut,
                  onGoHome: () => context.go('/'),
                ),
                ..._buildDesktopWindowsLayer(isMacStyle: true),
              ] else if (activeOs == 'windows') ...[
                WindowsView(
                  windowsVersion: _windowsVersion,
                  user: user,
                  timeString: _formatDate('a h:mm', 'ko_KR'),
                  dateString: _formatDate('yyyy-MM-dd'),
                  currentWallpaper: _wallpaper,
                  isStartMenuOpen: _isStartMenuOpen,
                  onToggleStartMenu: () => setState(() => _isStartMenuOpen = !_isStartMenuOpen),
                  onOpenTemplate: _openTemplate,
                  onOpenSettings: () => setState(() {
                    _isStartMenuOpen = false;
                    _isSettingsOpen = true;
                  }),
                  onSignOut: _handleSignOut,
                  onGoHome: () => context.go('/'),
                ),
                ..._buildDesktopWindowsLayer(isMacStyle: false),
              ] else if (activeOs == 'galaxy') ...[
                if (isDesktop && !_isDesktopMobileFullScreen)
                  _buildDesktopPhoneContainer(
                    title: 'Samsung Galaxy S26 Ultra (One UI 9)',
                    osKey: 'galaxy',
                    child: GalaxyView(
                      oneUiVersion: _galaxyVersion,
                      user: AuthService.currentUser,
                      timeString: _formatDate('h:mm'),
                      dateString: _formatDate('M월 d일 EEEE', 'ko_KR'),
                      currentWallpaper: _wallpaper,
                      onOpenTemplate: _openTemplate,
                      onOpenSettings: () => setState(() => _isSettingsOpen = true),
                      onSignOut: _handleSignOut,
                      onGoHome: () => context.go('/'),
                      onSelectOs: _handleSelectOs,
                    ),
                  )
                else
                  Stack(
                    children: [
                      Positioned.fill(
                        child: GalaxyView(
                          oneUiVersion: _galaxyVersion,
                          user: AuthService.currentUser,
                          timeString: _formatDate('h:mm'),
                          dateString: _formatDate('M월 d일 EEEE', 'ko_KR'),
                          currentWallpaper: _wallpaper,
                          onOpenTemplate: _openTemplate,
                          onOpenSettings: () => setState(() => _isSettingsOpen = true),
                          onSignOut: _handleSignOut,
                          onGoHome: () => context.go('/'),
                          onSelectOs: _handleSelectOs,
                        ),
                      ),
                      if (isDesktop && _isDesktopMobileFullScreen) _buildDesktopFullScreenOverlayBar('Samsung Galaxy One UI 9'),
                    ],
                  ),
              ] else ...[
                if (isDesktop && !_isDesktopMobileFullScreen)
                  _buildDesktopPhoneContainer(
                    title: 'Apple iPhone 16 Pro (iOS 18)',
                    osKey: 'ios',
                    child: IosView(
                      user: AuthService.currentUser,
                      iosVersion: '26',
                      timeString: _formatDate('h:mm'),
                      dateString: _formatDate('M월 d일 EEEE', 'ko_KR'),
                      currentWallpaper: _wallpaper,
                      onOpenTemplate: _openTemplate,
                      onOpenSettings: () => setState(() => _isSettingsOpen = true),
                      onSignOut: _handleSignOut,
                      onGoHome: () => context.go('/'),
                      onSelectOs: _handleSelectOs,
                    ),
                  )
                else
                  Stack(
                    children: [
                      Positioned.fill(
                        child: IosView(
                          user: AuthService.currentUser,
                          iosVersion: '26',
                          timeString: _formatDate('h:mm'),
                          dateString: _formatDate('M월 d일 EEEE', 'ko_KR'),
                          currentWallpaper: _wallpaper,
                          onOpenTemplate: _openTemplate,
                          onOpenSettings: () => setState(() => _isSettingsOpen = true),
                          onSignOut: _handleSignOut,
                          onGoHome: () => context.go('/'),
                          onSelectOs: _handleSelectOs,
                        ),
                      ),
                      if (isDesktop && _isDesktopMobileFullScreen) _buildDesktopFullScreenOverlayBar('Apple iOS 18'),
                    ],
                  ),
              ],

              // 3. 시스템 설정 창 (타이틀바 1:1 드래그 + 설정 변경 시 파이어스토어 자동 저장)
              if (_isSettingsOpen)
                isDesktop
                    ? Positioned(
                        left: _settingsPos.dx,
                        top: _settingsPos.dy,
                        child: OsSettingsWindow(
                          currentPcTheme: _pcTheme,
                          currentWindowsVersion: _windowsVersion,
                          currentMobileTheme: _mobileTheme,
                          currentWallpaper: _wallpaper,
                          onPcThemeChanged: (val) => _handleSelectOs(val),
                          onWindowsVersionChanged: (val) {
                            setState(() => _windowsVersion = val);
                            _handleSelectOs('windows');
                          },
                          onMobileThemeChanged: (val) => _handleSelectOs(val),
                          onWallpaperChanged: (val) {
                            setState(() => _wallpaper = val);
                            _saveCurrentOsSettings();
                          },
                          onClose: () => setState(() => _isSettingsOpen = false),
                          onSignOut: _handleSignOut,
                          onTitleDragStart: (DragStartDetails details) {
                            _settingsDragStart = details.globalPosition - _settingsPos;
                          },
                          onTitleDragUpdate: (DragUpdateDetails details) {
                            setState(() {
                              _settingsPos = details.globalPosition - _settingsDragStart;
                            });
                          },
                          user: user,
                          isDesktop: isDesktop,
                        ),
                      )
                    : GestureDetector(
                        onTap: () => setState(() => _isSettingsOpen = false),
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.35),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {},
                              child: OsSettingsWindow(
                                currentPcTheme: _pcTheme,
                                currentWindowsVersion: _windowsVersion,
                                currentMobileTheme: _mobileTheme,
                                currentWallpaper: _wallpaper,
                                onPcThemeChanged: (val) => _handleSelectOs(val),
                                onWindowsVersionChanged: (val) {
                                  setState(() => _windowsVersion = val);
                                  _handleSelectOs('windows');
                                },
                                onMobileThemeChanged: (val) => _handleSelectOs(val),
                                onWallpaperChanged: (val) {
                                  setState(() => _wallpaper = val);
                                  _saveCurrentOsSettings();
                                },
                                onClose: () => setState(() => _isSettingsOpen = false),
                                onSignOut: _handleSignOut,
                                user: user,
                                isDesktop: isDesktop,
                              ),
                            ),
                          ),
                        ),
                      ),

              // 4. 모바일 전체화면(Full Screen) 가상 스마트폰 앱 오버레이
              if (_activeMobileTemplateId != null)
                Positioned.fill(
                  child: _buildMobileFullScreenApp(_activeMobileTemplateId!),
                ),

              // 5. OS 전체화면 (Windows 가짜 업데이트 / 블루스크린) 오버레이
              if (_activeFullScreenTemplateId != null)
                Positioned.fill(
                  child: _buildFullScreenOsTemplate(_activeFullScreenTemplateId!),
                ),
            ],
          );
        },
      ),
    );
  }

  /// OS 시스템 전체화면(Full Screen) 모달 렌더러
  Widget _buildFullScreenOsTemplate(String templateId) {
    if (templateId == 'windows_update') {
      return WindowsUpdateScreen(
        config: WindowsUpdateConfig.defaultPreset(),
        onClose: () => setState(() => _activeFullScreenTemplateId = null),
      );
    } else if (templateId == 'windows_bsod') {
      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: WindowsBsodScreen(config: WindowsBsodConfig.defaultPreset()),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: InkWell(
                onTap: () => setState(() => _activeFullScreenTemplateId = null),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.xmark, size: 14, color: Colors.white),
                      SizedBox(width: 6),
                      Text('전체화면 종료', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  /// 모바일 스마트폰 전체화면 가상 앱 뷰
  Widget _buildMobileFullScreenApp(String templateId) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Stack(
          children: [
            // 스마트폰 전체화면 앱 콘텐츠
            Positioned.fill(
              child: DeviceFramePreview(
                showFrame: false,
                isDesktop: false,
                child: _buildMobileAppWidget(templateId),
              ),
            ),

            // 상단 오버레이 가이드 바 (모바일 홈으로 돌아가기 / 에디터 전환)
            Positioned(
              top: 10,
              left: 14,
              right: 14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => setState(() => _activeMobileTemplateId = null),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.chevron_left, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text('스마트폰 홈으로', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      final tid = _activeMobileTemplateId;
                      setState(() => _activeMobileTemplateId = null);
                      if (tid != null) {
                        context.push('/studio/$tid');
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withValues(alpha: 0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.pencil, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text('직접 편집', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileAppWidget(String templateId) {
    switch (templateId) {
      case 'kakaotalk':
        return KakaoTalkScreen(config: KakaoRoomConfig.defaultPreset());
      case 'instagram':
        return InstagramScreen(config: InstagramConfig.defaultPreset());
      case 'toss':
        return TossScreen(config: TossConfig.defaultPreset());
      case 'x_twitter':
        return XTwitterScreen(config: XTwitterConfig.defaultPreset());
      case 'pinterest':
        return PinterestScreen(config: PinterestConfig.defaultPreset());
      case 'youtube':
        return YoutubeScreen(config: YoutubeConfig.defaultPreset());
      case 'delivery':
        return DeliveryScreen(config: DeliveryConfig.defaultPreset());
      default:
        return KakaoTalkScreen(config: KakaoRoomConfig.defaultPreset());
    }
  }

  List<Widget> _buildDesktopWindowsLayer({required bool isMacStyle}) {
    return _activeFloatingWindows.where((w) => !w.isMinimized).map((win) {
      final isFocused = _activeFloatingWindows.isNotEmpty && _activeFloatingWindows.last.id == win.id;
      return ValueListenableBuilder<Offset>(
        valueListenable: win.positionNotifier,
        builder: (context, pos, child) {
          return FloatingAppWindow(
            key: ValueKey(win.id),
            template: win.template,
            position: pos,
            size: win.size,
            isFocused: isFocused,
            isMacStyle: isMacStyle,
            onFocus: () => _bringToFront(win.id),
            onPositionChanged: (newPos) => win.position = newPos,
            onSizeChanged: (newSize) => setState(() => win.size = newSize),
            onMinimize: () => setState(() => win.isMinimized = true),
            onClose: () => setState(() => _activeFloatingWindows.removeWhere((w) => w.id == win.id)),
          );
        },
      );
    }).toList();
  }

  Widget _buildDesktopPhoneContainer({required Widget child, required String title, required String osKey}) {
    return Container(
      color: const Color(0xFF090A0F),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    (osKey == 'galaxy' ? const Color(0xFF4F46E5) : const Color(0xFF2563EB)).withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 14,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 16)],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.device_phone_portrait, color: osKey == 'galaxy' ? const Color(0xFF10B981) : const Color(0xFF38BDF8), size: 16),
                    const SizedBox(width: 8),
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 14),
                    Container(width: 1, height: 16, color: Colors.white24),
                    const SizedBox(width: 10),
                    _buildPhoneTopButton(label: '전체화면', icon: CupertinoIcons.arrow_up_left_arrow_down_right, onTap: () => setState(() => _isDesktopMobileFullScreen = true)),
                    const SizedBox(width: 6),
                    _buildPhoneTopButton(label: 'Windows 11', icon: CupertinoIcons.device_desktop, onTap: () => _handleSelectOs('windows')),
                    const SizedBox(width: 6),
                    _buildPhoneTopButton(label: 'macOS', icon: CupertinoIcons.device_laptop, onTap: () => _handleSelectOs('macos')),
                    if (osKey != 'galaxy') ...[
                      const SizedBox(width: 6),
                      _buildPhoneTopButton(label: 'Galaxy (One UI 9)', icon: CupertinoIcons.device_phone_portrait, onTap: () => _handleSelectOs('galaxy')),
                    ],
                    if (osKey != 'ios') ...[
                      const SizedBox(width: 6),
                      _buildPhoneTopButton(label: 'iOS 18', icon: CupertinoIcons.device_phone_portrait, onTap: () => _handleSelectOs('ios')),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 56, bottom: 16),
              child: Container(
                width: 412,
                constraints: const BoxConstraints(maxHeight: 890),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(44),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.22), width: 3.5),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.65), blurRadius: 40, spreadRadius: 4, offset: const Offset(0, 10)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFullScreenOverlayBar(String title) {
    return Positioned(
      top: 14,
      right: 20,
      child: InkWell(
        onTap: () => setState(() => _isDesktopMobileFullScreen = false),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 10)],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(CupertinoIcons.arrow_down_right_arrow_up_left, size: 13, color: Colors.white),
              const SizedBox(width: 6),
              Text('$title 프레임으로 축소', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneTopButton({required String label, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: Colors.white70),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
