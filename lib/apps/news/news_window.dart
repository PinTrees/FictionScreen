import 'package:flutter/cupertino.dart';
import '../../pages/console/common/os_window_frame.dart';
import 'data/news_model.dart';
import 'news_screen.dart';

class NewsWindow extends StatefulWidget {
  final double width;
  final double height;
  final WindowStyle style;
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(int layoutType, int zoneIndex)? onSnapLayout;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final bool? isMaximized;

  const NewsWindow({
    super.key,
    this.width = 960,
    this.height = 620,
    required this.style,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onSnapLayout,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.isMaximized,
  });

  @override
  State<NewsWindow> createState() => _NewsWindowState();
}

class _NewsWindowState extends State<NewsWindow> {
  late NewsConfig _config;

  @override
  void initState() {
    super.initState();
    _config = NewsConfig.defaultPreset();
  }

  @override
  Widget build(BuildContext context) {
    return OsWindowFrame(
      title: '뉴스 속보 (Breaking News TV)',
      icon: CupertinoIcons.tv_fill,
      style: widget.style,
      width: widget.width,
      height: widget.height,
      isMaximized: widget.isMaximized,
      onClose: widget.onClose,
      onMinimize: widget.onMinimize,
      onMaximize: widget.onMaximize,
      onSnapLayout: widget.onSnapLayout,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: NewsScreen(
        config: _config,
        onConfigChanged: (updated) => setState(() => _config = updated),
      ),
    );
  }
}
