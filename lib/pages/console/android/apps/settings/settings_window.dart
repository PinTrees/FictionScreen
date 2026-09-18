import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Samsung One UI 설정 앱
class SamsungSettingsWindow extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback? onOpenSystemSettings;
  final Function(String osKey)? onSelectOs;

  const SamsungSettingsWindow({
    super.key,
    required this.onClose,
    this.onOpenSystemSettings,
    this.onSelectOs,
  });

  void _showOsSelectionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext sheetContext) => CupertinoActionSheet(
        title: const Text('운영체제 (OS) 전환', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        message: const Text('원하시는 모바일 또는 데스크톱 OS 환경으로 즉시 전환합니다.'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(sheetContext);
              onClose();
              onSelectOs?.call('galaxy');
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.device_phone_portrait, size: 20),
                SizedBox(width: 8),
                Text('Samsung Galaxy (One UI 9 최신) ✓'),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(sheetContext);
              onClose();
              onSelectOs?.call('ios');
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.device_phone_portrait, size: 20),
                SizedBox(width: 8),
                Text('Apple iOS 26 (리퀴드 글래스)'),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(sheetContext);
              onClose();
              onSelectOs?.call('windows');
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.device_desktop, size: 20),
                SizedBox(width: 8),
                Text('Microsoft Windows 11'),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(sheetContext);
              onClose();
              onSelectOs?.call('macos');
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.device_laptop, size: 20),
                SizedBox(width: 8),
                Text('Apple macOS Sequoia'),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(sheetContext),
          isDestructiveAction: true,
          child: const Text('취소'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      body: SafeArea(
        child: Column(
          children: [
            // One UI 대형 헤더
            Container(
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF161822),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: onClose,
                        child: const Icon(CupertinoIcons.chevron_left, color: Colors.white, size: 20),
                      ),
                      const Icon(CupertinoIcons.search, color: Colors.white70, size: 18),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '설정',
                    style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // 설정 목록
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSettingCard(
                    title: '운영체제 (OS) 전환',
                    subtitle: 'Galaxy, iOS, Windows, macOS 즉시 전환',
                    icon: CupertinoIcons.arrow_2_circlepath,
                    color: const Color(0xFF10B981),
                    onTap: () => _showOsSelectionSheet(context),
                  ),
                  _buildSettingCard(
                    title: '연결',
                    subtitle: 'Wi-Fi, Bluetooth, 모바일 네트워크',
                    icon: CupertinoIcons.wifi,
                    color: const Color(0xFF3B82F6),
                  ),
                  _buildSettingCard(
                    title: '소리 및 진동',
                    subtitle: '소리 모드, 벨소리, 음량',
                    icon: CupertinoIcons.speaker_2_fill,
                    color: const Color(0xFF10B981),
                  ),
                  _buildSettingCard(
                    title: '디스플레이',
                    subtitle: '밝기, 편안하게 화면 보기, 편의 기능',
                    icon: CupertinoIcons.sun_max_fill,
                    color: const Color(0xFFF59E0B),
                  ),
                  _buildSettingCard(
                    title: '배경화면 및 스타일',
                    subtitle: 'FictionScreen 전역 테마 및 OS 설정',
                    icon: CupertinoIcons.photo_fill_on_rectangle_fill,
                    color: const Color(0xFF8B5CF6),
                    onTap: onOpenSystemSettings,
                  ),
                  _buildSettingCard(
                    title: '배터리 및 기기 케어',
                    subtitle: '저장공간, 메모리, 앱 보호',
                    icon: CupertinoIcons.battery_25,
                    color: const Color(0xFFEC4899),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                  ],
                ),
              ),
              const Icon(CupertinoIcons.chevron_right, color: Colors.white38, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
