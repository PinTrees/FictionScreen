import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../data/chrome_model.dart';
import '../../widgets/chrome_web_content.dart';

class ChromeMobileWorkspace extends StatefulWidget {
  final ChromeConfig config;
  final ValueChanged<ChromeConfig> onConfigChanged;
  final VoidCallback onOpenEditDialog;

  const ChromeMobileWorkspace({
    super.key,
    required this.config,
    required this.onConfigChanged,
    required this.onOpenEditDialog,
  });

  @override
  State<ChromeMobileWorkspace> createState() => _ChromeMobileWorkspaceState();
}

class _ChromeMobileWorkspaceState extends State<ChromeMobileWorkspace> {
  bool _showTabGrid = false;
  late TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.config.activeTab.isNewTabPage ? '' : widget.config.activeTab.url);
  }

  @override
  void didUpdateWidget(covariant ChromeMobileWorkspace oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config.activeTab.url != widget.config.activeTab.url) {
      _urlController.text = widget.config.activeTab.isNewTabPage ? '' : widget.config.activeTab.url;
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _newTab([String url = 'chrome://newtab', String title = '새 탭']) {
    final newId = 'tab-${DateTime.now().millisecondsSinceEpoch}';
    final newTab = ChromeTab(
      id: newId,
      title: title,
      url: url,
      history: [url],
      historyIndex: 0,
    );
    final updatedTabs = List<ChromeTab>.from(widget.config.tabs)..add(newTab);
    widget.onConfigChanged(widget.config.copyWith(
      tabs: updatedTabs,
      activeTabIndex: updatedTabs.length - 1,
    ));
    setState(() => _showTabGrid = false);
  }

  void _selectTab(int index) {
    widget.onConfigChanged(widget.config.copyWith(activeTabIndex: index));
    setState(() => _showTabGrid = false);
  }

  void _closeTab(int index) {
    final updatedTabs = List<ChromeTab>.from(widget.config.tabs);
    if (updatedTabs.length <= 1) {
      updatedTabs[0] = const ChromeTab(id: 'tab-new', title: '새 탭', url: 'chrome://newtab');
      widget.onConfigChanged(widget.config.copyWith(tabs: updatedTabs, activeTabIndex: 0));
      return;
    }

    updatedTabs.removeAt(index);
    int newIndex = widget.config.activeTabIndex;
    if (newIndex >= updatedTabs.length) {
      newIndex = updatedTabs.length - 1;
    } else if (newIndex > index) {
      newIndex--;
    }

    widget.onConfigChanged(widget.config.copyWith(tabs: updatedTabs, activeTabIndex: newIndex));
  }

  void _navigateActive(String url) {
    final currentTab = widget.config.activeTab;
    final updatedActive = currentTab.copyWith(url: url, title: url);
    final updatedTabs = List<ChromeTab>.from(widget.config.tabs);
    updatedTabs[widget.config.activeTabIndex] = updatedActive;
    widget.onConfigChanged(widget.config.copyWith(tabs: updatedTabs));
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1F22),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D30),
        elevation: 0,
        toolbarHeight: 52,
        titleSpacing: 8,
        title: Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1F22),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Row(
            children: [
              const Icon(CupertinoIcons.search, size: 13, color: Colors.white38),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _urlController,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: const InputDecoration(
                    hintText: '검색어 또는 웹 주소 입력',
                    hintStyle: TextStyle(color: Colors.white38, fontSize: 12),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onSubmitted: (val) {
                    final trimmed = val.trim();
                    if (trimmed.isEmpty) return;
                    String target = trimmed.startsWith('http') ? trimmed : 'https://$trimmed';
                    if (config.openInNewTabByDefault) {
                      _newTab(target, target);
                    } else {
                      _navigateActive(target);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          // Tab Switcher Button with tab count [ 3 ]
          InkWell(
            onTap: () => setState(() => _showTabGrid = !_showTabGrid),
            borderRadius: BorderRadius.circular(4),
            child: Container(
              width: 26,
              height: 26,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white70, width: 1.5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  '${config.tabs.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white70, size: 20),
            onPressed: widget.onOpenEditDialog,
          ),
        ],
      ),
      body: _showTabGrid ? _buildMobileTabGrid() : _buildActiveWebContent(),
    );
  }

  Widget _buildActiveWebContent() {
    return ChromeWebContent(
      tab: widget.config.activeTab,
      bookmarks: widget.config.bookmarks,
      openInNewTabByDefault: widget.config.openInNewTabByDefault,
      onNavigate: _navigateActive,
      onOpenNewTab: (url) => _newTab(url, url),
    );
  }

  Widget _buildMobileTabGrid() {
    final tabs = widget.config.tabs;
    return Container(
      color: const Color(0xFF1E1F22),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '열린 탭 (${tabs.length})',
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 16),
                label: const Text('새 탭'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4285F4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                onPressed: () => _newTab('chrome://newtab', '새 탭'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final tab = tabs[index];
                final isSelected = index == widget.config.activeTabIndex;

                return InkWell(
                  onTap: () => _selectTab(index),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B2D30),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF4285F4) : Colors.white12,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Card Header
                        Container(
                          height: 32,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF4285F4).withValues(alpha: 0.2) : Colors.transparent,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(9), topRight: Radius.circular(9)),
                          ),
                          child: Row(
                            children: [
                              const Icon(CupertinoIcons.globe, size: 12, color: Color(0xFF4285F4)),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  tab.title.isEmpty ? tab.url : tab.title,
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              InkWell(
                                onTap: () => _closeTab(index),
                                child: const Icon(CupertinoIcons.xmark, size: 12, color: Colors.white60),
                              ),
                            ],
                          ),
                        ),
                        // Card Body Preview Thumbnail
                        Expanded(
                          child: Container(
                            color: const Color(0xFF202124),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    tab.isNewTabPage ? CupertinoIcons.search : CupertinoIcons.doc_text,
                                    size: 32,
                                    color: Colors.white24,
                                  ),
                                  const SizedBox(height: 6),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      tab.url,
                                      style: const TextStyle(color: Colors.white38, fontSize: 9.5),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
