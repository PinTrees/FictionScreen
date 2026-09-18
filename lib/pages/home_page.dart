import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../apps/coupang/data/coupang_model.dart';
import '../apps/coupang/coupang_screen.dart';
import '../apps/netflix/data/netflix_model.dart';
import '../apps/netflix/netflix_screen.dart';
import '../apps/lottery/data/lottery_model.dart';
import '../apps/lottery/lottery_screen.dart';
import '../apps/delivery/data/delivery_model.dart';
import '../apps/delivery/delivery_screen.dart';
import '../apps/instagram/data/instagram_model.dart';
import '../apps/instagram/instagram_screen.dart';
import '../apps/kakaotalk/data/kakaotalk_model.dart';
import '../apps/kakaotalk/kakaotalk_screen.dart';
import '../apps/toss/data/toss_model.dart';
import '../apps/toss/toss_screen.dart';
import '../apps/pinterest/data/pinterest_model.dart';
import '../apps/pinterest/pinterest_screen.dart';
import '../apps/screen_template.dart';
import '../apps/windows_bsod/data/windows_bsod_model.dart';
import '../apps/windows_bsod/windows_bsod_screen.dart';
import '../apps/x_twitter/data/x_twitter_model.dart';
import '../apps/x_twitter/x_twitter_screen.dart';
import '../apps/youtube/data/youtube_model.dart';
import '../apps/youtube/youtube_screen.dart';
import '../services/auth_service.dart';
import '../widgets/common/device_frame_preview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 메인 프리뷰 선택 탭
  String _activeHeroTab = 'kakaotalk';
  TemplateCategory? _selectedCategory;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _catalogKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();

  void _scrollToKey(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: const Color(0xFF090A0F),
      body: Stack(
        children: [
          // 1. 은은하고 고급스러운 배경 오로라
          _buildBackgroundGlow(),

          // 2. 메인 스크롤뷰
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 90)),

              // Hero Section
              SliverToBoxAdapter(
                child: _buildHeroSection(isMobile),
              ),

              // Interactive Preview Deck Section
              SliverToBoxAdapter(
                child: _buildInteractiveShowcaseDeck(isMobile),
              ),

              // Features Section
              SliverToBoxAdapter(
                child: Container(
                  key: _featuresKey,
                  child: _buildCoreFeaturesSection(isMobile),
                ),
              ),

              // Template Catalog Section
              SliverToBoxAdapter(
                child: Container(
                  key: _catalogKey,
                  child: _buildCatalogSection(isMobile),
                ),
              ),

              // Footer
              SliverToBoxAdapter(
                child: _buildFooter(),
              ),
            ],
          ),

          // 3. 플로팅 내비게이션 바
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(
              child: _buildFloatingNav(isMobile),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 배경 디자인
  // ==========================================
  Widget _buildBackgroundGlow() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: -120,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 800,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF6366F1).withValues(alpha: 0.12),
                        const Color(0xFF3B82F6).withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // Floating Navigation Bar
  // ==========================================
  Widget _buildFloatingNav(bool isMobile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      constraints: const BoxConstraints(maxWidth: 920),
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF12141D).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // 브랜드 로고
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF38BDF8)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(CupertinoIcons.square_stack_3d_up_fill, color: Colors.white, size: 15),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'FictionScreen',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // 메뉴
                if (!isMobile) ...[
                  _buildNavTextButton('실시간 미리보기', () => _scrollController.animateTo(380, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut)),
                  const SizedBox(width: 20),
                  _buildNavTextButton('주요 기능', () => _scrollToKey(_featuresKey)),
                  const SizedBox(width: 20),
                  _buildNavTextButton('앱 카탈로그', () => _scrollToKey(_catalogKey)),
                  const SizedBox(width: 24),
                ],

                // 액션 버튼
                StreamBuilder<User?>(
                  stream: AuthService.authStateChanges,
                  builder: (context, snapshot) {
                    final user = snapshot.data ?? AuthService.currentUser;
                    if (user != null) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                          minimumSize: const Size(0, 34),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        onPressed: () => context.go('/console'),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('OS 콘솔 실행', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            SizedBox(width: 4),
                            Icon(CupertinoIcons.device_desktop, size: 14),
                          ],
                        ),
                      );
                    }

                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                        minimumSize: const Size(0, 34),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      onPressed: () => context.go('/console'),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('콘솔 시작하기', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          SizedBox(width: 4),
                          Icon(CupertinoIcons.arrow_right, size: 13),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavTextButton(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.transparent,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.75),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ==========================================
  // Hero Section
  // ==========================================
  Widget _buildHeroSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: isMobile ? 30 : 50,
      ),
      child: Column(
        children: [
          // 뱃지
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
                  '웹툰 • 방송 • 연출가를 위한 픽셀 정밀 스튜디오',
                  style: TextStyle(
                    color: Color(0xFFA5B4FC),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 메인 타이틀
          Text(
            '실제 앱과 구별할 수 없는\n가짜 화면을 단 몇 초만에.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 32 : 48,
              fontWeight: FontWeight.w800,
              height: 1.18,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 16),

          // 서브 타이틀
          Container(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(
              '카카오톡, 인스타그램, 유튜브부터 Windows 블루스크린까지.\n글꼴과 디테일이 완벽히 일치하는 고화질 픽션 화면을 만들고 내보내세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.65),
                fontSize: isMobile ? 14 : 16,
                height: 1.55,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // CTA 버튼군
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () => context.go('/console'),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('가상 OS 콘솔 체험', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    SizedBox(width: 6),
                    Icon(CupertinoIcons.arrow_right, size: 16),
                  ],
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _scrollToKey(_catalogKey),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.square_grid_2x2, size: 16),
                    SizedBox(width: 6),
                    Text('템플릿 둘러보기', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),

          // 신뢰 요약 메트릭
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMetricItem('100%', '픽셀 정밀도'),
              _buildMetricDivider(),
              _buildMetricItem('PNG', '워터마크 프리 내보내기'),
              _buildMetricDivider(),
              _buildMetricItem('4가지', '가상 OS 인터페이스'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 20,
      width: 1,
      color: Colors.white.withValues(alpha: 0.12),
    );
  }

  // ==========================================
  // Interactive Live Showcase Deck Section
  // ==========================================
  Widget _buildInteractiveShowcaseDeck(bool isMobile) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: 20,
      ),
      padding: EdgeInsets.all(isMobile ? 16 : 28),
      decoration: BoxDecoration(
        color: const Color(0xFF11131C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          // 헤더 & 탭
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '실시간 미리보기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '원하는 앱 탭을 선택하여 렌더링 상태를 확인하세요.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 앱 선택 탭
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTabChip('kakaotalk', '카카오톡', CupertinoIcons.chat_bubble_2_fill, const Color(0xFFFEE500)),
                _buildTabChip('toss', '토스', CupertinoIcons.money_dollar_circle_fill, const Color(0xFF0050FF)),
                _buildTabChip('x_twitter', 'X (트위터)', CupertinoIcons.conversation_bubble, const Color(0xFF1D9BF0)),
                _buildTabChip('pinterest', '핀터레스트', CupertinoIcons.sparkles, const Color(0xFFE60023)),
                _buildTabChip('windows_bsod', 'Windows BSOD', CupertinoIcons.device_desktop, const Color(0xFF0078D7)),
                _buildTabChip('youtube', '유튜브', CupertinoIcons.play_circle_fill, const Color(0xFFFF0000)),
                _buildTabChip('instagram', '인스타그램', CupertinoIcons.camera_fill, const Color(0xFFE1306C)),
                _buildTabChip('coupang', '쿠팡', CupertinoIcons.cart_fill, const Color(0xFFC72424)),
                _buildTabChip('netflix', '넷플릭스', CupertinoIcons.tv_fill, const Color(0xFFE50914)),
                _buildTabChip('lottery', '동행복권', CupertinoIcons.tickets_fill, const Color(0xFF0066B3)),
                _buildTabChip('delivery', '배달 플랫폼', CupertinoIcons.bag_fill, const Color(0xFF2AC1BC)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 프레임 미리보기
          SizedBox(
            height: isMobile ? 480 : 540,
            child: Center(
              child: DeviceFramePreview(
                isDesktop: _activeHeroTab == 'windows_bsod' || _activeHeroTab == 'coupang' || _activeHeroTab == 'netflix' || _activeHeroTab == 'lottery',
                child: _buildActivePreviewWidget(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 편집하기 버튼
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
              ),
            ),
            onPressed: () => context.go('/studio/$_activeHeroTab'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(CupertinoIcons.slider_horizontal_3, size: 15),
                const SizedBox(width: 8),
                Text('$_activeHeroTab 스튜디오에서 직접 편집하기', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip(String id, String label, IconData icon, Color color) {
    final isActive = _activeHeroTab == id;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        selected: isActive,
        showCheckmark: false,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isActive ? (color == const Color(0xFFFEE500) ? Colors.black : Colors.white) : color),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
        labelStyle: TextStyle(
          color: isActive ? (color == const Color(0xFFFEE500) ? Colors.black : Colors.white) : Colors.white70,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
        selectedColor: color,
        backgroundColor: const Color(0xFF1A1C28),
        side: BorderSide(
          color: isActive ? color : Colors.white.withValues(alpha: 0.08),
        ),
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _activeHeroTab = id;
            });
          }
        },
      ),
    );
  }

  Widget _buildActivePreviewWidget() {
    switch (_activeHeroTab) {
      case 'kakaotalk':
        return KakaoTalkScreen(config: KakaoRoomConfig.defaultPreset());
      case 'toss':
        return TossScreen(config: TossConfig.defaultPreset());
      case 'x_twitter':
        return XTwitterScreen(config: XTwitterConfig.defaultPreset());
      case 'pinterest':
        return PinterestScreen(config: PinterestConfig.defaultPreset());
      case 'windows_bsod':
        return WindowsBsodScreen(config: WindowsBsodConfig.defaultPreset());
      case 'youtube':
        return YoutubeScreen(config: YoutubeConfig.defaultPreset());
      case 'instagram':
        return InstagramScreen(config: InstagramConfig.defaultPreset());
      case 'coupang':
        return CoupangScreen(config: CoupangConfig.defaultPreset());
      case 'netflix':
        return NetflixScreen(config: NetflixConfig.defaultPreset());
      case 'lottery':
        return LotteryScreen(config: LotteryConfig.defaultPreset());
      case 'delivery':
        return DeliveryScreen(config: DeliveryConfig.defaultPreset());
      default:
        return KakaoTalkScreen(config: KakaoRoomConfig.defaultPreset());
    }
  }

  // ==========================================
  // Core Features Section
  // ==========================================
  Widget _buildCoreFeaturesSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '왜 FictionScreen인가요?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '콘텐츠 제작 환경에 최적화된 핵심 기능들을 확인하세요.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),

          // 2x2 기능 카드
          GridView.count(
            crossAxisCount: isMobile ? 1 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isMobile ? 2.2 : 2.5,
            children: [
              _buildFeatureCard(
                icon: CupertinoIcons.sparkles,
                title: '100% 픽셀 및 글꼴 정밀도',
                description: 'Pretendard, San Francisco, Segoe UI 등 실제 서비스의 원본 글꼴과 상단바, 말풍선 곡률, 안읽음 카운트를 고해상도로 재현합니다.',
              ),
              _buildFeatureCard(
                icon: CupertinoIcons.device_desktop,
                title: '가상 OS 콘솔 지원',
                description: 'Windows 11, macOS, iOS, Galaxy 중 원하는 바탕화면 환경 위에서 앱 화면을 구성하고 자연스러운 연출이 가능합니다.',
              ),
              _buildFeatureCard(
                icon: CupertinoIcons.slider_horizontal_3,
                title: '실시간 커스텀 데이터',
                description: '프로필, 대화 내역, 시각, 배터리 잔량, 신호 세기, 댓글 수 등 모든 요소를 즉시 수정하고 조합할 수 있습니다.',
              ),
              _buildFeatureCard(
                icon: CupertinoIcons.arrow_down_doc_fill,
                title: '고화질 워터마크 프리 내보내기',
                description: '웹툰 원고나 영상 편집 프로그램에 바로 배치할 수 있도록 투명하고 깔끔한 PNG 이미지를 즉시 생성합니다.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF12141D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF818CF8), size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Template Catalog Section
  // ==========================================
  Widget _buildCatalogSection(bool isMobile) {
    final templates = _selectedCategory == null
        ? ScreenTemplate.allTemplates
        : ScreenTemplate.allTemplates.where((t) => t.category == _selectedCategory).toList();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '앱 템플릿 카탈로그',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '필요한 픽션 앱을 선택하여 바로 커스텀을 시작하세요.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 카테고리 필터
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryFilterChip(null, '전체 보기'),
                ...TemplateCategory.values.map((cat) => _buildCategoryFilterChip(cat, cat.label)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 그리드 목록
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: templates.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : (MediaQuery.of(context).size.width > 1200 ? 3 : 2),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 150,
            ),
            itemBuilder: (context, index) {
              final template = templates[index];
              return _buildCatalogCard(template);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilterChip(TemplateCategory? category, String label) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        showCheckmark: false,
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.white60,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
        selectedColor: const Color(0xFF6366F1),
        backgroundColor: const Color(0xFF12141D),
        side: BorderSide(
          color: isSelected ? const Color(0xFF6366F1) : Colors.white.withValues(alpha: 0.08),
        ),
        onSelected: (_) {
          setState(() {
            _selectedCategory = category;
          });
        },
      ),
    );
  }

  Widget _buildCatalogCard(ScreenTemplate template) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF12141D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: template.themeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(template.icon, color: template.themeColor, size: 18),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          template.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (template.badge.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              template.badge,
                              style: const TextStyle(
                                color: Color(0xFFA5B4FC),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      template.category.label,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            template.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
              height: 1.35,
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => context.go('/studio/${template.id}'),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '스튜디오 열기',
                    style: TextStyle(
                      color: Color(0xFF818CF8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(CupertinoIcons.chevron_forward, size: 12, color: Color(0xFF818CF8)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Footer
  // ==========================================
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
        color: const Color(0xFF0C0D13),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
      ),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF38BDF8)],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Icon(CupertinoIcons.square_stack_3d_up_fill, color: Colors.white, size: 13),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'FictionScreen',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '크리에이터 및 콘텐츠 제작자를 위한 픽션 스크린 시뮬레이터 프로젝트입니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '© 2026 FictionScreen. All rights reserved.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.25),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
