import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../common/os_window_frame.dart';

/// macOS Maps (지도) 창
class MapsWindow extends StatefulWidget {
  final VoidCallback onClose;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;

  const MapsWindow({
    super.key,
    required this.onClose,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 780,
    this.height = 500,
  });

  @override
  State<MapsWindow> createState() => _MapsWindowState();
}

class _MapsWindowState extends State<MapsWindow> {
  int _selectedCity = 0;

  final List<Map<String, String>> _locations = [
    {
      'name': 'Golden Gate Bridge',
      'city': 'San Francisco, CA',
      'desc': '샌프란시스코의 상징적인 현수교. macOS Golden Gate 테마의 모티브',
      'asset': 'assets/images/macos_golden_gate.webp',
      'lat': '37.8199° N, 122.4783° W',
    },
    {
      'name': 'Apple Park',
      'city': 'Cupertino, CA',
      'desc': 'Apple 본사 링 모양 사옥 및 스티브 잡스 극장',
      'asset': 'assets/images/apple_logo.webp',
      'lat': '37.3346° N, 122.0090° W',
    },
    {
      'name': '강남역 사거리',
      'city': '서울특별시 강남구',
      'desc': '대한민국 IT 스타트업과 미디어 크리에이터들의 허브',
      'asset': 'assets/images/kakaotalk_icon.webp',
      'lat': '37.4979° N, 127.0276° E',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final loc = _locations[_selectedCity];

    return OsWindowFrame(
      title: '지도 - ${loc['name']}',
      style: WindowStyle.macos,
      width: widget.width,
      height: widget.height,
      onClose: widget.onClose,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Column(
        children: [
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
            ),
            child: Row(
              children: [
                Container(
                  width: 240,
                  height: 28,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: const Row(
                    children: [
                      Icon(CupertinoIcons.search, size: 14, color: Colors.white38),
                      SizedBox(width: 8),
                      Text('장소 또는 주소 검색', style: TextStyle(color: Colors.white38, fontSize: 11)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      _buildModeChip('탐색', true),
                      _buildModeChip('대중교통', false),
                      _buildModeChip('위성', false),
                    ],
                  ),
                ),
                const Spacer(),
                const Icon(CupertinoIcons.location_fill, size: 16, color: Color(0xFF38BDF8)),
                const SizedBox(width: 14),
                const Icon(CupertinoIcons.compass, size: 16, color: Colors.white60),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 220,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.02),
                    border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: _locations.length,
                    itemBuilder: (context, index) {
                      final item = _locations[index];
                      final isSelected = _selectedCity == index;

                      return InkWell(
                        onTap: () => setState(() => _selectedCity = index),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF38BDF8).withValues(alpha: 0.2) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF38BDF8).withValues(alpha: 0.5) : Colors.transparent,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(CupertinoIcons.map_pin_ellipse, size: 14, color: Color(0xFFEF4444)),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      item['name']!,
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(item['city']!, style: const TextStyle(color: Colors.white54, fontSize: 10)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        loc['asset']!,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E212B).withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            children: [
                              const Icon(CupertinoIcons.location_solid, size: 28, color: Color(0xFFEF4444)),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(loc['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                    const SizedBox(height: 2),
                                    Text(loc['desc']!, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                                    const SizedBox(height: 2),
                                    Text(loc['lat']!, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildModeChip(String title, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withValues(alpha: 0.18) : Colors.transparent,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white60,
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
