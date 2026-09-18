import 'package:flutter/material.dart';

/// 바탕화면 아이콘 데이터 모델 (시스템 앱/폴더 구분 및 리네임 지원)
class DesktopIconItem {
  final String id;
  String title;
  final IconData? icon;
  final String? imageAsset;
  final Color iconColor;
  int gridX; // 열 인덱스 (0, 1, 2, ...)
  int gridY; // 행 인덱스 (0, 1, 2, ...)
  final VoidCallback onTap;
  final bool isSystemApp; // 기본 앱 여부 (기본 앱은 이름 변경 불가)
  final bool isFolder; // 폴더 여부

  DesktopIconItem({
    required this.id,
    required this.title,
    this.icon,
    this.imageAsset,
    this.iconColor = const Color(0xFF60A5FA),
    required this.gridX,
    required this.gridY,
    required this.onTap,
    this.isSystemApp = true,
    this.isFolder = false,
  });
}

/// 실제 윈도우 스타일 바탕화면 아이콘 위젯 (투명 아이콘 본체 + 외곽 호버/선택 박스 + 마우스 추적 드래그)
class WindowsDesktopIconWidget extends StatefulWidget {
  final DesktopIconItem item;
  final bool isSelected;
  final bool isRenaming;
  final ValueChanged<String> onRenameSubmitted;
  final VoidCallback onCancelRename;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;
  final Function(TapUpDetails details) onSecondaryTapUp;
  final Function(Offset totalDelta) onDragEnd;
  final VoidCallback? onDragStart;

  const WindowsDesktopIconWidget({
    super.key,
    required this.item,
    required this.isSelected,
    required this.isRenaming,
    required this.onRenameSubmitted,
    required this.onCancelRename,
    required this.onTap,
    required this.onDoubleTap,
    required this.onSecondaryTapUp,
    required this.onDragEnd,
    this.onDragStart,
  });

  @override
  State<WindowsDesktopIconWidget> createState() => _WindowsDesktopIconWidgetState();
}

class _WindowsDesktopIconWidgetState extends State<WindowsDesktopIconWidget> {
  bool _isHovered = false;
  bool _isDragging = false;
  Offset _dragDelta = Offset.zero;
  late TextEditingController _renameCtrl;
  late FocusNode _renameFocus;

  @override
  void initState() {
    super.initState();
    _renameCtrl = TextEditingController(text: widget.item.title);
    _renameFocus = FocusNode();
    if (widget.isRenaming) {
      _renameFocus.requestFocus();
      _renameCtrl.selection = TextSelection(baseOffset: 0, extentOffset: _renameCtrl.text.length);
    }
  }

  @override
  void didUpdateWidget(covariant WindowsDesktopIconWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRenaming && !oldWidget.isRenaming) {
      _renameCtrl.text = widget.item.title;
      _renameFocus.requestFocus();
      _renameCtrl.selection = TextSelection(baseOffset: 0, extentOffset: _renameCtrl.text.length);
    }
  }

  @override
  void dispose() {
    _renameCtrl.dispose();
    _renameFocus.dispose();
    super.dispose();
  }

  void _submitRename() {
    final text = _renameCtrl.text.trim();
    if (text.isNotEmpty) {
      widget.onRenameSubmitted(text);
    } else {
      widget.onCancelRename();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 호버/선택 상태에 따른 Windows 11 글래스 사각 박스 색상
    final Color bgColor = widget.isSelected
        ? const Color(0x3DCCE8FF)
        : (_isHovered ? const Color(0x24CCE8FF) : Colors.transparent);

    final Border border = widget.isSelected
        ? Border.all(color: const Color(0x9999D1FF), width: 1.0)
        : (_isHovered
            ? Border.all(color: const Color(0x5599D1FF), width: 1.0)
            : Border.all(color: Colors.transparent, width: 1.0));

    return Transform.translate(
      offset: _dragDelta,
      child: Opacity(
        opacity: _isDragging ? 0.8 : 1.0,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.onTap,
            onDoubleTap: widget.onDoubleTap,
            onSecondaryTapUp: widget.onSecondaryTapUp,
            // 마우스 드래그 시 실시간 마우스 위치 추적
            onPanStart: (details) {
              setState(() {
                _isDragging = true;
                _dragDelta = Offset.zero;
              });
              widget.onDragStart?.call();
            },
            onPanUpdate: (details) {
              setState(() {
                _dragDelta += details.delta;
              });
            },
            onPanEnd: (details) {
              final finalDelta = _dragDelta;
              setState(() {
                _isDragging = false;
                _dragDelta = Offset.zero;
              });
              widget.onDragEnd(finalDelta);
            },
            child: Container(
              width: 80,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(4),
                border: border,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. 아이콘 본체 (배경 둥근 박스 없이 실제 윈도우처럼 아이콘만 투명하게 렌더링)
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(
                      child: widget.item.imageAsset != null
                          ? Image.asset(
                              widget.item.imageAsset!,
                              width: 44,
                              height: 44,
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.high,
                            )
                          : Icon(
                              widget.item.icon ?? Icons.folder,
                              color: widget.item.iconColor,
                              size: 40,
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // 2. 텍스트 라벨 또는 인라인 이름 변경 입력창
                  if (widget.isRenaming)
                    Container(
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2028),
                        border: Border.all(color: const Color(0xFF60A5FA), width: 1.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: TextField(
                        controller: _renameCtrl,
                        focusNode: _renameFocus,
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSubmitted: (_) => _submitRename(),
                      ),
                    )
                  else
                    Text(
                      widget.item.title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                        shadows: [
                          Shadow(color: Colors.black, blurRadius: 4, offset: Offset(1, 1)),
                          Shadow(color: Colors.black87, blurRadius: 2),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
