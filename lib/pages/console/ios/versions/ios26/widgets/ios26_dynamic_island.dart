import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// iPhone 17/18 Pro iOS 26 다이내믹 아일랜드
class Ios26DynamicIsland extends StatefulWidget {
  final VoidCallback? onTap;

  const Ios26DynamicIsland({super.key, this.onTap});

  @override
  State<Ios26DynamicIsland> createState() => _Ios26DynamicIslandState();
}

class _Ios26DynamicIslandState extends State<Ios26DynamicIsland>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isPlaying = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _isExpanded = !_isExpanded);
        widget.onTap?.call();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: Curves.fastOutSlowIn,
        width: _isExpanded ? 340 : 126,
        height: _isExpanded ? 160 : 35,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(_isExpanded ? 36 : 20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: _isExpanded ? 24 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_isExpanded ? 36 : 20),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _isExpanded ? _buildExpandedContent() : _buildCompactContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        key: const ValueKey('compact'),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: const Color(0xFFFA243C),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(CupertinoIcons.music_note, color: Colors.white, size: 9),
          ),
          Row(
            children: [
              _buildWaveBar(10, const Color(0xFF34C759)),
              const SizedBox(width: 2),
              _buildWaveBar(14, const Color(0xFF34C759)),
              const SizedBox(width: 2),
              _buildWaveBar(8, const Color(0xFF34C759)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaveBar(double height, Color color) {
    return Container(
      width: 3,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1.5),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        key: const ValueKey('expanded'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFA243C), Color(0xFF7928CA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(CupertinoIcons.music_note_2, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Supernova',
                      style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      'aespa — Armageddon',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildWaveBar(12, const Color(0xFF34C759)),
                  const SizedBox(width: 2.5),
                  _buildWaveBar(18, const Color(0xFF34C759)),
                  const SizedBox(width: 2.5),
                  _buildWaveBar(10, const Color(0xFF34C759)),
                ],
              ),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: const LinearProgressIndicator(
                  value: 0.42,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 4),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('1:18', style: TextStyle(color: Colors.white54, fontSize: 10)),
                  Text('-1:45', style: TextStyle(color: Colors.white54, fontSize: 10)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(CupertinoIcons.backward_fill, color: Colors.white, size: 22),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              IconButton(
                icon: Icon(
                  _isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => setState(() => _isPlaying = !_isPlaying),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.forward_fill, color: Colors.white, size: 22),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
