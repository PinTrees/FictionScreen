import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data/steam_model.dart';
import 'widgets/steam_edit_dialog.dart';
import 'widgets/steam_friends_panel.dart';
import 'widgets/steam_game_detail.dart';
import 'widgets/steam_sidebar.dart';
import 'widgets/steam_toast_popup.dart';

class SteamScreen extends StatefulWidget {
  final SteamConfig? config;
  final ValueChanged<SteamConfig>? onConfigChanged;

  const SteamScreen({
    super.key,
    this.config,
    this.onConfigChanged,
  });

  @override
  State<SteamScreen> createState() => _SteamScreenState();
}

class _SteamScreenState extends State<SteamScreen> {
  late SteamConfig _config;
  Timer? _toastDismissTimer;

  @override
  void initState() {
    super.initState();
    _config = widget.config ?? SteamConfig.defaultPreset();
    if (_config.activeToast != null) {
      _startToastTimer();
    }
  }

  @override
  void didUpdateWidget(covariant SteamScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config != null && widget.config != _config) {
      _config = widget.config!;
    }
  }

  @override
  void dispose() {
    _toastDismissTimer?.cancel();
    super.dispose();
  }

  void _startToastTimer() {
    _toastDismissTimer?.cancel();
    _toastDismissTimer = Timer(const Duration(seconds: 8), () {
      if (mounted && _config.activeToast != null) {
        _updateConfig(_config.copyWith(clearToast: true));
      }
    });
  }

  void _updateConfig(SteamConfig newConfig) {
    setState(() => _config = newConfig);
    widget.onConfigChanged?.call(_config);
  }

  void _triggerToast(String title, String subtitle, String type) {
    _updateConfig(
      _config.copyWith(
        activeToast: SteamToastData(
          title: title,
          subtitle: subtitle,
          type: type,
          timestamp: DateTime.now(),
        ),
      ),
    );
    _startToastTimer();
  }

  void _togglePlay() {
    final game = _config.selectedGame;
    final newRunning = !game.isRunning;
    final updatedGames = _config.games.map((g) {
      if (g.id == game.id) {
        return g.copyWith(
          isRunning: newRunning,
          hoursPlayed: newRunning ? g.hoursPlayed + 0.1 : g.hoursPlayed,
        );
      }
      return g;
    }).toList();

    _updateConfig(_config.copyWith(games: updatedGames));

    if (newRunning) {
      _triggerToast('게임 실행 중', '${game.title}을(를) 플레이하고 있습니다.', 'friend_playing');
    }
  }

  void _openEditDialog() {
    showDialog(
      context: context,
      builder: (_) => SteamEditDialog(
        config: _config,
        onSave: _updateConfig,
        onTriggerToast: _triggerToast,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF171A21),
      child: Stack(
        children: [
          Column(
            children: [
              // 1. 스팀 상단 메인 헤더
              _buildTopHeader(),

              // 2. 메인 콘텐츠 영역 (사이드바 + 게임 상세 + 친구 패널)
              Expanded(
                child: Row(
                  children: [
                    // 좌측 게임 라이브러리
                    SteamSidebar(
                      games: _config.games,
                      selectedGameId: _config.selectedGameId,
                      onSelectGame: (id) => _updateConfig(_config.copyWith(selectedGameId: id)),
                    ),

                    // 중앙 게임 상세 뷰
                    Expanded(
                      child: SteamGameDetail(
                        game: _config.selectedGame,
                        onTogglePlay: _togglePlay,
                        onTriggerAchievementToast: () {
                          final ach = _config.selectedGame.achievements.first;
                          _triggerToast('도전 과제 달성!', '${ach.title}: ${ach.description}', 'achievement');
                        },
                      ),
                    ),

                    // 우측 친구 목록 패널 (토글 가능)
                    if (_config.showFriendsPanel)
                      SteamFriendsPanel(
                        friends: _config.friends,
                        onClose: () => _updateConfig(_config.copyWith(showFriendsPanel: false)),
                        onFriendTap: (friendId) {
                          final friend = _config.friends.firstWhere((f) => f.id == friendId);
                          _triggerToast('친구 알림', '${friend.name}님이 ${friend.gameTitle ?? "게임"}을(를) 플레이 중입니다.', 'friend_playing');
                        },
                      ),
                  ],
                ),
              ),

              // 3. 스팀 최하단 상태 표시줄
              _buildBottomStatusBar(),
            ],
          ),

          // 우측 하단 스팀 도전 과제 달성 토스트 오버레이 팝업
          if (_config.activeToast != null)
            Positioned(
              right: _config.showFriendsPanel ? 236 : 16,
              bottom: 34,
              child: SteamToastPopup(
                toast: _config.activeToast!,
                onDismiss: () => _updateConfig(_config.copyWith(clearToast: true)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      height: 72,
      color: const Color(0xFF171D25),
      child: Column(
        children: [
          // 풀다운 메뉴 (Steam, 보기, 친구, 게임, 도움말)
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                _buildMenuText('Steam'),
                _buildMenuText('보기'),
                _buildMenuText('친구'),
                _buildMenuText('게임'),
                _buildMenuText('도움말'),
                const Spacer(),
                InkWell(
                  onTap: _openEditDialog,
                  child: Row(
                    children: const [
                      Icon(CupertinoIcons.slider_horizontal_3, size: 12, color: Color(0xFF66C0F4)),
                      SizedBox(width: 4),
                      Text('시나리오 편집', style: TextStyle(color: Color(0xFF66C0F4), fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 메인 내비게이션 바 (상점, 라이브러리, 커뮤니티, 프로필)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // 뒤로가기 / 앞으로가기
                  const Icon(CupertinoIcons.chevron_left, color: Colors.white38, size: 16),
                  const SizedBox(width: 10),
                  const Icon(CupertinoIcons.chevron_right, color: Colors.white24, size: 16),
                  const SizedBox(width: 20),

                  // 메인 탭들
                  _buildNavTab('상점', false),
                  _buildNavTab('라이브러리', true),
                  _buildNavTab('커뮤니티', false),
                  _buildNavTab(_config.username.toUpperCase(), false),

                  const Spacer(),

                  // 우측 알림 및 지갑
                  IconButton(
                    icon: Icon(
                      _config.showFriendsPanel ? CupertinoIcons.person_2_fill : CupertinoIcons.person_2,
                      size: 16,
                      color: _config.showFriendsPanel ? const Color(0xFF66C0F4) : Colors.white60,
                    ),
                    onPressed: () => _updateConfig(_config.copyWith(showFriendsPanel: !_config.showFriendsPanel)),
                    tooltip: '친구 및 대화 토글',
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF90BA3C).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(CupertinoIcons.bell_fill, color: Color(0xFF90BA3C), size: 12),
                        const SizedBox(width: 4),
                        Text(
                          '${_config.notificationCount}',
                          style: const TextStyle(color: Color(0xFF90BA3C), fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),

                  // 지갑 잔액
                  Text(
                    _config.walletBalance,
                    style: const TextStyle(
                      color: Color(0xFFB8B6B4),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // 프로필 아바타
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF60A5FA)]),
                      border: Border.all(color: const Color(0xFF66C0F4)),
                    ),
                    child: Center(
                      child: Text(
                        _config.username.isNotEmpty ? _config.username.characters.first : 'U',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuText(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Text(
        title,
        style: const TextStyle(color: Color(0xFFB8B6B4), fontSize: 11),
      ),
    );
  }

  Widget _buildNavTab(String title, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: isSelected
            ? const Border(bottom: BorderSide(color: Color(0xFF1A9FFF), width: 3))
            : null,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFFC7D5E0),
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildBottomStatusBar() {
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      color: const Color(0xFF171A21),
      child: Row(
        children: const [
          Icon(CupertinoIcons.arrow_down_circle, color: Color(0xFF66C0F4), size: 12),
          SizedBox(width: 6),
          Text(
            '다운로드 관리',
            style: TextStyle(color: Color(0xFF66C0F4), fontSize: 11),
          ),
          Spacer(),
          Text(
            '친구 및 대화 (5명 온라인)',
            style: TextStyle(color: Color(0xFF8F98A0), fontSize: 11),
          ),
        ],
      ),
    );
  }
}
