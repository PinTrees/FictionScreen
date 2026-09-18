import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/win11_window_frame.dart';

/// Windows 11 2열 순정 Fluent 설정(Settings) 앱
class Win11SettingsWindow extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(int layoutType, int zoneIndex)? onSnapLayout;
  final VoidCallback? onOpenSystemSettings;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final Function(String wallpaperKey)? onSelectWallpaper;
  final String currentWallpaper;
  final double width;
  final double height;

  const Win11SettingsWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onSnapLayout,
    this.onOpenSystemSettings,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.onSelectWallpaper,
    this.currentWallpaper = 'win11_bloom',
    this.width = 880,
    this.height = 580,
  });

  @override
  State<Win11SettingsWindow> createState() => _Win11SettingsWindowState();
}

class _Win11SettingsWindowState extends State<Win11SettingsWindow> {
  int _selectedCategoryIndex = 0; // 0: 시스템, 3: 개인 설정, 10: Windows 업데이트
  String _searchQuery = '';
  bool _transparencyEffect = true;
  bool _isNightMode = false;
  String _currentTheme = 'win11_bloom';

  final List<Map<String, dynamic>> _categories = [
    {'title': '시스템', 'icon': CupertinoIcons.device_desktop},
    {'title': 'Bluetooth 및 장치', 'icon': CupertinoIcons.bluetooth},
    {'title': '네트워크 및 인터넷', 'icon': CupertinoIcons.wifi},
    {'title': '개인 설정', 'icon': CupertinoIcons.paintbrush_fill},
    {'title': '앱', 'icon': CupertinoIcons.square_grid_2x2},
    {'title': '계정', 'icon': CupertinoIcons.person_crop_circle},
    {'title': '시간 및 언어', 'icon': CupertinoIcons.globe},
    {'title': '게임', 'icon': CupertinoIcons.gamecontroller_fill},
    {'title': '접근성', 'icon': CupertinoIcons.person_alt},
    {'title': '개인 정보 및 보안', 'icon': CupertinoIcons.shield_fill},
    {'title': 'Windows 업데이트', 'icon': CupertinoIcons.arrow_clockwise},
  ];

  @override
  void initState() {
    super.initState();
    _currentTheme = widget.currentWallpaper;
  }

  void _changeWallpaper(String key) {
    setState(() => _currentTheme = key);
    widget.onSelectWallpaper?.call(key);
  }

  @override
  Widget build(BuildContext context) {
    return Win11WindowFrame(
      title: '설정',
      iconAsset: 'assets/images/windows/settings.png',
      width: widget.width,
      height: widget.height,
      onClose: widget.onClose,
      onMinimize: widget.onMinimize,
      onMaximize: widget.onMaximize,
      onSnapLayout: widget.onSnapLayout,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Row(
        children: [
          // 1. 좌측 1열 네비게이션 패널
          Container(
            width: 240,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              border: Border(
                right: BorderSide(color: Colors.white.withValues(alpha: 0.07)),
              ),
            ),
            child: Column(
              children: [
                // 사용자 계정 프로필 카드
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF0078D7),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/windows/user.png',
                            width: 26,
                            height: 26,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FictionScreen',
                              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '로컬 계정 · 관리자',
                              style: TextStyle(color: Colors.white54, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 설정 검색창
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.search, size: 13, color: Colors.white54),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.white, fontSize: 11.5),
                            decoration: const InputDecoration(
                              hintText: '설정 찾기',
                              hintStyle: TextStyle(color: Colors.white38, fontSize: 11.5),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (val) => setState(() => _searchQuery = val),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // 11대 카테고리 리스트
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final item = _categories[index];
                      final isSelected = _selectedCategoryIndex == index;
                      if (_searchQuery.isNotEmpty && !item['title'].toString().contains(_searchQuery)) {
                        return const SizedBox.shrink();
                      }

                      return InkWell(
                        onTap: () => setState(() => _selectedCategoryIndex = index),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          margin: const EdgeInsets.symmetric(vertical: 1.5),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white.withValues(alpha: 0.08) : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: isSelected
                                ? const Border(left: BorderSide(color: Color(0xFF60A5FA), width: 3))
                                : null,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                item['icon'],
                                size: 16,
                                color: isSelected ? const Color(0xFF60A5FA) : Colors.white70,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                item['title'],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.white70,
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // 2. 우측 2열 상세 설정 본문 패널
          Expanded(
            child: Container(
              color: const Color(0xFF1E212B).withValues(alpha: 0.9),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // 상단 PC 식별 헤더 배너
                  _buildPcBanner(),
                  const SizedBox(height: 24),

                  // 카테고리별 콘텐츠 분기
                  if (_selectedCategoryIndex == 3)
                    _buildPersonalizationSection()
                  else if (_selectedCategoryIndex == 10)
                    _buildWindowsUpdateSection()
                  else
                    _buildSystemSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 상단 PC 배너 (PC 이름, 상태 뱃지)
  Widget _buildPcBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(CupertinoIcons.device_laptop, color: Color(0xFF60A5FA), size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      'DESKTOP-FICTION',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(width: 8),
                    Icon(CupertinoIcons.pencil, color: Colors.white54, size: 14),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'FictionScreen Virtual PC · Windows 11 Pro',
                  style: TextStyle(color: Colors.white54, fontSize: 11.5),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildStatusChip(CupertinoIcons.battery_100, '배터리 94%'),
                    const SizedBox(width: 10),
                    _buildStatusChip(CupertinoIcons.cloud_fill, 'OneDrive 동기화 완료'),
                    const SizedBox(width: 10),
                    _buildStatusChip(CupertinoIcons.checkmark_shield_fill, '최신 상태'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: const Color(0xFF60A5FA)),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  // 개인 설정 (Personalization) - 배경화면 테마 실시간 변경
  Widget _buildPersonalizationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '개인 설정 > 배경 및 테마',
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        const Text(
          '적용할 테마 선택 (클릭 시 바탕화면 즉시 반영)',
          style: TextStyle(color: Colors.white54, fontSize: 12),
        ),
        const SizedBox(height: 12),

        // 테마 프리뷰 카드 그리드
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: [
            _buildThemeCard('Windows 11 (블룸)', 'assets/images/win11_bloom.webp', 'win11_bloom'),
            _buildThemeCard('Windows 10 (히어로)', 'assets/images/win10_hero.webp', 'win10_hero'),
            _buildThemeCard('Windows 7 (하모니)', 'assets/images/win7_harmony.webp', 'win7_harmony'),
            _buildThemeCard('오로라 글로우', null, 'aurora', gradient: const [Color(0xFF1E1B4B), Color(0xFF701A75)]),
            _buildThemeCard('미니멀 다크', null, 'minimal_dark', color: const Color(0xFF0C0E14)),
            _buildThemeCard('사이버펑크 네온', null, 'cyberpunk', gradient: const [Color(0xFF020617), Color(0xFF4C1D95), Color(0xFFBE185D)]),
          ],
        ),
        const SizedBox(height: 24),

        // 추가 설정 항목들
        _buildSettingCard(
          icon: CupertinoIcons.sparkles,
          title: '투명 효과',
          subtitle: '창 및 작업표시줄의 반투명 미카/아크릴 글래스 효과',
          trailing: CupertinoSwitch(
            value: _transparencyEffect,
            activeTrackColor: const Color(0xFF0078D7),
            onChanged: (val) => setState(() => _transparencyEffect = val),
          ),
        ),
        const SizedBox(height: 8),
        _buildSettingCard(
          icon: CupertinoIcons.moon_fill,
          title: '야간 모드 (블루라이트 차단)',
          subtitle: '눈의 피로를 덜어주는 따뜻한 색감 적용',
          trailing: CupertinoSwitch(
            value: _isNightMode,
            activeTrackColor: const Color(0xFF0078D7),
            onChanged: (val) => setState(() => _isNightMode = val),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeCard(String title, String? asset, String key, {List<Color>? gradient, Color? color}) {
    final isSelected = _currentTheme == key;
    return InkWell(
      onTap: () => _changeWallpaper(key),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF60A5FA) : Colors.white.withValues(alpha: 0.12),
            width: isSelected ? 2.5 : 1.0,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (asset != null)
                Image.asset(asset, fit: BoxFit.cover)
              else if (gradient != null)
                Container(decoration: BoxDecoration(gradient: LinearGradient(colors: gradient)))
              else
                Container(color: color ?? Colors.black),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: Colors.black.withValues(alpha: 0.65),
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (isSelected)
                const Positioned(
                  top: 6,
                  right: 6,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Color(0xFF60A5FA),
                    child: Icon(Icons.check, size: 12, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Windows 업데이트 섹션
  Widget _buildWindowsUpdateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF10B981),
                child: Icon(Icons.check, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('현재 최신 상태입니다', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                    SizedBox(height: 2),
                    Text('마지막 확인: 오늘 17:40', style: TextStyle(color: Colors.white54, fontSize: 11.5)),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0078D7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                onPressed: () {},
                child: const Text('업데이트 확인', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingCard(icon: CupertinoIcons.time, title: '업데이트 기록', subtitle: '설치된 보안 업데이트 내역 확인'),
        const SizedBox(height: 8),
        _buildSettingCard(icon: CupertinoIcons.slider_horizontal_3, title: '고급 옵션', subtitle: '전달 최적화, 선택적 업데이트'),
      ],
    );
  }

  // 시스템 섹션 (디스플레이, 사운드, 저장소 등)
  Widget _buildSystemSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '시스템 설정',
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        _buildSettingCard(icon: CupertinoIcons.brightness, title: '디스플레이', subtitle: '밝기, 야간 모드, 배율 100%, 해상도 1920x1080'),
        const SizedBox(height: 8),
        _buildSettingCard(icon: CupertinoIcons.speaker_2_fill, title: '소리', subtitle: '출력 장치, 볼륨 80%, 고급 오디오 설정'),
        const SizedBox(height: 8),
        _buildSettingCard(icon: CupertinoIcons.bell_fill, title: '알림', subtitle: '앱 및 보낸 사람의 알림 켜짐, 방해 금지'),
        const SizedBox(height: 8),
        _buildSettingCard(icon: CupertinoIcons.battery_charging, title: '전원 및 배터리', subtitle: '화면 및 절전 모드, 전원 모드: 균형 잡힘'),
        const SizedBox(height: 8),
        _buildSettingCard(icon: CupertinoIcons.archivebox_fill, title: '저장소', subtitle: '로컬 디스크 C: 256GB 중 120GB 사용 가능'),
        const SizedBox(height: 8),
        _buildSettingCard(icon: CupertinoIcons.info_circle_fill, title: '정보', subtitle: '장치 사양, Windows 11 Pro 버전 24H2 빌드 26100'),
      ],
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF60A5FA)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 11)),
              ],
            ),
          ),
          trailing ?? const Icon(CupertinoIcons.chevron_right, size: 12, color: Colors.white38),
        ],
      ),
    );
  }
}
