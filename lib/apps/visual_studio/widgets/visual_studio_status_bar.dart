import 'package:flutter/material.dart';
import '../data/visual_studio_model.dart';

class VisualStudioStatusBar extends StatelessWidget {
  final VisualStudioConfig config;

  const VisualStudioStatusBar({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = config.isDebugging ? const Color(0xFFCA5100) : const Color(0xFF68217A);

    return Container(
      height: 24,
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Icon(
            config.isDebugging ? Icons.bug_report : Icons.check_circle_outline,
            size: 13,
            color: Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            config.isDebugging ? '디버깅 중 (중단점 도달)' : '준비',
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 14),
          const Row(
            children: [
              Icon(Icons.cancel, size: 12, color: Colors.white70),
              SizedBox(width: 3),
              Text('0', style: TextStyle(color: Colors.white, fontSize: 11)),
              SizedBox(width: 8),
              Icon(Icons.warning_amber_rounded, size: 12, color: Colors.white70),
              SizedBox(width: 3),
              Text('0', style: TextStyle(color: Colors.white, fontSize: 11)),
            ],
          ),
          const Spacer(),
          _statusItem('줄 ${config.breakpointLine}, 열 24'),
          _divider(),
          _statusItem('문자 ${config.breakpointLine}'),
          _divider(),
          _statusItem('공백: 4'),
          _divider(),
          _statusItem('UTF-8'),
          _divider(),
          _statusItem('CRLF'),
          _divider(),
          const Row(
            children: [
              Icon(Icons.fork_right, size: 12, color: Colors.white70),
              SizedBox(width: 4),
              Text('main', style: TextStyle(color: Colors.white, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusItem(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 11),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white24,
    );
  }
}
