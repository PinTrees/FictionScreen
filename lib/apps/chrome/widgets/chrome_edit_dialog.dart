import 'package:flutter/material.dart';
import '../data/chrome_model.dart';

class ChromeEditDialog extends StatefulWidget {
  final ChromeConfig initialConfig;
  final ValueChanged<ChromeConfig> onSave;

  const ChromeEditDialog({
    super.key,
    required this.initialConfig,
    required this.onSave,
  });

  @override
  State<ChromeEditDialog> createState() => _ChromeEditDialogState();
}

class _ChromeEditDialogState extends State<ChromeEditDialog> {
  late bool _showBookmarksBar;
  late bool _openInNewTabByDefault;
  late TextEditingController _activeUrlController;
  late TextEditingController _activeTitleController;

  @override
  void initState() {
    super.initState();
    final cfg = widget.initialConfig;
    _showBookmarksBar = cfg.showBookmarksBar;
    _openInNewTabByDefault = cfg.openInNewTabByDefault;
    _activeUrlController = TextEditingController(text: cfg.activeTab.url);
    _activeTitleController = TextEditingController(text: cfg.activeTab.title);
  }

  @override
  void dispose() {
    _activeUrlController.dispose();
    _activeTitleController.dispose();
    super.dispose();
  }

  void _save() {
    final activeTab = widget.initialConfig.activeTab.copyWith(
      url: _activeUrlController.text.trim(),
      title: _activeTitleController.text.trim(),
    );

    final updatedTabs = List<ChromeTab>.from(widget.initialConfig.tabs);
    if (widget.initialConfig.activeTabIndex < updatedTabs.length) {
      updatedTabs[widget.initialConfig.activeTabIndex] = activeTab;
    }

    final updated = widget.initialConfig.copyWith(
      tabs: updatedTabs,
      showBookmarksBar: _showBookmarksBar,
      openInNewTabByDefault: _openInNewTabByDefault,
    );

    widget.onSave(updated);
    Navigator.of(context).pop();
  }

  void _restoreDefaults() {
    final def = ChromeConfig.defaultPreset();
    setState(() {
      _showBookmarksBar = def.showBookmarksBar;
      _openInNewTabByDefault = def.openInNewTabByDefault;
      _activeUrlController.text = def.activeTab.url;
      _activeTitleController.text = def.activeTab.title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF2B2D30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 540,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Color(0xFF4285F4), shape: BoxShape.circle),
                  child: const Icon(Icons.public, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Google Chrome 브라우저 환경 설정', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('탭 관리, 링크 인터셉트 모드 및 북마크를 설정합니다.', style: TextStyle(color: Colors.white60, fontSize: 12)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(color: Color(0xFF3F3F46), height: 28),

            // Settings switches
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('새 탭 인터셉트 활성화', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              subtitle: const Text('바로가기/북마크 클릭 시 외부 팝업 대신 크롬 프레임 내 새 탭으로 엽니다.', style: TextStyle(color: Colors.white60, fontSize: 11.5)),
              value: _openInNewTabByDefault,
              activeThumbColor: const Color(0xFF4285F4),
              onChanged: (v) => setState(() => _openInNewTabByDefault = v),
            ),
            const SizedBox(height: 6),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('북마크 바 표시', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              subtitle: const Text('주소창 바로 아래에 즐겨찾기 북마크 바를 표시합니다.', style: TextStyle(color: Colors.white60, fontSize: 11.5)),
              value: _showBookmarksBar,
              activeThumbColor: const Color(0xFF4285F4),
              onChanged: (v) => setState(() => _showBookmarksBar = v),
            ),
            const SizedBox(height: 16),

            // Active Tab Title and URL
            const Text('현재 활성 탭 설정', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildTextField('탭 제목', _activeTitleController),
            const SizedBox(height: 10),
            _buildTextField('현재 URL', _activeUrlController),

            const Divider(color: Color(0xFF3F3F46), height: 32),
            Row(
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.refresh, size: 16, color: Colors.white70),
                  label: const Text('기본값 복원', style: TextStyle(color: Colors.white70)),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF3F3F46))),
                  onPressed: _restoreDefaults,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소', style: TextStyle(color: Colors.white60)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4285F4),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: _save,
                  child: const Text('적용하기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
        const SizedBox(height: 4),
        Container(
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1F22),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFF3F3F46)),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white, fontSize: 12.5),
            decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), border: InputBorder.none),
          ),
        ),
      ],
    );
  }
}
