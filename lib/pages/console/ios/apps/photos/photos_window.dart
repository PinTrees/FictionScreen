import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// iOS 18 Photos (사진) 앱
class IosPhotosWindow extends StatefulWidget {
  final VoidCallback onClose;

  const IosPhotosWindow({
    super.key,
    required this.onClose,
  });

  @override
  State<IosPhotosWindow> createState() => _IosPhotosWindowState();
}

class _IosPhotosWindowState extends State<IosPhotosWindow> {
  String? _previewAsset;

  final List<Map<String, String>> _photos = [
    {'title': '골든 게이트 브리지', 'asset': 'assets/images/macos_golden_gate.webp'},
    {'title': 'Windows 11 Bloom', 'asset': 'assets/images/win11_bloom.webp'},
    {'title': 'Windows 10 Hero', 'asset': 'assets/images/win10_hero.webp'},
    {'title': '카카오톡 브랜드 아이콘', 'asset': 'assets/images/kakaotalk_icon.webp'},
    {'title': '인스타그램 스크린샷', 'asset': 'assets/images/instagram_icon.webp'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                    onTap: () {
                      if (_previewAsset != null) {
                        setState(() => _previewAsset = null);
                      } else {
                        widget.onClose();
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(CupertinoIcons.chevron_left, color: Color(0xFF007AFF), size: 20),
                        SizedBox(width: 4),
                        Text('보관함', style: TextStyle(color: Color(0xFF007AFF), fontSize: 16)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Text('사진', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const SizedBox(width: 50),
                ],
              ),
            ),

            // 본문
            Expanded(
              child: _previewAsset != null
                  ? Center(
                      child: Image.asset(_previewAsset!, fit: BoxFit.contain),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemCount: _photos.length,
                      itemBuilder: (context, index) {
                        final item = _photos[index];
                        return InkWell(
                          onTap: () => setState(() => _previewAsset = item['asset']),
                          child: Image.asset(item['asset']!, fit: BoxFit.cover),
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
