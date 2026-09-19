import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../apps/screen_template.dart';

class WorkspaceTopBar extends StatelessWidget {
  final ScreenTemplate template;
  final bool showFrame;
  final bool isExporting;
  final VoidCallback onToggleFrame;
  final VoidCallback onExport;
  final VoidCallback onOpenInOs;
  final Function(String osKey) onSelectOs;
  final VoidCallback onSignOut;

  const WorkspaceTopBar({
    super.key,
    required this.template,
    required this.showFrame,
    required this.isExporting,
    required this.onToggleFrame,
    required this.onExport,
    required this.onOpenInOs,
    required this.onSelectOs,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF10131A),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
      ),
      child: Row(
        children: [
          // Logo & Brand
          InkWell(
            onTap: () => context.go('/'),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF38BDF8)],
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Center(
                      child: Icon(CupertinoIcons.sparkles, color: Colors.white, size: 16),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'FictionScreen',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: -0.3),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.5)),
                    ),
                    child: const Text(
                      'CONSOLE',
                      style: TextStyle(color: Color(0xFFA5B4FC), fontSize: 9.5, fontWeight: FontWeight.w800, letterSpacing: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 14),
          const Text('/', style: TextStyle(color: Colors.white24, fontSize: 16)),
          const SizedBox(width: 14),

          // Breadcrumbs
          Icon(template.icon, color: template.themeColor, size: 16),
          const SizedBox(width: 8),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  template.category.label,
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 6),
                const Text('›', style: TextStyle(color: Colors.white30, fontSize: 14)),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    template.title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.5),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // 1. Open in Virtual OS Window Button
          Tooltip(
            message: '선택한 가상 OS 화면으로 이동하여 이 앱을 플로팅 창으로 엽니다',
            child: InkWell(
              onTap: onOpenInOs,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.4)),
                ),
                child: const Row(
                  children: [
                    Icon(CupertinoIcons.macwindow, size: 14, color: Color(0xFF38BDF8)),
                    SizedBox(width: 6),
                    Text(
                      'OS 창으로 실행',
                      style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // 2. Launch Virtual OS Dropdown / Menu
          _buildOsLauncherMenu(context),

          const SizedBox(width: 10),

          // 3. Frame Toggle
          IconButton(
            tooltip: showFrame ? '디바이스 프레임 숨기기' : '디바이스 프레임 씌우기',
            icon: Icon(
              showFrame ? CupertinoIcons.device_phone_portrait : CupertinoIcons.square,
              color: showFrame ? const Color(0xFF6366F1) : Colors.white70,
              size: 19,
            ),
            onPressed: onToggleFrame,
          ),

          const SizedBox(width: 6),

          // 4. Export PNG Button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: isExporting
                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(CupertinoIcons.arrow_down_doc_fill, size: 14),
            label: Text(
              isExporting ? '저장 중...' : '캡처 저장',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
            ),
            onPressed: isExporting ? null : onExport,
          ),

          const SizedBox(width: 10),

          // 5. Sign Out / Profile
          PopupMenuButton<String>(
            tooltip: '계정 및 이동',
            icon: const Icon(CupertinoIcons.ellipsis_vertical, color: Colors.white70, size: 18),
            color: const Color(0xFF1E222D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
            ),
            onSelected: (val) {
              if (val == 'home') {
                context.go('/');
              } else if (val == 'signout') {
                onSignOut();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'home',
                child: Row(
                  children: [
                    Icon(CupertinoIcons.house_fill, size: 16, color: Colors.white70),
                    SizedBox(width: 8),
                    Text('메인 홈페이지로', style: TextStyle(color: Colors.white, fontSize: 13)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'signout',
                child: Row(
                  children: [
                    Icon(CupertinoIcons.square_arrow_left, size: 16, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text('로그아웃', style: TextStyle(color: Colors.redAccent, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOsLauncherMenu(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: '원하는 가상 OS로 즉시 전환합니다',
      offset: const Offset(0, 44),
      color: const Color(0xFF141924),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
      ),
      onSelected: onSelectOs,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFF252A36),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: const Row(
          children: [
            Icon(CupertinoIcons.device_desktop, size: 15, color: Color(0xFF67C1F5)),
            SizedBox(width: 6),
            Text('가상 OS로 진입', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            SizedBox(width: 4),
            Icon(CupertinoIcons.chevron_down, size: 12, color: Colors.white54),
          ],
        ),
      ),
      itemBuilder: (context) => [
        _buildPopupItem('windows_11', 'Windows 11', 'assets/images/win11_logo.png', 'Fluent Modern'),
        _buildPopupItem('windows_10', 'Windows 10', 'assets/images/win10_logo.png', 'Metro Desktop'),
        _buildPopupItem('windows_7', 'Windows 7', 'assets/images/win7_logo.png', 'Aero Glass'),
        _buildPopupItem('windows_xp', 'Windows XP', 'assets/images/winxp_logo.png', 'Luna Classic'),
        const PopupMenuDivider(),
        _buildPopupItem('macos_27', 'macOS Sequoia (Golden Gate)', 'assets/images/apple_logo.png', 'Liquid Glass', tintWhite: true),
        _buildPopupItem('steamos', 'SteamOS (Steam Deck)', 'assets/images/steamdeck_icon.png', 'Gaming & Desktop'),
        const PopupMenuDivider(),
        _buildPopupItem('galaxy', 'Samsung Galaxy (One UI 9)', null, 'Android 16', icon: Icons.android_rounded, iconColor: const Color(0xFF3DDC84)),
        _buildPopupItem('ios', 'Apple iPhone 18 (iOS 18)', null, 'Dynamic Island', icon: CupertinoIcons.device_phone_portrait, iconColor: Colors.white70),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupItem(
    String value,
    String title,
    String? asset,
    String subtitle, {
    bool tintWhite = false,
    IconData? icon,
    Color? iconColor,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          if (asset != null)
            Image.asset(asset, width: 18, height: 18, color: tintWhite ? Colors.white : null, fit: BoxFit.contain)
          else if (icon != null)
            Icon(icon, size: 18, color: iconColor ?? Colors.white70)
          else
            const SizedBox(width: 18),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
