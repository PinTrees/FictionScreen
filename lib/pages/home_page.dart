import 'package:flutter/material.dart';
import 'home/widgets/home_bento_grid.dart';
import 'home/widgets/home_catalog_section.dart';
import 'home/widgets/home_floating_nav.dart';
import 'home/widgets/home_footer.dart';
import 'home/widgets/home_genre_cliches.dart';
import 'home/widgets/home_hero_section.dart';
import 'home/widgets/home_showcase_deck.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _activeHeroTab = 'news';

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _showcaseKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _clichesKey = GlobalKey();
  final GlobalKey _catalogKey = GlobalKey();

  void _scrollToKey(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _handleQuickLaunch(String templateId) {
    setState(() {
      _activeHeroTab = templateId;
    });
    _scrollToKey(_showcaseKey);
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
      backgroundColor: const Color(0xFF07080D),
      body: Stack(
        children: [
          // 1. Deep Ambient Aura & Grid Mesh Background
          _buildBackgroundAura(),

          // 2. Main Scrollable Content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 90)),

              // Hero Section
              SliverToBoxAdapter(
                child: HomeHeroSection(
                  isMobile: isMobile,
                  onExploreTemplates: () => _scrollToKey(_catalogKey),
                  onQuickLaunch: _handleQuickLaunch,
                ),
              ),

              // Interactive Live Showcase Deck Section
              SliverToBoxAdapter(
                child: Container(
                  key: _showcaseKey,
                  child: HomeShowcaseDeck(
                    isMobile: isMobile,
                    activeTab: _activeHeroTab,
                    onTabChanged: (tabId) {
                      setState(() {
                        _activeHeroTab = tabId;
                      });
                    },
                  ),
                ),
              ),

              // Bento Grid Features Section
              SliverToBoxAdapter(
                child: Container(
                  key: _featuresKey,
                  child: HomeBentoGrid(isMobile: isMobile),
                ),
              ),

              // Genre Clichés Collection
              SliverToBoxAdapter(
                child: Container(
                  key: _clichesKey,
                  child: HomeGenreCliches(isMobile: isMobile),
                ),
              ),

              // Template Catalog Section with Instant Search
              SliverToBoxAdapter(
                child: Container(
                  key: _catalogKey,
                  child: HomeCatalogSection(isMobile: isMobile),
                ),
              ),

              // CTA Banner & Footer
              SliverToBoxAdapter(
                child: HomeFooter(isMobile: isMobile),
              ),
            ],
          ),

          // 3. Floating Glassmorphism Nav Bar
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(
              child: HomeFloatingNav(
                isMobile: isMobile,
                onScrollToShowcase: () => _scrollToKey(_showcaseKey),
                onScrollToFeatures: () => _scrollToKey(_featuresKey),
                onScrollToCliches: () => _scrollToKey(_clichesKey),
                onScrollToCatalog: () => _scrollToKey(_catalogKey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Ambient Aurora & Mesh Background
  // ==========================================
  Widget _buildBackgroundAura() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            // Ambient Top Glow
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
                      colors: [
                        const Color(0xFF6366F1).withValues(alpha: 0.18),
                        const Color(0xFF8B5CF6).withValues(alpha: 0.08),
                        const Color(0xFF06B6D4).withValues(alpha: 0.03),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.35, 0.65, 1.0],
                    ),
                  ),
                ),
              ),
            ),

            // Left Side Subtle Cyan Orb
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
                      const Color(0xFF38BDF8).withValues(alpha: 0.06),
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
                      const Color(0xFF8B5CF6).withValues(alpha: 0.06),
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
