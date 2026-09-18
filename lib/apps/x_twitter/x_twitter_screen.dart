import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data/x_twitter_model.dart';

class XTwitterScreen extends StatelessWidget {
  final XTwitterConfig config;
  final VoidCallback? onTapPost;

  const XTwitterScreen({
    super.key,
    required this.config,
    this.onTapPost,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = config.isDark ? Colors.black : Colors.white;
    final textColor = config.isDark ? Colors.white : Colors.black;
    final subTextColor = config.isDark ? const Color(0xFF71767B) : const Color(0xFF536471);
    final borderColor = config.isDark ? const Color(0xFF2F3336) : const Color(0xFFEFF3F4);

    return Container(
      color: bgColor,
      child: Column(
        children: [
          // 1. 상단 X 헤더
          Container(
            padding: const EdgeInsets.fromLTRB(16, 36, 16, 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor, width: 0.8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(CupertinoIcons.back, size: 20, color: Colors.white),
                Text(
                  '포스트',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Icon(CupertinoIcons.ellipsis, size: 20, color: textColor),
              ],
            ),
          ),

          // 2. 메인 포스트 카드 (터치 시 수정)
          Expanded(
            child: GestureDetector(
              onTap: onTapPost,
              behavior: HitTestBehavior.opaque,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 작성자 정보
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: const Color(0xFF1D9BF0),
                        child: Text(
                          config.displayName.isNotEmpty ? config.displayName[0] : 'X',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    config.displayName,
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                if (config.isVerified) ...[
                                  const SizedBox(width: 4),
                                  const Icon(CupertinoIcons.checkmark_seal_fill, size: 16, color: Color(0xFF1D9BF0)),
                                ],
                              ],
                            ),
                            Text(
                              '@${config.username}',
                              style: TextStyle(
                                color: subTextColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: textColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '팔로우',
                          style: TextStyle(
                            color: bgColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 본문
                  Text(
                    config.tweetText,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      height: 1.4,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 게시 시간 & 조회수
                  Text(
                    '${config.postTime} · 조회 ${config.views}회',
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Divider(color: borderColor, height: 1),
                  const SizedBox(height: 12),

                  // 리포스트 / 좋아요 / 북마크 카운트 바
                  Row(
                    children: [
                      _buildMetricText(config.retweets, '재게시', textColor, subTextColor),
                      const SizedBox(width: 14),
                      _buildMetricText(config.quotes, '인용', textColor, subTextColor),
                      const SizedBox(width: 14),
                      _buildMetricText(config.likes, '마음에 들어요', textColor, subTextColor),
                      const SizedBox(width: 14),
                      _buildMetricText(config.bookmarks, '북마크', textColor, subTextColor),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(color: borderColor, height: 1),
                  const SizedBox(height: 12),

                  // 하단 인터랙션 아이콘 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(CupertinoIcons.chat_bubble, size: 18, color: subTextColor),
                      Icon(CupertinoIcons.arrow_2_squarepath, size: 18, color: subTextColor),
                      Icon(CupertinoIcons.heart, size: 18, color: subTextColor),
                      Icon(CupertinoIcons.bookmark, size: 18, color: subTextColor),
                      Icon(CupertinoIcons.share, size: 18, color: subTextColor),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(color: borderColor, height: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricText(String value, String label, Color textColor, Color subTextColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: subTextColor, fontSize: 12)),
      ],
    );
  }
}
