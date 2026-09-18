import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/win11_window_frame.dart';

/// Windows 11 순정 Fluent 2열 설정(Settings) 앱
/// 사용자가 제공한 실제 Windows 11 스크린샷 100% 1:1 완벽 반영
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
  final bool isMaximized;

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
    this.isMaximized = false,
  });

  @override
  State<Win11SettingsWindow> createState() => _Win11SettingsWindowState();
}

class _Win11SettingsWindowState extends State<Win11SettingsWindow> {
  int _selectedCategoryIndex = 0; // 0: 시스템, 3: 개인 설정
  String _searchQuery = '';
  String _pcName = 'BOOK-UAQIC6A7S1';
  final String _pcManufacturer = 'SAMSUNG PC';

  // 시스템 세부 설정 상태값
  double _brightness = 75.0;
  bool _nightLight = false;
  double _volume = 68.0;
  bool _notificationsEnabled = true;
  bool _doNotDisturb = false;
  String? _expandedItem; // 클릭해서 펼친 카드 이름

  // 개인 설정 상태값
  String _currentTheme = 'win11_bloom';
  bool _transparencyEffect = true;
  bool _isDarkMode = true;

  // 11개 순정 카테고리 (공식 WebP 3D 아이콘 적용)
  final List<Map<String, String>> _categories = [
    {'title': '시스템', 'icon': 'assets/images/windows/settings/System.webp'},
    {'title': 'Bluetooth 및 장치', 'icon': 'assets/images/windows/settings/Bluetooth_and_devices.webp'},
    {'title': '네트워크 및 인터넷', 'icon': 'assets/images/windows/settings/Network_and_internet.webp'},
    {'title': '개인 설정', 'icon': 'assets/images/windows/settings/Personalisation.webp'},
    {'title': '앱', 'icon': 'assets/images/windows/settings/Apps.webp'},
    {'title': '계정', 'icon': 'assets/images/windows/settings/Accounts.webp'},
    {'title': '시간 및 언어', 'icon': 'assets/images/windows/settings/Time_and_language.webp'},
    {'title': '게임', 'icon': 'assets/images/windows/settings/Gaming.webp'},
    {'title': '접근성', 'icon': 'assets/images/windows/settings/Accessibility.webp'},
    {'title': '개인 정보 및 보안', 'icon': 'assets/images/windows/settings/Privacy_and_security.webp'},
    {'title': 'Windows 업데이트', 'icon': 'assets/images/windows/settings/Windows_Update.webp'},
  ];

  // 시스템 카테고리 항목 목록 (스크린샷 그대로 순서 및 텍스트 100% 일치)
  final List<Map<String, dynamic>> _systemItems = [
    {
      'title': '디스플레이',
      'desc': '모니터, 밝기, 야간 모드, 디스플레이 프로필',
      'icon': CupertinoIcons.device_laptop,
    },
    {
      'title': '소리',
      'desc': '볼륨 레벨, 출력, 입력, 사운드 장치',
      'icon': CupertinoIcons.speaker_2_fill,
    },
    {
      'title': '알림',
      'desc': '앱 및 시스템의 경고, 방해 금지',
      'icon': CupertinoIcons.bell,
    },
    {
      'title': '집중',
      'desc': '방해 요소 줄이기',
      'icon': CupertinoIcons.circle_bottomthird_split,
    },
    {
      'title': '전원 및 배터리',
      'desc': '절전, 배터리 사용, 배터리 절약',
      'icon': CupertinoIcons.power,
    },
    {
      'title': '저장소',
      'desc': '저장소 공간, 드라이브, 구성 규칙',
      'icon': CupertinoIcons.square_stack_3d_up,
    },
    {
      'title': '근거리 공유',
      'desc': '검색 기능, 받은 파일 위치',
      'icon': CupertinoIcons.arrow_up_right_square,
    },
    {
      'title': '멀티태스킹',
      'desc': '스냅 창, 데스크톱, 작업 전환',
      'icon': CupertinoIcons.square_split_2x2,
    },
    {
      'title': '정품 인증',
      'desc': '정품 인증 상태, 구독, 제품 키',
      'icon': CupertinoIcons.checkmark_shield,
    },
    {
      'title': '문제 해결',
      'desc': '권장 문제 해결사, 기본 설정, 기록',
      'icon': CupertinoIcons.wrench,
    },
    {
      'title': '복구',
      'desc': '초기화, 고급 시작 옵션, 돌아가기',
      'icon': CupertinoIcons.arrow_2_circlepath,
    },
    {
      'title': '이 PC에 표시',
      'desc': '권한, 연결 PIN, 검색 가능성',
      'icon': CupertinoIcons.tv,
    },
    {
      'title': '원격 데스크톱',
      'desc': '원격 데스크톱 사용자, 연결 권한',
      'icon': CupertinoIcons.desktopcomputer,
    },
    {
      'title': '클립보드',
      'desc': '잘라내기 및 복사 기록, 동기화, 지우기',
      'icon': CupertinoIcons.doc_on_clipboard,
    },
    {
      'title': '정보',
      'desc': '장치 사양, PC 이름 바꾸기, Windows 사양',
      'icon': CupertinoIcons.info_circle,
    },
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

  void _renamePcDialog() {
    final controller = TextEditingController(text: _pcName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Text('PC 이름 바꾸기', style: TextStyle(color: Colors.white, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '다른 사용자와 장치에서 이 PC를 식별할 이름을 입력하세요.',
              style: TextStyle(color: Colors.white70, fontSize: 12.5),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              cursorColor: const Color(0xFF60CDFF),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Color(0xFF60CDFF)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Color(0xFF60CDFF), width: 1.5),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0067C0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() => _pcName = controller.text.trim());
              }
              Navigator.pop(ctx);
            },
            child: const Text('다음', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _activationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Row(
          children: [
            Icon(CupertinoIcons.checkmark_shield_fill, color: Color(0xFF60CDFF), size: 20),
            SizedBox(width: 8),
            Text('Windows 정품 인증', style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '상태: 정품 인증됨 (디지털 라이선스 사용)',
              style: TextStyle(color: Color(0xFF60CDFF), fontSize: 13, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Microsoft 계정에 연결된 디지털 라이선스를 사용하여 Windows 11이 정품 인증되었습니다.',
              style: TextStyle(color: Colors.white70, fontSize: 12.5),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0067C0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('확인', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Win11WindowFrame(
      title: '설정',
      iconAsset: 'assets/images/windows/settings/System.webp',
      width: widget.width,
      height: widget.height,
      isMaximized: widget.isMaximized,
      onClose: widget.onClose,
      onMinimize: widget.onMinimize,
      onMaximize: widget.onMaximize,
      onSnapLayout: widget.onSnapLayout,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      // 스크린샷과 동일한 상단 뒤로가기 화살표 및 "설정" 타이틀
      customTitleWidget: Row(
        children: [
          const SizedBox(width: 8),
          InkWell(
            onTap: _selectedCategoryIndex != 0
                ? () => setState(() {
                      _selectedCategoryIndex = 0;
                      _expandedItem = null;
                    })
                : null,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Icon(
                CupertinoIcons.arrow_left,
                size: 13,
                color: _selectedCategoryIndex != 0 ? Colors.white : Colors.white30,
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            '설정',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. 좌측 1열 네비게이션 패널
          _buildLeftSidebar(),

          // 2. 우측 2열 메인 상세 콘텐츠 (시스템 / 개인 설정 등)
          Expanded(child: _buildRightContent()),
        ],
      ),
    );
  }

  /// 좌측 1열 네비게이션 사이드바 (프로필 카드 + 설정 검색 + 11개 카테고리)
  Widget _buildLeftSidebar() {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.015),
        border: Border(
          right: BorderSide(color: Colors.white.withValues(alpha: 0.07)),
        ),
      ),
      child: Column(
        children: [
          // 사용자 계정 프로필 카드 (스크린샷 그대로)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Icon(
                      CupertinoIcons.person_fill,
                      size: 26,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'P',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        '로컬 계정',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 설정 검색창 (스크린샷과 동일하게 우측에 돋보기 아이콘, Fluent 통합 디자인)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: SizedBox(
              height: 32,
              child: TextField(
                style: const TextStyle(color: Colors.white, fontSize: 12.5),
                cursorColor: const Color(0xFF60CDFF),
                cursorHeight: 14,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: const Color(0xFF282828),
                  hoverColor: const Color(0xFF303030),
                  hintText: '설정 검색',
                  hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.09)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.09)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFF60CDFF), width: 1.5),
                  ),
                  suffixIcon: const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(CupertinoIcons.search, size: 14, color: Colors.white54),
                  ),
                  suffixIconConstraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                ),
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 11개 순정 카테고리 목록
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategoryIndex == index;

                // 검색어 필터링
                if (_searchQuery.isNotEmpty && !cat['title']!.toLowerCase().contains(_searchQuery.toLowerCase())) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.5),
                  child: Material(
                    color: isSelected ? Colors.white.withValues(alpha: 0.06) : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      hoverColor: Colors.white.withValues(alpha: 0.04),
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                          _expandedItem = null;
                        });
                      },
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.only(left: 4, right: 10),
                        child: Row(
                          children: [
                            // 활성화 인디케이터 (하늘색 세로 바)
                            Container(
                              width: 3,
                              height: 16,
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF60CDFF) : Colors.transparent,
                                borderRadius: BorderRadius.circular(1.5),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // 순정 WebP 3D 아이콘
                            Image.asset(
                              cat['icon']!,
                              width: 20,
                              height: 20,
                              errorBuilder: (_, _, _) => const Icon(CupertinoIcons.app, size: 18, color: Colors.white70),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                cat['title']!,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.86),
                                  fontSize: 12.5,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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

  /// 우측 메인 콘텐츠 분기
  Widget _buildRightContent() {
    switch (_selectedCategoryIndex) {
      case 0: // 시스템 (스크린샷 100% 동일)
        return _buildSystemView();
      case 3: // 개인 설정 (배경화면 실시간 변경)
        return _buildPersonalizationView();
      default:
        return _buildGenericCategoryView(_categories[_selectedCategoryIndex]['title']!);
    }
  }

  /// 스크린샷과 100% 동일한 '시스템' 화면
  Widget _buildSystemView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 대형 카테고리 타이틀 "시스템"
          const Text(
            '시스템',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),

          // 2. 노트북 썸네일 + PC 정보 + 우측 상태 칩 (Microsoft 365, OneDrive, Windows 업데이트)
          _buildDeviceTopBanner(),
          const SizedBox(height: 18),

          // 3. "Windows가 정품 인증되지 않았습니다." 안내 배너 카드
          _buildActivationNoticeCard(),
          const SizedBox(height: 16),

          // 4. 시스템 설정 타일 목록 (디스플레이, 소리, 알림, 집중, 전원, 저장소 등)
          ..._systemItems.map((item) => _buildSystemCard(item)),
        ],
      ),
    );
  }

  /// 노트북 이미지 + PC 스펙 + 3개 상태 칩 배너
  Widget _buildDeviceTopBanner() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 노트북 미리보기 그래픽 (Windows 11 Bloom 화면)
        _buildLaptopMockup(),
        const SizedBox(width: 16),

        // PC 이름, 제조사, 이름 바꾸기 링크
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _pcName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _pcManufacturer,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                InkWell(
                  onTap: _renamePcDialog,
                  child: const Text(
                    '이름 바꾸기',
                    style: TextStyle(
                      color: Color(0xFF60CDFF),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (widget.onOpenSystemSettings != null) ...[
                  const Text('  ·  ', style: TextStyle(color: Colors.white38, fontSize: 11)),
                  InkWell(
                    onTap: widget.onOpenSystemSettings,
                    child: const Text(
                      'OS 모드 변경',
                      style: TextStyle(
                        color: Color(0xFF60CDFF),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),

        const Spacer(),

        // 우측 3개 서비스 상태 (Microsoft 365, OneDrive, Windows 업데이트)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildServiceChip(
              customIcon: _buildMicrosoftLogo(),
              title: 'Microsoft 365',
              subtext: '혜택 보기',
              subtextColor: Colors.white54,
            ),
            const SizedBox(width: 24),
            _buildServiceChip(
              iconData: CupertinoIcons.cloud_fill,
              iconColor: const Color(0xFF0078D4),
              title: 'OneDrive',
              subtext: '· 로그인',
              subtextColor: const Color(0xFF60CDFF),
            ),
            const SizedBox(width: 24),
            _buildServiceChip(
              customIcon: Stack(
                children: [
                  const Icon(CupertinoIcons.arrow_clockwise_circle_fill, size: 20, color: Color(0xFF0078D4)),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF59E0B),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              title: 'Windows 업데이트',
              subtext: '· 주의 필요',
              subtextColor: const Color(0xFFF59E0B),
            ),
          ],
        ),
      ],
    );
  }

  /// 세련된 초소형 다크 노트북 프레임 목업 (블룸 배경화면 표시)
  Widget _buildLaptopMockup() {
    return SizedBox(
      width: 108,
      height: 72,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // 노트북 상판 화면
          Container(
            width: 96,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: const Color(0xFF383838), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Image.asset(
                'assets/images/win11_bloom.webp',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 노트북 하판 베이스
          Positioned(
            bottom: 4,
            child: Container(
              width: 106,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFF333333),
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: const Color(0xFF4A4A4A), width: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 4색 마이크로소프트 로고
  Widget _buildMicrosoftLogo() {
    return SizedBox(
      width: 16,
      height: 16,
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(color: const Color(0xFFF25022)),
          Container(color: const Color(0xFF7FBA00)),
          Container(color: const Color(0xFF00A4EF)),
          Container(color: const Color(0xFFFFB900)),
        ],
      ),
    );
  }

  /// 서비스 상태 칩 (Microsoft 365, OneDrive, Windows 업데이트)
  Widget _buildServiceChip({
    Widget? customIcon,
    IconData? iconData,
    Color? iconColor,
    required String title,
    required String subtext,
    required Color subtextColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (customIcon != null) customIcon else Icon(iconData, size: 20, color: iconColor),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              subtext,
              style: TextStyle(
                color: subtextColor,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// "Windows가 정품 인증되지 않았습니다." 알림 배너
  Widget _buildActivationNoticeCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFF282828),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          const Icon(CupertinoIcons.info_circle_fill, size: 16, color: Color(0xFF60CDFF)),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Windows가 정품 인증되지 않았습니다.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.5,
              ),
            ),
          ),
          InkWell(
            onTap: _activationDialog,
            child: const Text(
              '지금 정품 인증',
              style: TextStyle(
                color: Color(0xFF60CDFF),
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 시스템 설정 개별 카드 (클릭 시 토글/슬라이더 등 대화형 기능 펼침)
  Widget _buildSystemCard(Map<String, dynamic> item) {
    final title = item['title'] as String;
    final desc = item['desc'] as String;
    final icon = item['icon'] as IconData;
    final isExpanded = _expandedItem == title;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF262626),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isExpanded ? const Color(0xFF60CDFF).withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Column(
          children: [
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                hoverColor: Colors.white.withValues(alpha: 0.04),
                onTap: () {
                  setState(() {
                    _expandedItem = isExpanded ? null : title;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Icon(icon, size: 18, color: Colors.white70),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              desc,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        isExpanded ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_right,
                        size: 13,
                        color: Colors.white38,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 펼쳤을 때 대화형 설정 패널
            if (isExpanded) _buildExpandedContent(title),
          ],
        ),
      ),
    );
  }

  /// 카드 클릭 시 펼쳐지는 실제 인터랙티브 컨트롤 패널
  Widget _buildExpandedContent(String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(50, 6, 20, 14),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Builder(
        builder: (context) {
          if (title == '디스플레이') {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('밝기', style: TextStyle(color: Colors.white, fontSize: 12)),
                    const Spacer(),
                    Text('${_brightness.toInt()}%', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF60CDFF),
                    thumbColor: Colors.white,
                    trackHeight: 3,
                  ),
                  child: Slider(
                    value: _brightness,
                    min: 0,
                    max: 100,
                    onChanged: (val) => setState(() => _brightness = val),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('야간 모드 (따뜻한 색상 표시)', style: TextStyle(color: Colors.white, fontSize: 12)),
                    CupertinoSwitch(
                      value: _nightLight,
                      activeTrackColor: const Color(0xFF0067C0),
                      onChanged: (val) => setState(() => _nightLight = val),
                    ),
                  ],
                ),
              ],
            );
          } else if (title == '소리') {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('마스터 볼륨', style: TextStyle(color: Colors.white, fontSize: 12)),
                    const Spacer(),
                    Text('${_volume.toInt()}%', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF60CDFF),
                    thumbColor: Colors.white,
                    trackHeight: 3,
                  ),
                  child: Slider(
                    value: _volume,
                    min: 0,
                    max: 100,
                    onChanged: (val) => setState(() => _volume = val),
                  ),
                ),
              ],
            );
          } else if (title == '알림') {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('앱 및 시스템 알림 받기', style: TextStyle(color: Colors.white, fontSize: 12)),
                    CupertinoSwitch(
                      value: _notificationsEnabled,
                      activeTrackColor: const Color(0xFF0067C0),
                      onChanged: (val) => setState(() => _notificationsEnabled = val),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('방해 금지 모드 자동 켜기', style: TextStyle(color: Colors.white, fontSize: 12)),
                    CupertinoSwitch(
                      value: _doNotDisturb,
                      activeTrackColor: const Color(0xFF0067C0),
                      onChanged: (val) => setState(() => _doNotDisturb = val),
                    ),
                  ],
                ),
              ],
            );
          } else if (title == '정보') {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('장치 이름', _pcName),
                _buildInfoRow('프로세서', '13th Gen Intel(R) Core(TM) i7-1360P 2.20 GHz'),
                _buildInfoRow('설치된 RAM', '16.0 GB (15.7 GB 사용 가능)'),
                _buildInfoRow('시스템 종류', '64비트 운영 체제, x64 기반 프로세서'),
                const Divider(color: Colors.white12, height: 16),
                _buildInfoRow('에디션', 'Windows 11 Home'),
                _buildInfoRow('버전', '23H2'),
                _buildInfoRow('OS 빌드', '22631.3880'),
              ],
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                '이 설정 옵션은 FictionScreen 가상 Windows 환경에서 최적화되어 작동합니다.',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11.5),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11.5)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  /// 개인 설정 화면 (실제 바탕화면 배경 즉시 변경)
  Widget _buildPersonalizationView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '개인 설정',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),

          // 현재 테마 미리보기 배너
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              image: const DecorationImage(
                image: AssetImage('assets/images/win11_bloom_dark.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomLeft,
              child: const Text(
                '적용할 테마를 선택하세요',
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Windows 순정 테마 (클릭 시 바탕화면 실시간 반영)',
            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // 테마 선택 그리드
          Row(
            children: [
              _buildThemeCard('Windows (라이트)', 'win11_bloom', const Color(0xFF4A90E2)),
              const SizedBox(width: 12),
              _buildThemeCard('Windows (다크)', 'win11_dark', const Color(0xFF1E293B)),
              const SizedBox(width: 12),
              _buildThemeCard('Glow (네온 바이올렛)', 'glow', const Color(0xFF8B5CF6)),
              const SizedBox(width: 12),
              _buildThemeCard('Flow (시안 블루)', 'flow', const Color(0xFF06B6D4)),
              const SizedBox(width: 12),
              _buildThemeCard('Sunrise (일출)', 'sunrise', const Color(0xFFF97316)),
            ],
          ),
          const SizedBox(height: 24),

          // 투명 효과 & 다크 모드 스위치
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF262626),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.sparkles, size: 18, color: Colors.white70),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('투명 효과 (Mica Acrylic Glass)', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                            Text('창과 표면에 반투명 블러 효과를 적용합니다', style: TextStyle(color: Colors.white54, fontSize: 11.5)),
                          ],
                        ),
                      ),
                      CupertinoSwitch(
                        value: _transparencyEffect,
                        activeTrackColor: const Color(0xFF0067C0),
                        onChanged: (val) => setState(() => _transparencyEffect = val),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.moon_fill, size: 18, color: Colors.white70),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('모드 선택 (다크 모드)', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                            Text('앱 및 시스템 전반에 다크 테마를 적용합니다', style: TextStyle(color: Colors.white54, fontSize: 11.5)),
                          ],
                        ),
                      ),
                      CupertinoSwitch(
                        value: _isDarkMode,
                        activeTrackColor: const Color(0xFF0067C0),
                        onChanged: (val) => setState(() => _isDarkMode = val),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard(String title, String key, Color previewColor) {
    final isSelected = _currentTheme == key;
    return Expanded(
      child: GestureDetector(
        onTap: () => _changeWallpaper(key),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? const Color(0xFF60CDFF) : Colors.white.withValues(alpha: 0.1),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
                  color: previewColor,
                  image: key == 'win11_bloom'
                      ? const DecorationImage(
                          image: AssetImage('assets/images/win11_bloom_light.jpg'),
                          fit: BoxFit.cover,
                        )
                      : (key == 'win11_dark'
                          ? const DecorationImage(
                              image: AssetImage('assets/images/win11_bloom_dark.jpg'),
                              fit: BoxFit.cover,
                            )
                          : null),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                color: const Color(0xFF262626),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF60CDFF) : Colors.white70,
                    fontSize: 10.5,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 기타 카테고리 뷰
  Widget _buildGenericCategoryView(String title) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF262626),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      _categories[_selectedCategoryIndex]['icon']!,
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      '$title 설정 구성',
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Windows 11 $title 기능을 가상 환경에서 시뮬레이션하고 있습니다. 상단의 시스템 또는 개인 설정을 선택하여 실제 배경화면과 기기 옵션을 제어할 수 있습니다.',
                  style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
