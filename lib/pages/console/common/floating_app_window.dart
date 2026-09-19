import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import '../../../apps/chrome/data/chrome_model.dart';
import '../../../apps/chrome/chrome_screen.dart';
import '../../../apps/davinci_resolve/data/davinci_resolve_model.dart';
import '../../../apps/davinci_resolve/davinci_resolve_screen.dart';
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
  final String windowsVersion;
  final bool isMaximized;
  final VoidCallback onFocus;
  final Function(Offset) onPositionChanged;
  final Function(Size) onSizeChanged;
  final VoidCallback onMinimize;
  final VoidCallback onMaximize;
  final VoidCallback onClose;

  const FloatingAppWindow({
    super.key,
    required this.template,
    required this.position,
    required this.size,
    required this.isFocused,
    this.isMacStyle = false,
    this.windowsVersion = '11',
    this.isMaximized = false,
    required this.onFocus,
    required this.onPositionChanged,
    required this.onSizeChanged,
    required this.onMinimize,
    required this.onMaximize,
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
  late ChromeConfig _chromeConfig;
  late DavinciConfig _davinciConfig;

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
    _chromeConfig = ChromeConfig.defaultPreset();
    _davinciConfig = DavinciConfig.defaultPreset();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktopApp = widget.template.isDesktop;
    final isWinXp = !widget.isMacStyle && widget.windowsVersion == 'xp';
    final isWin7 = !widget.isMacStyle && widget.windowsVersion == '7';
    final isWin10 = !widget.isMacStyle && widget.windowsVersion == '10';
    final borderRadius = widget.isMaximized
        ? BorderRadius.zero
        : (isWin10 ? BorderRadius.zero : (isWinXp || isWin7 ? BorderRadius.circular(8) : BorderRadius.circular(12)));
    final borderColor = isWinXp
        ? const Color(0xFF0055EA)
        : (isWin7
            ? (widget.isFocused ? Colors.white.withValues(alpha: 0.55) : Colors.white.withValues(alpha: 0.25))
            : (isWin10
                ? (widget.isFocused ? const Color(0xFF0078D7) : const Color(0xFF3E3E42))
                : (widget.isFocused ? const Color(0xFF6366F1) : Colors.white.withValues(alpha: 0.12))));
    final titleBarHeight = isWinXp ? 29.0 : (isWin7 ? 30.0 : (isWin10 ? 31.0 : 38.0));
    final titleBarColor = isWinXp
        ? const Color(0xFF0055EA)
        : (isWin7
            ? (widget.isFocused ? const Color(0xFF6BA4D8).withValues(alpha: 0.85) : const Color(0xFF50789E).withValues(alpha: 0.75))
            : (isWin10
                ? (widget.isFocused ? const Color(0xFF2B2B2B) : const Color(0xFF1F1F1F))
                : (widget.isFocused ? const Color(0xFF141622) : const Color(0xFF0D0E15))));
    final titleBarBorderRadius = widget.isMaximized
        ? BorderRadius.zero
        : (isWin10
            ? BorderRadius.zero
            : (isWinXp || isWin7
                ? const BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7))
                : const BorderRadius.only(topLeft: Radius.circular(11), topRight: Radius.circular(11))));

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
              color: isWin10 ? const Color(0xFF191919) : const Color(0xFF181A24),
              borderRadius: borderRadius,
              border: Border.all(
                color: borderColor,
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: widget.isFocused ? 0.55 : 0.30),
                  blurRadius: isWin10 ? (widget.isFocused ? 20 : 10) : (widget.isFocused ? 32 : 16),
                  spreadRadius: isWin10 ? 0 : (widget.isFocused ? 2 : 0),
                  offset: isWin10 ? const Offset(0, 5) : const Offset(0, 10),
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
                      onDoubleTap: widget.onMaximize,
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
                        height: titleBarHeight,
                        padding: EdgeInsets.symmetric(horizontal: isWin10 ? 0 : 12),
                        decoration: BoxDecoration(
                          color: titleBarColor,
                          borderRadius: titleBarBorderRadius,
                          border: Border(bottom: BorderSide(color: isWin10 ? const Color(0xFF333333) : Colors.white.withValues(alpha: 0.08))),
                        ),
                        child: Row(
                          children: [
                            if (widget.isMacStyle) ...[
                              // macOS 삼색 버튼
                              _buildMacCircleButton(const Color(0xFFFF5F56), widget.onClose),
                              const SizedBox(width: 8),
                              _buildMacCircleButton(const Color(0xFFFFBD2E), widget.onMinimize),
                              const SizedBox(width: 8),
                              _buildMacCircleButton(const Color(0xFF27C93F), widget.onMaximize),
                              const SizedBox(width: 12),
                            ],

                            if (isWin10) const SizedBox(width: 10),
                            Icon(widget.template.icon, size: 15, color: widget.template.themeColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.template.title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isWin7
                                      ? Colors.black87
                                      : (widget.isFocused ? Colors.white : Colors.white60),
                                  fontSize: 12,
                                  fontWeight: (isWinXp || isWin7)
                                      ? FontWeight.w600
                                      : (widget.isFocused ? (isWin10 ? FontWeight.w500 : FontWeight.bold) : FontWeight.normal),
                                  fontFamily: (isWinXp || isWin7 || isWin10) ? 'Segoe UI' : null,
                                  shadows: isWinXp
                                      ? const [Shadow(color: Color(0xFF002266), blurRadius: 2, offset: Offset(1, 1))]
                                      : (isWin7
                                          ? const [
                                              Shadow(color: Colors.white, blurRadius: 10),
                                              Shadow(color: Colors.white, blurRadius: 5),
                                              Shadow(color: Colors.white, blurRadius: 2),
                                            ]
                                          : null),
                                ),
                              ),
                            ),

                            if (!widget.isMacStyle) ...[
                              if (isWinXp) ...[
                                _buildWinXpCaptionButtons(),
                              ] else if (isWin7) ...[
                                _buildWin7AeroCaptionButtons(),
                              ] else if (isWin10) ...[
                                // Windows 10 직각 풀-하이트 캡션 버튼: [최소화] [최대화/복원] [닫기]
                                _buildWin10HeaderBtn(
                                  Container(width: 10, height: 1, color: Colors.white70),
                                  widget.onMinimize,
                                ),
                                _Win10TitleHeaderButton(
                                  icon: widget.isMaximized ? _buildWin10RestoreIcon() : _buildWin10MaximizeIcon(),
                                  onTap: widget.onMaximize,
                                ),
                                _buildWin10HeaderBtn(
                                  const Icon(CupertinoIcons.xmark, size: 10.5, color: Colors.white),
                                  widget.onClose,
                                  isClose: true,
                                ),
                              ] else ...[
                                // Windows 11 MDI 우측 버튼: [최소화] [최대화/복원] [닫기]
                                InkWell(
                                  onTap: widget.onMinimize,
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: Icon(CupertinoIcons.minus, size: 12, color: Colors.white70),
                                  ),
                                ),
                                InkWell(
                                  onTap: widget.onMaximize,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: Icon(
                                      widget.isMaximized ? CupertinoIcons.square_on_square : CupertinoIcons.square,
                                      size: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: widget.onClose,
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: Icon(CupertinoIcons.xmark, size: 12, color: Colors.redAccent),
                                  ),
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ),

                    // 2. 창 내부 앱 실행 뷰 영역
                    Expanded(
                      child: ClipRRect(
                        borderRadius: (isWin10 || widget.isMaximized)
                            ? BorderRadius.zero
                            : (isWin7
                                ? const BorderRadius.only(
                                    bottomLeft: Radius.circular(7),
                                    bottomRight: Radius.circular(7),
                                  )
                                : const BorderRadius.only(
                                    bottomLeft: Radius.circular(11),
                                    bottomRight: Radius.circular(11),
                                  )),
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
      case 'chrome':
        return ChromeScreen(
          config: _chromeConfig,
          onConfigChanged: (cfg) => setState(() => _chromeConfig = cfg),
        );
      case 'davinci_resolve':
        return DavinciResolveScreen(
          config: _davinciConfig,
          onConfigChanged: (cfg) => setState(() => _davinciConfig = cfg),
        );
      case 'windows_bsod':
        return WindowsBsodScreen(config: _bsodConfig);
      default:
        return TossScreen(config: _tossConfig);
    }
  }

  Widget _buildWin10MaximizeIcon() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.isFocused ? Colors.white : Colors.white60,
          width: 1.0,
        ),
        borderRadius: BorderRadius.zero,
      ),
    );
  }

  Widget _buildWin10RestoreIcon() {
    return SizedBox(
      width: 10,
      height: 10,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                border: Border.all(
                  color: widget.isFocused ? Colors.white : Colors.white60,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F1F),
                border: Border.all(
                  color: widget.isFocused ? Colors.white : Colors.white60,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWin10HeaderBtn(Widget icon, VoidCallback? onTap, {bool isClose = false}) {
    return _Win10TitleHeaderButton(icon: icon, onTap: onTap, isClose: isClose);
  }

  Widget _buildWinXpCaptionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _WinXpButton(
          icon: Container(width: 8, height: 2, color: Colors.white),
          tooltip: '최소화',
          onTap: widget.onMinimize,
        ),
        const SizedBox(width: 2),
        _WinXpButton(
          icon: Icon(
            widget.isMaximized ? CupertinoIcons.square_on_square : CupertinoIcons.square,
            size: 11,
            color: Colors.white,
          ),
          tooltip: widget.isMaximized ? '이전 크기로 복원' : '최대화',
          onTap: widget.onMaximize,
        ),
        const SizedBox(width: 2),
        _WinXpButton(
          icon: const Icon(CupertinoIcons.xmark, size: 11, color: Colors.white),
          tooltip: '닫기',
          isClose: true,
          onTap: widget.onClose,
        ),
      ],
    );
  }

  Widget _buildWin7AeroCaptionButtons() {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 0.8),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Win7AeroButton(
            width: 28,
            onTap: widget.onMinimize,
            child: Container(width: 8, height: 2, color: Colors.black87),
          ),
          _Win7AeroButton(
            width: 28,
            onTap: widget.onMaximize,
            child: widget.isMaximized ? _buildWin10RestoreIcon() : _buildWin10MaximizeIcon(),
          ),
          _Win7AeroButton(
            width: 44,
            isClose: true,
            onTap: widget.onClose,
            child: const Icon(CupertinoIcons.xmark, size: 11, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _Win7AeroButton extends StatefulWidget {
  final double width;
  final Widget child;
  final VoidCallback? onTap;
  final bool isClose;

  const _Win7AeroButton({
    required this.width,
    required this.child,
    required this.onTap,
    this.isClose = false,
  });

  @override
  State<_Win7AeroButton> createState() => _Win7AeroButtonState();
}

class _Win7AeroButtonState extends State<_Win7AeroButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: widget.width,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: widget.isClose
                  ? (_isHovered
                      ? [const Color(0xFFFF5C5C), const Color(0xFFD61818)]
                      : [const Color(0xFFE27474).withValues(alpha: 0.85), const Color(0xFFA82E2E).withValues(alpha: 0.9)])
                  : (_isHovered
                      ? [const Color(0xFFBFE0FF), const Color(0xFF6EB7F5)]
                      : [Colors.white.withValues(alpha: 0.45), Colors.white.withValues(alpha: 0.15)]),
            ),
            border: widget.isClose
                ? null
                : const Border(right: BorderSide(color: Colors.black12, width: 0.8)),
            boxShadow: (widget.isClose && _isHovered)
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF3B30).withValues(alpha: 0.6),
                      blurRadius: 6,
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: widget.child,
        ),
      ),
    );
  }
}

class _WinXpButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback? onTap;
  final bool isClose;
  final String tooltip;

  const _WinXpButton({
    required this.icon,
    required this.onTap,
    this.isClose = false,
    required this.tooltip,
  });

  @override
  State<_WinXpButton> createState() => _WinXpButtonState();
}

class _WinXpButtonState extends State<_WinXpButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final List<Color> normalGradient = widget.isClose
        ? const [Color(0xFFE2614E), Color(0xFFC7301B), Color(0xFFA81C08)]
        : const [Color(0xFF3F8CFF), Color(0xFF1E6BE6), Color(0xFF0F50C2)];

    final List<Color> hoverGradient = widget.isClose
        ? const [Color(0xFFFF8270), Color(0xFFEE4932), Color(0xFFC7240E)]
        : const [Color(0xFF68A5FF), Color(0xFF3982F7), Color(0xFF1C60D9)];

    final List<Color> pressedGradient = widget.isClose
        ? const [Color(0xFFB81F0C), Color(0xFFD6341F), Color(0xFFE8503C)]
        : const [Color(0xFF0C46A8), Color(0xFF1659C9), Color(0xFF2870E8)];

    final currentColors = _isPressed
        ? pressedGradient
        : (_isHovered ? hoverGradient : normalGradient);

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() {
          _isHovered = false;
          _isPressed = false;
        }),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: widget.onTap,
          child: Container(
            width: 21,
            height: 21,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: currentColors,
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.9),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  offset: const Offset(1, 1),
                  blurRadius: 1,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: widget.icon,
          ),
        ),
      ),
    );
  }
}

class _Win10TitleHeaderButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback? onTap;
  final bool isClose;

  const _Win10TitleHeaderButton({
    required this.icon,
    required this.onTap,
    this.isClose = false,
  });

  @override
  State<_Win10TitleHeaderButton> createState() => _Win10TitleHeaderButtonState();
}

class _Win10TitleHeaderButtonState extends State<_Win10TitleHeaderButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.transparent;
    if (_isPressed) {
      bg = widget.isClose ? const Color(0xFFF1707A) : const Color(0xFF4C4C50);
    } else if (_isHovered) {
      bg = widget.isClose ? const Color(0xFFE81123) : const Color(0xFF3F3F41);
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: Container(
          width: 46,
          height: 31,
          color: bg,
          alignment: Alignment.center,
          child: widget.icon,
        ),
      ),
    );
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
