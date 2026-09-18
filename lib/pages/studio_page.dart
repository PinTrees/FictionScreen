import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:screenshot/screenshot.dart';
import '../apps/delivery/data/delivery_model.dart';
import '../apps/delivery/delivery_screen.dart';
import '../apps/instagram/data/instagram_model.dart';
import '../apps/instagram/instagram_screen.dart';
import '../apps/kakaotalk/data/kakaotalk_model.dart';
import '../apps/kakaotalk/kakaotalk_screen.dart';
import '../apps/pinterest/data/pinterest_model.dart';
import '../apps/pinterest/pinterest_screen.dart';
import '../apps/screen_template.dart';
import '../apps/toss/data/toss_model.dart';
import '../apps/toss/toss_screen.dart';
import '../apps/windows_bsod/data/windows_bsod_model.dart';
import '../apps/windows_bsod/windows_bsod_screen.dart';
import '../apps/windows_update/data/windows_update_model.dart';
import '../apps/windows_update/windows_update_screen.dart';
import '../apps/x_twitter/data/x_twitter_model.dart';
import '../apps/x_twitter/x_twitter_screen.dart';
import '../apps/youtube/data/youtube_model.dart';
import '../apps/youtube/youtube_screen.dart';
import '../managers/export_manager.dart';
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
  bool _showAdvancedPanel = false; // 기본은 상세 에디터 패널 비활성화 (실제 앱 뷰 중심)
  bool _isExporting = false;

  // 각 앱별 데이터 Config
  late KakaoRoomConfig _kakaoConfig;
  late TossConfig _tossConfig;
  late XTwitterConfig _twitterConfig;
  late PinterestConfig _pinterestConfig;
  late WindowsBsodConfig _bsodConfig;
  late WindowsUpdateConfig _winUpdateConfig;
  late YoutubeConfig _youtubeConfig;
  late InstagramConfig _instaConfig;
  late DeliveryConfig _deliveryConfig;

  @override
  void initState() {
    super.initState();
    _template = ScreenTemplate.allTemplates.firstWhere(
      (t) => t.id == widget.templateId,
      orElse: () => ScreenTemplate.allTemplates.first,
    );

    _kakaoConfig = KakaoRoomConfig.defaultPreset();
    _tossConfig = TossConfig.defaultPreset();
    _twitterConfig = XTwitterConfig.defaultPreset();
    _pinterestConfig = PinterestConfig.defaultPreset();
    _bsodConfig = WindowsBsodConfig.defaultPreset();
    _winUpdateConfig = WindowsUpdateConfig.defaultPreset();
    _youtubeConfig = YoutubeConfig.defaultPreset();
    _instaConfig = InstagramConfig.defaultPreset();
    _deliveryConfig = DeliveryConfig.defaultPreset();
  }

  Future<void> _exportScreen() async {
    setState(() => _isExporting = true);
    final success = await ExportManager.captureAndDownload(
      controller: _screenshotController,
      filename: '${_template.id}_fiction_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    setState(() => _isExporting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? '이미지가 성공적으로 저장되었습니다!' : '캡처 저장에 실패했습니다.'),
          backgroundColor: success ? const Color(0xFF10B981) : Colors.red,
        ),
      );
    }
  }

  // ==========================================
  // Quick Edit Dialog Helper
  // ==========================================
  void _openQuickEditDialog({
    required String title,
    required List<Widget> children,
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E202C),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(CupertinoIcons.pencil_circle_fill, color: Color(0xFF818CF8), size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 360,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                onConfirm?.call();
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('적용하기', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogInput(String label, TextEditingController controller, {int maxLines = 1, TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: type,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF12141D),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF6366F1)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // App Specific Handlers (Direct Touch Modals)
  // ==========================================
  void _editTossHeader() {
    final nameCtrl = TextEditingController(text: _tossConfig.userName);
    _openQuickEditDialog(
      title: '토스 사용자 정보 수정',
      children: [
        _buildDialogInput('사용자 이름', nameCtrl),
      ],
      onConfirm: () {
        _tossConfig.userName = nameCtrl.text;
      },
    );
  }

  void _editTossSendCard() {
    final msgCtrl = TextEditingController(text: _tossConfig.completionMessage);
    final receiverCtrl = TextEditingController(text: _tossConfig.receiverName);
    final amountCtrl = TextEditingController(text: _tossConfig.sendAmount.toString());
    final timeCtrl = TextEditingController(text: _tossConfig.transactionTime);

    _openQuickEditDialog(
      title: '송금 완료 내역 수정',
      children: [
        _buildDialogInput('송금 완료 메시지', msgCtrl),
        _buildDialogInput('받으시는 분 이름', receiverCtrl),
        _buildDialogInput('보낸 금액 (원)', amountCtrl, type: TextInputType.number),
        _buildDialogInput('거래 일시', timeCtrl),
      ],
      onConfirm: () {
        _tossConfig.completionMessage = msgCtrl.text;
        _tossConfig.receiverName = receiverCtrl.text;
        _tossConfig.sendAmount = int.tryParse(amountCtrl.text) ?? _tossConfig.sendAmount;
        _tossConfig.transactionTime = timeCtrl.text;
      },
    );
  }

  void _editTossBalanceCard() {
    final bankCtrl = TextEditingController(text: _tossConfig.bankName);
    final accCtrl = TextEditingController(text: _tossConfig.accountNumber);
    final balanceCtrl = TextEditingController(text: _tossConfig.balance.toString());

    _openQuickEditDialog(
      title: '계좌 및 잔액 수정',
      children: [
        _buildDialogInput('통장/계좌 이름', bankCtrl),
        _buildDialogInput('계좌번호', accCtrl),
        _buildDialogInput('현재 잔액 (원)', balanceCtrl, type: TextInputType.number),
      ],
      onConfirm: () {
        _tossConfig.bankName = bankCtrl.text;
        _tossConfig.accountNumber = accCtrl.text;
        _tossConfig.balance = int.tryParse(balanceCtrl.text) ?? _tossConfig.balance;
      },
    );
  }

  void _editTossHistoryItem(TossTransaction item) {
    final titleCtrl = TextEditingController(text: item.title);
    final timeCtrl = TextEditingController(text: item.time);
    final amountCtrl = TextEditingController(text: item.amount.toString());

    _openQuickEditDialog(
      title: '거래 내역 항목 수정',
      children: [
        _buildDialogInput('거래처 / 이름', titleCtrl),
        _buildDialogInput('거래 일시', timeCtrl),
        _buildDialogInput('금액 (음수는 차감, 양수는 입금)', amountCtrl, type: TextInputType.number),
      ],
      onConfirm: () {
        item.title = titleCtrl.text;
        item.time = timeCtrl.text;
        item.amount = int.tryParse(amountCtrl.text) ?? item.amount;
      },
    );
  }

  void _editKakaoHeader() {
    final titleCtrl = TextEditingController(text: _kakaoConfig.roomTitle);
    final memberCtrl = TextEditingController(text: _kakaoConfig.memberCount.toString());
    final statusTimeCtrl = TextEditingController(text: _kakaoConfig.statusBarTime);
    final batteryCtrl = TextEditingController(text: _kakaoConfig.batteryLevel.toString());

    _openQuickEditDialog(
      title: '카카오톡 상단바 & 방 정보 수정',
      children: [
        _buildDialogInput('대화방 제목', titleCtrl),
        _buildDialogInput('참여 인원수 (1:1은 0 입력)', memberCtrl, type: TextInputType.number),
        _buildDialogInput('상단바 시각', statusTimeCtrl),
        _buildDialogInput('배터리 잔량 (%)', batteryCtrl, type: TextInputType.number),
      ],
      onConfirm: () {
        _kakaoConfig.roomTitle = titleCtrl.text;
        _kakaoConfig.memberCount = int.tryParse(memberCtrl.text) ?? _kakaoConfig.memberCount;
        _kakaoConfig.statusBarTime = statusTimeCtrl.text;
        _kakaoConfig.batteryLevel = int.tryParse(batteryCtrl.text) ?? _kakaoConfig.batteryLevel;
      },
    );
  }

  void _addOrEditKakaoMessage([KakaoMessage? existingMsg]) {
    final isEdit = existingMsg != null;
    final senderCtrl = TextEditingController(text: isEdit ? existingMsg.senderName : '상대방');
    final textCtrl = TextEditingController(text: isEdit ? existingMsg.text : '');
    final timeCtrl = TextEditingController(text: isEdit ? existingMsg.time : '오후 2:35');
    bool isMe = isEdit ? existingMsg.isMe : false;
    int unread = isEdit ? existingMsg.unreadCount : 1;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E202C),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                isEdit ? '메시지 수정' : '새 메시지 추가',
                style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 360,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          ChoiceChip(
                            label: const Text('상대방 메시지'),
                            selected: !isMe,
                            onSelected: (val) => setDialogState(() => isMe = !val),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('내 메시지'),
                            selected: isMe,
                            onSelected: (val) => setDialogState(() => isMe = val),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (!isMe) _buildDialogInput('발신자 이름', senderCtrl),
                      _buildDialogInput('메시지 내용', textCtrl, maxLines: 3),
                      _buildDialogInput('시각', timeCtrl),
                      Row(
                        children: [
                          const Text('안읽음 표시 (1):', style: TextStyle(color: Colors.white70, fontSize: 13)),
                          const SizedBox(width: 8),
                          Switch(
                            value: unread == 1,
                            onChanged: (val) => setDialogState(() => unread = val ? 1 : 0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                if (isEdit)
                  TextButton(
                    onPressed: () {
                      _kakaoConfig.messages.removeWhere((m) => m.id == existingMsg.id);
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: const Text('삭제', style: TextStyle(color: Colors.redAccent)),
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('취소', style: TextStyle(color: Colors.white54)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
                  onPressed: () {
                    if (isEdit) {
                      existingMsg.senderName = senderCtrl.text;
                      existingMsg.text = textCtrl.text;
                      existingMsg.time = timeCtrl.text;
                      existingMsg.isMe = isMe;
                      existingMsg.unreadCount = unread;
                    } else {
                      _kakaoConfig.messages.add(
                        KakaoMessage(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          senderName: senderCtrl.text,
                          isMe: isMe,
                          text: textCtrl.text,
                          time: timeCtrl.text,
                          unreadCount: unread,
                        ),
                      );
                    }
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('저장', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _editInstagram() {
    final userCtrl = TextEditingController(text: _instaConfig.username);
    final locCtrl = TextEditingController(text: _instaConfig.location);
    final likesCtrl = TextEditingController(text: _instaConfig.likes);
    final captionCtrl = TextEditingController(text: _instaConfig.caption);
    final timeCtrl = TextEditingController(text: _instaConfig.timeAgo);

    _openQuickEditDialog(
      title: '인스타그램 피드 수정',
      children: [
        _buildDialogInput('사용자 ID', userCtrl),
        _buildDialogInput('위치 태그', locCtrl),
        _buildDialogInput('좋아요 수', likesCtrl),
        _buildDialogInput('게시물 캡션 글', captionCtrl, maxLines: 3),
        _buildDialogInput('업로드 시간', timeCtrl),
      ],
      onConfirm: () {
        _instaConfig.username = userCtrl.text;
        _instaConfig.location = locCtrl.text;
        _instaConfig.likes = likesCtrl.text;
        _instaConfig.caption = captionCtrl.text;
        _instaConfig.timeAgo = timeCtrl.text;
      },
    );
  }

  void _editYoutube() {
    final videoIdCtrl = TextEditingController(text: _youtubeConfig.videoId);
    final titleCtrl = TextEditingController(text: _youtubeConfig.videoTitle);
    final channelCtrl = TextEditingController(text: _youtubeConfig.channelName);
    final subCtrl = TextEditingController(text: _youtubeConfig.subscriberCount);
    final viewCtrl = TextEditingController(text: _youtubeConfig.viewCount);
    final timeCtrl = TextEditingController(text: _youtubeConfig.uploadTime);

    _openQuickEditDialog(
      title: '유튜브 영상 및 정보 수정',
      children: [
        _buildDialogInput('유튜브 영상 ID 또는 링크 (IFrame 재생)', videoIdCtrl),
        _buildDialogInput('동영상 제목', titleCtrl, maxLines: 2),
        _buildDialogInput('채널 이름', channelCtrl),
        _buildDialogInput('구독자 수', subCtrl),
        _buildDialogInput('조회수', viewCtrl),
        _buildDialogInput('업로드 일자', timeCtrl),
      ],
      onConfirm: () {
        String vid = videoIdCtrl.text.trim();
        if (vid.contains('v=')) {
          vid = vid.split('v=')[1].split('&')[0];
        } else if (vid.contains('youtu.be/')) {
          vid = vid.split('youtu.be/')[1].split('?')[0];
        } else if (vid.contains('embed/')) {
          vid = vid.split('embed/')[1].split('?')[0];
        }
        _youtubeConfig = _youtubeConfig.copyWith(
          videoId: vid.isNotEmpty ? vid : _youtubeConfig.videoId,
          title: titleCtrl.text,
          channelName: channelCtrl.text,
          subscriberCount: subCtrl.text,
          viewCount: viewCtrl.text,
          uploadTime: timeCtrl.text,
        );
      },
    );
  }

  void _editDelivery() {
    final storeCtrl = TextEditingController(text: _deliveryConfig.storeName);
    final orderNumCtrl = TextEditingController(text: _deliveryConfig.orderNumber);
    final timeCtrl = TextEditingController(text: _deliveryConfig.estimatedTime);
    final menuCtrl = TextEditingController(text: _deliveryConfig.menuSummary);
    final priceCtrl = TextEditingController(text: _deliveryConfig.totalPrice.toString());

    _openQuickEditDialog(
      title: '배달 플랫폼 정보 수정',
      children: [
        _buildDialogInput('가게 이름', storeCtrl),
        _buildDialogInput('주문 번호', orderNumCtrl),
        _buildDialogInput('예상 도착 시간', timeCtrl),
        _buildDialogInput('메뉴 요약', menuCtrl, maxLines: 2),
        _buildDialogInput('총 결제금액 (원)', priceCtrl, type: TextInputType.number),
      ],
      onConfirm: () {
        _deliveryConfig.storeName = storeCtrl.text;
        _deliveryConfig.orderNumber = orderNumCtrl.text;
        _deliveryConfig.estimatedTime = timeCtrl.text;
        _deliveryConfig.menuSummary = menuCtrl.text;
        _deliveryConfig.totalPrice = int.tryParse(priceCtrl.text) ?? _deliveryConfig.totalPrice;
      },
    );
  }

  void _editTwitter() {
    final nameCtrl = TextEditingController(text: _twitterConfig.displayName);
    final userCtrl = TextEditingController(text: _twitterConfig.username);
    final textCtrl = TextEditingController(text: _twitterConfig.tweetText);
    final timeCtrl = TextEditingController(text: _twitterConfig.postTime);
    final viewsCtrl = TextEditingController(text: _twitterConfig.views);
    final likesCtrl = TextEditingController(text: _twitterConfig.likes);

    _openQuickEditDialog(
      title: 'X (트위터) 포스트 수정',
      children: [
        _buildDialogInput('닉네임', nameCtrl),
        _buildDialogInput('아이디 (@handle)', userCtrl),
        _buildDialogInput('포스트 본문', textCtrl, maxLines: 3),
        _buildDialogInput('작성 시간 & 날짜', timeCtrl),
        _buildDialogInput('조회수', viewsCtrl),
        _buildDialogInput('좋아요 수', likesCtrl),
      ],
      onConfirm: () {
        _twitterConfig.displayName = nameCtrl.text;
        _twitterConfig.username = userCtrl.text;
        _twitterConfig.tweetText = textCtrl.text;
        _twitterConfig.postTime = timeCtrl.text;
        _twitterConfig.views = viewsCtrl.text;
        _twitterConfig.likes = likesCtrl.text;
      },
    );
  }

  void _editPinterest() {
    final titleCtrl = TextEditingController(text: _pinterestConfig.pinTitle);
    final creatorCtrl = TextEditingController(text: _pinterestConfig.creatorName);
    final descCtrl = TextEditingController(text: _pinterestConfig.description);
    final savedCtrl = TextEditingController(text: _pinterestConfig.savedCount);

    _openQuickEditDialog(
      title: '핀터레스트 핀 수정',
      children: [
        _buildDialogInput('핀 제목', titleCtrl, maxLines: 2),
        _buildDialogInput('크리에이터 이름', creatorCtrl),
        _buildDialogInput('핀 설명', descCtrl, maxLines: 3),
        _buildDialogInput('저장 수', savedCtrl),
      ],
      onConfirm: () {
        _pinterestConfig.pinTitle = titleCtrl.text;
        _pinterestConfig.creatorName = creatorCtrl.text;
        _pinterestConfig.description = descCtrl.text;
        _pinterestConfig.savedCount = savedCtrl.text;
      },
    );
  }

  void _editBsod() {
    final percentCtrl = TextEditingController(text: _bsodConfig.percentage.toString());
    final stopCodeCtrl = TextEditingController(text: _bsodConfig.stopCode);
    final failedCtrl = TextEditingController(text: _bsodConfig.whatFailed);

    _openQuickEditDialog(
      title: 'Windows BSOD 오류 화면 수정',
      children: [
        _buildDialogInput('진행률 퍼센트 (%)', percentCtrl, type: TextInputType.number),
        _buildDialogInput('중지 코드 (Stop Code)', stopCodeCtrl),
        _buildDialogInput('실패 항목 (whatFailed)', failedCtrl),
      ],
      onConfirm: () {
        _bsodConfig.percentage = int.tryParse(percentCtrl.text) ?? _bsodConfig.percentage;
        _bsodConfig.stopCode = stopCodeCtrl.text;
        _bsodConfig.whatFailed = failedCtrl.text;
      },
    );
  }

  void _editWindowsUpdate() {
    final percentCtrl = TextEditingController(text: _winUpdateConfig.progress.toString());
    final msgCtrl = TextEditingController(text: _winUpdateConfig.primaryMessage);
    final subMsgCtrl = TextEditingController(text: _winUpdateConfig.secondaryMessage);

    _openQuickEditDialog(
      title: 'Windows 가짜 업데이트 수정',
      children: [
        _buildDialogInput('진행률 퍼센트 (%)', percentCtrl, type: TextInputType.number),
        _buildDialogInput('주요 안내 문구', msgCtrl),
        _buildDialogInput('보조 안내 문구', subMsgCtrl, maxLines: 3),
      ],
      onConfirm: () {
        _winUpdateConfig.progress = int.tryParse(percentCtrl.text) ?? _winUpdateConfig.progress;
        _winUpdateConfig.primaryMessage = msgCtrl.text;
        _winUpdateConfig.secondaryMessage = subMsgCtrl.text;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C10),
      body: SafeArea(
        child: Column(
          children: [
            // 1. 상단 미니 컨트롤 오버레이 바
            _buildTopOverlayBar(),

            // 2. 메인 프론트엔드 뷰 영역 (실제 앱 뷰)
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      child: Screenshot(
                        controller: _screenshotController,
                        child: _showFrame
                            ? DeviceFramePreview(
                                isDesktop: _template.isDesktop,
                                child: _buildInteractiveAppScreen(),
                              )
                            : Container(
                                constraints: BoxConstraints(
                                  maxWidth: _template.isDesktop ? 960 : 400,
                                  maxHeight: _template.isDesktop ? 600 : 780,
                                ),
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(_template.isDesktop ? 12 : 32),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.5),
                                      blurRadius: 30,
                                    ),
                                  ],
                                ),
                                child: _buildInteractiveAppScreen(),
                              ),
                      ),
                    ),
                  ),

                  // 오른쪽 슬라이딩 보조 에디터 패널 (옵션)
                  if (_showAdvancedPanel)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      width: 340,
                      child: _buildAdvancedInspectorPanel(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // Top Overlay Bar
  // ==========================================
  Widget _buildTopOverlayBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF12141D),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(CupertinoIcons.arrow_left, color: Colors.white, size: 20),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/console');
              }
            },
          ),
          const SizedBox(width: 8),
          Icon(_template.icon, color: _template.themeColor, size: 18),
          const SizedBox(width: 8),
          Text(
            _template.title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(width: 12),

          // 💡 안내 뱃지
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.hand_point_right_fill, color: Color(0xFFA5B4FC), size: 13),
                    SizedBox(width: 6),
                    Text(
                      '화면의 텍스트나 항목을 터치하면 바로 수정할 수 있습니다',
                      style: TextStyle(color: Color(0xFFA5B4FC), fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          if (_template.id == 'youtube')
            IconButton(
              tooltip: '유튜브 영상/정보 변경',
              icon: const Icon(CupertinoIcons.play_circle_fill, color: Color(0xFFFF3333), size: 22),
              onPressed: _editYoutube,
            ),

          // 디바이스 프레임 토글
          IconButton(
            tooltip: '디바이스 프레임 토글',
            icon: Icon(
              _showFrame ? CupertinoIcons.device_phone_portrait : CupertinoIcons.square,
              color: Colors.white70,
              size: 20,
            ),
            onPressed: () => setState(() => _showFrame = !_showFrame),
          ),

          // 상세 에디터 패널 토글
          IconButton(
            tooltip: '상세 에디터 패널',
            icon: Icon(
              CupertinoIcons.slider_horizontal_3,
              color: _showAdvancedPanel ? const Color(0xFF818CF8) : Colors.white70,
              size: 20,
            ),
            onPressed: () => setState(() => _showAdvancedPanel = !_showAdvancedPanel),
          ),

          const SizedBox(width: 8),

          // 내보내기 버튼
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: _isExporting ? null : _exportScreen,
            child: _isExporting
                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.arrow_down_doc_fill, size: 14),
                      SizedBox(width: 6),
                      Text('PNG 캡처 저장', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Render Interactive Front-End App Screen
  // ==========================================
  Widget _buildInteractiveAppScreen() {
    switch (_template.id) {
      case 'toss':
        return TossScreen(
          config: _tossConfig,
          onTapHeader: _editTossHeader,
          onTapSendCard: _editTossSendCard,
          onTapBalance: _editTossBalanceCard,
          onTapHistoryItem: _editTossHistoryItem,
        );
      case 'x_twitter':
        return GestureDetector(
          onTap: _editTwitter,
          child: XTwitterScreen(config: _twitterConfig),
        );
      case 'pinterest':
        return GestureDetector(
          onTap: _editPinterest,
          child: PinterestScreen(config: _pinterestConfig),
        );
      case 'kakaotalk':
        return GestureDetector(
          onTap: _editKakaoHeader,
          child: KakaoTalkScreen(
            config: _kakaoConfig,
          ),
        );
      case 'instagram':
        return GestureDetector(
          onTap: _editInstagram,
          child: InstagramScreen(config: _instaConfig),
        );
      case 'youtube':
        return YoutubeScreen(
          config: _youtubeConfig,
          onConfigChanged: (cfg) => setState(() => _youtubeConfig = cfg),
        );
      case 'delivery':
        return GestureDetector(
          onTap: _editDelivery,
          child: DeliveryScreen(config: _deliveryConfig),
        );
      case 'windows_bsod':
        return GestureDetector(
          onTap: _editBsod,
          child: WindowsBsodScreen(config: _bsodConfig),
        );
      case 'windows_update':
        return GestureDetector(
          onTap: _editWindowsUpdate,
          child: WindowsUpdateScreen(config: _winUpdateConfig),
        );
      default:
        return TossScreen(config: _tossConfig);
    }
  }

  // ==========================================
  // Optional Advanced Inspector Panel (Drawer)
  // ==========================================
  Widget _buildAdvancedInspectorPanel() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF12141D),
        border: Border(left: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
            ),
            child: Row(
              children: [
                const Text('상세 에디터 패널', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const Spacer(),
                IconButton(
                  icon: const Icon(CupertinoIcons.xmark, color: Colors.white70, size: 16),
                  onPressed: () => setState(() => _showAdvancedPanel = false),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(CupertinoIcons.pencil, size: 16),
                  label: const Text('항목 전체 편집 다이얼로그 열기', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () {
                    switch (_template.id) {
                      case 'toss':
                        _editTossSendCard();
                        break;
                      case 'kakaotalk':
                        _editKakaoHeader();
                        break;
                      case 'instagram':
                        _editInstagram();
                        break;
                      case 'youtube':
                        _editYoutube();
                        break;
                      case 'delivery':
                        _editDelivery();
                        break;
                      case 'windows_bsod':
                        _editBsod();
                        break;
                    }
                  },
                ),
                const SizedBox(height: 16),
                if (_template.id == 'kakaotalk') ...[
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 40),
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                    icon: const Icon(CupertinoIcons.plus, size: 16),
                    label: const Text('새 카카오톡 메시지 추가'),
                    onPressed: () => _addOrEditKakaoMessage(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
