import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/win7_window_frame.dart';

/// Windows 7 순정 컴퓨터(탐색기) 창 (Aero Glass, 커맨드 바, C:/D: 드라이브 게이지)
class Win7FileExplorerWindow extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(String templateId)? onOpenTemplate;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;
  final bool isMaximized;

  const Win7FileExplorerWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onOpenTemplate,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 840,
    this.height = 540,
    this.isMaximized = false,
  });

  @override
  State<Win7FileExplorerWindow> createState() => _Win7FileExplorerWindowState();
}

class _Win7FileExplorerWindowState extends State<Win7FileExplorerWindow> {
  String _currentPath = '컴퓨터';
  String _searchQuery = '';
  String? _selectedItemTitle;

  @override
  Widget build(BuildContext context) {
    return Win7WindowFrame(
      title: _currentPath,
      iconAsset: 'assets/images/windows/this_pc.png',
      width: widget.width,
      height: widget.height,
      isMaximized: widget.isMaximized,
      onClose: widget.onClose,
      onMinimize: widget.onMinimize,
      onMaximize: widget.onMaximize,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // 1. 에어로 주소창 및 검색창 헤더
            _buildNavigationAddressBar(),

            // 2. Windows 7 클래식 커맨드 바 (구성, 시스템 속성 등)
            _buildClassicCommandBar(),

            // 3. 메인 탐색기 본문 (좌측 네비게이션 트리 + 우측 드라이브 목록)
            Expanded(
              child: Row(
                children: [
                  // 좌측 사이드바 트리
                  Container(
                    width: 190,
                    color: const Color(0xFFF0F4F9),
                    child: _buildNavigationSidebar(),
                  ),

                  // 구분선
                  Container(width: 1, color: const Color(0xFFD9D9D9)),

                  // 우측 하드 디스크 드라이브 목록
                  Expanded(
                    child: _buildDrivesContent(),
                  ),
                ],
              ),
            ),

            // 4. 하단 상세 정보 창 (Details Pane)
            _buildDetailsPane(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationAddressBar() {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F6F7),
        border: Border(bottom: BorderSide(color: Color(0xFFD9D9D9))),
      ),
      child: Row(
        children: [
          // 뒤로 가기 / 앞으로 가기 에어로 원형 버튼
          _buildNavCircleButton(CupertinoIcons.chevron_back, false),
          const SizedBox(width: 2),
          _buildNavCircleButton(CupertinoIcons.chevron_forward, false),
          const SizedBox(width: 6),

          // 에어로 브레드크럼 주소창
          Expanded(
            child: Container(
              height: 26,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFF7F9DB9)),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/windows/this_pc.png',
                    width: 14,
                    height: 14,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.computer, size: 14),
                  ),
                  const SizedBox(width: 6),
                  Text(_currentPath, style: const TextStyle(fontSize: 11.5, color: Colors.black87)),
                  const Icon(CupertinoIcons.chevron_right, size: 10, color: Colors.black45),
                  const Spacer(),
                  const Icon(CupertinoIcons.arrow_clockwise, size: 12, color: Colors.black54),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),

          // 검색창
          Container(
            width: 200,
            height: 26,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF7F9DB9)),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val.trim()),
                    style: const TextStyle(fontSize: 11.5, color: Colors.black87),
                    decoration: const InputDecoration(
                      hintText: '컴퓨터 검색',
                      hintStyle: TextStyle(fontSize: 11, color: Colors.black38),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const Icon(CupertinoIcons.search, size: 12, color: Color(0xFF38BDF8)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavCircleButton(IconData icon, bool enabled) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: enabled
              ? [const Color(0xFFBFE0FF), const Color(0xFF6EB7F5)]
              : [Colors.white, const Color(0xFFE2E2E2)],
        ),
        border: Border.all(color: enabled ? const Color(0xFF3399FF) : const Color(0xFFCCCCCC)),
      ),
      child: Icon(icon, size: 12, color: enabled ? const Color(0xFF003366) : Colors.black38),
    );
  }

  Widget _buildClassicCommandBar() {
    final commands = ['구성 ▾', '시스템 속성', '프로그램 제거 또는 변경', '네트워크 드라이브 연결', '제어판 열기'];

    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF9FAFB), Color(0xFFEAEFF5)],
        ),
        border: Border(bottom: BorderSide(color: Color(0xFFD9D9D9))),
      ),
      child: Row(
        children: commands.map((cmd) {
          return InkWell(
            onTap: () {},
            hoverColor: const Color(0xFFCCE8FF),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                cmd,
                style: const TextStyle(color: Color(0xFF1E395B), fontSize: 11),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNavigationSidebar() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _buildTreeGroupHeader('즐겨찾기'),
        _buildTreeItem('바탕 화면', CupertinoIcons.desktopcomputer),
        _buildTreeItem('다운로드', CupertinoIcons.arrow_down_circle),
        _buildTreeItem('최근 위치', CupertinoIcons.clock),
        const SizedBox(height: 8),

        _buildTreeGroupHeader('라이브러리'),
        _buildTreeItem('문서', CupertinoIcons.doc_text),
        _buildTreeItem('비디오', CupertinoIcons.film),
        _buildTreeItem('사진', CupertinoIcons.photo),
        _buildTreeItem('음악', CupertinoIcons.music_note),
        const SizedBox(height: 8),

        _buildTreeGroupHeader('컴퓨터'),
        _buildTreeItem('로컬 디스크 (C:)', CupertinoIcons.floppy_disk, isSelected: true),
        _buildTreeItem('새 볼륨 (D:)', CupertinoIcons.floppy_disk),
        const SizedBox(height: 8),

        _buildTreeGroupHeader('네트워크'),
      ],
    );
  }

  Widget _buildTreeGroupHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        children: [
          const Icon(CupertinoIcons.chevron_down, size: 10, color: Colors.black54),
          const SizedBox(width: 4),
          Text(title, style: const TextStyle(color: Color(0xFF1E395B), fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTreeItem(String title, IconData icon, {bool isSelected = false}) {
    return InkWell(
      onTap: () => setState(() => _currentPath = title),
      child: Container(
        color: isSelected ? const Color(0xFFDCEBFC) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 14, color: isSelected ? const Color(0xFF1B65B5) : Colors.black54),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? const Color(0xFF1B65B5) : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrivesContent() {
    final bool matchC = _searchQuery.isEmpty || '로컬 디스크 (c:)'.toLowerCase().contains(_searchQuery.toLowerCase());
    final bool matchD = _searchQuery.isEmpty || '새 볼륨 (d:)'.toLowerCase().contains(_searchQuery.toLowerCase());
    final bool matchE = _searchQuery.isEmpty || 'dvd rw 드라이브 (e:)'.toLowerCase().contains(_searchQuery.toLowerCase());

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (matchC || matchD) ...[
          // 그룹 1: 하드 디스크 드라이브 (2)
          _buildDriveSectionHeader('하드 디스크 드라이브 (2)'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 16,
            runSpacing: 14,
            children: [
              if (matchC)
                _buildDriveTile(
                  title: '로컬 디스크 (C:)',
                  freeSpaceText: '118GB 중 45.2GB 사용 가능',
                  progress: 0.62,
                  iconAsset: 'assets/images/windows/disk-sm.png',
                ),
              if (matchD)
                _buildDriveTile(
                  title: '새 볼륨 (D:)',
                  freeSpaceText: '931GB 중 720GB 사용 가능',
                  progress: 0.23,
                  iconAsset: 'assets/images/windows/disk-sm.png',
                ),
            ],
          ),
          const SizedBox(height: 24),
        ],

        if (matchE) ...[
          // 그룹 2: 이동식 미디어가 있는 장치 (1)
          _buildDriveSectionHeader('이동식 미디어가 있는 장치 (1)'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 16,
            children: [
              _buildDriveTile(
                title: 'DVD RW 드라이브 (E:)',
                freeSpaceText: '',
                progress: 0.0,
                iconAsset: 'assets/images/windows/docs.png',
                isRemovable: true,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDriveSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(color: Color(0xFF1E395B), fontSize: 11.5, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Expanded(child: Container(height: 1, color: const Color(0xFFD9D9D9))),
      ],
    );
  }

  Widget _buildDriveTile({
    required String title,
    required String freeSpaceText,
    required double progress,
    required String iconAsset,
    bool isRemovable = false,
  }) {
    final isSelected = _selectedItemTitle == title;

    return InkWell(
      onTap: () => setState(() => _selectedItemTitle = title),
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE5F3FF) : Colors.transparent,
          border: Border.all(color: isSelected ? const Color(0xFF7DA2CE) : Colors.transparent),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Row(
          children: [
            Image.asset(
              iconAsset,
              width: 36,
              height: 36,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(CupertinoIcons.floppy_disk, size: 36, color: Color(0xFF0078D7)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 11.5, color: Colors.black87, fontWeight: FontWeight.w600),
                  ),
                  if (!isRemovable) ...[
                    const SizedBox(height: 4),
                    // Windows 7 순정 블루 게이지 바
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF999999)),
                        color: const Color(0xFFE6E6E6),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF8CD4FF), Color(0xFF268BDB), Color(0xFF0A58A2)],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      freeSpaceText,
                      style: const TextStyle(fontSize: 10, color: Colors.black54),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsPane() {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFEEF3FA),
        border: Border(top: BorderSide(color: Color(0xFFC9D5E8))),
      ),
      child: const Row(
        children: [
          Icon(Icons.computer, size: 16, color: Color(0xFF1E395B)),
          SizedBox(width: 8),
          Text(
            '컴퓨터',
            style: TextStyle(color: Color(0xFF1E395B), fontSize: 11, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 14),
          Text(
            '시스템 등급: 7.9 Windows 체험 지수 | 프로세서: Intel(R) Core(TM) i7 | 메모리: 16.0GB',
            style: TextStyle(color: Colors.black54, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
