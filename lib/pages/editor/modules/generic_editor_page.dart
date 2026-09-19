import 'package:flutter/material.dart';
import '../../../../apps/blind/data/blind_model.dart';
import '../../../../apps/cctv/data/cctv_model.dart';
import '../../../../apps/chrome/data/chrome_model.dart';
import '../../../../apps/coupang/data/coupang_model.dart';
import '../../../../apps/daangn/data/daangn_model.dart';
import '../../../../apps/davinci_resolve/data/davinci_resolve_model.dart';
import '../../../../apps/dcinside/data/dcinside_model.dart';
import '../../../../apps/delivery/data/delivery_model.dart';
import '../../../../apps/discord/data/discord_model.dart';
import '../../../../apps/edge/data/edge_model.dart';
import '../../../../apps/excel/data/excel_model.dart';
import '../../../../apps/instagram/data/instagram_model.dart';
import '../../../../apps/kakaobank/data/kakaobank_model.dart';
import '../../../../apps/kakaotalk/data/kakaotalk_model.dart';
import '../../../../apps/lottery/data/lottery_model.dart';
import '../../../../apps/naver/data/naver_model.dart';
import '../../../../apps/netflix/data/netflix_model.dart';
import '../../../../apps/news/data/news_model.dart';
import '../../../../apps/photoshop/data/photoshop_model.dart';
import '../../../../apps/pinterest/data/pinterest_model.dart';
import '../../../../apps/powerpoint/data/powerpoint_model.dart';
import '../../../../apps/screen_template.dart';
import '../../../../apps/steam/data/steam_model.dart';
import '../../../../apps/telegram/data/telegram_model.dart';
import '../../../../apps/toss/data/toss_model.dart';
import '../../../../apps/upbit/data/upbit_model.dart';
import '../../../../apps/visual_studio/data/visual_studio_model.dart';
import '../../../../apps/windows_bsod/data/windows_bsod_model.dart';
import '../../../../apps/windows_update/data/windows_update_model.dart';
import '../../../../apps/word/data/word_model.dart';
import '../../../../apps/x_twitter/data/x_twitter_model.dart';
import '../../../../apps/yanolja/data/yanolja_model.dart';
import '../../../../apps/zigbang/data/zigbang_model.dart';
import '../../../../apps/youtube/data/youtube_model.dart';
import '../../console/workspace/widgets/workspace_editor_inspector.dart';
import '../../studio/widgets/studio_preview_dispatcher.dart';
import '../core/app_editor_shell.dart';

/// 범용 피그마 스타일 전체화면 앱 에디터 페이지 (기타 모든 32개 앱 지원)
class GenericEditorPage extends StatefulWidget {
  final String templateId;
  final VoidCallback onBackToGallery;
  final Function(String osKey) onOpenInOs;

  const GenericEditorPage({
    super.key,
    required this.templateId,
    required this.onBackToGallery,
    required this.onOpenInOs,
  });

  @override
  State<GenericEditorPage> createState() => _GenericEditorPageState();
}

class _GenericEditorPageState extends State<GenericEditorPage> {
  late KakaoBankConfig _kakaobankConfig;
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
  late YanoljaConfig _yanoljaConfig;
  late UpbitConfig _upbitConfig;
  late BlindConfig _blindConfig;
  late DiscordConfig _discordConfig;
  late PhotoshopConfig _photoshopConfig;
  late VisualStudioConfig _visualStudioConfig;
  late ChromeConfig _chromeConfig;
  late DavinciConfig _davinciConfig;
  late TelegramConfig _telegramConfig;
  late ZigbangConfig _zigbangConfig;
  late NaverConfig _naverConfig;
  late EdgeConfig _edgeConfig;
  late CctvConfig _cctvConfig;
  late SteamConfig _steamConfig;
  late NewsConfig _newsConfig;
  late DcinsideConfig _dcinsideConfig;
  late ExcelConfig _excelConfig;
  late PowerPointConfig _powerpointConfig;
  late WordConfig _wordConfig;

  @override
  void initState() {
    super.initState();
    _kakaobankConfig = KakaoBankConfig.defaultPreset();
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
    _yanoljaConfig = YanoljaConfig.defaultPreset();
    _upbitConfig = UpbitConfig.defaultPreset();
    _blindConfig = BlindConfig.defaultPreset();
    _discordConfig = DiscordConfig.defaultPreset();
    _photoshopConfig = PhotoshopConfig.defaultPreset();
    _visualStudioConfig = VisualStudioConfig.defaultPreset();
    _chromeConfig = ChromeConfig.defaultPreset();
    _davinciConfig = DavinciConfig.defaultPreset();
    _telegramConfig = TelegramConfig.defaultPreset();
    _zigbangConfig = ZigbangConfig.defaultPreset();
    _naverConfig = NaverConfig.defaultPreset();
    _edgeConfig = EdgeConfig.defaultPreset();
    _cctvConfig = CctvConfig.defaultPreset();
    _steamConfig = SteamConfig.defaultPreset();
    _newsConfig = NewsConfig.defaultPreset();
    _dcinsideConfig = DcinsideConfig.defaultPreset();
    _excelConfig = ExcelConfig.defaultPreset();
    _powerpointConfig = PowerPointConfig.defaultPreset();
    _wordConfig = WordConfig.defaultPreset();
  }

  ScreenTemplate get _template {
    final lookupId = widget.templateId == 'steamos' ? 'steam' : widget.templateId;
    return ScreenTemplate.allTemplates.firstWhere(
      (t) => t.id == lookupId,
      orElse: () => ScreenTemplate.allTemplates.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = _template;

    return AppEditorShell(
      template: t,
      onBackToGallery: widget.onBackToGallery,
      onOpenInOs: widget.onOpenInOs,
      canvasBuilder: (ctx, isDark) {
        return StudioPreviewDispatcher(
          templateId: t.id,
          tossConfig: _tossConfig,
          kakaobankConfig: _kakaobankConfig,
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
          yanoljaConfig: _yanoljaConfig,
          upbitConfig: _upbitConfig,
          blindConfig: _blindConfig,
          discordConfig: _discordConfig,
          photoshopConfig: _photoshopConfig,
          visualStudioConfig: _visualStudioConfig,
          chromeConfig: _chromeConfig,
          davinciConfig: _davinciConfig,
          onKakaoBankChanged: (cfg) => setState(() => _kakaobankConfig = cfg),
          onDaangnChanged: (cfg) => setState(() => _daangnConfig = cfg),
          onYoutubeChanged: (cfg) => setState(() => _youtubeConfig = cfg),
          onCoupangChanged: (cfg) => setState(() => _coupangConfig = cfg),
          onNetflixChanged: (cfg) => setState(() => _netflixConfig = cfg),
          onLotteryChanged: (cfg) => setState(() => _lotteryConfig = cfg),
          onYanoljaChanged: (cfg) => setState(() => _yanoljaConfig = cfg),
          onUpbitChanged: (cfg) => setState(() => _upbitConfig = cfg),
          onBlindChanged: (cfg) => setState(() => _blindConfig = cfg),
          onDiscordChanged: (cfg) => setState(() => _discordConfig = cfg),
          onPhotoshopChanged: (cfg) => setState(() => _photoshopConfig = cfg),
          onVisualStudioChanged: (cfg) => setState(() => _visualStudioConfig = cfg),
          onChromeChanged: (cfg) => setState(() => _chromeConfig = cfg),
          onDavinciChanged: (cfg) => setState(() => _davinciConfig = cfg),
          telegramConfig: _telegramConfig,
          onTelegramChanged: (cfg) => setState(() => _telegramConfig = cfg),
          zigbangConfig: _zigbangConfig,
          onZigbangChanged: (cfg) => setState(() => _zigbangConfig = cfg),
          naverConfig: _naverConfig,
          onNaverChanged: (cfg) => setState(() => _naverConfig = cfg),
          edgeConfig: _edgeConfig,
          onEdgeChanged: (cfg) => setState(() => _edgeConfig = cfg),
          cctvConfig: _cctvConfig,
          onCctvChanged: (cfg) => setState(() => _cctvConfig = cfg),
          steamConfig: _steamConfig,
          onSteamChanged: (cfg) => setState(() => _steamConfig = cfg),
          newsConfig: _newsConfig,
          onNewsChanged: (cfg) => setState(() => _newsConfig = cfg),
          dcinsideConfig: _dcinsideConfig,
          onDcinsideChanged: (cfg) => setState(() => _dcinsideConfig = cfg),
          excelConfig: _excelConfig,
          onExcelChanged: (cfg) => setState(() => _excelConfig = cfg),
          powerpointConfig: _powerpointConfig,
          onPowerPointChanged: (cfg) => setState(() => _powerpointConfig = cfg),
          wordConfig: _wordConfig,
          onWordChanged: (cfg) => setState(() => _wordConfig = cfg),
        );
      },
      inspectorBuilder: (ctx, isDark) {
        return WorkspaceEditorInspector(
          template: t,
          isDarkMode: isDark,
          onOpenInOs: () => widget.onOpenInOs('windows_11'),
          kakaoConfig: _kakaoConfig,
          onKakaoChanged: (cfg) => setState(() => _kakaoConfig = cfg),
          tossConfig: _tossConfig,
          onTossChanged: (cfg) => setState(() => _tossConfig = cfg),
          kakaobankConfig: _kakaobankConfig,
          onKakaoBankChanged: (cfg) => setState(() => _kakaobankConfig = cfg),
          daangnConfig: _daangnConfig,
          onDaangnChanged: (cfg) => setState(() => _daangnConfig = cfg),
          youtubeConfig: _youtubeConfig,
          onYoutubeChanged: (cfg) => setState(() => _youtubeConfig = cfg),
          instaConfig: _instaConfig,
          onInstaChanged: (cfg) => setState(() => _instaConfig = cfg),
          twitterConfig: _twitterConfig,
          onTwitterChanged: (cfg) => setState(() => _twitterConfig = cfg),
          blindConfig: _blindConfig,
          onBlindChanged: (cfg) => setState(() => _blindConfig = cfg),
          steamConfig: _steamConfig,
          onSteamChanged: (cfg) => setState(() => _steamConfig = cfg),
          excelConfig: _excelConfig,
          onExcelChanged: (cfg) => setState(() => _excelConfig = cfg),
          powerpointConfig: _powerpointConfig,
          onPowerPointChanged: (cfg) => setState(() => _powerpointConfig = cfg),
          wordConfig: _wordConfig,
          onWordChanged: (cfg) => setState(() => _wordConfig = cfg),
          bsodConfig: _bsodConfig,
          onBsodChanged: (cfg) => setState(() => _bsodConfig = cfg),
          winUpdateConfig: _winUpdateConfig,
          onWinUpdateChanged: (cfg) => setState(() => _winUpdateConfig = cfg),
        );
      },
    );
  }
}
