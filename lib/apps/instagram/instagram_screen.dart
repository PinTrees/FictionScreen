import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data/instagram_model.dart';

class InstagramScreen extends StatelessWidget {
  final InstagramConfig config;

  const InstagramScreen({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFFCB045)],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.orange.shade200,
                      child: Text(
                        config.username.isNotEmpty ? config.username[0].toUpperCase() : 'I',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        config.username,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                      ),
                      if (config.location.isNotEmpty)
                        Text(
                          config.location,
                          style: const TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                    ],
                  ),
                ),
                const Icon(CupertinoIcons.ellipsis_vertical, size: 18, color: Colors.black87),
              ],
            ),
          ),
          Container(
            height: 380,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Icon(CupertinoIcons.photo, size: 72, color: Colors.white70),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  config.isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                  color: config.isLiked ? Colors.red : Colors.black87,
                  size: 26,
                ),
                const SizedBox(width: 14),
                const Icon(CupertinoIcons.chat_bubble, size: 24, color: Colors.black87),
                const SizedBox(width: 14),
                const Icon(CupertinoIcons.paperplane, size: 24, color: Colors.black87),
                const Spacer(),
                Icon(
                  config.isSaved ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
                  color: Colors.black87,
                  size: 26,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '좋아요 ${config.likes}개',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.3),
                    children: [
                      TextSpan(
                        text: '${config.username} ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: config.caption),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '댓글 ${config.commentCount}개 모두 보기',
                  style: const TextStyle(color: Colors.black45, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  config.timeAgo,
                  style: const TextStyle(color: Colors.black38, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
