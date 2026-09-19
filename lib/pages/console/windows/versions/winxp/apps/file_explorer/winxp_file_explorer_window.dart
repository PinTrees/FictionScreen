import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/winxp_window_frame.dart';

/// Windows XP 내 컴퓨터 (My Computer / Explorer)
class WinXpFileExplorerWindow extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(String templateId)? onOpenTemplate;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;
  final bool isMaximized;

  const WinXpFileExplorerWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onOpenTemplate,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 820,
    this.height = 540,
    this.isMaximized = false,
  });

  @override
  State<WinXpFileExplorerWindow> createState() => _WinXpFileExplorerWindowState();
}

class _WinXpFileExplorerWindowState extends State<WinXpFileExplorerWindow> {
  final String _currentPath = '내 컴퓨터';
  String? _selectedItemTitle;

  @override
  Widget build(BuildContext context) {
    return WinXpWindowFrame(
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
        color: const Color(0xFFECE9D8), // XP 툴바 베이지
        child: Column(
          children: [
            // 1. 메뉴 바
            _buildMenuBar(),

            // 2. 표준 단추 툴바 (큰 초록색 원형 뒤로가기 버튼)
            _buildStandardToolbar(),

            // 3. 주소창 (주소 + 이동)
            _buildAddressBar(),

            // 4. 메인 콘텐츠 (좌측 태스크 패널 + 우측 드라이브 목록)
            Expanded(
              child: Row(
                children: [
                  // 좌측 블루 태스크 패널 (시스템 작업, 기타 위치)
                  _buildLeftTaskPane(),

                  // 우측 흰색 드라이브 목록 영역
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: _buildMainDriveList(),
                    ),
                  ),
                ],
              ),
            ),

            // 5. 하단 상태 표시줄
            _buildStatusBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuBar() {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: const BoxDecoration(
        color: Color(0xFFECE9D8),
        border: Border(bottom: BorderSide(color: Color(0xFFD8D2BD))),
      ),
      child: Row(
        children: [
          _buildMenuText('파일(F)'),
          _buildMenuText('편집(E)'),
          _buildMenuText('보기(V)'),
          _buildMenuText('즐겨찾기(A)'),
          _buildMenuText('도구(T)'),
          _buildMenuText('도움말(H)'),
          const Spacer(),
          // 우측 상단 회전하는 Windows XP 플래그
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF90A4AE)),
              borderRadius: BorderRadius.circular(2),
            ),
            child: const Icon(CupertinoIcons.flag_fill, size: 10, color: Color(0xFF0284C7)),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildMenuText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Text(text, style: const TextStyle(fontSize: 11, color: Colors.black87)),
    );
  }

  Widget _buildStandardToolbar() {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: const BoxDecoration(
        color: Color(0xFFECE9D8),
        border: Border(bottom: BorderSide(color: Color(0xFFD8D2BD))),
      ),
      child: Row(
        children: [
          // 시그니처 큼직한 초록색 원형 뒤로 단추
          _buildToolbarButton(
            label: '뒤로',
            iconWidget: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: Alignment(-0.2, -0.3),
                  colors: [Color(0xFF86EFAC), Color(0xFF22C55E), Color(0xFF15803D)],
                ),
              ),
              child: const Icon(CupertinoIcons.arrow_left, size: 14, color: Colors.white),
            ),
            hasArrow: true,
          ),
          const SizedBox(width: 2),

          // 앞으로 단추
          _buildToolbarButton(
            label: '앞으로',
            iconWidget: const Icon(CupertinoIcons.arrow_right, size: 18, color: Colors.black38),
            hasArrow: true,
            enabled: false,
          ),
          const SizedBox(width: 2),

          // 위로 단추
          _buildToolbarButton(
            label: '',
            iconWidget: const Icon(CupertinoIcons.arrow_up_to_line, size: 18, color: Color(0xFFF59E0B)),
          ),

          _buildToolbarDivider(),

          // 검색 단추
          _buildToolbarButton(
            label: '검색',
            iconWidget: const Icon(CupertinoIcons.search, size: 18, color: Color(0xFF0284C7)),
          ),
          const SizedBox(width: 2),

          // 폴더 단추
          _buildToolbarButton(
            label: '폴더',
            iconWidget: const Icon(CupertinoIcons.folder_fill, size: 18, color: Color(0xFFF59E0B)),
          ),

          _buildToolbarDivider(),

          // 보기 단추
          _buildToolbarButton(
            label: '',
            iconWidget: const Icon(CupertinoIcons.rectangle_grid_2x2, size: 18, color: Color(0xFF475569)),
            hasArrow: true,
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton({
    required String label,
    required Widget iconWidget,
    bool hasArrow = false,
    bool enabled = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          if (label.isNotEmpty) ...[
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: enabled ? Colors.black87 : Colors.black38),
            ),
          ],
          if (hasArrow) ...[
            const SizedBox(width: 2),
            const Icon(CupertinoIcons.chevron_down, size: 8, color: Colors.black54),
          ],
        ],
      ),
    );
  }

  Widget _buildToolbarDivider() {
    return Container(
      width: 1,
      height: 22,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: const Color(0xFFB0A890),
    );
  }

  Widget _buildAddressBar() {
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: const BoxDecoration(
        color: Color(0xFFECE9D8),
        border: Border(bottom: BorderSide(color: Color(0xFFB0A890))),
      ),
      child: Row(
        children: [
          const Text('주소(D)', style: TextStyle(fontSize: 11, color: Colors.black54)),
          const SizedBox(width: 6),
          Expanded(
            child: Container(
              height: 20,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFF7F9DB9)),
              ),
              child: Row(
                children: [
                  Image.asset('assets/images/windows/this_pc.png', width: 14, height: 14, errorBuilder: (c, e, s) => const Icon(Icons.computer, size: 14)),
                  const SizedBox(width: 6),
                  Text(_currentPath, style: const TextStyle(fontSize: 11, color: Colors.black87)),
                  const Spacer(),
                  const Icon(CupertinoIcons.chevron_down, size: 9, color: Colors.black54),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          // 초록색 이동(Go) 버튼
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF86EFAC), Color(0xFF22C55E)]),
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: const Color(0xFF15803D)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.arrow_right, size: 10, color: Colors.white),
                SizedBox(width: 2),
                Text('이동', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftTaskPane() {
    return Container(
      width: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF7BA2D8), Color(0xFF6375D6)],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          _buildTaskPaneCard(
            title: '시스템 작업',
            items: [
              '시스템 정보 보기',
              '프로그램 추가/제거',
              '설정 변경',
            ],
          ),
          const SizedBox(height: 12),
          _buildTaskPaneCard(
            title: '기타 위치',
            items: [
              '내 네트워크 환경',
              '내 문서',
              '공유 문서',
              '제어판',
            ],
          ),
          const SizedBox(height: 12),
          _buildTaskPaneCard(
            title: '자세한 내용',
            items: [
              '내 컴퓨터',
              '시스템 폴더',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskPaneCard({required String title, required List<String> items}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD6E3F4),
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          // 카드 헤더 (둥근 그라데이션)
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF215DC6), Color(0xFF3886DF)]),
              borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const Icon(CupertinoIcons.chevron_up_circle_fill, size: 14, color: Colors.white),
              ],
            ),
          ),
          // 카드 내부 링크 목록
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.smallcircle_fill_circle, size: 8, color: Color(0xFF215DC6)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 10.5, color: Color(0xFF0C2442), decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainDriveList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('이 컴퓨터에 저장된 파일'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            _buildXpTile('공유 문서', 'assets/images/windows/folder.png'),
            _buildXpTile('사용자의 문서', 'assets/images/windows/folder.png'),
          ],
        ),
        const SizedBox(height: 22),

        _buildSectionHeader('하드 디스크 드라이브'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            _buildXpTile('로컬 디스크 (C:)', 'assets/images/windows/disk-sm.png'),
            _buildXpTile('새 볼륨 (D:)', 'assets/images/windows/disk-sm.png'),
          ],
        ),
        const SizedBox(height: 22),

        _buildSectionHeader('이동식 미디어가 있는 장치'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 16,
          children: [
            _buildXpTile('CD-RW 드라이브 (E:)', 'assets/images/windows/docs.png'),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF0C2442)),
        ),
        const SizedBox(width: 8),
        Expanded(child: Container(height: 1, color: const Color(0xFFE2E8F0))),
      ],
    );
  }

  Widget _buildXpTile(String title, String iconAsset) {
    final isSelected = _selectedItemTitle == title;

    return InkWell(
      onTap: () => setState(() => _selectedItemTitle = title),
      child: Container(
        width: 220,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0A246A) : Colors.transparent,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          children: [
            Image.asset(iconAsset, width: 32, height: 32, errorBuilder: (c, e, s) => const Icon(CupertinoIcons.folder_fill, size: 32, color: Color(0xFFF59E0B))),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 11.5,
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: Color(0xFFECE9D8),
        border: Border(top: BorderSide(color: Color(0xFFD8D2BD))),
      ),
      child: const Row(
        children: [
          Text('개체 5개', style: TextStyle(fontSize: 10.5, color: Colors.black54)),
          Spacer(),
          Icon(CupertinoIcons.desktopcomputer, size: 12, color: Colors.black45),
          SizedBox(width: 4),
          Text('내 컴퓨터', style: TextStyle(fontSize: 10.5, color: Colors.black54)),
        ],
      ),
    );
  }
}
