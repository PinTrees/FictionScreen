import 'dart:async';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import '../apps/coupang/data/coupang_model.dart';
import '../apps/daangn/data/daangn_model.dart';
import '../apps/delivery/data/delivery_model.dart';
import '../apps/instagram/data/instagram_model.dart';
import '../apps/kakaotalk/data/kakaotalk_model.dart';
import '../apps/lottery/data/lottery_model.dart';
import '../apps/netflix/data/netflix_model.dart';
import '../apps/pinterest/data/pinterest_model.dart';
import '../apps/screen_template.dart';
import '../apps/toss/data/toss_model.dart';
import '../apps/windows_bsod/data/windows_bsod_model.dart';
import '../apps/windows_update/data/windows_update_model.dart';
import '../apps/x_twitter/data/x_twitter_model.dart';
import '../apps/youtube/data/youtube_model.dart';
import '../managers/export_manager.dart';
import '../widgets/common/device_frame_preview.dart';
import 'studio/dialogs/studio_quick_dialogs.dart';
import 'studio/widgets/studio_advanced_panel.dart';
import 'studio/widgets/studio_preview_dispatcher.dart';
import 'studio/widgets/studio_top_bar.dart';

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
  bool _showAdvancedPanel = false;
  bool _isExporting = false;

  late KakaoRoomConfig _kakaoConfig;
  late TossConfig _tossConfig;
  late XTwitterConfig _twitterConfig;
  late PinterestConfig _pinterestConfig;
  late WindowsBsodConfig _bsodConfig;
  late WindowsUpdateConfig _winUpdateConfig;
  late YoutubeConfig _youtubeConfig;
  late InstagramConfig _instaConfig;
  late DeliveryConfig _deliveryConfig;
  late DaangnConfig _daangnConfig;
  late CoupangConfig _coupangConfig;
  late NetflixConfig _netflixConfig;
  late LotteryConfig _lotteryConfig;

  @override
  void initState() {
    super.initState();
    _template = ScreenTemplate.allTemplates.firstWhere((t) => t.id == widget.templateId, orElse: () => ScreenTemplate.allTemplates.first);
    _kakaoConfig = KakaoRoomConfig.defaultPreset();
    _tossConfig = TossConfig.defaultPreset();
    _twitterConfig = XTwitterConfig.defaultPreset();
    _pinterestConfig = PinterestConfig.defaultPreset();
    _bsodConfig = WindowsBsodConfig.defaultPreset();
    _winUpdateConfig = WindowsUpdateConfig.defaultPreset();
    _youtubeConfig = YoutubeConfig.defaultPreset();
    _instaConfig = InstagramConfig.defaultPreset();
    _deliveryConfig = DeliveryConfig.defaultPreset();
    _daangnConfig = DaangnConfig.defaultPreset();
    _coupangConfig = CoupangConfig.defaultPreset();
    _netflixConfig = NetflixConfig.defaultPreset();
    _lotteryConfig = LotteryConfig.defaultPreset();
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

  void _openAdvancedDialog() {
    switch (_template.id) {
      case 'toss': StudioQuickDialogs.editTossSendCard(context, _tossConfig, () => setState(() {})); break;
      case 'kakaotalk': StudioQuickDialogs.editKakaoHeader(context, _kakaoConfig, () => setState(() {})); break;
      case 'instagram': StudioQuickDialogs.editInstagram(context, _instaConfig, () => setState(() {})); break;
      case 'youtube': StudioQuickDialogs.editYoutube(context, _youtubeConfig, (cfg) => setState(() => _youtubeConfig = cfg)); break;
      case 'delivery': StudioQuickDialogs.editDelivery(context, _deliveryConfig, () => setState(() {})); break;
      case 'daangn': StudioQuickDialogs.editDaangn(context, _daangnConfig, () => setState(() {})); break;
      case 'windows_bsod': StudioQuickDialogs.editBsod(context, _bsodConfig, () => setState(() {})); break;
      case 'windows_update': StudioQuickDialogs.editWindowsUpdate(context, _winUpdateConfig, () => setState(() {})); break;
      case 'coupang': StudioQuickDialogs.editCoupang(context, _coupangConfig, (cfg) => setState(() => _coupangConfig = cfg)); break;
      case 'netflix': StudioQuickDialogs.editNetflix(context, _netflixConfig, (cfg) => setState(() => _netflixConfig = cfg)); break;
      case 'pinterest': StudioQuickDialogs.editPinterest(context, _pinterestConfig, () => setState(() {})); break;
      case 'x_twitter': StudioQuickDialogs.editTwitter(context, _twitterConfig, () => setState(() {})); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C10),
      body: SafeArea(
        child: Column(
          children: [
            StudioTopBar(
              template: _template,
              showFrame: _showFrame,
              isExporting: _isExporting,
              onToggleFrame: () => setState(() => _showFrame = !_showFrame),
              onExport: _exportScreen,
              onEditYoutube: _template.id == 'youtube' ? () => StudioQuickDialogs.editYoutube(context, _youtubeConfig, (cfg) => setState(() => _youtubeConfig = cfg)) : null,
            ),
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      child: Screenshot(
                        controller: _screenshotController,
                        child: _showFrame
                            ? DeviceFramePreview(isDesktop: _template.isDesktop, child: _buildPreview())
                            : Container(
                                constraints: BoxConstraints(maxWidth: _template.isDesktop ? 960 : 400, maxHeight: _template.isDesktop ? 600 : 780),
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(_template.isDesktop ? 12 : 32),
                                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 30)],
                                ),
                                child: _buildPreview(),
                              ),
                      ),
                    ),
                  ),
                  if (_showAdvancedPanel)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      width: 340,
                      child: StudioAdvancedPanel(
                        templateId: _template.id,
                        onClose: () => setState(() => _showAdvancedPanel = false),
                        onOpenEditDialog: _openAdvancedDialog,
                        onAddKakaoMessage: () => StudioQuickDialogs.addOrEditKakaoMessage(context, _kakaoConfig, () => setState(() {})),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return StudioPreviewDispatcher(
      templateId: _template.id,
      tossConfig: _tossConfig,
      kakaoConfig: _kakaoConfig,
      twitterConfig: _twitterConfig,
      pinterestConfig: _pinterestConfig,
      instaConfig: _instaConfig,
      youtubeConfig: _youtubeConfig,
      deliveryConfig: _deliveryConfig,
      daangnConfig: _daangnConfig,
      bsodConfig: _bsodConfig,
      winUpdateConfig: _winUpdateConfig,
      coupangConfig: _coupangConfig,
      netflixConfig: _netflixConfig,
      lotteryConfig: _lotteryConfig,
      onTapTossHeader: () => StudioQuickDialogs.editTossHeader(context, _tossConfig, () => setState(() {})),
      onTapTossSendCard: () => StudioQuickDialogs.editTossSendCard(context, _tossConfig, () => setState(() {})),
      onTapTossBalance: () => StudioQuickDialogs.editTossBalanceCard(context, _tossConfig, () => setState(() {})),
      onTapTossHistoryItem: (it) => StudioQuickDialogs.editTossHistoryItem(context, it, () => setState(() {})),
      onTapKakaoHeader: () => StudioQuickDialogs.editKakaoHeader(context, _kakaoConfig, () => setState(() {})),
      onTapTwitter: () => StudioQuickDialogs.editTwitter(context, _twitterConfig, () => setState(() {})),
      onTapPinterest: () => StudioQuickDialogs.editPinterest(context, _pinterestConfig, () => setState(() {})),
      onTapInstagram: () => StudioQuickDialogs.editInstagram(context, _instaConfig, () => setState(() {})),
      onTapDelivery: () => StudioQuickDialogs.editDelivery(context, _deliveryConfig, () => setState(() {})),
      onTapDaangn: () => StudioQuickDialogs.editDaangn(context, _daangnConfig, () => setState(() {})),
      onTapBsod: () => StudioQuickDialogs.editBsod(context, _bsodConfig, () => setState(() {})),
      onTapWindowsUpdate: () => StudioQuickDialogs.editWindowsUpdate(context, _winUpdateConfig, () => setState(() {})),
      onYoutubeChanged: (cfg) => setState(() => _youtubeConfig = cfg),
      onCoupangChanged: (cfg) => setState(() => _coupangConfig = cfg),
      onNetflixChanged: (cfg) => setState(() => _netflixConfig = cfg),
      onLotteryChanged: (cfg) => setState(() => _lotteryConfig = cfg),
    );
  }
}
