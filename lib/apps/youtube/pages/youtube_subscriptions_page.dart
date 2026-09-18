import 'package:flutter/cupertino.dart';
import '../data/youtube_model.dart';
import '../widgets/youtube_icons.dart';

class YouTubeSubscriptionsPage extends StatelessWidget {
  final YoutubeConfig config;
  final ValueChanged<YoutubeVideoItem> onSelectVideo;

  const YouTubeSubscriptionsPage({
    super.key,
    required this.config,
    required this.onSelectVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopBar(),
        _buildChannelsTray(),
        Container(height: 1, color: const Color(0xFF272727)),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: config.recommendedVideos.length,
            itemBuilder: (context, index) {
              final item = config.recommendedVideos[index];
              return _buildVideoCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      color: const Color(0xFF0F0F0F),
      child: Row(
        children: [
          YouTubeIcons.logo(isDark: true),
          const Spacer(),
          const Icon(CupertinoIcons.tv, color: Color(0xFFFFFFFF), size: 20),
          const SizedBox(width: 16),
          const Icon(CupertinoIcons.bell, color: Color(0xFFFFFFFF), size: 20),
          const SizedBox(width: 16),
          const Icon(CupertinoIcons.search, color: Color(0xFFFFFFFF), size: 20),
        ],
      ),
    );
  }

  Widget _buildChannelsTray() {
    final channels = config.subscribedChannels;
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: channels.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final ch = channels[index];
          return SizedBox(
            width: 62,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: ch.avatarBg,
                        shape: BoxShape.circle,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: ch.avatarUrl.isNotEmpty
                          ? Image.network(
                              ch.avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Center(
                                child: Text(ch.avatarLetter, style: const TextStyle(color: Color(0xFFFFFFFF))),
                              ),
                            )
                          : Center(
                              child: Text(ch.avatarLetter, style: const TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold)),
                            ),
                    ),
                    if (ch.hasNew)
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3EA6FF),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF0F0F0F), width: 1.5),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  ch.name,
                  style: const TextStyle(
                    color: Color(0xFFEEEEEE),
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoCard(YoutubeVideoItem item) {
    return GestureDetector(
      onTap: () => onSelectVideo(item),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  Container(
                    color: const Color(0xFF1F1F1F),
                    child: Image.network(
                      item.thumbnailUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(
                          CupertinoIcons.play_rectangle_fill,
                          color: Color(0xFFFF0000),
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
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
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 8, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: item.channelAvatarBg,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        item.channelAvatarLetter,
                        style: const TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.channelTitle} · 조회수 ${item.viewCount} · ${item.publishedTime}',
                          style: const TextStyle(
                            color: Color(0xFFAAAAAA),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    CupertinoIcons.ellipsis_vertical,
                    color: Color(0xFFAAAAAA),
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
