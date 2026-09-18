import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// macOS 27 Golden Gate 상단 글로벌 메뉴바
/// - Apple Intelligence "Search or Ask" AI 필 (Siri AI 검색 연동)
/// - Liquid Glass 반투명 블러 머티리얼 & 컨트롤 센터
class Macos27MenuBar extends StatelessWidget {
  final User? user;
  final String timeString;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;
  final VoidCallback? onToggleSpotlight;
  final double glassTransparency;

  const Macos27MenuBar({
    super.key,
    required this.user,
    required this.timeString,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
    this.onToggleSpotlight,
    this.glassTransparency = 0.55,
  });

  @override
  Widget build(BuildContext context) {
    final bgAlpha = (glassTransparency * 0.75).clamp(0.25, 0.85);

    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E).withValues(alpha: bgAlpha),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
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
                    child: Text('이 Mac에 관하여 (macOS 27 Golden Gate)', style: TextStyle(color: Colors.white, fontSize: 12)),
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
                'Finder',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(width: 14),
              _buildMenuItem('파일'),
              _buildMenuItem('편집'),
              _buildMenuItem('보기'),
              _buildMenuItem('이동'),
              _buildMenuItem('윈도우'),
              _buildMenuItem('도움말'),

              const Spacer(),

              // Apple Intelligence "Search or Ask" Spotlight AI 필
              InkWell(
                onTap: onToggleSpotlight ?? onOpenSettings,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF60CDFF).withValues(alpha: 0.45)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFC084FC).withValues(alpha: 0.2),
                        blurRadius: 6,
                        spreadRadius: -1,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.sparkles, size: 11, color: Color(0xFF60CDFF)),
                      SizedBox(width: 5),
                      Text(
                        'Search or Ask',
                        style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),
              const Icon(CupertinoIcons.battery_full, color: Colors.white70, size: 16),
              const SizedBox(width: 10),
              const Icon(CupertinoIcons.wifi, color: Colors.white70, size: 14),
              const SizedBox(width: 10),
              InkWell(
                onTap: onOpenSettings,
                child: const Icon(CupertinoIcons.slider_horizontal_3, color: Colors.white70, size: 14),
              ),
              const SizedBox(width: 14),

              // 날짜 및 시간
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
      child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12)),
    );
  }
}
