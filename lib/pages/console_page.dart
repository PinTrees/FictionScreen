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
  Offset position;
  Size size;
  bool isMinimized;
  int zIndex;

  FloatingWindowData({
    required this.id,
    required this.template,
    required this.position,
    required this.size,
    this.isMinimized = false,
    this.zIndex = 0,
  });
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
  // 전역 바탕화면 테마
  String _wallpaper = 'win10_hero';

  bool _isStartMenuOpen = false;
  bool _isSettingsOpen = false;
  bool _isLoadingSettings = false;
  String? _activeMobileTemplateId;
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

    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 768;

    if (isDesktop) {
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
        final initialSize = template.isDesktop ? const Size(720, 480) : const Size(380, 680);

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

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: AuthService.authStateChanges,
        builder: (context, snapshot) {
          final user = snapshot.data ?? AuthService.currentUser;

          return Stack(
            children: [
              // 1. 선택된 가상 OS 메인 뷰 (Windows / macOS)
              if (isDesktop) ...[
                if (_pcTheme == 'macos')
                  MacosView(
                    user: user,
                    timeString: _formatDate('E a h:mm', 'ko_KR'),
                    currentWallpaper: _wallpaper,
                    onOpenTemplate: _openTemplate,
                    onOpenSettings: () => setState(() => _isSettingsOpen = true),
                    onSignOut: _handleSignOut,
                    onGoHome: () => context.go('/'),
                  )
                else
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

                // 2. MDI 가상 창 레이어 모음
                ..._activeFloatingWindows.where((w) => !w.isMinimized).map((win) {
                  final isFocused = _activeFloatingWindows.isNotEmpty && _activeFloatingWindows.last.id == win.id;

                  return FloatingAppWindow(
                    key: ValueKey(win.id),
                    template: win.template,
                    position: win.position,
                    size: win.size,
                    isFocused: isFocused,
                    isMacStyle: _pcTheme == 'macos',
                    onFocus: () => _bringToFront(win.id),
                    onPositionChanged: (newPos) => setState(() => win.position = newPos),
                    onSizeChanged: (newSize) => setState(() => win.size = newSize),
                    onMinimize: () => setState(() => win.isMinimized = true),
                    onClose: () {
                      setState(() {
                        _activeFloatingWindows.removeWhere((w) => w.id == win.id);
                      });
                    },
                  );
                }),
              ] else ...[
                if (_mobileTheme == 'ios')
                  IosView(
                    timeString: _formatDate('h:mm'),
                    dateString: _formatDate('M월 d일 EEEE', 'ko_KR'),
                    currentWallpaper: _wallpaper,
                    onOpenTemplate: _openTemplate,
                    onOpenSettings: () => setState(() => _isSettingsOpen = true),
                    onSignOut: _handleSignOut,
                    onGoHome: () => context.go('/'),
                  )
                else
                  GalaxyView(
                    timeString: _formatDate('h:mm'),
                    dateString: _formatDate('M월 d일 EEEE', 'ko_KR'),
                    currentWallpaper: _wallpaper,
                    onOpenTemplate: _openTemplate,
                    onOpenSettings: () => setState(() => _isSettingsOpen = true),
                    onSignOut: _handleSignOut,
                    onGoHome: () => context.go('/'),
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
                          onPcThemeChanged: (val) {
                            setState(() => _pcTheme = val);
                            _saveCurrentOsSettings();
                          },
                          onWindowsVersionChanged: (val) {
                            setState(() => _windowsVersion = val);
                            _saveCurrentOsSettings();
                          },
                          onMobileThemeChanged: (val) {
                            setState(() => _mobileTheme = val);
                            _saveCurrentOsSettings();
                          },
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
                                onPcThemeChanged: (val) {
                                  setState(() => _pcTheme = val);
                                  _saveCurrentOsSettings();
                                },
                                onWindowsVersionChanged: (val) {
                                  setState(() => _windowsVersion = val);
                                  _saveCurrentOsSettings();
                                },
                                onMobileThemeChanged: (val) {
                                  setState(() => _mobileTheme = val);
                                  _saveCurrentOsSettings();
                                },
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
              if (!isDesktop && _activeMobileTemplateId != null)
                Positioned.fill(
                  child: _buildMobileFullScreenApp(_activeMobileTemplateId!),
                ),
            ],
          );
        },
      ),
    );
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
}
