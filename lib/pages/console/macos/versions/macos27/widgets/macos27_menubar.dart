import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// macOS 27 Golden Gate 상단 글로벌 메뉴바
/// - 정품 Apple 화이트 로고 (assets/images/apple_logo.webp)
/// - Liquid Glass 네이티브 맥 스타일 애플 드롭다운 메뉴
/// - Apple Intelligence "Search or Ask" AI 필 (Siri AI 검색 연동)
/// - 컨트롤 센터, Wi-Fi, 배터리, 실시간 시계
class Macos27MenuBar extends StatefulWidget {
  final User? user;
  final String timeString;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;
  final VoidCallback? onToggleSpotlight;
  final VoidCallback? onOpenOsSwitch;
  final double glassTransparency;

  const Macos27MenuBar({
    super.key,
    required this.user,
    required this.timeString,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
    this.onToggleSpotlight,
    this.onOpenOsSwitch,
    this.glassTransparency = 0.55,
  });

  @override
  State<Macos27MenuBar> createState() => _Macos27MenuBarState();
}

class _Macos27MenuBarState extends State<Macos27MenuBar> {
  bool _isAppleMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    final bgAlpha = (widget.glassTransparency * 0.75).clamp(0.25, 0.85);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 상단 바 본체
        Container(
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
                  // 정품 Apple 로고 버튼
                  Material(
                    color: _isAppleMenuOpen ? Colors.white.withValues(alpha: 0.22) : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      hoverColor: Colors.white.withValues(alpha: 0.12),
                      onTap: () => setState(() => _isAppleMenuOpen = !_isAppleMenuOpen),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                        child: Image.asset(
                          'assets/images/apple_logo.webp',
                          width: 14,
                          height: 14,
                          color: Colors.white,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
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
                    onTap: widget.onToggleSpotlight ?? widget.onOpenSettings,
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
                    onTap: widget.onOpenSettings,
                    child: const Icon(CupertinoIcons.slider_horizontal_3, color: Colors.white70, size: 14),
                  ),
                  const SizedBox(width: 14),

                  // 실시간 날짜 & 시간
                  Text(
                    widget.timeString,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),

        // macOS 네이티브 Liquid Glass 애플 메뉴 드롭다운
        if (_isAppleMenuOpen) ...[
          // 바깥 영역 클릭 시 닫기
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => setState(() => _isAppleMenuOpen = false),
            ),
          ),
          Positioned(
            top: 34,
            left: 8,
            child: Container(
              width: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.52),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E26).withValues(alpha: 0.88),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.16), width: 0.8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildAppleMenuItem(
                          label: '이 Mac에 관하여',
                          desc: 'macOS 27 Golden Gate',
                          onTap: () {
                            setState(() => _isAppleMenuOpen = false);
                            widget.onOpenSettings();
                          },
                        ),
                        _buildDivider(),
                        _buildAppleMenuItem(
                          label: '시스템 설정...',
                          icon: CupertinoIcons.gear_alt_fill,
                          onTap: () {
                            setState(() => _isAppleMenuOpen = false);
                            widget.onOpenSettings();
                          },
                        ),
                        _buildAppleMenuItem(
                          label: '운영체제 전환...',
                          icon: CupertinoIcons.device_laptop,
                          highlightColor: const Color(0xFF60CDFF),
                          onTap: () {
                            setState(() => _isAppleMenuOpen = false);
                            widget.onOpenOsSwitch?.call();
                          },
                        ),
                        _buildDivider(),
                        _buildAppleMenuItem(
                          label: '랜딩 홈으로 이동',
                          icon: CupertinoIcons.house_fill,
                          onTap: () {
                            setState(() => _isAppleMenuOpen = false);
                            widget.onGoHome();
                          },
                        ),
                        _buildDivider(),
                        _buildAppleMenuItem(
                          label: '로그아웃...',
                          icon: CupertinoIcons.square_arrow_right,
                          highlightColor: const Color(0xFFEF4444),
                          onTap: () {
                            setState(() => _isAppleMenuOpen = false);
                            widget.onSignOut();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      color: Colors.white.withValues(alpha: 0.1),
    );
  }

  Widget _buildAppleMenuItem({
    required String label,
    String? desc,
    IconData? icon,
    Color? highlightColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        hoverColor: const Color(0xFF3B82F6),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 13, color: highlightColor ?? Colors.white70),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: highlightColor ?? Colors.white,
                    fontSize: 12,
                    fontWeight: highlightColor != null ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              if (desc != null)
                Text(
                  desc,
                  style: const TextStyle(color: Colors.white38, fontSize: 10),
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
