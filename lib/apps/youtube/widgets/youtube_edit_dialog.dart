import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/youtube_model.dart';

class YouTubeEditDialog extends StatefulWidget {
  final YoutubeConfig config;
  final ValueChanged<YoutubeConfig> onApply;

  const YouTubeEditDialog({
    super.key,
    required this.config,
    required this.onApply,
  });

  @override
  State<YouTubeEditDialog> createState() => _YouTubeEditDialogState();
}

class _YouTubeEditDialogState extends State<YouTubeEditDialog> {
  late TextEditingController _titleCtrl;
  late TextEditingController _channelCtrl;
  late TextEditingController _subCountCtrl;
  late TextEditingController _viewCountCtrl;
  late TextEditingController _uploadTimeCtrl;
  late TextEditingController _likeCountCtrl;
  late TextEditingController _videoIdCtrl;
  late TextEditingController _descCtrl;

  late List<YoutubeComment> _comments;
  bool _isSubscribed = true;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    final cfg = widget.config;
    _titleCtrl = TextEditingController(text: cfg.title);
    _channelCtrl = TextEditingController(text: cfg.channelName);
    _subCountCtrl = TextEditingController(text: cfg.subscriberCount);
    _viewCountCtrl = TextEditingController(text: cfg.viewCount);
    _uploadTimeCtrl = TextEditingController(text: cfg.uploadTime);
    _likeCountCtrl = TextEditingController(text: cfg.likeCount);
    _videoIdCtrl = TextEditingController(text: cfg.videoId);
    _descCtrl = TextEditingController(text: cfg.description);
    _comments = List<YoutubeComment>.from(cfg.comments);
    _isSubscribed = cfg.isSubscribed;
    _isLiked = cfg.isLiked;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _channelCtrl.dispose();
    _subCountCtrl.dispose();
    _viewCountCtrl.dispose();
    _uploadTimeCtrl.dispose();
    _likeCountCtrl.dispose();
    _videoIdCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _applyPreset(YoutubeConfig preset) {
    setState(() {
      _titleCtrl.text = preset.title;
      _channelCtrl.text = preset.channelName;
      _subCountCtrl.text = preset.subscriberCount;
      _viewCountCtrl.text = preset.viewCount;
      _uploadTimeCtrl.text = preset.uploadTime;
      _likeCountCtrl.text = preset.likeCount;
      _videoIdCtrl.text = preset.videoId;
      _descCtrl.text = preset.description;
      _isSubscribed = preset.isSubscribed;
      _isLiked = preset.isLiked;
      _comments = List<YoutubeComment>.from(preset.comments);
    });
  }

  void _save() {
    final updated = widget.config.copyWith(
      title: _titleCtrl.text.trim(),
      channelName: _channelCtrl.text.trim(),
      subscriberCount: _subCountCtrl.text.trim(),
      viewCount: _viewCountCtrl.text.trim(),
      uploadTime: _uploadTimeCtrl.text.trim(),
      likeCount: _likeCountCtrl.text.trim(),
      videoId: _videoIdCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      isSubscribed: _isSubscribed,
      isLiked: _isLiked,
      comments: _comments,
    );
    widget.onApply(updated);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 680,
        height: 720,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF0000),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                const Text(
                  'YouTube 시나리오 & 영상 설정',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // 5대 장르 퀵 프리셋
            const Text(
              '🎯 웹툰 / 웹소설 장르별 원클릭 프리셋',
              style: TextStyle(color: Color(0xFF3EA6FF), fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPresetChip('⚔️ 헌터/각성', () => _applyPreset(YoutubeConfig.hunterPreset())),
                  _buildPresetChip('🕵️ 미스터리/폭로', () => _applyPreset(YoutubeConfig.mysteryPreset())),
                  _buildPresetChip('📉 코인/청산', () => _applyPreset(YoutubeConfig.coinPreset())),
                  _buildPresetChip('🎤 아이돌/직캠', () => _applyPreset(YoutubeConfig.idolPreset())),
                  _buildPresetChip('🎮 인방/합방', () => _applyPreset(YoutubeConfig.streamerPreset())),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Divider(color: Color(0xFF333333), height: 1),
            const SizedBox(height: 12),

            // Scrollable fields
            Expanded(
              child: ListView(
                children: [
                  _buildTextField('영상 제목 (Video Title)', _titleCtrl, maxLines: 2),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('채널명 (Channel Name)', _channelCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField('구독자 수 (Subscribers)', _subCountCtrl)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('조회수 (Views)', _viewCountCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField('업로드 시간 (Upload Time)', _uploadTimeCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField('좋아요 수 (Likes)', _likeCountCtrl)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField('유튜브 재생 비디오 ID (예: jfKfPfyJRdk)', _videoIdCtrl),
                  const SizedBox(height: 12),
                  _buildTextField('영상 설명문 (Description)', _descCtrl, maxLines: 3),
                  const SizedBox(height: 16),

                  // Comments section
                  Row(
                    children: [
                      const Text(
                        '💬 베스트 댓글 편집',
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        icon: const Icon(Icons.add, size: 16, color: Color(0xFF3EA6FF)),
                        label: const Text('댓글 추가', style: TextStyle(color: Color(0xFF3EA6FF), fontSize: 12)),
                        onPressed: () {
                          setState(() {
                            _comments.add(
                              YoutubeComment(
                                author: '새로운_시청자',
                                timeAgo: '방금 전',
                                text: '영상 진짜 잘 만드셨네요 대박 ㄷㄷ',
                                likes: 120,
                              ),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ..._comments.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final c = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF272727),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '@${c.author}',
                                      style: const TextStyle(color: Color(0xFF3EA6FF), fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(c.timeAgo, style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 11)),
                                    const Spacer(),
                                    Text('👍 ${c.likes}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(c.text, style: const TextStyle(color: Colors.white, fontSize: 12)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(CupertinoIcons.trash, color: Colors.redAccent, size: 16),
                            onPressed: () {
                              setState(() => _comments.removeAt(idx));
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소', style: TextStyle(color: Colors.white70)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF0000),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: _save,
                  child: const Text('적용하기', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetChip(String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label),
        backgroundColor: const Color(0xFF2A2A2A),
        labelStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
        side: const BorderSide(color: Color(0xFF444444)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled: true,
            fillColor: const Color(0xFF272727),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF3EA6FF))),
          ),
        ),
      ],
    );
  }
}
