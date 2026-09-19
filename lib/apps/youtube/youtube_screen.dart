import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data/youtube_model.dart';
import 'pages/youtube_desktop_home_page.dart';
import 'pages/youtube_desktop_watch_page.dart';
import 'pages/youtube_home_feed_page.dart';
import 'pages/youtube_library_page.dart';
import 'pages/youtube_shorts_page.dart';
import 'pages/youtube_subscriptions_page.dart';
import 'pages/youtube_video_detail_page.dart';
import 'widgets/youtube_bottom_nav.dart';
import 'widgets/youtube_comments_sheet.dart';
import 'widgets/youtube_desktop_header.dart';
import 'widgets/youtube_desktop_sidebar.dart';
import 'widgets/youtube_edit_dialog.dart';
import 'widgets/youtube_modal_scope.dart';

class YoutubeScreen extends StatefulWidget {
  final YoutubeConfig config;
  final ValueChanged<YoutubeConfig>? onConfigChanged;

  const YoutubeScreen({
    super.key,
    required this.config,
    this.onConfigChanged,
  });

  @override
  State<YoutubeScreen> createState() => _YoutubeScreenState();
}

class _YoutubeScreenState extends State<YoutubeScreen> {
  int _currentTabIndex = 0;
  late YoutubeConfig _activeConfig;
  bool _showingDetail = true; // Start in video detail mode for immediate playback
  bool _isSidebarOpen = true;
  Widget? _currentModal;

  @override
  void initState() {
    super.initState();
    _activeConfig = widget.config;
  }

  @override
  void didUpdateWidget(covariant YoutubeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      _activeConfig = widget.config;
    }
  }

  void _updateConfig(YoutubeConfig newConfig) {
    setState(() {
      _activeConfig = newConfig;
    });
    widget.onConfigChanged?.call(newConfig);
  }

  void _showModal(Widget sheet) {
    setState(() {
      _currentModal = sheet;
    });
  }

  void _hideModal() {
    setState(() {
      _currentModal = null;
    });
  }

  void _openComments() {
    _showModal(
      YouTubeCommentsSheet(
        config: _activeConfig,
        onClose: _hideModal,
        onAddComment: (text) {
          // Comment added
        },
      ),
    );
  }

  void _openCreateSheet() {
    _showModal(
      _buildCreateSheet(),
    );
  }

  void _openEditDialog() {
    showDialog(
      context: context,
      builder: (ctx) => YouTubeEditDialog(
        config: _activeConfig,
        onApply: _updateConfig,
      ),
    );
  }

  void _onSelectVideo(YoutubeVideoItem item) {
    setState(() {
      _activeConfig = _activeConfig.copyWith(
        title: item.title,
        channelName: item.channelTitle,
        channelAvatarUrl: item.channelAvatarUrl,
        viewCount: item.viewCount,
        uploadTime: item.publishedTime,
        thumbnailUrl: item.thumbnailUrl,
        videoId: item.videoId,
      );
      _showingDetail = true;
    });
    widget.onConfigChanged?.call(_activeConfig);
  }

  @override
  Widget build(BuildContext context) {
    return YouTubeModalScope(
      showModal: _showModal,
      hideModal: _hideModal,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Determine if desktop mode is active
          final isDesktop = _activeConfig.isDesktopMode ?? (constraints.maxWidth >= 720);

          return Container(
            color: const Color(0xFF0F0F0F),
            child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
          );
        },
      ),
    );
  }

  // -------------------------------------------------------------
  // 💻 Desktop Web Layout (youtube.com authentic dark experience)
  // -------------------------------------------------------------
  Widget _buildDesktopLayout() {
    return Column(
      children: [
        // 1. YouTube Desktop Global Header
        YouTubeDesktopHeader(
          isSidebarOpen: _isSidebarOpen,
          onToggleSidebar: () => setState(() => _isSidebarOpen = !_isSidebarOpen),
          isDesktopMode: true,
          onToggleDesktopMode: () => _updateConfig(_activeConfig.copyWith(isDesktopMode: false)),
          onOpenEditDialog: _openEditDialog,
          onNavigateHome: () => setState(() => _showingDetail = false),
          userAvatarUrl: _activeConfig.channelAvatarUrl,
        ),

        // 2. Main Desktop Body: Sidebar + Content
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Desktop Sidebar (Collapsible)
              YouTubeDesktopSidebar(
                isExpanded: _isSidebarOpen,
                selectedIndex: _showingDetail ? -1 : _currentTabIndex,
                channels: _activeConfig.subscribedChannels,
                onSelectIndex: (idx) {
                  setState(() {
                    _currentTabIndex = idx;
                    _showingDetail = false;
                  });
                },
              ),

              // Content Area: Watch Page or Home Feed
              Expanded(
                child: _showingDetail
                    ? YouTubeDesktopWatchPage(
                        config: _activeConfig,
                        onConfigChanged: _updateConfig,
                        onSelectVideo: _onSelectVideo,
                      )
                    : YouTubeDesktopHomePage(
                        config: _activeConfig,
                        onSelectVideo: _onSelectVideo,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // 📱 Mobile Layout (with responsive switcher)
  // -------------------------------------------------------------
  Widget _buildMobileLayout() {
    return Stack(
      children: [
        Column(
          children: [
            // Mobile Top Bar
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              color: const Color(0xFF0F0F0F),
              child: Row(
                children: [
                  if (_showingDetail && _currentTabIndex != 1)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _showingDetail = false),
                      child: Row(
                        children: const [
                          Icon(CupertinoIcons.chevron_down, color: Colors.white, size: 20),
                          SizedBox(width: 4),
                          Text('홈', style: TextStyle(color: Colors.white, fontSize: 13)),
                        ],
                      ),
                    )
                  else
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 17,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF0000),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(
                            child: Icon(Icons.play_arrow, color: Colors.white, size: 14),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'YouTube',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                  const Spacer(),

                  // Switch to Desktop Mode
                  InkWell(
                    onTap: () => _updateConfig(_activeConfig.copyWith(isDesktopMode: true)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF272727),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(CupertinoIcons.device_desktop, color: Color(0xFF3EA6FF), size: 13),
                          SizedBox(width: 4),
                          Text('데스크톱', style: TextStyle(color: Color(0xFF3EA6FF), fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Edit Scenario
                  InkWell(
                    onTap: _openEditDialog,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF0000).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(CupertinoIcons.pencil, color: Color(0xFFFF4E4E), size: 14),
                    ),
                  ),

                  const SizedBox(width: 8),
                  const Icon(CupertinoIcons.search, color: Colors.white, size: 18),
                ],
              ),
            ),

            // Body
            Expanded(child: _buildMobileBody()),

            // Mobile Bottom Navigation
            YouTubeBottomNav(
              currentIndex: _showingDetail ? -1 : _currentTabIndex,
              profileAvatarUrl: _activeConfig.channelAvatarUrl,
              onTap: (index) {
                if (index == 2) {
                  _openCreateSheet();
                  return;
                }
                setState(() {
                  _currentTabIndex = index;
                  _showingDetail = false;
                });
              },
            ),
          ],
        ),

        // In-window Modal presentation (Comments, Create)
        if (_currentModal != null) ...[
          GestureDetector(
            onTap: _hideModal,
            child: Container(color: const Color(0x77000000)),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 420,
            child: _currentModal!,
          ),
        ],
      ],
    );
  }

  Widget _buildMobileBody() {
    if (_showingDetail) {
      return YouTubeVideoDetailPage(
        config: _activeConfig,
        onConfigChanged: _updateConfig,
        onOpenComments: _openComments,
        onSelectVideo: _onSelectVideo,
      );
    }

    switch (_currentTabIndex) {
      case 0:
        return YouTubeHomeFeedPage(config: _activeConfig, onSelectVideo: _onSelectVideo);
      case 1:
        return YouTubeShortsPage(config: _activeConfig, onOpenComments: _openComments);
      case 3:
        return YouTubeSubscriptionsPage(config: _activeConfig, onSelectVideo: _onSelectVideo);
      case 4:
        return YouTubeLibraryPage(config: _activeConfig, onSelectVideo: _onSelectVideo);
      default:
        return YouTubeHomeFeedPage(config: _activeConfig, onSelectVideo: _onSelectVideo);
    }
  }

  Widget _buildCreateSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF555555),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('만들기', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: _hideModal,
                child: const Icon(CupertinoIcons.xmark, color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCreateOption(CupertinoIcons.bolt_fill, 'Shorts 동영상 만들기'),
          _buildCreateOption(CupertinoIcons.arrow_up_circle, '동영상 업로드'),
          _buildCreateOption(CupertinoIcons.antenna_radiowaves_left_right, '라이브 스트리밍 시작'),
          _buildCreateOption(CupertinoIcons.square_pencil, '게시물 작성'),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildCreateOption(IconData icon, String label) {
    return GestureDetector(
      onTap: _hideModal,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(color: Color(0xFF272727), shape: BoxShape.circle),
              child: Center(child: Icon(icon, color: Colors.white, size: 18)),
            ),
            const SizedBox(width: 14),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
