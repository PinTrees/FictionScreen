import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SteamDeckGameItem {
  final String id;
  final String title;
  final String heroBannerType;
  final Color themeColor;
  final double hoursPlayed;
  final String lastPlayed;
  final int achievementsUnlocked;
  final int achievementsTotal;
  final bool isDeckVerified;

  const SteamDeckGameItem({
    required this.id,
    required this.title,
    required this.heroBannerType,
    required this.themeColor,
    required this.hoursPlayed,
    required this.lastPlayed,
    required this.achievementsUnlocked,
    required this.achievementsTotal,
    this.isDeckVerified = true,
  });
}

class SteamosGamingMode extends StatefulWidget {
  final User? user;
  final String timeString;
  final VoidCallback onToggleSteamMenu;
  final VoidCallback onToggleQam;
  final VoidCallback onSwitchToDesktop;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;

  const SteamosGamingMode({
    super.key,
    required this.user,
    required this.timeString,
    required this.onToggleSteamMenu,
    required this.onToggleQam,
    required this.onSwitchToDesktop,
    required this.onOpenTemplate,
    required this.onOpenSettings,
  });

  @override
  State<SteamosGamingMode> createState() => _SteamosGamingModeState();
}

class _SteamosGamingModeState extends State<SteamosGamingMode> {
  int _activeNavIndex = 0; // 0: Home, 1: Library, 2: Store, 3: Community
  late SteamDeckGameItem _selectedGame;

  final List<SteamDeckGameItem> _games = const [
    SteamDeckGameItem(
      id: 'cyberpunk',
      title: 'Cyberpunk 2077: Phantom Liberty',
      heroBannerType: 'cyberpunk',
      themeColor: Color(0xFFFCEE09),
      hoursPlayed: 84.5,
      lastPlayed: '오늘',
      achievementsUnlocked: 38,
      achievementsTotal: 45,
    ),
    SteamDeckGameItem(
      id: 'elden_ring',
      title: 'ELDEN RING: Shadow of the Erdtree',
      heroBannerType: 'elden',
      themeColor: Color(0xFFC5A059),
      hoursPlayed: 142.0,
      lastPlayed: '어제',
      achievementsUnlocked: 42,
      achievementsTotal: 42,
    ),
    SteamDeckGameItem(
      id: 'wukong',
      title: '검은 신화: 오공 (Black Myth: Wukong)',
      heroBannerType: 'wukong',
      themeColor: Color(0xFFE07A2B),
      hoursPlayed: 56.2,
      lastPlayed: '3일 전',
      achievementsUnlocked: 24,
      achievementsTotal: 36,
    ),
    SteamDeckGameItem(
      id: 'monster_hunter',
      title: '몬스터 헌터 와일즈 (Monster Hunter Wilds)',
      heroBannerType: 'monster_hunter',
      themeColor: Color(0xFF2A9D8F),
      hoursPlayed: 32.8,
      lastPlayed: '5일 전',
      achievementsUnlocked: 18,
      achievementsTotal: 50,
    ),
    SteamDeckGameItem(
      id: 'palworld',
      title: '팔월드 (Palworld)',
      heroBannerType: 'palworld',
      themeColor: Color(0xFF38BDF8),
      hoursPlayed: 68.4,
      lastPlayed: '1주일 전',
      achievementsUnlocked: 29,
      achievementsTotal: 32,
    ),
    SteamDeckGameItem(
      id: 'cs2',
      title: 'Counter-Strike 2',
      heroBannerType: 'cs2',
      themeColor: Color(0xFFF97316),
      hoursPlayed: 520.0,
      lastPlayed: '2주 전',
      achievementsUnlocked: 1,
      achievementsTotal: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedGame = _games[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0C1017),
      child: Stack(
        children: [
          // 1. Dynamic Ambient Background glow matching selected game
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.6, -0.4),
                  radius: 1.4,
                  colors: [
                    _selectedGame.themeColor.withValues(alpha: 0.22),
                    const Color(0xFF131A24).withValues(alpha: 0.6),
                    const Color(0xFF0C1017),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // 2. Main Scrollable Content
          Column(
            children: [
              // Top System Header Bar
              _buildTopHeader(context),

              // Navigation Tabs Ribbon
              _buildNavTabs(),

              // Body Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 54),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Featured Hero Showcase
                      _buildHeroShowcase(),

                      const SizedBox(height: 28),

                      // Horizontal Game Shelves (Recent Games)
                      _buildShelf(
                        title: '최근 플레이한 게임 (RECENT)',
                        games: _games,
                      ),

                      const SizedBox(height: 24),

                      // Horizontal Game Shelves (Deck Verified)
                      _buildShelf(
                        title: '스팀덱 완벽 호환 타이틀 (GREAT ON DECK)',
                        games: _games.reversed.toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 3. Bottom Controller Quick-Guide Bar
          _buildBottomControllerBar(),
        ],
      ),
    );
  }

  // ==========================================
  // Top Header Bar
  // ==========================================
  Widget _buildTopHeader(BuildContext context) {
    final displayName = widget.user?.displayName ?? widget.user?.email?.split('@').first ?? 'GabeN';

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E15).withValues(alpha: 0.85),
        border: const Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          // Steam Logo Brand
          Image.asset('assets/images/steamdeck_icon.png', width: 22, height: 22),
          const SizedBox(width: 8),
          const Text(
            'STEAM DECK',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(width: 14),

          // Search Field Button
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(CupertinoIcons.search, size: 12, color: Colors.white54),
                  SizedBox(width: 6),
                  Text('라이브러리 검색...', style: TextStyle(color: Colors.white54, fontSize: 11)),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Profile Pill
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF1A9FFF),
                ),
                child: Center(
                  child: Text(
                    displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                displayName,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 4),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF57CBDE), // Steam in-game blue
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Download indicator
          const Icon(CupertinoIcons.arrow_down_to_line, color: Colors.white60, size: 15),
          const SizedBox(width: 12),

          // Wi-Fi
          const Icon(CupertinoIcons.wifi, color: Colors.white60, size: 15),
          const SizedBox(width: 12),

          // Battery 98%
          const Row(
            children: [
              Icon(CupertinoIcons.battery_100, color: Color(0xFF22C55E), size: 16),
              SizedBox(width: 4),
              Text('98%', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(width: 14),

          // Digital Clock
          Text(
            widget.timeString,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Navigation Tabs Ribbon
  // ==========================================
  Widget _buildNavTabs() {
    final tabs = ['홈 (HOME)', '라이브러리 (LIBRARY)', '상점 (STORE)', '커뮤니티 (COMMUNITY)'];

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final idx = entry.key;
          final title = entry.value;
          final isSelected = _activeNavIndex == idx;

          return Padding(
            padding: const EdgeInsets.only(right: 24),
            child: InkWell(
              onTap: () {
                setState(() => _activeNavIndex = idx);
                if (idx == 1 || idx == 2) {
                  widget.onOpenTemplate('steam');
                }
              },
              hoverColor: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white54,
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 2.5,
                    width: isSelected ? 24 : 0,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A9FFF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================
  // Featured Hero Showcase
  // ==========================================
  Widget _buildHeroShowcase() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 320,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _selectedGame.themeColor.withValues(alpha: 0.35),
                const Color(0xFF131923),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Stack(
            children: [
              // Subtle Banner Art Glow
              Positioned(
                right: -40,
                top: -40,
                bottom: -40,
                width: 500,
                child: Opacity(
                  opacity: 0.25,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [_selectedGame.themeColor, Colors.transparent],
                      ),
                    ),
                  ),
                ),
              ),

              // Left Details Panel
              Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Verified Badge
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF22C55E).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFF22C55E)),
                          ),
                          child: const Row(
                            children: [
                              Icon(CupertinoIcons.checkmark_seal_fill, color: Color(0xFF22C55E), size: 13),
                              SizedBox(width: 5),
                              Text(
                                'STEAM DECK 완벽 호환',
                                style: TextStyle(
                                  color: Color(0xFF22C55E),
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Row(
                          children: [
                            Icon(CupertinoIcons.cloud_fill, color: Color(0xFF67C1F5), size: 13),
                            SizedBox(width: 4),
                            Text(
                              '클라우드 최신 상태',
                              style: TextStyle(color: Colors.white60, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Game Title
                    Text(
                      _selectedGame.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Stats: hours & last played
                    Text(
                      '플레이 시간: ${_selectedGame.hoursPlayed}시간  •  마지막 플레이: ${_selectedGame.lastPlayed}',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 20),

                    // Play Button & Options
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => widget.onOpenTemplate('steam'),
                          icon: const Icon(CupertinoIcons.play_fill, size: 16, color: Colors.white),
                          label: const Text(
                            '플레이 (PLAY)',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 0.5),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF22C55E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 4,
                          ),
                        ),
                        const SizedBox(width: 14),
                        OutlinedButton.icon(
                          onPressed: () => widget.onOpenTemplate('steam'),
                          icon: const Icon(CupertinoIcons.gear_alt, size: 15, color: Colors.white70),
                          label: const Text('관리', style: TextStyle(color: Colors.white70, fontSize: 13)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white24),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        OutlinedButton.icon(
                          onPressed: widget.onSwitchToDesktop,
                          icon: const Icon(CupertinoIcons.device_desktop, size: 15, color: Color(0xFF67C1F5)),
                          label: const Text('데스크톱 모드 전환', style: TextStyle(color: Color(0xFF67C1F5), fontSize: 13)),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: const Color(0xFF1A9FFF).withValues(alpha: 0.4)),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // Horizontal Game Shelves
  // ==========================================
  Widget _buildShelf({required String title, required List<SteamDeckGameItem> games}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF8F98A0),
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              final isSelected = _selectedGame.id == game.id;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: InkWell(
                  onTap: () => setState(() => _selectedGame = game),
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 130,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A222D),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF1A9FFF) : Colors.white.withValues(alpha: 0.08),
                        width: isSelected ? 2.5 : 1.0,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF1A9FFF).withValues(alpha: 0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Game Card Header Art Box
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: game.themeColor.withValues(alpha: 0.25),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Icon(
                                    CupertinoIcons.gamecontroller_fill,
                                    color: game.themeColor,
                                    size: 34,
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF22C55E),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(CupertinoIcons.checkmark, size: 10, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Title & info
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                game.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${game.hoursPlayed}시간',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 10.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================
  // Bottom Controller Quick-Guide Bar
  // ==========================================
  Widget _buildBottomControllerBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 46,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF080B10).withValues(alpha: 0.95),
          border: const Border(top: BorderSide(color: Colors.white10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left STEAM button
            InkWell(
              onTap: widget.onToggleSteamMenu,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A9FFF).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF1A9FFF).withValues(alpha: 0.5)),
                ),
                child: const Row(
                  children: [
                    Icon(CupertinoIcons.square_fill_line_vertical_square, size: 13, color: Color(0xFF1A9FFF)),
                    SizedBox(width: 6),
                    Text(
                      'STEAM 메뉴',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            // Center Controller hints
            Row(
              children: [
                _buildKeyHint('A', '선택'),
                const SizedBox(width: 14),
                _buildKeyHint('B', '뒤로'),
                const SizedBox(width: 14),
                _buildKeyHint('X', '옵션'),
                const SizedBox(width: 14),
                _buildKeyHint('Y', '검색'),
              ],
            ),

            // Right "..." Quick Access button
            InkWell(
              onTap: widget.onToggleQam,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Row(
                  children: [
                    Text(
                      '••• 빠른 설정',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyHint(String keyLabel, String action) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white30, width: 0.8),
          ),
          child: Center(
            child: Text(
              keyLabel,
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          action,
          style: const TextStyle(color: Colors.white70, fontSize: 11.5),
        ),
      ],
    );
  }
}
