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
import 'versions/win11/apps/calculator/win11_calculator_window.dart';
import 'versions/win11/apps/file_explorer/win11_file_explorer_window.dart';
import 'versions/win11/apps/notepad/win11_notepad_window.dart';
import 'versions/win11/apps/settings/win11_settings_window.dart';
import 'widgets/windows_context_menu.dart';
import 'widgets/windows_desktop_icon_widget.dart';
import 'widgets/windows_item_context_menu.dart';
import 'widgets/windows_quick_settings.dart';
import 'windows_start_menu.dart';
import 'windows_taskbar.dart';

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
  String? _wallpaperOverride;
  Offset? _contextMenuPosition;
  Offset? _itemContextMenuPosition;
  DesktopIconItem? _contextMenuItem;
  String? _selectedItemId;
  String? _renamingItemId;

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
        imageAsset: 'assets/images/windows/this_pc.png',
        gridX: 0,
        gridY: 0,
        isSystemApp: true,
        onTap: () => _openWinApp('file_explorer'),
      ),
      DesktopIconItem(
        id: 'edge',
        title: 'Edge',
        imageAsset: 'assets/images/windows/edge.png',
        gridX: 0,
        gridY: 1,
        isSystemApp: true,
        onTap: () => _openWinApp('edge'),
      ),
      DesktopIconItem(
        id: 'chrome',
        title: 'Chrome',
        imageAsset: 'assets/images/windows/chrome.png',
        gridX: 0,
        gridY: 2,
        isSystemApp: true,
        onTap: () => _openWinApp('chrome'),
      ),
      DesktopIconItem(
        id: 'folder_sample',
        title: '새 폴더',
        imageAsset: 'assets/images/windows/folder.png',
        gridX: 0,
        gridY: 3,
        isSystemApp: false,
        isFolder: true,
        onTap: () => _openWinApp('file_explorer'),
      ),
      DesktopIconItem(
        id: 'kakaotalk',
        title: '카카오톡',
        imageAsset: 'assets/images/kakaotalk_icon.webp',
        gridX: 0,
        gridY: 4,
        isSystemApp: true,
        onTap: () => widget.onOpenTemplate('kakaotalk'),
      ),
      DesktopIconItem(
        id: 'youtube',
        title: 'YouTube',
        icon: CupertinoIcons.play_arrow_solid,
        iconColor: const Color(0xFFFF0000),
        gridX: 1,
        gridY: 0,
        isSystemApp: true,
        onTap: () => widget.onOpenTemplate('youtube'),
      ),
      DesktopIconItem(
        id: 'instagram',
        title: 'Instagram',
        imageAsset: 'assets/images/instagram_icon.webp',
        gridX: 1,
        gridY: 1,
        isSystemApp: true,
        onTap: () => widget.onOpenTemplate('instagram'),
      ),
      DesktopIconItem(
        id: 'coupang',
        title: '쿠팡',
        imageAsset: 'assets/images/coupang_icon.webp',
        gridX: 1,
        gridY: 2,
        isSystemApp: true,
        onTap: () => widget.onOpenTemplate('coupang'),
      ),
      DesktopIconItem(
        id: 'netflix',
        title: 'Netflix',
        imageAsset: 'assets/images/netflix_icon.webp',
        gridX: 1,
        gridY: 3,
        isSystemApp: true,
        onTap: () => widget.onOpenTemplate('netflix'),
      ),
      DesktopIconItem(
        id: 'delivery',
        title: '배달의민족',
        icon: CupertinoIcons.bag_fill,
        iconColor: const Color(0xFF2AC1BC),
        gridX: 1,
        gridY: 4,
        isSystemApp: true,
        onTap: () => widget.onOpenTemplate('delivery'),
      ),
      DesktopIconItem(
        id: 'notepad',
        title: '메모장',
        imageAsset: 'assets/images/windows/notepad.png',
        gridX: 2,
        gridY: 0,
        isSystemApp: true,
        onTap: () => _openWinApp('notepad'),
      ),
      DesktopIconItem(
        id: 'calculator',
        title: '계산기',
        imageAsset: 'assets/images/windows/calc.png',
        gridX: 2,
        gridY: 1,
        isSystemApp: true,
        onTap: () => _openWinApp('calculator'),
      ),
      DesktopIconItem(
        id: 'paint',
        title: '그림판',
        imageAsset: 'assets/images/windows/mspaint.png',
        gridX: 2,
        gridY: 2,
        isSystemApp: true,
        onTap: () => _openWinApp('paint'),
      ),
      DesktopIconItem(
        id: 'settings',
        title: '설정',
        imageAsset: 'assets/images/windows/settings.png',
        gridX: 2,
        gridY: 3,
        isSystemApp: true,
        onTap: () => _openWinApp('settings'),
      ),
      DesktopIconItem(
        id: 'cmd',
        title: '명령 프롬프트',
        imageAsset: 'assets/images/windows/cmd.png',
        gridX: 2,
        gridY: 4,
        isSystemApp: true,
        onTap: () => _openWinApp('cmd'),
      ),
      DesktopIconItem(
        id: 'trash',
        title: '휴지통',
        imageAsset: 'assets/images/windows/recycle_bin.png',
        gridX: 3,
        gridY: 0,
        isSystemApp: true,
        onTap: () {},
      ),
      DesktopIconItem(
        id: 'lottery',
        title: '동행복권',
        imageAsset: 'assets/images/lottery_icon.webp',
        gridX: 3,
        gridY: 1,
        isSystemApp: true,
        onTap: () => widget.onOpenTemplate('lottery'),
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

      if (widget.windowsVersion == '11') {
        if (appId == 'file_explorer') {
          defaultSize = const Size(860, 560);
        } else if (appId == 'settings') {
          defaultSize = const Size(880, 580);
        } else if (appId == 'notepad') {
          defaultSize = const Size(720, 480);
        } else if (appId == 'calculator') {
          defaultSize = const Size(340, 520);
        }
      } else {
        if (appId == 'calculator') {
          defaultSize = const Size(340, 480);
        } else if (appId == 'cmd' || appId == 'notepad') {
          defaultSize = const Size(680, 440);
        }
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

  void _minimizeWindow(String windowId) {
    setState(() {
      final win = _activeWindows.firstWhere((w) => w.id == windowId);
      win.isMinimized = true;
    });
  }

  void _toggleMaximizeWindow(WindowsWindowData win) {
    final media = MediaQuery.of(context).size;
    final totalW = media.width;
    final totalH = media.height - 48;

    setState(() {
      if (win.size.width >= totalW - 10 && win.size.height >= totalH - 10) {
        win.position = const Offset(120, 70);
        win.size = const Size(820, 540);
      } else {
        win.position = Offset.zero;
        win.size = Size(totalW, totalH);
      }
      _bringToFront(win.id);
    });
  }

  void _snapWindow(WindowsWindowData win, int layoutType, int zoneIndex) {
    final media = MediaQuery.of(context).size;
    final totalW = media.width;
    final totalH = media.height - 48;

    double newX = 0;
    double newY = 0;
    double newW = totalW;
    double newH = totalH;

    switch (layoutType) {
      case 0:
        newW = totalW * 0.5;
        newH = totalH;
        newX = zoneIndex == 0 ? 0 : totalW * 0.5;
        newY = 0;
        break;
      case 1:
        if (zoneIndex == 0) {
          newW = totalW * 0.67;
          newX = 0;
        } else {
          newW = totalW * 0.33;
          newX = totalW * 0.67;
        }
        newH = totalH;
        newY = 0;
        break;
      case 2:
        if (zoneIndex == 0) {
          newW = totalW * 0.5;
          newH = totalH;
          newX = 0;
          newY = 0;
        } else if (zoneIndex == 1) {
          newW = totalW * 0.5;
          newH = totalH * 0.5;
          newX = totalW * 0.5;
          newY = 0;
        } else {
          newW = totalW * 0.5;
          newH = totalH * 0.5;
          newX = totalW * 0.5;
          newY = totalH * 0.5;
        }
        break;
      case 3:
        newW = totalW * 0.5;
        newH = totalH * 0.5;
        newX = (zoneIndex == 0 || zoneIndex == 2) ? 0 : totalW * 0.5;
        newY = (zoneIndex == 0 || zoneIndex == 1) ? 0 : totalH * 0.5;
        break;
    }

    setState(() {
      win.position = Offset(newX, newY);
      win.size = Size(newW, newH);
      _bringToFront(win.id);
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

  /// 마우스 드래그 완료 시 격자 그리드(Snap-to-Grid)로 스냅 정렬
  void _onIconDragEnd(DesktopIconItem item, Offset totalDelta) {
    final double currentX = gridPaddingLeft + (item.gridX * cellWidth);
    final double currentY = gridPaddingTop + (item.gridY * cellHeight);
    final double droppedX = currentX + totalDelta.dx;
    final double droppedY = currentY + totalDelta.dy;

    final double relativeX = (droppedX - gridPaddingLeft).clamp(0.0, 2000.0);
    final double relativeY = (droppedY - gridPaddingTop).clamp(0.0, 1500.0);

    final int newGridX = (relativeX / cellWidth).round().clamp(0, 15);
    final int newGridY = (relativeY / cellHeight).round().clamp(0, 8);

    setState(() {
      item.gridX = newGridX;
      item.gridY = newGridY;
    });
  }

  /// 바탕화면 우클릭 -> '새로 만들기' -> 새 폴더 생성 및 즉시 이름 변경 모드 활성화
  void _handleCreateNewFolder() {
    final existingTitles = _desktopIcons.map((e) => e.title).toSet();
    String folderTitle = '새 폴더';
    if (existingTitles.contains(folderTitle)) {
      int index = 2;
      while (existingTitles.contains('새 폴더 ($index)')) {
        index++;
      }
      folderTitle = '새 폴더 ($index)';
    }

    final occupiedPositions = _desktopIcons.map((e) => '${e.gridX}_${e.gridY}').toSet();
    int newGridX = 0;
    int newGridY = 0;
    bool found = false;

    for (int col = 0; col < 15; col++) {
      for (int row = 0; row < 7; row++) {
        if (!occupiedPositions.contains('${col}_$row')) {
          newGridX = col;
          newGridY = row;
          found = true;
          break;
        }
      }
      if (found) break;
    }

    final newFolderId = 'folder_${DateTime.now().millisecondsSinceEpoch}';
    final newFolder = DesktopIconItem(
      id: newFolderId,
      title: folderTitle,
      imageAsset: 'assets/images/windows/folder.png',
      gridX: newGridX,
      gridY: newGridY,
      isSystemApp: false,
      isFolder: true,
      onTap: () => _openWinApp('file_explorer'),
    );

    setState(() {
      _desktopIcons.add(newFolder);
      _selectedItemId = newFolderId;
      _renamingItemId = newFolderId;
      _contextMenuPosition = null;
      _itemContextMenuPosition = null;
      _contextMenuItem = null;
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
          _itemContextMenuPosition = null;
          _contextMenuItem = null;
          _contextMenuPosition = details.globalPosition;
        });
      },
      onTap: () {
        setState(() {
          _contextMenuPosition = null;
          _itemContextMenuPosition = null;
          _contextMenuItem = null;
          _selectedItemId = null;
          _renamingItemId = null;
        });
      },
      child: Stack(
        children: [
          // 1. 배경화면 (WebP 이미지 또는 그라데이션)
          Positioned.fill(
            child: _buildWindowsWallpaper(),
          ),

          // 2. 바탕화면 격자 그리드 맞춤 투명 Windows 아이콘들 (마우스 추적 120fps 부드러운 드래그)
          ..._desktopIcons.map((item) {
            final double posX = gridPaddingLeft + (item.gridX * cellWidth);
            final double posY = gridPaddingTop + (item.gridY * cellHeight);

            return Positioned(
              left: posX,
              top: posY,
              child: WindowsDesktopIconWidget(
                key: ValueKey(item.id),
                item: item,
                isSelected: _selectedItemId == item.id,
                isRenaming: _renamingItemId == item.id,
                onTap: () {
                  setState(() {
                    _contextMenuPosition = null;
                    _itemContextMenuPosition = null;
                    _contextMenuItem = null;
                    _selectedItemId = item.id;
                    _renamingItemId = null;
                  });
                },
                onDoubleTap: () {
                  setState(() {
                    _contextMenuPosition = null;
                    _itemContextMenuPosition = null;
                    _contextMenuItem = null;
                  });
                  item.onTap();
                },
                onSecondaryTapUp: (details) {
                  setState(() {
                    _contextMenuPosition = null;
                    _selectedItemId = item.id;
                    _contextMenuItem = item;
                    _itemContextMenuPosition = details.globalPosition;
                  });
                },
                onRenameSubmitted: (newName) {
                  setState(() {
                    item.title = newName;
                    _renamingItemId = null;
                  });
                },
                onCancelRename: () {
                  setState(() {
                    _renamingItemId = null;
                  });
                },
                onDragEnd: (totalDelta) => _onIconDragEnd(item, totalDelta),
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

          // 7. Windows 스타일 바탕화면 우클릭 컨텍스트 드롭다운 메뉴
          if (_contextMenuPosition != null)
            WindowsContextMenu(
              position: _contextMenuPosition!,
              onRefresh: () => setState(() {}),
              onNewFolder: _handleCreateNewFolder,
              onNewNote: () => _openWinApp('notepad'),
              onOpenSettings: widget.onOpenSettings,
              onClose: () => setState(() => _contextMenuPosition = null),
              onSort: (_) => _sortIconsByName(),
            ),

          // 8. 개별 아이콘 우클릭 컨텍스트 메뉴 (열기, 이름 바꾸기, 삭제)
          if (_itemContextMenuPosition != null && _contextMenuItem != null)
            WindowsItemContextMenu(
              position: _itemContextMenuPosition!,
              item: _contextMenuItem!,
              onOpen: () => _contextMenuItem!.onTap(),
              onRename: () {
                setState(() {
                  _renamingItemId = _contextMenuItem!.id;
                  _selectedItemId = _contextMenuItem!.id;
                });
              },
              onDelete: () {
                setState(() {
                  _desktopIcons.removeWhere((i) => i.id == _contextMenuItem!.id);
                  if (_selectedItemId == _contextMenuItem!.id) {
                    _selectedItemId = null;
                  }
                  if (_renamingItemId == _contextMenuItem!.id) {
                    _renamingItemId = null;
                  }
                });
              },
              onClose: () => setState(() {
                _itemContextMenuPosition = null;
                _contextMenuItem = null;
              }),
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
        if (widget.windowsVersion == '11') {
          return Win11FileExplorerWindow(
            width: win.size.width,
            height: win.size.height,
            onClose: () => _closeWindow(win.id),
            onMinimize: () => _minimizeWindow(win.id),
            onMaximize: () => _toggleMaximizeWindow(win),
            onSnapLayout: (layout, zone) => _snapWindow(win, layout, zone),
            onOpenTemplate: widget.onOpenTemplate,
            onTitleDragStart: onDragStart,
            onTitleDragUpdate: onDragUpdate,
          );
        }
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
        if (widget.windowsVersion == '11') {
          return Win11SettingsWindow(
            width: win.size.width,
            height: win.size.height,
            onClose: () => _closeWindow(win.id),
            onMinimize: () => _minimizeWindow(win.id),
            onMaximize: () => _toggleMaximizeWindow(win),
            onSnapLayout: (layout, zone) => _snapWindow(win, layout, zone),
            onOpenSystemSettings: widget.onOpenSettings,
            onTitleDragStart: onDragStart,
            onTitleDragUpdate: onDragUpdate,
            currentWallpaper: _wallpaperOverride ?? widget.currentWallpaper,
            onSelectWallpaper: (key) => setState(() => _wallpaperOverride = key),
          );
        }
        return WindowsSettingsWindow(
          width: win.size.width,
          height: win.size.height,
          onClose: () => _closeWindow(win.id),
          onOpenSystemSettings: widget.onOpenSettings,
          onTitleDragStart: onDragStart,
          onTitleDragUpdate: onDragUpdate,
        );
      case 'calculator':
        if (widget.windowsVersion == '11') {
          return Win11CalculatorWindow(
            width: win.size.width,
            height: win.size.height,
            onClose: () => _closeWindow(win.id),
            onMinimize: () => _minimizeWindow(win.id),
            onMaximize: () => _toggleMaximizeWindow(win),
            onSnapLayout: (layout, zone) => _snapWindow(win, layout, zone),
            onTitleDragStart: onDragStart,
            onTitleDragUpdate: onDragUpdate,
          );
        }
        return WindowsCalculatorWindow(
          width: win.size.width,
          height: win.size.height,
          onClose: () => _closeWindow(win.id),
          onTitleDragStart: onDragStart,
          onTitleDragUpdate: onDragUpdate,
        );
      case 'notepad':
        if (widget.windowsVersion == '11') {
          return Win11NotepadWindow(
            width: win.size.width,
            height: win.size.height,
            onClose: () => _closeWindow(win.id),
            onMinimize: () => _minimizeWindow(win.id),
            onMaximize: () => _toggleMaximizeWindow(win),
            onSnapLayout: (layout, zone) => _snapWindow(win, layout, zone),
            onTitleDragStart: onDragStart,
            onTitleDragUpdate: onDragUpdate,
          );
        }
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
    final activeWallpaper = _wallpaperOverride ?? widget.currentWallpaper;

    if (activeWallpaper == 'win10_hero') {
      return Image.asset(
        'assets/images/win10_hero.webp',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        filterQuality: FilterQuality.high,
      );
    } else if (activeWallpaper == 'win11_bloom') {
      return Image.asset(
        'assets/images/win11_bloom.webp',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        filterQuality: FilterQuality.high,
      );
    } else if (activeWallpaper == 'win11_dark') {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/win11_bloom.webp',
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
          Container(color: Colors.black.withValues(alpha: 0.65)),
        ],
      );
    } else if (activeWallpaper == 'glow') {
      return Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.2, -0.3),
            radius: 1.2,
            colors: [Color(0xFF3B1F70), Color(0xFF13092C), Color(0xFF070212)],
          ),
        ),
      );
    } else if (activeWallpaper == 'flow') {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F3E50), Color(0xFF13678A), Color(0xFF012030)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      );
    } else if (activeWallpaper == 'sunrise') {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8B2635), Color(0xFF531253), Color(0xFF1A0A2A)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
      );
    } else if (activeWallpaper == 'win7_harmony') {
      return Image.asset(
        'assets/images/win7_harmony.webp',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        filterQuality: FilterQuality.high,
      );
    }

    switch (activeWallpaper) {
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
