import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../common/os_app_item.dart';
import 'apps/finder_window.dart';
import 'apps/mail_window.dart';
import 'apps/maps_window.dart';
import 'apps/messages_window.dart';
import 'apps/music_window.dart';
import 'apps/notes_window.dart';
import 'apps/photos_window.dart';
import 'apps/safari_window.dart';
import 'apps/terminal_window.dart';
import 'macos_dock.dart';
import 'macos_menubar.dart';

/// macOS 전용 데스크톱 뷰 레이아웃
class MacosView extends StatefulWidget {
  final User? user;
  final String timeString;
  final String currentWallpaper;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;

  const MacosView({
    super.key,
    required this.user,
    required this.timeString,
    required this.currentWallpaper,
    required this.onOpenTemplate,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
  });

  @override
  State<MacosView> createState() => _MacosViewState();
}

class _MacosViewState extends State<MacosView> {
  String? _activeAppId;

  void _openApp(String appId) {
    setState(() {
      _activeAppId = appId;
    });
  }

  void _closeApp() {
    setState(() {
      _activeAppId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. 2K 고해상도 배경화면
        Positioned.fill(
          child: _buildMacWallpaper(),
        ),

        // 2. 바탕화면 디스크 & 시스템 설정 아이콘 (우측 상단)
        Positioned(
          top: 46,
          right: 20,
          child: Column(
            children: [
              OsAppItem(
                title: 'Macintosh HD',
                imageAsset: 'assets/images/apple_logo.webp',
                iconColor: Colors.white,
                backgroundColor: Colors.white.withValues(alpha: 0.18),
                onTap: () => _openApp('finder'),
              ),
              const SizedBox(height: 12),
              OsAppItem(
                title: '시스템 설정',
                imageAsset: 'assets/images/macos/settings.webp',
                onTap: widget.onOpenSettings,
              ),
            ],
          ),
        ),

        // 3. 상단 Apple 메뉴바
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: MacosMenuBar(
            user: widget.user,
            timeString: widget.timeString,
            onOpenSettings: widget.onOpenSettings,
            onSignOut: widget.onSignOut,
            onGoHome: widget.onGoHome,
          ),
        ),

        // 4. 활성화된 기본 앱 창 (오버레이 모달)
        if (_activeAppId != null)
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeApp,
              behavior: HitTestBehavior.translucent,
              child: Container(
                color: Colors.black.withValues(alpha: 0.25),
                child: Center(
                  child: GestureDetector(
                    onTap: () {}, // 창 내부 클릭 시 닫힘 방지
                    child: _buildActiveAppWindow(),
                  ),
                ),
              ),
            ),
          ),

        // 5. 하단 플로팅 글래스 독
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: MacosDock(
            onOpenTemplate: widget.onOpenTemplate,
            onOpenApp: _openApp,
            onOpenSettings: widget.onOpenSettings,
            onGoHome: widget.onGoHome,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveAppWindow() {
    switch (_activeAppId) {
      case 'finder':
        return FinderWindow(onClose: _closeApp, onOpenTemplate: widget.onOpenTemplate);
      case 'safari':
        return SafariWindow(onClose: _closeApp, onOpenTemplate: widget.onOpenTemplate);
      case 'terminal':
        return TerminalWindow(onClose: _closeApp);
      case 'messages':
        return MessagesWindow(onClose: _closeApp);
      case 'notes':
        return NotesWindow(onClose: _closeApp);
      case 'mail':
        return MailWindow(onClose: _closeApp);
      case 'photos':
        return PhotosWindow(onClose: _closeApp);
      case 'music':
        return MusicWindow(onClose: _closeApp);
      case 'maps':
        return MapsWindow(onClose: _closeApp);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMacWallpaper() {
    if (widget.currentWallpaper == 'macos_golden_gate' || widget.currentWallpaper == 'golden_gate') {
      return Image.asset(
        'assets/images/macos_golden_gate.webp',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        filterQuality: FilterQuality.high,
      );
    }

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
        return Container(color: const Color(0xFF0D0E15));
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
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E1B4B), Color(0xFF311042), Color(0xFF0F172A)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 80,
                left: 180,
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFF43F5E).withValues(alpha: 0.16),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 120,
                right: 200,
                child: Container(
                  width: 450,
                  height: 450,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF8B5CF6).withValues(alpha: 0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      default:
        return Image.asset(
          'assets/images/macos_golden_gate.webp',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          filterQuality: FilterQuality.high,
        );
    }
  }
}