import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../common/os_window_frame.dart';
import '../../widgets/windows_desktop_icon_widget.dart';

/// Windows 폴더 브라우저 창 (폴더 내부 파일/앱 목록 표시 및 관리)
class WindowsFolderWindow extends StatefulWidget {
  final DesktopIconItem folder;
  final WindowStyle style;
  final String windowsVersion;
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(String templateId)? onOpenTemplate;
  final Function(String appId)? onOpenWinApp;
  final Function(DesktopIconItem subfolder)? onOpenFolder;
  final Function(DesktopIconItem item)? onMoveToDesktop;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;

  const WindowsFolderWindow({
    super.key,
    required this.folder,
    required this.style,
    required this.windowsVersion,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onOpenTemplate,
    this.onOpenWinApp,
    this.onOpenFolder,
    this.onMoveToDesktop,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 760,
    this.height = 500,
  });

  @override
  State<WindowsFolderWindow> createState() => _WindowsFolderWindowState();
}

class _WindowsFolderWindowState extends State<WindowsFolderWindow> {
  String _searchQuery = '';
  String? _selectedItemId;
  String? _renamingItemId;
  late TextEditingController _renameCtrl;
  late FocusNode _renameFocus;
  Offset? _contextMenuPos;
  DesktopIconItem? _contextMenuItem;

  @override
  void initState() {
    super.initState();
    _renameCtrl = TextEditingController();
    _renameFocus = FocusNode();
  }

  @override
  void dispose() {
    _renameCtrl.dispose();
    _renameFocus.dispose();
    super.dispose();
  }

  void _openItem(DesktopIconItem item) {
    if (item.isFolder) {
      widget.onOpenFolder?.call(item);
    } else if (item.templateId != null) {
      widget.onOpenTemplate?.call(item.templateId!);
    } else if (item.appId != null) {
      widget.onOpenWinApp?.call(item.appId!);
    } else {
      item.onTap();
    }
  }

  void _createNewTextFile() {
    final existingTitles = widget.folder.children.map((e) => e.title).toSet();
    String docTitle = '새 텍스트 문서.txt';
    if (existingTitles.contains(docTitle)) {
      int idx = 2;
      while (existingTitles.contains('새 텍스트 문서 ($idx).txt')) {
        idx++;
      }
      docTitle = '새 텍스트 문서 ($idx).txt';
    }

    final newDoc = DesktopIconItem(
      id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
      title: docTitle,
      icon: CupertinoIcons.doc_text_fill,
      iconColor: const Color(0xFF60A5FA),
      imageAsset: 'assets/images/windows/notepad.png',
      gridX: 0,
      gridY: 0,
      isSystemApp: false,
      isTextDoc: true,
      appId: 'notepad',
      onTap: () => widget.onOpenWinApp?.call('notepad'),
    );

    setState(() {
      widget.folder.children.add(newDoc);
      _selectedItemId = newDoc.id;
      _renamingItemId = newDoc.id;
      _renameCtrl.text = docTitle;
      _renameFocus.requestFocus();
    });
  }

  void _createNewSubfolder() {
    final existingTitles = widget.folder.children.map((e) => e.title).toSet();
    String folderTitle = '새 폴더';
    if (existingTitles.contains(folderTitle)) {
      int idx = 2;
      while (existingTitles.contains('새 폴더 ($idx)')) {
        idx++;
      }
      folderTitle = '새 폴더 ($idx)';
    }

    final newSub = DesktopIconItem(
      id: 'subfolder_${DateTime.now().millisecondsSinceEpoch}',
      title: folderTitle,
      imageAsset: 'assets/images/windows/folder.png',
      gridX: 0,
      gridY: 0,
      isSystemApp: false,
      isFolder: true,
      onTap: () {},
    );
    newSub.onTap = () => widget.onOpenFolder?.call(newSub);

    setState(() {
      widget.folder.children.add(newSub);
      _selectedItemId = newSub.id;
      _renamingItemId = newSub.id;
      _renameCtrl.text = folderTitle;
      _renameFocus.requestFocus();
    });
  }

  void _moveItemToDesktop(DesktopIconItem item) {
    widget.onMoveToDesktop?.call(item);
    setState(() {
      if (_selectedItemId == item.id) _selectedItemId = null;
    });
  }

  void _moveAllToDesktop() {
    final copy = List<DesktopIconItem>.from(widget.folder.children);
    for (final item in copy) {
      widget.onMoveToDesktop?.call(item);
    }
    setState(() {
      _selectedItemId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.windowsVersion == '11' || widget.windowsVersion == '10';
    final isWin7 = widget.windowsVersion == '7';

    final bgMain = isDark
        ? const Color(0xFF191B22)
        : (isWin7 ? const Color(0xFFF0F4F8) : const Color(0xFFFAFAFA));

    final filtered = widget.folder.children.where((item) {
      if (_searchQuery.isEmpty) return true;
      return item.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return OsWindowFrame(
      title: widget.folder.title,
      icon: CupertinoIcons.folder_fill,
      iconAsset: 'assets/images/windows/folder.png',
      style: widget.style,
      width: widget.width,
      height: widget.height,
      onClose: widget.onClose,
      onMinimize: widget.onMinimize,
      onMaximize: widget.onMaximize,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _selectedItemId = null;
            _contextMenuPos = null;
            _contextMenuItem = null;
            _renamingItemId = null;
          });
        },
        child: Container(
          color: bgMain,
          child: Column(
            children: [
              // 1. 주소창 & 검색창 (Address Bar & Search)
              _buildAddressBar(isDark),

              // 2. 명령 도구 모음 바 (Command Ribbon)
              _buildCommandBar(isDark),

              // 3. 메인 콘텐츠 영역 (파일/앱 그리드)
              Expanded(
                child: Stack(
                  children: [
                    filtered.isEmpty
                        ? _buildEmptyState(isDark)
                        : _buildFolderItemsGrid(filtered, isDark),

                    // 항목 우클릭 컨텍스트 메뉴
                    if (_contextMenuPos != null && _contextMenuItem != null)
                      Positioned(
                        left: _contextMenuPos!.dx.clamp(10.0, widget.width - 200),
                        top: _contextMenuPos!.dy.clamp(10.0, widget.height - 180),
                        child: _buildItemContextMenu(_contextMenuItem!, isDark),
                      ),
                  ],
                ),
              ),

              // 4. 하단 상태 표시줄
              _buildStatusBar(filtered.length, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressBar(bool isDark) {
    final barBg = isDark ? const Color(0xFF13141C) : Colors.white;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFD0D7DE);
    final textColor = isDark ? Colors.white : Colors.black87;

    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161822) : const Color(0xFFF3F4F6),
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          // 뒤로/앞으로/상위 버튼
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(CupertinoIcons.arrow_left, size: 14, color: isDark ? Colors.white70 : Colors.black54),
            ),
          ),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(CupertinoIcons.arrow_right, size: 14, color: isDark ? Colors.white30 : Colors.black26),
            ),
          ),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(CupertinoIcons.arrow_up, size: 14, color: isDark ? Colors.white70 : Colors.black54),
            ),
          ),
          const SizedBox(width: 8),

          // 주소 경로 바
          Expanded(
            child: Container(
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: barBg,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/windows/folder.png',
                    width: 15,
                    height: 15,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.folder, size: 15, color: Color(0xFFFBBF24)),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '내 PC',
                    style: TextStyle(color: textColor, fontSize: 11.5),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(CupertinoIcons.chevron_right, size: 10, color: Colors.grey),
                  ),
                  Text(
                    '바탕 화면',
                    style: TextStyle(color: textColor, fontSize: 11.5),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(CupertinoIcons.chevron_right, size: 10, color: Colors.grey),
                  ),
                  Text(
                    widget.folder.title,
                    style: TextStyle(color: textColor, fontSize: 11.5, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // 검색창
          Container(
            width: 180,
            height: 28,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: barBg,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.search, size: 13, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: TextStyle(color: textColor, fontSize: 11.5),
                    decoration: InputDecoration(
                      hintText: '${widget.folder.title} 검색',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 11),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () => setState(() => _searchQuery = ''),
                    child: const Icon(CupertinoIcons.clear_circled_solid, size: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandBar(bool isDark) {
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFD0D7DE);

    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1E2A) : const Color(0xFFF9FAFB),
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          // 1. 새 텍스트 문서
          _buildToolBtn(
            icon: CupertinoIcons.doc_text_fill,
            iconColor: const Color(0xFF60A5FA),
            label: '새 텍스트 문서',
            onTap: _createNewTextFile,
            isDark: isDark,
          ),
          const SizedBox(width: 4),

          // 2. 새 하위 폴더
          _buildToolBtn(
            icon: CupertinoIcons.folder_badge_plus,
            iconColor: const Color(0xFFFBBF24),
            label: '새 폴더',
            onTap: _createNewSubfolder,
            isDark: isDark,
          ),
          const SizedBox(width: 8),
          Container(width: 1, height: 18, color: borderColor),
          const SizedBox(width: 8),

          // 3. 선택 항목 바탕화면으로 꺼내기
          if (_selectedItemId != null) ...[
            _buildToolBtn(
              icon: CupertinoIcons.arrow_up_right_square_fill,
              iconColor: const Color(0xFF10B981),
              label: '바탕 화면으로 꺼내기',
              onTap: () {
                final item = widget.folder.children.firstWhere((c) => c.id == _selectedItemId);
                _moveItemToDesktop(item);
              },
              isDark: isDark,
            ),
            const SizedBox(width: 8),
            Container(width: 1, height: 18, color: borderColor),
            const SizedBox(width: 8),
          ],

          // 4. 모두 바탕화면으로 이동
          if (widget.folder.children.isNotEmpty)
            _buildToolBtn(
              icon: CupertinoIcons.arrow_turn_up_left,
              iconColor: const Color(0xFF8B5CF6),
              label: '모두 바탕화면으로 꺼내기',
              onTap: _moveAllToDesktop,
              isDark: isDark,
            ),

          const Spacer(),

          // 안내 뱃지
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.info_circle, size: 12, color: isDark ? Colors.white60 : Colors.black54),
                const SizedBox(width: 4),
                Text(
                  '바탕화면 아이콘을 폴더 위로 드래그하여 보관할 수 있습니다.',
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolBtn({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.04),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.folder,
              size: 38,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '이 폴더는 비어 있습니다.',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '바탕 화면에서 앱이나 파일 아이콘을 이 폴더 위로 드래그하면 여기에 보관됩니다.\n상단의 [+ 새 텍스트 문서] 버튼을 눌러 메모를 작성할 수도 있습니다.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.black54,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderItemsGrid(List<DesktopIconItem> items, bool isDark) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 96,
        mainAxisExtent: 104,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = _selectedItemId == item.id;
        final isRenaming = _renamingItemId == item.id;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedItemId = item.id;
              _contextMenuPos = null;
              _contextMenuItem = null;
              _renamingItemId = null;
            });
          },
          onDoubleTap: () => _openItem(item),
          onSecondaryTapUp: (details) {
            setState(() {
              _selectedItemId = item.id;
              _contextMenuItem = item;
              _contextMenuPos = details.localPosition;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark ? const Color(0x3DCCE8FF) : const Color(0x3D0078D7))
                  : Colors.transparent,
              border: Border.all(
                color: isSelected
                    ? (isDark ? const Color(0x9999D1FF) : const Color(0xFF0078D7))
                    : Colors.transparent,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 아이콘 본체
                SizedBox(
                  width: 44,
                  height: 44,
                  child: Center(
                    child: item.imageAsset != null
                        ? Image.asset(
                            item.imageAsset!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Icon(item.icon ?? Icons.insert_drive_file, color: item.iconColor, size: 36),
                          )
                        : Icon(
                            item.icon ?? Icons.insert_drive_file,
                            color: item.iconColor,
                            size: 36,
                          ),
                  ),
                ),
                const SizedBox(height: 6),

                // 라벨 또는 이름 변경 필드
                if (isRenaming)
                  Container(
                    height: 22,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E2028) : Colors.white,
                      border: Border.all(color: const Color(0xFF60A5FA), width: 1.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: TextField(
                      controller: _renameCtrl,
                      focusNode: _renameFocus,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 11),
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: (val) {
                        final trimmed = val.trim();
                        if (trimmed.isNotEmpty) {
                          setState(() {
                            item.title = trimmed;
                            _renamingItemId = null;
                          });
                        } else {
                          setState(() => _renamingItemId = null);
                        }
                      },
                    ),
                  )
                else
                  Text(
                    item.title,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 11,
                      height: 1.2,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemContextMenu(DesktopIconItem item, bool isDark) {
    final menuBg = isDark ? const Color(0xFF252733) : Colors.white;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.12) : const Color(0xFFD0D7DE);

    return Container(
      width: 170,
      decoration: BoxDecoration(
        color: menuBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 12, offset: Offset(2, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildContextMenuItem(
            icon: CupertinoIcons.play_arrow_solid,
            label: '열기',
            onTap: () {
              setState(() {
                _contextMenuPos = null;
                _contextMenuItem = null;
              });
              _openItem(item);
            },
            isDark: isDark,
          ),
          _buildContextMenuItem(
            icon: CupertinoIcons.arrow_up_right_square_fill,
            label: '바탕 화면으로 꺼내기',
            iconColor: const Color(0xFF10B981),
            onTap: () {
              setState(() {
                _contextMenuPos = null;
                _contextMenuItem = null;
              });
              _moveItemToDesktop(item);
            },
            isDark: isDark,
          ),
          _buildContextMenuItem(
            icon: CupertinoIcons.pencil,
            label: '이름 바꾸기',
            onTap: () {
              setState(() {
                _contextMenuPos = null;
                _contextMenuItem = null;
                _renamingItemId = item.id;
                _renameCtrl.text = item.title;
                _renameFocus.requestFocus();
              });
            },
            isDark: isDark,
          ),
          Divider(height: 1, color: borderColor),
          _buildContextMenuItem(
            icon: CupertinoIcons.trash,
            label: '삭제',
            iconColor: Colors.redAccent,
            onTap: () {
              setState(() {
                widget.folder.children.removeWhere((c) => c.id == item.id);
                _contextMenuPos = null;
                _contextMenuItem = null;
                if (_selectedItemId == item.id) _selectedItemId = null;
              });
            },
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildContextMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 14, color: iconColor ?? (isDark ? Colors.white70 : Colors.black54)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar(int count, bool isDark) {
    final barBg = isDark ? const Color(0xFF161822) : const Color(0xFFF3F4F6);
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFD0D7DE);
    final textColor = isDark ? Colors.white54 : Colors.black54;

    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: barBg,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          Text('$count개 항목', style: TextStyle(color: textColor, fontSize: 11)),
          if (_selectedItemId != null) ...[
            const SizedBox(width: 12),
            Text('|', style: TextStyle(color: textColor, fontSize: 11)),
            const SizedBox(width: 12),
            Text('1개 항목 선택됨', style: TextStyle(color: textColor, fontSize: 11)),
          ],
        ],
      ),
    );
  }
}
