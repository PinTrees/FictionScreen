import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common/os_app_item.dart';
import 'macos_dock.dart';
import 'macos_menubar.dart';

/// macOS 전용 데스크톱 뷰 레이아웃
class MacosView extends StatelessWidget {
  final User? user;
  final String timeString;
  final String currentWallpaper;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;

  const MacosView({
    super.key,
    required this.user,
    required this.timeString,
    required this.currentWallpaper,
    required this.onOpenTemplate,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. 배경화면
        Positioned.fill(
          child: _buildMacWallpaper(),
        ),

        // 2. 바탕화면 디스크 & 파일 아이콘 (우측 상단)
        Positioned(
          top: 46,
          right: 20,
          child: Column(
            children: [
              OsAppItem(
                title: 'Macintosh HD',
                icon: CupertinoIcons.circle_grid_hex,
                iconColor: const Color(0xFF94A3B8),
                backgroundColor: const Color(0xFF334155).withValues(alpha: 0.4),
                onTap: () {},
              ),
              const SizedBox(height: 12),
              OsAppItem(
                title: '시스템 설정',
                icon: CupertinoIcons.gear_alt_fill,
                iconColor: Colors.white,
                backgroundColor: const Color(0xFF64748B).withValues(alpha: 0.4),
                onTap: onOpenSettings,
              ),
            ],
          ),
        ),

        // 3. 상단 Apple 메뉴바
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: MacosMenuBar(
            user: user,
            timeString: timeString,
            onOpenSettings: onOpenSettings,
            onSignOut: onSignOut,
            onGoHome: onGoHome,
          ),
        ),

        // 4. 하단 플로팅 글래스 독
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: MacosDock(
            onOpenTemplate: onOpenTemplate,
            onOpenSettings: onOpenSettings,
            onGoHome: onGoHome,
          ),
        ),
      ],
    );
  }

  Widget _buildMacWallpaper() {
    switch (currentWallpaper) {
      case 'bloom':
        return Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.0, -0.2),
              radius: 1.2,
              colors: [Color(0xFF193256), Color(0xFF0F1E38), Color(0xFF090E1A)],
            ),
          ),
        );
      case 'minimal_dark':
        return Container(color: const Color(0xFF0D0E15));
      case 'cyberpunk':
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF020617), Color(0xFF4C1D95), Color(0xFFBE185D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      case 'aurora':
      default:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E1B4B), Color(0xFF311042), Color(0xFF0F172A)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 80,
                left: 180,
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFF43F5E).withValues(alpha: 0.16),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 120,
                right: 200,
                child: Container(
                  width: 450,
                  height: 450,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF8B5CF6).withValues(alpha: 0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }
}