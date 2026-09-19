import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GenreClicheItem {
  final String title;
  final String badge;
  final Color accentColor;
  final IconData icon;
  final String quote;
  final List<String> scenes;
  final String primaryTemplateId;
  final String primaryTemplateLabel;

  const GenreClicheItem({
    required this.title,
    required this.badge,
    required this.accentColor,
    required this.icon,
    required this.quote,
    required this.scenes,
    required this.primaryTemplateId,
    required this.primaryTemplateLabel,
  });
}

class HomeGenreCliches extends StatelessWidget {
  final bool isMobile;

  const HomeGenreCliches({
    super.key,
    required this.isMobile,
  });

  static const List<GenreClicheItem> _cliches = [
    GenreClicheItem(
      title: '재벌물 & 경영 스릴러',
      badge: '재벌·정치',
      accentColor: Color(0xFF107C41),
      icon: CupertinoIcons.briefcase_fill,
      quote: '“이 장부가 검찰 손에 들어가면, 우린 끝장이야.”',
      scenes: [
        '엑셀 비자금 차명계좌 & 로비 장부',
        '적대적 M&A 긴급 이사회 발표 PPT',
        '스위스 비밀 계좌 5,000억 원 이체 내역',
      ],
      primaryTemplateId: 'excel',
      primaryTemplateLabel: '엑셀 장부 연출하기',
    ),
    GenreClicheItem(
      title: '아포칼립스 & 괴담 스릴러',
      badge: '재난·공포',
      accentColor: Color(0xFFD32F2F),
      icon: CupertinoIcons.exclamationmark_triangle_fill,
      quote: '“[속보] 도심 한복판 정체불명의 생명체 출현…”',
      scenes: [
        'KBS/SBS 풍 긴급속보 롤링 자막 방송',
        '지하 연구소 침입자 감지 4분할 CCTV',
        '1급 기밀문서 REDACTED 블랙 마스킹',
      ],
      primaryTemplateId: 'news',
      primaryTemplateLabel: '뉴스 속보 연출하기',
    ),
    GenreClicheItem(
      title: '학원물 & 현대 로맨스',
      badge: '청춘·로맨스',
      accentColor: Color(0xFFE1306C),
      icon: CupertinoIcons.heart_fill,
      quote: '“너 지금 그 단톡방에 올라온 사진 봤어?”',
      scenes: [
        '전교생 단톡방 폭파 & 1 안읽음 카톡',
        '디시 갤러리 실시간 개념글 박제',
        '인스타 인플루언서 스토리 & DM',
      ],
      primaryTemplateId: 'kakaotalk',
      primaryTemplateLabel: '카톡 단톡방 연출하기',
    ),
    GenreClicheItem(
      title: '회귀물 & 인생역전',
      badge: '회귀·현판',
      accentColor: Color(0xFF0050FF),
      icon: CupertinoIcons.chart_bar_alt_fill,
      quote: '“10년 전 오늘, 비트코인이 폭등하기 직전이다.”',
      scenes: [
        '업비트 코인 800% 폭등 빨간불 호가창',
        '동행복권 1등 35억 당첨 영수증 인증',
        '스팀 라이브러리 히든 업적 달성 팝업',
      ],
      primaryTemplateId: 'upbit',
      primaryTemplateLabel: '코인 차트 연출하기',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: 48,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.book_fill, color: Color(0xFF38BDF8), size: 13),
                      SizedBox(width: 6),
                      Text(
                        'GENRE CLICHES FOR CREATORS',
                        style: TextStyle(
                          color: Color(0xFF7DD3FC),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  '웹툰·웹소설 장르별 필수 클리셰',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '독자의 심장을 뛰게 만드는 그 장면, 픽션스크린의 완성형 템플릿으로 단 1초 만에 배치하세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // 4-Card Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _cliches.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              mainAxisExtent: isMobile ? 260 : 250,
            ),
            itemBuilder: (context, index) {
              final item = _cliches[index];
              return _buildGenreCard(context, item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGenreCard(BuildContext context, GenreClicheItem item) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF0F111A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Badge & Icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: item.accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: item.accentColor.withValues(alpha: 0.3)),
                ),
                child: Icon(item.icon, color: item.accentColor, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: item.accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.badge,
                  style: TextStyle(
                    color: item.accentColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Quote
          Text(
            item.quote,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),

          // Scenes List
          ...item.scenes.map((scene) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.checkmark_alt, size: 13, color: item.accentColor),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        scene,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )),

          const Spacer(),

          // Bottom Action
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => context.go('/studio/${item.primaryTemplateId}'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.primaryTemplateLabel,
                    style: TextStyle(
                      color: item.accentColor,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(CupertinoIcons.chevron_forward, size: 12, color: item.accentColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
