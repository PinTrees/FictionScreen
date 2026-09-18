import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'apps/calculator/calculator_window.dart';
import 'apps/chrome/chrome_window.dart';
import 'apps/cmd/cmd_window.dart';
import 'apps/edge/edge_window.dart';
import 'apps/file_explorer/file_explorer_window.dart';
import 'apps/notepad/notepad_window.dart';
import 'apps/paint/paint_window.dart';
import 'apps/settings/settings_window.dart';
import 'widgets/windows_context_menu.dart';
import 'widgets/windows_quick_settings.dart';
import 'windows_start_menu.dart';
import 'windows_taskbar.dart';
import '../common/os_app_item.dart';

/// 바탕화면 격자 그리드 아이콘 데이터 모델
class DesktopIconItem {
  final String id;
  final String title;
  final IconData? icon;
  final String? imageAsset;
  final Color iconColor;
  int gridX; // 열 인덱스 (0, 1, 2, ...)
  int gridY; // 행 인덱스 (0, 1, 2, ...)
  final VoidCallback onTap;

  DesktopIconItem({
    required this.id,
    required this.title,
    this.icon,
    this.imageAsset,
    this.iconColor = const Color(0xFF60A5FA),
    required this.gridX,
    required this.gridY,
    required this.onTap,
  });
}

/// Windows MDI 가상 창 데이터 모델
class WindowsWindowData {
  final String id;
  final String appId;
  final ValueNotifier<Offset> positionNotifier;
  Size size;
  int zIndex;
  bool isMinimized;

  WindowsWindowData({
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

/// Windows 7 / 10 / 11 데스크톱 뷰 레이아웃 (그리드 정렬 아이콘 + 우클릭 컨텍스트 메뉴)
class WindowsView extends StatefulWidget {
  final String windowsVersion;
  final User? user;
  final String timeString;
  final String dateString;
  final String currentWallpaper;
  final bool isStartMenuOpen;
  final VoidCallback onToggleStartMenu;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;

  const WindowsView({
    super.key,
    this.windowsVersion = '10',
    required this.user,
    required this.timeString,
    required this.dateString,
    required this.currentWallpaper,
    required this.isStartMenuOpen,
    required this.onToggleStartMenu,
    required this.onOpenTemplate,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
  });

  @override
  State<WindowsView> createState() => _WindowsViewState();
}

class _WindowsViewState extends State<WindowsView> {
  final List<WindowsWindowData> _activeWindows = [];
  int _highestZIndex = 1;

  bool _isQuickSettingsOpen = false;
  Offset? _contextMenuPosition;

  // 바탕화면 그리드 규격
  static const double cellWidth = 92.0;
  static const double cellHeight = 100.0;
  static const double gridPaddingLeft = 20.0;
  static const double gridPaddingTop = 20.0;

  late List<DesktopIconItem> _desktopIcons;

  @override
  void initState() {
    super.initState();
    _initDesktopIcons();
  }

  void _initDesktopIcons() {
    _desktopIcons = [
      DesktopIconItem(
        id: 'pc',
        title: widget.windowsVersion == '7' ? '컴퓨터' : '내 PC',
        icon: CupertinoIcons.device_desktop,
        iconColor: const Color(0xFF60A5FA),
        gridX: 0,
        gridY: 0,
        onTap: () => _openWinApp('file_explorer'),
      ),
      DesktopIconItem(
        id: 'edge',
        title: 'Edge',
        icon: CupertinoIcons.globe,
        iconColor: const Color(0xFF0078D7),
        gridX: 0,
        gridY: 1,
        onTap: () => _openWinApp('edge'),
      ),
      DesktopIconItem(
        id: 'chrome',
        title: 'Chrome',
        icon: CupertinoIcons.globe,
        iconColor: const Color(0xFFEA4335),
        gridX: 0,
        gridY: 2,
        onTap: () => _openWinApp('chrome'),
      ),
      DesktopIconItem(
        id: 'kakaotalk',
        title: '카카오톡',
        imageAsset: 'assets/images/kakaotalk_icon.webp',
        gridX: 0,
        gridY: 3,
        onTap: () => widget.onOpenTemplate('kakaotalk'),
      ),
      DesktopIconItem(
        id: 'youtube',
        title: 'YouTube',
        icon: CupertinoIcons.play_arrow_solid,
        iconColor: const Color(0xFFFF0000),
        gridX: 0,
        gridY: 4,
        onTap: () => widget.onOpenTemplate('youtube'),
      ),
      DesktopIconItem(
        id: 'instagram',
        title: 'Instagram',
        imageAsset: 'assets/images/instagram_icon.webp',
        gridX: 1,
        gridY: 0,
        onTap: () => widget.onOpenTemplate('instagram'),
      ),
      DesktopIconItem(
        id: 'coupang',
        title: '쿠팡',
        imageAsset: 'assets/images/coupang_icon.webp',
        gridX: 1,
        gridY: 1,
        onTap: () => widget.onOpenTemplate('coupang'),
      ),
      DesktopIconItem(
        id: 'delivery',
        title: '배달의민족',
        icon: CupertinoIcons.bag_fill,
        iconColor: const Color(0xFF2AC1BC),
        gridX: 1,
        gridY: 2,
        onTap: () => widget.onOpenTemplate('delivery'),
      ),
      DesktopIconItem(
        id: 'bsod',
        title: '블루스크린',
        icon: CupertinoIcons.device_desktop,
        iconColor: const Color(0xFF0078D7),
        gridX: 1,
        gridY: 3,
        onTap: () => widget.onOpenTemplate('windows_bsod'),
      ),
      DesktopIconItem(
        id: 'win_update',
        title: '가짜 업데이트',
        icon: CupertinoIcons.arrow_clockwise,
        iconColor: const Color(0xFF60A5FA),
        gridX: 1,
        gridY: 4,
        onTap: () => widget.onOpenTemplate('windows_update'),
      ),
      DesktopIconItem(
        id: 'notepad',
        title: '메모장',
        icon: CupertinoIcons.doc_plaintext,
        iconColor: Colors.white70,
        gridX: 2,
        gridY: 0,
        onTap: () => _openWinApp('notepad'),
      ),
      DesktopIconItem(
        id: 'calculator',
        title: '계산기',
        icon: CupertinoIcons.number,
        iconColor: const Color(0xFF10B981),
        gridX: 2,
        gridY: 1,
        onTap: () => _openWinApp('calculator'),
      ),
      DesktopIconItem(
        id: 'paint',
        title: '그림판',
        icon: CupertinoIcons.paintbrush_fill,
        iconColor: const Color(0xFFF59E0B),
        gridX: 2,
        gridY: 2,
        onTap: () => _openWinApp('paint'),
      ),
      DesktopIconItem(
        id: 'settings',
        title: '설정',
        icon: CupertinoIcons.gear_alt_fill,
        iconColor: Colors.white70,
        gridX: 2,
        gridY: 3,
        onTap: () => _openWinApp('settings'),
      ),
      DesktopIconItem(
        id: 'trash',
        title: '휴지통',
        icon: CupertinoIcons.trash_fill,
        iconColor: Colors.white70,
        gridX: 2,
        gridY: 4,
        onTap: () {},
      ),
    ];
  }

  void _openWinApp(String appId) {
    final existingIndex = _activeWindows.indexWhere((w) => w.appId == appId);

    if (existingIndex != -1) {
      _bringToFront(_activeWindows[existingIndex].id);
    } else {
      _highestZIndex++;
      final count = _activeWindows.length;
      final initialPos = Offset(100.0 + (count * 28), 50.0 + (count * 22));
      Size defaultSize = const Size(760, 520);

      if (appId == 'calculator') {
        defaultSize = const Size(340, 480);
      } else if (appId == 'cmd' || appId == 'notepad') {
        defaultSize = const Size(680, 440);
      }

      final newWin = WindowsWindowData(
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

  /// 마우스 드롭 좌표를 격자 그리드(Snap-to-Grid)로 스냅 정렬
  void _snapIconToGrid(DesktopIconItem item, Offset globalPos) {
    final double relativeX = (globalPos.dx - gridPaddingLeft).clamp(0.0, 2000.0);
    final double relativeY = (globalPos.dy - gridPaddingTop).clamp(0.0, 1500.0);

    final int newGridX = (relativeX / cellWidth).round().clamp(0, 12);
    final int newGridY = (relativeY / cellHeight).round().clamp(0, 10);

    setState(() {
      item.gridX = newGridX;
      item.gridY = newGridY;
    });
  }

  void _sortIconsByName() {
    setState(() {
      _desktopIcons.sort((a, b) => a.title.compareTo(b.title));
      int col = 0;
      int row = 0;
      for (var icon in _desktopIcons) {
        icon.gridX = col;
        icon.gridY = row;
        row++;
        if (row >= 5) {
          row = 0;
          col++;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapUp: (details) {
        setState(() {
          _contextMenuPosition = details.globalPosition;
        });
      },
      onTap: () {
        if (_contextMenuPosition != null) {
          setState(() => _contextMenuPosition = null);
        }
      },
      child: Stack(
        children: [
          // 1. 배경화면 (WebP 이미지 또는 그라데이션)
          Positioned.fill(
            child: _buildWindowsWallpaper(),
          ),

          // 2. 바탕화면 격자 그리드 맞춤(Snap-to-Grid) 드래그 가능한 아이콘들
          ..._desktopIcons.map((item) {
            final double posX = gridPaddingLeft + (item.gridX * cellWidth);
            final double posY = gridPaddingTop + (item.gridY * cellHeight);

            return Positioned(
              left: posX,
              top: posY,
              child: _DraggableGridIcon(
                key: ValueKey(item.id),
                item: item,
                onDragEnd: (globalPos) => _snapIconToGrid(item, globalPos),
              ),
            );
          }),

          // 3. MDI 가상 Windows 윈도우 창 레이어 (120fps 부드러운 드래그 최적화)
          ..._activeWindows.map((win) {
            if (win.isMinimized) return const SizedBox.shrink();

            return ValueListenableBuilder<Offset>(
              valueListenable: win.positionNotifier,
              builder: (context, pos, child) {
                return Positioned(
                  left: pos.dx,
                  top: pos.dy,
                  child: _WindowsMdiWindowWrapper(
                    key: ValueKey(win.id),
                    windowData: win,
                    onTapFocus: () => _bringToFront(win.id),
                    onClose: () => _closeWindow(win.id),
                    builder: (onDragStart, onDragUpdate) => _buildWinAppContent(win, onDragStart, onDragUpdate),
                  ),
                );
              },
            );
          }),

          // 4. 시작 메뉴 팝업 (버전별 위치 및 UI 분기)
          if (widget.isStartMenuOpen)
            Positioned(
              bottom: widget.windowsVersion == '11' ? 60 : (widget.windowsVersion == '10' ? 44 : 42),
              left: 0,
              right: widget.windowsVersion == '11' ? 0 : null,
              child: widget.windowsVersion == '11'
                  ? Center(
                      child: WindowsStartMenu(
                        windowsVersion: widget.windowsVersion,
                        user: widget.user,
                        onOpenTemplate: widget.onOpenTemplate,
                        onOpenSettings: widget.onOpenSettings,
                        onSignOut: widget.onSignOut,
                        onGoHome: widget.onGoHome,
                      ),
                    )
                  : WindowsStartMenu(
                      windowsVersion: widget.windowsVersion,
                      user: widget.user,
                      onOpenTemplate: widget.onOpenTemplate,
                      onOpenSettings: widget.onOpenSettings,
                      onSignOut: widget.onSignOut,
                      onGoHome: widget.onGoHome,
                    ),
            ),

          // 5. 하단 작업표시줄
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: WindowsTaskbar(
              windowsVersion: widget.windowsVersion,
              user: widget.user,
              timeString: widget.timeString,
              dateString: widget.dateString,
              isStartMenuOpen: widget.isStartMenuOpen,
              onToggleStartMenu: widget.onToggleStartMenu,
              onToggleQuickSettings: () => setState(() => _isQuickSettingsOpen = !_isQuickSettingsOpen),
              onOpenTemplate: widget.onOpenTemplate,
              onOpenSettings: widget.onOpenSettings,
              onSignOut: widget.onSignOut,
              onGoHome: widget.onGoHome,
            ),
          ),

          // 6. Windows 11 빠른 설정 & 알림 센터 오버레이
          if (_isQuickSettingsOpen)
            Positioned.fill(
              child: WindowsQuickSettings(
                timeString: widget.timeString,
                dateString: widget.dateString,
                onClose: () => setState(() => _isQuickSettingsOpen = false),
                onOpenSettings: widget.onOpenSettings,
              ),
            ),

          // 7. Windows 스타일 우클릭 컨텍스트 드롭다운 메뉴
          if (_contextMenuPosition != null)
            WindowsContextMenu(
              position: _contextMenuPosition!,
              onRefresh: () => setState(() {}),
              onNewFolder: () {},
              onNewNote: () => _openWinApp('notepad'),
              onOpenSettings: widget.onOpenSettings,
              onClose: () => setState(() => _contextMenuPosition = null),
              onSort: (_) => _sortIconsByName(),
            ),
        ],
      ),
    );
  }

  Widget _buildWinAppContent(
    WindowsWindowData win,
    Function(DragStartDetails) onDragStart,
    Function(DragUpdateDetails) onDragUpdate,
  ) {
    switch (win.appId) {
      case 'file_explorer':
        return WindowsFileExplorerWindow(
          width: win.size.width,
          height: win.size.height,
          onClose: () => _closeWindow(win.id),
          onOpenTemplate: widget.onOpenTemplate,
          onTitleDragStart: onDragStart,
          onTitleDragUpdate: onDragUpdate,
        );
      case 'edge':
        return WindowsEdgeWindow(
          width: win.size.width,
          height: win.size.height,
          onClose: () => _closeWindow(win.id),
          onOpenTemplate: widget.onOpenTemplate,
          onTitleDragStart: onDragStart,
          onTitleDragUpdate: onDragUpdate,
        );
      case 'chrome':
        return WindowsChromeWindow(
          width: win.size.width,
          height: win.size.height,
          onClose: () => _closeWindow(win.id),
          onOpenTemplate: widget.onOpenTemplate,
          onTitleDragStart: onDragStart,
          onTitleDragUpdate: onDragUpdate,
        );
      case 'settings':
        return WindowsSettingsWindow(
          width: win.size.width,
          height: win.size.height,
          onClose: () => _closeWindow(win.id),
          onOpenSystemSettings: widget.onOpenSettings,
          onTitleDragStart: onDragStart,
          onTitleDragUpdate: onDragUpdate,
        );
      case 'calculator':
        return WindowsCalculatorWindow(
          width: win.size.width,
          height: win.size.height,
          onClose: () => _closeWindow(win.id),
          onTitleDragStart: onDragStart,
          onTitleDragUpdate: onDragUpdate,
        );
      case 'notepad':
        return WindowsNotepadWindow(
          width: win.size.width,
          height: win.size.height,
          onClose: () => _closeWindow(win.id),
          onTitleDragStart: onDragStart,
          onTitleDragUpdate: onDragUpdate,
        );
      case 'cmd':
        return WindowsCmdWindow(
          width: win.size.width,
          height: win.size.height,
          onClose: () => _closeWindow(win.id),
          onTitleDragStart: onDragStart,
          onTitleDragUpdate: onDragUpdate,
        );
      case 'paint':
        return WindowsPaintWindow(
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

  Widget _buildWindowsWallpaper() {
    if (widget.currentWallpaper == 'win10_hero') {
      return Image.asset(
        'assets/images/win10_hero.webp',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        filterQuality: FilterQuality.high,
      );
    } else if (widget.currentWallpaper == 'win11_bloom') {
      return Image.asset(
        'assets/images/win11_bloom.webp',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        filterQuality: FilterQuality.high,
      );
    } else if (widget.currentWallpaper == 'win7_harmony') {
      return Image.asset(
        'assets/images/win7_harmony.webp',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        filterQuality: FilterQuality.high,
      );
    }

    switch (widget.currentWallpaper) {
      case 'aurora':
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E1B4B), Color(0xFF701A75), Color(0xFF0F172A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      case 'minimal_dark':
        return Container(color: const Color(0xFF0C0E14));
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
      default:
        final defaultAsset = widget.windowsVersion == '11'
            ? 'assets/images/win11_bloom.webp'
            : (widget.windowsVersion == '7' ? 'assets/images/win7_harmony.webp' : 'assets/images/win10_hero.webp');
        return Image.asset(
          defaultAsset,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          filterQuality: FilterQuality.high,
        );
    }
  }
}

/// 그리드 상에서 드래그 및 착! 스냅 정렬되는 아이콘 위젯
class _DraggableGridIcon extends StatefulWidget {
  final DesktopIconItem item;
  final Function(Offset globalPos) onDragEnd;

  const _DraggableGridIcon({
    super.key,
    required this.item,
    required this.onDragEnd,
  });

  @override
  State<_DraggableGridIcon> createState() => _DraggableGridIconState();
}

class _DraggableGridIconState extends State<_DraggableGridIcon> {
  Offset? _dragPos;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          _dragPos = details.globalPosition;
        });
      },
      onPanUpdate: (details) {
        setState(() {
          _dragPos = details.globalPosition;
        });
      },
      onPanEnd: (details) {
        if (_dragPos != null) {
          widget.onDragEnd(_dragPos!);
          setState(() {
            _dragPos = null;
          });
        }
      },
      child: OsAppItem(
        title: widget.item.title,
        icon: widget.item.icon,
        imageAsset: widget.item.imageAsset,
        iconColor: widget.item.iconColor,
        onTap: widget.item.onTap,
      ),
    );
  }
}

/// Windows MDI 가상 창 래퍼 위젯
class _WindowsMdiWindowWrapper extends StatefulWidget {
  final WindowsWindowData windowData;
  final VoidCallback onTapFocus;
  final VoidCallback onClose;
  final Widget Function(
    Function(DragStartDetails) onDragStart,
    Function(DragUpdateDetails) onDragUpdate,
  ) builder;

  const _WindowsMdiWindowWrapper({
    super.key,
    required this.windowData,
    required this.onTapFocus,
    required this.onClose,
    required this.builder,
  });

  @override
  State<_WindowsMdiWindowWrapper> createState() => _WindowsMdiWindowWrapperState();
}

class _WindowsMdiWindowWrapperState extends State<_WindowsMdiWindowWrapper> {
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
            Positioned.fill(
              child: widget.builder(_handleDragStart, _handleDragUpdate),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onPanStart: (_) => widget.onTapFocus(),
                onPanUpdate: (details) {
                  setState(() {
                    final newWidth = (widget.windowData.size.width + details.delta.dx).clamp(320.0, 1400.0);
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
