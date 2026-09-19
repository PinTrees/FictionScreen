import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/steam_model.dart';

class SteamEditDialog extends StatefulWidget {
  final SteamConfig config;
  final ValueChanged<SteamConfig> onSave;
  final Function(String title, String subtitle, String type) onTriggerToast;

  const SteamEditDialog({
    super.key,
    required this.config,
    required this.onSave,
    required this.onTriggerToast,
  });

  @override
  State<SteamEditDialog> createState() => _SteamEditDialogState();
}

class _SteamEditDialogState extends State<SteamEditDialog> {
  late TextEditingController _usernameController;
  late TextEditingController _walletController;
  late List<SteamGame> _games;
  late List<SteamFriend> _friends;
  late String _selectedGameId;
  late TextEditingController _gameHoursController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.config.username);
    _walletController = TextEditingController(text: widget.config.walletBalance);
    _games = List.from(widget.config.games);
    _friends = List.from(widget.config.friends);
    _selectedGameId = widget.config.selectedGameId;

    final game = _games.firstWhere((g) => g.id == _selectedGameId, orElse: () => _games.first);
    _gameHoursController = TextEditingController(text: game.hoursPlayed.toStringAsFixed(1));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _walletController.dispose();
    _gameHoursController.dispose();
    super.dispose();
  }

  void _saveCurrentGameFields() {
    final idx = _games.indexWhere((g) => g.id == _selectedGameId);
    if (idx != -1) {
      final hours = double.tryParse(_gameHoursController.text.trim()) ?? _games[idx].hoursPlayed;
      _games[idx] = _games[idx].copyWith(hoursPlayed: hours);
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = _games.firstWhere((g) => g.id == _selectedGameId, orElse: () => _games.first);

    return Dialog(
      backgroundColor: const Color(0xFF1E2633),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFF2A475E)),
      ),
      child: Container(
        width: 580,
        height: 620,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 다이얼로그 헤더
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset('assets/images/steam_icon.webp', width: 24, height: 24),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Steam 라이브러리 & 시나리오 편집',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(CupertinoIcons.xmark, color: Colors.white70, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 알림 토스트 즉시 연출 버튼
            Row(
              children: [
                const Text('즉시 연출: ', style: TextStyle(color: Colors.white54, fontSize: 12)),
                _buildActionButton(
                  '🏆 도전 과제 팝업',
                  () {
                    widget.onTriggerToast('도전 과제 달성!', '${game.title}: 전설적인 위업 완수', 'achievement');
                  },
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  '🎮 친구 게임 접속 알림',
                  () {
                    widget.onTriggerToast('친구 알림', '김철수님이 ${game.title} 게임을 시작했습니다.', 'friend_playing');
                  },
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 편집 세부 폼
            Expanded(
              child: ListView(
                children: [
                  // 프로필 정보
                  Row(
                    children: [
                      Expanded(child: _buildInput('사용자 닉네임', _usernameController)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildInput('지갑 잔액', _walletController)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 게임 플레이 상태
                  const Text('현재 선택된 게임 설정', style: TextStyle(color: Color(0xFF66C0F4), fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          game.title,
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Switch(
                        value: game.isRunning,
                        activeThumbColor: const Color(0xFF90BA3C),
                        onChanged: (val) {
                          setState(() {
                            final idx = _games.indexWhere((g) => g.id == _selectedGameId);
                            _games[idx] = _games[idx].copyWith(isRunning: val);
                          });
                        },
                      ),
                      Text(game.isRunning ? '게임 실행 중' : '미실행', style: TextStyle(color: game.isRunning ? const Color(0xFF90BA3C) : Colors.white54, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildInput('누적 플레이 시간 (시간 단위)', _gameHoursController),
                  const SizedBox(height: 16),

                  // 친구 목록 설정
                  const Text('친구 접속 상태 편집', style: TextStyle(color: Color(0xFF66C0F4), fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ..._friends.map((f) => _buildFriendEditTile(f)),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 하단 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('취소', style: TextStyle(color: Colors.white54)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _saveCurrentGameFields();
                    final newConfig = widget.config.copyWith(
                      username: _usernameController.text.trim(),
                      walletBalance: _walletController.text.trim(),
                      games: _games,
                      friends: _friends,
                      selectedGameId: _selectedGameId,
                    );
                    widget.onSave(newConfig);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF66C0F4),
                    foregroundColor: const Color(0xFF1B2838),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Text('적용하기', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF2A475E),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF66C0F4).withValues(alpha: 0.5)),
        ),
        child: Text(title, style: const TextStyle(color: Color(0xFF66C0F4), fontSize: 11, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: const Color(0xFF12161E),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xFF2A475E))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Color(0xFF66C0F4))),
          ),
        ),
      ],
    );
  }

  Widget _buildFriendEditTile(SteamFriend friend) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF16202D),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Text(friend.name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(width: 12),
          DropdownButton<SteamFriendStatus>(
            value: friend.status,
            dropdownColor: const Color(0xFF1B2838),
            underline: const SizedBox.shrink(),
            items: SteamFriendStatus.values.map((st) {
              return DropdownMenuItem(
                value: st,
                child: Text(st.label, style: TextStyle(color: st.color, fontSize: 11)),
              );
            }).toList(),
            onChanged: (newStatus) {
              if (newStatus != null) {
                setState(() {
                  final idx = _friends.indexWhere((f) => f.id == friend.id);
                  _friends[idx] = _friends[idx].copyWith(status: newStatus);
                });
              }
            },
          ),
          const SizedBox(width: 12),
          if (friend.status == SteamFriendStatus.inGame)
            Expanded(
              child: Text(
                friend.gameTitle ?? 'Cyberpunk 2077',
                style: const TextStyle(color: Color(0xFF90BA3C), fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}
