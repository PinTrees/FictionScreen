import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/app_theme_service.dart';
import '../widgets/scale_button.dart';
import 'home/widgets/home_editorial_hero.dart';
import 'home/widgets/home_featured_trio.dart';
import 'home/widgets/home_footer.dart';
import 'home/widgets/home_icon_cloud.dart';
import 'home/widgets/home_top_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isEnglish = false;
  double _scrollProgress = 0.0;
  bool _showBackToTop = false;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _featuredKey = GlobalKey();
  final GlobalKey _iconCloudKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final current = _scrollController.offset;
    final shouldShow = current > 280;
    if (shouldShow != _showBackToTop) {
      setState(() {
        _showBackToTop = shouldShow;
      });
    }
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll > 0) {
      final progress = (current / maxScroll).clamp(0.0, 1.0);
      if ((progress - _scrollProgress).abs() > 0.008) {
        setState(() {
          _scrollProgress = progress;
        });
      }
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  void _scrollToKey(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _toggleTheme() {
    AppThemeService.instance.toggleTheme(context);
  }

  void _toggleLanguage() {
    setState(() {
      _isEnglish = !_isEnglish;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppThemeService.instance.isDarkMode(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF040508) : const Color(0xFFFAFAFA),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        color: isDarkMode ? const Color(0xFF040508) : const Color(0xFFFAFAFA),
        child: Stack(
          children: [
            // 1. Ambient Aurora & Background
            _buildBackgroundAura(isDarkMode),

            // 2. Main Scrollable Content (Scrollbar hidden)
            ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Editorial Hero Section with Windows 11 Official Bloom
                  SliverToBoxAdapter(
                    child: HomeEditorialHero(
                      isMobile: isMobile,
                      isDarkMode: isDarkMode,
                      isEnglish: _isEnglish,
                      onExploreFeatured: () => _scrollToKey(_featuredKey),
                      onToggleTheme: _toggleTheme,
                      scrollProgress: _scrollProgress,
                    ),
                  ),

                  // Signature Mockup Trio Section (KakaoTalk, Daangn, Blind)
                  SliverToBoxAdapter(
                    child: Container(
                      key: _featuredKey,
                      child: HomeFeaturedTrio(
                        isMobile: isMobile,
                        isDarkMode: isDarkMode,
                        isEnglish: _isEnglish,
                      ),
                    ),
                  ),

                  // All Supported Ecosystem Icon Cloud (OS, Apps, Sites with REAL PNG icons)
                  SliverToBoxAdapter(
                    child: Container(
                      key: _iconCloudKey,
                      child: HomeIconCloud(
                        isMobile: isMobile,
                        isDarkMode: isDarkMode,
                        isEnglish: _isEnglish,
                      ),
                    ),
                  ),

                  // Final CTA Banner & Footer
                  SliverToBoxAdapter(
                    child: HomeFooter(
                      isMobile: isMobile,
                      isDarkMode: isDarkMode,
                      isEnglish: _isEnglish,
                    ),
                  ),
                ],
              ),
            ),

            // 3. Full-Width Top App Bar (NOT floating, pinned 100% width across top)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 64,
              child: HomeTopAppBar(
                isMobile: isMobile,
                isDarkMode: isDarkMode,
                isEnglish: _isEnglish,
                onToggleTheme: _toggleTheme,
                onToggleLanguage: _toggleLanguage,
                onScrollToFeatured: () => _scrollToKey(_featuredKey),
                onScrollToIconCloud: () => _scrollToKey(_iconCloudKey),
              ),
            ),

            // 4. Floating Back to Top Button (우측 하단 맨위로가기 아이콘 버튼)
            Positioned(
              bottom: isMobile ? 22 : 30,
              right: isMobile ? 20 : 28,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutBack,
                offset: _showBackToTop ? Offset.zero : const Offset(0, 1.6),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 240),
                  opacity: _showBackToTop ? 1.0 : 0.0,
                  child: IgnorePointer(
                    ignoring: !_showBackToTop,
                    child: Tooltip(
                      message: '맨 위로 가기',
                      child: ScaleButton(
                        onTap: _scrollToTop,
                        child: Container(
                          width: isMobile ? 44 : 48,
                          height: isMobile ? 44 : 48,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? const Color(0xFF161922).withValues(alpha: 0.92)
                                : Colors.white.withValues(alpha: 0.96),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDarkMode
                                  ? Colors.white.withValues(alpha: 0.12)
                                  : const Color(0xFFE2E8F0),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDarkMode ? 0.45 : 0.12),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              CupertinoIcons.arrow_up,
                              size: isMobile ? 18 : 20,
                              color: isDarkMode ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ),
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
  // Ambient Aurora & Background
  // ==========================================
  Widget _buildBackgroundAura(bool isDarkMode) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            // Top Ambient Glow
            Positioned(
              top: -160,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeInOut,
                  width: 900,
                  height: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: isDarkMode
                          ? [
                              const Color(0xFF6366F1).withValues(alpha: 0.18),
                              const Color(0xFF8B5CF6).withValues(alpha: 0.08),
                              const Color(0xFF06B6D4).withValues(alpha: 0.03),
                              Colors.transparent,
                            ]
                          : [
                              const Color(0xFF818CF8).withValues(alpha: 0.12),
                              const Color(0xFFC7D2FE).withValues(alpha: 0.08),
                              Colors.transparent,
                            ],
                      stops: const [0.0, 0.35, 0.65, 1.0],
                    ),
                  ),
                ),
              ),
            ),

            // Left Side Subtle Orb
            Positioned(
              top: 400,
              left: -200,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeInOut,
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF38BDF8).withValues(alpha: isDarkMode ? 0.06 : 0.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Right Side Subtle Violet Orb
            Positioned(
              top: 900,
              right: -200,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeInOut,
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF8B5CF6).withValues(alpha: isDarkMode ? 0.06 : 0.04),
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
}
