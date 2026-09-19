import 'package:flutter/material.dart';
import 'home/widgets/home_featured_trio.dart';
import 'home/widgets/home_footer.dart';
import 'home/widgets/home_hero_section.dart';
import 'home/widgets/home_icon_cloud.dart';
import 'home/widgets/home_top_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isDarkMode = true;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _featuredKey = GlobalKey();
  final GlobalKey _iconCloudKey = GlobalKey();

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
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
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
      backgroundColor: _isDarkMode ? const Color(0xFF07080D) : const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // 1. Ambient Aurora & Background
          _buildBackgroundAura(),

          // 2. Main Scrollable Content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 64)),

              // Hero Section
              SliverToBoxAdapter(
                child: HomeHeroSection(
                  isMobile: isMobile,
                  isDarkMode: _isDarkMode,
                  onExploreFeatured: () => _scrollToKey(_featuredKey),
                ),
              ),

              // Signature Mockup Trio Section (KakaoTalk, Daangn, Blind)
              SliverToBoxAdapter(
                child: Container(
                  key: _featuredKey,
                  child: HomeFeaturedTrio(
                    isMobile: isMobile,
                    isDarkMode: _isDarkMode,
                  ),
                ),
              ),

              // All Supported Ecosystem Icon Cloud (OS, Apps, Sites with REAL PNG icons)
              SliverToBoxAdapter(
                child: Container(
                  key: _iconCloudKey,
                  child: HomeIconCloud(
                    isMobile: isMobile,
                    isDarkMode: _isDarkMode,
                  ),
                ),
              ),

              // Final CTA Banner & Footer
              SliverToBoxAdapter(
                child: HomeFooter(
                  isMobile: isMobile,
                  isDarkMode: _isDarkMode,
                ),
              ),
            ],
          ),

          // 3. Full-Width Top App Bar (NOT floating, pinned 100% width across top)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 64,
            child: HomeTopAppBar(
              isMobile: isMobile,
              isDarkMode: _isDarkMode,
              onToggleTheme: _toggleTheme,
              onScrollToFeatured: () => _scrollToKey(_featuredKey),
              onScrollToIconCloud: () => _scrollToKey(_iconCloudKey),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Ambient Aurora & Background
  // ==========================================
  Widget _buildBackgroundAura() {
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
                child: Container(
                  width: 900,
                  height: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: _isDarkMode
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
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF38BDF8).withValues(alpha: _isDarkMode ? 0.06 : 0.04),
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
              child: Container(
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF8B5CF6).withValues(alpha: _isDarkMode ? 0.06 : 0.04),
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
