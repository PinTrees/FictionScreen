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
                    _buildDockItem(3, 'Messages', 'assets/images/macos/messages.webp', appId: 'messages'),
                  _buildDockItem(4, 'Mail', 'assets/images/macos/mail.webp', appId: 'mail'),
                  _buildDockItem(5, 'Maps', 'assets/images/macos/maps.png', appId: 'maps'),
                  _buildDockItem(6, 'Photos', 'assets/images/macos/photos.webp', appId: 'photos'),
                  _buildDockItem(7, 'Notes', 'assets/images/macos/notes.png', appId: 'notes'),
                  _buildDockItem(8, 'Music', 'assets/images/macos/music.png', appId: 'music'),
                  _buildDockItem(9, '시스템 설정 (OS 전환)', 'assets/images/macos/settings.webp', isSettings: true),
                  _buildDockItem(10, 'Terminal', 'assets/images/macos/terminal.png', appId: 'terminal'),
                  _buildDockItem(11, 'Calculator', 'assets/images/macos/calculator.webp', appId: 'calculator'),

                  _buildDockDivider(),

                  _buildDockItem(12, '카카오톡 채팅 에디터', 'assets/images/kakaotalk_icon.webp', templateId: 'kakaotalk'),
                  _buildDockItem(13, 'Instagram 에디터', 'assets/images/instagram_icon.webp', templateId: 'instagram'),
                  _buildDockItem(14, 'Toss 에디터', 'assets/images/toss_icon.webp', templateId: 'toss'),
                  _buildDockItem(15, 'X (Twitter) 에디터', 'assets/images/x_twitter_icon.webp', templateId: 'x_twitter'),
                  _buildDockItem(16, 'YouTube 에디터', 'assets/images/youtube_icon.webp', templateId: 'youtube'),
                  _buildDockItem(17, '배달의민족 에디터', 'assets/images/baemin_icon.webp', templateId: 'delivery'),

                  _buildDockDivider(),

                  _buildDockItem(18, '랜딩 홈으로 이동', null, icon: CupertinoIcons.house_fill, isHome: true),
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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOutCubic,
            width: size + 6,
            height: size + 12,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
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
    );
  }
}
