import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../apps/screen_template.dart';

class WorkspaceTopBar extends StatelessWidget {
  final ScreenTemplate template;
  final bool isDarkMode;
  final bool isSidebarCollapsed;
  final bool isExporting;
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleSidebar;
  final VoidCallback onExport;
  final VoidCallback onOpenInOs;
  final Function(String osKey) onSelectOs;
  final VoidCallback onSignOut;

  const WorkspaceTopBar({
    super.key,
    required this.template,
    required this.isDarkMode,
    required this.isSidebarCollapsed,
    required this.isExporting,
    required this.onToggleTheme,
    required this.onToggleSidebar,
    required this.onExport,
    required this.onOpenInOs,
    required this.onSelectOs,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkMode ? const Color(0xFF0E121B) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDarkMode ? Colors.white54 : const Color(0xFF64748B);
    final buttonBgColor = isDarkMode ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFF1F5F9);
    final shadowColor = isDarkMode ? Colors.black.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.04);

    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Sidebar Toggle Button
          IconButton(
            tooltip: isSidebarCollapsed ? '사이드바 펼치기' : '사이드바 접기',
            icon: Icon(
              isSidebarCollapsed ? CupertinoIcons.sidebar_left : CupertinoIcons.sidebar_left,
              color: isSidebarCollapsed ? const Color(0xFF6366F1) : textColor.withValues(alpha: 0.8),
              size: 19,
            ),
            onPressed: onToggleSidebar,
            style: IconButton.styleFrom(
              backgroundColor: isSidebarCollapsed ? const Color(0xFF6366F1).withValues(alpha: 0.12) : Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),

          const SizedBox(width: 6),

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
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(CupertinoIcons.sparkles, color: Colors.white, size: 15),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'FictionScreen',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 7),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'CONSOLE',
                      style: TextStyle(
                        color: Color(0xFF6366F1),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 14),
          Text('/', style: TextStyle(color: textSubColor.withValues(alpha: 0.4), fontSize: 16)),
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
                  style: TextStyle(color: textSubColor, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 6),
                Text('›', style: TextStyle(color: textSubColor.withValues(alpha: 0.5), fontSize: 14)),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    template.title,
                    style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13.5),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // 1. Open in Virtual OS Window Button (NO OUTLINE, Smooth Surface Fill)
          Tooltip(
            message: '가상 OS 화면으로 이동하여 이 앱을 플로팅 창으로 실행합니다',
            child: InkWell(
              onTap: onOpenInOs,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.macwindow,
                      size: 14,
                      color: isDarkMode ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'OS 창으로 실행',
                      style: TextStyle(
                        color: isDarkMode ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // 2. Launch Virtual OS Dropdown (NO OUTLINE)
          _buildOsLauncherMenu(context, textColor, buttonBgColor, isDarkMode),

          const SizedBox(width: 10),

          // 3. Theme Toggle (Light / Dark mode, NO OUTLINE)
          IconButton(
            tooltip: isDarkMode ? '라이트 모드로 전환' : '다크 모드로 전환',
            icon: Icon(
              isDarkMode ? CupertinoIcons.sun_max_fill : CupertinoIcons.moon_fill,
              color: isDarkMode ? const Color(0xFFFBBF24) : const Color(0xFF475569),
              size: 18,
            ),
            style: IconButton.styleFrom(
              backgroundColor: buttonBgColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: onToggleTheme,
          ),

          const SizedBox(width: 8),

          // 4. Export PNG Button (Gradient / Solid without outline)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            ),
            icon: isExporting
                ? const SizedBox(width: 13, height: 13, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(CupertinoIcons.arrow_down_doc_fill, size: 14),
            label: Text(
              isExporting ? '저장 중...' : '캡처 저장',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
            ),
            onPressed: isExporting ? null : onExport,
          ),

          const SizedBox(width: 8),

          // 5. More Actions (No Outline Menu)
          PopupMenuButton<String>(
            tooltip: '계정 및 이동',
            icon: Icon(CupertinoIcons.ellipsis_vertical, color: textSubColor, size: 18),
            color: isDarkMode ? const Color(0xFF191F2D) : Colors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (val) {
              if (val == 'home') {
                context.go('/');
              } else if (val == 'signout') {
                onSignOut();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'home',
                child: Row(
                  children: [
                    Icon(CupertinoIcons.house_fill, size: 16, color: textColor.withValues(alpha: 0.7)),
                    const SizedBox(width: 10),
                    Text('메인 홈페이지로', style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const PopupMenuDivider(height: 1),
              const PopupMenuItem(
                value: 'signout',
                child: Row(
                  children: [
                    Icon(CupertinoIcons.square_arrow_left, size: 16, color: Colors.redAccent),
                    SizedBox(width: 10),
                    Text('로그아웃', style: TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOsLauncherMenu(
    BuildContext context,
    Color textColor,
    Color buttonBgColor,
    bool isDarkMode,
  ) {
    return PopupMenuButton<String>(
      tooltip: '원하는 가상 OS로 즉시 전환합니다',
      offset: const Offset(0, 44),
      elevation: 8,
      color: isDarkMode ? const Color(0xFF141924) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      onSelected: onSelectOs,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: buttonBgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(CupertinoIcons.device_desktop, size: 15, color: Color(0xFF6366F1)),
            const SizedBox(width: 7),
            Text(
              '가상 OS로 진입',
              style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 5),
            Icon(CupertinoIcons.chevron_down, size: 11, color: textColor.withValues(alpha: 0.5)),
          ],
        ),
      ),
      itemBuilder: (context) => [
        _buildPopupItem('windows_11', 'Windows 11', 'assets/images/win11_logo.png', 'Fluent Modern', isDarkMode),
        _buildPopupItem('windows_10', 'Windows 10', 'assets/images/win10_logo.png', 'Metro Desktop', isDarkMode),
        _buildPopupItem('windows_7', 'Windows 7', 'assets/images/win7_logo.png', 'Aero Glass', isDarkMode),
        _buildPopupItem('windows_xp', 'Windows XP', 'assets/images/winxp_logo.png', 'Luna Classic', isDarkMode),
        const PopupMenuDivider(height: 1),
        _buildPopupItem('macos_27', 'macOS Sequoia (Golden Gate)', 'assets/images/apple_logo.png', 'Liquid Glass', isDarkMode, tintWhite: isDarkMode),
        _buildPopupItem('steamos', 'SteamOS (Steam Deck)', 'assets/images/steamdeck_icon.png', 'Gaming & Desktop', isDarkMode),
        const PopupMenuDivider(height: 1),
        _buildPopupItem('galaxy', 'Samsung Galaxy (One UI 9)', null, 'Android 16', isDarkMode, icon: Icons.android_rounded, iconColor: const Color(0xFF3DDC84)),
        _buildPopupItem('ios', 'Apple iPhone 18 (iOS 18)', null, 'Dynamic Island', isDarkMode, icon: CupertinoIcons.device_phone_portrait, iconColor: isDarkMode ? Colors.white70 : Colors.black87),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupItem(
    String value,
    String title,
    String? asset,
    String subtitle,
    bool isDarkMode, {
    bool tintWhite = false,
    IconData? icon,
    Color? iconColor,
  }) {
    final titleColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDarkMode ? Colors.white54 : const Color(0xFF64748B);

    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          if (asset != null)
            Image.asset(
              asset,
              width: 18,
              height: 18,
              color: tintWhite ? (isDarkMode ? Colors.white : Colors.black) : null,
              fit: BoxFit.contain,
            )
          else if (icon != null)
            Icon(icon, size: 18, color: iconColor ?? (isDarkMode ? Colors.white70 : Colors.black54))
          else
            const SizedBox(width: 18),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: TextStyle(color: titleColor, fontSize: 12.5, fontWeight: FontWeight.bold)),
              Text(subtitle, style: TextStyle(color: subtitleColor, fontSize: 10.5)),
            ],
          ),
        ],
      ),
    );
  }
}
