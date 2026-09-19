import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import '../../../apps/screen_template.dart';
import '../../../managers/export_manager.dart';
import '../../../services/app_theme_service.dart';

enum ScreenAspectRatio {
  r9_16('9:16', '스마트폰 세로', 390, 844),
  r16_9('16:9', '가로 와이드', 844, 475),
  r1_1('1:1', '정사각형', 560, 560),
  r4_3('4:3', '태블릿 가로', 720, 540),
  r3_4('3:4', '태블릿 세로', 540, 720),
  r21_9('21:9', '울트라와이드', 920, 394);

  final String label;
  final String desc;
  final double width;
  final double height;

  const ScreenAspectRatio(this.label, this.desc, this.width, this.height);
}

/// Universal Figma-like Full-Screen Editor Shell
/// Shared across all 33 screen applications.
class AppEditorShell extends StatefulWidget {
  final ScreenTemplate template;
  final String? documentTitle;
  final String? documentId;
  final Widget Function(BuildContext context, bool isDarkMode) canvasBuilder;
  final Widget Function(BuildContext context, bool isDarkMode) inspectorBuilder;
  final Widget Function(BuildContext context, bool isDarkMode)? layersBuilder;
  final Function(String osKey) onOpenInOs;
  final VoidCallback onBackToGallery;
  final List<Widget> extraTopBarActions;
  final bool initialDarkMode;

  const AppEditorShell({
    super.key,
    required this.template,
    this.documentTitle,
    this.documentId,
    required this.canvasBuilder,
    required this.inspectorBuilder,
    this.layersBuilder,
    required this.onOpenInOs,
    required this.onBackToGallery,
    this.extraTopBarActions = const [],
    this.initialDarkMode = true,
  });

  @override
  State<AppEditorShell> createState() => _AppEditorShellState();
}

class _AppEditorShellState extends State<AppEditorShell> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool get _isDarkMode => AppThemeService.instance.isDarkMode(context);
  double _zoomScale = 1.0;
  Offset _panOffset = Offset.zero;
  bool _isHoveringArtboard = false;
  bool _isExporting = false;

  late ScreenAspectRatio _currentRatio;

  @override
  void initState() {
    super.initState();
    _currentRatio = widget.template.isDesktop ? ScreenAspectRatio.r16_9 : ScreenAspectRatio.r9_16;
  }

  void _zoomIn() {
    setState(() {
      _zoomScale = (_zoomScale + 0.1).clamp(0.25, 3.0);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomScale = (_zoomScale - 0.1).clamp(0.25, 3.0);
    });
  }

  void _resetZoom() {
    setState(() {
      _zoomScale = 1.0;
      _panOffset = Offset.zero;
    });
  }

  void _handleWheelZoom(double dy) {
    setState(() {
      if (dy < 0) {
        _zoomScale = (_zoomScale + 0.08).clamp(0.25, 3.0);
      } else if (dy > 0) {
        _zoomScale = (_zoomScale - 0.08).clamp(0.25, 3.0);
      }
    });
  }

  Future<void> _exportScreen() async {
    setState(() => _isExporting = true);
    final filename = '${widget.template.id}_figma_artboard_${DateTime.now().millisecondsSinceEpoch}.png';
    final success = await ExportManager.captureAndDownload(
      controller: _screenshotController,
      filename: filename,
    );
    setState(() => _isExporting = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? '고해상도 아트보드 캡처가 성공적으로 저장되었습니다!' : '캡처 저장에 실패했습니다.'),
          backgroundColor: success ? const Color(0xFF10B981) : Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final template = widget.template;

    final bgColor = _isDarkMode ? const Color(0xFF07090E) : const Color(0xFFE5E9F0);
    final topBarBgColor = _isDarkMode ? const Color(0xCC0E121B) : const Color(0xCCFFFFFF);
    final textColor = _isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = _isDarkMode ? Colors.white54 : const Color(0xFF64748B);
    final buttonBgColor = _isDarkMode ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFF1F5F9);

    final artboardWidth = _currentRatio.width;
    final artboardHeight = _currentRatio.height;

    // Remove all scrollbars throughout the editor
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(scrollbars: false),
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            // 1. Figma-style Top Toolbar with Blur (ZERO OUTLINE)
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  height: 58,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: topBarBgColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: _isDarkMode ? 0.3 : 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Back to App Gallery button
                      InkWell(
                        onTap: widget.onBackToGallery,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            color: buttonBgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.arrow_left, size: 14, color: textColor),
                              const SizedBox(width: 6),
                              Text(
                                '콘솔 목록',
                                style: TextStyle(color: textColor, fontSize: 12.5, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),
                      Text('/', style: TextStyle(color: textSubColor.withValues(alpha: 0.4), fontSize: 16)),
                      const SizedBox(width: 12),

                      // App Title & Tag
                      Container(
                        width: 28,
                        height: 28,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: template.themeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Center(
                          child: template.imageAsset != null
                              ? Image.asset(template.imageAsset!, fit: BoxFit.contain)
                              : Icon(template.icon, color: template.themeColor, size: 15),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        template.title,
                        style: TextStyle(color: textColor, fontSize: 14.5, fontWeight: FontWeight.w800, letterSpacing: -0.3),
                      ),
                      if (widget.documentTitle != null) ...[
                        const SizedBox(width: 8),
                        Text('•', style: TextStyle(color: textSubColor.withValues(alpha: 0.5), fontSize: 14)),
                        const SizedBox(width: 8),
                        Text(
                          widget.documentTitle!,
                          style: const TextStyle(color: Color(0xFF6366F1), fontSize: 13.5, fontWeight: FontWeight.w700),
                        ),
                      ],
                      if (widget.documentId != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            widget.documentId!.length > 18
                                ? 'DOC: ...${widget.documentId!.substring(widget.documentId!.length - 8)}'
                                : 'DOC: ${widget.documentId}',
                            style: const TextStyle(color: Color(0xFF818CF8), fontSize: 9.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          'FIGMA CANVAS',
                          style: TextStyle(color: Color(0xFF00B0FF), fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: 0.8),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Aspect Ratio Selector Dropdown (Req: "화면 비율 좌상단 아이콘만들어서 변경할 수 있게 해. 1:1 ~ 16:9, 9:16 등등")
                      _buildAspectRatioSelector(textColor, buttonBgColor),

                      const Spacer(),

                      // Canvas Zoom Controls (Figma-style: Ctrl + Wheel hint)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                        decoration: BoxDecoration(
                          color: buttonBgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: '축소 (-)',
                              icon: const Icon(CupertinoIcons.minus, size: 13),
                              color: textColor,
                              onPressed: _zoomOut,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                            ),
                            Tooltip(
                              message: 'Ctrl + 휠로 줌 조절 가능\n클릭 시 100% 및 위치 리셋',
                              child: InkWell(
                                onTap: _resetZoom,
                                borderRadius: BorderRadius.circular(5),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                  child: Text(
                                    '${(_zoomScale * 100).toInt()}%',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: '확대 (+)',
                              icon: const Icon(CupertinoIcons.plus, size: 13),
                              color: textColor,
                              onPressed: _zoomIn,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Theme Toggle
                      IconButton(
                        tooltip: _isDarkMode ? '라이트 모드로 전환' : '다크 모드로 전환',
                        icon: Icon(
                          _isDarkMode ? CupertinoIcons.sun_max_fill : CupertinoIcons.moon_fill,
                          size: 15,
                          color: _isDarkMode ? const Color(0xFFFACC15) : const Color(0xFF64748B),
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: buttonBgColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => AppThemeService.instance.toggleTheme(context),
                      ),

                      const SizedBox(width: 10),

                      // Open in Virtual OS Button
                      Tooltip(
                        message: '가상 OS 화면으로 이동하여 이 앱을 플로팅 창으로 실행합니다',
                        child: InkWell(
                          onTap: () => widget.onOpenInOs('windows_11'),
                          borderRadius: BorderRadius.circular(9),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: _isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFE0F2FE),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.macwindow,
                                  size: 14,
                                  color: _isDarkMode ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'OS 창으로 실행',
                                  style: TextStyle(
                                    color: _isDarkMode ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      // High-Res PNG Export Button
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                        ),
                        icon: _isExporting
                            ? const SizedBox(width: 13, height: 13, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(CupertinoIcons.arrow_down_doc_fill, size: 14),
                        label: Text(
                          _isExporting ? '저장 중...' : 'PNG 캡처 저장',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                        ),
                        onPressed: _isExporting ? null : _exportScreen,
                      ),

                      if (widget.extraTopBarActions.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        ...widget.extraTopBarActions,
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // 2. Editor Body: Left Layers + Center Canvas + Right Inspector (ZERO OUTLINE)
            Expanded(
              child: Row(
                children: [
                  // Left Figma Layers/Objects Panel (ZERO OUTLINE)
                  if (widget.layersBuilder != null)
                    Container(
                      width: 260,
                      decoration: BoxDecoration(
                        color: _isDarkMode ? const Color(0xFF0F1219) : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: _isDarkMode ? 0.25 : 0.03),
                            blurRadius: 10,
                            offset: const Offset(2, 0),
                          ),
                        ],
                      ),
                      child: widget.layersBuilder!(context, _isDarkMode),
                    ),

                  // Center Figma-style Canvas (Square Grid, Ctrl + Wheel Zoom, NO SCROLLBAR)
                  Expanded(
                    child: ClipRect(
                      child: Stack(
                        children: [
                          // Canvas Background: Square Grid with Pan and Ctrl+Wheel Zoom
                          Positioned.fill(
                            child: Listener(
                              onPointerSignal: (pointerSignal) {
                                if (pointerSignal is PointerScrollEvent) {
                                  final isCtrl = HardwareKeyboard.instance.isControlPressed ||
                                      HardwareKeyboard.instance.isMetaPressed;
                                  // Req: "컨트롤 휠 눌러야 확대 축소되게 하고"
                                  if (isCtrl) {
                                    _handleWheelZoom(pointerSignal.scrollDelta.dy);
                                  } else if (!_isHoveringArtboard) {
                                    // Regular wheel on background: pan vertically
                                    setState(() {
                                      _panOffset += Offset(0, -pointerSignal.scrollDelta.dy);
                                    });
                                  }
                                }
                              },
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onPanUpdate: (details) {
                                  setState(() {
                                    _panOffset += details.delta;
                                  });
                                },
                                child: CustomPaint(
                                  painter: _FigmaSquareGridPainter(
                                    isDarkMode: _isDarkMode,
                                    offset: _panOffset,
                                    zoomScale: _zoomScale,
                                  ),
                                  child: Container(),
                                ),
                              ),
                            ),
                          ),

                          // Centered Artboard with pan offset and scale
                          Positioned.fill(
                            child: Center(
                              child: Transform.translate(
                                offset: _panOffset,
                                child: Transform.scale(
                                  scale: _zoomScale,
                                  child: MouseRegion(
                                    onEnter: (_) => setState(() => _isHoveringArtboard = true),
                                    onExit: (_) => setState(() => _isHoveringArtboard = false),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Dimension indicator label above artboard
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 12),
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _isDarkMode
                                                ? Colors.white.withValues(alpha: 0.08)
                                                : Colors.black.withValues(alpha: 0.05),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            '${_currentRatio.label} (${_currentRatio.desc}) • ${artboardWidth.toInt()} × ${artboardHeight.toInt()} px',
                                            style: TextStyle(
                                              color: textSubColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                        ),

                                        // Actual Artboard wrapped in Screenshot
                                        Screenshot(
                                          controller: _screenshotController,
                                          child: Container(
                                            width: artboardWidth,
                                            height: artboardHeight,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              color: _isDarkMode ? Colors.black : Colors.white,
                                              borderRadius: BorderRadius.circular(16),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: _isDarkMode ? 0.6 : 0.16),
                                                  blurRadius: 44,
                                                  offset: const Offset(0, 16),
                                                ),
                                              ],
                                            ),
                                            child: widget.canvasBuilder(context, _isDarkMode),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Right Figma Inspector Panel (ZERO OUTLINE)
                  Container(
                    width: 340,
                    decoration: BoxDecoration(
                      color: _isDarkMode ? const Color(0xFF0F1219) : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: _isDarkMode ? 0.25 : 0.03),
                          blurRadius: 10,
                          offset: const Offset(-2, 0),
                        ),
                      ],
                    ),
                    child: widget.inspectorBuilder(context, _isDarkMode),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAspectRatioSelector(Color textColor, Color buttonBgColor) {
    return PopupMenuButton<ScreenAspectRatio>(
      tooltip: '화면 비율 변경 (1:1, 16:9, 9:16 등)',
      color: _isDarkMode ? const Color(0xFF161A23) : Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      offset: const Offset(0, 40),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: buttonBgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.aspect_ratio, size: 15, color: Color(0xFF00B0FF)),
            const SizedBox(width: 6),
            Text(
              _currentRatio.label,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Icon(CupertinoIcons.chevron_down, size: 10, color: textColor.withValues(alpha: 0.5)),
          ],
        ),
      ),
      onSelected: (ratio) {
        setState(() {
          _currentRatio = ratio;
        });
      },
      itemBuilder: (context) {
        return ScreenAspectRatio.values.map((ratio) {
          final isSelected = ratio == _currentRatio;
          return PopupMenuItem<ScreenAspectRatio>(
            value: ratio,
            height: 38,
            child: Row(
              children: [
                Text(
                  ratio.label,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF00B0FF) : textColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${ratio.desc} (${ratio.width.toInt()}×${ratio.height.toInt()})',
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF00B0FF).withValues(alpha: 0.8) : textColor.withValues(alpha: 0.5),
                    fontSize: 11,
                  ),
                ),
                if (isSelected) ...[
                  const Spacer(),
                  const Icon(CupertinoIcons.checkmark_alt, size: 14, color: Color(0xFF00B0FF)),
                ],
              ],
            ),
          );
        }).toList();
      },
    );
  }
}

/// Crisp Square Grid Painter for Figma Canvas (Req: "배경에 격자 그리드 추가하고")
class _FigmaSquareGridPainter extends CustomPainter {
  final bool isDarkMode;
  final Offset offset;
  final double zoomScale;

  const _FigmaSquareGridPainter({
    required this.isDarkMode,
    required this.offset,
    required this.zoomScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final majorPaint = Paint()
      ..color = isDarkMode
          ? Colors.white.withValues(alpha: 0.05)
          : Colors.black.withValues(alpha: 0.04)
      ..strokeWidth = 1.0;

    final minorPaint = Paint()
      ..color = isDarkMode
          ? Colors.white.withValues(alpha: 0.02)
          : Colors.black.withValues(alpha: 0.02)
      ..strokeWidth = 0.5;

    const baseStep = 24.0;
    final step = baseStep * zoomScale;
    if (step < 6) return;

    final startX = (offset.dx % step) - step;
    final startY = (offset.dy % step) - step;

    int col = 0;
    for (double x = startX; x < size.width + step; x += step, col++) {
      final paint = (col % 4 == 0) ? majorPaint : minorPaint;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    int row = 0;
    for (double y = startY; y < size.height + step; y += step, row++) {
      final paint = (row % 4 == 0) ? majorPaint : minorPaint;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FigmaSquareGridPainter oldDelegate) {
    return oldDelegate.isDarkMode != isDarkMode ||
        oldDelegate.offset != offset ||
        oldDelegate.zoomScale != zoomScale;
  }
}
