import 'package:flutter/cupertino.dart';
import '../../../../../../apps/chrome/chrome_screen.dart';
import '../../../../../../apps/chrome/data/chrome_model.dart';
import '../../../common/os_window_frame.dart';

/// macOS용 Google Chrome 브라우저 창 (고도화 멀티탭 & 프레임 인터셉트 지원)
class MacosChromeWindow extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String templateId)? onOpenTemplate;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;

  const MacosChromeWindow({
    super.key,
    required this.onClose,
    this.onOpenTemplate,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 860,
    this.height = 560,
  });

  @override
  State<MacosChromeWindow> createState() => _MacosChromeWindowState();
}

class _MacosChromeWindowState extends State<MacosChromeWindow> {
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
      style: WindowStyle.macos,
      width: widget.width,
      height: widget.height,
      onClose: widget.onClose,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: ChromeScreen(
        config: _config,
        onConfigChanged: (updated) => setState(() => _config = updated),
      ),
    );
  }
}
