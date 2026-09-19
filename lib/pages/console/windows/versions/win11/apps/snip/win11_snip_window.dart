import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/win11_window_frame.dart';

enum SnipMode { rectangle, window, fullScreen, freeform }
enum SnipTool { none, pen, highlighter, eraser, ruler }

class SnipStroke {
  final List<Offset> points;
  final Color color;
  final double width;
  final bool isHighlighter;

  SnipStroke({
    required this.points,
    required this.color,
    required this.width,
    this.isHighlighter = false,
  });
}

/// Windows 11 순정 캡처 도구 (Snipping Tool)
class Win11SnipWindow extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(int layoutType, int zoneIndex)? onSnapLayout;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;
  final bool isMaximized;

  const Win11SnipWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onSnapLayout,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 720,
    this.height = 500,
    this.isMaximized = false,
  });

  @override
  State<Win11SnipWindow> createState() => _Win11SnipWindowState();
}

class _Win11SnipWindowState extends State<Win11SnipWindow> {
  SnipMode _currentMode = SnipMode.rectangle;
  int _delaySeconds = 0;
  bool _isSnappingActive = false;
  int _countdown = 0;

  // 캡처 드래그 영역
  Offset? _snipStart;
  Offset? _snipEnd;

  // 편집 도구 상태
  SnipTool _activeTool = SnipTool.pen;
  Color _penColor = const Color(0xFFFF3B30); // 기본 빨간색 펜
  final double _penWidth = 3.0;
  final Color _highlighterColor = const Color(0xFFFFEB3B); // 형광 노랑
  final double _highlighterWidth = 14.0;
  bool _showRuler = false;

  // 드로잉 스트로크 데이터
  final List<SnipStroke> _strokes = [];
  final List<SnipStroke> _undoneStrokes = [];

  // 알림 메시지
  String? _toastMessage;

  void _showToast(String msg) {
    setState(() => _toastMessage = msg);
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() => _toastMessage = null);
      }
    });
  }

  void _startSnip() {
    if (_delaySeconds > 0) {
      setState(() => _countdown = _delaySeconds);
      _runCountdown();
    } else {
      setState(() {
        _isSnappingActive = true;
        _snipStart = null;
        _snipEnd = null;
      });
    }
  }

  void _runCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (_countdown > 1) {
        setState(() => _countdown--);
        _runCountdown();
      } else {
        setState(() {
          _countdown = 0;
          _isSnappingActive = true;
          _snipStart = null;
          _snipEnd = null;
        });
      }
    });
  }

  void _finishSnip() {
    setState(() {
      _isSnappingActive = false;
      _strokes.clear();
      _undoneStrokes.clear();
    });
    _showToast('새 캡처가 완료되었습니다');
  }

  @override
  Widget build(BuildContext context) {
    return Win11WindowFrame(
      title: '캡처 도구',
      iconAsset: 'assets/images/windows/snip.png',
      width: widget.width,
      height: widget.height,
      isMaximized: widget.isMaximized,
      onClose: widget.onClose,
      onMinimize: widget.onMinimize,
      onMaximize: widget.onMaximize,
      onSnapLayout: widget.onSnapLayout,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Container(
        color: const Color(0xFF202020),
        child: Stack(
          children: [
            Column(
              children: [
                // 상단 Windows 11 Fluent 툴바
                _buildTopToolbar(),
                const Divider(height: 1, color: Color(0xFF2F2F2F)),

                // 캡처 프리뷰 및 편집 캔버스 영역
                Expanded(
                  child: _buildCanvasArea(),
                ),

                // 하단 상태바
                _buildStatusBar(),
              ],
            ),

            // 스크린샷 캡처 오버레이 모드
            if (_isSnappingActive) _buildSnipOverlay(),

            // 카운트다운 오버레이
            if (_countdown > 0)
              Positioned.fill(
                child: Container(
                  color: Colors.black45,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF3F3F46)),
                      ),
                      child: Text(
                        '$_countdown',
                        style: const TextStyle(
                          color: Color(0xFF60CDFF),
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // 플로팅 토스트 알림
            if (_toastMessage != null)
              Positioned(
                bottom: 36,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF0078D7)),
                      boxShadow: const [
                        BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Color(0xFF60CDFF), size: 16),
                        const SizedBox(width: 8),
                        Text(
                          _toastMessage!,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopToolbar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      color: const Color(0xFF272727),
      child: Row(
        children: [
          // "+ 새 캡처" 알약 버튼
          InkWell(
            onTap: _startSnip,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF0078D7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(CupertinoIcons.camera_fill, size: 14, color: Colors.white),
                  SizedBox(width: 6),
                  Text(
                    '새 캡처',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          // 캡처 모드 선택 메뉴
          PopupMenuButton<SnipMode>(
            initialValue: _currentMode,
            tooltip: '캡처 모드',
            color: const Color(0xFF2C2C2C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onSelected: (mode) => setState(() => _currentMode = mode),
            itemBuilder: (context) => [
              const PopupMenuItem(value: SnipMode.rectangle, child: Text('사각형 캡처', style: TextStyle(color: Colors.white, fontSize: 12))),
              const PopupMenuItem(value: SnipMode.window, child: Text('창 캡처', style: TextStyle(color: Colors.white, fontSize: 12))),
              const PopupMenuItem(value: SnipMode.fullScreen, child: Text('전체 화면 캡처', style: TextStyle(color: Colors.white, fontSize: 12))),
              const PopupMenuItem(value: SnipMode.freeform, child: Text('자유형 캡처', style: TextStyle(color: Colors.white, fontSize: 12))),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_getModeIcon(_currentMode), size: 14, color: Colors.white70),
                  const SizedBox(width: 4),
                  Text(_getModeLabel(_currentMode), style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  const Icon(CupertinoIcons.chevron_down, size: 10, color: Colors.white54),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // 지연 타이머 메뉴
          PopupMenuButton<int>(
            initialValue: _delaySeconds,
            tooltip: '지연 캡처',
            color: const Color(0xFF2C2C2C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onSelected: (sec) => setState(() => _delaySeconds = sec),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 0, child: Text('지연 없음', style: TextStyle(color: Colors.white, fontSize: 12))),
              PopupMenuItem(value: 3, child: Text('3초 후 캡처', style: TextStyle(color: Colors.white, fontSize: 12))),
              PopupMenuItem(value: 5, child: Text('5초 후 캡처', style: TextStyle(color: Colors.white, fontSize: 12))),
              PopupMenuItem(value: 10, child: Text('10초 후 캡처', style: TextStyle(color: Colors.white, fontSize: 12))),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(CupertinoIcons.timer, size: 14, color: Colors.white70),
                  const SizedBox(width: 4),
                  Text(_delaySeconds == 0 ? '즉시' : '$_delaySeconds초', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  const Icon(CupertinoIcons.chevron_down, size: 10, color: Colors.white54),
                ],
              ),
            ),
          ),

          const Spacer(),

          // 편집 도구들 (볼펜, 형광펜, 지우개, 눈금자)
          _buildToolBtn(
            icon: CupertinoIcons.pencil,
            label: '볼펜',
            isSelected: _activeTool == SnipTool.pen,
            indicatorColor: _penColor,
            onTap: () => setState(() => _activeTool = SnipTool.pen),
            onLongPress: _showPenSettings,
          ),
          const SizedBox(width: 4),
          _buildToolBtn(
            icon: CupertinoIcons.paintbrush,
            label: '형광펜',
            isSelected: _activeTool == SnipTool.highlighter,
            indicatorColor: _highlighterColor,
            onTap: () => setState(() => _activeTool = SnipTool.highlighter),
          ),
          const SizedBox(width: 4),
          _buildToolBtn(
            icon: CupertinoIcons.bandage,
            label: '지우개',
            isSelected: _activeTool == SnipTool.eraser,
            onTap: () => setState(() => _activeTool = SnipTool.eraser),
          ),
          const SizedBox(width: 4),
          _buildToolBtn(
            icon: CupertinoIcons.pencil_outline,
            label: '눈금자',
            isSelected: _showRuler,
            onTap: () => setState(() => _showRuler = !_showRuler),
          ),

          const SizedBox(width: 8),
          Container(width: 1, height: 20, color: Colors.white24),
          const SizedBox(width: 8),

          // 실행 취소 / 다시 실행
          IconButton(
            icon: const Icon(CupertinoIcons.arrow_uturn_left, size: 15, color: Colors.white70),
            tooltip: '실행 취소',
            onPressed: _strokes.isNotEmpty
                ? () {
                    setState(() {
                      _undoneStrokes.add(_strokes.removeLast());
                    });
                  }
                : null,
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.arrow_uturn_right, size: 15, color: Colors.white70),
            tooltip: '다시 실행',
            onPressed: _undoneStrokes.isNotEmpty
                ? () {
                    setState(() {
                      _strokes.add(_undoneStrokes.removeLast());
                    });
                  }
                : null,
          ),

          const SizedBox(width: 8),
          Container(width: 1, height: 20, color: Colors.white24),
          const SizedBox(width: 8),

          // 복사 / 저장 / 공유
          IconButton(
            icon: const Icon(CupertinoIcons.doc_on_doc, size: 15, color: Colors.white70),
            tooltip: '클립보드에 복사',
            onPressed: () {
              Clipboard.setData(const ClipboardData(text: 'FictionScreen 캡처 이미지'));
              _showToast('클립보드에 복사되었습니다');
            },
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.floppy_disk, size: 15, color: Colors.white70),
            tooltip: '이미지 저장',
            onPressed: () {
              _showToast('캡처 이미지가 다운로드 폴더에 저장되었습니다');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToolBtn({
    required IconData icon,
    required String label,
    required bool isSelected,
    Color? indicatorColor,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
  }) {
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF383838) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: isSelected ? Border.all(color: const Color(0xFF60CDFF).withValues(alpha: 0.6)) : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: isSelected ? const Color(0xFF60CDFF) : Colors.white70),
              if (indicatorColor != null) ...[
                const SizedBox(height: 2),
                Container(width: 12, height: 2, color: indicatorColor),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showPenSettings() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF272727),
        title: const Text('볼펜 설정', style: TextStyle(color: Colors.white, fontSize: 14)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('색상 선택', style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Color(0xFFFF3B30),
                const Color(0xFF0078D7),
                const Color(0xFF10B981),
                const Color(0xFFF59E0B),
                Colors.white,
                Colors.black,
              ].map((c) {
                final isCur = _penColor == c;
                return InkWell(
                  onTap: () {
                    setState(() => _penColor = c);
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(color: isCur ? Colors.cyanAccent : Colors.white30, width: isCur ? 2 : 1),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCanvasArea() {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2C2C2C)),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onPanStart: (details) {
              if (_activeTool == SnipTool.eraser) {
                _eraseNear(details.localPosition);
                return;
              }
              if (_activeTool == SnipTool.none) return;

              final isHl = _activeTool == SnipTool.highlighter;
              final stroke = SnipStroke(
                points: [details.localPosition],
                color: isHl ? _highlighterColor.withValues(alpha: 0.35) : _penColor,
                width: isHl ? _highlighterWidth : _penWidth,
                isHighlighter: isHl,
              );
              setState(() {
                _strokes.add(stroke);
                _undoneStrokes.clear();
              });
            },
            onPanUpdate: (details) {
              if (_activeTool == SnipTool.eraser) {
                _eraseNear(details.localPosition);
                return;
              }
              if (_strokes.isNotEmpty) {
                setState(() {
                  _strokes.last.points.add(details.localPosition);
                });
              }
            },
            child: Stack(
              children: [
                // 배경 모의 캡처 캔버스 (소설/인증 데스크톱 캡처 템플릿)
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1A1A24), Color(0xFF0D0D14)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: constraints.maxWidth * 0.85,
                        height: constraints.maxHeight * 0.75,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF21232B),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF333544)),
                          boxShadow: const [
                            BoxShadow(color: Colors.black38, blurRadius: 20, offset: Offset(0, 10)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(color: Color(0xFF0078D7), shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'FictionScreen 캡처 화면 프리뷰',
                                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0078D7).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text('1920 x 1080', style: TextStyle(color: Color(0xFF60CDFF), fontSize: 10)),
                                ),
                              ],
                            ),
                            const Divider(color: Color(0xFF333544), height: 24),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.photo_on_rectangle, size: 48, color: Colors.white.withValues(alpha: 0.15)),
                                    const SizedBox(height: 12),
                                    const Text(
                                      '원하는 도구를 선택해 캡처본 위에 메모하거나 형광펜으로 강조하세요.',
                                      style: TextStyle(color: Colors.white54, fontSize: 12),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      '상단의 "+ 새 캡처" 버튼을 누르면 언제든 새로운 영역을 지정 캡처할 수 있습니다.',
                                      style: TextStyle(color: Colors.white38, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // 유저 드로잉 렌더러
                Positioned.fill(
                  child: CustomPaint(
                    painter: _SnipPainter(strokes: _strokes),
                  ),
                ),

                // 가상 눈금자
                if (_showRuler)
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.yellow.withValues(alpha: 0.85),
                        border: Border.all(color: Colors.black45),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
                      ),
                      child: Row(
                        children: List.generate(
                          30,
                          (i) => Expanded(
                            child: Container(
                              alignment: Alignment.topCenter,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(width: 1, height: i % 5 == 0 ? 14 : 7, color: Colors.black87),
                                  if (i % 5 == 0)
                                    Text('$i', style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold))
                                  else
                                    const SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _eraseNear(Offset pt) {
    setState(() {
      _strokes.removeWhere((st) => st.points.any((p) => (p - pt).distance < 20));
    });
  }

  Widget _buildSnipOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: (details) {
          setState(() {
            _snipStart = details.localPosition;
            _snipEnd = details.localPosition;
          });
        },
        onPanUpdate: (details) {
          setState(() {
            _snipEnd = details.localPosition;
          });
        },
        onPanEnd: (_) {
          _finishSnip();
        },
        child: Container(
          color: Colors.black54,
          child: Stack(
            children: [
              // 안내 텍스트
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF60CDFF)),
                    ),
                    child: Text(
                      '캡처할 영역을 드래그하세요 (${_getModeLabel(_currentMode)})',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),

              // 선택 박스
              if (_snipStart != null && _snipEnd != null)
                Positioned(
                  left: math.min(_snipStart!.dx, _snipEnd!.dx),
                  top: math.min(_snipStart!.dy, _snipEnd!.dy),
                  width: (_snipStart!.dx - _snipEnd!.dx).abs(),
                  height: (_snipStart!.dy - _snipEnd!.dy).abs(),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF60CDFF), width: 1.5),
                      color: Colors.transparent,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      color: const Color(0xFF1B1B1B),
      child: Row(
        children: [
          const Text('준비 완료', style: TextStyle(color: Colors.white54, fontSize: 11)),
          const Spacer(),
          Text('스트로크: ${_strokes.length}', style: const TextStyle(color: Colors.white38, fontSize: 11)),
          const SizedBox(width: 14),
          Text(_getModeLabel(_currentMode), style: const TextStyle(color: Colors.white54, fontSize: 11)),
        ],
      ),
    );
  }

  IconData _getModeIcon(SnipMode mode) {
    switch (mode) {
      case SnipMode.rectangle:
        return CupertinoIcons.crop;
      case SnipMode.window:
        return CupertinoIcons.rectangle_on_rectangle_angled;
      case SnipMode.fullScreen:
        return CupertinoIcons.fullscreen;
      case SnipMode.freeform:
        return CupertinoIcons.scribble;
    }
  }

  String _getModeLabel(SnipMode mode) {
    switch (mode) {
      case SnipMode.rectangle:
        return '사각형';
      case SnipMode.window:
        return '창';
      case SnipMode.fullScreen:
        return '전체 화면';
      case SnipMode.freeform:
        return '자유형';
    }
  }
}

class _SnipPainter extends CustomPainter {
  final List<SnipStroke> strokes;

  _SnipPainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      if (stroke.points.length < 2) continue;

      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      final path = Path();
      path.moveTo(stroke.points.first.dx, stroke.points.first.dy);
      for (int i = 1; i < stroke.points.length; i++) {
        path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SnipPainter oldDelegate) => true;
}
