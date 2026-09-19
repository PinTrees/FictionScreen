import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/news_model.dart';

class NewsEditDialog extends StatefulWidget {
  final NewsConfig config;
  final ValueChanged<NewsConfig> onApply;

  const NewsEditDialog({
    super.key,
    required this.config,
    required this.onApply,
  });

  @override
  State<NewsEditDialog> createState() => _NewsEditDialogState();
}

class _NewsEditDialogState extends State<NewsEditDialog> {
  late NewsChannelTheme _channelTheme;
  late String _channelName;
  late NewsLayoutMode _layoutMode;
  late NewsBadgeType _badgeType;
  late TextEditingController _headlineController;
  late TextEditingController _subHeadlineController;
  late TextEditingController _reporterNameController;
  late TextEditingController _reportLocationController;
  late TextEditingController _timeController;
  late TextEditingController _hotlineController;
  late TextEditingController _tickerController;
  late FieldSceneType _fieldSceneType;
  late bool _showSignLanguage;
  late bool _crtScanlines;

  @override
  void initState() {
    super.initState();
    final c = widget.config;
    _channelTheme = c.channelTheme;
    _channelName = c.channelName;
    _layoutMode = c.layoutMode;
    _badgeType = c.badgeType;
    _headlineController = TextEditingController(text: c.mainHeadline);
    _subHeadlineController = TextEditingController(text: c.subHeadline);
    _reporterNameController = TextEditingController(text: c.reporterName);
    _reportLocationController = TextEditingController(text: c.reportLocation);
    _timeController = TextEditingController(text: c.timeString);
    _hotlineController = TextEditingController(text: c.hotlineText);
    _tickerController = TextEditingController(text: c.tickerItems.join('\n'));
    _fieldSceneType = c.fieldSceneType;
    _showSignLanguage = c.showSignLanguage;
    _crtScanlines = c.crtScanlines;
  }

  @override
  void dispose() {
    _headlineController.dispose();
    _subHeadlineController.dispose();
    _reporterNameController.dispose();
    _reportLocationController.dispose();
    _timeController.dispose();
    _hotlineController.dispose();
    _tickerController.dispose();
    super.dispose();
  }

  void _applyPreset(int presetIndex) {
    setState(() {
      switch (presetIndex) {
        case 0: // 재벌물 비자금
          _channelTheme = NewsChannelTheme.ytn;
          _channelName = 'FSN 24 뉴스특보';
          _layoutMode = NewsLayoutMode.fieldSplit;
          _badgeType = NewsBadgeType.exclusive;
          _headlineController.text = '[단독] ○○그룹 일가 비자금 수천억 해외 은닉 정황 포착';
          _subHeadlineController.text = '검찰 특수부 전격 압수수색 돌입... 총수 일가 핵심 임원 일괄 출국금지 조치';
          _reporterNameController.text = '이서연 기자';
          _reportLocationController.text = '서울중앙지방검찰청 앞';
          _fieldSceneType = FieldSceneType.prosecution;
          _timeController.text = '오후 08:42 LIVE';
          break;
        case 1: // 범죄/스릴러 도심 사건
          _channelTheme = NewsChannelTheme.alert;
          _channelName = 'FSN 긴급 속보';
          _layoutMode = NewsLayoutMode.fieldSplit;
          _badgeType = NewsBadgeType.breaking;
          _headlineController.text = '[긴급 속보] 도심 한복판 흉기 난동 용의자 현장 사살 검거';
          _subHeadlineController.text = '인질 전원 무사 구조... 경찰, 배후 조직 및 추가 공범 추적 중';
          _reporterNameController.text = '박준혁 기자';
          _reportLocationController.text = '강남역 4번 출구 앞';
          _fieldSceneType = FieldSceneType.police;
          _timeController.text = '새벽 02:15 LIVE';
          break;
        case 2: // 아포칼립스 / 싱크홀 재난
          _channelTheme = NewsChannelTheme.kbs;
          _channelName = 'KBS 재난 특보';
          _layoutMode = NewsLayoutMode.fullScene;
          _badgeType = NewsBadgeType.special;
          _headlineController.text = '[특보] 국가 비상사태 선포... 도심 전역 대규모 정체불명 싱크홀 발생';
          _subHeadlineController.text = '정부, 중앙재난안전대책본부 가동... 수도권 반경 10km 즉각 대피령 발령';
          _reporterNameController.text = '강도윤 기자';
          _reportLocationController.text = '광화문 광장 재난 현장';
          _fieldSceneType = FieldSceneType.disaster;
          _timeController.text = '오전 06:30 LIVE';
          break;
        case 3: // 주식 / 금융 대폭락
          _channelTheme = NewsChannelTheme.sbs;
          _channelName = 'FSN 경제 뉴스';
          _layoutMode = NewsLayoutMode.fieldSplit;
          _badgeType = NewsBadgeType.breaking;
          _headlineController.text = '[속보] 코스피 사이드카·서킷브레이커 동시 발동... 패닉 셀 확산';
          _subHeadlineController.text = '원·달러 환율 1,450원 돌파... 금융당국 긴급 거시경제 점검회의 소집';
          _reporterNameController.text = '정유나 기자';
          _reportLocationController.text = '한국거래소 브리핑룸';
          _fieldSceneType = FieldSceneType.briefing;
          _timeController.text = '오후 02:00 LIVE';
          break;
        case 4: // 심야 도심 추격전
          _channelTheme = NewsChannelTheme.jtbc;
          _channelName = 'JBS 뉴스룸';
          _layoutMode = NewsLayoutMode.studioAnchor;
          _badgeType = NewsBadgeType.urgent;
          _headlineController.text = '[긴급] 특수수사본부 비밀 회동 포착... 정관계 유착 의혹 녹취록 입수';
          _subHeadlineController.text = '핵심 증인 신변보호 요청... 오늘 밤 9시 뉴스룸 심층 단독 보도 예정';
          _reporterNameController.text = '최민우 기자';
          _reportLocationController.text = '국회 본회의장 앞';
          _fieldSceneType = FieldSceneType.nightCity;
          _timeController.text = '오후 08:55 LIVE';
          break;
      }
    });
  }

  void _submit() {
    final tickers = _tickerController.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    widget.onApply(
      widget.config.copyWith(
        channelTheme: _channelTheme,
        channelName: _channelName,
        layoutMode: _layoutMode,
        badgeType: _badgeType,
        mainHeadline: _headlineController.text.trim(),
        subHeadline: _subHeadlineController.text.trim(),
        reporterName: _reporterNameController.text.trim(),
        reportLocation: _reportLocationController.text.trim(),
        fieldSceneType: _fieldSceneType,
        showSignLanguage: _showSignLanguage,
        timeString: _timeController.text.trim(),
        hotlineText: _hotlineController.text.trim(),
        tickerItems: tickers.isEmpty ? widget.config.tickerItems : tickers,
        crtScanlines: _crtScanlines,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF131D2A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF1E3A5F), width: 1.5),
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
                    color: const Color(0xFFD32F2F).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(CupertinoIcons.tv_fill, color: Color(0xFFFF5252), size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '뉴스 속보 / 보도 화면 시나리오 에디터',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '웹툰·소설 장르별 뉴스 자막, 현장 연결 및 방송사 레이아웃 커스텀',
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
                    // 1. 원클릭 장르별 프리셋
                    const Text('⚡ 원클릭 스토리 프리셋', style: TextStyle(color: Color(0xFF64B5F6), fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildPresetChip(0, '🏛️ 재벌 비자금 게이트'),
                        _buildPresetChip(1, '🚨 도심 흉기난동 검거'),
                        _buildPresetChip(2, '🌋 싱크홀 국가비상사태'),
                        _buildPresetChip(3, '📉 주식·코스피 서킷브레이커'),
                        _buildPresetChip(4, '🎭 특검 녹취록 단독'),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 2. 방송사 테마 & 레이아웃 모드
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('방송사 스타일 테마', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<NewsChannelTheme>(
                                initialValue: _channelTheme,
                                dropdownColor: const Color(0xFF1E293B),
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                                decoration: _buildInputDeco(),
                                items: const [
                                  DropdownMenuItem(value: NewsChannelTheme.ytn, child: Text('YTN 보도채널 풍 (네이비/레드)')),
                                  DropdownMenuItem(value: NewsChannelTheme.kbs, child: Text('공영방송 뉴스9 풍 (딥네이비/골드)')),
                                  DropdownMenuItem(value: NewsChannelTheme.sbs, child: Text('지상파 8뉴스 풍 (코발트/오렌지)')),
                                  DropdownMenuItem(value: NewsChannelTheme.jtbc, child: Text('뉴스룸 풍 (퍼플/민트)')),
                                  DropdownMenuItem(value: NewsChannelTheme.alert, child: Text('국가 재난/비상 특보 풍 (경보레드)')),
                                ],
                                onChanged: (val) {
                                  if (val != null) setState(() => _channelTheme = val);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('화면 분할 레이아웃', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<NewsLayoutMode>(
                                initialValue: _layoutMode,
                                dropdownColor: const Color(0xFF1E293B),
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                                decoration: _buildInputDeco(),
                                items: const [
                                  DropdownMenuItem(value: NewsLayoutMode.fieldSplit, child: Text('현장 연결 2분할 (앵커 + 기자)')),
                                  DropdownMenuItem(value: NewsLayoutMode.studioAnchor, child: Text('스튜디오 앵커 단독 데스크')),
                                  DropdownMenuItem(value: NewsLayoutMode.fullScene, child: Text('사건 현장 단독 전체화면')),
                                ],
                                onChanged: (val) {
                                  if (val != null) setState(() => _layoutMode = val);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 3. 뱃지 종류 & 현장 화면 타입
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('속보 뱃지 종류', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<NewsBadgeType>(
                                initialValue: _badgeType,
                                dropdownColor: const Color(0xFF1E293B),
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                                decoration: _buildInputDeco(),
                                items: const [
                                  DropdownMenuItem(value: NewsBadgeType.breaking, child: Text('🚨 [긴급 속보]')),
                                  DropdownMenuItem(value: NewsBadgeType.exclusive, child: Text('⭐ [단독]')),
                                  DropdownMenuItem(value: NewsBadgeType.special, child: Text('📢 [뉴스 특보]')),
                                  DropdownMenuItem(value: NewsBadgeType.live, child: Text('🔴 [생중계]')),
                                  DropdownMenuItem(value: NewsBadgeType.urgent, child: Text('⚡ [긴급]')),
                                ],
                                onChanged: (val) {
                                  if (val != null) setState(() => _badgeType = val);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('현장 사건 배경 유형', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<FieldSceneType>(
                                initialValue: _fieldSceneType,
                                dropdownColor: const Color(0xFF1E293B),
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                                decoration: _buildInputDeco(),
                                items: const [
                                  DropdownMenuItem(value: FieldSceneType.prosecution, child: Text('🏛️ 검찰청/법원 포토라인')),
                                  DropdownMenuItem(value: FieldSceneType.police, child: Text('🚔 사건현장 폴리스라인 경광등')),
                                  DropdownMenuItem(value: FieldSceneType.briefing, child: Text('🎤 정부/기업 긴급 기자회견')),
                                  DropdownMenuItem(value: FieldSceneType.disaster, child: Text('🌋 싱크홀/붕괴 재난 현장')),
                                  DropdownMenuItem(value: FieldSceneType.nightCity, child: Text('🌃 심야 빗속 도심')),
                                ],
                                onChanged: (val) {
                                  if (val != null) setState(() => _fieldSceneType = val);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 4. 메인 헤드라인 및 서브 헤드라인
                    const Text('메인 헤드라인 (대형 볼드 자막)', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _headlineController,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                      decoration: _buildInputDeco(),
                    ),
                    const SizedBox(height: 12),

                    const Text('서브 헤드라인 (상세 설명 자막)', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _subHeadlineController,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: _buildInputDeco(),
                    ),
                    const SizedBox(height: 16),

                    // 5. 취재 장소 및 기자 이름
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('취재 장소 표기', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _reportLocationController,
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                                decoration: _buildInputDeco(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('담당 기자 이름', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _reporterNameController,
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                                decoration: _buildInputDeco(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 6. 실시간 시각 및 제보 번호
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('우측 상단 시각', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _timeController,
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                                decoration: _buildInputDeco(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('제보 전화번호', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _hotlineController,
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                                decoration: _buildInputDeco(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 7. 하단 롤링 티커 자막 리스트
                    const Text('하단 실시간 롤링 자막 (줄바꿈으로 구분)', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _tickerController,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      decoration: _buildInputDeco(),
                    ),
                    const SizedBox(height: 16),

                    // 8. 옵션 스위치 (수화 통역 & CRT)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.person_crop_circle_fill, color: Color(0xFF64B5F6), size: 20),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('수화 통역사 원형 창', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                Text('우측 하단 수화 통역 모션 그래픽 표시', style: TextStyle(color: Colors.white54, fontSize: 11)),
                              ],
                            ),
                          ),
                          Switch(
                            value: _showSignLanguage,
                            activeThumbColor: const Color(0xFF64B5F6),
                            onChanged: (val) => setState(() => _showSignLanguage = val),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.tv, color: Color(0xFFFFB74D), size: 20),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('TV 브라운관 스캔라인', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                Text('CRT 텔레비전 화면 주사선 효과 연출', style: TextStyle(color: Colors.white54, fontSize: 11)),
                              ],
                            ),
                          ),
                          Switch(
                            value: _crtScanlines,
                            activeThumbColor: const Color(0xFFFFB74D),
                            onChanged: (val) => setState(() => _crtScanlines = val),
                          ),
                        ],
                      ),
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
                    backgroundColor: const Color(0xFFD32F2F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _submit,
                  child: const Text('뉴스 화면에 적용', style: TextStyle(fontWeight: FontWeight.bold)),
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
      backgroundColor: const Color(0xFF1E293B),
      side: const BorderSide(color: Color(0xFF2E4057)),
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
        borderSide: const BorderSide(color: Color(0xFF2E4057)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFF64B5F6)),
      ),
    );
  }
}
