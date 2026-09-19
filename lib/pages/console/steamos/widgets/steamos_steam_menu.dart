import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SteamosSteamMenu extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onSwitchToDesktop;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;
  final Function(String osKey)? onSelectOs;

  const SteamosSteamMenu({
    super.key,
    required this.onClose,
    required this.onSwitchToDesktop,
    required this.onOpenTemplate,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
    this.onSelectOs,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      width: 320,
      child: Material(
        color: Colors.transparent,
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F141C).withValues(alpha: 0.94),
                border: Border(
                  right: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1.0,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/steamdeck_icon.png',
                            width: 28,
                            height: 28,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'STEAM',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(CupertinoIcons.xmark, color: Colors.white70, size: 18),
                            onPressed: onClose,
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.white12, height: 1),

                    // Navigation List
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        children: [
                          _buildMenuItem(
                            icon: CupertinoIcons.house_fill,
                            label: '홈 (Home)',
                            onTap: onClose,
                          ),
                          _buildMenuItem(
                            icon: CupertinoIcons.square_stack_3d_up_fill,
                            label: '라이브러리 (Library)',
                            onTap: () {
                              onClose();
                            },
                          ),
                          _buildMenuItem(
                            icon: CupertinoIcons.bag_fill,
                            label: '상점 (Store)',
                            onTap: () {
                              onClose();
                              onOpenTemplate('steam');
                            },
                          ),
                          _buildMenuItem(
                            icon: CupertinoIcons.chat_bubble_2_fill,
                            label: '친구 및 채팅 (Friends)',
                            onTap: () {
                              onClose();
                              onOpenTemplate('steam');
                            },
                          ),
                          _buildMenuItem(
                            icon: CupertinoIcons.gear_alt_fill,
                            label: '설정 (Settings)',
                            onTap: () {
                              onClose();
                              onOpenSettings();
                            },
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(color: Colors.white12, height: 1),
                          ),

                          // Power Actions
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            child: Text(
                              '전원 및 모드 전환 (POWER)',
                              style: TextStyle(
                                color: Color(0xFF67707B),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          _buildMenuItem(
                            imageAsset: 'assets/images/steamdeck_return.png',
                            icon: CupertinoIcons.device_desktop,
                            label: '데스크톱 모드로 전환 (KDE)',
                            badgeText: 'KDE Plasma',
                            onTap: () {
                              onClose();
                              onSwitchToDesktop();
                            },
                          ),
                          if (onSelectOs != null) ...[
                            _buildMenuItem(
                              icon: CupertinoIcons.device_desktop,
                              label: 'Windows 11로 전환',
                              onTap: () {
                                onClose();
                                onSelectOs!('windows_11');
                              },
                            ),
                            _buildMenuItem(
                              icon: CupertinoIcons.device_laptop,
                              label: 'macOS로 전환',
                              onTap: () {
                                onClose();
                                onSelectOs!('macos');
                              },
                            ),
                          ],
                          _buildMenuItem(
                            icon: CupertinoIcons.arrow_left_circle_fill,
                            label: '메인 랜딩 홈으로',
                            onTap: () {
                              onClose();
                              onGoHome();
                            },
                          ),
                          _buildMenuItem(
                            icon: CupertinoIcons.square_arrow_left,
                            label: '로그아웃 (Sign Out)',
                            onTap: () {
                              onClose();
                              onSignOut();
                            },
                          ),
                        ],
                      ),
                    ),

                    // Steam Deck Footer hint
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                        ),
                        child: const Row(
                          children: [
                            Icon(CupertinoIcons.info_circle, color: Color(0xFF1A9FFF), size: 14),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'SteamOS 3.6 Holo / Steam Deck UI',
                                style: TextStyle(color: Colors.white60, fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    IconData? icon,
    String? imageAsset,
    required String label,
    required VoidCallback onTap,
    String? badgeText,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      hoverColor: const Color(0xFF1A9FFF).withValues(alpha: 0.15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            if (imageAsset != null)
              Image.asset(imageAsset, width: 20, height: 20, fit: BoxFit.contain)
            else if (icon != null)
              Icon(icon, color: const Color(0xFF1A9FFF), size: 18),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (badgeText != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A9FFF).withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badgeText,
                  style: const TextStyle(
                    color: Color(0xFF67C1F5),
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
