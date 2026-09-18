import 'package:flutter/material.dart';
import '../data/photoshop_model.dart';

class PhotoshopCanvasView extends StatelessWidget {
  final PhotoshopConfig config;
  final ValueChanged<String>? onSelectLayer;

  const PhotoshopCanvasView({
    super.key,
    required this.config,
    this.onSelectLayer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1E1E1E),
      child: Column(
        children: [
          // Horizontal Ruler
          _buildHorizontalRuler(),
          Expanded(
            child: Row(
              children: [
                // Vertical Ruler
                _buildVerticalRuler(),
                // Main Workspace with Canvas
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: _buildArtboard(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalRuler() {
    return Container(
      height: 16,
      color: const Color(0xFF282828),
      child: Row(
        children: [
          Container(width: 16, color: const Color(0xFF333333)),
          Expanded(
            child: CustomPaint(
              painter: _RulerPainter(isHorizontal: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalRuler() {
    return Container(
      width: 16,
      color: const Color(0xFF282828),
      child: CustomPaint(
        painter: _RulerPainter(isHorizontal: false),
      ),
    );
  }

  Widget _buildArtboard() {
    // 16:9 canvas preview
    const double canvasW = 540;
    const double canvasH = 320;

    return Container(
      width: canvasW,
      height: canvasH,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Render Visible Layers in reverse order (bottom to top)
          ...config.layers.reversed.where((l) => l.isVisible).map((layer) {
            return _buildLayerContent(layer, canvasW, canvasH);
          }),

          // Transform Bounding Box with 8 Anchor Handles
          _buildTransformBoundingBox(canvasW, canvasH),
        ],
      ),
    );
  }

  Widget _buildLayerContent(PhotoshopLayer layer, double w, double h) {
    Widget content;

    if (layer.type == 'background') {
      content = Container(
        width: w,
        height: h,
        color: layer.color,
      );
    } else if (layer.type == 'shape') {
      content = Positioned(
        left: 40,
        top: 40,
        right: 40,
        bottom: 40,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                layer.color.withValues(alpha: 0.8),
                const Color(0xFF5865F2).withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    } else if (layer.type == 'text') {
      content = Positioned(
        left: 0,
        right: 0,
        top: 90,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                layer.textContent ?? 'FICTION SCREEN',
                style: TextStyle(
                  color: layer.color,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  shadows: const [
                    Shadow(color: Colors.black54, offset: Offset(2, 2), blurRadius: 4),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Adobe Photoshop CC 2026 Simulation',
                style: TextStyle(
                  color: Color(0xFFE0E0E0),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Pixel / Graphic layer
      content = Positioned(
        left: 120,
        right: 120,
        top: 155,
        child: Center(
          child: Container(
            width: 140,
            height: 80,
            decoration: BoxDecoration(
              color: layer.color.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: layer.color.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.auto_awesome, size: 36, color: Colors.white),
            ),
          ),
        ),
      );
    }

    return Opacity(
      opacity: layer.opacity.clamp(0.0, 1.0),
      child: content,
    );
  }

  Widget _buildTransformBoundingBox(double w, double h) {
    // Show transform bounding box around the active selection
    return Positioned(
      left: 100,
      top: 75,
      width: 340,
      height: 180,
      child: Stack(
        children: [
          // Blue outline
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF31A8FF), width: 1),
            ),
          ),
          // 8 Square Anchor Handles
          _buildAnchor(0, 0), // Top-Left
          _buildAnchor(166, 0), // Top-Center
          _buildAnchor(332, 0), // Top-Right
          _buildAnchor(0, 86), // Mid-Left
          _buildAnchor(332, 86), // Mid-Right
          _buildAnchor(0, 172), // Bottom-Left
          _buildAnchor(166, 172), // Bottom-Center
          _buildAnchor(332, 172), // Bottom-Right
        ],
      ),
    );
  }

  Widget _buildAnchor(double left, double top) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF31A8FF), width: 1.2),
        ),
      ),
    );
  }
}

class _RulerPainter extends CustomPainter {
  final bool isHorizontal;

  _RulerPainter({required this.isHorizontal});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6E6E6E)
      ..strokeWidth = 1;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    if (isHorizontal) {
      for (double x = 0; x < size.width; x += 10) {
        final isMajor = (x % 50 == 0);
        final is100 = (x % 100 == 0);
        final height = is100 ? 10.0 : (isMajor ? 6.0 : 3.0);
        canvas.drawLine(Offset(x, size.height), Offset(x, size.height - height), paint);

        if (is100 && x > 0) {
          textPainter.text = TextSpan(
            text: '${x.round()}',
            style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 8),
          );
          textPainter.layout();
          textPainter.paint(canvas, Offset(x + 2, 1));
        }
      }
    } else {
      for (double y = 0; y < size.height; y += 10) {
        final isMajor = (y % 50 == 0);
        final is100 = (y % 100 == 0);
        final width = is100 ? 10.0 : (isMajor ? 6.0 : 3.0);
        canvas.drawLine(Offset(size.width, y), Offset(size.width - width, y), paint);

        if (is100 && y > 0) {
          textPainter.text = TextSpan(
            text: '${y.round()}',
            style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 7.5),
          );
          textPainter.layout();
          textPainter.paint(canvas, Offset(1, y + 2));
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
