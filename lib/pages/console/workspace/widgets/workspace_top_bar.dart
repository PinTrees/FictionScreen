import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../apps/screen_template.dart';
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
  final VoidCallback onOpenProfile;

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
    required this.onOpenProfile,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkMode
        ? const Color(0xCC090B10)
        : const Color(0xCCF8FAFC);
    final textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final buttonBgColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFEDEFEF);
    final User? user = AuthService.currentUser;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: bgColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // 1. Hamburger Sidebar Toggle Icon Button
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

              const SizedBox(width: 10),

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

              // Spacer pushes right elements to the very edge
              const Spacer(),

              // 3. Theme Toggle (Icon only as requested)
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

              const SizedBox(width: 10),

              // 4. Far Right User Profile Avatar (Directly at the right edge)
              Tooltip(
                message: user?.displayName ?? user?.email ?? '사용자 프로필 (클릭하여 설정)',
                child: InkWell(
                  onTap: onOpenProfile,
                  borderRadius: BorderRadius.circular(16),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
