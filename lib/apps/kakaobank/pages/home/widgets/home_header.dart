import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KakaoBankHomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onProfileTap;
  final VoidCallback? onNotificationTap;

  const KakaoBankHomeHeader({
    super.key,
    required this.userName,
    required this.onProfileTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: const Color(0xFF16161A),
      child: Row(
        children: [
          GestureDetector(
            onTap: onProfileTap,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFFFEE500),
                  child: Text('🦁', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 10),
                Text(
                  '$userName의 통장',
                  style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(CupertinoIcons.bell_fill, color: Colors.white70, size: 20),
            onPressed: onNotificationTap,
          ),
        ],
      ),
    );
  }
}
