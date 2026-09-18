import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../data/chrome_model.dart';

class ChromeNavToolbar extends StatefulWidget {
  final ChromeTab activeTab;
  final bool openInNewTabByDefault;
  final VoidCallback onBack;
  final VoidCallback onForward;
  final VoidCallback onReload;
  final VoidCallback onHome;
  final ValueChanged<String> onSubmitUrl;
  final ValueChanged<bool> onToggleNewTabMode;
  final VoidCallback onEditConfig;

  const ChromeNavToolbar({
    super.key,
    required this.activeTab,
    required this.openInNewTabByDefault,
    required this.onBack,
    required this.onForward,
    required this.onReload,
    required this.onHome,
    required this.onSubmitUrl,
    required this.onToggleNewTabMode,
    required this.onEditConfig,
  });

  @override
  State<ChromeNavToolbar> createState() => _ChromeNavToolbarState();
}

class _ChromeNavToolbarState extends State<ChromeNavToolbar> {
  late TextEditingController _urlController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.activeTab.isNewTabPage ? '' : widget.activeTab.url);
  }

  @override
  void didUpdateWidget(covariant ChromeNavToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeTab.url != widget.activeTab.url && !_focusNode.hasFocus) {
      _urlController.text = widget.activeTab.isNewTabPage ? '' : widget.activeTab.url;
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit(String text) {
    widget.onSubmitUrl(text);
  }

  @override
  Widget build(BuildContext context) {
    final canBack = widget.activeTab.canGoBack;
    final canForward = widget.activeTab.canGoForward;
    final isSecure = widget.activeTab.url.startsWith('https://');

    return Container(
      height: 42,
      color: const Color(0xFF2B2D30),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          // 1. Back button
          IconButton(
            icon: const Icon(CupertinoIcons.arrow_left, size: 15),
            color: canBack ? Colors.white : Colors.white24,
            splashRadius: 16,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            tooltip: '뒤로 가기',
            onPressed: canBack ? widget.onBack : null,
          ),
          const SizedBox(width: 4),

          // 2. Forward button
          IconButton(
            icon: const Icon(CupertinoIcons.arrow_right, size: 15),
            color: canForward ? Colors.white : Colors.white24,
            splashRadius: 16,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            tooltip: '앞으로 가기',
            onPressed: canForward ? widget.onForward : null,
          ),
          const SizedBox(width: 4),

          // 3. Reload button
          IconButton(
            icon: Icon(
              widget.activeTab.isLoading ? CupertinoIcons.xmark : CupertinoIcons.arrow_clockwise,
              size: 15,
            ),
            color: Colors.white70,
            splashRadius: 16,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            tooltip: '새로고침 (Ctrl+R)',
            onPressed: widget.onReload,
          ),
          const SizedBox(width: 4),

          // 4. Home button
          IconButton(
            icon: const Icon(CupertinoIcons.house, size: 15),
            color: Colors.white70,
            splashRadius: 16,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            tooltip: '홈으로 이동',
            onPressed: widget.onHome,
          ),
          const SizedBox(width: 8),

          // 5. Omnibox (Address & Search Bar)
          Expanded(
            child: Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1F22),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _focusNode.hasFocus ? const Color(0xFF4285F4) : Colors.white.withValues(alpha: 0.12),
                  width: _focusNode.hasFocus ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isSecure ? CupertinoIcons.lock_fill : CupertinoIcons.search,
                    size: 12,
                    color: isSecure ? const Color(0xFF34A853) : Colors.white38,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _urlController,
                      focusNode: _focusNode,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      decoration: const InputDecoration(
                        hintText: 'Google 검색 또는 URL 입력',
                        hintStyle: TextStyle(color: Colors.white38, fontSize: 12),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: _handleSubmit,
                    ),
                  ),
                  if (_urlController.text.isNotEmpty)
                    InkWell(
                      onTap: () {
                        _urlController.clear();
                        setState(() {});
                      },
                      child: const Icon(CupertinoIcons.clear_circled_solid, size: 12, color: Colors.white38),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // 6. "새 탭 인터셉트" Toggle Badge
          Tooltip(
            message: widget.openInNewTabByDefault ? '클릭 시 새 탭에서 열기 (활성)' : '클릭 시 현재 탭에서 열기 (비활성)',
            child: InkWell(
              onTap: () => widget.onToggleNewTabMode(!widget.openInNewTabByDefault),
              borderRadius: BorderRadius.circular(4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.openInNewTabByDefault ? const Color(0xFF4285F4).withValues(alpha: 0.2) : Colors.white10,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: widget.openInNewTabByDefault ? const Color(0xFF4285F4) : Colors.transparent,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.rectangle_stack_badge_plus,
                      size: 13,
                      color: widget.openInNewTabByDefault ? const Color(0xFF4285F4) : Colors.white54,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '새 탭 인터셉트',
                      style: TextStyle(
                        color: widget.openInNewTabByDefault ? const Color(0xFF4285F4) : Colors.white54,
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // 7. Config / Edit Story Button
          IconButton(
            icon: const Icon(Icons.tune, size: 16, color: Colors.white70),
            tooltip: '크롬 설정 & 시나리오 편집',
            splashRadius: 16,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            onPressed: widget.onEditConfig,
          ),
          const SizedBox(width: 4),

          // 8. Profile Avatar
          const CircleAvatar(
            radius: 12,
            backgroundColor: Color(0xFF4285F4),
            child: Text('G', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
