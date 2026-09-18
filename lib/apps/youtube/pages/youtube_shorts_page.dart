import 'package:flutter/cupertino.dart';
import '../data/youtube_model.dart';

class YouTubeShortsPage extends StatefulWidget {
  final YoutubeConfig config;
  final VoidCallback onOpenComments;

  const YouTubeShortsPage({
    super.key,
    required this.config,
    required this.onOpenComments,
  });

  @override
  State<YouTubeShortsPage> createState() => _YouTubeShortsPageState();
}

class _YouTubeShortsPageState extends State<YouTubeShortsPage> {
  bool _isLiked = false;
  bool _isSubscribed = false;

  final List<Map<String, String>> _shortsData = [
    {
      'title': 'AI로 10초 만에 배경화면 만들기 🎨 #shorts #ai #tech',
      'channel': 'DevStudio',
      'handle': '@devstudio_kr',
      'avatar': 'https://picsum.photos/id/64/100/100',
      'sound': 'Original Audio - DevStudio',
      'image': 'https://picsum.photos/id/10/600/1000',
      'likes': '14.2만',
      'comments': '1,280',
    },
    {
      'title': '오늘 밤하늘 오로라 실화냐 🌌 넋 놓고 보게 되는 풍경 #힐링',
      'channel': 'SkyTraveler',
      'handle': '@sky_traveler',
      'avatar': 'https://picsum.photos/id/102/100/100',
      'sound': 'Calm Piano & Ambient Rain',
      'image': 'https://picsum.photos/id/29/600/1000',
      'likes': '8.9만',
      'comments': '642',
    },
    {
      'title': '고양이한테 새 간식을 줬을 때 반응 🐱 귀여움 주의!',
      'channel': 'MeowLife',
      'handle': '@meow_life',
      'avatar': 'https://picsum.photos/id/40/100/100',
      'sound': 'Cute Funny BGM - PetSounds',
      'image': 'https://picsum.photos/id/1062/600/1000',
      'likes': '32.1만',
      'comments': '3,410',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _shortsData.length,
      onPageChanged: (index) {
        setState(() {
          _isLiked = false;
          _isSubscribed = false;
        });
      },
      itemBuilder: (context, index) {
        final short = _shortsData[index];
        return _buildShortItem(short);
      },
    );
  }

  Widget _buildShortItem(Map<String, String> short) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image / Video simulation
        Image.network(
          short['image']!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFF1E1E1E)),
        ),

        // Gradient overlay for readability
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x66000000),
                Color(0x00000000),
                Color(0x00000000),
                Color(0xCC000000),
              ],
              stops: [0.0, 0.2, 0.6, 1.0],
            ),
          ),
        ),

        // Top Navigation Bar
        Positioned(
          top: 8,
          left: 14,
          right: 14,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Shorts',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              Row(
                children: const [
                  Icon(CupertinoIcons.search, color: Color(0xFFFFFFFF), size: 22),
                  SizedBox(width: 18),
                  Icon(CupertinoIcons.camera, color: Color(0xFFFFFFFF), size: 22),
                  SizedBox(width: 18),
                  Icon(CupertinoIcons.ellipsis_vertical, color: Color(0xFFFFFFFF), size: 20),
                ],
              ),
            ],
          ),
        ),

        // Right Action Rail
        Positioned(
          right: 10,
          bottom: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Like
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isLiked = !_isLiked;
                  });
                },
                child: Column(
                  children: [
                    Icon(
                      _isLiked ? CupertinoIcons.hand_thumbsup_fill : CupertinoIcons.hand_thumbsup,
                      color: _isLiked ? const Color(0xFFFF0000) : const Color(0xFFFFFFFF),
                      size: 28,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      short['likes']!,
                      style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Dislike
              Column(
                children: const [
                  Icon(CupertinoIcons.hand_thumbsdown, color: Color(0xFFFFFFFF), size: 28),
                  SizedBox(height: 4),
                  Text('싫어요', style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 18),

              // Comments
              GestureDetector(
                onTap: widget.onOpenComments,
                child: Column(
                  children: [
                    const Icon(CupertinoIcons.chat_bubble_fill, color: Color(0xFFFFFFFF), size: 28),
                    const SizedBox(height: 4),
                    Text(
                      short['comments']!,
                      style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Share
              Column(
                children: const [
                  Icon(CupertinoIcons.arrow_turn_up_right, color: Color(0xFFFFFFFF), size: 28),
                  SizedBox(height: 4),
                  Text('공유', style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 18),

              // Remix
              Column(
                children: const [
                  Icon(CupertinoIcons.arrow_2_squarepath, color: Color(0xFFFFFFFF), size: 28),
                  SizedBox(height: 4),
                  Text('리믹스', style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 18),

              // Audio rotating disc
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFFFFFFF), width: 1.5),
                  image: DecorationImage(
                    image: NetworkImage(short['avatar']!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bottom Left Content Info
        Positioned(
          left: 12,
          right: 70,
          bottom: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Channel Info & Subscribe button
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(short['avatar']!, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    short['handle']!,
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSubscribed = !_isSubscribed;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _isSubscribed ? const Color(0x66000000) : const Color(0xFFFF0000),
                        borderRadius: BorderRadius.circular(16),
                        border: _isSubscribed ? Border.all(color: const Color(0x88FFFFFF)) : null,
                      ),
                      child: Text(
                        _isSubscribed ? '구독중' : '구독',
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
              const SizedBox(height: 10),

              // Title / Caption
              Text(
                short['title']!,
                style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 13,
                  height: 1.3,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Sound row
              Row(
                children: [
                  const Icon(CupertinoIcons.music_note_2, color: Color(0xFFFFFFFF), size: 13),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      short['sound']!,
                      style: const TextStyle(
                        color: Color(0xFFDDDDDD),
                        fontSize: 11,
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
      ],
    );
  }
}
