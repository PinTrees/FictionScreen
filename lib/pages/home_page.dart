import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../models/delivery_model.dart';
import '../models/kakaotalk_model.dart';
import '../models/screen_template.dart';
import '../models/windows_bsod_model.dart';
import '../models/youtube_model.dart';
import '../style/app_colors.dart';
import '../templates/lifestyle/delivery_screen.dart';
import '../templates/messenger/kakaotalk_screen.dart';
import '../templates/os/windows_bsod_screen.dart';
import '../templates/sns/youtube_screen.dart';
import '../widgets/common/device_frame_preview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 히어로 인터랙티브 프리뷰 탭
  String _activeHeroTab = 'kakaotalk';
  TemplateCategory? _selectedCategory;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _catalogKey = GlobalKey();
  final GlobalKey _specsKey = GlobalKey();

  void _scrollToSection(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
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
      backgroundColor: const Color(0xFF08090D),
      body: Stack(
        children: [
          // 1. 2027 앰비언트 글로우 배경
          _buildAmbientBackground(),

          // 2. 메인 스크롤 콘텐츠
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 100)), // 네비바 공간

              // Hero Section
              SliverToBoxAdapter(
                child: _buildHeroSection(isMobile),
              ),

              // Live Interactive Deck Section
              SliverToBoxAdapter(
                child: _buildInteractiveShowcaseDeck(isMobile),
              ),

              // Bento Grid Engine Features Section
              SliverToBoxAdapter(
                child: Container(
                  key: _specsKey,
                  child: _buildBentoGridSection(isMobile),
                ),
              ),

              // Template Catalog Section
              SliverToBoxAdapter(
                child: Container(
                  key: _catalogKey,
                  child: _buildCatalogSection(isMobile),
                ),
              ),

              // Minimalist Footer
              SliverToBoxAdapter(
                child: _buildFooter(),
              ),
            ],
          ),

          // 3. Floating Island Navigation Bar
          Positioned(
            top: 18,
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
  // 배경 앰비언트 오로라
  // ==========================================
  Widget _buildAmbientBackground() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            // 상단 은은한 림 라이트
            Positioned(
              top: -160,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 900,
                  height: 480,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF4F46E5).withValues(alpha: 0.14),
                        const Color(0xFF2563EB).withValues(alpha: 0.06),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            // 하단 우측 메탈릭 사이언 라이트
            Positioned(
              top: 1200,
              right: -100,
              child: Container(
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF06B6D4).withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
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
  // Floating Island Navigation
  // ==========================================
  Widget _buildFloatingNav(bool isMobile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      constraints: const BoxConstraints(maxWidth: 960),
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF10121A).withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Brand Logo
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
                        child: Icon(Icons.layers_rounded, color: Colors.white, size: 16),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'FictionScreen',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Desktop Menu Links
                if (!isMobile) ...[
                  _buildNavLink('라이브 덱', () => _scrollController.animateTo(400, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut)),
                  const SizedBox(width: 22),
                  _buildNavLink('엔진 스펙', () => _scrollToSection(_specsKey)),
                  const SizedBox(width: 22),
                  _buildNavLink('템플릿 카탈로그', () => _scrollToSection(_catalogKey)),
                  const SizedBox(width: 24),
                ],

                // Action CTA
                StreamBuilder<User?>(
                  stream: AuthService.authStateChanges,
                  builder: (context, snapshot) {
                    final user = snapshot.data ?? AuthService.currentUser;
                    if (user != null) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                            backgroundColor: const Color(0xFF6366F1),
                            child: user.photoURL == null
                                ? Text(user.displayName?[0] ?? 'U', style: const TextStyle(color: Colors.white, fontSize: 11))
                                : null,
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF0A0B10),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                              minimumSize: const Size(0, 36),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            onPressed: () => context.go('/console'),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('OS 콘솔 열기', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                SizedBox(width: 4),
                                Icon(Icons.desktop_mac_rounded, size: 14),
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            minimumSize: const Size(0, 36),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () => context.go('/console'),
                          child: const Text('콘솔 체험', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0A0B10),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                            minimumSize: const Size(0, 36),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () async {
                            try {
                              await AuthService.signInWithGoogle();
                              if (context.mounted) {
                                context.go('/console');
                              }
                            } catch (e) {
                              if (context.mounted) {
                                context.go('/console');
                              }
                            }
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Google 로그인', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded, size: 14),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildNavLink(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.transparent,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.7),
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  // ==========================================
  // Hero Section
  // ==========================================
  Widget _buildHeroSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 40, vertical: isMobile ? 36 : 64),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 880),
        child: Column(
          children: [
            // Status Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF131520),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '2027 REAL-TIME MOCK ENGINE · ZERO WATERMARK',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Editorial Main Heading
            Text(
              '상상한 화면을\n완벽한 현실의 프레임으로.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 38 : 64,
                fontWeight: FontWeight.w800,
                height: 1.15,
                letterSpacing: isMobile ? -1.2 : -2.2,
              ),
            ),
            const SizedBox(height: 20),

            // Refined Subtitle
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Text(
                '유튜브 숏폼, 웹드라마 소품, 썰툰, 미디어 콘텐츠를 위한 고품질 가상 인터페이스.\n'
                '카카오톡·인스타그램·유튜브·배달앱·OS 오류 화면을 1:1 무손실 벡터로 렌더링하고 내보내세요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: isMobile ? 14 : 17,
                  height: 1.6,
                  letterSpacing: -0.3,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 36),

            // Primary CTAs
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                // Glow Launch CTA
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => context.go('/console'),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'OS 콘솔 작업공간 입장',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: -0.3),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.desktop_windows_rounded, size: 18),
                      ],
                    ),
                  ),
                ),

                // Secondary Scroll CTA
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE2E8F0),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.14), width: 1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    backgroundColor: const Color(0xFF10121A).withValues(alpha: 0.5),
                  ),
                  onPressed: () => _scrollToSection(_catalogKey),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.dashboard_customize_rounded, size: 16, color: Color(0xFF94A3B8)),
                      SizedBox(width: 8),
                      Text(
                        '전체 템플릿 탐색',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: -0.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // Live Interactive Showcase Deck
  // ==========================================
  Widget _buildInteractiveShowcaseDeck(bool isMobile) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40, vertical: 24),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1020),
        child: Container(
          padding: EdgeInsets.all(isMobile ? 16 : 28),
          decoration: BoxDecoration(
            color: const Color(0xFF0F111A),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            children: [
              // Deck Top Bar
              Row(
                children: [
                  const Icon(Icons.play_circle_filled_rounded, color: Color(0xFF6366F1), size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'LIVE INTERACTIVE DECK',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                  ),
                  const Spacer(),
                  // Studio Jump Shortcut
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF818CF8),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    icon: const Icon(Icons.edit_square, size: 14),
                    label: const Text('현재 화면 스튜디오에서 편집', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    onPressed: () => context.push('/studio/$_activeHeroTab'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Interactive Selector Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildDeckTab(id: 'kakaotalk', label: '카카오톡 채팅방', icon: Icons.chat_bubble_rounded),
                    _buildDeckTab(id: 'windows_bsod', label: 'Windows 블루스크린', icon: Icons.desktop_windows_rounded),
                    _buildDeckTab(id: 'youtube', label: '유튜브 플레이어', icon: Icons.play_arrow_rounded),
                    _buildDeckTab(id: 'delivery', label: '배달 플랫폼', icon: Icons.two_wheeler_rounded),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Embedded Interactive Frame
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: _buildSelectedHeroScreen(isMobile),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeckTab({required String id, required String label, required IconData icon}) {
    final isSelected = _activeHeroTab == id;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _activeHeroTab = id),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1E2130) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF6366F1).withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: isSelected ? const Color(0xFF818CF8) : const Color(0xFF64748B)),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedHeroScreen(bool isMobile) {
    final scale = isMobile ? 0.78 : 0.88;
    switch (_activeHeroTab) {
      case 'kakaotalk':
        return DeviceFramePreview(
          showFrame: true,
          scale: scale,
          child: KakaoTalkScreen(
            config: KakaoRoomConfig.defaultPreset(),
            isAnimated: false,
          ),
        );
      case 'windows_bsod':
        return DeviceFramePreview(
          showFrame: true,
          isDesktop: true,
          scale: isMobile ? 0.5 : 0.8,
          child: WindowsBsodScreen(
            config: WindowsBsodConfig.defaultPreset(),
            currentPercentage: 84,
          ),
        );
      case 'youtube':
        return DeviceFramePreview(
          showFrame: true,
          scale: scale,
          child: YoutubeScreen(config: YoutubeConfig.defaultPreset()),
        );
      case 'delivery':
        return DeviceFramePreview(
          showFrame: true,
          scale: scale,
          child: DeliveryScreen(config: DeliveryConfig.defaultPreset()),
        );
      default:
        return DeviceFramePreview(
          showFrame: true,
          scale: scale,
          child: KakaoTalkScreen(config: KakaoRoomConfig.defaultPreset()),
        );
    }
  }

  // ==========================================
  // Bento Grid Section (Engine Specifications)
  // ==========================================
  Widget _buildBentoGridSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40, vertical: 60),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1040),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            const Text(
              'ENGINE SPECIFICATIONS',
              style: TextStyle(
                color: Color(0xFF6366F1),
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '어떤 영상에서도 어색함이 없는 이유.',
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 26 : 38,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.0,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '단순한 이미지가 아닙니다. 네이티브 픽셀 단위 렌더링 엔진으로 오차 없는 싱크로율을 제공합니다.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 15),
            ),
            const SizedBox(height: 36),

            // Bento Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 740;
                if (isNarrow) {
                  return Column(
                    children: [
                      _buildBentoCard(
                        title: '0.1mm 오차 없는 타이포그래피',
                        description: '카카오톡, iOS San Francisco, Windows Segoe UI, Android Roboto 시스템 글꼴의 자간과 굵기를 정밀 재현합니다.',
                        icon: Icons.text_fields_rounded,
                        accentColor: const Color(0xFF6366F1),
                      ),
                      const SizedBox(height: 16),
                      _buildBentoCard(
                        title: '무손실 4K 스크린 캡처',
                        description: '확대해도 깨지지 않는 2.5x ~ 4.0x 슈퍼 샘플링 래스터라이징으로 고화질 영상 소스로 즉각 사용 가능합니다.',
                        icon: Icons.high_quality_rounded,
                        accentColor: const Color(0xFF38BDF8),
                      ),
                      const SizedBox(height: 16),
                      _buildBentoCard(
                        title: '프레임 & 화면 독립 분리',
                        description: '실제 스마트폰 디바이스 베젤을 씌우거나, 순수 화면 사각형만 잘라내는 전환을 1초 만에 완료합니다.',
                        icon: Icons.smartphone_rounded,
                        accentColor: const Color(0xFFEC4899),
                      ),
                      const SizedBox(height: 16),
                      _buildBentoCard(
                        title: '워터마크 제로 · 상업적 무제한',
                        description: '상업적 영상, 웹드라마 소품, 썰툰, 방송 등 어디서든 표기 의무 없이 자유롭게 활용할 수 있습니다.',
                        icon: Icons.verified_user_rounded,
                        accentColor: const Color(0xFF10B981),
                      ),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          _buildBentoCard(
                            title: '0.1mm 오차 없는 타이포그래피',
                            description: '카카오톡 말풍선의 곡률과 꼬리 위치, 1 안읽음 숫자 위치, 통신사 상태바까지 현존 최고 수준의 싱크로율을 자랑합니다.',
                            icon: Icons.text_fields_rounded,
                            accentColor: const Color(0xFF6366F1),
                            minHeight: 220,
                          ),
                          const SizedBox(height: 16),
                          _buildBentoCard(
                            title: '워터마크 제로 · 상업적 무제한 라이선스',
                            description: '방송, 유튜브 숏폼, 릴스, 웹드라마 어디든 워터마크 없이 깨끗한 결과물을 상업적으로 사용할 수 있습니다.',
                            icon: Icons.verified_user_rounded,
                            accentColor: const Color(0xFF10B981),
                            minHeight: 180,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          _buildBentoCard(
                            title: '무손실 4K 스크린 캡처',
                            description: '고해상도 캔버스 캡처로 숏폼(1080x1920) 및 데스크톱 영상(16:9) 제작 시 깨짐 없는 무손실 품질을 보장합니다.',
                            icon: Icons.high_quality_rounded,
                            accentColor: const Color(0xFF38BDF8),
                            minHeight: 180,
                          ),
                          const SizedBox(height: 16),
                          _buildBentoCard(
                            title: '프레임 유무 자유 토글',
                            description: '아이폰/모니터 외형 프레임 캡처 또는 순수 화면 전용 캡처를 한 번의 클릭으로 스위칭하세요.',
                            icon: Icons.smartphone_rounded,
                            accentColor: const Color(0xFFEC4899),
                            minHeight: 220,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBentoCard({
    required String title,
    required String description,
    required IconData icon,
    required Color accentColor,
    double minHeight = 160,
  }) {
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F111A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 13,
              height: 1.5,
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
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40, vertical: 60),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1040),
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
                        'TEMPLATES LIBRARY',
                        style: TextStyle(color: Color(0xFF6366F1), fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '제작할 가상 화면을 선택하세요.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 24 : 34,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Category Filter
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCatalogFilterChip(null, '전체 템플릿'),
                  ...TemplateCategory.values.map((cat) => _buildCatalogFilterChip(cat, cat.label)),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Cards Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final count = constraints.maxWidth > 720 ? 2 : 1;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: count,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 155,
                  ),
                  itemCount: templates.length,
                  itemBuilder: (context, index) {
                    final t = templates[index];
                    return _buildModernTemplateCard(t);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCatalogFilterChip(TemplateCategory? category, String label) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => setState(() => _selectedCategory = category),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : const Color(0xFF131520),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : const Color(0xFF94A3B8),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernTemplateCard(ScreenTemplate template) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F111A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          hoverColor: Colors.white.withValues(alpha: 0.02),
          onTap: () => context.push('/studio/${template.id}'),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: template.themeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: template.themeColor.withValues(alpha: 0.25)),
                  ),
                  child: Center(
                    child: Icon(template.icon, color: template.themeColor, size: 24),
                  ),
                ),
                const SizedBox(width: 18),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              template.title,
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (template.badge.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                template.badge,
                                style: const TextStyle(color: AppColors.secondary, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        template.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, height: 1.35),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Arrow
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // Footer
  // ==========================================
  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.only(top: 80),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      decoration: BoxDecoration(
        color: const Color(0xFF07080C),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF38BDF8)]),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.layers_rounded, color: Colors.white, size: 14),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'FictionScreen',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  const Text(
                    'Next-Gen Mock UI Studio',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '© 2027 FictionScreen. Built for Creators.',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
                  ),
                  Row(
                    children: [
                      _buildFooterLink('이용약관'),
                      const SizedBox(width: 14),
                      _buildFooterLink('개인정보처리방침'),
                      const SizedBox(width: 14),
                      _buildFooterLink('라이선스'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLink(String label) {
    return Text(
      label,
      style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
    );
  }
}
