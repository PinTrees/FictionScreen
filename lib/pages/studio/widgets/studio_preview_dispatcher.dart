import 'package:flutter/material.dart';
import '../../../apps/blind/blind_screen.dart';
import '../../../apps/blind/data/blind_model.dart';
import '../../../apps/discord/discord_screen.dart';
import '../../../apps/discord/data/discord_model.dart';
import '../../../apps/photoshop/photoshop_screen.dart';
import '../../../apps/photoshop/data/photoshop_model.dart';
import '../../../apps/visual_studio/visual_studio_screen.dart';
import '../../../apps/visual_studio/data/visual_studio_model.dart';
import '../../../apps/coupang/coupang_screen.dart';
import '../../../apps/coupang/data/coupang_model.dart';
import '../../../apps/daangn/daangn_screen.dart';
import '../../../apps/daangn/data/daangn_model.dart';
import '../../../apps/delivery/data/delivery_model.dart';
import '../../../apps/delivery/delivery_screen.dart';
import '../../../apps/instagram/data/instagram_model.dart';
import '../../../apps/instagram/instagram_screen.dart';
import '../../../apps/kakaobank/data/kakaobank_model.dart';
import '../../../apps/kakaobank/kakaobank_screen.dart';
import '../../../apps/kakaotalk/data/kakaotalk_model.dart';
import '../../../apps/kakaotalk/kakaotalk_screen.dart';
import '../../../apps/lottery/data/lottery_model.dart';
import '../../../apps/lottery/lottery_screen.dart';
import '../../../apps/netflix/data/netflix_model.dart';
import '../../../apps/netflix/netflix_screen.dart';
import '../../../apps/pinterest/data/pinterest_model.dart';
import '../../../apps/pinterest/pinterest_screen.dart';
import '../../../apps/toss/data/toss_model.dart';
import '../../../apps/toss/toss_screen.dart';
import '../../../apps/upbit/data/upbit_model.dart';
import '../../../apps/upbit/upbit_screen.dart';
import '../../../apps/windows_bsod/data/windows_bsod_model.dart';
import '../../../apps/windows_bsod/windows_bsod_screen.dart';
import '../../../apps/windows_update/data/windows_update_model.dart';
import '../../../apps/windows_update/windows_update_screen.dart';
import '../../../apps/x_twitter/data/x_twitter_model.dart';
import '../../../apps/x_twitter/x_twitter_screen.dart';
import '../../../apps/yanolja/data/yanolja_model.dart';
import '../../../apps/yanolja/yanolja_screen.dart';
import '../../../apps/youtube/data/youtube_model.dart';
import '../../../apps/youtube/youtube_screen.dart';

/// 스튜디오 템플릿별 실시간 프리뷰 위젯 순수 디스패처
class StudioPreviewDispatcher extends StatelessWidget {
  final String templateId;
  final TossConfig tossConfig;
  final KakaoBankConfig kakaobankConfig;
  final KakaoRoomConfig kakaoConfig;
  final XTwitterConfig twitterConfig;
  final PinterestConfig pinterestConfig;
  final InstagramConfig instaConfig;
  final YoutubeConfig youtubeConfig;
  final DeliveryConfig deliveryConfig;
  final DaangnConfig daangnConfig;
  final WindowsBsodConfig bsodConfig;
  final WindowsUpdateConfig winUpdateConfig;
  final CoupangConfig coupangConfig;
  final NetflixConfig netflixConfig;
  final LotteryConfig lotteryConfig;
  final YanoljaConfig yanoljaConfig;
  final UpbitConfig upbitConfig;
  final BlindConfig blindConfig;
  final DiscordConfig discordConfig;
  final ValueChanged<KakaoBankConfig>? onKakaoBankChanged;
  final ValueChanged<DaangnConfig>? onDaangnChanged;
  final ValueChanged<YoutubeConfig>? onYoutubeChanged;
  final ValueChanged<CoupangConfig>? onCoupangChanged;
  final ValueChanged<NetflixConfig>? onNetflixChanged;
  final ValueChanged<LotteryConfig>? onLotteryChanged;
  final ValueChanged<YanoljaConfig>? onYanoljaChanged;
  final ValueChanged<UpbitConfig>? onUpbitChanged;
  final ValueChanged<BlindConfig>? onBlindChanged;
  final ValueChanged<DiscordConfig>? onDiscordChanged;

  const StudioPreviewDispatcher({
    super.key,
    required this.templateId,
    required this.tossConfig,
    required this.kakaobankConfig,
    required this.kakaoConfig,
    required this.twitterConfig,
    required this.pinterestConfig,
    required this.instaConfig,
    required this.youtubeConfig,
    required this.deliveryConfig,
    required this.daangnConfig,
    required this.bsodConfig,
    required this.winUpdateConfig,
    required this.coupangConfig,
    required this.netflixConfig,
    required this.lotteryConfig,
    required this.yanoljaConfig,
    required this.upbitConfig,
    required this.blindConfig,
    required this.discordConfig,
    required this.photoshopConfig,
    required this.visualStudioConfig,
    this.onKakaoBankChanged,
    this.onDaangnChanged,
    this.onYoutubeChanged,
    this.onCoupangChanged,
    this.onNetflixChanged,
    this.onLotteryChanged,
    this.onYanoljaChanged,
    this.onUpbitChanged,
    this.onBlindChanged,
    this.onDiscordChanged,
    this.onPhotoshopChanged,
    this.onVisualStudioChanged,
  });

  final PhotoshopConfig photoshopConfig;
  final ValueChanged<PhotoshopConfig>? onPhotoshopChanged;
  final VisualStudioConfig visualStudioConfig;
  final ValueChanged<VisualStudioConfig>? onVisualStudioChanged;

  @override
  Widget build(BuildContext context) {
    switch (templateId) {
      case 'toss': return TossScreen(config: tossConfig);
      case 'kakaobank': return KakaoBankScreen(config: kakaobankConfig, onConfigChanged: onKakaoBankChanged);
      case 'x_twitter': return XTwitterScreen(config: twitterConfig);
      case 'pinterest': return PinterestScreen(config: pinterestConfig);
      case 'kakaotalk': return KakaoTalkScreen(config: kakaoConfig);
      case 'instagram': return InstagramScreen(config: instaConfig);
      case 'youtube': return YoutubeScreen(config: youtubeConfig, onConfigChanged: onYoutubeChanged);
      case 'delivery': return DeliveryScreen(config: deliveryConfig);
      case 'daangn': return DaangnScreen(config: daangnConfig, onConfigChanged: onDaangnChanged);
      case 'windows_bsod': return WindowsBsodScreen(config: bsodConfig);
      case 'windows_update': return WindowsUpdateScreen(config: winUpdateConfig);
      case 'coupang': return CoupangScreen(config: coupangConfig, onConfigChanged: onCoupangChanged);
      case 'netflix': return NetflixScreen(config: netflixConfig, onConfigChanged: onNetflixChanged);
      case 'lottery': return LotteryScreen(config: lotteryConfig, onConfigChanged: onLotteryChanged);
      case 'yanolja': return YanoljaScreen(config: yanoljaConfig, onConfigChanged: onYanoljaChanged);
      case 'upbit': return UpbitScreen(config: upbitConfig, onConfigChanged: onUpbitChanged);
      case 'blind': return BlindScreen(config: blindConfig, onConfigChanged: onBlindChanged);
      case 'discord': return DiscordScreen(config: discordConfig, onConfigChanged: onDiscordChanged);
      case 'photoshop': return PhotoshopScreen(config: photoshopConfig, onConfigChanged: onPhotoshopChanged);
      case 'visual_studio': return VisualStudioScreen(config: visualStudioConfig, onConfigChanged: onVisualStudioChanged);
      default: return TossScreen(config: tossConfig);
    }
  }
}
