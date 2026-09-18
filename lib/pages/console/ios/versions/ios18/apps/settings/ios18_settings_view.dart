import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Apple iOS 18/26 공식 설정 앱
/// - 레퍼런스(media_1789748743696.png) 1:1 픽셀 퍼펙트 구현
/// - 좌측 상단 대형 '설정' 타이틀
/// - 이진교 Apple 계정 프로필 카드 (그라데이션 모노그램 + Apple 계정 제안 레드 배지)
/// - 시스템 연결성 그룹 (에어플레인 모드, Wi-Fi, Bluetooth, 셀룰러, 개인용 핫스팟, 배터리, VPN)
/// - 일반, 배경화면 실시간 교체, 홈 이동, 로그아웃 액션
/// - 하단 플로팅 글래스 검색 캡슐 바 (음성 마이크 아이콘 포함)
class Ios18SettingsView extends StatefulWidget {
  final User? user;
  final String currentWallpaper;
  final Function(String wallpaperKey) onSelectWallpaper;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;
  final VoidCallback onClose;

  const Ios18SettingsView({
    super.key,
    required this.user,
    required this.currentWallpaper,
    required this.onSelectWallpaper,
    required this.onSignOut,
    required this.onGoHome,
    required this.onClose,
  });

  @override
  State<Ios18SettingsView> createState() => _Ios18SettingsViewState();
}

class _Ios18SettingsViewState extends State<Ios18SettingsView> {
  bool _airplaneMode = false;
  bool _wifiEnabled = false;
  bool _bluetoothEnabled = true;
  bool _vpnEnabled = false;
  bool _isWallpaperExpanded = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getMonogram() {
    final name = widget.user?.displayName;
    if (name != null && name.trim().isNotEmpty) {
      final clean = name.trim();
      return clean.length >= 2 ? clean.substring(clean.length - 2) : clean;
    }
    return '진교';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // 1. 설정 스크롤 리스트 (하단 플로팅 검색 바 뒤로 자연스럽게 스크롤)
            Positioned.fill(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 12, bottom: 96, left: 16, right: 16),
                children: [
                  // 상단 대형 '설정' 타이틀
                  const Padding(
                    padding: EdgeInsets.only(left: 4, top: 8, bottom: 14),
                    child: Text(
                      '설정',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),

                  // 1) Apple 계정 프로필 카드
                  _buildProfileCard(),
                  const SizedBox(height: 18),

                  // 2) 시스템 연결성 그룹 (에어플레인 모드 ~ VPN)
                  _buildConnectivityGroup(),
                  const SizedBox(height: 18),

                  // 3) 시스템 일반 & 액션 그룹 (일반, 배경화면, 홈, 로그아웃)
                  _buildSystemActionsGroup(),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // 2. 하단 플로팅 글래스 검색 캡슐 바 (iOS 18 신규 디자인)
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: _buildFloatingSearchBar(),
            ),
          ],
        ),
      ),
    );
  }

  // Apple 계정 프로필 카드 (이진교 + Apple 계정 제안 2 배지)
  Widget _buildProfileCard() {
    final displayName = widget.user?.displayName ?? '이진교';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        children: [
          // 상단 프로필 행
          InkWell(
            onTap: () {},
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // 라벤더/블루 그라데이션 모노그램 아바타
                  Container(
                    width: 58,
                    height: 58,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF8EA3D7), Color(0xFF5B6FA8)],
                      ),
                    ),
                    child: Center(
                      child: widget.user?.photoURL != null
                          ? ClipOval(
                              child: Image.network(
                                widget.user!.photoURL!,
                                width: 58,
                                height: 58,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Text(
                              _getMonogram(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Apple 계정, iCloud 등',
                          style: TextStyle(
                            color: Color(0xFF8E8E93),
                            fontSize: 13.5,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(CupertinoIcons.chevron_right, color: Color(0xFF545458), size: 15),
                ],
              ),
            ),
          ),

          // 세퍼레이터 라인 (텍스트 시작 위치에 인덴트)
          const Divider(height: 0.5, thickness: 0.5, color: Color(0xFF38383A), indent: 88),

          // 하단 'Apple 계정 제안' + 레드 알림 배지 (2)
          InkWell(
            onTap: () {},
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(26)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Row(
                children: [
                  const Text(
                    'Apple 계정 제안',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const Spacer(),
                  // 레드 배지 (2)
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF3B30),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '2',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(CupertinoIcons.chevron_right, color: Color(0xFF545458), size: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 시스템 연결성 그룹 (에어플레인 모드, Wi-Fi, Bluetooth, 셀룰러, 개인용 핫스팟, 배터리, VPN)
  Widget _buildConnectivityGroup() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        children: [
          // 1. 에어플레인 모드 (토글)
          _buildSwitchRow(
            icon: CupertinoIcons.airplane,
            iconBg: const Color(0xFFFF9500),
            title: '에어플레인 모드',
            value: _airplaneMode,
            onChanged: (val) => setState(() => _airplaneMode = val),
          ),
          const Divider(height: 0.5, thickness: 0.5, color: Color(0xFF38383A), indent: 60),

          // 2. Wi-Fi
          _buildNavRow(
            icon: CupertinoIcons.wifi,
            iconBg: const Color(0xFF007AFF),
            title: 'Wi-Fi',
            trailingText: _wifiEnabled ? '켬' : '끔',
            onTap: () => setState(() => _wifiEnabled = !_wifiEnabled),
          ),
          const Divider(height: 0.5, thickness: 0.5, color: Color(0xFF38383A), indent: 60),

          // 3. Bluetooth
          _buildNavRow(
            icon: CupertinoIcons.bluetooth,
            iconBg: const Color(0xFF007AFF),
            title: 'Bluetooth',
            trailingText: _bluetoothEnabled ? '켬' : '끔',
            onTap: () => setState(() => _bluetoothEnabled = !_bluetoothEnabled),
          ),
          const Divider(height: 0.5, thickness: 0.5, color: Color(0xFF38383A), indent: 60),

          // 4. 셀룰러
          _buildNavRow(
            icon: CupertinoIcons.antenna_radiowaves_left_right,
            iconBg: const Color(0xFF34C759),
            title: '셀룰러',
            onTap: () {},
          ),
          const Divider(height: 0.5, thickness: 0.5, color: Color(0xFF38383A), indent: 60),

          // 5. 개인용 핫스팟
          _buildNavRow(
            icon: CupertinoIcons.link,
            iconBg: const Color(0xFF34C759),
            title: '개인용 핫스팟',
            onTap: () {},
          ),
          const Divider(height: 0.5, thickness: 0.5, color: Color(0xFF38383A), indent: 60),

          // 6. 배터리
          _buildNavRow(
            icon: CupertinoIcons.battery_100,
            iconBg: const Color(0xFF34C759),
            title: '배터리',
            onTap: () {},
          ),
          const Divider(height: 0.5, thickness: 0.5, color: Color(0xFF38383A), indent: 60),

          // 7. VPN (토글)
          _buildSwitchRow(
            icon: CupertinoIcons.globe,
            iconBg: const Color(0xFF007AFF),
            title: 'VPN',
            value: _vpnEnabled,
            onChanged: (val) => setState(() => _vpnEnabled = val),
          ),
        ],
      ),
    );
  }

  // 시스템 일반 & 액션 그룹 (일반, 배경화면, 홈, 로그아웃)
  Widget _buildSystemActionsGroup() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        children: [
          // 1. 일반
          _buildNavRow(
            icon: CupertinoIcons.gear_alt_fill,
            iconBg: const Color(0xFF8E8E93),
            title: '일반',
            onTap: () {},
          ),
          const Divider(height: 0.5, thickness: 0.5, color: Color(0xFF38383A), indent: 60),

          // 2. 배경화면 (탭 시 인라인 캐러셀 확장/축소)
          _buildNavRow(
            icon: CupertinoIcons.photo_fill_on_rectangle_fill,
            iconBg: const Color(0xFF007AFF),
            title: '배경화면',
            trailingText: _isWallpaperExpanded ? '접기' : '선택',
            onTap: () => setState(() => _isWallpaperExpanded = !_isWallpaperExpanded),
          ),
          if (_isWallpaperExpanded) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.black26,
              child: SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildWallpaperOption('다크', 'ios18_dark', 'assets/images/ios/wallpapers/ios18_dark.png'),
                    const SizedBox(width: 10),
                    _buildWallpaperOption('라이트', 'ios18_light', 'assets/images/ios/wallpapers/ios18_light.png'),
                    const SizedBox(width: 10),
                    _buildWallpaperOption('아주르 블루', 'ios18_blue', 'assets/images/ios/wallpapers/ios18_blue.jpg'),
                    const SizedBox(width: 10),
                    _buildWallpaperOption('딥 퍼플', 'ios18_purple', 'assets/images/ios/wallpapers/ios18_purple.jpg'),
                    const SizedBox(width: 10),
                    _buildWallpaperOption('앰버 옐로우', 'ios18_yellow', 'assets/images/ios/wallpapers/ios18_yellow.jpg'),
                  ],
                ),
              ),
            ),
          ],
          const Divider(height: 0.5, thickness: 0.5, color: Color(0xFF38383A), indent: 60),

          // 3. FictionScreen 홈으로 이동
          _buildNavRow(
            icon: CupertinoIcons.house_fill,
            iconBg: const Color(0xFF5856D6),
            title: 'FictionScreen 홈으로 이동',
            onTap: widget.onGoHome,
          ),
          const Divider(height: 0.5, thickness: 0.5, color: Color(0xFF38383A), indent: 60),

          // 4. 로그아웃
          _buildNavRow(
            icon: CupertinoIcons.square_arrow_right,
            iconBg: const Color(0xFFFF453A),
            title: '로그아웃',
            titleColor: const Color(0xFFFF453A),
            showChevron: false,
            onTap: widget.onSignOut,
          ),
        ],
      ),
    );
  }

  // 하단 플로팅 글래스 검색 캡슐 바
  Widget _buildFloatingSearchBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E22).withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(CupertinoIcons.search, color: Color(0xFF8E8E93), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 16.5),
                  cursorColor: const Color(0xFF007AFF),
                  decoration: const InputDecoration(
                    hintText: '검색',
                    hintStyle: TextStyle(
                      color: Color(0xFF8E8E93),
                      fontSize: 16.5,
                      fontWeight: FontWeight.normal,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const Icon(CupertinoIcons.mic_fill, color: Color(0xFF8E8E93), size: 18),
            ],
          ),
        ),
      ),
    );
  }

  // 개별 토글 스위치 행
  Widget _buildSwitchRow({
    required IconData icon,
    required Color iconBg,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(7.5),
            ),
            child: Icon(icon, color: Colors.white, size: 19),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.5,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.2,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.82,
            alignment: Alignment.centerRight,
            child: CupertinoSwitch(
              value: value,
              activeTrackColor: const Color(0xFF34C759),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  // 개별 내비게이션 행
  Widget _buildNavRow({
    required IconData icon,
    required Color iconBg,
    required String title,
    String? trailingText,
    Color titleColor = Colors.white,
    bool showChevron = true,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(7.5),
              ),
              child: Icon(icon, color: Colors.white, size: 19),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 16),
              ),
              const SizedBox(width: 6),
            ],
            if (showChevron)
              const Icon(CupertinoIcons.chevron_right, color: Color(0xFF545458), size: 15),
          ],
        ),
      ),
    );
  }

  // 배경화면 옵션 카드
  Widget _buildWallpaperOption(String title, String key, String imageAsset) {
    final isSelected = widget.currentWallpaper == key;

    return GestureDetector(
      onTap: () => widget.onSelectWallpaper(key),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 54,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: isSelected ? const Color(0xFF007AFF) : Colors.white24,
                width: isSelected ? 2.5 : 1,
              ),
              image: DecorationImage(image: AssetImage(imageAsset), fit: BoxFit.cover),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: const Color(0xFF007AFF).withValues(alpha: 0.5),
                    blurRadius: 8,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              color: isSelected ? const Color(0xFF007AFF) : Colors.white70,
              fontSize: 10.5,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
