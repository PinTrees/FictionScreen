import 'package:flutter/cupertino.dart';
import '../../../../../../apps/chrome/chrome_screen.dart';
import '../../../../../../apps/chrome/data/chrome_model.dart';
import '../../../common/os_window_frame.dart';

/// Windows용 Google Chrome 브라우저 창 (각 Windows 버전별 순정 헤드 디자인 자동 적용)
class WindowsChromeWindow extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(int layoutType, int zoneIndex)? onSnapLayout;
  final Function(String templateId)? onOpenTemplate;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;
  final bool isMaximized;
  final WindowStyle style;

  const WindowsChromeWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onSnapLayout,
    this.onOpenTemplate,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 860,
    this.height = 560,
    this.isMaximized = false,
    this.style = WindowStyle.windows10,
  });

  @override
  State<WindowsChromeWindow> createState() => _WindowsChromeWindowState();
}

class _WindowsChromeWindowState extends State<WindowsChromeWindow> {
  late ChromeConfig _config;

  @override
  void initState() {
    super.initState();
    _config = ChromeConfig.defaultPreset();
  }

  @override
  Widget build(BuildContext context) {
    final activeTabTitle = _config.activeTab.title.isEmpty ? '새 탭' : _config.activeTab.title;

    return OsWindowFrame(
      title: 'Google Chrome - $activeTabTitle',
      iconAsset: 'assets/images/windows/chrome.png',
      icon: CupertinoIcons.globe,
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
      child: ChromeScreen(
        config: _config,
        onConfigChanged: (updated) => setState(() => _config = updated),
      ),
    );
  }
}
