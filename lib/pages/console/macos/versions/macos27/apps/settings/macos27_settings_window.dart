import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../common/os_window_frame.dart';

/// macOS 27 Golden Gate 전용 시스템 설정 창
/// - 좌측 사이드바 카테고리 (계정, 외관, 배경화면, 운영체제 전환 등)
/// - Liquid Glass 투명도 슬라이더
/// - macOS 27 Golden Gate 공식 배경화면 선택기
/// - 운영체제 전환 전용 탭 지원 (macOS 27, Sequoia, Win11, Win10, Win7, Galaxy One UI 9, iOS 18)
class Macos27SettingsWindow extends StatefulWidget {
  final double width;
  final double height;
  final VoidCallback onClose;
  final Function(DragStartDetails) onTitleDragStart;
  final Function(DragUpdateDetails) onTitleDragUpdate;
  final Function(String osKey)? onSelectOs;
  final String currentWallpaper;
  final Function(String wallpaperKey) onWallpaperChanged;
  final double glassTransparency;
  final Function(double val) onGlassTransparencyChanged;
  final User? user;

  const Macos27SettingsWindow({
    super.key,
    required this.width,
    required this.height,
    required this.onClose,
    required this.onTitleDragStart,
    required this.onTitleDragUpdate,
    this.onSelectOs,
    required this.currentWallpaper,
    required this.onWallpaperChanged,
    required this.glassTransparency,
    required this.onGlassTransparencyChanged,
    this.user,
  });

  @override
  State<Macos27SettingsWindow> createState() => _Macos27SettingsWindowState();
}

class _Macos27SettingsWindowState extends State<Macos27SettingsWindow> {
  int _selectedCategoryIndex = 0;
  String _searchQuery = '';

  final List<Map<String, dynamic>> _categories = [
    {'title': '외관 (Appearance)', 'icon': CupertinoIcons.circle_righthalf_fill, 'color': Color(0xFF3B82F6)},
    {'title': '배경화면', 'icon': CupertinoIcons.photo_fill, 'color': Color(0xFF06B6D4)},
    {'title': '운영체제 전환', 'icon': CupertinoIcons.device_laptop, 'color': Color(0xFF8B5CF6)},
    {'title': 'Wi-Fi', 'icon': CupertinoIcons.wifi, 'color': Color(0xFF3B82F6)},
    {'title': '블루투스', 'icon': CupertinoIcons.bluetooth, 'color': Color(0xFF3B82F6)},
    {'title': '사운드', 'icon': CupertinoIcons.speaker_2_fill, 'color': Color(0xFFEF4444)},
    {'title': '디스플레이', 'icon': CupertinoIcons.tv_fill, 'color': Color(0xFF10B981)},
    {'title': '일반', 'icon': CupertinoIcons.gear_alt_fill, 'color': Color(0xFF6B7280)},
  ];

  @override
  Widget build(BuildContext context) {
    return OsWindowFrame(
      title: '시스템 설정',
      icon: CupertinoIcons.gear_alt_fill,
      style: WindowStyle.macos,
      width: widget.width,
      height: widget.height,
      onClose: widget.onClose,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Container(
        color: const Color(0xFF1E1E24),
        child: Row(
          children: [
            // 좌측 사이드바
            _buildSidebar(),

            // 구분선
            Container(width: 1, color: Colors.white.withValues(alpha: 0.08)),

            // 우측 설정 세부 내용
            Expanded(child: _buildMainContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    final displayName = widget.user?.displayName ?? 'Mac 사용자';
    final email = widget.user?.email ?? 'apple_id@fictionscreen.com';

    return Container(
      width: 220,
      color: const Color(0xFF18181F).withValues(alpha: 0.95),
      child: Column(
        children: [
          // 상단 검색창
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Container(
              height: 28,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.search, size: 13, color: Colors.white38),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        hintText: '검색',
                        hintStyle: TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                      onChanged: (val) => setState(() => _searchQuery = val.trim()),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Apple ID 프로필 카드
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFF60CDFF),
                    child: Text(
                      displayName.isNotEmpty ? displayName[0].toUpperCase() : 'M',
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(displayName, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text(email, style: const TextStyle(color: Colors.white38, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 6),

          // 카테고리 목록
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              itemCount: _categories.length,
              itemBuilder: (context, idx) {
                final cat = _categories[idx];
                final isSelected = _selectedCategoryIndex == idx;
                if (_searchQuery.isNotEmpty && !cat['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase())) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.5),
                  child: Material(
                    color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () => setState(() => _selectedCategoryIndex = idx),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white.withValues(alpha: 0.2) : cat['color'],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(cat['icon'] as IconData, size: 12, color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                cat['title'] as String,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.85),
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    final title = _categories[_selectedCategoryIndex]['title'] as String;

    if (title.contains('운영체제 전환')) {
      return _buildOsSwitchContent();
    } else if (title.contains('외관')) {
      return _buildAppearanceContent();
    } else if (title.contains('배경화면')) {
      return _buildWallpaperContent();
    } else {
      return _buildGeneralContent(title);
    }
  }

  /// 운영체제 전환 전용 탭
  Widget _buildOsSwitchContent() {
    final osList = [
      {
        'key': 'macos_27',
        'name': 'macOS 27 Golden Gate',
        'desc': '최신 플래그십 Apple Silicon 전용 OS (Liquid Glass, Siri AI Spotlight)',
        'icon': CupertinoIcons.sparkles,
        'color': Color(0xFF60CDFF),
        'isCurrent': true,
      },
      {
        'key': 'macos_15',
        'name': 'macOS 15 Sequoia',
        'desc': 'macOS 클래식 데스크톱 레거시 모드',
        'icon': CupertinoIcons.device_laptop,
        'color': Color(0xFF38BDF8),
        'isCurrent': false,
      },
      {
        'key': 'windows_11',
        'name': 'Windows 11 Fluent 2.0',
        'desc': '모던 플루언트 디자인, 중앙 시작 메뉴, 윈도우 스냅',
        'icon': Icons.window,
        'color': Color(0xFF0078D4),
        'isCurrent': false,
      },
      {
        'key': 'windows_10',
        'name': 'Windows 10',
        'desc': '클래식 타일 시작 메뉴와 안정적인 생산성 환경',
        'icon': Icons.window,
        'color': Color(0xFF00A4EF),
        'isCurrent': false,
      },
      {
        'key': 'windows_7',
        'name': 'Windows 7 Aero Glass',
        'desc': '에어로 글래스 투명 타이틀바 및 향수의 클래식 UI',
        'icon': Icons.desktop_windows,
        'color': Color(0xFF38BDF8),
        'isCurrent': false,
      },
      {
        'key': 'galaxy',
        'name': 'Samsung Galaxy S26 Ultra (One UI 9)',
        'desc': '최신 One UI 9 모바일 스마트폰 환경 및 멀티페이지 슬라이드',
        'icon': CupertinoIcons.device_phone_portrait,
        'color': Color(0xFF10B981),
        'isCurrent': false,
      },
      {
        'key': 'ios',
        'name': 'Apple iPhone 16 Pro (iOS 18)',
        'desc': 'iOS 모바일 다이내믹 아일랜드 및 Liquid Retina 환경',
        'icon': CupertinoIcons.device_phone_portrait,
        'color': Color(0xFFA855F7),
        'isCurrent': false,
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('운영체제 전환', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text(
          'FictionScreen 가상 환경에서 사용할 운영체제를 선택하세요. 클릭 즉시 해당 OS 환경으로 전환됩니다.',
          style: TextStyle(color: Colors.white54, fontSize: 12),
        ),
        const SizedBox(height: 20),

        ...osList.map((item) {
          final isCurrent = item['isCurrent'] as bool;
          final key = item['key'] as String;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF26262F),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isCurrent ? const Color(0xFF3B82F6) : Colors.white.withValues(alpha: 0.08),
                  width: isCurrent ? 1.5 : 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    if (!isCurrent) {
                      widget.onSelectOs?.call(key);
                      widget.onClose();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: (item['color'] as Color).withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(item['icon'] as IconData, size: 20, color: item['color'] as Color),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 3),
                              Text(item['desc'] as String, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                            ],
                          ),
                        ),
                        if (isCurrent)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xFF3B82F6)),
                            ),
                            child: const Text('현재 사용 중', style: TextStyle(color: Color(0xFF60CDFF), fontSize: 11, fontWeight: FontWeight.bold)),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                            ),
                            child: const Text('전환', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  /// 외관 & Liquid Glass 설정
  Widget _buildAppearanceContent() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('외관 (Appearance)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text('macOS 27 Liquid Glass 디자인 및 창 반투명 효과를 설정합니다.', style: TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 24),

        // Liquid Glass 투명도 슬라이더
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF26262F),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Liquid Glass 투명도', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  Text('${(widget.glassTransparency * 100).toInt()}%', style: const TextStyle(color: Color(0xFF60CDFF), fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Slider(
                value: widget.glassTransparency,
                min: 0.2,
                max: 0.95,
                activeColor: const Color(0xFF3B82F6),
                inactiveColor: Colors.white12,
                onChanged: widget.onGlassTransparencyChanged,
              ),
              const Text(
                'macOS 27 Golden Gate의 새로운 리퀴드 글래스 머티리얼을 반영하여 독(Dock)과 메뉴바의 반투명도를 즉시 조절합니다.',
                style: TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 배경화면 선택
  Widget _buildWallpaperContent() {
    final wallpapers = [
      {'key': 'golden_gate_sunset', 'name': 'Golden Gate Sunset', 'path': 'assets/images/macos/golden_gate/sunset.png'},
      {'key': 'golden_gate_day', 'name': 'Golden Gate Day', 'path': 'assets/images/macos/golden_gate/day.png'},
      {'key': 'golden_gate_evening', 'name': 'Golden Gate Evening', 'path': 'assets/images/macos/golden_gate/evening.png'},
      {'key': 'golden_gate_night', 'name': 'Golden Gate Night', 'path': 'assets/images/macos/golden_gate/night.png'},
      {'key': 'macos_golden_gate', 'name': 'macOS 27 Hero Abstract', 'path': 'assets/images/macos_golden_gate.webp'},
    ];

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('배경화면', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text('macOS 27 Golden Gate 공식 에어리얼 및 그래픽 배경화면을 선택하세요.', style: TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 20),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.4,
          ),
          itemCount: wallpapers.length,
          itemBuilder: (context, idx) {
            final wp = wallpapers[idx];
            final isSelected = widget.currentWallpaper == wp['key'];

            return GestureDetector(
              onTap: () => widget.onWallpaperChanged(wp['key']!),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF3B82F6) : Colors.white.withValues(alpha: 0.1),
                    width: isSelected ? 2.5 : 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(wp['path']!, fit: BoxFit.cover),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          color: Colors.black.withValues(alpha: 0.6),
                          child: Text(
                            wp['name']!,
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      if (isSelected)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Color(0xFF3B82F6), shape: BoxShape.circle),
                            child: const Icon(CupertinoIcons.checkmark, size: 12, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGeneralContent(String title) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(CupertinoIcons.gear, size: 40, color: Colors.white24),
          const SizedBox(height: 12),
          Text('$title 설정', style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 4),
          const Text('추가 옵션은 차후 업데이트될 예정입니다.', style: TextStyle(color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }
}
