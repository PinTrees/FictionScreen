import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/blind_model.dart';

class BlindPollWidget extends StatelessWidget {
  final BlindPoll poll;
  final ValueChanged<String>? onVote;

  const BlindPollWidget({
    super.key,
    required this.poll,
    this.onVote,
  });

  @override
  Widget build(BuildContext context) {
    final total = poll.totalVotes;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFDA3238),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '투표',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  poll.title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E2024),
                  ),
                ),
              ),
              Text(
                '${_formatNumber(total)}명 참여',
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF8A8F98),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...poll.options.map((option) {
            final isSelected = poll.selectedOptionId == option.id;
            final percent = total > 0 ? (option.votes / total) : 0.0;
            final percentInt = (percent * 100).round();

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onVote?.call(option.id),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 44,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFDA3238) : const Color(0xFFE2E4E8),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        if (poll.hasVoted)
                          FractionallySizedBox(
                            widthFactor: percent.clamp(0.0, 1.0),
                            child: Container(
                              color: isSelected
                                  ? const Color(0xFFDA3238).withValues(alpha: 0.12)
                                  : const Color(0xFFEEF0F3),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Row(
                            children: [
                              if (isSelected)
                                const Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Icon(CupertinoIcons.checkmark_circle_fill, size: 16, color: Color(0xFFDA3238)),
                                ),
                              Expanded(
                                child: Text(
                                  option.text,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? const Color(0xFFDA3238) : const Color(0xFF2B2D31),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (poll.hasVoted) ...[
                                Text(
                                  '${_formatNumber(option.votes)}표',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: Color(0xFF8A8F98),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$percentInt%',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected ? const Color(0xFFDA3238) : const Color(0xFF373A40),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              poll.hasVoted ? '✓ 투표 완료 (항목 클릭 시 변경 가능)' : '항목을 터치하여 투표하세요',
              style: TextStyle(
                fontSize: 11,
                color: poll.hasVoted ? const Color(0xFFDA3238) : const Color(0xFF9EA3AA),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int val) {
    return val.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
