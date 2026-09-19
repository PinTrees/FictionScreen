import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import '../../../apps/screen_template.dart';
import '../../../managers/export_manager.dart';

/// Universal Figma-like Full-Screen Editor Shell
/// Shared across all 33 screen applications.
class AppEditorShell extends StatefulWidget {
  final ScreenTemplate template;
  final Widget Function(BuildContext context, bool isDarkMode) canvasBuilder;
  final Widget Function(BuildContext context, bool isDarkMode) inspectorBuilder;
  final VoidCallback onBackToGallery;
  final ValueChanged<String> onOpenInOs;
  final List<Widget> extraTopBarActions;
  final bool initialDarkMode;

  const AppEditorShell({
    super.key,
    required this.template,
    required this.canvasBuilder,
    required this.inspectorBuilder,
    required this.onBackToGallery,
    required this.onOpenInOs,
    this.extraTopBarActions = const [],
    this.initialDarkMode = true,
  });

  @override
  State<AppEditorShell> createState() => _AppEditorShellState();
}

class _AppEditorShellState extends State<AppEditorShell> {
  final ScreenshotController _screenshotController = ScreenshotController();
  late bool _isDarkMode;
  double _zoomScale = 1.0;
  Offset _panOffset = Offset.zero;
  bool _isHoveringArtboard = false;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.initialDarkMode;
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
    final isDesktop = template.isDesktop;

    final bgColor = _isDarkMode ? const Color(0xFF07090E) : const Color(0xFFE5E9F0);
    final topBarBgColor = _isDarkMode ? const Color(0xFF0E121B) : Colors.white;
    final textColor = _isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = _isDarkMode ? Colors.white54 : const Color(0xFF64748B);
    final buttonBgColor = _isDarkMode ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFF1F5F9);

    final artboardWidth = isDesktop ? 1040.0 : 390.0;
    final artboardHeight = isDesktop ? 660.0 : 844.0;

    // Remove all scrollbars throughout the editor
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(scrollbars: false),
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            // 1. Figma-style Top Toolbar (ZERO OUTLINE)
            Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: topBarBgColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: _isDarkMode ? 0.25 : 0.04),
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

                  const SizedBox(width: 14),
                  Text('/', style: TextStyle(color: textSubColor.withValues(alpha: 0.4), fontSize: 16)),
                  const SizedBox(width: 14),

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
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'FIGMA CANVAS',
                      style: TextStyle(color: Color(0xFF6366F1), fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: 0.8),
                    ),
                  ),

                  const Spacer(),

                  // Canvas Zoom Controls (Figma-style)
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
                          message: '클릭 시 100% 및 위치 리셋',
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

                  // Theme Toggle (Sun / Moon)
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
                    onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
                  ),

                  const SizedBox(width: 10),

                  // Open in Virtual OS Button (NO OUTLINE)
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

            // 2. Editor Body: Center Infinite Canvas + Right Property Inspector
            Expanded(
              child: Row(
                children: [
                  // Center Figma-style Canvas (Infinite Pan & Wheel Zoom, NO SCROLLBAR)
                  Expanded(
                    child: ClipRect(
                      child: Stack(
                        children: [
                          // Canvas Background: Dot Grid with Pan and Wheel Zoom
                          Positioned.fill(
                            child: Listener(
                              onPointerSignal: (pointerSignal) {
                                if (pointerSignal is PointerScrollEvent) {
                                  final isCtrl = HardwareKeyboard.instance.isControlPressed ||
                                      HardwareKeyboard.instance.isMetaPressed;
                                  // If Ctrl is held or pointer is outside artboard, zoom canvas!
                                  if (isCtrl || !_isHoveringArtboard) {
                                    _handleWheelZoom(pointerSignal.scrollDelta.dy);
                                  }
                                  // Otherwise when hovering artboard without Ctrl,
                                  // do nothing here to let the inner app's Scrollable (KakaoTalk list) scroll!
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
                                  painter: _FigmaDotGridPainter(
                                    isDarkMode: _isDarkMode,
                                    offset: _panOffset,
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
                                                ? Colors.white.withValues(alpha: 0.07)
                                                : Colors.black.withValues(alpha: 0.05),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            isDesktop
                                                ? 'Desktop Window • ${artboardWidth.toInt()} × ${artboardHeight.toInt()} px'
                                                : 'Mobile Artboard • ${artboardWidth.toInt()} × ${artboardHeight.toInt()} px',
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
                                              borderRadius: BorderRadius.circular(isDesktop ? 12 : 24),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: _isDarkMode ? 0.55 : 0.15),
                                                  blurRadius: 40,
                                                  offset: const Offset(0, 14),
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
}

class _FigmaDotGridPainter extends CustomPainter {
  final bool isDarkMode;
  final Offset offset;

  const _FigmaDotGridPainter({required this.isDarkMode, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDarkMode
          ? Colors.white.withValues(alpha: 0.05)
          : Colors.black.withValues(alpha: 0.04)
      ..style = PaintingStyle.fill;

    const step = 24.0;
    final startX = (offset.dx % step) - step;
    final startY = (offset.dy % step) - step;

    for (double x = startX; x < size.width + step; x += step) {
      for (double y = startY; y < size.height + step; y += step) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FigmaDotGridPainter oldDelegate) {
    return oldDelegate.isDarkMode != isDarkMode || oldDelegate.offset != offset;
  }
}
