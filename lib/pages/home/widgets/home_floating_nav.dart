import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../services/auth_service.dart';

class HomeFloatingNav extends StatelessWidget {
  final bool isMobile;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onScrollToShowcase;
  final VoidCallback onScrollToFeatured;
  final VoidCallback onScrollToIconCloud;

  const HomeFloatingNav({
    super.key,
    required this.isMobile,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onScrollToShowcase,
    required this.onScrollToFeatured,
    required this.onScrollToIconCloud,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkMode
        ? const Color(0xFF0F111A).withValues(alpha: 0.8)
        : Colors.white.withValues(alpha: 0.85);
    final textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 24),
      constraints: const BoxConstraints(maxWidth: 1040),
      height: 56,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withValues(alpha: 0.4) : const Color(0x1A000000),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Brand Logo
                InkWell(
                  onTap: () => context.go('/'),
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(CupertinoIcons.square_stack_3d_up_fill, color: Colors.white, size: 16),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'FictionScreen',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Desktop Navigation Links
                if (!isMobile) ...[
                  _buildNavLink('실시간 체험', onScrollToShowcase, textColor),
                  const SizedBox(width: 22),
                  _buildNavLink('대표 화면 3선', onScrollToFeatured, textColor),
                  const SizedBox(width: 22),
                  _buildNavLink('지원 목록', onScrollToIconCloud, textColor),
                  const SizedBox(width: 20),
                ],

                // Light / Dark Mode Toggle Button (Clean icon button, no outline)
                IconButton(
                  tooltip: isDarkMode ? '라이트 모드로 전환' : '다크 모드로 전환',
                  onPressed: onToggleTheme,
                  icon: Icon(
                    isDarkMode ? CupertinoIcons.sun_max_fill : CupertinoIcons.moon_fill,
                    color: isDarkMode ? const Color(0xFFFBBF24) : const Color(0xFF6366F1),
                    size: 19,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: isDarkMode
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.05),
                    shape: const CircleBorder(),
                  ),
                ),
                const SizedBox(width: 8),

                // Brand Gradient Action Button (No outline)
                StreamBuilder<User?>(
                  stream: AuthService.authStateChanges,
                  builder: (context, snapshot) {
                    final user = snapshot.data ?? AuthService.currentUser;
                    final isLoggedIn = user != null;

                    return Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          minimumSize: const Size(0, 36),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () => context.go('/console'),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isLoggedIn ? '가상 OS 콘솔' : '콘솔 시작하기',
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                            const SizedBox(width: 6),
                            const Icon(CupertinoIcons.arrow_right, size: 13),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavLink(String title, VoidCallback onTap, Color textColor) {
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Text(
        title,
        style: TextStyle(
          color: textColor.withValues(alpha: 0.75),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}
