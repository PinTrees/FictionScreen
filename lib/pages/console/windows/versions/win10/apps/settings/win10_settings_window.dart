import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/win10_window_frame.dart';

/// Windows 10 순정 설정 (Windows Settings) - 클래식 그리드 타일 & 직각 0px 디자인
class Win10SettingsWindow extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final VoidCallback? onOpenSystemSettings;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;
  final bool isMaximized;
  final Function(String osKey)? onSelectOs;

  const Win10SettingsWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onOpenSystemSettings,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 880,
    this.height = 580,
    this.isMaximized = false,
    this.onSelectOs,
  });

  @override
  State<Win10SettingsWindow> createState() => _Win10SettingsWindowState();
}

class _Win10SettingsWindowState extends State<Win10SettingsWindow> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _settingCategories = [
    {'title': '시스템', 'desc': '디스플레이, 소리, 알림, 전원', 'icon': CupertinoIcons.desktopcomputer},
    {'title': '장치', 'desc': 'Bluetooth, 프린터, 마우스', 'icon': CupertinoIcons.device_laptop},
    {'title': '전화', 'desc': 'Android, iPhone 연결', 'icon': CupertinoIcons.device_phone_portrait},
    {'title': '네트워크 및 인터넷', 'desc': 'Wi-Fi, 비행기 모드, VPN', 'icon': CupertinoIcons.wifi},
    {'title': '개인 설정', 'desc': '배경, 잠금 화면, 색', 'icon': CupertinoIcons.paintbrush},
    {'title': '앱', 'desc': '설치된 앱, 기본 앱, 옵션 기능', 'icon': CupertinoIcons.square_grid_2x2},
    {'title': '계정', 'desc': '내 정보, 전자 메일, 동기화', 'icon': CupertinoIcons.person_crop_circle},
    {'title': '시간 및 언어', 'desc': '음성, 지역, 날짜', 'icon': CupertinoIcons.globe},
    {'title': '게임', 'desc': 'Xbox Game Bar, 캡처, 게임 모드', 'icon': CupertinoIcons.game_controller},
    {'title': '접근성', 'desc': '내레이터, 돋보기, 고대비', 'icon': CupertinoIcons.eye},
    {'title': '검색', 'desc': '내 파일 찾기, 사용 권한', 'icon': CupertinoIcons.search},
    {'title': '개인 정보', 'desc': '위치, 카메라, 마이크', 'icon': CupertinoIcons.lock},
    {'title': '업데이트 및 보안', 'desc': 'Windows 업데이트, 복구, 백업', 'icon': CupertinoIcons.arrow_clockwise_circle},
  ];

  @override
  Widget build(BuildContext context) {
    return Win10WindowFrame(
      title: '설정',
      iconAsset: 'assets/images/windows/settings.png',
      width: widget.width,
      height: widget.height,
      isMaximized: widget.isMaximized,
      onClose: widget.onClose,
      onMinimize: widget.onMinimize,
      onMaximize: widget.onMaximize,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Container(
        color: const Color(0xFF1F1F1F),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // 중앙 큰 제목
              const Text(
                'Windows 설정',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Segoe UI',
                ),
              ),
              const SizedBox(height: 16),

              // 설정 검색창
              Container(
                width: 380,
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2B2B2B),
                  border: Border.all(color: const Color(0xFF3F3F46)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (val) => setState(() => _searchQuery = val.trim()),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        decoration: const InputDecoration(
                          hintText: '설정 찾기',
                          hintStyle: TextStyle(color: Colors.white38, fontSize: 12),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const Icon(CupertinoIcons.search, size: 14, color: Color(0xFF0078D7)),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // 설정 카테고리 그리드
              Builder(
                builder: (context) {
                  final filtered = _searchQuery.isEmpty
                      ? _settingCategories
                      : _settingCategories.where((c) {
                          final title = (c['title'] as String).toLowerCase();
                          final desc = (c['desc'] as String).toLowerCase();
                          final q = _searchQuery.toLowerCase();
                          return title.contains(q) || desc.contains(q);
                        }).toList();

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 16,
                      childAspectRatio: 2.8,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final cat = filtered[index];
                      return InkWell(
                        onTap: () {
                          if (cat['title'] == '개인 설정' || cat['title'] == '시스템') {
                            widget.onOpenSystemSettings?.call();
                          }
                        },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B2B2B),
                        border: Border.all(color: const Color(0xFF3A3A3C)),
                      ),
                      child: Row(
                        children: [
                          Icon(cat['icon'], size: 28, color: const Color(0xFF0078D7)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  cat['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  cat['desc'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 10.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    );
                  },
                );
              },
            ),
            ],
          ),
        ),
      ),
    );
  }
}
