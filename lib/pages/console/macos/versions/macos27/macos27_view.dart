import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../common/os_app_item.dart';
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
import 'apps/settings/macos27_settings_window.dart';
import 'widgets/macos27_context_menu.dart';
import 'widgets/macos27_dock.dart';
import 'widgets/macos27_menubar.dart';

/// macOS MDI 가상 창 데이터 모델
class Macos27WindowData {
  final String id;
  final String appId;
  final ValueNotifier<Offset> positionNotifier;
  Size size;
  int zIndex;
  bool isMinimized;

  Macos27WindowData({
    required this.id,
    required this.appId,
    required Offset position,
    required this.size,
    required this.zIndex,
    this.isMinimized = false,
  }) : positionNotifier = ValueNotifier<Offset>(position);

  Offset get position => positionNotifier.value;
  set position(Offset newPos) => positionNotifier.value = newPos;
}

/// macOS 데스크톱 사용자 생성 아이템 모델
class MacosDesktopItem {
  final String id;
  String title;
  Offset position;
  final String imageAsset;
  final bool isFolder;

  MacosDesktopItem({
    required this.id,
    required this.title,
    required this.position,
    required this.imageAsset,
    this.isFolder = false,
  });
}

/// macOS 27 Golden Gate 플래그십 데스크톱 뷰 레이아웃
/// - Apple Silicon 전용 Liquid Glass 투명도 & 머티리얼 시스템
/// - Siri AI & Spotlight "Search or Ask" 상단 메뉴바
/// - 코사인 확대 및 반사광 독(Dock)
/// - 골든 게이트 공식 4종 에어리얼 배경화면(Day, Sunset, Evening, Night, Abstract Hero)
class Macos27View extends StatefulWidget {
  final User? user;
  final String timeString;
  final String currentWallpaper;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;
  final Function(String osKey)? onSelectOs;
  final Function(String wallpaperKey)? onWallpaperChanged;

  const Macos27View({
    super.key,
    required this.user,
    required this.timeString,
    required this.currentWallpaper,
    required this.onOpenTemplate,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
    this.onSelectOs,
    this.onWallpaperChanged,
  });

  @override
  State<Macos27View> createState() => _Macos27ViewState();
}

class _Macos27ViewState extends State<Macos27View> {
  final List<Macos27WindowData> _activeWindows = [];
  int _highestZIndex = 1;
  String _activeWallpaper = '';
  double _glassTransparency = 0.55;
  Offset? _contextMenuPos;
  final List<MacosDesktopItem> _customFolders = [];

  void _handleCreateNewFolder(Offset clickPos) {
    final folderNum = _customFolders.length + 1;
    final title = folderNum == 1 ? '무제 폴더' : '무제 폴더 $folderNum';
    final size = MediaQuery.of(context).size;
    final pos = Offset(
      (clickPos.dx - 30).clamp(20.0, size.width - 120.0),
      (clickPos.dy - 30).clamp(50.0, size.height - 180.0),
    );
    setState(() {
      _customFolders.add(
        MacosDesktopItem(
          id: 'folder_${DateTime.now().millisecondsSinceEpoch}',
          title: title,
          position: pos,
          imageAsset: 'assets/images/macos/folder.png',
          isFolder: true,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _activeWallpaper = widget.currentWallpaper;
  }

  @override
  void didUpdateWidget(covariant Macos27View oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentWallpaper != widget.currentWallpaper) {
      _activeWallpaper = widget.currentWallpaper;
    }
  }

  void _openApp(String appId) {
    final existingIndex = _activeWindows.indexWhere((w) => w.appId == appId);

    if (existingIndex != -1) {
      _bringToFront(_activeWindows[existingIndex].id);
    } else {
      _highestZIndex++;
      final count = _activeWindows.length;
      final initialPos = Offset(110.0 + (count * 28), 54.0 + (count * 22));
      Size defaultSize = const Size(780, 520);

      if (appId == 'terminal') {
        defaultSize = const Size(680, 440);
      } else if (appId == 'settings') {
        defaultSize = const Size(820, 540);
      } else if (appId == 'messages' || appId == 'notes') {
        defaultSize = const Size(760, 500);
      }

      final newWin = Macos27WindowData(
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
    setState(() => _activeWindows.removeWhere((w) => w.id == windowId));
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
    final activeAppIds = _activeWindows.map((w) => w.appId).toList();

    return Stack(
      children: [
        // 1. macOS 27 Golden Gate 레티나 배경화면 + 우클릭 제스처
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onSecondaryTapDown: (details) => setState(() => _contextMenuPos = details.globalPosition),
            onTap: () {
              if (_contextMenuPos != null) setState(() => _contextMenuPos = null);
            },
            child: _buildMacWallpaper(),
          ),
        ),

        // 2. 바탕화면 디스크 & 시스템 설정 아이콘 (우측 상단)
        Positioned(
          top: 48,
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
              const SizedBox(height: 14),
              OsAppItem(
                title: '시스템 설정',
                imageAsset: 'assets/images/macos/settings.webp',
                onTap: () => _openApp('settings'),
              ),
            ],
          ),
        ),

        // 2-1. 사용자 생성 데스크톱 폴더 (드래그 이동 & 더블클릭 Finder 열기)
        ..._customFolders.map((folder) {
          return Positioned(
            left: folder.position.dx,
            top: folder.position.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() => folder.position += details.delta);
              },
              onTap: () => _openApp('finder'),
              onSecondaryTapDown: (details) {
                setState(() => _contextMenuPos = details.globalPosition);
              },
              child: Container(
                width: 76,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      folder.imageAsset,
                      width: 54,
                      height: 54,
                      filterQuality: FilterQuality.high,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        folder.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),

        // 3. MDI 가상 floating 윈도우 창 레이어
        ..._activeWindows.map((win) {
          if (win.isMinimized) return const SizedBox.shrink();

          return ValueListenableBuilder<Offset>(
            valueListenable: win.positionNotifier,
            builder: (context, pos, child) {
              return Positioned(
                left: pos.dx,
                top: pos.dy,
                child: _Macos27MdiWindowWrapper(
                  key: ValueKey(win.id),
                  windowData: win,
                  onTapFocus: () => _bringToFront(win.id),
                  onClose: () => _closeWindow(win.id),
                  builder: (onDragStart, onDragUpdate) => _buildAppContent(win, onDragStart, onDragUpdate),
                ),
              );
            },
          );
        }),

        // 4. 상단 Apple 글로벌 메뉴바 (macOS 27 Liquid Glass)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Macos27MenuBar(
            user: widget.user,
            timeString: widget.timeString,
            glassTransparency: _glassTransparency,
            onOpenSettings: () => _openApp('settings'),
            onOpenOsSwitch: () => _openApp('settings'),
            onSignOut: widget.onSignOut,
            onGoHome: widget.onGoHome,
            onToggleSpotlight: () => _openApp('finder'),
          ),
        ),

        // 5. 하단 플로팅 글래스 독 (macOS 27 Liquid Glass)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Macos27Dock(
            activeAppIds: activeAppIds,
            glassTransparency: _glassTransparency,
            onOpenTemplate: widget.onOpenTemplate,
            onOpenApp: _openApp,
            onOpenSettings: () => _openApp('settings'),
            onGoHome: widget.onGoHome,
          ),
        ),

        // 6. macOS 27 우클릭 컨텍스트 메뉴
        if (_contextMenuPos != null)
          Macos27ContextMenu(
            position: _contextMenuPos!,
            onNewFolder: () => _handleCreateNewFolder(_contextMenuPos!),
            onOpenWallpaperSettings: () => _openApp('settings'),
            onOpenSettings: () => _openApp('settings'),
            onOpenOsSwitch: () => _openApp('settings'),
            onClose: () => setState(() => _contextMenuPos = null),
          ),
      ],
    );
  }

  Widget _buildAppContent(
    Macos27WindowData win,
    Function(DragStartDetails) onDragStart,
    Function(DragUpdateDetails) onDragUpdate,
  ) {
    switch (win.appId) {
      case 'settings':
        return Macos27SettingsWindow(
          width: win.size.width,
          height: win.size.height,
          onClose: () => _closeWindow(win.id),
          onTitleDragStart: onDragStart,
          onTitleDragUpdate: onDragUpdate,
          onSelectOs: widget.onSelectOs,
          currentWallpaper: _activeWallpaper,
          glassTransparency: _glassTransparency,
          onGlassTransparencyChanged: (val) => setState(() => _glassTransparency = val),
          onWallpaperChanged: (wp) {
            setState(() => _activeWallpaper = wp);
            widget.onWallpaperChanged?.call(wp);
          },
          user: widget.user,
        );
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
      case 'chrome':
        return MacosChromeWindow(
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
      case 'maps':
        return MapsWindow(
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
      default:
        return FinderWindow(
          width: win.size.width,
          height: win.size.height,
          onClose: () => _closeWindow(win.id),
          onOpenTemplate: widget.onOpenTemplate,
          onTitleDragStart: onDragStart,
          onTitleDragUpdate: onDragUpdate,
        );
    }
  }

  Widget _buildMacWallpaper() {
    String assetPath;
    switch (_activeWallpaper) {
      case 'golden_gate_sunset':
        assetPath = 'assets/images/macos/golden_gate/sunset.png';
        break;
      case 'golden_gate_day':
        assetPath = 'assets/images/macos/golden_gate/day.png';
        break;
      case 'golden_gate_evening':
        assetPath = 'assets/images/macos/golden_gate/evening.png';
        break;
      case 'golden_gate_night':
        assetPath = 'assets/images/macos/golden_gate/night.png';
        break;
      case 'macos_golden_gate':
      case 'golden_gate':
      default:
        assetPath = 'assets/images/macos_golden_gate.webp';
        break;
    }

    return Image.asset(
      assetPath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      filterQuality: FilterQuality.high,
    );
  }
}

/// macOS MDI 가상 창 래퍼 위젯 (타이틀바 1:1 드래그 + 리사이즈 + 포커스 연동)
class _Macos27MdiWindowWrapper extends StatefulWidget {
  final Macos27WindowData windowData;
  final VoidCallback onTapFocus;
  final VoidCallback onClose;
  final Widget Function(
    Function(DragStartDetails) onDragStart,
    Function(DragUpdateDetails) onDragUpdate,
  ) builder;

  const _Macos27MdiWindowWrapper({
    super.key,
    required this.windowData,
    required this.onTapFocus,
    required this.onClose,
    required this.builder,
  });

  @override
  State<_Macos27MdiWindowWrapper> createState() => _Macos27MdiWindowWrapperState();
}

class _Macos27MdiWindowWrapperState extends State<_Macos27MdiWindowWrapper> {
  Offset _dragStartOffset = Offset.zero;

  void _handleDragStart(DragStartDetails details) {
    widget.onTapFocus();
    _dragStartOffset = details.globalPosition - widget.windowData.position;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    widget.windowData.position = details.globalPosition - _dragStartOffset;
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
            Positioned.fill(child: widget.builder(_handleDragStart, _handleDragUpdate)),
            Positioned(
              right: 0,
              bottom: 0,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeDownRight,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      final newW = (widget.windowData.size.width + details.delta.dx).clamp(420.0, 1400.0);
                      final newH = (widget.windowData.size.height + details.delta.dy).clamp(320.0, 950.0);
                      widget.windowData.size = Size(newW, newH);
                    });
                  },
                  child: Container(width: 14, height: 14, color: Colors.transparent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
