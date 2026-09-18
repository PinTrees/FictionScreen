import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import '../managers/export_manager.dart';
import '../models/delivery_model.dart';
import '../models/instagram_model.dart';
import '../models/kakaotalk_model.dart';
import '../models/screen_template.dart';
import '../models/windows_bsod_model.dart';
import '../models/youtube_model.dart';
import '../style/app_colors.dart';
import '../templates/lifestyle/delivery_screen.dart';
import '../templates/messenger/kakaotalk_screen.dart';
import '../templates/os/windows_bsod_screen.dart';
import '../templates/sns/instagram_screen.dart';
import '../templates/sns/youtube_screen.dart';
import '../widgets/common/device_frame_preview.dart';

class StudioPage extends StatefulWidget {
  final String templateId;

  const StudioPage({super.key, required this.templateId});

  @override
  State<StudioPage> createState() => _StudioPageState();
}

class _StudioPageState extends State<StudioPage> {
  final ScreenshotController _screenshotController = ScreenshotController();

  late ScreenTemplate _template;
  bool _showFrame = true;
  double _previewScale = 0.95;
  bool _isExporting = false;

  // 템플릿별 상태값들
  late KakaoRoomConfig _kakaoConfig;
  late WindowsBsodConfig _bsodConfig;
  late YoutubeConfig _youtubeConfig;
  late InstagramConfig _instaConfig;
  late DeliveryConfig _deliveryConfig;

  // 애니메이션 관련
  bool _isKakaoAnimated = false;
  int _bsodAnimatedPercent = 67;
  Timer? _bsodTimer;

  // 새 메시지 입력용 컨트롤러 (카톡)
  final TextEditingController _msgInputController = TextEditingController();
  bool _msgIsMe = true;
  int _msgUnread = 1;

  @override
  void initState() {
    super.initState();
    _template = ScreenTemplate.allTemplates.firstWhere(
      (t) => t.id == widget.templateId,
      orElse: () => ScreenTemplate.allTemplates.first,
    );

    _kakaoConfig = KakaoRoomConfig.defaultPreset();
    _bsodConfig = WindowsBsodConfig.defaultPreset();
    _youtubeConfig = YoutubeConfig.defaultPreset();
    _instaConfig = InstagramConfig.defaultPreset();
    _deliveryConfig = DeliveryConfig.defaultPreset();
    _bsodAnimatedPercent = _bsodConfig.percentage;

    if (_template.isDesktop) {
      _previewScale = 0.85;
    }
  }

  @override
  void dispose() {
    _bsodTimer?.cancel();
    _msgInputController.dispose();
    super.dispose();
  }

  void _triggerBsodAnimation() {
    _bsodTimer?.cancel();
    setState(() {
      _bsodAnimatedPercent = 0;
    });

    _bsodTimer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      if (_bsodAnimatedPercent >= 100) {
        timer.cancel();
      } else {
        setState(() {
          _bsodAnimatedPercent += 2;
          if (_bsodAnimatedPercent > 100) _bsodAnimatedPercent = 100;
        });
      }
    });
  }

  void _triggerKakaoAnimation() {
    setState(() {
      _isKakaoAnimated = false;
    });
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        _isKakaoAnimated = true;
      });
    });
  }

  Future<void> _exportScreen() async {
    setState(() => _isExporting = true);
    final success = await ExportManager.captureAndDownload(
      controller: _screenshotController,
      filename: '${_template.id}_mock_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    setState(() => _isExporting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? '이미지가 성공적으로 저장되었습니다!' : '캡처 저장에 실패했습니다.'),
          backgroundColor: success ? AppColors.success : AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(_template.icon, color: _template.themeColor, size: 20),
            const SizedBox(width: 8),
            Text(_template.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          ],
        ),
        actions: [
          // 프레임 토글
          IconButton(
            tooltip: _showFrame ? '프레임 숨기기 (화면만)' : '기기 프레임 씌우기',
            icon: Icon(_showFrame ? CupertinoIcons.device_phone_portrait : CupertinoIcons.viewfinder),
            onPressed: () => setState(() => _showFrame = !_showFrame),
          ),
          const SizedBox(width: 4),

          // 캡처 다운로드 버튼
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: _isExporting
                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(CupertinoIcons.arrow_down_doc_fill, size: 18),
              label: const Text('PNG 캡처 저장', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: _isExporting ? null : _exportScreen,
            ),
          ),
        ],
      ),
      body: isWide ? _buildWideLayout() : _buildCompactLayout(),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        // 왼쪽: 에디터 툴패널
        SizedBox(
          width: 380,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(right: BorderSide(color: AppColors.border)),
            ),
            child: _buildEditorPanel(),
          ),
        ),

        // 오른쪽: 실시간 프리뷰 영역
        Expanded(
          child: Container(
            color: AppColors.background,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPreviewControls(),
                    const SizedBox(height: 16),
                    Screenshot(
                      controller: _screenshotController,
                      child: DeviceFramePreview(
                        showFrame: _showFrame,
                        isDesktop: _template.isDesktop,
                        scale: _previewScale,
                        child: _renderCurrentScreen(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactLayout() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primaryLight,
            unselectedLabelColor: AppColors.textMuted,
            tabs: [
              Tab(icon: Icon(CupertinoIcons.eye_fill), text: '실시간 프리뷰'),
              Tab(icon: Icon(CupertinoIcons.pencil_ellipsis_rectangle), text: '화면 편집하기'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // 프리뷰 탭
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildPreviewControls(),
                      const SizedBox(height: 12),
                      Screenshot(
                        controller: _screenshotController,
                        child: DeviceFramePreview(
                          showFrame: _showFrame,
                          isDesktop: _template.isDesktop,
                          scale: _previewScale * 0.9,
                          child: _renderCurrentScreen(),
                        ),
                      ),
                    ],
                  ),
                ),
                // 에디터 탭
                _buildEditorPanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_template.id == 'kakaotalk') ...[
            TextButton.icon(
              icon: const Icon(CupertinoIcons.play_arrow_solid, color: AppColors.kakaoYellow, size: 18),
              label: const Text('대화 애니메이션', style: TextStyle(color: Colors.white, fontSize: 12)),
              onPressed: _triggerKakaoAnimation,
            ),
            const SizedBox(width: 8),
          ],
          if (_template.id == 'windows_bsod') ...[
            TextButton.icon(
              icon: const Icon(CupertinoIcons.arrow_counterclockwise, color: AppColors.accent, size: 18),
              label: const Text('% 카운트 시뮬레이션', style: TextStyle(color: Colors.white, fontSize: 12)),
              onPressed: _triggerBsodAnimation,
            ),
            const SizedBox(width: 8),
          ],
          const Text('배율:', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(width: 6),
          DropdownButton<double>(
            value: _previewScale,
            dropdownColor: AppColors.surfaceLight,
            underline: const SizedBox(),
            isDense: true,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            items: const [
              DropdownMenuItem(value: 0.75, child: Text('75%')),
              DropdownMenuItem(value: 0.85, child: Text('85%')),
              DropdownMenuItem(value: 0.95, child: Text('95%')),
              DropdownMenuItem(value: 1.0, child: Text('100%')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _previewScale = val);
            },
          ),
        ],
      ),
    );
  }

  Widget _renderCurrentScreen() {
    switch (_template.id) {
      case 'kakaotalk':
        return KakaoTalkScreen(
          config: _kakaoConfig,
          isAnimated: _isKakaoAnimated,
        );
      case 'windows_bsod':
        return WindowsBsodScreen(
          config: _bsodConfig,
          currentPercentage: _bsodAnimatedPercent,
        );
      case 'youtube':
        return YoutubeScreen(config: _youtubeConfig);
      case 'instagram':
        return InstagramScreen(config: _instaConfig);
      case 'delivery':
        return DeliveryScreen(config: _deliveryConfig);
      default:
        return KakaoTalkScreen(config: _kakaoConfig);
    }
  }

  Widget _buildEditorPanel() {
    switch (_template.id) {
      case 'kakaotalk':
        return _buildKakaoEditor();
      case 'windows_bsod':
        return _buildBsodEditor();
      case 'youtube':
        return _buildYoutubeEditor();
      case 'instagram':
        return _buildInstaEditor();
      case 'delivery':
        return _buildDeliveryEditor();
      default:
        return const Center(child: Text('에디터 준비 중'));
    }
  }

  // ========== 1. 카카오톡 에디터 ==========
  Widget _buildKakaoEditor() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('기본 설정', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: _kakaoConfig.roomTitle,
          decoration: const InputDecoration(labelText: '채팅방 / 상대방 이름'),
          onChanged: (v) => setState(() => _kakaoConfig.roomTitle = v),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: _kakaoConfig.statusBarTime,
                decoration: const InputDecoration(labelText: '상단바 시간'),
                onChanged: (v) => setState(() => _kakaoConfig.statusBarTime = v),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                initialValue: '${_kakaoConfig.batteryLevel}',
                decoration: const InputDecoration(labelText: '배터리 (%)'),
                keyboardType: TextInputType.number,
                onChanged: (v) {
                  final n = int.tryParse(v);
                  if (n != null) setState(() => _kakaoConfig.batteryLevel = n);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('다크 테마 모드', style: TextStyle(fontSize: 14)),
          value: _kakaoConfig.isDarkTheme,
          onChanged: (val) => setState(() => _kakaoConfig.isDarkTheme = val),
        ),
        const Divider(height: 28),

        // 메시지 추가하기 폼
        const Text('새 메시지 추가', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 10),
        Row(
          children: [
            ChoiceChip(
              label: const Text('나 (노랑)'),
              selected: _msgIsMe,
              selectedColor: AppColors.primary,
              onSelected: (val) => setState(() => _msgIsMe = true),
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('상대방 (흰색)'),
              selected: !_msgIsMe,
              selectedColor: AppColors.primary,
              onSelected: (val) => setState(() => _msgIsMe = false),
            ),
            const Spacer(),
            Row(
              children: [
                const Text('1 표시:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                Checkbox(
                  value: _msgUnread == 1,
                  onChanged: (val) => setState(() => _msgUnread = (val == true) ? 1 : 0),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _msgInputController,
          decoration: InputDecoration(
            hintText: '메시지 내용을 입력하세요',
            suffixIcon: IconButton(
              icon: const Icon(CupertinoIcons.paperplane_fill, color: AppColors.primary),
              onPressed: () {
                if (_msgInputController.text.trim().isEmpty) return;
                setState(() {
                  _kakaoConfig.messages.add(
                    KakaoMessage(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      senderName: _kakaoConfig.roomTitle,
                      isMe: _msgIsMe,
                      text: _msgInputController.text.trim(),
                      time: _kakaoConfig.statusBarTime,
                      unreadCount: _msgUnread,
                    ),
                  );
                  _msgInputController.clear();
                });
              },
            ),
          ),
          onSubmitted: (_) {
            if (_msgInputController.text.trim().isEmpty) return;
            setState(() {
              _kakaoConfig.messages.add(
                KakaoMessage(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  senderName: _kakaoConfig.roomTitle,
                  isMe: _msgIsMe,
                  text: _msgInputController.text.trim(),
                  time: _kakaoConfig.statusBarTime,
                  unreadCount: _msgUnread,
                ),
              );
              _msgInputController.clear();
            });
          },
        ),
        const SizedBox(height: 18),

        // 메시지 리스트 관리
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('대화 목록 (${_kakaoConfig.messages.length}개)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            TextButton(
              onPressed: () => setState(() => _kakaoConfig.messages.clear()),
              child: const Text('전체 삭제', style: TextStyle(color: AppColors.danger, fontSize: 12)),
            ),
          ],
        ),
        ..._kakaoConfig.messages.asMap().entries.map((entry) {
          final idx = entry.key;
          final msg = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: AppColors.surfaceLight,
            child: ListTile(
              dense: true,
              leading: CircleAvatar(
                radius: 12,
                backgroundColor: msg.isMe ? AppColors.kakaoYellow : Colors.grey.shade400,
                child: Text(
                  msg.isMe ? '나' : '상',
                  style: const TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(msg.text, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
              subtitle: Text('${msg.time} · 1 표시: ${msg.unreadCount > 0 ? "O" : "X"}', style: const TextStyle(fontSize: 11)),
              trailing: IconButton(
                icon: const Icon(CupertinoIcons.xmark, size: 14, color: AppColors.textMuted),
                onPressed: () => setState(() => _kakaoConfig.messages.removeAt(idx)),
              ),
            ),
          );
        }),
      ],
    );
  }

  // ========== 2. 윈도우 블루스크린 에디터 ==========
  Widget _buildBsodEditor() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('블루스크린 설정', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: _bsodConfig.stopCode,
          decoration: const InputDecoration(labelText: '중지 코드 (Stop Code)'),
          onChanged: (v) => setState(() => _bsodConfig.stopCode = v),
        ),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: _bsodConfig.whatFailed,
          decoration: const InputDecoration(labelText: '실패한 내용 (선택, 예: nvlddmkm.sys)'),
          onChanged: (v) => setState(() => _bsodConfig.whatFailed = v),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: '${_bsodConfig.percentage}',
                decoration: const InputDecoration(labelText: '완료 퍼센트 (%)'),
                keyboardType: TextInputType.number,
                onChanged: (v) {
                  final n = int.tryParse(v);
                  if (n != null) {
                    setState(() {
                      _bsodConfig.percentage = n;
                      _bsodAnimatedPercent = n;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.windowsBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: const Icon(CupertinoIcons.play_circle_fill),
          label: const Text('실시간 카운트업 시뮬레이션 시작'),
          onPressed: _triggerBsodAnimation,
        ),
      ],
    );
  }

  // ========== 3. 유튜브 에디터 ==========
  Widget _buildYoutubeEditor() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('유튜브 영상 정보', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: _youtubeConfig.title,
          decoration: const InputDecoration(labelText: '영상 제목'),
          onChanged: (v) => setState(() => _youtubeConfig.title = v),
        ),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: _youtubeConfig.channelName,
          decoration: const InputDecoration(labelText: '채널명'),
          onChanged: (v) => setState(() => _youtubeConfig.channelName = v),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: _youtubeConfig.viewCount,
                decoration: const InputDecoration(labelText: '조회수'),
                onChanged: (v) => setState(() => _youtubeConfig.viewCount = v),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                initialValue: _youtubeConfig.uploadTime,
                decoration: const InputDecoration(labelText: '게시일 (예: 3일 전)'),
                onChanged: (v) => setState(() => _youtubeConfig.uploadTime = v),
              ),
            ),
          ],
        ),
        const Divider(height: 28),
        const Text('베스트 댓글', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 10),
        ..._youtubeConfig.comments.map((c) {
          return Card(
            color: AppColors.surfaceLight,
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: c.author,
                    decoration: const InputDecoration(labelText: '댓글 작성자 닉네임', isDense: true),
                    onChanged: (v) => setState(() => c.author = v),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    initialValue: c.text,
                    decoration: const InputDecoration(labelText: '댓글 내용', isDense: true),
                    onChanged: (v) => setState(() => c.text = v),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ========== 4. 인스타그램 에디터 ==========
  Widget _buildInstaEditor() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('인스타그램 게시물 정보', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: _instaConfig.username,
          decoration: const InputDecoration(labelText: '계정 아이디'),
          onChanged: (v) => setState(() => _instaConfig.username = v),
        ),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: _instaConfig.location,
          decoration: const InputDecoration(labelText: '위치 정보'),
          onChanged: (v) => setState(() => _instaConfig.location = v),
        ),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: _instaConfig.likes,
          decoration: const InputDecoration(labelText: '좋아요 수 (예: 1,420)'),
          onChanged: (v) => setState(() => _instaConfig.likes = v),
        ),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: _instaConfig.caption,
          decoration: const InputDecoration(labelText: '본문 캡션 내용'),
          maxLines: 3,
          onChanged: (v) => setState(() => _instaConfig.caption = v),
        ),
      ],
    );
  }

  // ========== 5. 배달 플랫폼 에디터 ==========
  Widget _buildDeliveryEditor() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('배달 주문 정보', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: _deliveryConfig.storeName,
          decoration: const InputDecoration(labelText: '가게 상호명'),
          onChanged: (v) => setState(() => _deliveryConfig.storeName = v),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<DeliveryStatus>(
          initialValue: _deliveryConfig.status,
          decoration: const InputDecoration(labelText: '배달 진행 단계'),
          dropdownColor: AppColors.surfaceLight,
          items: DeliveryStatus.values.map((s) {
            return DropdownMenuItem(value: s, child: Text(s.title));
          }).toList(),
          onChanged: (val) {
            if (val != null) setState(() => _deliveryConfig.status = val);
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: _deliveryConfig.estimatedTime,
          decoration: const InputDecoration(labelText: '예상 시간 (예: 15~25분 후 도착 예정)'),
          onChanged: (v) => setState(() => _deliveryConfig.estimatedTime = v),
        ),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: _deliveryConfig.menuSummary,
          decoration: const InputDecoration(labelText: '주문 메뉴 요약'),
          onChanged: (v) => setState(() => _deliveryConfig.menuSummary = v),
        ),
      ],
    );
  }
}
