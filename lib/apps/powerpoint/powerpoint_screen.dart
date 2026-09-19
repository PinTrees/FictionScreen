import 'package:flutter/material.dart';
import 'data/powerpoint_model.dart';
import 'widgets/powerpoint_edit_dialog.dart';
import 'widgets/powerpoint_ribbon.dart';
import 'widgets/powerpoint_slide_canvas.dart';
import 'widgets/powerpoint_slides_sidebar.dart';

class PowerPointScreen extends StatefulWidget {
  final PowerPointConfig config;
  final ValueChanged<PowerPointConfig>? onConfigChanged;

  const PowerPointScreen({
    super.key,
    required this.config,
    this.onConfigChanged,
  });

  @override
  State<PowerPointScreen> createState() => _PowerPointScreenState();
}

class _PowerPointScreenState extends State<PowerPointScreen> {
  late PowerPointConfig _config;

  @override
  void initState() {
    super.initState();
    _config = widget.config;
  }

  @override
  void didUpdateWidget(covariant PowerPointScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      _config = widget.config;
    }
  }

  void _updateConfig(PowerPointConfig newConfig) {
    setState(() {
      _config = newConfig;
    });
    widget.onConfigChanged?.call(newConfig);
  }

  void _openEditDialog() {
    showDialog(
      context: context,
      builder: (ctx) => PowerPointEditDialog(
        config: _config,
        onApply: _updateConfig,
      ),
    );
  }

  void _onSelectSlide(int index) {
    _updateConfig(_config.copyWith(activeSlideIndex: index));
  }

  void _toggleSlideShow() {
    _updateConfig(_config.copyWith(isSlideShowMode: !_config.isSlideShowMode));
  }

  @override
  Widget build(BuildContext context) {
    // If Slide Show mode is on, render full-screen presentation
    if (_config.isSlideShowMode) {
      return _buildFullSlideShow();
    }

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // 1. Ribbon Bar
          PowerPointRibbon(
            presentationTitle: _config.presentationTitle,
            onOpenEdit: _openEditDialog,
            onStartSlideShow: _toggleSlideShow,
          ),

          // 2. Main Workspace: Thumbnails Sidebar + Slide Canvas
          Expanded(
            child: Row(
              children: [
                // Left Thumbnails
                PowerPointSlidesSidebar(
                  slides: _config.slides,
                  activeSlideIndex: _config.activeSlideIndex,
                  onSelectSlide: _onSelectSlide,
                ),

                // Main 16:9 Canvas
                Expanded(
                  child: PowerPointSlideCanvas(
                    slide: _config.activeSlide,
                    slideIndex: _config.activeSlideIndex,
                    totalSlides: _config.slides.length,
                    onStartSlideShow: _toggleSlideShow,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullSlideShow() {
    final active = _config.activeSlide;
    final idx = _config.activeSlideIndex;
    final total = _config.slides.length;

    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Presentation Slide
          Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: PowerPointSlideCanvas(
                slide: active,
                slideIndex: idx,
                totalSlides: total,
                onStartSlideShow: _toggleSlideShow,
              ),
            ),
          ),

          // Top Floating Bar (Exit Slide Show)
          Positioned(
            top: 14,
            right: 14,
            child: Row(
              children: [
                if (idx > 0)
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white70, size: 20),
                    onPressed: () => _onSelectSlide(idx - 1),
                  ),
                if (idx < total - 1)
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 20),
                    onPressed: () => _onSelectSlide(idx + 1),
                  ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _toggleSlideShow,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.close, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text('슬라이드 쇼 종료 (ESC)', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
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
}
