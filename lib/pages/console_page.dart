import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
import 'console/android/galaxy_view.dart';
import 'console/ios/ios_view.dart';
import 'console/macos/macos_view.dart';
import 'console/settings/os_settings_window.dart';
import 'console/windows/windows_view.dart';

/// 가상 OS 콘솔 메인 페이지 (오케스트레이터)
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
  // 전역 바탕화면 테마 (기본: 사용자가 업로드한 win10_hero)
  String _wallpaper = 'win10_hero';

  bool _isStartMenuOpen = false;
  bool _isSettingsOpen = false;
  late Timer _clockTimer;
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
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  void _openTemplate(String templateId) {
    setState(() {
      _isStartMenuOpen = false;
      _isSettingsOpen = false;
    });
    context.push('/studio/$templateId');
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
              // 1. 선택된 가상 OS 메인 뷰
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

              // 2. 시스템 설정(Settings) 모달 창
              if (_isSettingsOpen)
                GestureDetector(
                  onTap: () => setState(() => _isSettingsOpen = false),
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.35),
                    child: GestureDetector(
                      onTap: () {}, // 창 내부 클릭 시 닫힘 방지
                      child: OsSettingsWindow(
                        currentPcTheme: _pcTheme,
                        currentWindowsVersion: _windowsVersion,
                        currentMobileTheme: _mobileTheme,
                        currentWallpaper: _wallpaper,
                        onPcThemeChanged: (val) => setState(() => _pcTheme = val),
                        onWindowsVersionChanged: (val) => setState(() => _windowsVersion = val),
                        onMobileThemeChanged: (val) => setState(() => _mobileTheme = val),
                        onWallpaperChanged: (val) => setState(() => _wallpaper = val),
                        onClose: () => setState(() => _isSettingsOpen = false),
                        onSignOut: _handleSignOut,
                        user: user,
                        isDesktop: isDesktop,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}