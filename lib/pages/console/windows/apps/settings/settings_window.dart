import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../common/os_window_frame.dart';

/// Windows 11 설정 (Settings) 창
class WindowsSettingsWindow extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback? onOpenSystemSettings;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;

  const WindowsSettingsWindow({
    super.key,
    required this.onClose,
    this.onOpenSystemSettings,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 760,
    this.height = 530,
  });

  @override
  Widget build(BuildContext context) {
    return OsWindowFrame(
      title: '설정',
      icon: CupertinoIcons.gear_alt_fill,
      style: WindowStyle.windows,
      width: width,
      height: height,
      onClose: onClose,
      onTitleDragStart: onTitleDragStart,
      onTitleDragUpdate: onTitleDragUpdate,
      child: Row(
        children: [
          // 좌측 카테고리
          Container(
            width: 180,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
            ),
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                _buildCategory('시스템', CupertinoIcons.device_desktop, isSelected: true),
                _buildCategory('Bluetooth 및 장치', CupertinoIcons.bluetooth),
                _buildCategory('네트워크 및 인터넷', CupertinoIcons.wifi),
                _buildCategory('개인 설정', CupertinoIcons.photo_fill_on_rectangle_fill, onTap: onOpenSystemSettings),
                _buildCategory('앱', CupertinoIcons.square_grid_2x2_fill),
                _buildCategory('계정', CupertinoIcons.person_crop_circle_fill),
              ],
            ),
          ),

          // 우측 내용
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('시스템 설정', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.device_desktop, color: Color(0xFF0078D7), size: 32),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Fiction-Windows-PC', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                              Text('Windows 11 Pro (Build 22631)', style: TextStyle(color: Colors.white54, fontSize: 11)),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: onOpenSystemSettings,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0078D7)),
                          child: const Text('OS 변경 설정', style: TextStyle(color: Colors.white, fontSize: 11)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(String title, IconData icon, {bool isSelected = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0078D7).withValues(alpha: 0.25) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? const Color(0xFF60A5FA) : Colors.white60),
            const SizedBox(width: 10),
            Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
