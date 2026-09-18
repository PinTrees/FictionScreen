import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

/// X-Frame-Options / CSP 차단 사이트용 스마트 시뮬레이터 & 리더 뷰어
class ChromeSimulatedPortal extends StatefulWidget {
  final String url;
  final ValueChanged<String>? onNavigate;
  final ValueChanged<String>? onOpenNewTab;

  const ChromeSimulatedPortal({
    super.key,
    required this.url,
    this.onNavigate,
    this.onOpenNewTab,
  });

  @override
  State<ChromeSimulatedPortal> createState() => _ChromeSimulatedPortalState();
}

class _ChromeSimulatedPortalState extends State<ChromeSimulatedPortal> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openExternal() {
    if (kIsWeb) {
      web.window.open(widget.url, '_blank');
    }
  }

  @override
  Widget build(BuildContext context) {
    final lowerUrl = widget.url.toLowerCase();

    Widget portalBody;
    if (lowerUrl.contains('naver.com')) {
      portalBody = _buildNaverSimulator();
    } else if (lowerUrl.contains('daum.net')) {
      portalBody = _buildDaumSimulator();
    } else if (lowerUrl.contains('youtube.com') || lowerUrl.contains('youtu.be')) {
      portalBody = _buildYoutubeSimulator();
    } else if (lowerUrl.contains('github.com')) {
      portalBody = _buildGithubSimulator();
    } else if (lowerUrl.contains('namu.wiki')) {
      portalBody = _buildNamuWikiSimulator();
    } else {
      portalBody = _buildUniversalReader();
    }

    return Column(
      children: [
        // Security policy alert banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          color: const Color(0xFF2A2110),
          child: Row(
            children: [
              const Icon(Icons.shield_outlined, size: 16, color: Color(0xFFE5A93C)),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  '사이트 자체 보안 정책(X-Frame-Options: SAMEORIGIN)으로 인해 실시간 리더/시뮬레이션 모드로 안전하게 표시 중입니다.',
                  style: TextStyle(color: Color(0xFFE5A93C), fontSize: 11.5, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: _openExternal,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5A93C).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFE5A93C)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.open_in_new, size: 12, color: Color(0xFFE5A93C)),
                      SizedBox(width: 4),
                      Text('새 창(외부 브라우저)에서 열기', style: TextStyle(color: Color(0xFFE5A93C), fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Main Simulated Portal Content
        Expanded(child: portalBody),
      ],
    );
  }

  // 1. 네이버 시뮬레이터
  Widget _buildNaverSimulator() {
    return Container(
      color: const Color(0xFFF5F6F7),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Naver Green Header
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('NAVER', style: TextStyle(color: Color(0xFF03C75A), fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: -1)),
                const SizedBox(width: 16),
                Container(
                  width: 380,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF03C75A), width: 2),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(fontSize: 13, color: Colors.black),
                          decoration: const InputDecoration(hintText: '검색어를 입력해 주세요', border: InputBorder.none, isDense: true),
                          onSubmitted: (q) {
                            widget.onOpenNewTab?.call('https://search.naver.com/search.naver?query=${Uri.encodeComponent(q)}');
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search, color: Color(0xFF03C75A), size: 20),
                        onPressed: () {
                          if (_searchController.text.isNotEmpty) {
                            widget.onOpenNewTab?.call('https://search.naver.com/search.naver?query=${Uri.encodeComponent(_searchController.text)}');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Menu Chips
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            children: ['메일', '카페', '블로그', '쇼핑', '뉴스', '증권', '부동산', '지도', '웹툰'].map((menu) {
              return ActionChip(
                backgroundColor: Colors.white,
                label: Text(menu, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                onPressed: () {
                  widget.onOpenNewTab?.call('https://section.blog.naver.com');
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // News Stand & Trending topics
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE5E5E5))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text('주요 뉴스스탠드', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                          Spacer(),
                          Text('연합뉴스 · 조선일보 · JTBC', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                      const Divider(height: 20),
                      _newsItem('[단독] 2026년 차세대 웹 & AI 에디터 혁신 발표', '10분 전'),
                      _newsItem('코스피 지수 3,100선 돌파, 기술주 중심 강세', '24분 전'),
                      _newsItem('소비자 만족도 1위 플랫폼 선정 기념 대규모 페스티벌', '1시간 전'),
                      _newsItem('전국 맑은 날씨 이어져, 주말 나들이 인파 북적', '2시간 전'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE5E5E5))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('실시간 트렌드 검색어', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
                      const Divider(height: 16),
                      _trendItem(1, 'FictionScreen 2.0', true),
                      _trendItem(2, 'Visual Studio 2026', true),
                      _trendItem(3, 'Google Chrome 멀티탭', true),
                      _trendItem(4, '카카오뱅크 통장 사본', false),
                      _trendItem(5, '비트코인 실시간 시세', false),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. 다음(Daum) 시뮬레이터
  Widget _buildDaumSimulator() {
    return Container(
      color: const Color(0xFFFAFAFA),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Daum', style: TextStyle(color: Color(0xFF4285F4), fontSize: 36, fontWeight: FontWeight.w900)),
                const SizedBox(width: 16),
                Container(
                  width: 360,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF4285F4), width: 1.5),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(fontSize: 13, color: Colors.black),
                          decoration: const InputDecoration(hintText: '궁금한 정보는 Daum에서 검색', border: InputBorder.none, isDense: true),
                        ),
                      ),
                      const Icon(Icons.search, color: Color(0xFF4285F4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE5E5E5))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Daum 랭킹 뉴스 TOP', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                const Divider(height: 20),
                _newsItem('글로벌 시장 환율 동향 및 금리 전망 분석', '35분 전'),
                _newsItem('한국 대표 픽션 시뮬레이션 서비스 폭발적 사용자 증가세', '50분 전'),
                _newsItem('주말 프로야구 하이라이트 명승부', '1시간 전'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. 유튜브(YouTube) 시뮬레이터
  Widget _buildYoutubeSimulator() {
    return Container(
      color: const Color(0xFF0F0F0F),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              const Icon(Icons.play_circle_fill, color: Colors.red, size: 28),
              const SizedBox(width: 8),
              const Text('YouTube', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                width: 340,
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF222222),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text('검색', style: TextStyle(color: Colors.white38, fontSize: 13)),
                    ),
                    Icon(Icons.search, color: Colors.white54, size: 18),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.4,
            children: [
              _ytVideoCard('FictionScreen 2.0 공식 시연 영상', '픽션스튜디오', '조회수 120만회 · 2일 전'),
              _ytVideoCard('Visual Studio 2026 완벽 분석', '개발자의 품격', '조회수 45만회 · 5일 전'),
              _ytVideoCard('Google Chrome 새로운 탭 인터셉트 기능', '테크 매거진', '조회수 89만회 · 1주 전'),
              _ytVideoCard('코딩할 때 듣기 좋은 로파이 음악 24/7', 'Lofi Girl Korea', '실시간 스트리밍 중'),
              _ytVideoCard('카카오뱅크 vs 토스뱅크 인터페이스 전격 비교', '금융 테크랩', '조회수 67만회 · 3일 전'),
              _ytVideoCard('디스코드 봇 만들기 풀코스 강좌', '코드 아카데미', '조회수 34만회 · 2주 전'),
            ],
          ),
        ],
      ),
    );
  }

  // 4. 깃허브(GitHub) 시뮬레이터
  Widget _buildGithubSimulator() {
    return Container(
      color: const Color(0xFF0D1117),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              const Icon(Icons.code, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              const Text('PinTrees / FictionScreen', style: TextStyle(color: Color(0xFF58A6FF), fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
                child: const Text('Public', style: TextStyle(color: Colors.white70, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF30363D)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('README.md', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                Divider(color: Color(0xFF30363D), height: 20),
                Text('# FictionScreen (픽션스크린)', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(
                  '바이럴 시나리오, 메신저 및 전문 OS/브라우저/IDE 에뮬레이션을 위한 통합 스튜디오 플랫폼입니다.\n\n- 카카오톡, 토스, 카카오뱅크, 당근마켓, 인스타그램, 유튜브\n- Windows BSOD, Windows Update, macOS Sequoia & macOS 27\n- Visual Studio 2026, Photoshop, Google Chrome 탭 인터셉터',
                  style: TextStyle(color: Color(0xFFC9D1D9), fontSize: 13, height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 5. 나무위키 시뮬레이터
  Widget _buildNamuWikiSimulator() {
    return Container(
      color: const Color(0xFFFFFFFF),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF008275), borderRadius: BorderRadius.circular(4)),
                child: const Text('namu.wiki', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(width: 12),
              const Text('Google Chrome (웹 브라우저)', style: TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(height: 24),
          const Text(
            '1. 개요\nGoogle에서 개발한 크로미엄(Chromium) 기반의 웹 브라우저. 전 세계에서 가장 높은 점유율을 차지하고 있다.\n\n2. 주요 기능\n- 다중 탭 브라우징 및 탭 그룹화\n- 옴니박스(Omnibox) 주소창 빠른 검색\n- FictionScreen 내 프레임 탭 인터셉트 및 격리 렌더링 지원',
            style: TextStyle(color: Colors.black87, fontSize: 13.5, height: 1.7),
          ),
        ],
      ),
    );
  }

  // 6. 범용 리더 모드
  Widget _buildUniversalReader() {
    return Container(
      color: const Color(0xFF1E1F22),
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.shield_lefthalf_fill, size: 54, color: Color(0xFF4285F4)),
            const SizedBox(height: 16),
            Text(widget.url, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              '이 웹사이트는 제3자 프레임 내 직접 렌더링을 차단하고 있습니다.\n크롬 프레임 내부 새 탭이나 외부 브라우저를 통해 편리하게 이용하실 수 있습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white60, fontSize: 12.5, height: 1.6),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text('새 창에서 열기 (외부 팝업)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4285F4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: _openExternal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _newsItem(String title, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 12.5, color: Colors.black87), overflow: TextOverflow.ellipsis)),
          Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _trendItem(int rank, String keyword, bool isUp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$rank', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF03C75A))),
          const SizedBox(width: 8),
          Expanded(child: Text(keyword, style: const TextStyle(fontSize: 12, color: Colors.black87), overflow: TextOverflow.ellipsis)),
          Icon(isUp ? Icons.arrow_drop_up : Icons.remove, size: 16, color: isUp ? Colors.red : Colors.grey),
        ],
      ),
    );
  }

  Widget _ytVideoCard(String title, String channel, String meta) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(6)),
              child: const Center(child: Icon(Icons.play_arrow, color: Colors.white54, size: 36)),
            ),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(channel, style: const TextStyle(color: Colors.white60, fontSize: 11)),
          Text(meta, style: const TextStyle(color: Colors.white38, fontSize: 10)),
        ],
      ),
    );
  }
}
