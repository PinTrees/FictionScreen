import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/blind_model.dart';
import '../../widgets/blind_comment_tile.dart';
import '../../widgets/blind_company_badge.dart';
import '../../widgets/blind_poll_widget.dart';
import '../../widgets/blind_post_card.dart';
import 'blind_desktop_header.dart';

class BlindDesktopHomePage extends StatefulWidget {
  final BlindConfig config;
  final ValueChanged<BlindConfig>? onConfigChanged;
  final VoidCallback onEditStory;

  const BlindDesktopHomePage({
    super.key,
    required this.config,
    this.onConfigChanged,
    required this.onEditStory,
  });

  @override
  State<BlindDesktopHomePage> createState() => _BlindDesktopHomePageState();
}

class _BlindDesktopHomePageState extends State<BlindDesktopHomePage> {
  int _navIndex = 0;
  String _selectedChannel = '전체';
  int _feedSubTabIndex = 0; // 0: 추천, 1: 최신, 2: 인기
  bool _isDetailView = true;
  late BlindPostItem _activePost;
  final TextEditingController _commentInputCtrl = TextEditingController();

  final List<String> _channels = [
    '전체',
    '블라블라',
    '직장인 토픽',
    '이직·커리어',
    '썸·연애',
    '주식·투자',
    '부동산',
    '암호화폐',
    'IT·인터넷',
    '취미생활',
    '차·바이크',
  ];

  final List<Map<String, dynamic>> _trendingKeywords = [
    {'rank': 1, 'word': '성과급', 'isNew': false},
    {'rank': 2, 'word': '이직 연봉', 'isNew': false},
    {'rank': 3, 'word': '네카라쿠배', 'isNew': true},
    {'rank': 4, 'word': '삼전 DS', 'isNew': false},
    {'rank': 5, 'word': '재택근무 폐지', 'isNew': false},
    {'rank': 6, 'word': '희망퇴직', 'isNew': false},
    {'rank': 7, 'word': '주택청약', 'isNew': false},
    {'rank': 8, 'word': '블라 소개팅', 'isNew': true},
    {'rank': 9, 'word': '미국 빅테크', 'isNew': false},
    {'rank': 10, 'word': '개발자 포트폴리오', 'isNew': false},
  ];

  final List<Map<String, String>> _popularCompanies = [
    {'name': '삼성전자', 'category': 'IT·전자', 'count': '18.4만 글'},
    {'name': '네이버', 'category': '포털·인터넷', 'count': '9.8만 글'},
    {'name': '현대자동차', 'category': '제조·자동차', 'count': '12.1만 글'},
    {'name': '카카오', 'category': 'IT·모바일', 'count': '8.5만 글'},
    {'name': 'SK하이닉스', 'category': '반도체', 'count': '10.3만 글'},
    {'name': '비바리퍼블리카(토스)', 'category': '핀테크', 'count': '5.2만 글'},
    {'name': '쿠팡', 'category': '이커머스', 'count': '7.9만 글'},
  ];

  @override
  void initState() {
    super.initState();
    _activePost = widget.config.currentPost;
    _selectedChannel = widget.config.selectedChannel;
  }

  @override
  void didUpdateWidget(covariant BlindDesktopHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      _activePost = widget.config.currentPost;
      _selectedChannel = widget.config.selectedChannel;
    }
  }

  @override
  void dispose() {
    _commentInputCtrl.dispose();
    super.dispose();
  }

  void _handleVote(String optionId) {
    final poll = _activePost.poll;
    if (poll == null) return;

    final updatedOptions = poll.options.map((opt) {
      if (opt.id == optionId) {
        return opt.copyWith(votes: opt.votes + 1, isVoted: true);
      } else if (poll.selectedOptionId == opt.id) {
        return opt.copyWith(votes: (opt.votes - 1).clamp(0, 9999999), isVoted: false);
      }
      return opt.copyWith(isVoted: false);
    }).toList();

    final updatedPoll = poll.copyWith(
      options: updatedOptions,
      hasVoted: true,
      selectedOptionId: optionId,
    );

    final updatedPost = _activePost.copyWith(poll: updatedPoll);
    setState(() => _activePost = updatedPost);
    widget.onConfigChanged?.call(widget.config.copyWith(currentPost: updatedPost));
  }

  void _handlePostLike() {
    final newIsLiked = !_activePost.isLiked;
    final newLikes = newIsLiked ? _activePost.likeCount + 1 : (_activePost.likeCount - 1).clamp(0, 9999999);
    final updatedPost = _activePost.copyWith(isLiked: newIsLiked, likeCount: newLikes);
    setState(() => _activePost = updatedPost);
    widget.onConfigChanged?.call(widget.config.copyWith(currentPost: updatedPost));
  }

  void _handleAddComment() {
    final text = _commentInputCtrl.text.trim();
    if (text.isEmpty) return;

    final newComment = BlindCommentItem(
      id: 'c-${DateTime.now().millisecondsSinceEpoch}',
      authorCompany: '토스',
      authorMaskedId: 't***',
      content: text,
      timeAgo: '방금 전',
    );

    final updatedComments = [newComment, ..._activePost.comments];
    final updatedPost = _activePost.copyWith(
      comments: updatedComments,
      commentCount: _activePost.commentCount + 1,
    );

    _commentInputCtrl.clear();
    setState(() => _activePost = updatedPost);
    widget.onConfigChanged?.call(widget.config.copyWith(currentPost: updatedPost));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FA),
      body: Column(
        children: [
          BlindDesktopHeader(
            selectedNavIndex: _navIndex,
            onNavTap: (idx) => setState(() => _navIndex = idx),
            onEditStory: widget.onEditStory,
            onWritePost: widget.onEditStory,
          ),
          Expanded(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1180),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column: Channels
                    SizedBox(width: 210, child: _buildLeftSidebar()),
                    const SizedBox(width: 20),

                    // Center Column: Feed / Post Detail
                    Expanded(
                      child: _isDetailView ? _buildPostDetailView() : _buildFeedView(),
                    ),
                    const SizedBox(width: 20),

                    // Right Column: Trending & Companies
                    SizedBox(width: 270, child: _buildRightSidebar()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftSidebar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Text(
              '토픽 채널',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E2024),
              ),
            ),
          ),
          const Divider(color: Color(0xFFF1F3F5), height: 12),
          ...List.generate(_channels.length, (idx) {
            final ch = _channels[idx];
            final isSelected = _selectedChannel == ch;
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedChannel = ch;
                  _isDetailView = false;
                });
              },
              child: Container(
                color: isSelected ? const Color(0xFFFFF0F0) : Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      ch,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? const Color(0xFFDA3238) : const Color(0xFF495057),
                      ),
                    ),
                    const Spacer(),
                    if (isSelected)
                      const Icon(CupertinoIcons.chevron_right, size: 12, color: Color(0xFFDA3238)),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPostDetailView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Navigation breadcrumb
            Row(
              children: [
                InkWell(
                  onTap: () => setState(() => _isDetailView = false),
                  borderRadius: BorderRadius.circular(4),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.arrow_left, size: 14, color: Color(0xFF8A8F98)),
                        SizedBox(width: 4),
                        Text(
                          '목록으로',
                          style: TextStyle(fontSize: 12.5, color: Color(0xFF8A8F98)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('>', style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F3F5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _activePost.channel,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF495057),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Post Title
            Text(
              _activePost.title,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E2024),
                height: 1.35,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 10),

            // Company & Meta Info
            Row(
              children: [
                BlindCompanyBadge(
                  company: _activePost.authorCompany,
                  maskedId: _activePost.authorMaskedId,
                  timeAgo: _activePost.createdAt,
                  viewCount: _activePost.viewCount,
                  fontSize: 13,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(CupertinoIcons.pencil_outline, size: 16, color: Color(0xFF8A8F98)),
                  onPressed: widget.onEditStory,
                  tooltip: '게시글 수정',
                ),
              ],
            ),
            const Divider(color: Color(0xFFF1F3F5), height: 26),

            // Post Body Content
            Text(
              _activePost.content,
              style: const TextStyle(
                fontSize: 14.5,
                color: Color(0xFF2B2D31),
                height: 1.7,
                letterSpacing: -0.2,
              ),
            ),

            // Poll Widget if present
            if (_activePost.poll != null)
              BlindPollWidget(
                poll: _activePost.poll!,
                onVote: _handleVote,
              ),

            const SizedBox(height: 20),

            // Action Buttons: Like & Bookmark
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: _handlePostLike,
                  icon: Icon(
                    _activePost.isLiked ? CupertinoIcons.hand_thumbsup_fill : CupertinoIcons.hand_thumbsup,
                    size: 15,
                    color: _activePost.isLiked ? const Color(0xFFDA3238) : const Color(0xFF495057),
                  ),
                  label: Text(
                    '추천 ${_activePost.likeCount}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _activePost.isLiked ? const Color(0xFFDA3238) : const Color(0xFF495057),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: _activePost.isLiked ? const Color(0xFFDA3238) : const Color(0xFFDEE2E6),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.bookmark, size: 15, color: Color(0xFF495057)),
                  label: const Text(
                    '스크랩',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF495057)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFDEE2E6)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  ),
                ),
              ],
            ),
            const Divider(color: Color(0xFFF1F3F5), height: 36),

            // Comment Input Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE9ECEF)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(CupertinoIcons.building_2_fill, size: 12, color: Color(0xFFDA3238)),
                      const SizedBox(width: 4),
                      const Text(
                        '토스 · t*** (익명)',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF495057)),
                      ),
                      const Spacer(),
                      const Text(
                        '솔직하고 따뜻한 댓글을 남겨주세요',
                        style: TextStyle(fontSize: 11, color: Color(0xFFADB5BD)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _commentInputCtrl,
                    maxLines: 2,
                    cursorColor: const Color(0xFFDA3238),
                    style: const TextStyle(fontSize: 13, color: Color(0xFF1E2024)),
                    decoration: const InputDecoration(
                      hintText: '댓글을 남겨보세요.',
                      hintStyle: TextStyle(fontSize: 12.5, color: Color(0xFFADB5BD)),
                      filled: false,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _handleAddComment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDA3238),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        elevation: 0,
                      ),
                      child: const Text('등록', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Comments List Header
            Row(
              children: [
                const Text(
                  '댓글',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1E2024)),
                ),
                const SizedBox(width: 6),
                Text(
                  '${_activePost.commentCount}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFFDA3238)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Comments
            ..._activePost.comments.map(
              (c) => BlindCommentTile(comment: c),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Feed tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF1F3F5))),
            ),
            child: Row(
              children: [
                _buildFeedSubTab(0, '추천'),
                _buildFeedSubTab(1, '최신'),
                _buildFeedSubTab(2, '인기'),
                const Spacer(),
                Text(
                  '선택된 채널: $_selectedChannel',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF8A8F98)),
                ),
              ],
            ),
          ),
          // Posts
          Expanded(
            child: ListView.builder(
              itemCount: widget.config.feedPosts.length,
              itemBuilder: (context, idx) {
                final post = widget.config.feedPosts[idx];
                return BlindPostCard(
                  post: post,
                  onTap: () {
                    setState(() {
                      _activePost = post;
                      _isDetailView = true;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedSubTab(int idx, String title) {
    final isSelected = _feedSubTabIndex == idx;
    return InkWell(
      onTap: () => setState(() => _feedSubTabIndex = idx),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? const Color(0xFFDA3238) : const Color(0xFF8A8F98),
          ),
        ),
      ),
    );
  }

  Widget _buildRightSidebar() {
    return Column(
      children: [
        // Realtime Trending keywords
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE9ECEF)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(CupertinoIcons.flame_fill, size: 14, color: Color(0xFFDA3238)),
                  SizedBox(width: 6),
                  Text(
                    '실시간 인기 검색어',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E2024),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ..._trendingKeywords.map((item) {
                final rank = item['rank'] as int;
                final word = item['word'] as String;
                final isNew = item['isNew'] as bool;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        child: Text(
                          '$rank',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: rank <= 3 ? const Color(0xFFDA3238) : const Color(0xFF8A8F98),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          word,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF33363D),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isNew)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDA3238).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFDA3238),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Popular Companies
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE9ECEF)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '인기 기업 랭킹',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E2024),
                ),
              ),
              const SizedBox(height: 10),
              ..._popularCompanies.take(5).map((comp) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.building_2_fill, size: 12, color: Color(0xFF8A8F98)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          comp['name']!,
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF22252A)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        comp['count']!,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF9EA3AA)),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
