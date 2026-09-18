import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/instagram_model.dart';
import '../widgets/instagram_comments_sheet.dart';
import '../widgets/instagram_icons.dart';
import '../widgets/instagram_modal_scope.dart';

class InstagramReelsPage extends StatefulWidget {
  const InstagramReelsPage({super.key});

  @override
  State<InstagramReelsPage> createState() => _InstagramReelsPageState();
}

class _InstagramReelsPageState extends State<InstagramReelsPage> with SingleTickerProviderStateMixin {
  bool _isLiked = false;
  int _likeCount = 48200;
  bool _isSaved = false;
  bool _isFollowing = false;
  late AnimationController _discAnimController;

  final List<InstagramCommentItem> _reelsComments = [
    InstagramCommentItem(id: 'rc1', username: 'beach_lover', text: '여기 위치 어디인가요?? 당장 가고 싶네요 ㅠㅠ', timeAgo: '2시간 전', likes: 18),
    InstagramCommentItem(id: 'rc2', username: 'sound_wave', text: '파도 소리 ASMR 미쳤다... 이어폰 필수', timeAgo: '1시간 전', likes: 7),
  ];

  @override
  void initState() {
    super.initState();
    _discAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _discAnimController.dispose();
    super.dispose();
  }

  void _openComments() {
    final modalScope = InstagramModalScope.maybeOf(context);
    final sheet = InstagramCommentsSheet(
      comments: _reelsComments,
      onAddComment: (text) {
        setState(() {
          _reelsComments.add(
            InstagramCommentItem(
              id: 'rc_${DateTime.now().millisecondsSinceEpoch}',
              username: 'sunset_traveler',
              text: text,
              timeAgo: '방금 전',
            ),
          );
        });
      },
    );

    if (modalScope != null) {
      modalScope.showModal(sheet);
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => sheet,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Video/Photo Mockup
          Image.asset(
            'assets/images/macos_golden_gate.webp',
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E1B4B), Color(0xFF4C1D95), Color(0xFFE11D48)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Center(
                child: Icon(CupertinoIcons.play_circle_fill, size: 80, color: Colors.white70),
              ),
            ),
          ),

          // Gradient overlay for readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.75),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Top Header: "릴스" + Camera Icon
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '릴스',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(CupertinoIcons.camera, color: Colors.white, size: 24),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('릴스 카메라를 실행합니다 📹'), duration: Duration(seconds: 1)),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Right Vertical Actions Rail
          Positioned(
            right: 12,
            bottom: 36,
            child: Column(
              children: [
                _buildActionWidget(
                  iconWidget: InstagramIcons.heart(
                    filled: _isLiked,
                    color: _isLiked ? Colors.red : Colors.white,
                    size: 28,
                  ),
                  label: '${(_likeCount / 1000).toStringAsFixed(1)}k',
                  onTap: () {
                    setState(() {
                      _isLiked = !_isLiked;
                      _likeCount += _isLiked ? 1 : -1;
                    });
                  },
                ),
                const SizedBox(height: 18),
                _buildActionWidget(
                  iconWidget: InstagramIcons.comment(
                    color: Colors.white,
                    size: 26,
                  ),
                  label: '${_reelsComments.length}',
                  onTap: _openComments,
                ),
                const SizedBox(height: 18),
                _buildActionWidget(
                  iconWidget: InstagramIcons.share(
                    color: Colors.white,
                    size: 26,
                  ),
                  label: '공유',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('릴스를 공유했습니다 ✈️'), duration: Duration(seconds: 1)),
                    );
                  },
                ),
                const SizedBox(height: 18),
                _buildActionWidget(
                  iconWidget: InstagramIcons.bookmark(
                    filled: _isSaved,
                    color: Colors.white,
                    size: 26,
                  ),
                  label: '저장',
                  onTap: () {
                    setState(() {
                      _isSaved = !_isSaved;
                    });
                  },
                ),
                const SizedBox(height: 18),
                IconButton(
                  icon: const Icon(CupertinoIcons.ellipsis, color: Colors.white, size: 20),
                  onPressed: () {},
                ),
                const SizedBox(height: 14),

                // Rotating Vinyl Audio Disc
                RotationTransition(
                  turns: _discAnimController,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white70, width: 2),
                      color: Colors.black,
                    ),
                    child: const Center(
                      child: Icon(CupertinoIcons.music_note_2, color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Left Content: Creator & Caption & Audio Ticker
          Positioned(
            left: 16,
            right: 76,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Creator Profile Row
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xFFF97316),
                      child: Text('S', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'sunset_traveler',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isFollowing = !_isFollowing;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: _isFollowing ? Colors.transparent : Colors.white.withValues(alpha: 0.2),
                          border: Border.all(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _isFollowing ? '팔로잉' : '팔로우',
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
                const SizedBox(height: 10),

                // Caption
                const Text(
                  '끝없이 펼쳐진 노을과 파도 소리... 🌅✨ 마음까지 평화로워지는 순간! #노을 #바다 #릴스 #힐링여행',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
                ),
                const SizedBox(height: 10),

                // Audio ticker
                Row(
                  children: const [
                    Icon(CupertinoIcons.music_note_2, color: Colors.white70, size: 14),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'sunset_beats · 오리지널 오디오',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionWidget({
    required Widget iconWidget,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: Center(child: iconWidget),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
