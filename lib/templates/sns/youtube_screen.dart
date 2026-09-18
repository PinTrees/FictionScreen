import 'package:flutter/material.dart';
import '../../models/youtube_model.dart';

class YoutubeScreen extends StatelessWidget {
  final YoutubeConfig config;

  const YoutubeScreen({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // 1. 영상 플레이어 영역
          Container(
            height: 215,
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 썸네일 배경 그라데이션
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2C3E50), Color(0xFF000000)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 64),
                // 하단 진행바
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    value: 0.35,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                    minHeight: 3,
                  ),
                ),
              ],
            ),
          ),

          // 2. 비디오 상세 정보
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Text(
                  config.title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '조회수 ${config.viewCount} · ${config.uploadTime}',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const SizedBox(height: 12),

                // 채널 바
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.purple.shade300,
                      child: Text(
                        config.channelName.isNotEmpty ? config.channelName[0] : 'Y',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            config.channelName,
                            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Text(
                            config.subscriberCount,
                            style: const TextStyle(color: Colors.black54, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: config.isSubscribed ? const Color(0xFFF2F2F2) : Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        config.isSubscribed ? '구독중' : '구독',
                        style: TextStyle(
                          color: config.isSubscribed ? Colors.black : Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // 댓글 영역
                Row(
                  children: [
                    const Text(
                      '댓글',
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${config.comments.length}',
                      style: const TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                ...config.comments.map((comment) => _buildCommentItem(comment)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(YoutubeComment comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.blueGrey.shade200,
            child: Text(
              comment.author.isNotEmpty ? comment.author[0] : 'U',
              style: const TextStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '@${comment.author}',
                      style: const TextStyle(color: Colors.black54, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      comment.timeAgo,
                      style: const TextStyle(color: Colors.black38, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  comment.text,
                  style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.3),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.thumb_up_outlined, size: 14, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(comment.likes, style: const TextStyle(color: Colors.black54, fontSize: 11)),
                    const SizedBox(width: 16),
                    const Icon(Icons.thumb_down_outlined, size: 14, color: Colors.black54),
                    if (comment.isHearted) ...[
                      const SizedBox(width: 14),
                      const Icon(Icons.favorite, size: 14, color: Colors.red),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
