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
        ? const Color(0xCC07090E)
        : const Color(0xEEFFFFFF);
    final borderColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);
    final textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(bottom: BorderSide(color: borderColor, width: 1.0)),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Padding(
            // Tight, modern horizontal padding (Req: "앱바 좌우 패딩 너무 큰데 제거해")
            padding: const EdgeInsets.symmetric(horizontal: 18),
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
                            colors: [Color(0xFF00E5FF), Color(0xFF00B0FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00E5FF).withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(CupertinoIcons.sparkles, color: Colors.white, size: 16),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'FictionScreen',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
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
                  const SizedBox(width: 20),
                  _buildNavLink(HomeI18n.t('navAllEcosystem', isEnglish: isEnglish), onScrollToIconCloud, textColor),
                  const SizedBox(width: 18),
                ],

                // Language Switcher (KO / EN)
                InkWell(
                  onTap: onToggleLanguage,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
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

                const SizedBox(width: 8),

                // Light / Dark Theme Switch (Req: "라이트모드 다크모드 아이콘 안보인다. 수정")
                IconButton(
                  tooltip: isEnglish
                      ? (isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode')
                      : (isDarkMode ? '라이트 모드로 전환' : '다크 모드로 전환'),
                  onPressed: onToggleTheme,
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                    color: isDarkMode ? const Color(0xFFFBBF24) : const Color(0xFF475569),
                    size: 21,
                  ),
                ),

                const SizedBox(width: 14),

                // Auth State & Console Button
                StreamBuilder<User?>(
                  stream: AuthService.authStateChanges,
                  builder: (context, snapshot) {
                    final user = snapshot.data ?? AuthService.currentUser;
                    final isLoggedIn = user != null;

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Req: "로그인 되어있으면 그때는 유저 아이콘 표시해주고, 안되어있을때만 로그인버튼 표시."
                        if (isLoggedIn) ...[
                          Tooltip(
                            message: '${user.displayName ?? user.email ?? "사용자"} (클릭 시 콘솔 이동)',
                            child: InkWell(
                              onTap: () => context.go('/console'),
                              borderRadius: BorderRadius.circular(18),
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: const Color(0xFF00B0FF),
                                backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                                child: user.photoURL == null
                                    ? Text(
                                        (user.displayName?.isNotEmpty == true
                                                ? user.displayName![0]
                                                : (user.email?.isNotEmpty == true ? user.email![0] : 'U'))
                                            .toUpperCase(),
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ] else ...[
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
                        ],

                        // Console Button (Req: "콘솔 시작하기 버튼에 아이콘 제거하고")
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00E5FF), Color(0xFF00B0FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00E5FF).withValues(alpha: 0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: const Color(0xFF003852),
                              shadowColor: Colors.transparent,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 14 : 18,
                                vertical: 0,
                              ),
                              minimumSize: const Size(0, 36),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () => context.go('/console'),
                            child: Text(
                              isLoggedIn
                                  ? HomeI18n.t('virtualOsConsole', isEnglish: isEnglish)
                                  : HomeI18n.t('startConsole', isEnglish: isEnglish),
                              style: const TextStyle(
                                color: Color(0xFF003852),
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
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
    );
  }

  Widget _buildNavLink(String label, VoidCallback onTap, Color textColor) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Text(
          label,
          style: TextStyle(
            color: textColor.withValues(alpha: 0.75),
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}
