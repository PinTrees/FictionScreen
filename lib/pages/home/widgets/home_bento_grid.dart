import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeBentoGrid extends StatelessWidget {
  final bool isMobile;

  const HomeBentoGrid({
    super.key,
    required this.isMobile,
  });

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
          // Section Eyebrow & Title
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.sparkles, color: Color(0xFF818CF8), size: 13),
                      SizedBox(width: 6),
                      Text(
                        'WHY FICTION SCREEN',
                        style: TextStyle(
                          color: Color(0xFFA5B4FC),
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
                  '창작자의 몰입을 깨지 않는\n타협 없는 디테일',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '대충 그린 가짜 화면은 독자의 몰입을 해칩니다. FictionScreen은 실제 앱과 완전히 똑같이 만듭니다.',
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

          // Bento Layout
          if (isMobile)
            Column(
              children: [
                _buildCard1(true),
                const SizedBox(height: 16),
                _buildCard2(),
                const SizedBox(height: 16),
                _buildCard3(),
                const SizedBox(height: 16),
                _buildCard4(true),
              ],
            )
          else
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _buildCard1(false)),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: _buildCard2()),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildCard3()),
                    const SizedBox(width: 16),
                    Expanded(flex: 3, child: _buildCard4(false)),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  // Card 1: Pixel Perfection & Typography (Wide)
  Widget _buildCard1(bool isMobile) {
    return _buildBentoContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildIconBox(CupertinoIcons.checkmark_seal_fill, const Color(0xFF6366F1)),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  '100% 픽셀 정밀도 & 원본 타이포그래피',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Pretendard, San Francisco, Segoe UI, 나눔고딕 등 실제 서비스가 사용하는 원본 서체와 말풍선 곡률, 뱃지 그라데이션, 안읽음 숫자 위치를 1:1 단위로 완벽하게 재현합니다.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 20),
          // Mini Visual Mockup Strip
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF090A10),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Wrap(
              spacing: 10,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // Kakao Bubble
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE500),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('지금 뉴스 속보 봤어?', style: TextStyle(color: Colors.black, fontSize: 11.5, fontWeight: FontWeight.w600)),
                      SizedBox(width: 6),
                      Text('1', style: TextStyle(color: Color(0xFFFEE500), backgroundColor: Colors.transparent, fontSize: 9)),
                    ],
                  ),
                ),
                // News Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD32F2F),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('[단독]', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900)),
                ),
                // Steam Achievement
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B2838),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF66C0F4).withValues(alpha: 0.4)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.star_fill, color: Color(0xFF66C0F4), size: 12),
                      SizedBox(width: 5),
                      Text('도전 과제 달성!', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Card 2: Virtual Desktop OS
  Widget _buildCard2() {
    return _buildBentoContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIconBox(CupertinoIcons.device_desktop, const Color(0xFF38BDF8)),
          const SizedBox(height: 14),
          const Text(
            'Windows & Mac 가상 OS',
            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            '실제 컴퓨터처럼 여러 앱 창을 동시에 띄우고 드래그, 리사이즈, 폴더 수납까지 자유롭게 연출할 수 있습니다.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF090A10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                _buildDot(const Color(0xFFFF5F56)),
                const SizedBox(width: 6),
                _buildDot(const Color(0xFFFFBD2E)),
                const SizedBox(width: 6),
                _buildDot(const Color(0xFF27C93F)),
                const Spacer(),
                const Text('MDI Multi-Window', style: TextStyle(color: Colors.white38, fontSize: 10.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Card 3: Watermark-free Export
  Widget _buildCard3() {
    return _buildBentoContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIconBox(CupertinoIcons.arrow_down_doc_fill, const Color(0xFF10B981)),
          const SizedBox(height: 14),
          const Text(
            '워터마크 없는 무손실 PNG',
            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            '웹툰 원고나 영상 편집 타임라인(클립스튜디오, 포토샵, 프리미어)에 즉시 얹을 수 있도록 깨끗한 고해상도로 다운로드됩니다.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.check_mark_circled_solid, color: Color(0xFF10B981), size: 14),
                SizedBox(width: 6),
                Text('상업용 웹툰·웹소설 100% 무료', style: TextStyle(color: Color(0xFF6EE7B7), fontSize: 11.5, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Card 4: Cliché Presets (Wide)
  Widget _buildCard4(bool isMobile) {
    return _buildBentoContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildIconBox(CupertinoIcons.bolt_fill, const Color(0xFFF59E0B)),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  '웹툰·웹소설 맞춤 클리셰 프리셋',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '비자금 엑셀 장부, 재벌 3세 주식 떡상, 아포칼립스 긴급속보, 단톡방 폭파 등 클리셰에 최적화된 사전 데이터가 내장되어 있어 내용만 살짝 고쳐 1초 만에 컷을 완성할 수 있습니다.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildGenreBadge('#재벌물 비자금 장부', const Color(0xFF107C41)),
              _buildGenreBadge('#스릴러 긴급 속보', const Color(0xFFD32F2F)),
              _buildGenreBadge('#회귀물 코인 떡상', const Color(0xFF0050FF)),
              _buildGenreBadge('#공포/미스터리 CCTV', const Color(0xFFE53935)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBentoContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F111A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildIconBox(IconData icon, Color color) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Center(child: Icon(icon, color: color, size: 19)),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildGenreBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11.5, fontWeight: FontWeight.w700),
      ),
    );
  }
}
