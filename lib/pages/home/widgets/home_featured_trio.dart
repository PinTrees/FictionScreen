import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../apps/blind/blind_screen.dart';
import '../../../apps/blind/data/blind_model.dart';
import '../../../apps/daangn/daangn_screen.dart';
import '../../../apps/daangn/data/daangn_model.dart';
import '../../../apps/kakaotalk/data/kakaotalk_model.dart';
import '../../../apps/kakaotalk/kakaotalk_screen.dart';

class HomeFeaturedTrio extends StatelessWidget {
  final bool isMobile;
  final bool isDarkMode;

  const HomeFeaturedTrio({
    super.key,
    required this.isMobile,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.68)
        : const Color(0xFF475569);

    // Standard smartphone screen aspect ratio: ~370px width by ~700px height (~9:17)
    final previewWidth = isMobile ? double.infinity : 370.0;
    final previewHeight = isMobile ? 640.0 : 700.0;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1140),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 48,
          vertical: isMobile ? 64 : 110,
        ),
        child: Column(
          children: [
            // Section Title
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFF1E1F30)
                          : const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'SIGNATURE MOCKUPS',
                      style: TextStyle(
                        color: isDarkMode ? const Color(0xFFC7D2FE) : const Color(0xFF4F46E5),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '창작자들이 가장 열광하는 대표 화면 3선',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: isMobile ? 28 : 40,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '디테일이 생명인 웹툰과 웹소설 씬에서 실제로 가장 많이 쓰이는 3대 킬러 화면입니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: isMobile ? 14.5 : 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 70),

            // 1. 카카오톡 (KakaoTalk) Section (Pure UI, standard smartphone ratio)
            _buildFeatureSection(
              context: context,
              badge: '메신저 • 인기 1위',
              iconAsset: 'assets/images/kakaotalk_icon.webp',
              title: '웹툰 대화 씬의 시작과 끝,\n카카오톡 완벽 재현',
              description:
                  '1:1 은밀한 귓속말부터 100명이 참여하는 단톡방 폭파까지. 실제 카카오톡의 시그니처 옐로우 말풍선, 1 안읽음 숫자, 상단바 배터리/시각, 커스텀 프로필을 1초 만에 완성합니다.',
              bullets: [
                'Pretendard 원본 폰트 & 노란 말풍선 곡률 100% 픽셀 일치',
                '시간별 대화 정렬 및 1 안읽음 카운트 자유 조작',
                '클릭 한 번으로 투명 PNG 캡처 후 원고 콘티에 바로 부착',
              ],
              uiWidget: KakaoTalkScreen(config: KakaoRoomConfig.defaultPreset()),
              previewWidth: previewWidth,
              previewHeight: previewHeight,
              templateId: 'kakaotalk',
              actionLabel: '카카오톡 스튜디오 열기',
              isReversed: false,
            ),

            const SizedBox(height: 120),

            // 2. 당근마켓 (Daangn) Section (Pure UI, standard smartphone ratio)
            _buildFeatureSection(
              context: context,
              badge: '중고거래 • 일상/스릴러 필수',
              iconAsset: 'assets/images/daangn_icon.webp',
              title: '현실감 넘치는 일상 & 직거래 사건의 무대,\n당근마켓 중고거래',
              description:
                  '중고거래 채팅, 매너온도 36.5℃, 거래완료 뱃지, 현실감 넘치는 가격 네고 대화. 일상툰, 청춘 로맨스, 범죄 스릴러에 꼭 필요한 생생한 중고 직거래 현장을 그대로 묘사하세요.',
              bullets: [
                '당근 특유의 오렌지 UI와 매너온도 게이지 완벽 재현',
                '가격 흥정, 직거래 장소 약속, 사진 전송 씬 연출',
                '‘의문의 물건 직거래’, ‘의문의 판매자’ 등 스릴러 클리셰 최적화',
              ],
              uiWidget: DaangnScreen(config: DaangnConfig.defaultPreset()),
              previewWidth: previewWidth,
              previewHeight: previewHeight,
              templateId: 'daangn',
              actionLabel: '당근마켓 스튜디오 열기',
              isReversed: !isMobile,
            ),

            const SizedBox(height: 120),

            // 3. 블라인드 (Blind) Section (Pure UI, standard smartphone ratio)
            _buildFeatureSection(
              context: context,
              badge: '사내 커뮤니티 • 직장인/기업물 킬러',
              iconAsset: 'assets/images/blind_icon.webp',
              title: '직장인물 & 기업 비리 폭로의 중심,\n블라인드 익명 커뮤니티',
              description:
                  '대기업/스타트업 회사 인증 뱃지(삼성, 넥슨, 현대 등), 실시간 찬반 투표(Poll), 익명 저격글과 티키타카 댓글. 재벌물과 오피스물의 숨막히는 사내 정치와 폭로전을 완벽 구현합니다.',
              bullets: [
                '삼성전자, 카카오, 넥슨 등 자유로운 회사 인증 뱃지 설정',
                '실시간 찬반 투표 위젯 (실제 투표율 % 연출)',
                '사내 익명 폭로글에 달리는 현실적인 댓글 티키타카',
              ],
              uiWidget: BlindScreen(config: BlindConfig.defaultPreset()),
              previewWidth: previewWidth,
              previewHeight: previewHeight,
              templateId: 'blind',
              actionLabel: '블라인드 스튜디오 열기',
              isReversed: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureSection({
    required BuildContext context,
    required String badge,
    required String iconAsset,
    required String title,
    required String description,
    required List<String> bullets,
    required Widget uiWidget,
    required double previewWidth,
    required double previewHeight,
    required String templateId,
    required String actionLabel,
    required bool isReversed,
  }) {
    final titleColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final descColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.72)
        : const Color(0xFF475569);

    final textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Badge with Real App Icon (No outline)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E2133) : const Color(0xFFEEF2FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(iconAsset, width: 20, height: 20, fit: BoxFit.cover),
              ),
              const SizedBox(width: 8),
              Text(
                badge,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF334155),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Title
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: isMobile ? 24 : 32,
            fontWeight: FontWeight.w900,
            height: 1.25,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 16),

        // Description
        Text(
          description,
          style: TextStyle(
            color: descColor,
            fontSize: isMobile ? 14 : 15.5,
            height: 1.65,
          ),
        ),
        const SizedBox(height: 24),

        // Bullets
        ...bullets.map(
          (bullet) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Color(0xFF6366F1), size: 17),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    bullet,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF334155),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),

        // Brand Gradient Action Button (NO OUTLINE)
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => context.go('/studio/$templateId'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  actionLabel,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
                const SizedBox(width: 6),
                const Icon(CupertinoIcons.arrow_right, size: 14),
              ],
            ),
          ),
        ),
      ],
    );

    // PURE UI ONLY Container - Accurate Smartphone Aspect Ratio (~9:17 to 9:19)
    final pureUiBox = Center(
      child: Container(
        width: previewWidth,
        height: previewHeight,
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF0F111A) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black.withValues(alpha: 0.5) : const Color(0x1C000000),
              blurRadius: 36,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: uiWidget,
        ),
      ),
    );

    if (isMobile) {
      return Column(
        children: [
          textColumn,
          const SizedBox(height: 32),
          pureUiBox,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: isReversed
          ? [
              Expanded(flex: 5, child: pureUiBox),
              const SizedBox(width: 60),
              Expanded(flex: 5, child: textColumn),
            ]
          : [
              Expanded(flex: 5, child: textColumn),
              const SizedBox(width: 60),
              Expanded(flex: 5, child: pureUiBox),
            ],
    );
  }
}
