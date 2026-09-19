import 'package:flutter/material.dart';
import '../data/dcinside_model.dart';

class DcinsideEditDialog extends StatefulWidget {
  final DcinsideConfig config;
  final ValueChanged<DcinsideConfig> onApply;

  const DcinsideEditDialog({
    super.key,
    required this.config,
    required this.onApply,
  });

  @override
  State<DcinsideEditDialog> createState() => _DcinsideEditDialogState();
}

class _DcinsideEditDialogState extends State<DcinsideEditDialog> {
  late TextEditingController _galleryNameController;
  late String _galleryCategory;
  late TextEditingController _titleController;
  late TextEditingController _categoryController;
  late TextEditingController _authorController;
  late TextEditingController _ipController;
  late DcAuthorType _authorType;
  late TextEditingController _contentController;
  late TextEditingController _recommendController;
  late TextEditingController _dislikeController;
  late TextEditingController _viewCountController;
  late TextEditingController _createdAtController;

  @override
  void initState() {
    super.initState();
    final c = widget.config;
    final currentPost = c.posts.firstWhere(
      (p) => p.id == c.selectedPostId,
      orElse: () => c.posts.first,
    );

    _galleryNameController = TextEditingController(text: c.galleryName);
    _galleryCategory = c.galleryCategory;
    _titleController = TextEditingController(text: currentPost.title);
    _categoryController = TextEditingController(text: currentPost.category);
    _authorController = TextEditingController(text: currentPost.authorName);
    _ipController = TextEditingController(text: currentPost.ipOrBadge);
    _authorType = currentPost.authorType;
    _contentController = TextEditingController(text: currentPost.content);
    _recommendController = TextEditingController(text: currentPost.recommendCount.toString());
    _dislikeController = TextEditingController(text: currentPost.dislikeCount.toString());
    _viewCountController = TextEditingController(text: currentPost.viewCount.toString());
    _createdAtController = TextEditingController(text: currentPost.createdAt);
  }

  @override
  void dispose() {
    _galleryNameController.dispose();
    _titleController.dispose();
    _categoryController.dispose();
    _authorController.dispose();
    _ipController.dispose();
    _contentController.dispose();
    _recommendController.dispose();
    _dislikeController.dispose();
    _viewCountController.dispose();
    _createdAtController.dispose();
    super.dispose();
  }

  void _applyPreset(int index) {
    setState(() {
      switch (index) {
        case 0: // 헌터 / 각성자 갤러리
          _galleryNameController.text = '각성자 갤러리';
          _galleryCategory = '마이너 갤러리';
          _categoryController.text = '[일반]';
          _titleController.text = '야 방금 F급 짐꾼 S급 각성한 거 실화냐? ㄷㄷㄷ';
          _contentController.text = '강남 던전 브레이크 현장에서 짐꾼 한 명이 맨손으로 보스 몬스터 찢어버림 ㅋㅋㅋㅋ\n\n'
              '옆에 있던 길드 마스터 표정 굳은 거 봤냐?\n'
              '검은 오라 치솟으면서 대검 소환하던데 진짜 각성자 협회 난리 나겠네 ㄷㄷ\n\n'
              '이 사람 과거 기록 아는 사람 있냐? 전생에 영웅이었나 봄 ㄹㅇ';
          _authorController.text = 'ㅇㅇ';
          _ipController.text = '(223.38)';
          _authorType = DcAuthorType.anonymous;
          _recommendController.text = '1420';
          _dislikeController.text = '18';
          _viewCountController.text = '4821';
          _createdAtController.text = '2026.09.19 16:42:15';
          break;
        case 1: // 아이돌 / 연예계
          _galleryNameController.text = '여자 아이돌 갤러리';
          _galleryCategory = '마이너 갤러리';
          _categoryController.text = '[후기]';
          _titleController.text = '속보) 이번 신인 걸그룹 음방 1위 앵콜 라이브 미쳤음 ㅋㅋㅋㅋ';
          _contentController.text = 'MR 제거 영상 떴는데 라이브 개잘함 ㄹㅇ ㅋㅋㅋㅋ\n\n'
              '메인보컬 고음 3단 지르고 춤추는데 숨도 안 차네\n'
              '올해 신인상은 그냥 얘네가 다 쓸어먹을 듯. 인정하면 개추 눌러라';
          _authorController.text = '음악평론가';
          _ipController.text = '갤로그';
          _authorType = DcAuthorType.fixed;
          _recommendController.text = '2150';
          _dislikeController.text = '42';
          _viewCountController.text = '7890';
          _createdAtController.text = '2026.09.19 17:10:00';
          break;
        case 2: // 주식 / 코인 청산
          _galleryNameController.text = '해외주식 갤러리';
          _galleryCategory = '정식 갤러리';
          _categoryController.text = '[인증]';
          _titleController.text = '한강 수온 체크하러 간다... 전재산 풀숏 쳤다가 청산당함';
          _contentController.text = '엔비디아 실적 발표 전에 올인 숏 쳤는데 실적 서프라이즈 +15% 떡상 ㅋㅋㅋㅋㅋ\n\n'
              '계좌 잔고 0원 찍혔다. 대출금 5천만원 어떡하냐?\n'
              '어머니 죄송합니다 다음 생에 봬요...';
          _authorController.text = 'ㅇㅇ';
          _ipController.text = '(118.235)';
          _authorType = DcAuthorType.anonymous;
          _recommendController.text = '980';
          _dislikeController.text = '14';
          _viewCountController.text = '3450';
          _createdAtController.text = '2026.09.19 09:30:11';
          break;
        case 3: // 내부고발 / 폭로
          _galleryNameController.text = '정치·사회 갤러리';
          _galleryCategory = '정식 갤러리';
          _categoryController.text = '[폭로]';
          _titleController.text = '[폭로/인증] ○○그룹 총수 일가 비자금 비밀장부 원본 깐다. 고소해봐';
          _contentController.text = '지난 5년간 조세회피처로 빼돌린 페이퍼컴퍼니 계좌 내역 전부 엑셀로 백업해둠.\n\n'
              '내일 09시 검찰청 정문에서 기자회견 하고 원본 USB 제출한다.\n'
              '나 신변보호 신청했으니까 허튼수작 부리지 마라. 공유 많이 해줘라.';
          _authorController.text = '내부고발자';
          _ipController.text = '갤로그';
          _authorType = DcAuthorType.fixed;
          _recommendController.text = '3420';
          _dislikeController.text = '85';
          _viewCountController.text = '12400';
          _createdAtController.text = '2026.09.19 22:15:40';
          break;
        case 4: // 인터넷방송 / 스트리머
          _galleryNameController.text = '인터넷방송 갤러리';
          _galleryCategory = '마이너 갤러리';
          _categoryController.text = '[정보]';
          _titleController.text = '방금 합방에서 레전드 사건 터짐 ㅋㅋㅋㅋㅋ 클립 따옴';
          _contentController.text = '100만 유튜버랑 합방하는데 주인공 혼자 모든 게임 1초컷으로 올킬함 ㅋㅋㅋㅋ\n\n'
              '상대방 멘탈 터져서 캠 끄고 탈주함 ㅋㅋㅋㅋ\n'
              '실시간 시청자 8만 명 돌파함 ㄷㄷ 클립 좌표 남긴다';
          _authorController.text = '방송담당_파딱';
          _ipController.text = '부매니저';
          _authorType = DcAuthorType.subManager;
          _recommendController.text = '1210';
          _dislikeController.text = '20';
          _viewCountController.text = '5120';
          _createdAtController.text = '2026.09.19 21:05:22';
          break;
      }
    });
  }

  void _submit() {
    final curPostId = widget.config.selectedPostId;
    final posts = List<DcPost>.from(widget.config.posts);
    final idx = posts.indexWhere((p) => p.id == curPostId);

    final rec = int.tryParse(_recommendController.text.trim()) ?? 0;
    final dis = int.tryParse(_dislikeController.text.trim()) ?? 0;
    final view = int.tryParse(_viewCountController.text.trim()) ?? 0;

    final updatedPost = (idx != -1 ? posts[idx] : posts.first).copyWith(
      title: _titleController.text.trim(),
      category: _categoryController.text.trim(),
      content: _contentController.text.trim(),
      authorName: _authorController.text.trim(),
      ipOrBadge: _ipController.text.trim(),
      authorType: _authorType,
      recommendCount: rec,
      dislikeCount: dis,
      viewCount: view,
      createdAt: _createdAtController.text.trim(),
      isConcept: rec >= 30,
    );

    if (idx != -1) {
      posts[idx] = updatedPost;
    } else {
      posts[0] = updatedPost;
    }

    widget.onApply(
      widget.config.copyWith(
        galleryName: _galleryNameController.text.trim(),
        galleryCategory: _galleryCategory,
        posts: posts,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF334155), width: 1.5),
      ),
      child: Container(
        width: 680,
        height: 720,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 다이얼로그 헤더
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B4890),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('dc', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '디시인사이드 갤러리 시나리오 에디터',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '웹툰·소설 장르별 게시글, 댓글, 추천수, 갤러리 커스텀',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 본문 폼 스크롤
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. 원클릭 스토리 프리셋
                    const Text('⚡ 원클릭 스토리 프리셋', style: TextStyle(color: Color(0xFF60A5FA), fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildPresetChip(0, '⚔️ 헌터/각성자 각성 떡상'),
                        _buildPresetChip(1, '🎤 걸그룹 음방 1위 라이브'),
                        _buildPresetChip(2, '📉 주식/코인 풀숏 청산'),
                        _buildPresetChip(3, '🕵️ 총수 일가 비자금 폭로'),
                        _buildPresetChip(4, '🎮 인방 합방 레전드 올킬'),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 2. 갤러리 정보
                    Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('갤러리 이름', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _galleryNameController,
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                                decoration: _buildInputDeco(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('갤러리 분류', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                initialValue: _galleryCategory,
                                dropdownColor: const Color(0xFF1E293B),
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                                decoration: _buildInputDeco(),
                                items: const [
                                  DropdownMenuItem(value: '마이너 갤러리', child: Text('마이너 갤러리')),
                                  DropdownMenuItem(value: '미니 갤러리', child: Text('미니 갤러리')),
                                  DropdownMenuItem(value: '정식 갤러리', child: Text('정식 갤러리')),
                                ],
                                onChanged: (val) {
                                  if (val != null) setState(() => _galleryCategory = val);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 3. 말머리 & 게시글 제목
                    Row(
                      children: [
                        SizedBox(
                          width: 110,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('말머리', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _categoryController,
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                                decoration: _buildInputDeco(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('게시글 제목', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _titleController,
                                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                decoration: _buildInputDeco(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 4. 작성자 정보 & 뱃지 유형
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('작성자 닉네임', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _authorController,
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                                decoration: _buildInputDeco(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('IP 또는 뱃지 텍스트', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _ipController,
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                                decoration: _buildInputDeco(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('회원 유형', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<DcAuthorType>(
                                initialValue: _authorType,
                                dropdownColor: const Color(0xFF1E293B),
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                                decoration: _buildInputDeco(),
                                items: const [
                                  DropdownMenuItem(value: DcAuthorType.anonymous, child: Text('유동닉')),
                                  DropdownMenuItem(value: DcAuthorType.fixed, child: Text('고정닉 (갤로그)')),
                                  DropdownMenuItem(value: DcAuthorType.subManager, child: Text('부매니저 (파딱)')),
                                  DropdownMenuItem(value: DcAuthorType.manager, child: Text('매니저 (주딱)')),
                                ],
                                onChanged: (val) {
                                  if (val != null) setState(() => _authorType = val);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 5. 게시글 본문 텍스트
                    const Text('게시글 본문 내용', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _contentController,
                      maxLines: 5,
                      style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
                      decoration: _buildInputDeco(),
                    ),
                    const SizedBox(height: 16),

                    // 6. 통계 (추천, 비추, 조회수, 작성일시)
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('개념 추천수', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _recommendController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 13, fontWeight: FontWeight.bold),
                                decoration: _buildInputDeco(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('비추천수', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _dislikeController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                                decoration: _buildInputDeco(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('조회수', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _viewCountController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                                decoration: _buildInputDeco(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('작성 일시', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _createdAtController,
                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                                decoration: _buildInputDeco(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 하단 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소', style: TextStyle(color: Colors.white60)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B4890),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _submit,
                  child: const Text('갤러리에 적용', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetChip(int index, String label) {
    return ActionChip(
      backgroundColor: const Color(0xFF0F172A),
      side: const BorderSide(color: Color(0xFF334155)),
      label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      onPressed: () => _applyPreset(index),
    );
  }

  InputDecoration _buildInputDeco() {
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: const Color(0xFF0F172A),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFF60A5FA)),
      ),
    );
  }
}
