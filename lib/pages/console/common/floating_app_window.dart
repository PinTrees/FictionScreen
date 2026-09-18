import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../apps/delivery/data/delivery_model.dart';
import '../../../apps/delivery/delivery_screen.dart';
import '../../../apps/daangn/data/daangn_model.dart';
import '../../../apps/daangn/daangn_screen.dart';
import '../../../apps/instagram/data/instagram_model.dart';
import '../../../apps/instagram/instagram_screen.dart';
import '../../../apps/kakaotalk/data/kakaotalk_model.dart';
import '../../../apps/kakaotalk/kakaotalk_screen.dart';
import '../../../apps/pinterest/data/pinterest_model.dart';
import '../../../apps/pinterest/pinterest_screen.dart';
import '../../../apps/screen_template.dart';
import '../../../apps/toss/data/toss_model.dart';
import '../../../apps/toss/toss_screen.dart';
import '../../../apps/kakaobank/data/kakaobank_model.dart';
import '../../../apps/kakaobank/kakaobank_screen.dart';
import '../../../apps/windows_bsod/data/windows_bsod_model.dart';
import '../../../apps/windows_bsod/windows_bsod_screen.dart';
import '../../../apps/x_twitter/data/x_twitter_model.dart';
import '../../../apps/x_twitter/x_twitter_screen.dart';
import '../../../apps/upbit/data/upbit_model.dart';
import '../../../apps/upbit/upbit_screen.dart';
import '../../../apps/blind/data/blind_model.dart';
import '../../../apps/blind/blind_screen.dart';
import '../../../apps/discord/data/discord_model.dart';
import '../../../apps/discord/discord_screen.dart';
import '../../../apps/photoshop/data/photoshop_model.dart';
import '../../../apps/photoshop/photoshop_screen.dart';
import '../../../apps/visual_studio/data/visual_studio_model.dart';
import '../../../apps/visual_studio/visual_studio_screen.dart';
import '../../../apps/yanolja/data/yanolja_model.dart';
import '../../../apps/yanolja/yanolja_screen.dart';
import '../../../apps/coupang/data/coupang_model.dart';
import '../../../apps/coupang/coupang_screen.dart';
import '../../../apps/netflix/data/netflix_model.dart';
import '../../../apps/netflix/netflix_screen.dart';
import '../../../apps/lottery/data/lottery_model.dart';
import '../../../apps/lottery/lottery_screen.dart';
import '../../../apps/youtube/data/youtube_model.dart';
import '../../../apps/youtube/youtube_screen.dart';
import '../../../widgets/common/device_frame_preview.dart';

class FloatingAppWindow extends StatefulWidget {
  final ScreenTemplate template;
  final Offset position;
  final Size size;
  final bool isFocused;
  final bool isMacStyle;
  final VoidCallback onFocus;
  final Function(Offset) onPositionChanged;
  final Function(Size) onSizeChanged;
  final VoidCallback onMinimize;
  final VoidCallback onClose;

  const FloatingAppWindow({
    super.key,
    required this.template,
    required this.position,
    required this.size,
    required this.isFocused,
    this.isMacStyle = false,
    required this.onFocus,
    required this.onPositionChanged,
    required this.onSizeChanged,
    required this.onMinimize,
    required this.onClose,
  });

  @override
  State<FloatingAppWindow> createState() => _FloatingAppWindowState();
}

class _FloatingAppWindowState extends State<FloatingAppWindow> {
  // 드래그 마우스 오프셋 고정
  Offset? _dragStartOffset;

  // 리사이즈 마우스 오프셋 고정
  Offset? _resizeStartMouse;
  Size? _resizeStartSize;

  // 창 내부 앱 Configs
  late KakaoRoomConfig _kakaoConfig;
  late TossConfig _tossConfig;
  late XTwitterConfig _twitterConfig;
  late PinterestConfig _pinterestConfig;
  late WindowsBsodConfig _bsodConfig;
  late YoutubeConfig _youtubeConfig;
  late InstagramConfig _instaConfig;
  late DeliveryConfig _deliveryConfig;
  late DaangnConfig _daangnConfig;
  late KakaoBankConfig _kakaobankConfig;
  late CoupangConfig _coupangConfig;
  late NetflixConfig _netflixConfig;
  late LotteryConfig _lotteryConfig;
  late YanoljaConfig _yanoljaConfig;
  late UpbitConfig _upbitConfig;
  late BlindConfig _blindConfig;
  late DiscordConfig _discordConfig;
  late PhotoshopConfig _photoshopConfig;
  late VisualStudioConfig _visualStudioConfig;

  @override
  void initState() {
    super.initState();
    _kakaoConfig = KakaoRoomConfig.defaultPreset();
    _tossConfig = TossConfig.defaultPreset();
    _kakaobankConfig = KakaoBankConfig.defaultPreset();
    _twitterConfig = XTwitterConfig.defaultPreset();
    _pinterestConfig = PinterestConfig.defaultPreset();
    _bsodConfig = WindowsBsodConfig.defaultPreset();
    _daangnConfig = DaangnConfig.defaultPreset();
    _youtubeConfig = YoutubeConfig.defaultPreset();
    _instaConfig = InstagramConfig.defaultPreset();
    _deliveryConfig = DeliveryConfig.defaultPreset();
    _coupangConfig = CoupangConfig.defaultPreset();
    _netflixConfig = NetflixConfig.defaultPreset();
    _lotteryConfig = LotteryConfig.defaultPreset();
    _yanoljaConfig = YanoljaConfig.defaultPreset();
    _upbitConfig = UpbitConfig.defaultPreset();
    _blindConfig = BlindConfig.defaultPreset();
    _discordConfig = DiscordConfig.defaultPreset();
    _photoshopConfig = PhotoshopConfig.defaultPreset();
    _visualStudioConfig = VisualStudioConfig.defaultPreset();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktopApp = widget.template.isDesktop;

    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: Listener(
        onPointerDown: (_) => widget.onFocus(), // 창 누르면 최상단 포커스
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: widget.size.width,
            height: widget.size.height,
            decoration: BoxDecoration(
              color: const Color(0xFF181A24),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.isFocused ? const Color(0xFF6366F1) : Colors.white.withValues(alpha: 0.12),
                width: widget.isFocused ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: widget.isFocused ? 0.6 : 0.35),
                  blurRadius: widget.isFocused ? 32 : 16,
                  spreadRadius: widget.isFocused ? 2 : 0,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    // 1. 드래그 가능한 타이틀바 (마우스 포인터 위치 1:1 완벽추종)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onPanStart: (details) {
                        widget.onFocus();
                        _dragStartOffset = details.globalPosition - widget.position;
                      },
                      onPanUpdate: (details) {
                        if (_dragStartOffset != null) {
                          widget.onPositionChanged(details.globalPosition - _dragStartOffset!);
                        }
                      },
                      onPanEnd: (_) {
                        _dragStartOffset = null;
                      },
                      child: Container(
                        height: 38,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: widget.isFocused ? const Color(0xFF141622) : const Color(0xFF0D0E15),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(11),
                            topRight: Radius.circular(11),
                          ),
                          border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
                        ),
                        child: Row(
                          children: [
                            if (widget.isMacStyle) ...[
                              // macOS 삼색 버튼
                              _buildMacCircleButton(const Color(0xFFFF5F56), widget.onClose),
                              const SizedBox(width: 8),
                              _buildMacCircleButton(const Color(0xFFFFBD2E), widget.onMinimize),
                              const SizedBox(width: 8),
                              _buildMacCircleButton(const Color(0xFF27C93F), () {
                                context.push('/studio/${widget.template.id}');
                              }),
                              const SizedBox(width: 12),
                            ],

                            Icon(widget.template.icon, size: 15, color: widget.template.themeColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.template.title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: widget.isFocused ? Colors.white : Colors.white60,
                                  fontSize: 12,
                                  fontWeight: widget.isFocused ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),

                            if (!widget.isMacStyle) ...[
                              // Windows MDI 우측 버튼
                              InkWell(
                                onTap: () => context.push('/studio/${widget.template.id}'),
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(CupertinoIcons.arrow_up_left_arrow_down_right, size: 13, color: Colors.white70),
                                ),
                              ),
                              const SizedBox(width: 6),
                              InkWell(
                                onTap: widget.onMinimize,
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(CupertinoIcons.minus, size: 13, color: Colors.white70),
                                ),
                              ),
                              const SizedBox(width: 6),
                              InkWell(
                                onTap: widget.onClose,
                                child: const Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(CupertinoIcons.xmark, size: 13, color: Colors.redAccent),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    // 2. 창 내부 앱 실행 뷰 영역
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(11),
                          bottomRight: Radius.circular(11),
                        ),
                        child: DeviceFramePreview(
                          showFrame: false,
                          isDesktop: isDesktopApp,
                          child: _buildAppContent(),
                        ),
                      ),
                    ),
                  ],
                ),

                // 3. 우측 하단 리사이즈 핸들러 (마우스 1:1 추종)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onPanStart: (details) {
                      widget.onFocus();
                      _resizeStartMouse = details.globalPosition;
                      _resizeStartSize = widget.size;
                    },
                    onPanUpdate: (details) {
                      if (_resizeStartMouse != null && _resizeStartSize != null) {
                        final mouseDelta = details.globalPosition - _resizeStartMouse!;
                        final newWidth = (_resizeStartSize!.width + mouseDelta.dx).clamp(320.0, 1200.0);
                        final newHeight = (_resizeStartSize!.height + mouseDelta.dy).clamp(420.0, 900.0);
                        widget.onSizeChanged(Size(newWidth, newHeight));
                      }
                    },
                    onPanEnd: (_) {
                      _resizeStartMouse = null;
                      _resizeStartSize = null;
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.resizeDownRight,
                      child: Container(
                        width: 20,
                        height: 20,
                        color: Colors.transparent,
                        child: CustomPaint(
                          painter: _ResizeHandlePainter(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMacCircleButton(Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildAppContent() {
    switch (widget.template.id) {
      case 'toss':
        return TossScreen(config: _tossConfig);
      case 'kakaobank':
        return KakaoBankScreen(
          config: _kakaobankConfig,
          onConfigChanged: (cfg) => setState(() => _kakaobankConfig = cfg),
        );
      case 'kakaotalk':
        return KakaoTalkScreen(config: _kakaoConfig);
      case 'x_twitter':
        return XTwitterScreen(config: _twitterConfig);
      case 'pinterest':
        return PinterestScreen(config: _pinterestConfig);
      case 'instagram':
        return InstagramScreen(config: _instaConfig);
      case 'youtube':
        return YoutubeScreen(
          config: _youtubeConfig,
          onConfigChanged: (cfg) => setState(() => _youtubeConfig = cfg),
        );
      case 'delivery':
        return DeliveryScreen(config: _deliveryConfig);
      case 'daangn':
        return DaangnScreen(
          config: _daangnConfig,
          onConfigChanged: (cfg) => setState(() => _daangnConfig = cfg),
        );
      case 'coupang':
        return CoupangScreen(
          config: _coupangConfig,
          onConfigChanged: (cfg) => setState(() => _coupangConfig = cfg),
        );
      case 'netflix':
        return NetflixScreen(
          config: _netflixConfig,
          onConfigChanged: (cfg) => setState(() => _netflixConfig = cfg),
        );
      case 'lottery':
        return LotteryScreen(
          config: _lotteryConfig,
          onConfigChanged: (cfg) => setState(() => _lotteryConfig = cfg),
        );
      case 'yanolja':
        return YanoljaScreen(
          config: _yanoljaConfig,
          onConfigChanged: (cfg) => setState(() => _yanoljaConfig = cfg),
        );
      case 'upbit':
        return UpbitScreen(
          config: _upbitConfig,
          onConfigChanged: (cfg) => setState(() => _upbitConfig = cfg),
        );
      case 'blind':
        return BlindScreen(
          config: _blindConfig,
          onConfigChanged: (cfg) => setState(() => _blindConfig = cfg),
        );
      case 'discord':
        return DiscordScreen(
          config: _discordConfig,
          onConfigChanged: (cfg) => setState(() => _discordConfig = cfg),
        );
      case 'photoshop':
        return PhotoshopScreen(
          config: _photoshopConfig,
          onConfigChanged: (cfg) => setState(() => _photoshopConfig = cfg),
        );
      case 'visual_studio':
        return VisualStudioScreen(
          config: _visualStudioConfig,
          onConfigChanged: (cfg) => setState(() => _visualStudioConfig = cfg),
        );
      case 'windows_bsod':
        return WindowsBsodScreen(config: _bsodConfig);
      default:
        return TossScreen(config: _tossConfig);
    }
  }
}

class _ResizeHandlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 1.5;

    canvas.drawLine(Offset(size.width * 0.4, size.height), Offset(size.width, size.height * 0.4), paint);
    canvas.drawLine(Offset(size.width * 0.7, size.height), Offset(size.width, size.height * 0.7), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
