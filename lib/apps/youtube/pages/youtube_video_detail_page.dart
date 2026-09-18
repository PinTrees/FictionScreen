import 'package:flutter/cupertino.dart';
import '../data/youtube_model.dart';
import '../widgets/youtube_iframe_player.dart';

class YouTubeVideoDetailPage extends StatelessWidget {
  final YoutubeConfig config;
  final ValueChanged<YoutubeConfig>? onConfigChanged;
  final VoidCallback onOpenComments;
  final ValueChanged<YoutubeVideoItem>? onSelectVideo;

  const YouTubeVideoDetailPage({
    super.key,
    required this.config,
    required this.onOpenComments,
    this.onConfigChanged,
    this.onSelectVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Video Player (Iframe or Mock)
        YouTubeIframePlayer(
          config: config,
          onConfigChanged: onConfigChanged,
        ),

        // Scrollable content below video
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVideoInfo(),
                const SizedBox(height: 12),
                _buildChannelBar(),
                const SizedBox(height: 12),
                _buildActionPills(),
                const SizedBox(height: 12),
                _buildCommentsPreview(),
                const SizedBox(height: 16),
                _buildRecommendedList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            config.videoTitle,
            style: const TextStyle(
              color: Color(0xFFF1F1F1),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '조회수 ${config.viewCount}',
                style: const TextStyle(
                  color: Color(0xFFAAAAAA),
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '·',
                style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 12),
              ),
              const SizedBox(width: 6),
              const Text(
                '3일 전',
                style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 12),
              ),
              const SizedBox(width: 8),
              const Text(
                '...더보기',
                style: TextStyle(
                  color: Color(0xFFF1F1F1),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChannelBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFF333333),
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAlias,
            child: config.channelAvatarUrl.isNotEmpty
                ? Image.network(
                    config.channelAvatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildChannelInitial(),
                  )
                : _buildChannelInitial(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  config.channelName,
                  style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  config.subscriberCount,
                  style: const TextStyle(
                    color: Color(0xFFAAAAAA),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (onConfigChanged != null) {
                onConfigChanged!(
                  config.copyWith(isSubscribed: !config.isSubscribed),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: config.isSubscribed
                    ? const Color(0xFF272727)
                    : const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (config.isSubscribed) ...[
                    const Icon(
                      CupertinoIcons.bell_fill,
                      color: Color(0xFFFFFFFF),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    config.isSubscribed ? '구독중' : '구독',
                    style: TextStyle(
                      color: config.isSubscribed
                          ? const Color(0xFFFFFFFF)
                          : const Color(0xFF0F0F0F),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelInitial() {
    return Center(
      child: Text(
        config.channelName.isNotEmpty ? config.channelName[0] : 'Y',
        style: const TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildActionPills() {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          // Thumbs Up / Down Pill
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF272727),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (onConfigChanged != null) {
                      onConfigChanged!(
                        config.copyWith(isLiked: !config.isLiked),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          config.isLiked ? CupertinoIcons.hand_thumbsup_fill : CupertinoIcons.hand_thumbsup,
                          color: config.isLiked ? const Color(0xFF3EA6FF) : const Color(0xFFFFFFFF),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          config.likeCount,
                          style: TextStyle(
                            color: config.isLiked ? const Color(0xFF3EA6FF) : const Color(0xFFFFFFFF),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 18,
                  color: const Color(0xFF3F3F3F),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Icon(
                    CupertinoIcons.hand_thumbsdown,
                    color: Color(0xFFFFFFFF),
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          _buildPillItem(CupertinoIcons.arrow_turn_up_right, '공유'),
          const SizedBox(width: 8),
          _buildPillItem(CupertinoIcons.arrow_2_squarepath, '리믹스'),
          const SizedBox(width: 8),
          _buildPillItem(CupertinoIcons.arrow_down_to_line, '오프라인 저장'),
          const SizedBox(width: 8),
          _buildPillItem(CupertinoIcons.scissors, '클립'),
        ],
      ),
    );
  }

  Widget _buildPillItem(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF272727),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFFFFFFF), size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsPreview() {
    final previewComment = config.comments.isNotEmpty
        ? config.comments.first
        : YoutubeComment(
            author: 'FictionMaster',
            avatarUrl: 'https://picsum.photos/id/64/100/100',
            text: '이 영상 진짜 역대급 퀄리티네요! 다음 영상도 너무 기대됩니다 🔥',
            timeAgo: '2시간 전',
          );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GestureDetector(
        onTap: onOpenComments,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF272727),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    '댓글',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${config.comments.length}',
                    style: const TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    CupertinoIcons.chevron_up_chevron_down,
                    color: Color(0xFFAAAAAA),
                    size: 14,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFF444444),
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: previewComment.avatarUrl.isNotEmpty
                        ? Image.network(
                            previewComment.avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Center(
                              child: Text(
                                previewComment.author.isNotEmpty ? previewComment.author[0] : '?',
                                style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 9),
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              previewComment.author.isNotEmpty ? previewComment.author[0] : '?',
                              style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 9),
                            ),
                          ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      previewComment.text,
                      style: const TextStyle(
                        color: Color(0xFFEEEEEE),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendedList() {
    final list = config.recommendedVideos;
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = list[index];
        return GestureDetector(
          onTap: () => onSelectVideo?.call(item),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 16:9 Thumbnail
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 140,
                      height: 78,
                      color: const Color(0xFF272727),
                      child: Image.network(
                        item.thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Icon(
                            CupertinoIcons.play_rectangle_fill,
                            color: Color(0xFFFF0000),
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xDD000000),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.duration,
                        style: const TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              // Title and Channel Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.channelTitle,
                      style: const TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '조회수 ${item.viewCount} · ${item.publishedTime}',
                      style: const TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                CupertinoIcons.ellipsis_vertical,
                color: Color(0xFFAAAAAA),
                size: 14,
              ),
            ],
          ),
        );
      },
    );
  }
}
