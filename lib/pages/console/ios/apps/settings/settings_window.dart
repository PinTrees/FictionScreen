import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// iOS 18 Settings (설정) 앱
class IosSettingsWindow extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback? onOpenSystemSettings;

  const IosSettingsWindow({
    super.key,
    required this.onClose,
    this.onOpenSystemSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 헤더
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  InkWell(
                    onTap: onClose,
                    child: const Icon(CupertinoIcons.chevron_left, color: Color(0xFF007AFF), size: 22),
                  ),
                  const Spacer(),
                  const Text('설정', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const SizedBox(width: 22),
                ],
              ),
            ),

            // iOS 카드 그룹형 설정 목록
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 사용자 프로필
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(12)),
                    child: const Row(
                      children: [
                        CircleAvatar(radius: 24, backgroundColor: Color(0xFF007AFF), child: Text('', style: TextStyle(color: Colors.white, fontSize: 22))),
                        SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Fiction Creator', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('Apple ID, iCloud, 구독', style: TextStyle(color: Colors.white54, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 네트워크 그룹
                  Container(
                    decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        _buildSettingItem('에어플레인 모드', CupertinoIcons.airplane, Colors.orange, isSwitch: true),
                        const Divider(color: Colors.white12, height: 1),
                        _buildSettingItem('Wi-Fi', CupertinoIcons.wifi, const Color(0xFF007AFF), value: 'Fiction_5G'),
                        const Divider(color: Colors.white12, height: 1),
                        _buildSettingItem('Bluetooth', CupertinoIcons.bluetooth, const Color(0xFF007AFF), value: 'Galaxy Buds3 Pro'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 테마 및 OS 설정 그룹
                  Container(
                    decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        _buildSettingItem('배경화면 및 OS 시스템', CupertinoIcons.photo_fill_on_rectangle_fill, Colors.purpleAccent, onTap: onOpenSystemSettings),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, IconData icon, Color iconBg, {String? value, bool isSwitch = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(6)),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14))),
            if (value != null) ...[
              Text(value, style: const TextStyle(color: Colors.white54, fontSize: 13)),
              const SizedBox(width: 6),
            ],
            if (isSwitch)
              CupertinoSwitch(value: false, onChanged: (_) {})
            else
              const Icon(CupertinoIcons.chevron_right, color: Colors.white38, size: 14),
          ],
        ),
      ),
    );
  }
}
