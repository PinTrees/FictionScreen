import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/steam_model.dart';

class SteamSidebar extends StatefulWidget {
  final List<SteamGame> games;
  final String selectedGameId;
  final ValueChanged<String> onSelectGame;

  const SteamSidebar({
    super.key,
    required this.games,
    required this.selectedGameId,
    required this.onSelectGame,
  });

  @override
  State<SteamSidebar> createState() => _SteamSidebarState();
}

class _SteamSidebarState extends State<SteamSidebar> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredGames = widget.games.where((g) {
      if (_searchQuery.isEmpty) return true;
      return g.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    final favorites = filteredGames.where((g) => g.category == '즐겨찾기').toList();
    final allGames = filteredGames.where((g) => g.category != '즐겨찾기').toList();

    return Container(
      width: 240,
      color: const Color(0xFF1E2633),
      child: Column(
        children: [
          // 1. 상단 검색 및 필터 바
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: const Color(0xFF1B222E),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF12161E),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.search, color: Colors.white54, size: 14),
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(color: Colors.white, fontSize: 11),
                            decoration: const InputDecoration(
                              hintText: '이름으로 검색',
                              hintStyle: TextStyle(color: Colors.white38, fontSize: 11),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (val) => setState(() => _searchQuery = val),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(CupertinoIcons.slider_horizontal_3, color: Colors.white38, size: 16),
              ],
            ),
          ),

          // 2. 게임 라이브러리 목록
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 6),
              children: [
                if (favorites.isNotEmpty) ...[
                  _buildCategoryHeader('즐겨찾기', favorites.length),
                  ...favorites.map((game) => _buildGameTile(game)),
                  const SizedBox(height: 10),
                ],
                if (allGames.isNotEmpty) ...[
                  _buildCategoryHeader('모든 게임', allGames.length),
                  ...allGames.map((game) => _buildGameTile(game)),
                ],
              ],
            ),
          ),

          // 3. 하단 '+ 게임 추가' 바
          Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: const Color(0xFF171D27),
            child: Row(
              children: const [
                Icon(CupertinoIcons.plus, color: Colors.white54, size: 14),
                SizedBox(width: 6),
                Text(
                  '게임 추가',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          const Icon(CupertinoIcons.chevron_down, color: Colors.white38, size: 10),
          const SizedBox(width: 6),
          Text(
            '$title ($count)',
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameTile(SteamGame game) {
    final isSelected = game.id == widget.selectedGameId;

    return InkWell(
      onTap: () => widget.onSelectGame(game.id),
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF38465B) : Colors.transparent,
          border: isSelected
              ? const Border(left: BorderSide(color: Color(0xFF66C0F4), width: 3))
              : null,
        ),
        child: Row(
          children: [
            // 실행 중 표시 녹색 점
            if (game.isRunning) ...[
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF90BA3C),
                ),
              ),
              const SizedBox(width: 6),
            ] else ...[
              Icon(
                CupertinoIcons.game_controller_solid,
                size: 13,
                color: isSelected ? Colors.white70 : const Color(0xFF8F98A0),
              ),
              const SizedBox(width: 6),
            ],

            Expanded(
              child: Text(
                game.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: game.isRunning
                      ? const Color(0xFF90BA3C)
                      : isSelected
                          ? Colors.white
                          : const Color(0xFF8F98A0),
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
