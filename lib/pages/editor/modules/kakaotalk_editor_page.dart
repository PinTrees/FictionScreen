import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../apps/kakaotalk/data/kakaotalk_model.dart';
import '../../../../apps/kakaotalk/kakaotalk_screen.dart';
import '../../../../apps/screen_template.dart';
import '../core/app_editor_shell.dart';

/// 카카오톡 전용 피그마 스타일 전체화면 에디터
class KakaoTalkEditorPage extends StatefulWidget {
  final VoidCallback onBackToGallery;
  final Function(String osKey) onOpenInOs;

  const KakaoTalkEditorPage({
    super.key,
    required this.onBackToGallery,
    required this.onOpenInOs,
  });

  @override
  State<KakaoTalkEditorPage> createState() => _KakaoTalkEditorPageState();
}

class _KakaoTalkEditorPageState extends State<KakaoTalkEditorPage> {
  late KakaoRoomConfig _config;
  final TextEditingController _msgInputCtrl = TextEditingController();
  bool _newMsgIsMe = true;
  bool _newMsgHasUnread = true;

  @override
  void initState() {
    super.initState();
    _config = KakaoRoomConfig.defaultPreset();
  }

  @override
  void dispose() {
    _msgInputCtrl.dispose();
    super.dispose();
  }

  ScreenTemplate get _template {
    return ScreenTemplate.allTemplates.firstWhere(
      (t) => t.id == 'kakaotalk',
      orElse: () => ScreenTemplate.allTemplates.first,
    );
  }

  void _addNewMessage() {
    final text = _msgInputCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _config.messages.add(
        KakaoMessage(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
          senderName: _newMsgIsMe ? '나' : _config.partnerProfileName,
          isMe: _newMsgIsMe,
          text: text,
          time: _config.statusBarTime,
          unreadCount: _newMsgHasUnread ? 1 : 0,
        ),
      );
      _msgInputCtrl.clear();
    });
  }

  void _deleteMessage(int index) {
    setState(() {
      _config.messages.removeAt(index);
    });
  }

  void _toggleMessageUnread(int index) {
    setState(() {
      final msg = _config.messages[index];
      msg.unreadCount = msg.unreadCount > 0 ? 0 : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppEditorShell(
      template: _template,
      onBackToGallery: widget.onBackToGallery,
      onOpenInOs: widget.onOpenInOs,
      canvasBuilder: (ctx, isDark) {
        return KakaoTalkScreen(config: _config);
      },
      inspectorBuilder: (ctx, isDark) {
        return _buildFigmaInspector(isDark);
      },
    );
  }

  Widget _buildFigmaInspector(bool isDark) {
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDark ? Colors.white54 : const Color(0xFF64748B);
    final fieldBgColor = isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF1F5F9);
    final cardBgColor = isDark ? const Color(0xFF141822) : const Color(0xFFF8FAFC);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        // Inspector Header
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFFEE500),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '카카오톡 프로퍼티',
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE500).withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'LIVE SYNC',
                style: TextStyle(color: Color(0xFFF59E0B), fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // Section 1: 대화방 및 프로필 설정
        _buildSectionTitle('대화방 및 프로필', isDark),
        const SizedBox(height: 10),
        _buildTextField('대화방 / 상대방 이름', _config.roomTitle, fieldBgColor, textColor, textSubColor, (val) {
          setState(() {
            _config.roomTitle = val;
            _config.partnerProfileName = val;
          });
        }),
        _buildSwitchField('다크 테마 (Dark Mode)', _config.isDarkTheme, textColor, (val) {
          setState(() => _config.isDarkTheme = val);
        }),

        const SizedBox(height: 18),

        // Section 2: 시스템 상단바 설정
        _buildSectionTitle('시스템 상단바 (Status Bar)', isDark),
        const SizedBox(height: 10),
        _buildTextField('상태바 시각', _config.statusBarTime, fieldBgColor, textColor, textSubColor, (val) {
          setState(() => _config.statusBarTime = val);
        }),
        _buildSliderField('배터리 잔량 (%)', _config.batteryLevel.toDouble(), 1, 100, textColor, (val) {
          setState(() => _config.batteryLevel = val.toInt());
        }),

        const SizedBox(height: 18),

        // Section 3: 실시간 메시지 발송 / 타임라인
        _buildSectionTitle('실시간 메시지 추가', isDark),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sender Toggle (Me vs Partner, NO OUTLINE)
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('내가 보냄')),
                      selected: _newMsgIsMe,
                      side: BorderSide.none,
                      selectedColor: const Color(0xFF6366F1),
                      backgroundColor: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0),
                      labelStyle: TextStyle(
                        color: _newMsgIsMe ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF475569)),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (val) => setState(() => _newMsgIsMe = true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('상대방이 보냄')),
                      selected: !_newMsgIsMe,
                      side: BorderSide.none,
                      selectedColor: const Color(0xFF6366F1),
                      backgroundColor: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0),
                      labelStyle: TextStyle(
                        color: !_newMsgIsMe ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF475569)),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (val) => setState(() => _newMsgIsMe = false),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Unread '1' Toggle
              Row(
                children: [
                  Text('‘1’ 안읽음 표시', style: TextStyle(color: textSubColor, fontSize: 11.5)),
                  const Spacer(),
                  CupertinoSwitch(
                    value: _newMsgHasUnread,
                    activeTrackColor: const Color(0xFF6366F1),
                    onChanged: (val) => setState(() => _newMsgHasUnread = val),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Message Input & Send Button
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgInputCtrl,
                      style: TextStyle(color: textColor, fontSize: 12.5),
                      decoration: InputDecoration(
                        hintText: '대화 내용 입력...',
                        hintStyle: TextStyle(color: textSubColor.withValues(alpha: 0.6), fontSize: 12),
                        filled: true,
                        fillColor: fieldBgColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                      onSubmitted: (_) => _addNewMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEE500),
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _addNewMessage,
                    child: const Text('전송', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Section 4: 메시지 목록 타임라인 관리
        Row(
          children: [
            _buildSectionTitle('메시지 타임라인 (${_config.messages.length})', isDark),
            const Spacer(),
            if (_config.messages.isNotEmpty)
              TextButton(
                onPressed: () => setState(() => _config.messages.clear()),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
                child: const Text('전체 삭제', style: TextStyle(fontSize: 11)),
              ),
          ],
        ),

        const SizedBox(height: 8),

        if (_config.messages.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                '대화방에 메시지가 없습니다.\n위 입력창에서 메시지를 추가해보세요.',
                textAlign: TextAlign.center,
                style: TextStyle(color: textSubColor, fontSize: 12, height: 1.5),
              ),
            ),
          )
        else
          ..._config.messages.asMap().entries.map((entry) {
            final idx = entry.key;
            final msg = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: msg.isMe
                          ? const Color(0xFF6366F1).withValues(alpha: 0.15)
                          : const Color(0xFFFEE500).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      msg.isMe ? '나' : '상대',
                      style: TextStyle(
                        color: msg.isMe ? const Color(0xFF818CF8) : const Color(0xFFD97706),
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.text,
                          style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${msg.time} • ${msg.unreadCount > 0 ? "안읽음(1)" : "읽음"}',
                          style: TextStyle(color: textSubColor, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      msg.unreadCount > 0 ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                      size: 14,
                      color: msg.unreadCount > 0 ? const Color(0xFFF59E0B) : textSubColor,
                    ),
                    tooltip: '1 안읽음 토글',
                    onPressed: () => _toggleMessageUnread(idx),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                  ),
                  IconButton(
                    icon: const Icon(CupertinoIcons.trash, size: 14, color: Colors.redAccent),
                    tooltip: '삭제',
                    onPressed: () => _deleteMessage(idx),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                  ),
                ],
              ),
            );
          }),

        const SizedBox(height: 18),

        // Section 5: 카카오페이 연동
        _buildSectionTitle('카카오페이 설정', isDark),
        const SizedBox(height: 10),
        _buildTextField('카카오페이 잔액 (원)', _config.kakaoPayBalance.toString(), fieldBgColor, textColor, textSubColor, (val) {
          setState(() {
            _config.kakaoPayBalance = int.tryParse(val) ?? _config.kakaoPayBalance;
          });
        }, isNumber: true),

        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF6366F1),
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String initialVal,
    Color fieldBgColor,
    Color textColor,
    Color textSubColor,
    ValueChanged<String> onChanged, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: textSubColor, fontSize: 11.5, fontWeight: FontWeight.w500)),
          const SizedBox(height: 5),
          TextFormField(
            initialValue: initialVal,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            style: TextStyle(color: textColor, fontSize: 12.5),
            decoration: InputDecoration(
              filled: true,
              fillColor: fieldBgColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderField(
    String label,
    double value,
    double min,
    double max,
    Color textColor,
    ValueChanged<double> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 11.5, color: Colors.white70)),
              Text('${value.toInt()}', style: const TextStyle(color: Color(0xFF6366F1), fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              activeColor: const Color(0xFF6366F1),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchField(String label, bool value, Color textColor, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: textColor.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w500)),
          CupertinoSwitch(
            value: value,
            activeTrackColor: const Color(0xFF6366F1),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
