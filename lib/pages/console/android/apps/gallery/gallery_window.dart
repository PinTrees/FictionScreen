import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Samsung One UI 갤러리 앱
class SamsungGalleryWindow extends StatefulWidget {
  final VoidCallback onClose;

  const SamsungGalleryWindow({
    super.key,
    required this.onClose,
  });

  @override
  State<SamsungGalleryWindow> createState() => _SamsungGalleryWindowState();
}

class _SamsungGalleryWindowState extends State<SamsungGalleryWindow> {
  String? _selectedAsset;

  final List<Map<String, String>> _images = [
    {'title': '골든 게이트 브리지', 'asset': 'assets/images/macos_golden_gate.webp'},
    {'title': 'Windows 11 Bloom', 'asset': 'assets/images/win11_bloom.webp'},
    {'title': 'Windows 10 Hero', 'asset': 'assets/images/win10_hero.webp'},
    {'title': '카카오톡 브랜드', 'asset': 'assets/images/kakaotalk_icon.webp'},
    {'title': '인스타그램 스크린샷', 'asset': 'assets/images/instagram_icon.webp'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10121A),
      body: SafeArea(
        child: Column(
          children: [
            // 헤더
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (_selectedAsset != null) {
                        setState(() => _selectedAsset = null);
                      } else {
                        widget.onClose();
                      }
                    },
                    child: const Icon(CupertinoIcons.chevron_left, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text('갤러리', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const Icon(CupertinoIcons.search, color: Colors.white70, size: 18),
                ],
              ),
            ),

            // 본문
            Expanded(
              child: _selectedAsset != null
                  ? Center(
                      child: Image.asset(_selectedAsset!, fit: BoxFit.contain),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        final item = _images[index];
                        return InkWell(
                          onTap: () => setState(() => _selectedAsset = item['asset']),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(item['asset']!, fit: BoxFit.cover),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
