import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../apps/chrome/chrome_window.dart';
import '../../apps/finder/finder_window.dart';
import '../../apps/mail/mail_window.dart';
import '../../apps/maps/maps_window.dart';
import '../../apps/messages/messages_window.dart';
import '../../apps/music/music_window.dart';
import '../../apps/notes/notes_window.dart';
import '../../apps/photos/photos_window.dart';
import '../../apps/safari/safari_window.dart';
import '../../apps/terminal/terminal_window.dart';
import '../../../../../apps/pdf_viewer/pdf_viewer_window.dart';
import '../../../../../apps/telegram/telegram_window.dart';
import '../../../../../apps/zigbang/zigbang_window.dart';
import '../../../../../apps/naver/naver_window.dart';
import '../../../../../apps/cctv/cctv_window.dart';
import '../../../../../apps/steam/steam_window.dart';
import '../../../../console/windows/apps/edge/edge_window.dart';
import '../../../common/os_window_frame.dart';
import '../../macos_dock.dart';
import '../../macos_menubar.dart';
import '../macos27/apps/settings/macos27_settings_window.dart';

/// macOS 15 Sequoia 레거시 데스크톱 뷰
class SequoiaView extends StatefulWidget {
  final User? user;
  final String timeString;
  final String currentWallpaper;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;
  final Function(String osKey)? onSelectOs;

  const SequoiaView({
    super.key,
    required this.user,
    required this.timeString,
    required this.currentWallpaper,
    required this.onOpenTemplate,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
    this.onSelectOs,
  });

  @override
  State<SequoiaView> createState() => _SequoiaViewState();
}

class _SequoiaViewState extends State<SequoiaView> {
  final List<String> _openApps = [];
  bool _isSettingsOpen = false;

  void _openApp(String appId) {
    if (appId == 'settings') {
      setState(() => _isSettingsOpen = true);
    } else {
      if (!_openApps.contains(appId)) {
        setState(() => _openApps.add(appId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/macos_golden_gate.webp',
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ),

        // MDI 창들
        ..._openApps.map((appId) {
          return Positioned(
            left: 120,
            top: 60,
            child: _buildAppWindow(appId),
          );
        }),

        if (_isSettingsOpen)
          Positioned(
            left: 140,
            top: 70,
            child: Macos27SettingsWindow(
              width: 800,
              height: 520,
              onClose: () => setState(() => _isSettingsOpen = false),
              onTitleDragStart: (_) {},
              onTitleDragUpdate: (_) {},
              onSelectOs: widget.onSelectOs,
              currentWallpaper: widget.currentWallpaper,
              onWallpaperChanged: (_) {},
              glassTransparency: 0.5,
              onGlassTransparencyChanged: (_) {},
              user: widget.user,
            ),
          ),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: MacosMenuBar(
            user: widget.user,
            timeString: widget.timeString,
            onOpenSettings: () => _openApp('settings'),
            onSignOut: widget.onSignOut,
            onGoHome: widget.onGoHome,
          ),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: MacosDock(
            onOpenTemplate: widget.onOpenTemplate,
            onOpenApp: _openApp,
            onOpenSettings: () => _openApp('settings'),
            onGoHome: widget.onGoHome,
          ),
        ),
      ],
    );
  }

  Widget _buildAppWindow(String appId) {
    switch (appId) {
      case 'safari':
        return SafariWindow(width: 780, height: 500, onClose: () => setState(() => _openApps.remove('safari')), onOpenTemplate: widget.onOpenTemplate, onTitleDragStart: (_) {}, onTitleDragUpdate: (_) {});
      case 'terminal':
        return TerminalWindow(width: 660, height: 420, onClose: () => setState(() => _openApps.remove('terminal')), onTitleDragStart: (_) {}, onTitleDragUpdate: (_) {});
      case 'notes':
        return NotesWindow(width: 740, height: 480, onClose: () => setState(() => _openApps.remove('notes')), onTitleDragStart: (_) {}, onTitleDragUpdate: (_) {});
      case 'messages':
        return MessagesWindow(width: 740, height: 480, onClose: () => setState(() => _openApps.remove('messages')), onTitleDragStart: (_) {}, onTitleDragUpdate: (_) {});
      case 'mail':
        return MailWindow(width: 740, height: 480, onClose: () => setState(() => _openApps.remove('mail')), onTitleDragStart: (_) {}, onTitleDragUpdate: (_) {});
      case 'maps':
        return MapsWindow(width: 740, height: 480, onClose: () => setState(() => _openApps.remove('maps')), onTitleDragStart: (_) {}, onTitleDragUpdate: (_) {});
      case 'photos':
        return PhotosWindow(width: 740, height: 480, onClose: () => setState(() => _openApps.remove('photos')), onTitleDragStart: (_) {}, onTitleDragUpdate: (_) {});
      case 'music':
        return MusicWindow(width: 740, height: 480, onClose: () => setState(() => _openApps.remove('music')), onTitleDragStart: (_) {}, onTitleDragUpdate: (_) {});
      case 'chrome':
        return MacosChromeWindow(width: 780, height: 500, onClose: () => setState(() => _openApps.remove('chrome')), onOpenTemplate: widget.onOpenTemplate, onTitleDragStart: (_) {}, onTitleDragUpdate: (_) {});
      case 'edge':
        return WindowsEdgeWindow(width: 820, height: 540, style: WindowStyle.macos, onClose: () => setState(() => _openApps.remove('edge')), onTitleDragStart: (_) {}, onTitleDragUpdate: (_) {});
      case 'zigbang':
        return ZigbangWindow(width: 880, height: 580, style: WindowStyle.macos, onClose: () => setState(() => _openApps.remove('zigbang')), onTitleDragStart: (_) {}, onTitleDragUpdate: (_) {});
      case 'naver':
        return NaverWindow(width: 920, height: 600, style: WindowStyle.macos, onClose: () => setState(() => _openApps.remove('naver')), onTitleDragStart: (_) {}, onTitleDragUpdate: (_) {});
      case 'cctv':
        return CctvWindow(width: 960, height: 640, style: WindowStyle.macos, onClose: () => setState(() => _openApps.remove('cctv')), onTitleDragStart: (_) {}, onTitleDragUpdate: (_) {});
      case 'steam':
        return SteamWindow(width: 980, height: 640, style: WindowStyle.macos, onClose: () => setState(() => _openApps.remove('steam')), onTitleDragStart: (_) {}, onTitleDragUpdate: (_) {});
      case 'pdf_viewer':
        return PdfViewerWindow(width: 880, height: 580, style: WindowStyle.macos, onClose: () => setState(() => _openApps.remove('pdf_viewer')), onTitleDragStart: (_) {}, onTitleDragUpdate: (_) {});
      case 'telegram':
        return TelegramWindow(width: 860, height: 560, style: WindowStyle.macos, onClose: () => setState(() => _openApps.remove('telegram')), onTitleDragStart: (_) {}, onTitleDragUpdate: (_) {});
      case 'finder':
      default:
        return FinderWindow(width: 780, height: 500, onClose: () => setState(() => _openApps.remove(appId)), onOpenTemplate: widget.onOpenTemplate, onTitleDragStart: (_) {}, onTitleDragUpdate: (_) {});
    }
  }
}
