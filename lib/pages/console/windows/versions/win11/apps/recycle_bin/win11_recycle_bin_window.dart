import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/win11_window_frame.dart';

/// Windows 11 순정 휴지동(Recycle Bin) 창 위젯
class Win11RecycleBinWindow extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(int layoutType, int zoneIndex)? onSnapLayout;
  final Function(String templateId)? onOpenTemplate;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;
  final bool isMaximized;

  const Win11RecycleBinWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onSnapLayout,
    this.onOpenTemplate,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 860,
    this.height = 560,
    this.isMaximized = false,
  });

  @override
  State<Win11RecycleBinWindow> createState() => _Win11RecycleBinWindowState();
}

class _Win11RecycleBinWindowState extends State<Win11RecycleBinWindow> {
  String _searchQuery = '';
  final Set<String> _selectedIds = {};
  String? _statusMessage;

  // 휴지동 내부 삭제된 파일 목록
  final List<Map<String, dynamic>> _deletedItems = [
    {
      'id': 'del_1',
      'name': '기획서_최종_수정본.docx',
      'originalLocation': r'C:\Users\Admin\Documents',
      'dateDeleted': '2026-09-18 14:22',
      'size': '48 KB',
      'type': 'Microsoft Word 문서',
      'icon': 'assets/images/windows/docs.png',
    },
    {
      'id': 'del_2',
      'name': '아이디어_스케치_v2.png',
      'originalLocation': r'C:\Users\Admin\Pictures',
      'dateDeleted': '2026-09-18 11:05',
      'size': '1.4 MB',
      'type': 'PNG 이미지',
      'icon': 'assets/images/windows/pics.png',
    },
    {
      'id': 'del_3',
      'name': '회의록_임시메모_백업.txt',
      'originalLocation': r'C:\Users\Admin\Desktop',
      'dateDeleted': '2026-09-17 17:30',
      'size': '12 KB',
      'type': '텍스트 문서',
      'icon': 'assets/images/windows/notepad.png',
    },
    {
      'id': 'del_4',
      'name': '레퍼런스_시안_클립.mp4',
      'originalLocation': r'C:\Users\Admin\Downloads',
      'dateDeleted': '2026-09-15 09:40',
      'size': '128 MB',
      'type': 'MP4 비디오',
      'icon': 'assets/images/windows/vid.png',
    },
  ];

  void _emptyRecycleBin() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF262B37),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
        ),
        title: const Row(
          children: [
            Icon(CupertinoIcons.trash, color: Color(0xFFEF4444), size: 20),
            SizedBox(width: 8),
            Text('휴지동 비우기', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          '휴지동에 있는 모든 항목을 영구적으로 삭제하시겠습니까?',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소', style: TextStyle(color: Colors.white54, fontSize: 12)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _deletedItems.clear();
                _selectedIds.clear();
                _statusMessage = '휴지동이 완전히 비워졌습니다.';
              });
            },
            child: const Text('휴지동 비우기', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _restoreSelected() {
    if (_selectedIds.isEmpty) return;
    final count = _selectedIds.length;
    setState(() {
      _deletedItems.removeWhere((item) => _selectedIds.contains(item['id']));
      _selectedIds.clear();
      _statusMessage = '$count개 항목이 원래 위치로 복원되었습니다.';
    });
  }

  void _restoreAll() {
    if (_deletedItems.isEmpty) return;
    final count = _deletedItems.length;
    setState(() {
      _deletedItems.clear();
      _selectedIds.clear();
      _statusMessage = '모든 항목($count개)이 원래 위치로 복원되었습니다.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _deletedItems.where((item) {
      final name = item['name'] as String;
      return name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Win11WindowFrame(
      title: '휴지동',
      iconAsset: _deletedItems.isEmpty
          ? 'assets/images/windows/bin-em.png'
          : 'assets/images/windows/recycle_bin.png',
      width: widget.width,
      height: widget.height,
      isMaximized: widget.isMaximized,
      onClose: widget.onClose,
      onMinimize: widget.onMinimize,
      onMaximize: widget.onMaximize,
      onSnapLayout: widget.onSnapLayout,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Column(
        children: [
          // 1. Windows 11 휴지동 도구 모음 (Ribbon Command Bar)
          _buildCommandRibbon(),

          // 2. 주소창 & 휴지동 검색창
          _buildAddressAndSearchBar(),

          // 3. 메인 분할 뷰 (사이드바 + 파일 목록)
          Expanded(
            child: Row(
              children: [
                // 좌측 탐색 사이드바
                Container(
                  width: 190,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.02),
                    border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.07))),
                  ),
                  child: _buildSidebar(),
                ),

                // 우측 삭제된 항목 목록
                Expanded(
                  child: Container(
                    color: const Color(0xFF191B22).withValues(alpha: 0.85),
                    child: filteredItems.isEmpty
                        ? _buildEmptyState()
                        : _buildItemsTable(filteredItems),
                  ),
                ),
              ],
            ),
          ),

          // 4. 하단 상태 표시줄
          _buildStatusBar(filteredItems.length),
        ],
      ),
    );
  }

  // Windows 11 상단 명령 모음 (휴지동 비우기, 모든 항목 복원, 선택한 항목 복원)
  Widget _buildCommandRibbon() {
    final bool hasItems = _deletedItems.isNotEmpty;
    final bool hasSelected = _selectedIds.isNotEmpty;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF242731).withValues(alpha: 0.7),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
      ),
      child: Row(
        children: [
          // 휴지동 비우기
          _buildRibbonButton(
            icon: CupertinoIcons.trash,
            label: '휴지동 비우기',
            color: hasItems ? const Color(0xFFEF4444) : Colors.white38,
            enabled: hasItems,
            onTap: _emptyRecycleBin,
          ),
          const SizedBox(width: 6),

          // 모든 항목 복원
          _buildRibbonButton(
            icon: CupertinoIcons.arrow_counterclockwise,
            label: '모든 항목 복원',
            color: hasItems ? const Color(0xFF60CDFF) : Colors.white38,
            enabled: hasItems,
            onTap: _restoreAll,
          ),
          const SizedBox(width: 6),

          // 선택한 항목 복원
          if (hasSelected) ...[
            _buildRibbonButton(
              icon: CupertinoIcons.arrow_turn_up_left,
              label: '선택한 항목 복원 (${_selectedIds.length})',
              color: const Color(0xFF10B981),
              enabled: true,
              onTap: _restoreSelected,
            ),
            const SizedBox(width: 6),
          ],

          const VerticalDivider(color: Colors.white12, indent: 12, endIndent: 12),
          const SizedBox(width: 6),

          // 보기 / 정렬
          _buildRibbonButton(
            icon: CupertinoIcons.list_bullet,
            label: '자세히',
            color: Colors.white70,
            enabled: true,
            onTap: () {},
          ),

          if (_statusMessage != null) ...[
            const Spacer(),
            Text(
              _statusMessage!,
              style: const TextStyle(color: Color(0xFF60CDFF), fontSize: 11, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }

  Widget _buildRibbonButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(4),
      hoverColor: Colors.white.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: enabled ? Colors.white : Colors.white38,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 주소 표시줄 & 검색창
  Widget _buildAddressAndSearchBar() {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.015),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(CupertinoIcons.arrow_left, size: 14, color: Colors.white30),
            onPressed: null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.arrow_right, size: 14, color: Colors.white30),
            onPressed: null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.arrow_up, size: 14, color: Colors.white70),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
          ),
          const SizedBox(width: 6),

          Expanded(
            flex: 3,
            child: Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                children: [
                  Image.asset(
                    _deletedItems.isEmpty ? 'assets/images/windows/bin-em.png' : 'assets/images/windows/recycle_bin.png',
                    width: 16,
                    height: 16,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 8),
                  const Text('휴지통', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          Expanded(
            flex: 2,
            child: Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.search, size: 13, color: Colors.white54),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val.trim()),
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                      decoration: const InputDecoration(
                        hintText: '휴지통 검색',
                        hintStyle: TextStyle(color: Colors.white38, fontSize: 11),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 좌측 사이드바
  Widget _buildSidebar() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      children: [
        _buildSidebarItem('홈', CupertinoIcons.house_fill, const Color(0xFF60CDFF), false),
        _buildSidebarItem('바탕 화면', CupertinoIcons.desktopcomputer, Colors.white70, false),
        _buildSidebarItem('다운로드', CupertinoIcons.arrow_down_circle_fill, const Color(0xFF38BDF8), false),
        _buildSidebarItem('문서', CupertinoIcons.doc_text_fill, const Color(0xFFF59E0B), false),
        _buildSidebarItem('사진', CupertinoIcons.photo_fill, const Color(0xFF10B981), false),
        const Divider(color: Colors.white10, height: 16),
        _buildSidebarItem('내 PC', CupertinoIcons.device_desktop, Colors.white70, false),
        _buildSidebarItem(
          '휴지통',
          null,
          const Color(0xFF60CDFF),
          true,
          imageAsset: _deletedItems.isEmpty ? 'assets/images/windows/bin-em.png' : 'assets/images/windows/recycle_bin.png',
        ),
      ],
    );
  }

  Widget _buildSidebarItem(String title, IconData? icon, Color color, bool isSelected, {String? imageAsset}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(4),
        hoverColor: Colors.white.withValues(alpha: 0.06),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            children: [
              if (imageAsset != null)
                Image.asset(imageAsset, width: 16, height: 16, fit: BoxFit.contain)
              else if (icon != null)
                Icon(icon, size: 15, color: color),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 삭제된 파일 테이블 뷰
  Widget _buildItemsTable(List<Map<String, dynamic>> items) {
    return Column(
      children: [
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                child: Checkbox(
                  value: _selectedIds.length == items.length && items.isNotEmpty,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedIds.addAll(items.map((e) => e['id'] as String));
                      } else {
                        _selectedIds.clear();
                      }
                    });
                  },
                  activeColor: const Color(0xFF60CDFF),
                  checkColor: Colors.black,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(flex: 3, child: Text('이름', style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.bold))),
              const Expanded(flex: 3, child: Text('원래 위치', style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.bold))),
              const Expanded(flex: 2, child: Text('삭제된 날짜', style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.bold))),
              const Expanded(flex: 1, child: Text('크기', style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.bold))),
              const Expanded(flex: 2, child: Text('항목 유형', style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.bold))),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final id = item['id'] as String;
              final isSelected = _selectedIds.contains(id);

              return InkWell(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedIds.remove(id);
                    } else {
                      _selectedIds.add(id);
                    }
                  });
                },
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white.withValues(alpha: 0.09) : Colors.transparent,
                    border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.03))),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedIds.add(id);
                              } else {
                                _selectedIds.remove(id);
                              }
                            });
                          },
                          activeColor: const Color(0xFF60CDFF),
                          checkColor: Colors.black,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: 8),

                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Image.asset(item['icon'] as String, width: 18, height: 18, fit: BoxFit.contain),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item['name'] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        flex: 3,
                        child: Text(
                          item['originalLocation'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white54, fontSize: 11),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Text(
                          item['dateDeleted'] as String,
                          style: const TextStyle(color: Colors.white54, fontSize: 11),
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: Text(
                          item['size'] as String,
                          style: const TextStyle(color: Colors.white54, fontSize: 11),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Text(
                          item['type'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white54, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 빈 휴지동 상태 화면
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/windows/bin-em.png',
            width: 72,
            height: 72,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          const Text(
            '이 폴더는 비어 있습니다.',
            style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text(
            '삭제한 파일이나 폴더가 여기에 표시됩니다.',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // 하단 상태 표시줄
  Widget _buildStatusBar(int filteredCount) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
      ),
      child: Row(
        children: [
          Text(
            '$filteredCount개 항목',
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
          if (_selectedIds.isNotEmpty) ...[
            const SizedBox(width: 14),
            Text(
              '${_selectedIds.length}개 항목 선택됨',
              style: const TextStyle(color: Color(0xFF60CDFF), fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ],
        ],
      ),
    );
  }
}
