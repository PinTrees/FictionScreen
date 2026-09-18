import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// macOS 상단 글로벌 메뉴바
class MacosMenuBar extends StatelessWidget {
  final User? user;
  final String timeString;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;

  const MacosMenuBar({
    super.key,
    required this.user,
    required this.timeString,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E).withValues(alpha: 0.75),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Row(
            children: [
              // 애플 로고 메뉴
              PopupMenuButton<String>(
                offset: const Offset(0, 24),
                color: const Color(0xFF1E212B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.white12),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text('', style: TextStyle(color: Colors.white, fontSize: 16, height: 1)),
                ),
                onSelected: (val) {
                  if (val == 'settings') onOpenSettings();
                  if (val == 'signout') onSignOut();
                  if (val == 'home') onGoHome();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'about',
                    child: Text('이 Mac에 관하여 (FictionScreen)', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.gear_alt_fill, size: 14, color: Colors.white70),
                        SizedBox(width: 8),
                        Text('시스템 설정...', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'home',
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.house_fill, size: 14, color: Colors.white70),
                        SizedBox(width: 8),
                        Text('랜딩 홈으로 이동', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'signout',
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.square_arrow_right, size: 14, color: Color(0xFFEF4444)),
                        SizedBox(width: 8),
                        Text('로그아웃...', style: TextStyle(color: Color(0xFFEF4444), fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              const Text(
                'FictionScreen',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(width: 14),
              _buildMenuItem('파일'),
              _buildMenuItem('편집'),
              _buildMenuItem('보기'),
              _buildMenuItem('창'),
              _buildMenuItem('도움말'),

              const Spacer(),

              // 우측 상태 아이콘들
              const Icon(CupertinoIcons.battery_full, color: Colors.white70, size: 16),
              const SizedBox(width: 10),
              const Icon(CupertinoIcons.wifi, color: Colors.white70, size: 14),
              const SizedBox(width: 10),
              const Icon(CupertinoIcons.search, color: Colors.white70, size: 14),
              const SizedBox(width: 10),
              InkWell(
                onTap: onOpenSettings,
                child: const Icon(CupertinoIcons.slider_horizontal_3, color: Colors.white70, size: 14),
              ),
              const SizedBox(width: 14),

              // 시계
              Text(
                timeString,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }
}