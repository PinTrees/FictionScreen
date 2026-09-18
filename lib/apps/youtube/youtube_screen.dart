import 'package:flutter/cupertino.dart';
import 'data/youtube_model.dart';
import 'pages/youtube_home_feed_page.dart';
import 'pages/youtube_library_page.dart';
import 'pages/youtube_shorts_page.dart';
import 'pages/youtube_subscriptions_page.dart';
import 'pages/youtube_video_detail_page.dart';
import 'widgets/youtube_bottom_nav.dart';
import 'widgets/youtube_comments_sheet.dart';
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

  Widget _buildCreateSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
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
              const Text(
                '만들기',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: _hideModal,
                child: const Icon(
                  CupertinoIcons.xmark,
                  color: Color(0xFFFFFFFF),
                  size: 20,
                ),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF272727),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(icon, color: const Color(0xFFFFFFFF), size: 20),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
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
      child: Container(
        color: const Color(0xFF0F0F0F),
        child: Stack(
          children: [
            // Main Content Area
            Column(
              children: [
                // Top detail header back button when in detail mode
                if (_showingDetail && _currentTabIndex != 1)
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    color: const Color(0xFF0F0F0F),
                    child: Row(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            setState(() {
                              _showingDetail = false;
                            });
                          },
                          child: Row(
                            children: const [
                              Icon(
                                CupertinoIcons.chevron_down,
                                color: Color(0xFFFFFFFF),
                                size: 20,
                              ),
                              SizedBox(width: 6),
                              Text(
                                '홈으로',
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          CupertinoIcons.tv,
                          color: Color(0xFFFFFFFF),
                          size: 18,
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          CupertinoIcons.search,
                          color: Color(0xFFFFFFFF),
                          size: 18,
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          CupertinoIcons.ellipsis_vertical,
                          color: Color(0xFFFFFFFF),
                          size: 18,
                        ),
                      ],
                    ),
                  ),

                // Body content
                Expanded(
                  child: _buildBody(),
                ),

                // Bottom Navigation
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

            // In-window Modal presentation (Comments, Create, Share)
            if (_currentModal != null) ...[
              GestureDetector(
                onTap: _hideModal,
                child: Container(
                  color: const Color(0x77000000),
                ),
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
        ),
      ),
    );
  }

  Widget _buildBody() {
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
        return YouTubeHomeFeedPage(
          config: _activeConfig,
          onSelectVideo: _onSelectVideo,
        );
      case 1:
        return YouTubeShortsPage(
          config: _activeConfig,
          onOpenComments: _openComments,
        );
      case 3:
        return YouTubeSubscriptionsPage(
          config: _activeConfig,
          onSelectVideo: _onSelectVideo,
        );
      case 4:
        return YouTubeLibraryPage(
          config: _activeConfig,
          onSelectVideo: _onSelectVideo,
        );
      default:
        return YouTubeHomeFeedPage(
          config: _activeConfig,
          onSelectVideo: _onSelectVideo,
        );
    }
  }
}
