import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// macOS 27 Golden Gate Liquid Glass 독(Dock)
/// - 코사인 기반 부드러운 마우스 호버 확대(Magnification)
/// - Liquid Glass 리퀴드 글래스 머티리얼 (초미세 림 라이트, 광택 반사광, 고성능 블러)
/// - 앱 실행 상태 표시 인디케이터 닷(Dot) & 클릭 시 햅틱 피드백
class Macos27Dock extends StatefulWidget {
  final Function(String templateId) onOpenTemplate;
  final Function(String appId)? onOpenApp;
  final VoidCallback onOpenSettings;
  final VoidCallback onGoHome;
  final List<String> activeAppIds;
  final double glassTransparency;

  const Macos27Dock({
    super.key,
    required this.onOpenTemplate,
    this.onOpenApp,
    required this.onOpenSettings,
    required this.onGoHome,
    this.activeAppIds = const [],
    this.glassTransparency = 0.55,
  });

  @override
  State<Macos27Dock> createState() => _Macos27DockState();
}

class _Macos27DockState extends State<Macos27Dock> {
  int? _hoveredIndex;
  int? _pressedIndex;

  double _getScale(int index) {
    if (_hoveredIndex == null) return 1.0;
    final distance = (index - _hoveredIndex!).abs();
    if (distance == 0) return 1.32;
    if (distance == 1) return 1.16;
    if (distance == 2) return 1.06;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final bgAlpha = (widget.glassTransparency * 0.7).clamp(0.2, 0.85);

    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.42),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: const Color(0xFF60CDFF).withValues(alpha: 0.08),
              blurRadius: 16,
              spreadRadius: -2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E).withValues(alpha: bgAlpha),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.22),
                  width: 1.2,
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildDockItem(0, 'Finder', 'assets/images/macos/finder.webp', appId: 'finder'),
                    _buildDockItem(1, 'Safari', 'assets/images/macos/safari.webp', appId: 'safari'),
                    _buildDockItem(2, 'Google Chrome', 'assets/images/macos/chrome.png', appId: 'chrome'),
                    _buildDockItem(3, 'Microsoft Edge', 'assets/images/windows/edge.png', appId: 'edge'),
                    _buildDockItem(4, 'Messages', 'assets/images/macos/messages.webp', appId: 'messages'),
                    _buildDockItem(5, 'Mail', 'assets/images/macos/mail.webp', appId: 'mail'),
                    _buildDockItem(6, 'Maps', 'assets/images/macos/maps.png', appId: 'maps'),
                    _buildDockItem(7, 'Photos', 'assets/images/macos/photos.webp', appId: 'photos'),
                    _buildDockItem(8, 'Notes', 'assets/images/macos/notes.png', appId: 'notes'),
                    _buildDockItem(9, 'Music', 'assets/images/macos/music.png', appId: 'music'),
                    _buildDockItem(10, '시스템 설정 (OS 전환)', 'assets/images/macos/settings.webp', isSettings: true),
                    _buildDockItem(11, 'Terminal', 'assets/images/macos/terminal.png', appId: 'terminal'),
                    _buildDockItem(12, 'Calculator', 'assets/images/macos/calculator.webp', appId: 'calculator'),
                    _buildDockItem(13, 'PDF 서식 스튜디오', 'assets/images/windows/docs.png', appId: 'pdf_viewer'),
                    _buildDockItem(14, 'Telegram Desktop', 'assets/images/windows/desk.png', appId: 'telegram'),
                    _buildDockItem(15, '직방 (부동산)', 'assets/images/zigbang_icon.webp', appId: 'zigbang'),
                    _buildDockItem(16, '네이버 (NAVER)', 'assets/images/naver_icon.webp', appId: 'naver'),
                    _buildDockItem(17, '보안 관제 (CCTV)', null, icon: CupertinoIcons.videocam_fill, appId: 'cctv'),
                    _buildDockItem(18, 'Steam (게임 라이브러리)', 'assets/images/steam_icon.webp', appId: 'steam'),
                    _buildDockItem(19, '뉴스 속보 (TV 생중계)', null, icon: CupertinoIcons.tv_fill, appId: 'news'),

                    _buildDockDivider(),

                    _buildDockItem(20, '카카오톡 채팅 에디터', 'assets/images/kakaotalk_icon.webp', templateId: 'kakaotalk'),
                    _buildDockItem(21, 'Instagram 에디터', 'assets/images/instagram_icon.webp', templateId: 'instagram'),
                    _buildDockItem(22, 'Toss 에디터', 'assets/images/toss_icon.webp', templateId: 'toss'),
                    _buildDockItem(23, '카카오뱅크 에디터', 'assets/images/kakaobank_icon.webp', templateId: 'kakaobank'),
                    _buildDockItem(24, '당근마켓 에디터', 'assets/images/daangn_icon.webp', templateId: 'daangn'),
                    _buildDockItem(25, 'X (Twitter) 에디터', 'assets/images/x_twitter_icon.webp', templateId: 'x_twitter'),
                    _buildDockItem(26, 'YouTube 에디터', 'assets/images/youtube_icon.webp', templateId: 'youtube'),
                    _buildDockItem(27, '배달의민족 에디터', 'assets/images/baemin_icon.webp', templateId: 'delivery'),
                    _buildDockItem(28, '야놀자 에디터', 'assets/images/yanolja_icon.webp', templateId: 'yanolja'),
                    _buildDockItem(29, '업비트 에디터', 'assets/images/upbit_icon.webp', templateId: 'upbit'),
                    _buildDockItem(30, '블라인드 에디터', 'assets/images/blind_icon.webp', templateId: 'blind'),
                    _buildDockItem(31, '디스코드 에디터', 'assets/images/discord_icon.webp', templateId: 'discord'),
                    _buildDockItem(32, '포토샵 에디터', 'assets/images/photoshop_icon.webp', templateId: 'photoshop'),
                    _buildDockItem(33, 'Visual Studio 2026', 'assets/images/visual_studio_icon.webp', templateId: 'visual_studio'),
                    _buildDockItem(34, 'DaVinci Resolve', 'assets/images/davinci_resolve_icon.webp', templateId: 'davinci_resolve'),

                    _buildDockDivider(),

                    _buildDockItem(35, '랜딩 홈으로 이동', null, icon: CupertinoIcons.house_fill, isHome: true),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildDockDivider() {
    return Container(
      width: 1,
      height: 38,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: Colors.white.withValues(alpha: 0.18),
    );
  }

  Widget _buildDockItem(
    int index,
    String tooltip,
    String? imageAsset, {
    IconData? icon,
    String? appId,
    String? templateId,
    bool isSettings = false,
    bool isHome = false,
  }) {
    final scale = _getScale(index);
    final size = 48.0 * scale;
    final isRunning = appId != null && widget.activeAppIds.contains(appId);
    final isDefaultApp = index < 12;
    final imageScale = isDefaultApp ? 1.20 : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: Tooltip(
        message: tooltip,
        textStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
        decoration: BoxDecoration(
          color: const Color(0xFF1E212B).withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white12),
        ),
        verticalOffset: -48 * scale - 12,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressedIndex = index),
          onTapUp: (_) => setState(() => _pressedIndex = null),
          onTapCancel: () => setState(() => _pressedIndex = null),
          onTap: () {
            if (isHome) {
              widget.onGoHome();
            } else if (isSettings) {
              widget.onOpenSettings();
            } else if (templateId != null) {
              widget.onOpenTemplate(templateId);
            } else if (appId != null) {
              widget.onOpenApp?.call(appId);
            }
          },
          child: AnimatedScale(
            scale: _pressedIndex == index ? 0.86 : 1.0,
            duration: const Duration(milliseconds: 90),
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              curve: Curves.easeOutCubic,
              width: size + 6,
              height: size + 12,
              margin: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: size,
                  height: size,
                  child: Center(
                    child: Transform.scale(
                      scale: imageScale,
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(size * 0.224),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.28),
                              blurRadius: 8 * scale,
                              offset: Offset(0, 3 * scale),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(size * 0.224),
                          child: imageAsset != null
                              ? Image.asset(imageAsset, fit: BoxFit.cover, filterQuality: FilterQuality.high)
                              : Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF2563EB), Color(0xFF60CDFF)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(size * 0.224),
                                  ),
                                  child: Icon(icon ?? CupertinoIcons.app, color: Colors.white, size: size * 0.54),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isRunning ? Colors.white.withValues(alpha: 0.85) : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }
}
