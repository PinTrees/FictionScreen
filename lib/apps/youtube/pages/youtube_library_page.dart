import 'package:flutter/cupertino.dart';
import '../data/youtube_model.dart';

class YouTubeLibraryPage extends StatelessWidget {
  final YoutubeConfig config;
  final ValueChanged<YoutubeVideoItem> onSelectVideo;

  const YouTubeLibraryPage({
    super.key,
    required this.config,
    required this.onSelectVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopBar(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 16),
              _buildHistorySection(),
              const SizedBox(height: 20),
              _buildPlaylistsSection(),
              const SizedBox(height: 20),
              _buildMenuRow(CupertinoIcons.play_circle, '내 동영상'),
              _buildMenuRow(CupertinoIcons.arrow_down_to_line, '오프라인 저장 동영상', trailingText: '24개'),
              _buildMenuRow(CupertinoIcons.film, '내 영화'),
              _buildMenuRow(CupertinoIcons.chart_bar, '시청 시간'),
              _buildMenuRow(CupertinoIcons.question_circle, '고객센터 및 의견 보내기'),
            ],
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Icon(CupertinoIcons.tv, color: Color(0xFFFFFFFF), size: 20),
          SizedBox(width: 16),
          Icon(CupertinoIcons.bell, color: Color(0xFFFFFFFF), size: 20),
          SizedBox(width: 16),
          Icon(CupertinoIcons.search, color: Color(0xFFFFFFFF), size: 20),
          SizedBox(width: 16),
          Icon(CupertinoIcons.gear, color: Color(0xFFFFFFFF), size: 20),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFF2BA640),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'F',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Fiction Creator',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '@fiction_creator · 채널 보기 >',
                      style: TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildPillButton('계정 전환', CupertinoIcons.arrow_2_squarepath),
              const SizedBox(width: 8),
              _buildPillButton('Google 계정', CupertinoIcons.person_crop_circle),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPillButton(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF272727),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFFFFFFF), size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '기록',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '모두 보기',
                style: TextStyle(
                  color: Color(0xFF3EA6FF),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: config.recommendedVideos.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = config.recommendedVideos[index];
              return GestureDetector(
                onTap: () => onSelectVideo(item),
                child: SizedBox(
                  width: 140,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlaylistsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '재생목록',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '모두 보기',
                style: TextStyle(
                  color: Color(0xFF3EA6FF),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 130,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildPlaylistItem('좋아요 표시한 동영상', '48개', CupertinoIcons.hand_thumbsup_fill),
              const SizedBox(width: 10),
              _buildPlaylistItem('나중에 볼 동영상', '12개', CupertinoIcons.clock_fill),
              const SizedBox(width: 10),
              _buildPlaylistItem('코딩 & 개발 강좌', '35개', CupertinoIcons.play_rectangle_fill),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaylistItem(String title, String count, IconData icon) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 140,
            height: 78,
            decoration: BoxDecoration(
              color: const Color(0xFF272727),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(icon, color: const Color(0xFFAAAAAA), size: 32),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            count,
            style: const TextStyle(
              color: Color(0xFFAAAAAA),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuRow(IconData icon, String title, {String? trailingText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFFFFFF), size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (trailingText != null)
            Text(
              trailingText,
              style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 13),
            ),
        ],
      ),
    );
  }
}
