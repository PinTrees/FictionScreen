import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import '../../managers/pdf_export_manager.dart';
import 'data/pdf_templates_data.dart';
import 'models/pdf_document_model.dart';
import 'widgets/pdf_a4_page_view.dart';
import 'widgets/pdf_inspector_drawer.dart';

/// PDF 문서 생성 및 뷰어 윈도우 (Acrobat / PDF Reader 스타일)
class PdfViewerWindow extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;
  final bool isMaximized;

  const PdfViewerWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 960,
    this.height = 680,
    this.isMaximized = false,
  });

  @override
  State<PdfViewerWindow> createState() => _PdfViewerWindowState();
}

class _PdfViewerWindowState extends State<PdfViewerWindow> {
  final ScreenshotController _screenshotController = ScreenshotController();
  late PdfDocumentData _currentDoc;
  final List<PdfDocumentData> _allTemplates = PdfTemplatesData.getAllTemplates();

  double _zoomScale = 1.0;
  bool _isInspectorOpen = true; // 기본적으로 설정/폼 편집창 열림
  bool _isExporting = false;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    // 기본으로 '이혼 및 재산분할 합의서' 로드
    _currentDoc = _allTemplates.first.copyWith();
  }

  void _showStatus(String msg) {
    setState(() => _statusMessage = msg);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _statusMessage = null);
    });
  }

  Future<void> _handleExportPdf() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);
    _showStatus('PDF 문서 생성 중...');

    final success = await PdfExportManager.exportToPdf(
      controller: _screenshotController,
      filename: '${_currentDoc.title}_${DateTime.now().millisecondsSinceEpoch}.pdf',
      pixelRatio: 2.8,
    );

    if (mounted) {
      setState(() => _isExporting = false);
      if (success) {
        _showStatus('✅ PDF 파일이 성공적으로 생성 및 다운로드되었습니다!');
      } else {
        _showStatus('❌ PDF 생성 중 오류가 발생했습니다.');
      }
    }
  }

  Future<void> _handleExportPng() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);
    _showStatus('고화질 이미지 저장 중...');

    final success = await PdfExportManager.exportToPng(
      controller: _screenshotController,
      filename: '${_currentDoc.title}.png',
      pixelRatio: 3.0,
    );

    if (mounted) {
      setState(() => _isExporting = false);
      if (success) {
        _showStatus('✅ 고화질 이미지가 다운로드되었습니다!');
      } else {
        _showStatus('❌ 이미지 생성 중 오류가 발생했습니다.');
      }
    }
  }

  void _showTemplateSelectionDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: const Color(0xFF1E222D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF333A4C)),
          ),
          child: Container(
            width: 580,
            constraints: const BoxConstraints(maxHeight: 520),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(CupertinoIcons.doc_text_fill, color: Color(0xFFEF4444), size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      '가상 서식 폼 라이브러리 선택',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(CupertinoIcons.xmark, size: 16, color: Colors.white70),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '원하는 법적/공문서 서식을 선택하면 즉시 A4 규격으로 로드되며 실시간 편집이 가능합니다.',
                  style: TextStyle(color: Colors.white60, fontSize: 11.5),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: ListView.separated(
                    itemCount: _allTemplates.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, idx) {
                      final tpl = _allTemplates[idx];
                      final isSelected = tpl.templateType == _currentDoc.templateType;

                      return InkWell(
                        onTap: () {
                          setState(() => _currentDoc = tpl.copyWith());
                          Navigator.pop(ctx);
                          _showStatus('"${tpl.title}" 서식을 불러왔습니다.');
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF2563EB).withValues(alpha: 0.25) : const Color(0xFF151821),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF333A4C),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(CupertinoIcons.doc_fill, color: Color(0xFFEF4444), size: 18),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tpl.title,
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      tpl.subtitle.isNotEmpty ? tpl.subtitle : tpl.docNumber,
                                      style: const TextStyle(color: Colors.white54, fontSize: 11),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(CupertinoIcons.chevron_right, size: 14, color: Colors.white38),
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: const Color(0xFF1E212B),
        borderRadius: widget.isMaximized ? BorderRadius.zero : BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 1),
        boxShadow: const [
          BoxShadow(color: Colors.black54, blurRadius: 24, offset: Offset(0, 10)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // 1. 윈도우 타이틀바
          _buildTitleBar(),

          // 2. 전문 PDF 툴바
          _buildPdfToolbar(),

          // 3. 상태 알림 바 (생성 중/완료)
          if (_statusMessage != null) _buildStatusBar(),

          // 4. 메인 뷰포트 & 인스펙터 서랍
          Expanded(
            child: Row(
              children: [
                // A4 문서 뷰포트
                Expanded(
                  child: Container(
                    color: const Color(0xFF32363E), // 전문 PDF 리더 워크벤치 배경색
                    child: InteractiveViewer(
                      minScale: 0.4,
                      maxScale: 2.5,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Screenshot(
                            controller: _screenshotController,
                            child: PdfA4PageView(
                              doc: _currentDoc,
                              scale: _zoomScale,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // 실시간 폼 필드 & 설정 인스펙터 서랍
                if (_isInspectorOpen)
                  PdfInspectorDrawer(
                    documentData: _currentDoc,
                    onDocumentChanged: (updated) {
                      setState(() => _currentDoc = updated);
                    },
                    onClose: () => setState(() => _isInspectorOpen = false),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleBar() {
    return GestureDetector(
      onPanStart: widget.onTitleDragStart,
      onPanUpdate: widget.onTitleDragUpdate,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(
          color: Color(0xFF1E222D),
          border: Border(bottom: BorderSide(color: Color(0xFF2E3444))),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(CupertinoIcons.doc_text_fill, size: 12, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${_currentDoc.title} - Fiction PDF Studio',
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // 최소화 / 최대화 / 닫기
            IconButton(
              icon: const Icon(CupertinoIcons.minus, size: 12, color: Colors.white70),
              onPressed: widget.onMinimize,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
            IconButton(
              icon: Icon(widget.isMaximized ? CupertinoIcons.square_on_square : CupertinoIcons.square, size: 11, color: Colors.white70),
              onPressed: widget.onMaximize,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.xmark, size: 12, color: Colors.white70),
              onPressed: widget.onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              hoverColor: Colors.red.withValues(alpha: 0.8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfToolbar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF262A36),
        border: Border(bottom: BorderSide(color: Color(0xFF333A4C))),
      ),
      child: Row(
        children: [
          // 1. 서식 템플릿 라이브러리 열기
          _buildToolbarButton(
            icon: CupertinoIcons.square_grid_2x2_fill,
            label: '서식 템플릿',
            color: const Color(0xFF3B82F6),
            onTap: _showTemplateSelectionDialog,
          ),
          const SizedBox(width: 6),

          // 2. 문서 설정 / 폼 편집 토글
          _buildToolbarButton(
            icon: CupertinoIcons.slider_horizontal_3,
            label: _isInspectorOpen ? '설정 닫기' : '서식 설정 & 편집',
            color: _isInspectorOpen ? const Color(0xFF60A5FA) : Colors.white70,
            isActive: _isInspectorOpen,
            onTap: () => setState(() => _isInspectorOpen = !_isInspectorOpen),
          ),

          const VerticalDivider(color: Colors.white24, indent: 8, endIndent: 8, width: 20),

          // 3. 줌 컨트롤
          IconButton(
            icon: const Icon(CupertinoIcons.minus_circle, size: 16, color: Colors.white70),
            tooltip: '축소',
            onPressed: () {
              if (_zoomScale > 0.5) setState(() => _zoomScale = (_zoomScale - 0.1).clamp(0.5, 2.0));
            },
          ),
          Text(
            '${(_zoomScale * 100).toInt()}%',
            style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.plus_circle, size: 16, color: Colors.white70),
            tooltip: '확대',
            onPressed: () {
              if (_zoomScale < 1.8) setState(() => _zoomScale = (_zoomScale + 0.1).clamp(0.5, 2.0));
            },
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.arrow_right_arrow_left, size: 14, color: Colors.white70),
            tooltip: '100% 원본 크기',
            onPressed: () => setState(() => _zoomScale = 1.0),
          ),

          const VerticalDivider(color: Colors.white24, indent: 8, endIndent: 8, width: 20),

          // 4. 페이지 표시
          const Text('1 / 1 페이지', style: TextStyle(color: Colors.white54, fontSize: 11)),

          const Spacer(),

          // 5. 인쇄
          IconButton(
            icon: const Icon(CupertinoIcons.printer_fill, size: 16, color: Colors.white70),
            tooltip: '인쇄',
            onPressed: PdfExportManager.printCurrentWindow,
          ),
          const SizedBox(width: 4),

          // 6. PNG 이미지 저장
          _buildToolbarButton(
            icon: CupertinoIcons.photo,
            label: '이미지 저장',
            color: Colors.white70,
            onTap: _handleExportPng,
          ),
          const SizedBox(width: 8),

          // 7. PDF 파일 생성 및 다운로드 (핵심)
          _buildToolbarButton(
            icon: CupertinoIcons.arrow_down_doc_fill,
            label: 'PDF 다운로드',
            color: Colors.white,
            bgColor: const Color(0xFFDC2626), // Acrobat Red
            onTap: _handleExportPdf,
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String label,
    required Color color,
    Color? bgColor,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor ?? (isActive ? const Color(0xFF3B82F6).withValues(alpha: 0.25) : const Color(0xFF1A1D26)),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isActive ? const Color(0xFF3B82F6) : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 11.5, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFF1D4ED8),
      child: Row(
        children: [
          if (_isExporting) ...[
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              _statusMessage ?? '',
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
