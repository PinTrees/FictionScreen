import 'package:flutter/material.dart';
import '../data/youtube_model.dart';

class YouTubeDesktopHomePage extends StatefulWidget {
  final YoutubeConfig config;
  final ValueChanged<YoutubeVideoItem>? onSelectVideo;

  const YouTubeDesktopHomePage({
    super.key,
    required this.config,
    this.onSelectVideo,
  });

  @override
  State<YouTubeDesktopHomePage> createState() => _YouTubeDesktopHomePageState();
}

class _YouTubeDesktopHomePageState extends State<YouTubeDesktopHomePage> {
  String _selectedCategory = '전체';

  final List<String> _categories = [
    '전체',
    '게임',
    '음악',
    '뉴스',
    '실시간',
    '웹소설',
    '스릴러',
    '애니메이션',
    '만화',
    '액션',
    'IT/테크',
  ];

  @override
  Widget build(BuildContext context) {
    final videos = widget.config.recommendedVideos;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    backgroundColor: const Color(0xFF272727),
                    selectedColor: Colors.white,
                    showCheckmark: false,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    onSelected: (val) {
                      if (val) setState(() => _selectedCategory = cat);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 18),

          // 2. Responsive Grid of Videos
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              int crossAxisCount = 3;
              if (width > 1200) {
                crossAxisCount = 4;
              } else if (width < 750) {
                crossAxisCount = 2;
              }

              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: videos.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 24,
                  childAspectRatio: 16 / 13,
                ),
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return _buildVideoCard(video);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(YoutubeVideoItem video) {
    return InkWell(
      onTap: () => widget.onSelectVideo?.call(video),
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 16:9 Thumbnail
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: const Color(0xFF272727),
                    child: Image.network(
                      video.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: video.gradientColors),
                        ),
                        child: const Center(
                          child: Icon(Icons.play_circle_fill, color: Colors.white70, size: 36),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xDD000000),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      video.duration,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Channel Avatar + Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: video.channelAvatarBg,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    video.channelAvatarLetter,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      style: const TextStyle(
                        color: Color(0xFFF1F1F1),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            video.channelTitle,
                            style: const TextStyle(
                              color: Color(0xFFAAAAAA),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.check_circle, color: Color(0xFFAAAAAA), size: 12),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '조회수 ${video.viewCount} · ${video.publishedTime}',
                      style: const TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
