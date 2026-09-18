import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// macOS 27 Golden Gate Spotlight "Search or Ask" AI 오버레이
/// - Apple Intelligence 무지개빛 그라데이션 글로우 테두리
/// - 실시간 앱 & 템플릿 검색 + 엔터 실행
/// - Siri AI 스마트 질의응답 시뮬레이션
class Macos27Spotlight extends StatefulWidget {
  final Function(String appId) onOpenApp;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final Function(String osKey)? onSelectOs;
  final VoidCallback onClose;

  const Macos27Spotlight({
    super.key,
    required this.onOpenApp,
    required this.onOpenTemplate,
    required this.onOpenSettings,
    this.onSelectOs,
    required this.onClose,
  });

  @override
  State<Macos27Spotlight> createState() => _Macos27SpotlightState();
}

class _Macos27SpotlightState extends State<Macos27Spotlight> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _query = '';
  late AnimationController _glowAnimController;

  final List<Map<String, dynamic>> _allApps = [
    {'title': 'Finder', 'desc': '파일 탐색기 및 데스크탑 관리', 'icon': 'assets/images/macos/finder.webp', 'appId': 'finder'},
    {'title': 'Safari', 'desc': '웹 브라우저', 'icon': 'assets/images/macos/safari.webp', 'appId': 'safari'},
    {'title': 'Google Chrome', 'desc': '고속 웹 브라우징', 'icon': 'assets/images/macos/chrome.png', 'appId': 'chrome'},
    {'title': '터미널 (Terminal)', 'desc': '명령 프롬프트 및 CLI 셸', 'icon': 'assets/images/macos/terminal.png', 'appId': 'terminal'},
    {'title': '메모 (Notes)', 'desc': '아이디어 및 텍스트 노트', 'icon': 'assets/images/macos/notes.png', 'appId': 'notes'},
    {'title': '메시지 (Messages)', 'desc': 'iMessage 및 대화', 'icon': 'assets/images/macos/messages.webp', 'appId': 'messages'},
    {'title': '메일 (Mail)', 'desc': '이메일 수발신', 'icon': 'assets/images/macos/mail.webp', 'appId': 'mail'},
    {'title': '지도 (Maps)', 'desc': '내비게이션 및 위치', 'icon': 'assets/images/macos/maps.png', 'appId': 'maps'},
    {'title': '사진 (Photos)', 'desc': '미디어 라이브러리', 'icon': 'assets/images/macos/photos.webp', 'appId': 'photos'},
    {'title': '음악 (Music)', 'desc': '애플 뮤직 플레이어', 'icon': 'assets/images/macos/music.png', 'appId': 'music'},
    {'title': '시스템 설정 (Settings)', 'desc': 'OS 전환, 외관, 배경화면', 'icon': 'assets/images/macos/settings.webp', 'appId': 'settings'},
    {'title': '계산기 (Calculator)', 'desc': '수학 계산 도구', 'icon': 'assets/images/macos/calculator.webp', 'appId': 'calculator'},
  ];

  final List<Map<String, dynamic>> _allTemplates = [
    {'title': '카카오톡 채팅 에디터', 'desc': 'FictionScreen 대화방 조작', 'icon': 'assets/images/kakaotalk_icon.webp', 'templateId': 'kakaotalk'},
    {'title': '카카오뱅크 에디터', 'desc': '통장 잔액, 세이프박스, 거래 내역', 'icon': null, 'iconData': CupertinoIcons.creditcard_fill, 'color': Color(0xFFFEE500), 'templateId': 'kakaobank'},
    {'title': '당근마켓 채팅 에디터', 'desc': '중고거래 채팅 및 매너온도 조작', 'icon': null, 'iconData': CupertinoIcons.chat_bubble_text_fill, 'color': Color(0xFFFF6F0F), 'templateId': 'daangn'},
    {'title': 'Instagram 에디터', 'desc': '피드, 릴스, 스토리 제작', 'icon': 'assets/images/instagram_icon.webp', 'templateId': 'instagram'},
    {'title': 'Toss 송금 에디터', 'desc': '금융 거래내역 시뮬레이션', 'icon': 'assets/images/toss_icon.webp', 'templateId': 'toss'},
    {'title': 'X (Twitter) 에디터', 'desc': '트윗 및 타임라인 생성', 'icon': 'assets/images/x_twitter_icon.webp', 'templateId': 'x_twitter'},
    {'title': 'YouTube 동영상 에디터', 'desc': '동영상 재생 및 댓글', 'icon': 'assets/images/youtube_icon.webp', 'templateId': 'youtube'},
    {'title': '배달의민족 배송 에디터', 'desc': '주문 및 배달 완료 화면', 'icon': 'assets/images/baemin_icon.webp', 'templateId': 'delivery'},
    {'title': '야놀자(NOL) 에디터', 'desc': '호텔·모텔·펜션 예약 및 숙소 검색 조작', 'icon': null, 'iconData': CupertinoIcons.bed_double_fill, 'color': const Color(0xFFFF3478), 'templateId': 'yanolja'},
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _glowAnimController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _glowAnimController.dispose();
    super.dispose();
  }

  String? _getSiriAnswer(String q) {
    final lower = q.toLowerCase().trim();
    if (lower.isEmpty) return null;
    if (lower.contains('날씨')) return '현재 샌프란시스코 골든 게이트 일대는 19°C로 맑으며, 시원한 바닷바람이 불고 있습니다. ☀️';
    if (lower.contains('골든게이트') || lower.contains('golden gate')) return 'macOS 27 Golden Gate는 2026년 공개된 최신 Apple Silicon 전용 운영체제로, Liquid Glass 디자인과 향상된 Siri AI를 탑재했습니다. 🌉';
    if (lower.contains('배경화면') || lower.contains('바탕화면')) return '바탕화면을 우클릭하여 "배경화면 변경..."을 누르거나 시스템 설정에서 골든 게이트의 5가지 테마(Sunset, Day, Evening, Night, Hero)로 언제든 변경할 수 있습니다. 🖼️';
    if (lower.contains('윈도우') || lower.contains('전환') || lower.contains('windows')) return '시스템 설정의 "운영체제 전환" 탭에서 Windows 11, Windows 10, Windows 7, Galaxy One UI 9, iOS로 원클릭 전환이 가능합니다. 💻';
    if (lower.contains('폴더')) return '바탕화면의 빈 공간을 우클릭하여 "새로운 폴더"를 누르면 폴더가 생성되며, 드래그하여 자유롭게 이동할 수 있습니다. 📁';
    if (lower.contains('안녕') || lower.contains('누구') || lower.contains('siri')) return '안녕하세요! Apple Intelligence와 연동된 macOS 27 Spotlight AI 비서입니다. 무엇을 도와드릴까요? ✨';
    return '"$q"에 대한 Apple Intelligence 요약: 관련된 최신 문서와 앱 목록을 아래에서 확인하거나, Enter를 눌러 웹에서 검색할 수 있습니다.';
  }

  @override
  Widget build(BuildContext context) {
    final siriAnswer = _getSiriAnswer(_query);
    final filteredApps = _allApps.where((a) {
      final t = a['title'].toString().toLowerCase();
      final d = a['desc'].toString().toLowerCase();
      return _query.isEmpty || t.contains(_query.toLowerCase()) || d.contains(_query.toLowerCase());
    }).toList();

    final filteredTemplates = _allTemplates.where((t) {
      final title = t['title'].toString().toLowerCase();
      return _query.isEmpty || title.contains(_query.toLowerCase());
    }).toList();

    return Stack(
      children: [
        // 바깥 배경 클릭 시 닫기
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onClose,
            child: Container(color: Colors.black.withValues(alpha: 0.3)),
          ),
        ),

        // Spotlight 팝업 중앙 상단 위치
        Positioned(
          top: 130,
          left: 0,
          right: 0,
          child: Center(
            child: AnimatedBuilder(
              animation: _glowAnimController,
              builder: (context, child) {
                return Container(
                  width: 640,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF60CDFF).withValues(alpha: 0.18 + (_glowAnimController.value * 0.14)),
                        blurRadius: 36,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: const Color(0xFFC084FC).withValues(alpha: 0.15 + ((1.0 - _glowAnimController.value) * 0.12)),
                        blurRadius: 30,
                        spreadRadius: -2,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.65),
                        blurRadius: 40,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: child,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E26).withValues(alpha: 0.88),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF60CDFF).withValues(alpha: 0.5),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 검색창 입력 행
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF60CDFF), Color(0xFFC084FC), Color(0xFFFB923C)],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(CupertinoIcons.sparkles, size: 16, color: Colors.white),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  focusNode: _focusNode,
                                  style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w400),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    hintText: 'Search or Ask Siri AI...',
                                    hintStyle: TextStyle(color: Colors.white38, fontSize: 17),
                                  ),
                                  onChanged: (val) => setState(() => _query = val),
                                  onSubmitted: (_) {
                                    if (filteredApps.isNotEmpty) {
                                      widget.onOpenApp(filteredApps.first['appId'] as String);
                                      widget.onClose();
                                    } else if (filteredTemplates.isNotEmpty) {
                                      widget.onOpenTemplate(filteredTemplates.first['templateId'] as String);
                                      widget.onClose();
                                    }
                                  },
                                ),
                              ),
                              if (_query.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    _controller.clear();
                                    setState(() => _query = '');
                                  },
                                  child: const Icon(CupertinoIcons.clear_circled_solid, size: 18, color: Colors.white38),
                                ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.white12),
                                ),
                                child: const Text('ESC', style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),

                        // Siri AI 질문 응답 카드
                        if (siriAnswer != null) ...[
                          Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            color: const Color(0xFF60CDFF).withValues(alpha: 0.08),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(CupertinoIcons.sparkles, size: 18, color: Color(0xFF60CDFF)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Apple Intelligence', style: TextStyle(color: Color(0xFF60CDFF), fontSize: 11, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text(siriAnswer, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // 검색 결과 리스트
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 380),
                          child: ListView(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            children: [
                              if (filteredApps.isNotEmpty) ...[
                                _buildCategoryHeader('응용 프로그램'),
                                ...filteredApps.map((a) => _buildResultTile(
                                  title: a['title'] as String,
                                  desc: a['desc'] as String,
                                  imageAsset: a['icon'] as String,
                                  onTap: () {
                                    widget.onOpenApp(a['appId'] as String);
                                    widget.onClose();
                                  },
                                )),
                              ],

                              if (filteredTemplates.isNotEmpty) ...[
                                _buildCategoryHeader('FictionScreen 에디터 템플릿'),
                                ...filteredTemplates.map((t) => _buildResultTile(
                                  title: t['title'] as String,
                                  desc: t['desc'] as String,
                                  imageAsset: t['icon'] as String?,
                                  iconData: t['iconData'] as IconData?,
                                  iconColor: t['color'] as Color?,
                                  onTap: () {
                                    widget.onOpenTemplate(t['templateId'] as String);
                                    widget.onClose();
                                  },
                                )),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(title, style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildResultTile({
    required String title,
    required String desc,
    String? imageAsset,
    IconData? iconData,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        hoverColor: const Color(0xFF3B82F6),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              if (imageAsset != null)
                Image.asset(imageAsset, width: 28, height: 28, filterQuality: FilterQuality.high)
              else
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: (iconColor ?? Colors.white).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(iconData ?? CupertinoIcons.app, size: 18, color: iconColor ?? Colors.white),
                ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                    Text(desc, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                  ],
                ),
              ),
              const Icon(CupertinoIcons.return_icon, size: 12, color: Colors.white38),
            ],
          ),
        ),
      ),
    );
  }
}
