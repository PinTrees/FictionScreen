import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../apps/kakaotalk/data/kakaotalk_model.dart';
import '../../../../apps/kakaotalk/kakaotalk_screen.dart';
import '../../../../apps/screen_template.dart';
import '../../../../services/project_service.dart';
import '../../../../widgets/scale_button.dart';
import '../../console/workspace/models/project_model.dart';
import '../core/app_editor_shell.dart';

/// 카카오톡 전용 피그마 스타일 전체화면 에디터
/// 좌측 사이드바: 각 오브젝트/레이어 목록 (피그마 레이어 패널)
/// 중앙 캔버스: 실시간 렌더링 및 클릭 선택
/// 우측 사이드바: 선택된 오브젝트 전용 인스펙터 속성 패널
class KakaoTalkEditorPage extends StatefulWidget {
  final String? projectId;
  final VoidCallback onBackToGallery;
  final Function(String osKey) onOpenInOs;

  const KakaoTalkEditorPage({
    super.key,
    this.projectId,
    required this.onBackToGallery,
    required this.onOpenInOs,
  });

  @override
  State<KakaoTalkEditorPage> createState() => _KakaoTalkEditorPageState();
}

class _KakaoTalkEditorPageState extends State<KakaoTalkEditorPage> {
  late KakaoRoomConfig _config;
  String _selectedObjectId = 'partner_profile'; // 기본 선택 오브젝트
  final TextEditingController _quickMsgCtrl = TextEditingController();
  bool _quickMsgIsMe = true;
  bool _quickMsgHasUnread = true;

  String _documentTitle = '카카오톡 대화 작업';
  bool _isLoadingDoc = false;
  Timer? _autoSaveTimer;

  @override
  void initState() {
    super.initState();
    _config = KakaoRoomConfig.defaultPreset();
    if (widget.projectId != null) {
      _loadDocument();
    }
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _quickMsgCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadDocument() async {
    setState(() => _isLoadingDoc = true);
    try {
      final proj = await ProjectService.getProject(widget.projectId!);
      if (proj != null) {
        setState(() {
          _documentTitle = proj.title;
          if (proj.contentData != null) {
            _config = KakaoRoomConfig.fromMap(proj.contentData!);
          }
        });
        if (proj.contentData == null) {
          _triggerAutoSave();
        }
      }
    } catch (e) {
      debugPrint('[KakaoTalkEditorPage] Error loading document: $e');
    } finally {
      if (mounted) setState(() => _isLoadingDoc = false);
    }
  }

  void _triggerAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(milliseconds: 600), () {
      if (widget.projectId != null) {
        ProjectService.updateProjectData(
          widget.projectId!,
          _config.toMap(),
          title: _documentTitle.isNotEmpty ? _documentTitle : _config.roomTitle,
        );
      }
    });
  }

  Future<void> _duplicateEntireProject() async {
    final newDocId = 'proj_${DateTime.now().millisecondsSinceEpoch}';
    final newProj = ProjectModel(
      id: newDocId,
      title: '$_documentTitle (사본)',
      appTemplateId: 'kakaotalk',
      contentData: _config.toMap(),
      updatedAt: DateTime.now(),
    );
    await ProjectService.createProject(newProj);
    if (!mounted) return;
    context.go('/editor/kakaotalk/$newDocId');
  }

  Future<void> _createNewDocument() async {
    final newDocId = 'proj_${DateTime.now().millisecondsSinceEpoch}';
    final defaultCfg = KakaoRoomConfig.defaultPreset();
    final newProj = ProjectModel(
      id: newDocId,
      title: '새 카카오톡 작업',
      appTemplateId: 'kakaotalk',
      contentData: defaultCfg.toMap(),
      updatedAt: DateTime.now(),
    );
    await ProjectService.createProject(newProj);
    if (!mounted) return;
    context.go('/editor/kakaotalk/$newDocId');
  }

  ScreenTemplate get _template {
    return ScreenTemplate.allTemplates.firstWhere(
      (t) => t.id == 'kakaotalk',
      orElse: () => ScreenTemplate.allTemplates.first,
    );
  }

  void _selectObject(String objectId) {
    setState(() {
      _selectedObjectId = objectId;
    });
  }

  void _addNewMessage({String? customText}) {
    final text = customText ?? _quickMsgCtrl.text.trim();
    if (text.isEmpty) return;

    final newId = 'msg_${DateTime.now().millisecondsSinceEpoch}';
    final newMsg = KakaoMessage(
      id: newId,
      senderName: _quickMsgIsMe ? '나' : _config.partnerProfileName,
      isMe: _quickMsgIsMe,
      text: text,
      time: _config.statusBarTime,
      unreadCount: _quickMsgHasUnread ? 1 : 0,
    );

    setState(() {
      _config.messages.add(newMsg);
      _selectedObjectId = 'msg_$newId';
      _quickMsgCtrl.clear();
    });
    _triggerAutoSave();
  }

  void _duplicateMessage(KakaoMessage msg) {
    final index = _config.messages.indexOf(msg);
    if (index == -1) return;

    final newId = 'msg_${DateTime.now().millisecondsSinceEpoch}';
    final duplicated = msg.copyWith(
      id: newId,
      text: '${msg.text} (복사본)',
    );

    setState(() {
      _config.messages.insert(index + 1, duplicated);
      _selectedObjectId = 'msg_$newId';
    });
    _triggerAutoSave();
  }

  void _deleteMessage(String msgId) {
    setState(() {
      _config.messages.removeWhere((m) => m.id == msgId);
      if (_selectedObjectId == 'msg_$msgId') {
        _selectedObjectId = _config.messages.isNotEmpty ? 'msg_${_config.messages.last.id}' : 'room_settings';
      }
    });
    _triggerAutoSave();
  }

  void _moveMessage(int fromIndex, int toIndex) {
    if (toIndex < 0 || toIndex >= _config.messages.length) return;
    setState(() {
      final item = _config.messages.removeAt(fromIndex);
      _config.messages.insert(toIndex, item);
    });
    _triggerAutoSave();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingDoc) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F1219),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF6366F1)),
        ),
      );
    }

    return AppEditorShell(
      template: _template,
      documentTitle: _documentTitle,
      documentId: widget.projectId,
      onBackToGallery: widget.onBackToGallery,
      onOpenInOs: widget.onOpenInOs,
      // Left Figma-style Layers Sidebar
      layersBuilder: (ctx, isDark) {
        return _buildFigmaLayers(isDark);
      },
      // Center Canvas
      canvasBuilder: (ctx, isDark) {
        return KakaoTalkScreen(
          config: _config,
          selectedElementId: _selectedObjectId,
          onSelectElement: _selectObject,
        );
      },
      // Right Figma-style Inspector Panel
      inspectorBuilder: (ctx, isDark) {
        return _buildFigmaInspector(isDark);
      },
    );
  }

  // ==========================================
  // 좌측 사이드바: 피그마 스타일 레이어 / 오브젝트 패널 (ZERO OUTLINE)
  // ==========================================
  Widget _buildFigmaLayers(bool isDark) {
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDark ? Colors.white54 : const Color(0xFF64748B);
    final totalObjects = 5 + _config.messages.length;

    return Column(
      children: [
        // Layers Header (ZERO OUTLINE)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              const Icon(CupertinoIcons.square_stack_3d_up_fill, size: 16, color: Color(0xFF6366F1)),
              const SizedBox(width: 8),
              Text(
                '레이어 (Layers)',
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFEEF2F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$totalObjects',
                  style: TextStyle(
                    color: textSubColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Layers Tree Scrollable List (ZERO OUTLINE)
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            children: [
              // Group 1: 화면 프레임 & 기본 설정
              _buildLayerGroupTitle('프레임 & 시스템', isDark),
              _buildLayerItem(
                id: 'statusbar',
                icon: CupertinoIcons.battery_charging,
                title: '상단 상태바',
                subtitle: '${_config.statusBarTime} • ${_config.batteryLevel}%',
                isDark: isDark,
              ),
              _buildLayerItem(
                id: 'partner_profile',
                icon: CupertinoIcons.person_crop_circle_fill,
                title: '상대방 프로필 & 타이틀',
                subtitle: _config.partnerProfileName,
                isDark: isDark,
              ),
              _buildLayerItem(
                id: 'room_settings',
                icon: CupertinoIcons.slider_horizontal_3,
                title: '대화방 테마 & 설정',
                subtitle: _config.isDarkTheme ? '다크 테마' : '라이트 테마',
                isDark: isDark,
              ),
              _buildLayerItem(
                id: 'notice_banner',
                icon: CupertinoIcons.speaker_2_fill,
                title: '상단 공지 배너',
                subtitle: _config.showNotice ? '활성화됨' : '숨김',
                badgeText: _config.showNotice ? 'ON' : null,
                isDark: isDark,
              ),

              const SizedBox(height: 14),

              // Group 2: 메시지 타임라인 레이어들
              Row(
                children: [
                  _buildLayerGroupTitle('메시지 타임라인 (${_config.messages.length})', isDark),
                  const Spacer(),
                  ScaleButton(
                    onTap: () => _addNewMessage(customText: '새 메시지입니다.'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.plus, size: 10, color: Color(0xFF6366F1)),
                          SizedBox(width: 2),
                          Text('추가', style: TextStyle(color: Color(0xFF6366F1), fontSize: 10.5, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              if (_config.messages.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      '등록된 메시지가 없습니다',
                      style: TextStyle(color: textSubColor, fontSize: 11),
                    ),
                  ),
                )
              else
                ..._config.messages.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final msg = entry.value;
                  final isMe = msg.isMe;

                  return _buildMessageLayerItem(
                    index: idx,
                    msg: msg,
                    isMe: isMe,
                    isDark: isDark,
                  );
                }),

              const SizedBox(height: 14),

              // Group 3: 하단 인터랙션 컨트롤
              _buildLayerGroupTitle('인터랙션 컨트롤', isDark),
              _buildLayerItem(
                id: 'input_bar',
                icon: CupertinoIcons.pencil_ellipsis_rectangle,
                title: '하단 입력창 (Input Bar)',
                subtitle: _config.inputText.isNotEmpty ? _config.inputText : '미입력 상태',
                isDark: isDark,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLayerGroupTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, bottom: 6, top: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildLayerItem({
    required String id,
    required IconData icon,
    required String title,
    required String subtitle,
    String? badgeText,
    required bool isDark,
  }) {
    final isSelected = _selectedObjectId == id;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDark ? Colors.white54 : const Color(0xFF64748B);

    return ScaleButton(
      onTap: () => _selectObject(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        margin: const EdgeInsets.only(bottom: 3),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF6366F1).withValues(alpha: 0.22) : const Color(0xFFEEF2FF))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? const Color(0xFF6366F1) : textSubColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF6366F1) : textColor,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: textSubColor,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (badgeText != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badgeText,
                  style: const TextStyle(color: Color(0xFF10B981), fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageLayerItem({
    required int index,
    required KakaoMessage msg,
    required bool isMe,
    required bool isDark,
  }) {
    final layerId = 'msg_${msg.id}';
    final isSelected = _selectedObjectId == layerId;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDark ? Colors.white54 : const Color(0xFF64748B);

    return ScaleButton(
      onTap: () => _selectObject(layerId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        margin: const EdgeInsets.only(bottom: 3),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF6366F1).withValues(alpha: 0.22) : const Color(0xFFEEF2FF))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Sender Badge Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: isMe
                    ? const Color(0xFFFEE500)
                    : (isDark ? Colors.white.withValues(alpha: 0.14) : const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isMe ? '나' : '상대',
                style: TextStyle(
                  color: isMe ? Colors.black87 : (isDark ? Colors.white : const Color(0xFF334155)),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Message Snippet
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text.isNotEmpty ? msg.text : '(내용 없음)',
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF6366F1) : textColor,
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '#${index + 1} • ${msg.time}${msg.unreadCount > 0 ? " • 1안읽음" : ""}',
                    style: TextStyle(
                      color: textSubColor,
                      fontSize: 9.5,
                    ),
                  ),
                ],
              ),
            ),

            // Quick Delete Button (ZERO OUTLINE)
            ScaleButton(
              onTap: () => _deleteMessage(msg.id),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  CupertinoIcons.xmark,
                  size: 11,
                  color: textSubColor.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 우측 사이드바: 피그마 스타일 인스펙터 속성 패널 (선택된 오브젝트 전용, ZERO OUTLINE)
  // ==========================================
  Widget _buildFigmaInspector(bool isDark) {
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final cardBgColor = isDark ? const Color(0xFF141822) : const Color(0xFFF8FAFC);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        // Inspector Header with Breadcrumb
        _buildInspectorHeader(isDark),

        const SizedBox(height: 16),

        // Dynamic Inspector based on _selectedObjectId
        if (_selectedObjectId == 'statusbar')
          _buildStatusBarInspector(isDark)
        else if (_selectedObjectId == 'partner_profile')
          _buildPartnerProfileInspector(isDark)
        else if (_selectedObjectId == 'room_settings')
          _buildRoomSettingsInspector(isDark)
        else if (_selectedObjectId == 'notice_banner')
          _buildNoticeBannerInspector(isDark)
        else if (_selectedObjectId == 'input_bar')
          _buildInputBarInspector(isDark)
        else if (_selectedObjectId.startsWith('msg_'))
          _buildSelectedMessageInspector(isDark)
        else
          _buildRoomSettingsInspector(isDark),

        const SizedBox(height: 24),

        // Quick Message Add Section at the bottom of Inspector
        _buildQuickAddMessageSection(cardBgColor, isDark, textColor),

        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildInspectorHeader(bool isDark) {
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final String title;
    final IconData icon;

    if (_selectedObjectId == 'statusbar') {
      title = '상태바 (Status Bar) 속성';
      icon = CupertinoIcons.battery_charging;
    } else if (_selectedObjectId == 'partner_profile') {
      title = '상대방 프로필 속성';
      icon = CupertinoIcons.person_crop_circle_fill;
    } else if (_selectedObjectId == 'room_settings') {
      title = '대화방 테마 및 환경 설정';
      icon = CupertinoIcons.slider_horizontal_3;
    } else if (_selectedObjectId == 'notice_banner') {
      title = '상단 공지사항 속성';
      icon = CupertinoIcons.speaker_2_fill;
    } else if (_selectedObjectId == 'input_bar') {
      title = '하단 입력창 속성';
      icon = CupertinoIcons.pencil_ellipsis_rectangle;
    } else if (_selectedObjectId.startsWith('msg_')) {
      final msgId = _selectedObjectId.replaceFirst('msg_', '');
      final idx = _config.messages.indexWhere((m) => m.id == msgId);
      title = '메시지 #${idx + 1} 속성';
      icon = CupertinoIcons.chat_bubble_2_fill;
    } else {
      title = '인스펙터 속성';
      icon = CupertinoIcons.gear_alt_fill;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF6366F1)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'INSPECT',
              style: TextStyle(color: Color(0xFF818CF8), fontSize: 9, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // --- 1. Status Bar Inspector ---
  Widget _buildStatusBarInspector(bool isDark) {
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDark ? Colors.white54 : const Color(0xFF64748B);
    final fieldBgColor = isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF1F5F9);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('상태바 시각', isDark),
        const SizedBox(height: 8),
        _buildTextField('시계 표시 텍스트', _config.statusBarTime, fieldBgColor, textColor, textSubColor, (val) {
          setState(() => _config.statusBarTime = val);
        }),
        const SizedBox(height: 14),
        _buildSectionTitle('배터리 잔량 (%)', isDark),
        const SizedBox(height: 8),
        _buildSliderField('배터리 게이지', _config.batteryLevel.toDouble(), 1, 100, textColor, (val) {
          setState(() => _config.batteryLevel = val.toInt());
        }),
        const SizedBox(height: 14),
        _buildSectionTitle('네트워크 모드', isDark),
        const SizedBox(height: 8),
        Row(
          children: ['5G', 'LTE', 'Wi-Fi'].map((net) {
            final isSelected = _config.networkType == net;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: ScaleButton(
                  onTap: () => setState(() => _config.networkType = net),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF6366F1)
                          : (isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        net,
                        style: TextStyle(
                          color: isSelected ? Colors.white : textColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- 2. Partner Profile Inspector ---
  Widget _buildPartnerProfileInspector(bool isDark) {
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDark ? Colors.white54 : const Color(0xFF64748B);
    final fieldBgColor = isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF1F5F9);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('상대방 이름 & 대화방 타이틀', isDark),
        const SizedBox(height: 8),
        _buildTextField('상대방 프로필 이름', _config.partnerProfileName, fieldBgColor, textColor, textSubColor, (val) {
          setState(() {
            _config.partnerProfileName = val;
            _config.roomTitle = val;
            // 메시지 중 상대방 보낸 메시지의 발신인 이름도 자동 동기화
            for (final m in _config.messages) {
              if (!m.isMe) m.senderName = val;
            }
          });
        }),
        const SizedBox(height: 14),
        _buildSectionTitle('단톡방 인원 수 (0이면 1:1 대화방)', isDark),
        const SizedBox(height: 8),
        _buildTextField('참여 인원 수 (예: 0, 3, 10)', _config.memberCount.toString(), fieldBgColor, textColor, textSubColor, (val) {
          setState(() {
            _config.memberCount = int.tryParse(val) ?? 0;
          });
        }, isNumber: true),
      ],
    );
  }

  // --- 3. Room Settings & Theme Inspector ---
  Widget _buildRoomSettingsInspector(bool isDark) {
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDark ? Colors.white54 : const Color(0xFF64748B);
    final fieldBgColor = isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF1F5F9);

    final colorPresets = [
      {'name': '기본 하늘색', 'color': const Color(0xFFBACEE0)},
      {'name': '다크 차콜', 'color': const Color(0xFF1E1E1E)},
      {'name': '파스텔 핑크', 'color': const Color(0xFFFFDDE1)},
      {'name': '소프트 민트', 'color': const Color(0xFFD6EFD8)},
      {'name': '라벤더', 'color': const Color(0xFFE8E5F9)},
      {'name': '웜 크림', 'color': const Color(0xFFFFF7DF)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Document & Paging Management Section
        _buildSectionTitle('작업 문서 & 페이징 정보', isDark),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(CupertinoIcons.doc_text_fill, size: 14, color: Color(0xFF6366F1)),
                  const SizedBox(width: 6),
                  Text(
                    '문서 고유 ID',
                    style: TextStyle(color: textSubColor, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.projectId ?? '임시 작업',
                      style: const TextStyle(color: Color(0xFF818CF8), fontSize: 10.5, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildTextField('작업 프로젝트 이름', _documentTitle, fieldBgColor, textColor, textSubColor, (val) {
                setState(() {
                  _documentTitle = val;
                });
                _triggerAutoSave();
              }),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ScaleButton(
                      onTap: _duplicateEntireProject,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.doc_on_doc, size: 12, color: Color(0xFF6366F1)),
                            SizedBox(width: 4),
                            Text('새 페이지로 복제', style: TextStyle(color: Color(0xFF6366F1), fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: ScaleButton(
                      onTap: _createNewDocument,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.plus, size: 12, color: textColor),
                            const SizedBox(width: 4),
                            Text('새 빈 작업', style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _buildSectionTitle('대화방 테마', isDark),
        const SizedBox(height: 8),
        _buildSwitchField('카카오톡 다크 모드', _config.isDarkTheme, textColor, (val) {
          setState(() => _config.isDarkTheme = val);
          _triggerAutoSave();
        }),
        const SizedBox(height: 14),
        _buildSectionTitle('대화방 배경색 프리셋', isDark),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colorPresets.map((preset) {
            final col = preset['color'] as Color;
            final isCurrent = _config.customBgColor?.toARGB32() == col.toARGB32();
            return ScaleButton(
              onTap: () {
                setState(() => _config.customBgColor = col);
                _triggerAutoSave();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: isCurrent ? const Color(0xFF6366F1).withValues(alpha: 0.18) : fieldBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: col,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      preset['name'] as String,
                      style: TextStyle(
                        color: isCurrent ? const Color(0xFF6366F1) : textColor,
                        fontSize: 11.5,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _buildSectionTitle('카카오페이 연동 잔액', isDark),
        const SizedBox(height: 8),
        _buildTextField('페이 잔액 (원)', _config.kakaoPayBalance.toString(), fieldBgColor, textColor, textSubColor, (val) {
          setState(() {
            _config.kakaoPayBalance = int.tryParse(val) ?? _config.kakaoPayBalance;
          });
          _triggerAutoSave();
        }, isNumber: true),
      ],
    );
  }

  // --- 4. Notice Banner Inspector ---
  Widget _buildNoticeBannerInspector(bool isDark) {
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDark ? Colors.white54 : const Color(0xFF64748B);
    final fieldBgColor = isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF1F5F9);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('공지사항 설정', isDark),
        const SizedBox(height: 8),
        _buildSwitchField('상단 공지사항 노출', _config.showNotice, textColor, (val) {
          setState(() => _config.showNotice = val);
        }),
        const SizedBox(height: 12),
        _buildTextField('공지 내용 텍스트', _config.noticeText, fieldBgColor, textColor, textSubColor, (val) {
          setState(() => _config.noticeText = val);
        }, maxLines: 3),
      ],
    );
  }

  // --- 5. Input Bar Inspector ---
  Widget _buildInputBarInspector(bool isDark) {
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDark ? Colors.white54 : const Color(0xFF64748B);
    final fieldBgColor = isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF1F5F9);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('하단 입력창 미리보기 텍스트', isDark),
        const SizedBox(height: 8),
        _buildTextField('작성 중인 텍스트 (비우면 기본 힌트 표시)', _config.inputText, fieldBgColor, textColor, textSubColor, (val) {
          setState(() => _config.inputText = val);
        }),
      ],
    );
  }

  // --- 6. Selected Message Inspector ---
  Widget _buildSelectedMessageInspector(bool isDark) {
    final msgId = _selectedObjectId.replaceFirst('msg_', '');
    final msgIndex = _config.messages.indexWhere((m) => m.id == msgId);

    if (msgIndex == -1) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text('선택된 메시지가 존재하지 않습니다.', style: TextStyle(color: isDark ? Colors.white54 : Colors.grey)),
        ),
      );
    }

    final msg = _config.messages[msgIndex];
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDark ? Colors.white54 : const Color(0xFF64748B);
    final fieldBgColor = isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF1F5F9);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('발신자 선택', isDark),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ScaleButton(
                onTap: () {
                  setState(() {
                    msg.isMe = true;
                    msg.senderName = '나';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: msg.isMe
                        ? const Color(0xFF6366F1)
                        : (isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '내가 보냄 (노란색)',
                      style: TextStyle(
                        color: msg.isMe ? Colors.white : textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ScaleButton(
                onTap: () {
                  setState(() {
                    msg.isMe = false;
                    msg.senderName = _config.partnerProfileName;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: !msg.isMe
                        ? const Color(0xFF6366F1)
                        : (isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '상대방이 보냄 (흰색)',
                      style: TextStyle(
                        color: !msg.isMe ? Colors.white : textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        _buildSectionTitle('대화 내용', isDark),
        const SizedBox(height: 8),
        _buildTextField('메시지 텍스트', msg.text, fieldBgColor, textColor, textSubColor, (val) {
          setState(() => msg.text = val);
        }, maxLines: 4),

        const SizedBox(height: 14),

        _buildSectionTitle('발송 시각 & 안읽음 표시', isDark),
        const SizedBox(height: 8),
        _buildTextField('발송 시각 (예: 오후 2:30)', msg.time, fieldBgColor, textColor, textSubColor, (val) {
          setState(() => msg.time = val);
        }),
        _buildSwitchField('‘1’ 안읽음 표시', msg.unreadCount > 0, textColor, (val) {
          setState(() => msg.unreadCount = val ? 1 : 0);
        }),

        const SizedBox(height: 14),

        _buildSectionTitle('메시지 순서 & 관리', isDark),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ScaleButton(
                onTap: msgIndex > 0 ? () => _moveMessage(msgIndex, msgIndex - 1) : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: msgIndex > 0
                        ? (isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0))
                        : (isDark ? Colors.white.withValues(alpha: 0.03) : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.arrow_up, size: 13, color: msgIndex > 0 ? textColor : textSubColor.withValues(alpha: 0.4)),
                      const SizedBox(width: 4),
                      Text(
                        '위로 이동',
                        style: TextStyle(
                          color: msgIndex > 0 ? textColor : textSubColor.withValues(alpha: 0.4),
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ScaleButton(
                onTap: msgIndex < _config.messages.length - 1 ? () => _moveMessage(msgIndex, msgIndex + 1) : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: msgIndex < _config.messages.length - 1
                        ? (isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0))
                        : (isDark ? Colors.white.withValues(alpha: 0.03) : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.arrow_down, size: 13, color: msgIndex < _config.messages.length - 1 ? textColor : textSubColor.withValues(alpha: 0.4)),
                      const SizedBox(width: 4),
                      Text(
                        '아래로 이동',
                        style: TextStyle(
                          color: msgIndex < _config.messages.length - 1 ? textColor : textSubColor.withValues(alpha: 0.4),
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: ScaleButton(
                onTap: () => _duplicateMessage(msg),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.doc_on_doc_fill, size: 13, color: Color(0xFF6366F1)),
                      SizedBox(width: 5),
                      Text(
                        '이 메시지 복제',
                        style: TextStyle(color: Color(0xFF6366F1), fontSize: 11.5, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ScaleButton(
                onTap: () => _deleteMessage(msg.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.trash_fill, size: 13, color: Colors.redAccent),
                      SizedBox(width: 5),
                      Text(
                        '메시지 삭제',
                        style: TextStyle(color: Colors.redAccent, fontSize: 11.5, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- Bottom Quick Add Section ---
  Widget _buildQuickAddMessageSection(Color cardBgColor, bool isDark, Color textColor) {
    final fieldBgColor = isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF1F5F9);
    final textSubColor = isDark ? Colors.white54 : const Color(0xFF64748B);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(CupertinoIcons.paperplane_fill, size: 13, color: Color(0xFF6366F1)),
              const SizedBox(width: 6),
              _buildSectionTitle('새 메시지 즉시 전송', isDark),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('내가 보냄')),
                  selected: _quickMsgIsMe,
                  side: BorderSide.none,
                  selectedColor: const Color(0xFF6366F1),
                  backgroundColor: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0),
                  labelStyle: TextStyle(
                    color: _quickMsgIsMe ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF475569)),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (val) => setState(() => _quickMsgIsMe = true),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('상대방이 보냄')),
                  selected: !_quickMsgIsMe,
                  side: BorderSide.none,
                  selectedColor: const Color(0xFF6366F1),
                  backgroundColor: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0),
                  labelStyle: TextStyle(
                    color: !_quickMsgIsMe ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF475569)),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (val) => setState(() => _quickMsgIsMe = false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('‘1’ 안읽음 표시', style: TextStyle(color: textSubColor, fontSize: 11)),
              const Spacer(),
              CupertinoSwitch(
                value: _quickMsgHasUnread,
                activeTrackColor: const Color(0xFF6366F1),
                onChanged: (val) => setState(() => _quickMsgHasUnread = val),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _quickMsgCtrl,
                  style: TextStyle(color: textColor, fontSize: 12),
                  decoration: InputDecoration(
                    hintText: '대화 내용 입력...',
                    hintStyle: TextStyle(color: textSubColor.withValues(alpha: 0.6), fontSize: 11.5),
                    filled: true,
                    fillColor: fieldBgColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  ),
                  onSubmitted: (_) => _addNewMessage(),
                ),
              ),
              const SizedBox(width: 6),
              ScaleButton(
                onTap: _addNewMessage,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE500),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('전송', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF6366F1),
        fontSize: 11.5,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.2,
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
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: textSubColor, fontSize: 11, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          TextFormField(
            key: ValueKey('field_${label}_$_selectedObjectId'),
            initialValue: initialVal,
            maxLines: maxLines,
            keyboardType: isNumber ? TextInputType.number : (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
            style: TextStyle(color: textColor, fontSize: 12),
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
              Text('${value.toInt()}', style: const TextStyle(color: Color(0xFF6366F1), fontSize: 11.5, fontWeight: FontWeight.bold)),
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
          Text(label, style: TextStyle(color: textColor.withValues(alpha: 0.85), fontSize: 11.5, fontWeight: FontWeight.w500)),
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
