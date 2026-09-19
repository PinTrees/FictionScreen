import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/steam_model.dart';

class SteamGameDetail extends StatelessWidget {
  final SteamGame game;
  final VoidCallback onTogglePlay;
  final VoidCallback onTriggerAchievementToast;

  const SteamGameDetail({
    super.key,
    required this.game,
    required this.onTogglePlay,
    required this.onTriggerAchievementToast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1B2838),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 1. 대형 히어로 배너
          _buildHeroBanner(),

          // 2. 실행 바 (플레이 버튼 + 플레이 시간 + 클라우드 상태)
          _buildActionBar(),

          // 3. 게임 정보 및 도전 과제 섹션
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAchievementsCard(),
                const SizedBox(height: 24),
                _buildActivityFeed(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            game.themeColor.withValues(alpha: 0.35),
            const Color(0xFF1B2838),
          ],
        ),
      ),
      child: Stack(
        children: [
          // 배경 기하학적 아트워크 패턴
          Positioned.fill(
            child: CustomPaint(
              painter: _GameArtworkPainter(themeColor: game.themeColor),
            ),
          ),

          // 하단 페이드 그라데이션
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF1B2838).withValues(alpha: 0.95),
                  ],
                ),
              ),
            ),
          ),

          // 게임 타이틀 로고
          Positioned(
            left: 28,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.title.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'sans-serif-condensed',
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.8),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Text(
                    '스팀 정품 인증 라이선스 보유',
                    style: TextStyle(color: Color(0xFF66C0F4), fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      color: const Color(0xFF16202D),
      child: Row(
        children: [
          // 스팀 대형 플레이 / 중지 버튼
          InkWell(
            onTap: onTogglePlay,
            borderRadius: BorderRadius.circular(3),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: game.isRunning
                      ? const [Color(0xFF2A475E), Color(0xFF1B2838)]
                      : const [Color(0xFF75B022), Color(0xFF588A1B)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: (game.isRunning ? const Color(0xFF2A475E) : const Color(0xFF75B022))
                        .withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    game.isRunning ? CupertinoIcons.stop_fill : CupertinoIcons.play_arrow_solid,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    game.isRunning ? '중지' : '플레이',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),

          // 통계 1: 마지막 플레이
          _buildStatColumn('마지막 플레이', game.lastPlayed),
          const SizedBox(width: 28),

          // 통계 2: 플레이 시간
          _buildStatColumn('플레이 시간', '${game.hoursPlayed.toStringAsFixed(1)}시간'),
          const SizedBox(width: 28),

          // 통계 3: 클라우드 상태
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('클라우드 상태', style: TextStyle(color: Color(0xFF8F98A0), fontSize: 11)),
              const SizedBox(height: 3),
              Row(
                children: const [
                  Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Color(0xFF66C0F4), size: 14),
                  SizedBox(width: 4),
                  Text('최신 상태', style: TextStyle(color: Color(0xFF66C0F4), fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),

          const Spacer(),

          // 도전 과제 알림 팝업 트리거 버튼
          ElevatedButton.icon(
            onPressed: onTriggerAchievementToast,
            icon: const Icon(CupertinoIcons.sparkles, size: 14),
            label: const Text('도전 과제 팝업 연출', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A475E),
              foregroundColor: const Color(0xFF66C0F4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF8F98A0), fontSize: 11)),
        const SizedBox(height: 3),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildAchievementsCard() {
    final unlocked = game.unlockedAchievementsCount;
    final total = game.achievements.length;
    final progress = total > 0 ? unlocked / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2431),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(CupertinoIcons.rosette, color: Color(0xFFD4AF37), size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    '도전 과제',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$unlocked / $total (${(progress * 100).toInt()}%)',
                    style: const TextStyle(color: Color(0xFF8F98A0), fontSize: 12),
                  ),
                ],
              ),
              const Text('모든 도전 과제 보기 >', style: TextStyle(color: Color(0xFF66C0F4), fontSize: 11)),
            ],
          ),
          const SizedBox(height: 12),

          // 스팀 골드 진행 바
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: SizedBox(
              height: 10,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color(0xFF10151C),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 최근 달성한 도전 과제 뱃지 그리드
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: game.achievements.map((ach) {
              return Container(
                width: 200,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF161C26),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: ach.isUnlocked ? const Color(0xFFD4AF37).withValues(alpha: 0.3) : Colors.white12,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: ach.isUnlocked ? const Color(0xFFD4AF37).withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        ach.isUnlocked ? CupertinoIcons.rosette : CupertinoIcons.lock_fill,
                        color: ach.isUnlocked ? const Color(0xFFD4AF37) : Colors.white38,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ach.title,
                            style: TextStyle(
                              color: ach.isUnlocked ? Colors.white : Colors.white54,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            ach.description,
                            style: const TextStyle(color: Colors.white38, fontSize: 10),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityFeed() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2431),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('친구 활동', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(
            '최근 2주간 친구 2명이 이 게임을 총 45시간 플레이했습니다.',
            style: TextStyle(color: Color(0xFF8F98A0), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _GameArtworkPainter extends CustomPainter {
  final Color themeColor;
  const _GameArtworkPainter({required this.themeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = themeColor.withValues(alpha: 0.08)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // 대각선 사이버/스팀 패턴 라인
    for (double x = -size.height; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height * 0.8, 0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GameArtworkPainter oldDelegate) => oldDelegate.themeColor != themeColor;
}
