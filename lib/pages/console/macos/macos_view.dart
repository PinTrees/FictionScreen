import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common/os_app_item.dart';
import 'apps/finder/finder_window.dart';
import 'apps/mail/mail_window.dart';
import 'apps/maps/maps_window.dart';
import 'apps/messages/messages_window.dart';
import 'apps/music/music_window.dart';
import 'apps/notes/notes_window.dart';
import 'apps/photos/photos_window.dart';
import 'apps/safari/safari_window.dart';
import 'apps/terminal/terminal_window.dart';
import 'macos_dock.dart';
import 'macos_menubar.dart';

/// macOS MDI 가상 창 데이터 모델
class MacosWindowData {
  final String id;
  final String appId;
  Offset position;
  Size size;
  int zIndex;
  bool isMinimized;

  MacosWindowData({
    required this.id,
    required this.appId,
    required this.position,
    required this.size,
    required this.zIndex,
    this.isMinimized = false,
  });
}

/// macOS 전용 데스크톱 MDI 뷰 레이아웃
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
  final List<MacosWindowData> _activeWindows = [];
  int _highestZIndex = 1;

  void _openApp(String appId) {
    final existingIndex = _activeWindows.indexWhere((w) => w.appId == appId);

    if (existingIndex != -1) {
      _bringToFront(_activeWindows[existingIndex].id);
    } else {
      _highestZIndex++;
      final count = _activeWindows.length;
      final initialPos = Offset(100.0 + (count * 28), 50.0 + (count * 22));
      Size defaultSize = const Size(780, 520);

      if (appId == 'terminal') {
        defaultSize = const Size(680, 440);
      } else if (appId == 'messages' || appId == 'notes') {
        defaultSize = const Size(760, 500);
      }

      final newWin = MacosWindowData(
        id: '${appId}_${DateTime.now().millisecondsSinceEpoch}',
        appId: appId,
        position: initialPos,
        size: defaultSize,
        zIndex: _highestZIndex,
      );

      setState(() {
        _activeWindows.add(newWin);
        _activeWindows.sort((a, b) => a.zIndex.compareTo(b.zIndex));
      });
    }
  }

  void _closeWindow(String windowId) {
    setState(() {
      _activeWindows.removeWhere((w) => w.id == windowId);
    });
  }

  void _bringToFront(String windowId) {
    setState(() {
      _highestZIndex++;
      final win = _activeWindows.firstWhere((w) => w.id == windowId);
      win.zIndex = _highestZIndex;
      win.isMinimized = false;
      _activeWindows.sort((a, b) => a.zIndex.compareTo(b.zIndex));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. 2K 고해상도 레티나 배경화면
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

        // 3. MDI 가상 floating 윈도우 창 레이어
        ..._activeWindows.map((win) {
          if (win.isMinimized) return const SizedBox.shrink();

          return Positioned(
            left: win.position.dx,
            top: win.position.dy,
            child: _MacosMdiWindowWrapper(
              key: ValueKey(win.id),
              windowData: win,
              onTapFocus: () => _bringToFront(win.id),
              onClose: () => _closeWindow(win.id),
              builder: (onDragStart, onDragUpdate) => _buildAppContent(win, onDragStart, onDragUpdate),
            ),
          );
        }),

        // 4. 상단 Apple 글로벌 메뉴바
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

  Widget _buildAppContent(
    MacosWindowData win,
    Function(DragStartDetails) onDragStart,
    Function(DragUpdateDetails) onDragUpdate,
  ) {
    switch (win.appId) {
      case 'finder':
        return FinderWindow(
          width: win.size.width,
          height: win.size.height,
          onClose: () => _closeWindow(win.id),
          onOpenTemplate: widget.onOpenTemplate,
          onTitleDragStart: onDragStart,
          onTitleDragUpdate: onDragUpdate,
        );
      case 'safari':
        return SafariWindow(
          width: win.size.width,
          height: win.size.height,
          onClose: () => _closeWindow(win.id),
          onOpenTemplate: widget.onOpenTemplate,
          onTitleDragStart: onDragStart,
          onTitleDragUpdate: onDragUpdate,
        );
      case 'terminal':
        return TerminalWindow(
          width: win.size.width,
          height: win.size.height,
          onClose: () => _closeWindow(win.id),
          onTitleDragStart: onDragStart,
          onTitleDragUpdate: onDragUpdate,
        );
      case 'messages':
        return MessagesWindow(
          width: win.size.width,
          height: win.size.height,
          onClose: () => _closeWindow(win.id),
          onTitleDragStart: onDragStart,
          onTitleDragUpdate: onDragUpdate,
        );
      case 'notes':
        return NotesWindow(
          width: win.size.width,
          height: win.size.height,
          onClose: () => _closeWindow(win.id),
          onTitleDragStart: onDragStart,
          onTitleDragUpdate: onDragUpdate,
        );
      case 'mail':
        return MailWindow(
          width: win.size.width,
          height: win.size.height,
          onClose: () => _closeWindow(win.id),
          onTitleDragStart: onDragStart,
          onTitleDragUpdate: onDragUpdate,
        );
      case 'photos':
        return PhotosWindow(
          width: win.size.width,
          height: win.size.height,
          onClose: () => _closeWindow(win.id),
          onTitleDragStart: onDragStart,
          onTitleDragUpdate: onDragUpdate,
        );
      case 'music':
        return MusicWindow(
          width: win.size.width,
          height: win.size.height,
          onClose: () => _closeWindow(win.id),
          onTitleDragStart: onDragStart,
          onTitleDragUpdate: onDragUpdate,
        );
      case 'maps':
        return MapsWindow(
          width: win.size.width,
          height: win.size.height,
          onClose: () => _closeWindow(win.id),
          onTitleDragStart: onDragStart,
          onTitleDragUpdate: onDragUpdate,
        );
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

/// macOS MDI 가상 창 래퍼 위젯 (타이틀바 1:1 드래그 + 리사이즈 + 포커스 연동)
class _MacosMdiWindowWrapper extends StatefulWidget {
  final MacosWindowData windowData;
  final VoidCallback onTapFocus;
  final VoidCallback onClose;
  final Widget Function(
    Function(DragStartDetails) onDragStart,
    Function(DragUpdateDetails) onDragUpdate,
  ) builder;

  const _MacosMdiWindowWrapper({
    super.key,
    required this.windowData,
    required this.onTapFocus,
    required this.onClose,
    required this.builder,
  });

  @override
  State<_MacosMdiWindowWrapper> createState() => _MacosMdiWindowWrapperState();
}

class _MacosMdiWindowWrapperState extends State<_MacosMdiWindowWrapper> {
  Offset _dragStartOffset = Offset.zero;

  void _handleDragStart(DragStartDetails details) {
    widget.onTapFocus();
    _dragStartOffset = details.globalPosition - widget.windowData.position;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      widget.windowData.position = details.globalPosition - _dragStartOffset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => widget.onTapFocus(),
      child: SizedBox(
        width: widget.windowData.size.width,
        height: widget.windowData.size.height,
        child: Stack(
          children: [
            // 창 내용 (OsWindowFrame 타이틀바에 드래그 제스처 직접 바인딩)
            Positioned.fill(
              child: widget.builder(_handleDragStart, _handleDragUpdate),
            ),

            // 창 우측 하단 리사이즈 핸들 (1:1 마우스 드래그 조절)
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onPanStart: (_) => widget.onTapFocus(),
                onPanUpdate: (details) {
                  setState(() {
                    final newWidth = (widget.windowData.size.width + details.delta.dx).clamp(420.0, 1400.0);
                    final newHeight = (widget.windowData.size.height + details.delta.dy).clamp(320.0, 900.0);
                    widget.windowData.size = Size(newWidth, newHeight);
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeUpLeftDownRight,
                  child: Container(
                    width: 24,
                    height: 24,
                    color: Colors.transparent,
                    child: const Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          CupertinoIcons.arrow_down_right,
                          size: 11,
                          color: Colors.white38,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
