import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/home_i18n.dart';
import '../../../services/auth_service.dart';

class HomeTopAppBar extends StatelessWidget {
  final bool isMobile;
  final bool isDarkMode;
  final bool isEnglish;
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleLanguage;
  final VoidCallback onScrollToFeatured;
  final VoidCallback onScrollToIconCloud;

  const HomeTopAppBar({
    super.key,
    required this.isMobile,
    required this.isDarkMode,
    required this.isEnglish,
    required this.onToggleTheme,
    required this.onToggleLanguage,
    required this.onScrollToFeatured,
    required this.onScrollToIconCloud,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkMode
        ? const Color(0xFF07090E).withValues(alpha: 0.88)
        : Colors.white.withValues(alpha: 0.92);
    final borderColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.08);
    final textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(bottom: BorderSide(color: borderColor, width: 1.0)),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1240),
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
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
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Navigation Links
                  if (!isMobile) ...[
                    _buildNavLink(HomeI18n.t('navFeatured', isEnglish: isEnglish), onScrollToFeatured, textColor),
                    const SizedBox(width: 24),
                    _buildNavLink(HomeI18n.t('navAllEcosystem', isEnglish: isEnglish), onScrollToIconCloud, textColor),
                    const SizedBox(width: 20),
                  ],

                  // Language Switcher (KO / EN)
                  InkWell(
                    onTap: onToggleLanguage,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'KO',
                            style: TextStyle(
                              color: !isEnglish
                                  ? (isDarkMode ? Colors.white : Colors.black)
                                  : (isDarkMode ? Colors.white38 : Colors.black38),
                              fontSize: 11.5,
                              fontWeight: !isEnglish ? FontWeight.w800 : FontWeight.w500,
                            ),
                          ),
                          Text(
                            ' / ',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white24 : Colors.black26,
                              fontSize: 10.5,
                            ),
                          ),
                          Text(
                            'EN',
                            style: TextStyle(
                              color: isEnglish
                                  ? (isDarkMode ? Colors.white : Colors.black)
                                  : (isDarkMode ? Colors.white38 : Colors.black38),
                              fontSize: 11.5,
                              fontWeight: isEnglish ? FontWeight.w800 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Light / Dark Theme Switch (Icon only, purely black/white palette)
                  IconButton(
                    tooltip: isEnglish
                        ? (isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode')
                        : (isDarkMode ? '라이트 모드로 전환' : '다크 모드로 전환'),
                    onPressed: onToggleTheme,
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    icon: Icon(
                      isDarkMode ? CupertinoIcons.sun_max : CupertinoIcons.moon,
                      color: isDarkMode ? Colors.white : Colors.black,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Auth (Login / Logout) & Console Button
                  StreamBuilder<User?>(
                    stream: AuthService.authStateChanges,
                    builder: (context, snapshot) {
                      final user = snapshot.data ?? AuthService.currentUser;
                      final isLoggedIn = user != null;

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!isLoggedIn) ...[
                            InkWell(
                              onTap: () => context.go('/login'),
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                child: Text(
                                  HomeI18n.t('login', isEnglish: isEnglish),
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ] else ...[
                            InkWell(
                              onTap: () => AuthService.signOut(),
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                child: Text(
                                  HomeI18n.t('logout', isEnglish: isEnglish),
                                  style: TextStyle(
                                    color: textColor.withValues(alpha: 0.65),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],

                          // Brand Gradient Console Button (No outline)
                          Container(
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
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 12 : 16,
                                  vertical: 0,
                                ),
                                minimumSize: const Size(0, 36),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () => context.go('/console'),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    isLoggedIn
                                        ? HomeI18n.t('virtualOsConsole', isEnglish: isEnglish)
                                        : HomeI18n.t('startConsole', isEnglish: isEnglish),
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(CupertinoIcons.arrow_right, size: 12, color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
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
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}
