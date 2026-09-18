import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/blind_model.dart';
import 'blind_company_badge.dart';

class BlindCommentTile extends StatelessWidget {
  final BlindCommentItem comment;
  final ValueChanged<String>? onLike;
  final ValueChanged<BlindCommentItem>? onReply;

  const BlindCommentTile({
    super.key,
    required this.comment,
    this.onLike,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSingleComment(comment, isReply: false),
        if (comment.replies.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: Color(0xFFE9ECEF), width: 1.5)),
              ),
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                children: comment.replies
                    .map((reply) => _buildSingleComment(reply, isReply: true))
                    .toList(),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSingleComment(BlindCommentItem item, {required bool isReply}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: BlindCompanyBadge(
                  company: item.authorCompany,
                  maskedId: item.authorMaskedId,
                  timeAgo: item.timeAgo,
                  isAuthor: item.isAuthor,
                  fontSize: 12,
                ),
              ),
              InkWell(
                onTap: () => onLike?.call(item.id),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    children: [
                      Icon(
                        item.isLiked ? CupertinoIcons.hand_thumbsup_fill : CupertinoIcons.hand_thumbsup,
                        size: 13,
                        color: item.isLiked ? const Color(0xFFDA3238) : const Color(0xFF9EA3AA),
                      ),
                      if (item.likeCount > 0) ...[
                        const SizedBox(width: 3),
                        Text(
                          '${item.likeCount}',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: item.isLiked ? const Color(0xFFDA3238) : const Color(0xFF9EA3AA),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (!isReply) ...[
                const SizedBox(width: 4),
                InkWell(
                  onTap: () => onReply?.call(item),
                  borderRadius: BorderRadius.circular(4),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      '대댓글',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF8A8F98),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.content,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.45,
              color: Color(0xFF2B2D31),
            ),
          ),
        ],
      ),
    );
  }
}
