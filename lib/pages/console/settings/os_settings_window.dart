import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common/os_window_frame.dart';

class OsSettingsWindow extends StatefulWidget {
  final String currentPcTheme;
  final String currentWindowsVersion;
  final String currentMobileTheme;
  final String currentWallpaper;
  final ValueChanged<String> onPcThemeChanged;
  final ValueChanged<String> onWindowsVersionChanged;
  final ValueChanged<String> onMobileThemeChanged;
  final ValueChanged<String> onWallpaperChanged;
  final VoidCallback onClose;
  final VoidCallback onSignOut;
  final User? user;
  final bool isDesktop;

  const OsSettingsWindow({
    super.key,
    required this.currentPcTheme,
    required this.currentWindowsVersion,
    required this.currentMobileTheme,
    required this.currentWallpaper,
    required this.onPcThemeChanged,
    required this.onWindowsVersionChanged,
    required this.onMobileThemeChanged,
    required this.onWallpaperChanged,
    required this.onClose,
    required this.onSignOut,
    this.user,
    this.isDesktop = true,
  });

  @override
  State<OsSettingsWindow> createState() => _OsSettingsWindowState();
}

class _OsSettingsWindowState extends State<OsSettingsWindow> {
  int _selectedTabIndex = 0;

  final List<Map<String, dynamic>> _tabs = const [
    {'title': 'OS 시스템 환경', 'icon': CupertinoIcons.device_desktop},
    {'title': '바탕화면 설정', 'icon': CupertinoIcons.photo_fill_on_rectangle_fill},
    {'title': '사용자 계정', 'icon': CupertinoIcons.person_crop_circle_fill},
    {'title': '시스템 정보', 'icon': CupertinoIcons.info_circle_fill},
  ];

  @override
  Widget build(BuildContext context) {
    final windowStyle = widget.currentPcTheme == 'macos' ? WindowStyle.macos : WindowStyle.windows;

    return OsWindowFrame(
      title: '시스템 설정 (Settings)',
      icon: CupertinoIcons.gear_alt_fill,
      style: windowStyle,
      onClose: widget.onClose,
      width: widget.isDesktop ? 760 : MediaQuery.of(context).size.width * 0.94,
      height: widget.isDesktop ? 530 : MediaQuery.of(context).size.height * 0.82,
      child: Row(
        children: [
          // 좌측 카테고리 사이드바
          Container(
            width: widget.isDesktop ? 190 : 120,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              border: Border(
                right: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
              ),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              itemCount: _tabs.length,
              itemBuilder: (context, index) {
                final tab = _tabs[index];
                final isSelected = _selectedTabIndex == index;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: InkWell(
                    onTap: () => setState(() => _selectedTabIndex = index),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF6366F1).withValues(alpha: 0.3)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.5))
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            tab['icon'] as IconData,
                            size: 16,
                            color: isSelected ? const Color(0xFF818CF8) : Colors.white60,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              tab['title'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white70,
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 우측 메인 설정 패널
          Expanded(
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(20),
              child: _buildTabContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOsSelectionTab();
      case 1:
        return _buildWallpaperTab();
      case 2:
        return _buildAccountTab();
      case 3:
      default:
        return _buildAboutTab();
    }
  }

  // 1. OS 선택 탭
  Widget _buildOsSelectionTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '데스크톱 OS 선택 (PC / 태블릿)',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Windows(7, 10, 11) 및 macOS Sequoia를 선택하면 테스크바, 시작 메뉴, 독 및 창 스타일이 즉각 전환됩니다.',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 14),

          // Windows 버전 선택 (7, 10, 11)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: widget.currentPcTheme == 'windows'
                    ? const Color(0xFF0078D7).withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(CupertinoIcons.device_desktop, color: Color(0xFF0078D7), size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Windows 시리즈',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                    if (widget.currentPcTheme == 'windows')
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0078D7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Windows ${widget.currentWindowsVersion} 사용 중',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildWindowsVersionButton(
                        version: '7',
                        title: 'Windows 7',
                        subtitle: 'Aero Glass & 오브 버튼',
                        defaultWallpaper: 'win7_harmony',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildWindowsVersionButton(
                        version: '10',
                        title: 'Windows 10',
                        subtitle: 'Hero 어두운 테스크바',
                        defaultWallpaper: 'win10_hero',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildWindowsVersionButton(
                        version: '11',
                        title: 'Windows 11',
                        subtitle: 'Fluent 중앙 테스크바',
                        defaultWallpaper: 'win11_bloom',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // macOS 카드
          _buildOsCard(
            id: 'macos',
            title: 'macOS Golden Gate (기본)',
            subtitle: '골든 게이트 브리지 공식 배경화면 & 글래스 독',
            icon: CupertinoIcons.compass,
            color: const Color(0xFFA855F7),
            isSelected: widget.currentPcTheme == 'macos',
            onTap: () {
              widget.onPcThemeChanged('macos');
              widget.onWallpaperChanged('macos_golden_gate');
            },
          ),

          const SizedBox(height: 24),
          const Text(
            '모바일 OS 선택 (스마트폰 환경)',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            '스마트폰 뷰에서 나타날 시스템 상태바 및 홈 제스처 인터페이스입니다.',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildOsCard(
                  id: 'ios',
                  title: 'iPhone (iOS 18)',
                  subtitle: '다이내믹 아일랜드 & 4칸 하단 독',
                  icon: CupertinoIcons.device_phone_portrait,
                  color: const Color(0xFF38BDF8),
                  isSelected: widget.currentMobileTheme == 'ios',
                  onTap: () => widget.onMobileThemeChanged('ios'),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildOsCard(
                  id: 'galaxy',
                  title: 'Galaxy (OneUI 6)',
                  subtitle: '원형 위젯 & 제스처 내비게이션',
                  icon: CupertinoIcons.slider_horizontal_3,
                  color: const Color(0xFF10B981),
                  isSelected: widget.currentMobileTheme == 'galaxy',
                  onTap: () => widget.onMobileThemeChanged('galaxy'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWindowsVersionButton({
    required String version,
    required String title,
    required String subtitle,
    required String defaultWallpaper,
  }) {
    final isSelected = widget.currentPcTheme == 'windows' && widget.currentWindowsVersion == version;

    return InkWell(
      onTap: () {
        widget.onPcThemeChanged('windows');
        widget.onWindowsVersionChanged(version);
        widget.onWallpaperChanged(defaultWallpaper);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF0078D7).withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF0078D7) : Colors.white.withValues(alpha: 0.08),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF60A5FA) : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                if (isSelected)
                  const Icon(CupertinoIcons.checkmark_alt, size: 14, color: Color(0xFF60A5FA)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOsCard({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : Colors.white.withValues(alpha: 0.1),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 22),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '활성 중',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  // 2. 바탕화면 탭
  Widget _buildWallpaperTab() {
    final wallpapers = [
      {
        'id': 'macos_golden_gate',
        'title': 'macOS Golden Gate (기본)',
        'desc': '골든 게이트 브리지 석양 2K WebP 배경화면',
        'asset': 'assets/images/macos_golden_gate.webp',
      },
      {
        'id': 'win10_hero',
        'title': 'Windows 10 Hero (기본)',
        'desc': '창문 빛 레이저 2K WebP 배경화면',
        'asset': 'assets/images/win10_hero.webp',
      },
      {
        'id': 'win11_bloom',
        'title': 'Windows 11 Bloom',
        'desc': '블루 페탈 2K WebP 배경화면',
        'asset': 'assets/images/win11_bloom.webp',
      },
      {
        'id': 'win7_harmony',
        'title': 'Windows 7 Harmony',
        'desc': '클래식 하모니 2K WebP 배경화면',
        'asset': 'assets/images/win7_harmony.webp',
      },
      {
        'id': 'aurora',
        'title': 'macOS Sequoia Aurora',
        'desc': '선명한 오로라 퍼플',
        'asset': null,
      },
      {
        'id': 'minimal_dark',
        'title': 'Dark Titanium',
        'desc': '미니멀 심야 그라데이션',
        'asset': null,
      },
      {
        'id': 'cyberpunk',
        'title': 'Neon Horizon',
        'desc': '네온 사이버 웨이브',
        'asset': null,
      },
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '바탕화면 테마 선택',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            '가상 OS의 배경 이미지를 자유롭게 변경할 수 있습니다. (WebP 경량화 적용)',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: wallpapers.map((w) {
              final isSelected = widget.currentWallpaper == w['id'];
              final assetPath = w['asset'];

              return InkWell(
                onTap: () => widget.onWallpaperChanged(w['id']!),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 230,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF6366F1).withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF6366F1) : Colors.white.withValues(alpha: 0.1),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 85,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          gradient: assetPath == null ? _getWallpaperGradient(w['id'] as String) : null,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: assetPath != null
                            ? Image.asset(assetPath, fit: BoxFit.cover, filterQuality: FilterQuality.medium)
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        w['title'] as String,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        w['desc'] as String,
                        style: const TextStyle(color: Colors.white54, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  LinearGradient _getWallpaperGradient(String id) {
    switch (id) {
      case 'aurora':
        return const LinearGradient(colors: [Color(0xFF1E1B4B), Color(0xFF701A75), Color(0xFF0F172A)]);
      case 'minimal_dark':
        return const LinearGradient(colors: [Color(0xFF0A0B10), Color(0xFF151722), Color(0xFF0A0B10)]);
      case 'cyberpunk':
        return const LinearGradient(colors: [Color(0xFF020617), Color(0xFF4C1D95), Color(0xFFBE185D)]);
      default:
        return const LinearGradient(colors: [Color(0xFF193256), Color(0xFF0F1E38), Color(0xFF090E1A)]);
    }
  }

  // 3. 계정 탭
  Widget _buildAccountTab() {
    final user = widget.user;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '사용자 계정 정보',
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                backgroundColor: const Color(0xFF6366F1),
                child: user?.photoURL == null
                    ? const Icon(CupertinoIcons.person_fill, color: Colors.white, size: 26)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? '게스트 창작자',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'Google 계정 미연결',
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                icon: const Icon(CupertinoIcons.square_arrow_right, size: 14, color: Color(0xFFEF4444)),
                label: const Text('로그아웃', style: TextStyle(color: Color(0xFFEF4444), fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFEF4444)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: widget.onSignOut,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 4. 정보 탭
  Widget _buildAboutTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF38BDF8)]),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(CupertinoIcons.square_stack_3d_up_fill, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('FictionScreen OS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                Text('Version 1.0.0 Production (Build 2027)', style: TextStyle(color: Colors.white54, fontSize: 11)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '크리에이터를 위한 가짜 화면 & 애니메이션 스튜디오',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
              ),
              SizedBox(height: 6),
              Text(
                '유튜브 숏폼, 릴스, 웹툰, 드라마 소품 제작 시 필요한 메신저 및 시스템 화면을 오차 없이 완벽하게 시뮬레이션합니다.\n모든 에셋은 경량화된 WebP로 제공되며, 아이콘은 Cupertino 디자인 가이드를 준수합니다.',
                style: TextStyle(color: Colors.white60, fontSize: 11, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}