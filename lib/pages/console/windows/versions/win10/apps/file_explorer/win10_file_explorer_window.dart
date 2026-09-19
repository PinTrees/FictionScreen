import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/win10_window_frame.dart';

/// Windows 10 순정 파일 탐색기 (File Explorer) - 리본 메뉴, 각진 0px 디자인, 클래식 주소창
class Win10FileExplorerWindow extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(String templateId)? onOpenTemplate;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;
  final bool isMaximized;

  const Win10FileExplorerWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onOpenTemplate,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 860,
    this.height = 560,
    this.isMaximized = false,
  });

  @override
  State<Win10FileExplorerWindow> createState() => _Win10FileExplorerWindowState();
}

class _Win10FileExplorerWindowState extends State<Win10FileExplorerWindow> {
  int _activeRibbonTab = 1; // 0: 파일, 1: 홈, 2: 공유, 3: 보기
  String _currentPath = '내 PC';
  String _searchQuery = '';
  String? _selectedFileTitle;

  // 6대 표준 라이브러리 폴더 (Windows 10 순정 노란색 폴더)
  final List<Map<String, dynamic>> _folders = [
    {'title': '3D 개체', 'icon': CupertinoIcons.cube_box_fill, 'color': Color(0xFF0078D7)},
    {'title': '다운로드', 'icon': CupertinoIcons.arrow_down_circle_fill, 'color': Color(0xFF10B981)},
    {'title': '동영상', 'icon': CupertinoIcons.film_fill, 'color': Color(0xFF8B5CF6)},
    {'title': '문서', 'icon': CupertinoIcons.doc_text_fill, 'color': Color(0xFFF59E0B)},
    {'title': '바탕 화면', 'icon': CupertinoIcons.desktopcomputer, 'color': Color(0xFF0078D7)},
    {'title': '사진', 'icon': CupertinoIcons.photo_fill, 'color': Color(0xFFEC4899)},
    {'title': '음악', 'icon': CupertinoIcons.music_note_2, 'color': Color(0xFFEF4444)},
  ];

  // 최근 사용한 파일 목록
  final List<Map<String, dynamic>> _recentFiles = [
    {'title': '다빈치리졸브_색보정프로젝트.drp', 'date': '오늘 19:40', 'type': 'DaVinci Resolve 프로젝트', 'size': '1.2 GB', 'app': 'davinci_resolve', 'icon': CupertinoIcons.videocam_circle_fill, 'color': Color(0xFFE53935)},
    {'title': 'FictionScreen_Core.sln', 'date': '오늘 18:55', 'type': 'Visual Studio 솔루션', 'size': '512 MB', 'app': 'visual_studio', 'icon': CupertinoIcons.chevron_left_slash_chevron_right, 'color': Color(0xFF68217A)},
    {'title': '포토샵_포스터_디자인.psd', 'date': '오늘 18:30', 'type': 'Photoshop 문서', 'size': '256 MB', 'app': 'photoshop', 'icon': CupertinoIcons.paintbrush_fill, 'color': Color(0xFF31A8FF)},
    {'title': '디스코드_커뮤니티_서버.json', 'date': '오늘 18:28', 'type': 'Discord 설정', 'size': '128 MB', 'app': 'discord', 'icon': CupertinoIcons.game_controller_solid, 'color': Color(0xFF5865F2)},
    {'title': '카카오톡_대화내용_백업.txt', 'date': '오늘 18:24', 'type': '텍스트 문서', 'size': '42 KB', 'app': 'kakaotalk', 'icon': CupertinoIcons.doc_text, 'color': Color(0xFFFEE500)},
    {'title': '로또_1등_당첨영수증.png', 'date': '오늘 16:10', 'type': 'PNG 이미지', 'size': '1.2 MB', 'app': 'lottery', 'icon': CupertinoIcons.photo, 'color': Color(0xFF0066B3)},
    {'title': '넷플릭스_오리지널_기획안.docx', 'date': '어제 21:05', 'type': 'Word 문서', 'size': '520 KB', 'app': 'netflix', 'icon': CupertinoIcons.doc_richtext, 'color': Color(0xFFE50914)},
    {'title': '쿠팡_로켓배송_주문서.pdf', 'date': '2024-10-04', 'type': 'PDF 문서', 'size': '2.4 MB', 'app': 'coupang', 'icon': CupertinoIcons.doc_fill, 'color': Color(0xFFC72424)},
    {'title': '인스타그램_릴스_편집본.mp4', 'date': '2024-09-28', 'type': 'MP4 동영상', 'size': '180 MB', 'app': 'instagram', 'icon': CupertinoIcons.play_circle_fill, 'color': Color(0xFFE1306C)},
  ];

  @override
  Widget build(BuildContext context) {
    return Win10WindowFrame(
      title: '$_currentPath - 파일 탐색기',
      iconAsset: 'assets/images/windows/explorer.png',
      width: widget.width,
      height: widget.height,
      isMaximized: widget.isMaximized,
      onClose: widget.onClose,
      onMinimize: widget.onMinimize,
      onMaximize: widget.onMaximize,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Column(
        children: [
          // 1. Windows 10 클래식 리본 메뉴 (Ribbon Bar)
          _buildRibbonBar(),

          // 2. 주소창 & 검색창 바 (Address Bar)
          _buildAddressBar(),

          // 3. 메인 분할 뷰 (좌측 네비게이션 트리 + 우측 내용)
          Expanded(
            child: Row(
              children: [
                // 좌측 폴더 트리
                Container(
                  width: 190,
                  color: const Color(0xFF1F1F1F),
                  child: _buildNavigationTree(),
                ),
                Container(width: 1, color: const Color(0xFF2D2D30)),

                // 우측 메인 콘텐츠
                Expanded(
                  child: Container(
                    color: const Color(0xFF191919),
                    child: _buildMainContent(),
                  ),
                ),
              ],
            ),
          ),

          // 4. 하단 상태 표시줄 (Status Bar)
          _buildStatusBar(),
        ],
      ),
    );
  }

  // Windows 10 리본 메뉴 (파일, 홈, 공유, 보기)
  Widget _buildRibbonBar() {
    final tabs = ['파일', '홈', '공유', '보기'];

    return Container(
      color: const Color(0xFF2B2B2B),
      child: Column(
        children: [
          // 상단 리본 탭 헤더
          Container(
            height: 28,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: const BoxDecoration(
              color: Color(0xFF242424),
              border: Border(bottom: BorderSide(color: Color(0xFF333333))),
            ),
            child: Row(
              children: [
                // 파일 탭 (파란색 배경 액센트)
                InkWell(
                  onTap: () => setState(() => _activeRibbonTab = 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    color: _activeRibbonTab == 0 ? const Color(0xFF0078D7) : const Color(0xFF1967B2),
                    child: const Text('파일', style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 2),
                ...tabs.sublist(1).asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  final title = entry.value;
                  final isActive = _activeRibbonTab == idx;
                  return InkWell(
                    onTap: () => setState(() => _activeRibbonTab = idx),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFF2B2B2B) : Colors.transparent,
                        border: isActive
                            ? const Border(top: BorderSide(color: Color(0xFF0078D7), width: 2))
                            : null,
                      ),
                      child: Text(
                        title,
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.white70,
                          fontSize: 11.5,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // 활성 탭에 따른 리본 도구 모음 그룹 패널
          Container(
            height: 82,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: const BoxDecoration(
              color: Color(0xFF2B2B2B),
              border: Border(bottom: BorderSide(color: Color(0xFF383838))),
            ),
            child: _buildRibbonHomeTools(),
          ),
        ],
      ),
    );
  }

  Widget _buildRibbonHomeTools() {
    return Row(
      children: [
        // 클립보드 그룹
        _buildRibbonGroup(
          '클립보드',
          Row(
            children: [
              _buildRibbonLargeBtn(CupertinoIcons.pin_fill, '고정', () {}),
              _buildRibbonLargeBtn(CupertinoIcons.doc_on_clipboard, '붙여넣기', () {}),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRibbonSmallBtn(CupertinoIcons.doc_on_doc, '복사'),
                  _buildRibbonSmallBtn(CupertinoIcons.scissors, '잘라내기'),
                ],
              ),
            ],
          ),
        ),
        _buildRibbonDivider(),

        // 구성 그룹
        _buildRibbonGroup(
          '구성',
          Row(
            children: [
              _buildRibbonLargeBtn(CupertinoIcons.trash, '삭제', () {}),
              _buildRibbonLargeBtn(CupertinoIcons.pencil, '이름 바꾸기', () {}),
            ],
          ),
        ),
        _buildRibbonDivider(),

        // 새로 만들기 그룹
        _buildRibbonGroup(
          '새로 만들기',
          Row(
            children: [
              _buildRibbonLargeBtn(CupertinoIcons.folder_badge_plus, '새 폴더', () {}),
              _buildRibbonLargeBtn(CupertinoIcons.plus_app, '새 항목', () {}),
            ],
          ),
        ),
        _buildRibbonDivider(),

        // 열기 그룹
        _buildRibbonGroup(
          '열기',
          Row(
            children: [
              _buildRibbonLargeBtn(CupertinoIcons.info_circle, '속성', () {}),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRibbonGroup(String label, Widget content) {
    return Column(
      children: [
        Expanded(child: content),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9.5)),
      ],
    );
  }

  Widget _buildRibbonDivider() {
    return Container(
      width: 1,
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: Colors.white10,
    );
  }

  Widget _buildRibbonLargeBtn(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: const Color(0xFF60CDFF)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildRibbonSmallBtn(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: Colors.white70),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 9.5)),
          ],
        ),
      ),
    );
  }

  // Windows 10 주소창 & 검색창 (각진 0px 바)
  Widget _buildAddressBar() {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        color: Color(0xFF1F1F1F),
        border: Border(bottom: BorderSide(color: Color(0xFF2D2D30))),
      ),
      child: Row(
        children: [
          // 뒤로/앞으로/상위 폴더
          _buildNavIcon(CupertinoIcons.arrow_left, () {}),
          _buildNavIcon(CupertinoIcons.arrow_right, null),
          _buildNavIcon(CupertinoIcons.arrow_up, () => setState(() => _currentPath = '내 PC')),
          const SizedBox(width: 6),

          // 클래식 브레드크럼 주소창
          Expanded(
            child: Container(
              height: 26,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF2B2B2B),
                border: Border.all(color: const Color(0xFF3F3F46)),
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.desktopcomputer, size: 13, color: Color(0xFF0078D7)),
                  const SizedBox(width: 6),
                  Text(_currentPath, style: const TextStyle(color: Colors.white, fontSize: 11)),
                  const Spacer(),
                  InkWell(
                    onTap: () => setState(() {}),
                    child: const Icon(CupertinoIcons.arrow_clockwise, size: 12, color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // 검색창
          SizedBox(
            width: 220,
            height: 26,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF2B2B2B),
                border: Border.all(color: const Color(0xFF3F3F46)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val.trim()),
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                      decoration: const InputDecoration(
                        hintText: '내 PC 검색',
                        hintStyle: TextStyle(color: Colors.white38, fontSize: 11),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const Icon(CupertinoIcons.search, size: 12, color: Colors.white54),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, VoidCallback? onTap) {
    final isEnabled = onTap != null;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        child: Icon(icon, size: 13, color: isEnabled ? Colors.white70 : Colors.white24),
      ),
    );
  }

  // 좌측 네비게이션 트리
  Widget _buildNavigationTree() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 6),
      children: [
        _buildTreeItem(CupertinoIcons.star_fill, '즐겨찾기', isHeader: true),
        _buildTreeItem(CupertinoIcons.desktopcomputer, '바탕 화면', indent: 16),
        _buildTreeItem(CupertinoIcons.arrow_down_circle, '다운로드', indent: 16),
        _buildTreeItem(CupertinoIcons.doc_text, '문서', indent: 16),
        _buildTreeItem(CupertinoIcons.photo, '사진', indent: 16),
        const SizedBox(height: 8),
        _buildTreeItem(CupertinoIcons.device_desktop, '내 PC', isHeader: true, isSelected: true),
        _buildTreeItem(CupertinoIcons.cube_box, '3D 개체', indent: 16),
        _buildTreeItem(CupertinoIcons.arrow_down_circle, '다운로드', indent: 16),
        _buildTreeItem(CupertinoIcons.film, '동영상', indent: 16),
        _buildTreeItem(CupertinoIcons.doc_text, '문서', indent: 16),
        _buildTreeItem(CupertinoIcons.photo, '사진', indent: 16),
        _buildTreeItem(CupertinoIcons.music_note, '음악', indent: 16),
        _buildTreeItem(CupertinoIcons.device_desktop, '로컬 디스크 (C:)', indent: 16),
        _buildTreeItem(CupertinoIcons.device_desktop, '로컬 디스크 (D:)', indent: 16),
        const SizedBox(height: 8),
        _buildTreeItem(CupertinoIcons.globe, '네트워크', isHeader: true),
      ],
    );
  }

  Widget _buildTreeItem(IconData icon, String title, {bool isHeader = false, bool isSelected = false, double indent = 8}) {
    return Container(
      color: isSelected ? const Color(0xFF0078D7).withValues(alpha: 0.25) : Colors.transparent,
      padding: EdgeInsets.fromLTRB(indent, 4, 8, 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: isSelected ? const Color(0xFF60CDFF) : (isHeader ? const Color(0xFF0078D7) : Colors.white60)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected ? Colors.white : (isHeader ? Colors.white : Colors.white70),
                fontSize: 11,
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 우측 메인 콘텐츠
  Widget _buildMainContent() {
    final filteredRecent = _recentFiles.where((f) {
      return _searchQuery.isEmpty || f['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. 폴더 (7개)
        const Text(
          '폴더 (7)',
          style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 12,
            childAspectRatio: 3.6,
          ),
          itemCount: _folders.length,
          itemBuilder: (context, index) {
            final folder = _folders[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              color: const Color(0xFF222222),
              child: Row(
                children: [
                  Icon(folder['icon'], size: 24, color: folder['color']),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      folder['title'],
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 24),

        // 2. 장치 및 드라이브 (2개)
        const Text(
          '장치 및 드라이브 (2)',
          style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildDriveBox('로컬 디스크 (C:)', 142, 256)),
            const SizedBox(width: 16),
            Expanded(child: _buildDriveBox('로컬 디스크 (D:)', 628, 931)),
          ],
        ),
        const SizedBox(height: 24),

        // 3. 최근에 사용한 파일
        const Text(
          '최근에 사용한 파일 (더블클릭하여 열기)',
          style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...filteredRecent.map((file) {
          final isSelected = _selectedFileTitle == file['title'];
          return InkWell(
            onTap: () => setState(() => _selectedFileTitle = file['title']),
            onDoubleTap: () => widget.onOpenTemplate?.call(file['app']),
            child: Container(
              color: isSelected ? const Color(0xFF0078D7).withValues(alpha: 0.3) : Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Icon(file['icon'], size: 16, color: file['color']),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 4,
                    child: Text(
                      file['title'],
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 11.5),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(file['date'], style: const TextStyle(color: Colors.white38, fontSize: 11)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(file['type'], style: const TextStyle(color: Colors.white38, fontSize: 11)),
                  ),
                  SizedBox(
                    width: 70,
                    child: Text(
                      file['size'],
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDriveBox(String name, int freeGb, int totalGb) {
    final usedGb = totalGb - freeGb;
    final ratio = usedGb / totalGb;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Row(
        children: [
          const Icon(CupertinoIcons.device_desktop, size: 36, color: Color(0xFF0078D7)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: LinearProgressIndicator(
                    value: ratio,
                    backgroundColor: const Color(0xFF333333),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0078D7)),
                    minHeight: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text('$freeGb GB 사용 가능(총 $totalGb GB)', style: const TextStyle(color: Colors.white54, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Windows 10 상태 표시줄
  Widget _buildStatusBar() {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1F1F1F),
        border: Border(top: BorderSide(color: Color(0xFF2D2D30))),
      ),
      child: Row(
        children: [
          Text('${_folders.length + 2 + _recentFiles.length}개 항목', style: const TextStyle(color: Colors.white54, fontSize: 10.5)),
          if (_selectedFileTitle != null) ...[
            const SizedBox(width: 14),
            Text('1개 항목 선택함: $_selectedFileTitle', style: const TextStyle(color: Color(0xFF60CDFF), fontSize: 10.5)),
          ],
          const Spacer(),
          const Icon(CupertinoIcons.list_bullet, size: 12, color: Colors.white70),
          const SizedBox(width: 8),
          const Icon(CupertinoIcons.square_grid_2x2, size: 12, color: Colors.white38),
        ],
      ),
    );
  }
}
