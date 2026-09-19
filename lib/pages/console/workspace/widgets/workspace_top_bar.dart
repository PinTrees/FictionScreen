import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../apps/screen_template.dart';
import '../../../../constants/app_platform_icons.dart';
import '../../../../services/auth_service.dart';

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
    // Translucent background with backdrop blur
    final bgColor = isDarkMode
        ? const Color(0xCC090B10)
        : const Color(0xCCF8FAFC);
    final textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDarkMode ? Colors.white54 : const Color(0xFF64748B);
    final buttonBgColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFEDEFEF);
    final User? user = AuthService.currentUser;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: bgColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDarkMode ? 0.35 : 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // 1. Hamburger Sidebar Toggle Icon Button (Req: "좌측 메뉴 열고 닫기는 햄버거 아이콘으로해")
              IconButton(
                tooltip: isSidebarCollapsed ? '사이드바 펼치기' : '사이드바 접기',
                icon: const Icon(CupertinoIcons.bars, size: 21),
                color: isDarkMode ? Colors.white70 : const Color(0xFF334155),
                onPressed: onToggleSidebar,
                style: IconButton.styleFrom(
                  backgroundColor: buttonBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),

              const SizedBox(width: 12),

              // 2. Logo & Brand
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
                            colors: [Color(0xFF00E5FF), Color(0xFF6366F1)],
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
                          fontWeight: FontWeight.w900,
                          fontSize: 15.5,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 7),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00B0FF).withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          'CONSOLE',
                          style: TextStyle(
                            color: Color(0xFF00B0FF),
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

              const SizedBox(width: 16),
              Text('/', style: TextStyle(color: textSubColor.withValues(alpha: 0.35), fontSize: 16)),
              const SizedBox(width: 16),

              // 3. Breadcrumbs
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

              // Pushes all right-side actions to the very far right edge!
              const Spacer(),

              // 4. Right Side Actions (Pushed to the far end edge)
              // OS Window Launch
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

              // OS Direct Launcher Menu
              _buildOsLauncherMenu(context, textColor, buttonBgColor, isDarkMode),

              const SizedBox(width: 10),

              // Theme Toggle
              IconButton(
                tooltip: isDarkMode ? '라이트 모드로 전환' : '다크 모드로 전환',
                icon: Icon(
                  isDarkMode ? CupertinoIcons.sun_max_fill : CupertinoIcons.moon_fill,
                  color: isDarkMode ? const Color(0xFFFBBF24) : const Color(0xFF475569),
                  size: 17,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: buttonBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: onToggleTheme,
              ),

              const SizedBox(width: 8),

              // Export PNG Button
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

              const SizedBox(width: 10),

              // Far Right User Profile / Avatar
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(20),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF00B0FF),
                  backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                  child: user?.photoURL == null
                      ? Text(
                          (user?.displayName?.isNotEmpty == true
                                  ? user!.displayName![0]
                                  : (user?.email?.isNotEmpty == true ? user!.email![0] : 'U'))
                              .toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
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
      tooltip: '가상 OS 바로가기',
      color: isDarkMode ? const Color(0xFF161A23) : Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      offset: const Offset(0, 44),
      onSelected: onSelectOs,
      itemBuilder: (context) {
        return AppPlatformIcons.osList.map((os) {
          return PopupMenuItem<String>(
            value: os.id,
            height: 38,
            child: Row(
              children: [
                Image.asset(os.assetPath, width: 18, height: 18, fit: BoxFit.contain),
                const SizedBox(width: 10),
                Text(
                  os.name,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        decoration: BoxDecoration(
          color: buttonBgColor,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          children: [
            const Icon(CupertinoIcons.desktopcomputer, size: 14, color: Color(0xFF818CF8)),
            const SizedBox(width: 6),
            Text(
              '가상 OS 진입',
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Icon(CupertinoIcons.chevron_down, size: 10, color: textColor.withValues(alpha: 0.6)),
          ],
        ),
      ),
    );
  }
}
