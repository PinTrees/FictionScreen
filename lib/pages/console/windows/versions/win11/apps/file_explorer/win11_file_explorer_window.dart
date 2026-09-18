import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/win11_window_frame.dart';

/// Windows 11 순정 파일 탐색기 (File Explorer) 창
class Win11FileExplorerWindow extends StatefulWidget {
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

  const Win11FileExplorerWindow({
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
  State<Win11FileExplorerWindow> createState() => _Win11FileExplorerWindowState();
}

class _Win11FileExplorerWindowState extends State<Win11FileExplorerWindow> {
  int _activeTabIndex = 0;
  String _currentPath = '홈';
  String _searchQuery = '';

  // 빠른 실행 폴더 목록 (Windows 11 순정 아이콘)
  final List<Map<String, dynamic>> _quickFolders = [
    {'title': '바탕 화면', 'icon': 'assets/images/windows/desk.png', 'items': '14개 항목'},
    {'title': '다운로드', 'icon': 'assets/images/windows/down.png', 'items': '32개 항목'},
    {'title': '문서', 'icon': 'assets/images/windows/docs.png', 'items': '58개 항목'},
    {'title': '사진', 'icon': 'assets/images/windows/pics.png', 'items': '142개 항목'},
    {'title': '음악', 'icon': 'assets/images/windows/music.png', 'items': '87개 항목'},
    {'title': '동영상', 'icon': 'assets/images/windows/video.png', 'items': '29개 항목'},
  ];

  // 최근 사용한 파일 목록
  final List<Map<String, dynamic>> _recentFiles = [
    {'title': '카카오톡_대화내용_백업.txt', 'date': '오늘 18:24', 'type': '텍스트 문서', 'size': '42 KB', 'app': 'kakaotalk', 'icon': CupertinoIcons.doc_text},
    {'title': '로또_1등_당첨영수증.png', 'date': '오늘 16:10', 'type': 'PNG 이미지', 'size': '1.2 MB', 'app': 'lottery', 'icon': CupertinoIcons.photo},
    {'title': '넷플릭스_오리지널_기획안.docx', 'date': '어제 21:05', 'type': 'Word 문서', 'size': '520 KB', 'app': 'netflix', 'icon': CupertinoIcons.doc_richtext},
    {'title': '쿠팡_로켓배송_주문서.pdf', 'date': '2024-10-04', 'type': 'PDF 문서', 'size': '2.4 MB', 'app': 'coupang', 'icon': CupertinoIcons.doc_fill},
    {'title': '유튜브_썸네일_최종.psd', 'date': '2024-10-02', 'type': '포토샵 파일', 'size': '45 MB', 'app': 'youtube', 'icon': CupertinoIcons.photo_fill_on_rectangle_fill},
    {'title': '인스타그램_릴스_편집본.mp4', 'date': '2024-09-28', 'type': 'MP4 동영상', 'size': '180 MB', 'app': 'instagram', 'icon': CupertinoIcons.play_circle_fill},
  ];

  @override
  Widget build(BuildContext context) {
    return Win11WindowFrame(
      title: '파일 탐색기',
      iconAsset: 'assets/images/windows/explorer.png',
      width: widget.width,
      height: widget.height,
      isMaximized: widget.isMaximized,
      onClose: widget.onClose,
      onMinimize: widget.onMinimize,
      onMaximize: widget.onMaximize,
      onSnapLayout: widget.onSnapLayout,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      // Windows 11 상단 탭 바 커스텀 타이틀 위젯
      customTitleWidget: _buildTabBar(),
      child: Column(
        children: [
          // 1. Windows 11 순정 명령 모음 리본 (Command Ribbon)
          _buildCommandRibbon(),

          // 2. 주소창 및 검색창 (Address Bar & Search)
          _buildAddressAndSearchBar(),

          // 3. 메인 콘텐츠 (좌측 사이드바 + 우측 파일/폴더 뷰)
          Expanded(
            child: Row(
              children: [
                // 좌측 사이드바 (Navigation Pane)
                Container(
                  width: 190,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.02),
                    border: Border(
                      right: BorderSide(color: Colors.white.withValues(alpha: 0.07)),
                    ),
                  ),
                  child: _buildSidebar(),
                ),

                // 우측 메인 파일/폴더 브라우저
                Expanded(
                  child: Container(
                    color: const Color(0xFF191B22).withValues(alpha: 0.85),
                    child: _buildMainContent(),
                  ),
                ),
              ],
            ),
          ),

          // 4. 하단 상태 표시줄 (Status Bar)
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
            ),
            child: Row(
              children: [
                Text(
                  '${_quickFolders.length + _recentFiles.length}개 항목',
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
                const SizedBox(width: 14),
                const Text('|', style: TextStyle(color: Colors.white24, fontSize: 11)),
                const SizedBox(width: 14),
                const Text('선택한 항목 1개', style: TextStyle(color: Colors.white38, fontSize: 11)),
                const Spacer(),
                const Icon(CupertinoIcons.square_grid_2x2, size: 12, color: Colors.white54),
                const SizedBox(width: 8),
                const Icon(CupertinoIcons.list_bullet, size: 12, color: Colors.white38),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Windows 11 상단 탭 바
  Widget _buildTabBar() {
    return Row(
      children: [
        const SizedBox(width: 8),
        _buildTabItem(0, '홈', CupertinoIcons.house_fill),
        const SizedBox(width: 4),
        _buildTabItem(1, '내 PC', CupertinoIcons.device_desktop),
        const SizedBox(width: 6),
        // 새 탭 추가 (+) 버튼
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
            child: const Icon(CupertinoIcons.plus, size: 12, color: Colors.white70),
          ),
        ),
      ],
    );
  }

  Widget _buildTabItem(int index, String title, IconData icon) {
    final isSelected = _activeTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() {
        _activeTabIndex = index;
        _currentPath = title;
      }),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF282B35) : Colors.transparent,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          border: isSelected
              ? Border(
                  left: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  right: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: isSelected ? const Color(0xFF60A5FA) : Colors.white60),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () {},
              child: const Icon(CupertinoIcons.xmark, size: 9, color: Colors.white38),
            ),
          ],
        ),
      ),
    );
  }

  // Windows 11 신규 명령 모음 리본
  Widget _buildCommandRibbon() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.025),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.07))),
      ),
      child: Row(
        children: [
          // 새로 만들기 드롭다운
          _buildRibbonButton(
            icon: CupertinoIcons.plus,
            label: '새로 만들기',
            hasDropdown: true,
            isPrimary: true,
            onTap: () {},
          ),
          _buildRibbonDivider(),
          // 가위, 복사, 붙여넣기, 이름 바꾸기, 공유, 삭제
          _buildIconButton(CupertinoIcons.scissors, '잘라내기'),
          _buildIconButton(CupertinoIcons.doc_on_doc, '복사'),
          _buildIconButton(CupertinoIcons.doc_on_clipboard, '붙여넣기'),
          _buildIconButton(CupertinoIcons.pencil, '이름 바꾸기'),
          _buildIconButton(CupertinoIcons.share, '공유'),
          _buildIconButton(CupertinoIcons.trash, '삭제'),
          _buildRibbonDivider(),
          // 정렬 & 보기 드롭다운
          _buildRibbonButton(icon: CupertinoIcons.arrow_up_arrow_down, label: '정렬', hasDropdown: true, onTap: () {}),
          const SizedBox(width: 4),
          _buildRibbonButton(icon: CupertinoIcons.rectangle_grid_2x2, label: '보기', hasDropdown: true, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildRibbonButton({
    required IconData icon,
    required String label,
    bool hasDropdown = false,
    bool isPrimary = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isPrimary ? const Color(0xFF60A5FA) : Colors.white70),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w500)),
            if (hasDropdown) ...[
              const SizedBox(width: 4),
              const Icon(CupertinoIcons.chevron_down, size: 9, color: Colors.white54),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          child: Icon(icon, size: 14, color: Colors.white70),
        ),
      ),
    );
  }

  Widget _buildRibbonDivider() {
    return Container(
      width: 1,
      height: 18,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: Colors.white.withValues(alpha: 0.12),
    );
  }

  // 주소창 및 검색창
  Widget _buildAddressAndSearchBar() {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.015),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
      ),
      child: Row(
        children: [
          _buildNavBtn(CupertinoIcons.arrow_left, () => setState(() => _currentPath = '홈')),
          _buildNavBtn(CupertinoIcons.arrow_right, null),
          _buildNavBtn(CupertinoIcons.arrow_up, () => setState(() => _currentPath = '내 PC')),
          _buildNavBtn(CupertinoIcons.arrow_clockwise, () => setState(() {})),
          const SizedBox(width: 8),

          // 빵부스러기 주소창
          Expanded(
            flex: 6,
            child: Container(
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.house_fill, size: 12, color: Color(0xFF60A5FA)),
                  const SizedBox(width: 6),
                  Text(_currentPath, style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w500)),
                  const Icon(CupertinoIcons.chevron_right, size: 9, color: Colors.white38),
                  const Spacer(),
                  const Icon(CupertinoIcons.arrow_clockwise, size: 11, color: Colors.white38),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // 검색창
          Expanded(
            flex: 3,
            child: Container(
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.search, size: 12, color: Colors.white38),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                      cursorColor: const Color(0xFF60CDFF),
                      decoration: const InputDecoration(
                        filled: false,
                        fillColor: Colors.transparent,
                        hintText: '내 PC 검색',
                        hintStyle: TextStyle(color: Colors.white30, fontSize: 11),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (val) => setState(() => _searchQuery = val),
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

  Widget _buildNavBtn(IconData icon, VoidCallback? onTap) {
    final isEnabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 26,
        height: 26,
        alignment: Alignment.center,
        child: Icon(icon, size: 13, color: isEnabled ? Colors.white70 : Colors.white24),
      ),
    );
  }

  // 좌측 사이드바
  Widget _buildSidebar() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _buildSidebarItem('홈', CupertinoIcons.house_fill, isSelected: _currentPath == '홈', onTap: () => setState(() => _currentPath = '홈')),
        _buildSidebarHeader('즐겨찾기'),
        _buildSidebarAssetItem('바탕 화면', 'assets/images/windows/desk.png'),
        _buildSidebarAssetItem('다운로드', 'assets/images/windows/down.png'),
        _buildSidebarAssetItem('문서', 'assets/images/windows/docs.png'),
        _buildSidebarAssetItem('사진', 'assets/images/windows/pics.png'),
        _buildSidebarAssetItem('음악', 'assets/images/windows/music.png'),
        _buildSidebarAssetItem('동영상', 'assets/images/windows/vid.png'),
        const Divider(color: Colors.white10, height: 16),
        _buildSidebarHeader('이 PC'),
        _buildSidebarAssetItem('로컬 디스크 (C:)', 'assets/images/windows/disk-sm.png'),
        _buildSidebarAssetItem('로컬 디스크 (D:)', 'assets/images/windows/disk-sm.png'),
        const Divider(color: Colors.white10, height: 16),
        _buildSidebarAssetItem('OneDrive - 개인', 'assets/images/windows/onedrive.png'),
        _buildSidebarAssetItem('휴지통', 'assets/images/windows/recycle_bin.png'),
      ],
    );
  }

  Widget _buildSidebarHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white38, fontSize: 10.5, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSidebarItem(String title, IconData icon, {bool isSelected = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        color: isSelected ? Colors.white.withValues(alpha: 0.08) : Colors.transparent,
        child: Row(
          children: [
            Icon(icon, size: 14, color: isSelected ? const Color(0xFF60A5FA) : Colors.white60),
            const SizedBox(width: 8),
            Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontSize: 11.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarAssetItem(String title, String asset) {
    return InkWell(
      onTap: () => setState(() => _currentPath = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        child: Row(
          children: [
            Image.asset(asset, width: 15, height: 15),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 11.5)),
          ],
        ),
      ),
    );
  }

  // 우측 메인 콘텐츠 (빠른 실행 폴더 + 드라이브 + 최근 파일)
  Widget _buildMainContent() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        // 1. 빠른 실행 (즐겨찾기 폴더들)
        const Text(
          '즐겨찾기',
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 180,
            mainAxisExtent: 56,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: _quickFolders.length,
          itemBuilder: (context, index) {
            final folder = _quickFolders[index];
            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                children: [
                  Image.asset(folder['icon'], width: 34, height: 34),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          folder['title'],
                          style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          folder['items'],
                          style: const TextStyle(color: Colors.white38, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 24),

        // 2. 장치 및 드라이브
        const Text(
          '장치 및 드라이브',
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildDriveCard('로컬 디스크 (C:)', 120, 256)),
            const SizedBox(width: 12),
            Expanded(child: _buildDriveCard('로컬 디스크 (D:)', 650, 931)),
          ],
        ),
        const SizedBox(height: 24),

        // 3. 최근 사용한 파일
        const Text(
          '최근에 사용한 파일',
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        ..._recentFiles
            .where((f) => _searchQuery.isEmpty || f['title'].toString().contains(_searchQuery))
            .map((file) {
          return InkWell(
            onDoubleTap: () => widget.onOpenTemplate?.call(file['app']),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white10, width: 0.5)),
              ),
              child: Row(
                children: [
                  Icon(file['icon'], size: 16, color: const Color(0xFF60A5FA)),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 4,
                    child: Text(
                      file['title'],
                      style: const TextStyle(color: Colors.white, fontSize: 11.5),
                      overflow: TextOverflow.ellipsis,
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
                  Expanded(
                    flex: 1,
                    child: Text(file['size'], textAlign: TextAlign.right, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDriveCard(String label, int freeGb, int totalGb) {
    final usedRatio = (totalGb - freeGb) / totalGb;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Image.asset('assets/images/windows/disk-sm.png', width: 32, height: 32),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: usedRatio,
                    backgroundColor: Colors.white12,
                    color: const Color(0xFF0078D7),
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalGb GB 중 $freeGb GB 사용 가능',
                  style: const TextStyle(color: Colors.white38, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
