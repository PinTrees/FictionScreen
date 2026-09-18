import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../common/os_window_frame.dart';

/// Windows 11 파일 탐색기 (File Explorer) 창
class WindowsFileExplorerWindow extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String templateId)? onOpenTemplate;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;

  const WindowsFileExplorerWindow({
    super.key,
    required this.onClose,
    this.onOpenTemplate,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 780,
    this.height = 520,
  });

  @override
  State<WindowsFileExplorerWindow> createState() => _WindowsFileExplorerWindowState();
}

class _WindowsFileExplorerWindowState extends State<WindowsFileExplorerWindow> {
  final List<Map<String, dynamic>> _quickAccess = [
    {'title': '바탕 화면', 'icon': CupertinoIcons.desktopcomputer, 'color': Color(0xFF0078D7)},
    {'title': '다운로드', 'icon': CupertinoIcons.arrow_down_circle, 'color': Color(0xFF10B981)},
    {'title': '문서', 'icon': CupertinoIcons.doc_text, 'color': Color(0xFFF59E0B)},
    {'title': '사진', 'icon': CupertinoIcons.photo_fill_on_rectangle_fill, 'color': Color(0xFF8B5CF6)},
  ];

  final List<Map<String, dynamic>> _templateFiles = [
    {'title': '카카오톡_채팅방_템플릿', 'type': 'kakaotalk', 'size': '64 MB', 'icon': CupertinoIcons.chat_bubble_2_fill, 'color': Color(0xFFFEE500)},
    {'title': '카카오뱅크_통장_템플릿', 'type': 'kakaobank', 'size': '48 MB', 'icon': CupertinoIcons.creditcard_fill, 'color': Color(0xFFFEE500)},
    {'title': '당근마켓_채팅_템플릿', 'type': 'daangn', 'size': '52 MB', 'icon': CupertinoIcons.chat_bubble_text_fill, 'color': Color(0xFFFF6F0F)},
    {'title': '토스_송금완료_템플릿', 'type': 'toss', 'size': '42 MB', 'icon': CupertinoIcons.money_dollar_circle_fill, 'color': Color(0xFF0050FF)},
    {'title': '인스타그램_피드_템플릿', 'type': 'instagram', 'size': '98 MB', 'icon': CupertinoIcons.camera_fill, 'color': Color(0xFFE1306C)},
    {'title': 'X_트위터_포스트_템플릿', 'type': 'x_twitter', 'size': '38 MB', 'icon': CupertinoIcons.conversation_bubble, 'color': Color(0xFF1D9BF0)},
    {'title': '유튜브_플레이어_템플릿', 'type': 'youtube', 'size': '112 MB', 'icon': CupertinoIcons.play_circle_fill, 'color': Color(0xFFFF0000)},
    {'title': 'Windows_블루스크린_에디터', 'type': 'windows_bsod', 'size': '45 MB', 'icon': CupertinoIcons.device_desktop, 'color': Color(0xFF0078D7)},
    {'title': '배달의민족_배송현황_템플릿', 'type': 'delivery', 'size': '84 MB', 'icon': CupertinoIcons.bag_fill, 'color': Color(0xFF2AC1BC)},
    {'title': '야놀자_숙소예약_템플릿', 'type': 'yanolja', 'size': '76 MB', 'icon': CupertinoIcons.bed_double_fill, 'color': Color(0xFFFF3478)},
    {'title': '업비트_가상자산_템플릿', 'type': 'upbit', 'size': '92 MB', 'icon': CupertinoIcons.chart_bar_alt_fill, 'color': Color(0xFF093687)},
    {'title': '블라인드_익명커뮤니티_템플릿', 'type': 'blind', 'size': '64 MB', 'icon': CupertinoIcons.building_2_fill, 'color': Color(0xFFDA3238)},
    {'title': '디스코드_커뮤니티_템플릿', 'type': 'discord', 'size': '128 MB', 'icon': CupertinoIcons.game_controller_solid, 'color': Color(0xFF5865F2)},
    {'title': '포토샵_그래픽작업_템플릿', 'type': 'photoshop', 'size': '256 MB', 'icon': CupertinoIcons.paintbrush_fill, 'color': Color(0xFF31A8FF)},
    {'title': '비주얼스튜디오2026_프로젝트', 'type': 'visual_studio', 'size': '512 MB', 'icon': CupertinoIcons.chevron_left_slash_chevron_right, 'color': Color(0xFF68217A)},
    {'title': '다빈치리졸브_색보정프로젝트', 'type': 'davinci_resolve', 'size': '1.2 GB', 'icon': CupertinoIcons.videocam_circle_fill, 'color': Color(0xFFE53935)},
  ];

  @override
  Widget build(BuildContext context) {
    return OsWindowFrame(
      title: '파일 탐색기 - 내 PC',
      icon: CupertinoIcons.folder_fill,
      style: WindowStyle.windows,
      width: widget.width,
      height: widget.height,
      onClose: widget.onClose,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Column(
        children: [
          // Windows 11 명령 바
          Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
            ),
            child: const Row(
              children: [
                Icon(CupertinoIcons.plus, size: 14, color: Color(0xFF60A5FA)),
                SizedBox(width: 4),
                Text('새로 만들기', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                SizedBox(width: 16),
                Icon(CupertinoIcons.scissors, size: 14, color: Colors.white54),
                SizedBox(width: 12),
                Icon(CupertinoIcons.doc_on_doc, size: 14, color: Colors.white54),
                SizedBox(width: 12),
                Icon(CupertinoIcons.trash, size: 14, color: Colors.white54),
                Spacer(),
                Icon(CupertinoIcons.line_horizontal_3_decrease, size: 14, color: Colors.white54),
              ],
            ),
          ),

          // 주소창 영역
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.arrow_left, size: 14, color: Colors.white54),
                const SizedBox(width: 8),
                const Icon(CupertinoIcons.arrow_up, size: 14, color: Colors.white54),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: const Row(
                      children: [
                        Icon(CupertinoIcons.folder_fill, size: 12, color: Color(0xFF60A5FA)),
                        SizedBox(width: 6),
                        Text('내 PC > 즐겨찾기 템플릿', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 본문 (좌측 탐색 창 + 우측 파일 뷰)
          Expanded(
            child: Row(
              children: [
                // 좌측 탐색 패널
                Container(
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.02),
                    border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text('즐겨찾기', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      ..._quickAccess.map((item) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            child: Row(
                              children: [
                                Icon(item['icon'] as IconData, size: 14, color: item['color'] as Color),
                                const SizedBox(width: 8),
                                Text(item['title'] as String, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),

                // 우측 파일 목록
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _templateFiles.length,
                    itemBuilder: (context, index) {
                      final file = _templateFiles[index];
                      return InkWell(
                        onTap: () {
                          final type = file['type'] as String;
                          widget.onOpenTemplate?.call(type);
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Row(
                            children: [
                              Icon(file['icon'] as IconData, size: 18, color: file['color'] as Color),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(file['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                              ),
                              Text(file['size'] as String, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
