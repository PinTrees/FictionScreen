import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/blind_model.dart';

class BlindEditDialog extends StatefulWidget {
  final BlindPostItem post;
  final ValueChanged<BlindPostItem> onSave;

  const BlindEditDialog({
    super.key,
    required this.post,
    required this.onSave,
  });

  @override
  State<BlindEditDialog> createState() => _BlindEditDialogState();
}

class _BlindEditDialogState extends State<BlindEditDialog> {
  late TextEditingController _titleCtrl;
  late TextEditingController _contentCtrl;
  late TextEditingController _companyCtrl;
  late TextEditingController _maskedIdCtrl;
  late TextEditingController _viewsCtrl;
  late TextEditingController _likesCtrl;
  late TextEditingController _commentsCtrl;
  late TextEditingController _channelCtrl;
  late TextEditingController _timeCtrl;

  bool _hasPoll = false;
  late TextEditingController _pollTitleCtrl;
  late TextEditingController _opt1TextCtrl;
  late TextEditingController _opt1VotesCtrl;
  late TextEditingController _opt2TextCtrl;
  late TextEditingController _opt2VotesCtrl;

  @override
  void initState() {
    super.initState();
    final p = widget.post;
    _titleCtrl = TextEditingController(text: p.title);
    _contentCtrl = TextEditingController(text: p.content);
    _companyCtrl = TextEditingController(text: p.authorCompany);
    _maskedIdCtrl = TextEditingController(text: p.authorMaskedId);
    _viewsCtrl = TextEditingController(text: '${p.viewCount}');
    _likesCtrl = TextEditingController(text: '${p.likeCount}');
    _commentsCtrl = TextEditingController(text: '${p.commentCount}');
    _channelCtrl = TextEditingController(text: p.channel);
    _timeCtrl = TextEditingController(text: p.createdAt);

    _hasPoll = p.poll != null;
    final poll = p.poll;
    _pollTitleCtrl = TextEditingController(text: poll?.title ?? '어디로 가는 게 나을까요?');
    _opt1TextCtrl = TextEditingController(
      text: poll != null && poll.options.isNotEmpty ? poll.options[0].text : '옵션 1',
    );
    _opt1VotesCtrl = TextEditingController(
      text: poll != null && poll.options.isNotEmpty ? '${poll.options[0].votes}' : '500',
    );
    _opt2TextCtrl = TextEditingController(
      text: poll != null && poll.options.length > 1 ? poll.options[1].text : '옵션 2',
    );
    _opt2VotesCtrl = TextEditingController(
      text: poll != null && poll.options.length > 1 ? '${poll.options[1].votes}' : '300',
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    _companyCtrl.dispose();
    _maskedIdCtrl.dispose();
    _viewsCtrl.dispose();
    _likesCtrl.dispose();
    _commentsCtrl.dispose();
    _channelCtrl.dispose();
    _timeCtrl.dispose();
    _pollTitleCtrl.dispose();
    _opt1TextCtrl.dispose();
    _opt1VotesCtrl.dispose();
    _opt2TextCtrl.dispose();
    _opt2VotesCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    BlindPoll? updatedPoll;
    if (_hasPoll) {
      final opt1 = BlindPollOption(
        id: 'opt-1',
        text: _opt1TextCtrl.text.trim(),
        votes: int.tryParse(_opt1VotesCtrl.text.trim()) ?? 0,
      );
      final opt2 = BlindPollOption(
        id: 'opt-2',
        text: _opt2TextCtrl.text.trim(),
        votes: int.tryParse(_opt2VotesCtrl.text.trim()) ?? 0,
      );
      updatedPoll = BlindPoll(
        title: _pollTitleCtrl.text.trim(),
        options: [opt1, opt2],
        hasVoted: widget.post.poll?.hasVoted ?? false,
        selectedOptionId: widget.post.poll?.selectedOptionId,
      );
    }

    final updated = widget.post.copyWith(
      title: _titleCtrl.text.trim(),
      content: _contentCtrl.text.trim(),
      authorCompany: _companyCtrl.text.trim(),
      authorMaskedId: _maskedIdCtrl.text.trim(),
      channel: _channelCtrl.text.trim(),
      createdAt: _timeCtrl.text.trim(),
      viewCount: int.tryParse(_viewsCtrl.text.trim()) ?? 0,
      likeCount: int.tryParse(_likesCtrl.text.trim()) ?? 0,
      commentCount: int.tryParse(_commentsCtrl.text.trim()) ?? 0,
      poll: updatedPoll,
    );

    widget.onSave(updated);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 520,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDA3238).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(CupertinoIcons.pencil, size: 18, color: Color(0xFFDA3238)),
                ),
                const SizedBox(width: 10),
                const Text(
                  '블라인드 게시글 편집',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E2024),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(CupertinoIcons.xmark, size: 18, color: Color(0xFF8A8F98)),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('기본 정보'),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _companyCtrl,
                            label: '작성자 회사',
                            hint: '삼성전자',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            controller: _maskedIdCtrl,
                            label: '마스킹 ID',
                            hint: 's***',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            controller: _channelCtrl,
                            label: '채널',
                            hint: '이직·커리어',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _titleCtrl,
                      label: '게시글 제목',
                      hint: '제목을 입력하세요',
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _contentCtrl,
                      label: '본문 내용',
                      hint: '본문을 입력하세요',
                      maxLines: 5,
                    ),
                    const SizedBox(height: 14),
                    _buildSectionHeader('수치 및 지표'),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _viewsCtrl,
                            label: '조회수',
                            hint: '4280',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            controller: _likesCtrl,
                            label: '좋아요(추천)',
                            hint: '184',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            controller: _commentsCtrl,
                            label: '댓글수',
                            hint: '52',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            controller: _timeCtrl,
                            label: '작성 시각',
                            hint: '15분 전',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionHeader('투표(Poll) 설정'),
                        Switch(
                          value: _hasPoll,
                          activeThumbColor: const Color(0xFFDA3238),
                          onChanged: (v) => setState(() => _hasPoll = v),
                        ),
                      ],
                    ),
                    if (_hasPoll) ...[
                      _buildTextField(
                        controller: _pollTitleCtrl,
                        label: '투표 질문',
                        hint: '투표 질문을 입력하세요',
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildTextField(
                              controller: _opt1TextCtrl,
                              label: '선택지 1',
                              hint: '항목 내용',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: _buildTextField(
                              controller: _opt1VotesCtrl,
                              label: '득표수 1',
                              hint: '842',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildTextField(
                              controller: _opt2TextCtrl,
                              label: '선택지 2',
                              hint: '항목 내용',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: _buildTextField(
                              controller: _opt2VotesCtrl,
                              label: '득표수 2',
                              hint: '1215',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소', style: TextStyle(color: Color(0xFF8A8F98))),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDA3238),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  ),
                  child: const Text('적용하기', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF495057),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11.5, color: Color(0xFF6C757D), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 13.5, color: Color(0xFF212529)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 12.5, color: Color(0xFFADB5BD)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            isDense: true,
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFDA3238)),
            ),
          ),
        ),
      ],
    );
  }
}
