import 'package:flutter/cupertino.dart';
import '../data/youtube_model.dart';
import '../widgets/youtube_icons.dart';

class YouTubeHomeFeedPage extends StatefulWidget {
  final YoutubeConfig config;
  final ValueChanged<YoutubeVideoItem> onSelectVideo;

  const YouTubeHomeFeedPage({
    super.key,
    required this.config,
    required this.onSelectVideo,
  });

  @override
  State<YouTubeHomeFeedPage> createState() => _YouTubeHomeFeedPageState();
}

class _YouTubeHomeFeedPageState extends State<YouTubeHomeFeedPage> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = [
    '전체',
    '음악',
    '실시간',
    '게임',
    '맞춤동영상',
    '애니메이션',
    '새로운 콘텐츠',
    '최근에 업로드된 동영상',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopBar(),
        _buildFilterChips(),
        Expanded(
          child: ListView.builder(
            itemCount: widget.config.recommendedVideos.length + 1, // +1 for shorts shelf
            itemBuilder: (context, index) {
              if (index == 2) {
                return _buildShortsShelf();
              }
              final videoIndex = index > 2 ? index - 1 : index;
              if (videoIndex >= widget.config.recommendedVideos.length) {
                return const SizedBox.shrink();
              }
              final item = widget.config.recommendedVideos[videoIndex];
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

  Widget _buildFilterChips() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _selectedFilterIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilterIndex = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF272727),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  _filters[index],
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF0F0F0F) : const Color(0xFFFFFFFF),
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoCard(YoutubeVideoItem item) {
    return GestureDetector(
      onTap: () => widget.onSelectVideo(item),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
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
            // Info row
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

  Widget _buildShortsShelf() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: Color(0xFF272727), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: YouTubeIcons.shorts(filled: true, color: const Color(0xFFFF0000), size: 20),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Shorts',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              itemCount: 4,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, idx) {
                final titles = [
                  '오늘 밤하늘 대박 사건 실화냐 🌌',
                  '1분 만에 끝내는 Flutter Web 팁',
                  '귀여운 고양이 보며 힐링 타임 🐱',
                  '이 음식 안 먹어본 사람 없게 해주세요'
                ];
                final views = ['240만회', '88만회', '150만회', '310만회'];
                final imageIds = ['10', '20', '30', '40'];
                return Container(
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF272727),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        'https://picsum.photos/id/${imageIds[idx]}/300/500',
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0x00000000), Color(0xEE000000)],
                            stops: [0.5, 1.0],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 8,
                        right: 8,
                        bottom: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              titles[idx],
                              style: const TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '조회수 ${views[idx]}',
                              style: const TextStyle(
                                color: Color(0xFFCCCCCC),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
